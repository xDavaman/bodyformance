"""Bewegungen aus Schlüsselhaltungen: weich überblenden, lösen, auf den Boden stellen, als Bilder ausgeben.

Zwischen den Schlüsselhaltungen wird jeder Kanal monoton kubisch interpoliert (PCHIP, schließt die Schleife):
keine Überschwinger, kein Ruckeln, Pausen entstehen durch zwei gleiche Haltungen hintereinander.
"""

from __future__ import annotations

import dataclasses
from collections.abc import Callable

import numpy as np

from .pose import Rig
from .rig import from_quat, to_quat

FPS = 30


@dataclasses.dataclass
class Prop:
    """Gegenstand in der Szene (z. B. Faszienrolle), Lage je Bild aus der gelösten Haltung."""

    kind: str  # "roller", "ball", "dumbbell", "barbell"
    place: Callable | None = None  # (Welt: name->xyz, Haltung) -> (Position, 3x3-Drehung; lokal y = Achse)
    # Hantel in der Hand: "L"/"R" (Kurzhantel) oder "LR" (Langhantel zwischen beiden Händen). Die Lage folgt dann
    # der Hand wie in der App (gleicher Griffpunkt wie die alten Kurzhantel-Bewegungen), place entfällt.
    hand: str | None = None


@dataclasses.dataclass
class Clip:
    key: str  # BodyMotion-Name in der App
    title: str
    keys: list  # [(Zeit in s, Haltung)], die Schleife schließt bei period wieder mit der ersten Haltung
    period: float
    space: dict = dataclasses.field(default_factory=dict)
    ground: bool = True
    props: list = dataclasses.field(default_factory=list)
    # Darstellung in der App (BodyRig.library)
    lying: bool = False
    bench: bool = False
    free: bool = True
    wall_z: float | None = None
    yaw: float = 0.9
    cam_y: float = 0.8
    app_props: str = "none"
    # Bodenhöhe für die Stellung (z. B. Stufe unter den Füßen)
    floor: float = 0.0
    # Becken je Bild so verschieben, dass Hände und Füße ihre Ziele in der Welt erreichen
    fit_root: bool = True
    # Rumpf liegt auf einer Fläche (Hantelbank): Höhe der Oberkante und Grundriss (x halb, z von, z bis). Das Becken
    # wird je Bild so gehoben oder gesenkt, dass der Rücken genau aufliegt; Füße bleiben über die IK am Boden.
    rest: tuple | None = None
    # Schritte: ein Fuß, der sich zwischen zwei Schlüsseln am Boden versetzt, wird in einem Bogen so hoch gehoben
    # (Meter), statt über den Boden zu rutschen
    step_lift: float = 0.0
    # Schlüssel beschreiben nur die linke Seite in der ersten Hälfte der Periode; die zweite Hälfte ist das
    # Spiegelbild (rechte Seite). So entsteht jede einseitige Übung ohne doppelte Beschreibung.
    mirror_half: bool = False
    # Lebendigkeit: Atmung (Brustkorb und Schultern heben sich leicht) und im Stand ein leichtes Pendeln des
    # Gewichts, damit die Figur auch in Haltephasen nicht wie eine Statue wirkt. 0 schaltet es ab.
    alive: float = 1.0

    @property
    def key_period(self) -> float:
        return self.period / 2 if self.mirror_half else self.period


def _pchip_slopes(x: np.ndarray, y: np.ndarray) -> np.ndarray:
    h = np.diff(x)
    d = np.diff(y) / h
    m = np.zeros_like(y)
    for k in range(1, len(y) - 1):
        if d[k - 1] * d[k] <= 0:
            m[k] = 0.0
        else:
            w1 = 2 * h[k] + h[k - 1]
            w2 = h[k] + 2 * h[k - 1]
            m[k] = (w1 + w2) / (w1 / d[k - 1] + w2 / d[k])
    return m


