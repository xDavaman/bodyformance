"""Gebackene Bewegungen aus FitScan_Motions.bin lesen und mit Bank, Hanteln und Hilfsmitteln so aufbauen wie die App.

Damit lassen sich alle Bewegungen prüfen und ansehen, auch die, deren Schlüsselhaltungen nicht in der Bibliothek
stehen. Die Lage der Gegenstände entspricht `BodyRig.apply` (Bank am Ursprung, Klimmzugstange bei y 2,03,
Wand bei wallZ) und den Geräte-Modellen aus `tools/geraete`.
"""

from __future__ import annotations

import dataclasses
import re
import struct
from functools import lru_cache

import numpy as np

from .rig import MOTIONS, ROOT, from_quat

SWIFT = ROOT / "FitScan" / "BodyMotions.swift"
PULLBAR_Y, PULLBAR_Z = 2.03, 0.05
BENCH_TOP = 0.30


@dataclasses.dataclass
class Motion:
    name: str
    period: float
    rot: np.ndarray  # (F, J, 4) lokale Drehungen
    pos: np.ndarray  # (F, J, 3) lokale Verschiebungen (Wurzel: Welt)
    prop_pos: np.ndarray  # (F, P, 3)
    prop_rot: np.ndarray  # (F, P, 4)
    lying: bool = False
    bench: bool = False
    free: bool = False
    wall_z: float | None = None
    props: str = "none"

    @property
    def frames(self) -> int:
        return len(self.rot)

    def world(self, sk, f: int):
        loc = np.array([from_quat(q) for q in self.rot[f]])
        return sk.world(loc, self.pos[f, sk.i("root")])


def from_baked(b) -> Motion:
    """Frisch gebackene Bewegung (clip.Baked) wie eine aus der App-Datei."""
    c = b.clip
    kinds = [p.kind for p in c.props]
    return Motion(c.key, c.period, b.rot, b.pos, b.prop_pos, b.prop_rot, lying=c.lying, bench=c.bench, free=c.free,
                  wall_z=c.wall_z, props=kinds[0] if kinds else c.app_props)


def read_flags() -> dict[str, dict]:
    out = {}
    pat = re.compile(r"^        \.(\w+): Motion\(period: ([\d.]+), lying: (\w+), bench: (\w+), free: (\w+), "
                     r"wallZ: ([^,]+), yaw: [^,]+, camY: [^,]+, props: \.(\w+)\),$", re.M)
    for m in pat.finditer(SWIFT.read_text()):
        name, _, lying, bench, free, wall, props = m.groups()
        out[name] = {"lying": lying == "true", "bench": bench == "true", "free": free == "true",
                     "wall_z": None if wall == "nil" else float(wall), "props": props}
    return out


def read_motions(path=MOTIONS) -> dict[str, Motion]:
    d = path.read_bytes()
    magic, nb, nm = struct.unpack_from("<III", d, 0)
    o = 12
    flags = read_flags()
    out = {}
    for _ in range(nm):
        name = d[o:o + 24].split(b"\0")[0].decode()
        nf, period, npr = struct.unpack_from("<IfI", d, o + 24)
        o += 36
        a = np.frombuffer(d, "<i2", nf * nb * 7, o).reshape(nf, nb, 7).astype(np.float64)
        o += nf * nb * 14
        b = np.frombuffer(d, "<i2", nf * npr * 7, o).reshape(nf, npr, 7).astype(np.float64)
        o += nf * npr * 14
        out[name] = Motion(name, period, a[..., 3:] / 32767, a[..., :3] / 10000, b[..., :3] / 10000, b[..., 3:] / 32767,
                           **flags.get(name, {}))
    return out


# --------------------------------------------------------------------------- Gegenstände als Dreiecksnetze


@lru_cache(maxsize=None)
def _gear(name: str):
    """Netz (v, f, Farbe je Dreieck) eines Geräts aus tools/geraete."""
    from geraete.materialien import MATERIALIEN
    from geraete.modelle import MODELLE

    vs, fs, cs, off = [], [], [], 0
    for mat, (v, _, f) in MODELLE[name]().merged().items():
        vs.append(v)
        fs.append(f + off)
        cs.append(np.repeat(np.array(MATERIALIEN[mat]["farbe"], float)[None, :3], len(f), 0))
        off += len(v)
    return np.concatenate(vs), np.concatenate(fs), np.concatenate(cs)


