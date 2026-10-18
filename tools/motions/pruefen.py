"""Prüft alle gebackenen Bewegungen auf unnatürliche Stellen und schreibt Bildreihen dazu.

Geprüft wird, was man in der App sofort sieht:
    boden      Körper sinkt in den Boden ein bzw. schwebt (keine Berührung, obwohl nichts trägt)
    fuesse     Füße stehen nicht auf dem Boden, obwohl sie es sollten (Stand, Bank: Füße fest am Boden)
    rutschen   ein Fuß, der am Boden steht, rutscht hin und her
    bank       Körper liegt nicht auf der Bank auf (Spalt) oder steckt im Polster
    hantel     Hantel sitzt nicht in der Hand, steckt im Körper, in der Bank oder im Boden
    durch      Arme oder Beine stecken im Rumpf, im Kopf oder im anderen Bein
    gelenk     Knie oder Ellbogen überstreckt bzw. falsch herum gebeugt

Die Grenzwerte sind bewusst großzügig: gemeldet wird, was als Fehler sichtbar ist.
"""

from __future__ import annotations

import dataclasses
import json
import math
from pathlib import Path

import numpy as np
from PIL import Image

from .rig import Skeleton, from_quat, normalize, skeleton
from .szene import BENCH_TOP, Motion, read_motions, scene_meshes

# Polster der Bank (Sitz + Lehne flach): Breite und Länge in z
BENCH_HALF_X = 0.14
BENCH_Z = (-0.82, 0.41)

SEGMENTS = {  # Name: (Gelenk a, Gelenk b)
    "becken": ("root", "spine1"), "bauch": ("spine1", "spine2"), "brust": ("spine2", "spine3"),
    "hals": ("neck1", "head"),
}
for _s in "LR":
    SEGMENTS.update({f"oberarm{_s}": (f"ua{_s}", f"fa{_s}"), f"unterarm{_s}": (f"fa{_s}", f"ha{_s}"),
                     f"hand{_s}": (f"ha{_s}", f"mid2{_s}"), f"oberschenkel{_s}": (f"th{_s}", f"sh{_s}"),
                     f"schienbein{_s}": (f"sh{_s}", f"ft{_s}"), f"fuss{_s}": (f"ft{_s}", f"toe{_s}")})
RUMPF = ("becken", "bauch", "brust", "hals", "kopf")


def _pairs():
    out = []
    for s in "LR":
        o = "R" if s == "L" else "L"
        for b in ("brust", "kopf"):
            out.append((f"unterarm{s}", b))
        out.append((f"hand{s}", "kopf"))
        out.append((f"oberarm{s}", "kopf"))
        # Hände berühren sich gewollt (Gebet, Handtuch, Hantel mit beiden Händen); nur Arme gegeneinander prüfen
        for a in (f"oberarm{s}", f"unterarm{s}"):
            for b in (f"oberarm{o}", f"unterarm{o}"):
                if s == "L":
                    out.append((a, b))
            for b in (f"oberschenkel{s}", f"schienbein{s}", f"oberschenkel{o}", f"schienbein{o}"):
                if not a.startswith("hand"):  # Hand auf Knie oder Oberschenkel ist gewollt
                    out.append((a, b))
        if s == "L":
            for a in (f"oberschenkel{s}", f"schienbein{s}", f"fuss{s}"):
                for b in (f"oberschenkel{o}", f"schienbein{o}", f"fuss{o}"):
                    out.append((a, b))
        for b in ("brust", "kopf"):
            out.append((f"schienbein{s}", b))
            out.append((f"fuss{s}", b))
    return out


PAIRS = _pairs()


def _seg_dist(p0, p1, q0, q1) -> float:
    """Kleinster Abstand zweier Strecken."""
    d1, d2, r = p1 - p0, q1 - q0, p0 - q0
    a, e, f = d1 @ d1, d2 @ d2, d2 @ r
    c, b = d1 @ r, d1 @ d2
    den = a * e - b * b
    s = np.clip((b * f - c * e) / den, 0, 1) if den > 1e-12 else 0.0
    t = (b * s + f) / e if e > 1e-12 else 0.0
    if t < 0:
        t, s = 0.0, np.clip(-c / a, 0, 1)
    elif t > 1:
        t, s = 1.0, np.clip((b - c) / a, 0, 1)
    return float(np.linalg.norm((p0 + d1 * s) - (q0 + d2 * t)))


