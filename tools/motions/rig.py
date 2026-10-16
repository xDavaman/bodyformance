"""Skelett und Haut von FitScan_Skin.usdz: Vorwärtskinematik, Skinning, Zwei-Glied-IK.

Konvention wie in der App (RealityKit): Meter, Y oben, die Figur schaut nach +Z, linke Körperseite +X.
In der Ruhepose sind alle lokalen Drehungen die Einheit, die Achsen jedes Gelenks sind also die Weltachsen.
Eine lokale Drehung wirkt deshalb im (mitgedrehten) Achsensystem des Elternglieds, wie in FitScans „local-ref“.

Quaternionen als (x, y, z, w), Matrizen als 3x3 für Spaltenvektoren (v' = R @ v).
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
SKIN = ROOT / "FitScan" / "FitScan_Skin.usdz"
MOTIONS = ROOT / "FitScan" / "FitScan_Motions.bin"

# --------------------------------------------------------------------------- Drehungen


def axis_angle(axis, deg: float) -> np.ndarray:
    a = np.asarray(axis, float)
    n = np.linalg.norm(a)
    if n < 1e-12 or abs(deg) < 1e-12:
        return np.eye(3)
    a = a / n
    t = math.radians(deg)
    k = np.array([[0, -a[2], a[1]], [a[2], 0, -a[0]], [-a[1], a[0], 0]])
    return np.eye(3) + math.sin(t) * k + (1 - math.cos(t)) * (k @ k)


def rot_x(d): return axis_angle((1, 0, 0), d)
def rot_y(d): return axis_angle((0, 1, 0), d)
def rot_z(d): return axis_angle((0, 0, 1), d)


def normalize(v) -> np.ndarray:
    v = np.asarray(v, float)
    n = np.linalg.norm(v)
    return v / n if n > 1e-12 else v


def between(a, b) -> np.ndarray:
    """Kleinste Drehung, die Richtung a auf Richtung b dreht."""
    a, b = normalize(a), normalize(b)
    c = np.cross(a, b)
    s = np.linalg.norm(c)
    d = float(np.clip(a @ b, -1, 1))
    if s < 1e-9:
        if d > 0:
            return np.eye(3)
        perp = np.cross(a, [1, 0, 0])
        if np.linalg.norm(perp) < 1e-6:
            perp = np.cross(a, [0, 1, 0])
        return axis_angle(perp, 180)
    return axis_angle(c, math.degrees(math.atan2(s, d)))


def frame(x, y_hint) -> np.ndarray:
    """Orthonormale Basis (Spalten x, y, z) mit x = Richtung, y = Hilfsrichtung senkrecht gemacht."""
    x = normalize(x)
    y = np.asarray(y_hint, float) - x * (x @ np.asarray(y_hint, float))
    if np.linalg.norm(y) < 1e-6:
        y = np.cross(x, [0, 0, 1]) if abs(x[2]) < 0.9 else np.cross(x, [1, 0, 0])
    y = normalize(y)
    return np.stack([x, y, np.cross(x, y)], 1)


def to_quat(r: np.ndarray) -> np.ndarray:
    m = r
    t = np.trace(m)
    if t > 0:
        s = math.sqrt(t + 1.0) * 2
        q = [(m[2, 1] - m[1, 2]) / s, (m[0, 2] - m[2, 0]) / s, (m[1, 0] - m[0, 1]) / s, 0.25 * s]
    elif m[0, 0] > m[1, 1] and m[0, 0] > m[2, 2]:
        s = math.sqrt(1.0 + m[0, 0] - m[1, 1] - m[2, 2]) * 2
        q = [0.25 * s, (m[0, 1] + m[1, 0]) / s, (m[0, 2] + m[2, 0]) / s, (m[2, 1] - m[1, 2]) / s]
    elif m[1, 1] > m[2, 2]:
        s = math.sqrt(1.0 + m[1, 1] - m[0, 0] - m[2, 2]) * 2
        q = [(m[0, 1] + m[1, 0]) / s, 0.25 * s, (m[1, 2] + m[2, 1]) / s, (m[0, 2] - m[2, 0]) / s]
    else:
        s = math.sqrt(1.0 + m[2, 2] - m[0, 0] - m[1, 1]) * 2
        q = [(m[0, 2] + m[2, 0]) / s, (m[1, 2] + m[2, 1]) / s, 0.25 * s, (m[1, 0] - m[0, 1]) / s]
    q = np.array(q)
    return q / np.linalg.norm(q)


def from_quat(q) -> np.ndarray:
    x, y, z, w = normalize(q)
    return np.array([[1 - 2 * (y * y + z * z), 2 * (x * y - z * w), 2 * (x * z + y * w)],
                     [2 * (x * y + z * w), 1 - 2 * (x * x + z * z), 2 * (y * z - x * w)],
                     [2 * (x * z - y * w), 2 * (y * z + x * w), 1 - 2 * (x * x + y * y)]])


def twist_about(r: np.ndarray, axis) -> float:
    """Drehwinkel (Grad) von r um die Achse (Swing-Twist-Zerlegung)."""
    q = to_quat(r)
    a = normalize(axis)
    p = (q[:3] @ a)
    return math.degrees(2 * math.atan2(p, q[3]))


# --------------------------------------------------------------------------- Skelett


class Skeleton:
    def __init__(self, path: Path = SKIN):
        from pxr import Usd, UsdGeom, UsdSkel  # usd-core

        stage = Usd.Stage.Open(str(path))
        skel = UsdSkel.Skeleton(stage.GetPrimAtPath("/Body/Skel"))
        paths = [str(j) for j in skel.GetJointsAttr().Get()]
        self.names = [p.split("/")[-1] for p in paths]
        self.index = {n: i for i, n in enumerate(self.names)}
        self.parent = []
        for p in paths:
            par = p.rsplit("/", 1)[0] if "/" in p else None
            self.parent.append(paths.index(par) if par else -1)
        rest = np.array([np.array(m) for m in skel.GetRestTransformsAttr().Get()])  # Zeilenvektor-Konvention
        bind = np.array([np.array(m) for m in skel.GetBindTransformsAttr().Get()])
        self.offset = rest[:, 3, :3].copy()  # lokale Verschiebung zum Elternglied
        self.bind_pos = bind[:, 3, :3].copy()  # Weltlage der Gelenke in der Ruhepose
        mesh = UsdGeom.Mesh(stage.GetPrimAtPath("/Body/Mesh"))
        self.vertices = np.array(mesh.GetPointsAttr().Get(), np.float64)
        self.faces = np.array(mesh.GetFaceVertexIndicesAttr().Get()).reshape(-1, 3)
        b = UsdSkel.BindingAPI(mesh.GetPrim())
        es = b.GetJointIndicesPrimvar().GetElementSize()
        self.ji = np.array(b.GetJointIndicesAttr().Get()).reshape(-1, es)
        self.jw = np.array(b.GetJointWeightsAttr().Get(), np.float64).reshape(-1, es)

    def __len__(self):
        return len(self.names)

    def i(self, name: str) -> int:
        return self.index[name]

    def pos(self, name: str) -> np.ndarray:
        return self.bind_pos[self.index[name]]

    def world(self, local_rot: np.ndarray, root_pos: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
        """Weltdrehungen (J,3,3) und Weltpositionen (J,3) aus lokalen Drehungen."""
        n = len(self)
        wr = np.zeros((n, 3, 3))
        wp = np.zeros((n, 3))
        for j in range(n):
            p = self.parent[j]
            if p < 0:
                wr[j] = local_rot[j]
                wp[j] = root_pos
            else:
                wr[j] = wr[p] @ local_rot[j]
                wp[j] = wp[p] + wr[p] @ self.offset[j]
        return wr, wp

    def skin(self, wr: np.ndarray, wp: np.ndarray, step: int = 1) -> np.ndarray:
        """Lineares Skinning der Haut (jeden step-ten Punkt)."""
        v = self.vertices[::step]
        ji, jw = self.ji[::step], self.jw[::step]
        out = np.zeros_like(v)
        for k in range(ji.shape[1]):
            j = ji[:, k]
            local = v - self.bind_pos[j]
            out += jw[:, k:k + 1] * (np.einsum("nij,nj->ni", wr[j], local) + wp[j])
        return out


@lru_cache(maxsize=1)
def skeleton() -> Skeleton:
    return Skeleton()


# --------------------------------------------------------------------------- Zwei-Glied-IK


def two_bone(a: np.ndarray, b: np.ndarray, c: np.ndarray, target: np.ndarray, pole: np.ndarray,
             reach: float = 0.999) -> tuple[np.ndarray, np.ndarray]:
    """Neue Lage von Mittelgelenk und Endgelenk für die Kette a-b-c, Ende möglichst auf target.

    pole: Richtung, in die das Mittelgelenk (Ellbogen, Knie) zeigen soll.
    """
    l1 = np.linalg.norm(b - a)
    l2 = np.linalg.norm(c - b)
    d_vec = target - a
    d = np.linalg.norm(d_vec)
    d = float(np.clip(d, abs(l1 - l2) + 1e-4, (l1 + l2) * reach))
    dirv = normalize(d_vec)
    side = np.asarray(pole, float) - dirv * (dirv @ np.asarray(pole, float))
    if np.linalg.norm(side) < 1e-6:
        side = np.cross(dirv, [1, 0, 0])
    side = normalize(side)
    x = (l1 * l1 - l2 * l2 + d * d) / (2 * d)
    h = math.sqrt(max(l1 * l1 - x * x, 0.0))
    mid = a + dirv * x + side * h
    end = a + dirv * d
    return mid, end