def cyclic_pchip(times: np.ndarray, values: np.ndarray, period: float, t: np.ndarray) -> np.ndarray:
    """Periodische, monotone kubische Interpolation einer Wertereihe (Schlüssel bei times)."""
    n = len(times)
    if n == 1:
        return np.repeat(values[:1], len(t), 0)
    # zwei Schlüssel auf jeder Seite anhängen, damit die Steigungen am Rand stimmen
    xs = np.concatenate([times[-2:] - period, times, times[:2] + period, [times[0] + 2 * period]])
    ys = np.concatenate([values[-2:], values, values[:2], values[:1]])
    out = np.zeros((len(t),) + values.shape[1:])
    flat_y = ys.reshape(len(ys), -1)
    res = np.zeros((len(t), flat_y.shape[1]))
    for c in range(flat_y.shape[1]):
        y = flat_y[:, c]
        m = _pchip_slopes(xs, y)
        idx = np.clip(np.searchsorted(xs, t, side="right") - 1, 0, len(xs) - 2)
        x0, x1 = xs[idx], xs[idx + 1]
        hseg = x1 - x0
        s = (t - x0) / hseg
        h00 = 2 * s ** 3 - 3 * s ** 2 + 1
        h10 = s ** 3 - 2 * s ** 2 + s
        h01 = -2 * s ** 3 + 3 * s ** 2
        h11 = s ** 3 - s ** 2
        res[:, c] = h00 * y[idx] + h10 * hseg * m[idx] + h01 * y[idx + 1] + h11 * hseg * m[idx + 1]
    return res.reshape(out.shape)


def check(clip: Clip) -> None:
    ts = [t for t, _ in clip.keys]
    if any(b <= a for a, b in zip(ts, ts[1:])) or ts[-1] >= clip.key_period:
        raise ValueError(f"{clip.key}: Schlüsselzeiten {ts} passen nicht in die Periode {clip.key_period}")


def complete_keys(rig: Rig, keys: list) -> list:
    """Fehlende Kanäle aus der vorigen Haltung (bzw. dem lockeren Stand) übernehmen."""
    full = []
    prev = rig.neutral()
    for t, p in keys:
        cur = dict(prev)
        cur.update(p)
        full.append((float(t), cur))
        prev = cur
    return full


def sample(rig: Rig, clip: Clip, fps: float = FPS) -> tuple[list[dict], np.ndarray]:
    check(clip)
    keys = complete_keys(rig, clip.keys)
    times = np.array([t for t, _ in keys])
    period = clip.key_period
    nf = max(2, int(round(period * fps)))
    t = np.arange(nf) / nf * period
    poses = [dict() for _ in range(nf)]
    for ch in keys[0][1]:
        vals = np.array([np.atleast_1d(np.asarray(p[ch], float)) for _, p in keys])
        res = cyclic_pchip(times, vals, period, t)
        for f in range(nf):
            v = res[f]
            poses[f][ch] = float(v[0]) if v.shape == (1,) else tuple(float(x) for x in v)
    if clip.step_lift > 0:
        _lift_steps(clip, keys, period, t, poses)
    if clip.alive > 0:
        _alive(clip, period, t, poses)
    return poses, t


BREATH = 4.5  # Sekunden je Atemzug in Ruhe
SWAY = 7.0  # Sekunden je Gewichtspendeln


def _alive(clip: Clip, period: float, t: np.ndarray, poses: list[dict]) -> None:
    """Atmung und Gewichtspendeln über die interpolierten Haltungen legen (periodisch, damit die Schleife glatt
    schließt). Bei mirror_half pendelt das Gewicht in halben Schwingungen, das Spiegeln setzt sie fort."""
    a = clip.alive
    n_b = max(1, int(round(period / BREATH)))
    breath = np.sin(2 * np.pi * n_b * t / period)
    standing = clip.ground and not clip.lying and not clip.bench and clip.space.get("footL", "world") == "world"
    if clip.mirror_half:
        n_s = max(1, int(round(period / (SWAY / 2))))
        n_s += 1 - n_s % 2  # ungerade Zahl halber Schwingungen
        sway = np.sin(np.pi * n_s * t / period)
    else:
        n_s = max(1, int(round(period / SWAY)))
        sway = np.sin(2 * np.pi * n_s * t / period)
    for f, p in enumerate(poses):
        b = a * float(breath[f])
        sb, ss, st = p["spine"]
        p["spine"] = (sb - 1.2 * b, ss, st)
        nb, ns, nt = p["neck"]
        p["neck"] = (nb + 0.8 * b, ns, nt)
        for s in "LR":
            up, fwd = p[f"clav{s}"]
            p[f"clav{s}"] = (up + 1.5 * b, fwd)
        if standing:
            x, y, z = p["root"]
            w = a * float(sway[f])
            p["root"] = (x + 0.012 * w, y, z)
            yaw, pitch, roll = p["body"]
            p["body"] = (yaw, pitch, roll + 1.2 * w)
            sb, ss, st = p["spine"]
            p["spine"] = (sb, ss - 1.5 * w, st)