class Koerper:
    """Kapseln je Knochen (Radius aus der Haut) und Haut-Gruppen für Boden und Bank."""

    def __init__(self, sk: Skeleton):
        self.sk = sk
        main = sk.ji[np.arange(len(sk.ji)), sk.jw.argmax(1)]
        self.main = main
        self.radius = {}
        for name, (a, b) in SEGMENTS.items():
            ia = sk.i(a)
            idx = np.isin(main, [ia] + ([sk.i("neck2")] if name == "hals" else []))
            p0, p1 = sk.pos(a), sk.pos(b)
            d = self._dist_pts(sk.vertices[idx], p0, p1)
            q = 35 if name in RUMPF else 50
            self.radius[name] = float(np.percentile(d, q)) if len(d) else 0.04
        hv = sk.vertices[main == sk.i("head")]
        self.head_top = float(hv[:, 1].max() - sk.pos("head")[1])
        self.radius["kopf"] = 0.085
        foot = [sk.i(n) for n in ("ftL", "toeL", "ftR", "toeR")]
        self.foot = {s: np.isin(main, [sk.i(f"ft{s}"), sk.i(f"toe{s}")]) for s in "LR"}
        self.foot_any = np.isin(main, foot)
        torso = [sk.i(n) for n in ("root", "spine1", "spine2", "spine3", "clavL", "clavR")]
        self.torso = np.isin(main, torso)
        self.back = self.torso & (sk.vertices[:, 2] < sk.vertices[self.torso][:, 2].mean())

    @staticmethod
    def _dist_pts(P, a, b):
        ab = b - a
        t = np.clip(((P - a) @ ab) / (ab @ ab), 0, 1)
        return np.linalg.norm(P - (a + t[:, None] * ab), axis=1)

    def segments(self, wr, wp):
        sk = self.sk
        out = {n: (wp[sk.i(a)], wp[sk.i(b)]) for n, (a, b) in SEGMENTS.items()}
        h = wp[sk.i("head")]
        top = wr[sk.i("head")] @ np.array([0.0, self.head_top - 0.09, 0.0])
        out["kopf"] = (h + top * 0.3, h + top)
        return out


@dataclasses.dataclass
class Befund:
    name: str
    werte: dict
    fehler: list


def _contacts(mask: np.ndarray) -> list[tuple[int, int]]:
    """Zusammenhängende Bereiche (zyklisch) mit mask == True als (start, ende)-Listen."""
    n = len(mask)
    if mask.all():
        return [(0, n)]
    out, k = [], 0
    start = int(np.argmin(mask))  # bei einem False beginnen, damit Bereiche nicht über das Ende reißen
    idx = [(start + i) % n for i in range(n)]
    while k < n:
        if mask[idx[k]]:
            j = k
            while j < n and mask[idx[j]]:
                j += 1
            out.append([idx[i] for i in range(k, j)])
            k = j
        else:
            k += 1
    return out


