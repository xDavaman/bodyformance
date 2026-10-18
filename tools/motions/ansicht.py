"""Bilder der Bewegungen mit Tiefenpuffer: Haut, Bank, Hanteln, Boden, aus mehreren Richtungen.

Jedes Dreieck wird in Punkte zerlegt (so fein, dass keine Lücken bleiben) und mit Tiefe eingetragen. Das ist
einfach, schnell genug und zeigt Durchdringungen richtig (anders als das Maler-Verfahren in preview.py).
"""

from __future__ import annotations

import numpy as np
from PIL import Image, ImageDraw

SKIN = np.array([0.88, 0.74, 0.64])
BG = np.array([0.93, 0.94, 0.96])


def _view(yaw: float, pitch: float) -> np.ndarray:
    a, p = np.radians(yaw), np.radians(pitch)
    ry = np.array([[np.cos(a), 0, -np.sin(a)], [0, 1, 0], [np.sin(a), 0, np.cos(a)]])
    rx = np.array([[1, 0, 0], [0, np.cos(p), -np.sin(p)], [0, np.sin(p), np.cos(p)]])
    return rx @ ry


def _samples(v, f, step):
    """Punkte auf den Dreiecken (Ecken, Kanten, Fläche), Abstand höchstens etwa step."""
    a, b, c = v[f[:, 0]], v[f[:, 1]], v[f[:, 2]]
    edge = np.maximum.reduce([np.linalg.norm(b - a, axis=1), np.linalg.norm(c - b, axis=1),
                              np.linalg.norm(a - c, axis=1)])
    n = np.clip(np.ceil(edge / step).astype(int), 1, 40)
    pts, tri = [], []
    for k in np.unique(n):
        idx = np.where(n == k)[0]
        uv = np.array([(i / k, j / k) for i in range(k + 1) for j in range(k + 1 - i)])
        w = np.stack([1 - uv.sum(1), uv[:, 0], uv[:, 1]], 1)  # (S, 3)
        p = (w[None, :, 0, None] * a[idx, None] + w[None, :, 1, None] * b[idx, None]
             + w[None, :, 2, None] * c[idx, None])
        pts.append(p.reshape(-1, 3))
        tri.append(np.repeat(idx, len(uv)))
    return np.concatenate(pts), np.concatenate(tri)


def render(meshes, size=(360, 360), yaw=35.0, pitch=10.0, center=(0, 0.8, 0), span=2.3, floor=0.0,
           label: str = "") -> Image.Image:
    """meshes: Liste (v, f, Farbe je Dreieck oder None für Haut)."""
    W, H = size
    R = _view(yaw, pitch)
    c = np.asarray(center, float)
    scale = H / span
    px = span / H
    depth = np.full(H * W, np.inf)
    color = np.tile(BG, (H * W, 1))
    light = np.array([0.35, 0.75, 0.55])
    light /= np.linalg.norm(light)

    # Boden (Kacheln 0,5 m) über Strahlen aus jedem Pixel (orthografische Kamera)
    ys, xs = np.mgrid[0:H, 0:W]
    q = np.stack([(xs - W / 2) / scale, (H / 2 - ys) / scale, np.zeros_like(xs, float)], -1).reshape(-1, 3)
    origin = q @ R + c  # Bildebene in der Welt
    view_dir = R.T @ np.array([0, 0, -1.0])  # Blickrichtung in die Szene; Tiefe = Weg entlang des Strahls
    with np.errstate(divide="ignore", invalid="ignore"):
        t = (floor - origin[:, 1]) / view_dir[1]
    hit = origin + t[:, None] * view_dir
    inside = (np.abs(hit[:, 0]) < 2.0) & (np.abs(hit[:, 2]) < 2.0) & np.isfinite(t)
    chk = ((np.floor(hit[:, 0] / 0.5) + np.floor(hit[:, 2] / 0.5)) % 2 == 0)
    fc = np.where(chk[:, None], [0.78, 0.79, 0.81], [0.70, 0.71, 0.74])
    color[inside] = fc[inside]
    depth[inside] = t[inside]

    for v, f, col in meshes:
        pts, tri = _samples(v, f, px * 0.7)
        a, b, cc = v[f[:, 0]], v[f[:, 1]], v[f[:, 2]]
        nrm = np.cross(b - a, cc - a)
        nrm /= np.linalg.norm(nrm, axis=1, keepdims=True) + 1e-12
        shade = np.abs(nrm @ light) * 0.65 + 0.32
        base = np.tile(SKIN, (len(f), 1)) if col is None else np.clip(col * 1.6 + 0.08, 0, 1)
        tc = np.clip(base * shade[:, None], 0, 1)
        Q = (pts - c) @ R.T
        u = np.round(W / 2 + Q[:, 0] * scale).astype(int)
        w_ = np.round(H / 2 - Q[:, 1] * scale).astype(int)
        z = -Q[:, 2]
        ok = (u >= 0) & (u < W) & (w_ >= 0) & (w_ < H)
        lin = w_[ok] * W + u[ok]
        zz, tt = z[ok], tri[ok]
        order = np.argsort(-zz)  # weit hinten zuerst, vorn zuletzt (gewinnt beim Schreiben)
        lin, zz, tt = lin[order], zz[order], tt[order]
        closer = zz < depth[lin]
        lin, zz, tt = lin[closer], zz[closer], tt[closer]
        depth[lin] = zz
        color[lin] = tc[tt]
    im = Image.fromarray((color.reshape(H, W, 3) * 255).astype(np.uint8))
    if label:
        ImageDraw.Draw(im).text((5, 4), label, fill=(40, 40, 50))
    return im