def _lift_steps(clip: Clip, keys: list, period: float, t: np.ndarray, poses: list[dict]) -> None:
    """Hebt Füße, die zwischen zwei Schlüsseln am Boden versetzt werden, in einem flachen Bogen an."""
    for side in "LR":
        ch = f"foot{side}"
        if clip.space.get(ch, "world") != "world":
            continue
        pts = [(tk, np.asarray(p[ch], float)) for tk, p in keys]
        pts.append((period + pts[0][0], pts[0][1]))
        for (t0, a), (t1, b) in zip(pts, pts[1:]):
            dist = float(np.linalg.norm((b - a)[[0, 2]]))
            if dist < 0.04 or max(a[1], b[1]) > clip.floor + 0.22:
                continue
            h = clip.step_lift * min(1.0, dist / 0.15)
            for f, tf in enumerate(t):
                for off in (0.0, period):
                    u = (tf + off - t0) / (t1 - t0)
                    if 0.0 < u < 1.0:
                        x, y, z = poses[f][ch]
                        poses[f][ch] = (x, y + h * float(np.sin(np.pi * u)), z)


@dataclasses.dataclass
class Baked:
    clip: Clip
    rot: np.ndarray  # (F, J, 4)
    pos: np.ndarray  # (F, J, 3)
    prop_pos: np.ndarray  # (F, P, 3)
    prop_rot: np.ndarray  # (F, P, 4)
    lift: np.ndarray  # Bodenkorrektur je Bild (m)
    world: list  # je Bild (wr, wp) nach Bodenkorrektur


def _smooth_cyclic(x: np.ndarray, sigma: float) -> np.ndarray:
    if sigma <= 0 or len(x) < 3:
        return x
    r = int(3 * sigma) + 1
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / sigma) ** 2)
    k /= k.sum()
    ext = np.concatenate([x[-r:], x, x[:r]])
    return np.convolve(ext, k, mode="same")[r:-r]


def bake(rig: Rig, clip: Clip, fps: float = FPS) -> Baked:
    sk = rig.sk
    poses, _ = sample(rig, clip, fps)
    nf = len(poses)
    locs, worlds = [], []
    lows = np.zeros(nf)
    torso = _torso_mask(sk) if clip.rest else None
    for f, p in enumerate(poses):
        if clip.fit_root:
            p = rig.fit_root(p, clip.space)
            poses[f] = p
        loc, wr, wp = rig.solve(p, clip.space)
        if clip.rest:
            p, (loc, wr, wp) = _rest_on(rig, clip, p, torso, (loc, wr, wp))
            poses[f] = p
        locs.append(loc)
        worlds.append((wr, wp))
        if clip.ground:
            lows[f] = sk.skin(wr, wp, step=7)[:, 1].min()
    lift = np.zeros(nf)
    if clip.ground:
        lift = _smooth_cyclic(clip.floor - lows, 1.5)
    rot = np.zeros((nf, len(sk), 4))
    pos = np.zeros((nf, len(sk), 3))
    props_p = np.zeros((nf, len(clip.props), 3))
    props_r = np.zeros((nf, len(clip.props), 4))
    out_world = []
    root = sk.i("root")
    for f in range(nf):
        wr, wp = worlds[f]
        wp = wp + np.array([0.0, lift[f], 0.0])
        out_world.append((wr, wp))
        for j in range(len(sk)):
            rot[f, j] = to_quat(locs[f][j])
            pos[f, j] = sk.offset[j]
        pos[f, root] = wp[root]
        named = {n: wp[i] for i, n in enumerate(sk.names)}
        for k, pr in enumerate(clip.props):
            pp, rr = hand_prop(sk, wr, wp, pr.hand) if pr.hand else pr.place(named, poses[f])
            props_p[f, k] = pp
            props_r[f, k] = to_quat(rr)
    if clip.mirror_half:
        rot, pos, props_p, props_r, lift, out_world = _mirrored(sk, rot, pos, props_p, props_r, lift, out_world)
        nf = len(rot)
    # Quaternionen ohne Vorzeichensprünge, damit die App sauber überblendet
    for f in range(1, nf):
        flip = (rot[f] * rot[f - 1]).sum(-1) < 0
        rot[f, flip] *= -1
        flipp = (props_r[f] * props_r[f - 1]).sum(-1) < 0
        props_r[f, flipp] *= -1
    return Baked(clip, rot, pos, props_p, props_r, lift, out_world)


# Griffpunkt und Hantelachse im Raum des Handgelenks (Ruhelage), gemessen an den alten Kurzhantel-Bewegungen
GRIP_OFFSET = np.array([0.002, -0.055, 0.026])
GRIP_AXIS = np.array([0.43, -0.54, -0.72])