def analyse(sk: Skeleton, kp: Koerper, mo: Motion, stride: int | None = None) -> Befund:
    nf = mo.frames
    stride = stride or max(1, nf // 60)
    frames = list(range(0, nf, stride))
    low, foot_low, foot_pos = [], {s: [] for s in "LR"}, {s: [] for s in "LR"}
    bench_gap, bench_pen = [], []
    hand_err, prop_in_body, prop_low, prop_bench = [], [], [], []
    durch = {}
    knee, elbow = [], []
    for f in frames:
        wr, wp = mo.world(sk, f)
        V = sk.skin(wr, wp)
        low.append(V[:, 1].min())
        for s in "LR":
            fv = V[kp.foot[s]]
            foot_low[s].append(fv[:, 1].min())
            foot_pos[s].append(wp[sk.i(f"ft{s}")].copy())
        if mo.bench:
            on = (np.abs(V[:, 0]) < BENCH_HALF_X) & (V[:, 2] > BENCH_Z[0]) & (V[:, 2] < BENCH_Z[1])
            pad = on & (V[:, 1] < BENCH_TOP) & (V[:, 1] > BENCH_TOP - 0.20)
            bench_pen.append(float((BENCH_TOP - V[pad, 1]).max()) if pad.any() else 0.0)
            tb = on & kp.torso
            bench_gap.append(float(V[tb, 1].min() - BENCH_TOP) if tb.any() else 1.0)
        seg = kp.segments(wr, wp)
        for a, b in PAIRS:
            d = _seg_dist(*seg[a], *seg[b])
            depth = kp.radius[a] + kp.radius[b] - d
            if depth > durch.get((a, b), (-1, 0))[0]:
                durch[(a, b)] = (depth, f)
        # Gelenke: Beugung im Knie nach hinten, im Ellbogen nach vorn (Winkel zwischen den Gliedern)
        for s in "LR":
            th, sh, ft = wp[sk.i(f"th{s}")], wp[sk.i(f"sh{s}")], wp[sk.i(f"ft{s}")]
            fwd = wr[sk.i(f"th{s}")] @ np.array([0, 0, 1.0])
            bend = np.cross(normalize(sh - th), normalize(ft - sh))
            lat = wr[sk.i(f"th{s}")] @ np.array([1.0, 0, 0])
            ang = math.degrees(math.asin(np.clip(np.linalg.norm(bend), 0, 1)))
            knee.append(-ang if bend @ lat < -0.05 and (ft - sh) @ fwd > 0.02 else ang)
            ua, fa, ha = wp[sk.i(f"ua{s}")], wp[sk.i(f"fa{s}")], wp[sk.i(f"ha{s}")]
            elbow.append(float(np.degrees(np.arccos(np.clip(normalize(fa - ua) @ normalize(ha - fa), -1, 1)))))
        if mo.props in ("dumbbell", "barbell") and mo.prop_pos.shape[1]:
            hands = [wp[sk.i(f"ha{s}")] * 0.45 + wp[sk.i(f"mid1{s}")] * 0.55 for s in "LR"]
            for k in range(mo.prop_pos.shape[1]):
                p = mo.prop_pos[f, k]
                if mo.props == "dumbbell":
                    hand_err.append(min(np.linalg.norm(h - p) for h in hands))
                    prop_low.append(p[1] - 0.075)
                    inside = max(kp.radius[n] + 0.04 - _seg_dist(p, p, *seg[n]) for n in ("bauch", "brust", "kopf"))
                    prop_in_body.append(inside)
                    if mo.bench:
                        if abs(p[0]) < BENCH_HALF_X + 0.06 and BENCH_Z[0] < p[2] < BENCH_Z[1]:
                            prop_bench.append(BENCH_TOP + 0.07 - p[1])
                else:
                    ax = from_quat(mo.prop_rot[f, k]) @ np.array([0, 1.0, 0])
                    a0, a1 = p - ax * 0.6, p + ax * 0.6
                    hand_err.append(max(kp._dist_pts(h[None], a0, a1)[0] for h in hands))
                    prop_low.append(p[1] - 0.225)
                    inside = max(kp.radius[n] + 0.015 - _seg_dist(a0, a1, *seg[n])
                                 for n in ("bauch", "brust", "hals", "kopf"))
                    prop_in_body.append(inside)
    low = np.array(low)
    fehler = []
    w = {"bilder": len(frames)}
    support = mo.props in ("pullbar", "roller", "step", "ball")
    w["boden_tief_cm"] = round(float(-low.min()) * 100, 1)
    w["boden_hoch_cm"] = round(float(low.min()) * 100, 1)
    if low.min() < -0.015:
        fehler.append(f"boden: sinkt bis {-low.min() * 100:.0f} cm in den Boden")
    # Sprünge (Seilspringen, Laufen) dürfen kurz abheben; gemeldet wird nur, wenn nie etwas den Boden berührt
    if not support and not mo.bench and low.min() > 0.03:
        fehler.append(f"boden: schwebt durchgehend ({low.min() * 100:.0f} cm über dem Boden)")
    for s in "LR":
        fl = np.array(foot_low[s])
        fp = np.array(foot_pos[s])
        w[f"fuss{s}_tief_cm"] = round(float(fl.min()) * 100, 1)
        if mo.bench and fl.min() > 0.03:
            seite = "linker" if s == "L" else "rechter"
            fehler.append(f"fuesse: {seite} Fuß nie am Boden (Bank, mind. {fl.min() * 100:.0f} cm)")
        contact = fl < 0.015
        worst = 0.0
        for run in _contacts(contact):
            if len(run) < 3:
                continue
            pts = fp[run][:, [0, 2]]
            worst = max(worst, float(np.linalg.norm(pts - pts.mean(0), axis=1).max()))
        w[f"rutschen{s}_cm"] = round(worst * 100, 1)
        if worst > 0.05:
            fehler.append(f"rutschen: {'linker' if s == 'L' else 'rechter'} Fuß rutscht {worst * 100:.0f} cm am Boden")
    if mo.bench:
        gap, pen = np.array(bench_gap), np.array(bench_pen)
        w["bank_spalt_cm"] = round(float(gap.min()) * 100, 1)
        w["bank_spalt_max_cm"] = round(float(gap.max()) * 100, 1)
        w["bank_tief_cm"] = round(float(pen.max()) * 100, 1)
        if mo.lying and gap.max() > 0.025:
            fehler.append(f"bank: Rücken schwebt bis {gap.max() * 100:.0f} cm über dem Polster")
        if pen.max() > 0.03:
            fehler.append(f"bank: steckt bis {pen.max() * 100:.0f} cm im Polster")
    if hand_err:
        he = np.array(hand_err)
        w["hantel_hand_cm"] = round(float(he.max()) * 100, 1)
        if he.max() > 0.07:
            fehler.append(f"hantel: bis {he.max() * 100:.0f} cm neben der Hand")
        pib = np.array(prop_in_body)
        if pib.max() > 0.02:
            fehler.append(f"hantel: steckt bis {pib.max() * 100:.0f} cm im Körper")
        pl = np.array(prop_low)
        if pl.min() < -0.01:
            fehler.append(f"hantel: steckt bis {-pl.min() * 100:.0f} cm im Boden")
        if prop_bench and max(prop_bench) > 0.02:
            fehler.append(f"hantel: steckt bis {max(prop_bench) * 100:.0f} cm in der Bank")
    deep = sorted(((d, a, b, f) for (a, b), (d, f) in durch.items() if d > 0.06), reverse=True)
    w["durch"] = [(a, b, round(d * 100, 1), f) for d, a, b, f in deep[:6]]
    for d, a, b, f in deep[:3]:
        fehler.append(f"durch: {a} steckt {d * 100:.0f} cm in {b} (Bild {f})")
    kn = np.array(knee)
    w["knie_min_grad"] = round(float(kn.min()), 1)
    if kn.min() < -8:
        fehler.append(f"gelenk: Knie {-kn.min():.0f}° falsch herum gebeugt")
    return Befund(mo.name, w, fehler)


def bildreihe(sk: Skeleton, mo: Motion, frames: int = 6, size: int = 240, path: Path | None = None) -> Image.Image:
    from .ansicht import render

    nf = mo.frames
    idx = [int(k * nf / frames) for k in range(frames)]
    worlds = [mo.world(sk, f) for f in idx]
    skins = [sk.skin(wr, wp) for wr, wp in worlds]
    allv = np.concatenate([v[::50] for v in skins])
    lo, hi = allv.min(0), allv.max(0)
    if mo.bench:
        lo, hi = np.minimum(lo, [-0.3, 0, -0.85]), np.maximum(hi, [0.3, 0.3, 0.6])
    lo[1] = min(lo[1], 0.0)
    center = (lo + hi) / 2
    span = max(1.2, float((hi - lo).max()) * 1.15)
    yaws = (90.0, 30.0) if mo.lying or mo.bench else (90.0, 25.0)
    im = Image.new("RGB", (size * frames, size * len(yaws)))
    for r, yaw in enumerate(yaws):
        for c, (f, V) in enumerate(zip(idx, skins)):
            meshes = [(V, sk.faces, None)] + scene_meshes(mo, f)
            tile = render(meshes, size=(size, size), yaw=yaw, pitch=12.0 if r else 4.0, center=center, span=span,
                          label=f"{mo.name} {f}/{nf}")
            im.paste(tile, (c * size, r * size))
    if path:
        im.save(path)
    return im


def main(namen: list[str], ziel: Path | None, bilder: bool) -> list[Befund]:
    sk = skeleton()
    kp = Koerper(sk)
    alle = read_motions()
    chosen = [m for n, m in alle.items() if not namen or n in namen]
    out = []
    if ziel:
        ziel.mkdir(parents=True, exist_ok=True)
    for mo in chosen:
        b = analyse(sk, kp, mo)
        out.append(b)
        print(f"{mo.name:18s} {'OK' if not b.fehler else '; '.join(b.fehler)}", flush=True)
        if ziel and bilder:
            bildreihe(sk, mo, path=ziel / f"{mo.name}.png")
    if ziel:
        rows = [dataclasses.asdict(b) for b in out]
        (ziel / "befund.json").write_text(json.dumps(rows, ensure_ascii=False, indent=1))
    return out
