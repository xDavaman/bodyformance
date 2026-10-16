"""Vorschaubilder zum Prüfen der Bewegungen ohne Xcode: Bildreihe je Bewegung (PNG).

Einfacher Software-Renderer (Maler-Algorithmus mit Pillow): Haut, Boden, Gegenstände. Reicht, um Haltung,
Bodenkontakt und Durchdringungen zu beurteilen.
"""

from __future__ import annotations

import numpy as np
from PIL import Image, ImageDraw

from .clip import Baked
from .rig import from_quat


def _view(yaw_deg: float, pitch_deg: float = 8.0) -> np.ndarray:
    a, p = np.radians(yaw_deg), np.radians(pitch_deg)
    ry = np.array([[np.cos(a), 0, -np.sin(a)], [0, 1, 0], [np.sin(a), 0, np.cos(a)]])
    rx = np.array([[1, 0, 0], [0, np.cos(p), -np.sin(p)], [0, np.sin(p), np.cos(p)]])
    return rx @ ry


def render(sk, wr, wp, props=(), size: int = 260, yaw: float = 35.0, center=(0, 0.85, 0), span: float = 2.3,
           floor: float = 0.0) -> Image.Image:
    V = sk.skin(wr, wp)
    R = _view(yaw)
    c = np.asarray(center, float)
    scale = size / span
    im = Image.new("RGB", (size, size), (28, 30, 36))
    d = ImageDraw.Draw(im)

    def proj(P):
        Q = (np.atleast_2d(P) - c) @ R.T
        return np.stack([size / 2 + Q[:, 0] * scale, size / 2 - Q[:, 1] * scale], 1), Q[:, 2]

    # Boden als Gitter
    for g in np.linspace(-1.2, 1.2, 13):
        for a, b in (((g, floor, -1.2), (g, floor, 1.2)), ((-1.2, floor, g), (1.2, floor, g))):
            xy, _ = proj(np.array([a, b]))
            d.line([tuple(xy[0]), tuple(xy[1])], fill=(55, 58, 66), width=1)
    tris = sk.faces
    P, z = proj(V)
    T = V[tris] @ R.T
    nrm = np.cross(T[:, 1] - T[:, 0], T[:, 2] - T[:, 0])
    nrm /= np.linalg.norm(nrm, axis=1, keepdims=True) + 1e-12
    depth = z[tris].mean(1)
    light = np.clip(nrm @ np.array([0.35, 0.55, 0.75]), 0, 1) * 0.75 + 0.22
    items = [(depth[t], "skin", t) for t in np.where(nrm[:, 2] > 0)[0]]
    for k, (kind, pp, rr) in enumerate(props):
        items.append((((pp - c) @ R.T)[2], "prop", k))
    items.sort(key=lambda x: x[0])
    for _, kind, t in items:
        if kind == "skin":
            col = tuple(int(v) for v in np.array([225, 196, 178]) * light[t])
            d.polygon([tuple(p) for p in P[tris[t]]], fill=col)
        else:
            pk, pp, rr = props[t]
            axis = rr @ np.array([0, 1, 0])
            half = {"roller": 0.45, "ball": 0.0, "dumbbell": 0.11, "band": 0.0, "post": 1.0, "step": 0.35}.get(pk, 0.2)
            rad = {"roller": 0.075, "ball": 0.06, "dumbbell": 0.03, "post": 0.035, "step": 0.09}.get(pk, 0.03)
            xy, _ = proj(np.array([pp - axis * half, pp + axis * half]))
            w = max(2, int(rad * 2 * scale))
            d.line([tuple(xy[0]), tuple(xy[1])], fill=(70, 120, 230), width=w)
            if half == 0:
                r = rad * scale
                d.ellipse([xy[0][0] - r, xy[0][1] - r, xy[0][0] + r, xy[0][1] + r], fill=(70, 120, 230))
    return im


def sheet(sk, baked: Baked, frames: int = 6, size: int = 220, yaws=(35.0, 100.0), at_keys: bool = False) -> Image.Image:
    nf = len(baked.world)
    if at_keys:
        idx = sorted({min(nf - 1, int(round(t / baked.clip.period * nf))) for t, _ in baked.clip.keys})
        frames = len(idx)
    else:
        idx = [int(k * nf / frames) for k in range(frames)]
    im = Image.new("RGB", (size * frames, size * len(yaws)))
    span = 2.3
    for r, yaw in enumerate(yaws):
        for c, f in enumerate(idx):
            wr, wp = baked.world[f]
            props = [(pr.kind, baked.prop_pos[f, k], from_quat(baked.prop_rot[f, k]))
                     for k, pr in enumerate(baked.clip.props)]
            center = (float(wp[0, 0]) * 0.0, 0.8, 0.0)
            tile = render(sk, wr, wp, props, size=size, yaw=yaw, center=center, span=span, floor=baked.clip.floor)
            ImageDraw.Draw(tile).text((4, 4), f"{baked.clip.key} {f}", fill=(200, 200, 200))
            im.paste(tile, (c * size, r * size))
    return im