def grip(sk, wr, wp, side: str) -> tuple[np.ndarray, np.ndarray]:
    """Griffpunkt und Richtung der Hantelachse (vom Daumen weg) einer Hand in der Welt."""
    g = 1.0 if side == "L" else -1.0
    m = np.array([g, 1.0, 1.0])
    h = sk.i(f"ha{side}")
    return wp[h] + wr[h] @ (GRIP_OFFSET * m), wr[h] @ (GRIP_AXIS * m)


def hand_prop(sk, wr, wp, hand: str) -> tuple[np.ndarray, np.ndarray]:
    from .rig import between, frame
    if hand in ("L", "R"):
        p, ax = grip(sk, wr, wp, hand)
        return p, between((0.0, 1.0, 0.0), ax)
    pl, _ = grip(sk, wr, wp, "L")
    pr, _ = grip(sk, wr, wp, "R")
    ax = pl - pr
    # Stange: lokale y = Achse, lokale x zeigt nach oben (Scheiben stehen senkrecht zur Stange, Lage egal)
    f = frame(ax, (0.0, 1.0, 0.0))
    return (pl + pr) / 2, np.stack([f[:, 1], f[:, 0], -f[:, 2]], 1)


def align_grip(rig: Rig, pose: dict, axis, space: dict | None = None, side: str = "L") -> tuple:
    """Sucht twist und wrist (beide Seiten gespiegelt), damit die Kurzhantel in der Haltung entlang axis (Welt)
    liegt. Hilfe beim Schreiben der Bibliothek, z. B. align_grip(Rig(), FLY_TOP, (0, 0, 1))."""
    t = np.asarray(axis, float) / np.linalg.norm(axis)
    best = None
    for tw in range(-90, 91, 15):
        for fl in range(-30, 31, 15):
            for dv in range(-30, 31, 15):
                p = dict(pose, twistL=tw, twistR=tw, wristL=(fl, dv), wristR=(fl, -dv))
                _, wr, wp = rig.solve(rig.fit_root(p, space), space)
                ax = grip(rig.sk, wr, wp, side)[1]
                err = min(np.linalg.norm(ax - t), np.linalg.norm(ax + t))
                if best is None or err < best[0]:
                    best = (float(err), tw, (fl, dv))
    return best[1], best[2]


def _torso_mask(sk) -> np.ndarray:
    main = sk.ji[np.arange(len(sk.ji)), sk.jw.argmax(1)]
    names = ("root", "spine1", "spine2", "spine3", "clavL", "clavR", "neck1", "neck2", "head")
    return np.isin(main, [sk.i(n) for n in names])


def _rest_on(rig: Rig, clip: Clip, p: dict, torso: np.ndarray, solved):
    """Hebt oder senkt das Becken, bis der tiefste Punkt von Rumpf und Kopf über der Fläche genau auf ihr liegt."""
    top, hx, z0, z1 = clip.rest
    sk = rig.sk
    for _ in range(3):
        _, wr, wp = solved
        V = sk.skin(wr, wp, step=5)
        sel = torso[::5] & (np.abs(V[:, 0]) < hx) & (V[:, 2] > z0) & (V[:, 2] < z1)
        if not sel.any():
            break
        gap = float(V[sel, 1].min()) - top
        if abs(gap) < 0.002:
            break
        x, y, z = p["root"]
        p = dict(p)
        p["root"] = (x, y - gap, z)
        solved = rig.solve(p, clip.space)
    return p, solved


def _mirrored(sk, rot, pos, props_p, props_r, lift, world):
    """Hängt das Spiegelbild (links ↔ rechts) der Bilder an: Gelenke tauschen die Seite, Drehungen werden an der
    Mittelebene (x = 0) gespiegelt, (x, y, z, w) → (x, -y, -z, w)."""
    swap = []
    for n in sk.names:
        if n[-1] in "LR" and (n[:-1] + ("R" if n[-1] == "L" else "L")) in sk.index:
            swap.append(sk.i(n[:-1] + ("R" if n[-1] == "L" else "L")))
        else:
            swap.append(sk.i(n))
    flip = np.array([1.0, -1.0, -1.0, 1.0])
    m_rot = rot[:, swap] * flip
    m_pos = pos[:, swap].copy()
    root = sk.i("root")
    m_pos[:, root] = pos[:, root] * np.array([-1.0, 1.0, 1.0])
    m_pp = props_p * np.array([-1.0, 1.0, 1.0])
    m_pr = props_r * flip
    m_world = []
    for f in range(len(rot)):
        loc = np.array([from_quat(q) for q in m_rot[f]])
        m_world.append(sk.world(loc, m_pos[f, root]))
    cat = np.concatenate
    return (cat([rot, m_rot]), cat([pos, m_pos]), cat([props_p, m_pp]), cat([props_r, m_pr]), cat([lift, lift]),
            world + m_world)