def _box(size, center=(0, 0, 0)):
    h = np.asarray(size, float) / 2
    v = np.array([[x, y, z] for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)], float) * h + center
    f = np.array([[0, 1, 3], [0, 3, 2], [4, 6, 7], [4, 7, 5], [0, 4, 5], [0, 5, 1], [2, 3, 7], [2, 7, 6],
                  [0, 2, 6], [0, 6, 4], [1, 5, 7], [1, 7, 3]])
    return v, f


def _cylinder(h, r, n=24):
    a = np.linspace(0, 2 * np.pi, n, endpoint=False)
    ring = np.stack([np.cos(a) * r, np.zeros(n), np.sin(a) * r], 1)
    v = np.concatenate([ring + [0, -h / 2, 0], ring + [0, h / 2, 0], [[0, -h / 2, 0], [0, h / 2, 0]]])
    f = []
    for i in range(n):
        j = (i + 1) % n
        f += [[i, j, n + j], [i, n + j, n + i], [2 * n, j, i], [2 * n + 1, n + i, n + j]]
    return v, np.array(f)


def _sphere(r, n=12):
    v, f = [], []
    for i in range(n + 1):
        th = np.pi * i / n
        for j in range(2 * n):
            ph = np.pi * j / n
            v.append([r * np.sin(th) * np.cos(ph), r * np.cos(th), r * np.sin(th) * np.sin(ph)])
    for i in range(n):
        for j in range(2 * n):
            a, b = i * 2 * n + j, i * 2 * n + (j + 1) % (2 * n)
            f += [[a, b, b + 2 * n], [a, b + 2 * n, a + 2 * n]]
    return np.array(v), np.array(f)


def _solid(vf, color):
    v, f = vf
    return v, f, np.repeat(np.array(color, float)[None], len(f), 0)


AIDS = {"roller": lambda: _solid(_cylinder(0.90, 0.075), (0.20, 0.45, 0.85)),
        "ball": lambda: _solid(_sphere(0.035), (0.85, 0.25, 0.2)),
        "post": lambda: _solid(_box((0.07, 2.0, 0.09)), (0.62, 0.48, 0.32)),
        "step": lambda: _solid(_box((0.15, 0.80, 0.32)), (0.62, 0.48, 0.32))}


def _place(mesh, rot=np.eye(3), pos=(0, 0, 0)):
    v, f, c = mesh
    return v @ np.asarray(rot).T + np.asarray(pos, float), f, c


def scene_meshes(mo: Motion, f: int) -> list:
    """Gegenstände der Szene in Bild f als Liste (v, f, Farben)."""
    out = []
    if mo.bench:
        out.append(_gear("Bank"))
        out.append(_place(_gear("BankLehne"), pos=(0, BENCH_TOP - 0.035, -0.02)))
    if mo.props == "pullbar":
        rz = np.array([[0, -1, 0], [1, 0, 0], [0, 0, 1]], float)
        out.append(_place(_solid(_cylinder(1.3, 0.017), (0.55, 0.55, 0.55)), rz, (0, PULLBAR_Y, PULLBAR_Z)))
    if mo.wall_z is not None:
        wz = mo.wall_z
        out.append(_solid(_box((1.8, 2.5, 0.03), (0, 1.25, wz + (0.015 if wz > 0 else -0.015))), (0.42, 0.42, 0.42)))
    for k in range(mo.prop_pos.shape[1]):
        r = from_quat(mo.prop_rot[f, k])
        p = mo.prop_pos[f, k]
        if mo.props == "dumbbell":
            out.append(_place(_gear("Kurzhantel"), r, p))
        elif mo.props == "barbell":
            rz = np.array([[0, -1, 0], [1, 0, 0], [0, 0, 1]], float)
            out.append(_place(_gear("Langhantel"), r @ rz, p))
        elif mo.props in AIDS:
            out.append(_place(AIDS[mo.props](), r, p))
    return out
