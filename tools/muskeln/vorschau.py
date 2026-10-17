"""Vorschau der Muskelkarte ohne Xcode: Figur in der Ruhepose mit eingefärbten Muskeln (nicht die App).

Die Farbmischung entspricht MuscleAtlas.compose in FitScan/MuscleAtlas.swift. Gezeichnet werden die Texel der
Karte als Punkte (z-Puffer), beleuchtet mit ihrer Normale.
"""

from __future__ import annotations

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

from . import anatomie as an
from .karte import CACHE

AKTIV = np.array([0.90, 0.12, 0.10])
PASSIV = np.array([1.00, 0.80, 0.10])
HAUT = np.array([0.80, 0.80, 0.80])


def muskel_farbe(c, faser, sehne):
    """Muskelgewebe: dunkle Rillen, hellere Faserbündel, zur Sehne hin blass."""
    dunkel, hell = c * 0.32, c + (1 - c) * 0.28
    f = faser[:, None]
    m = dunkel + (hell - dunkel) * f
    blass = c + (np.array([0.97, 0.93, 0.88]) - c) * 0.75
    return m + (blass - m) * sehne[:, None]


def mischen(roh, aktiv, passiv):
    """Grundfarbe und Leuchtfarbe je Texel (wie in der App): erst der schwächere Platz, darüber der stärkere."""
    base = np.tile(HAUT, (len(roh), 1))
    glow = np.zeros((len(roh), 3))
    ida, idp = [an.ID[m] for m in aktiv], [an.ID[m] for m in passiv]
    for o in (4, 0):
        ids, w, faser, sehne = roh[:, o], roh[:, o + 1] / 255, roh[:, o + 2] / 255, roh[:, o + 3] / 255
        for farbe, liste, licht in ((PASSIV, idp, 0.4), (AKTIV, ida, 1.0)):
            m = np.isin(ids, liste) & (w > 0)
            if not m.any():
                continue
            wm = w[m][:, None]
            base[m] = base[m] * (1 - wm) + muskel_farbe(farbe, faser[m], sehne[m]) * wm
            leucht = (licht * (0.2 + 0.8 * faser[m]) * (1 - 0.9 * sehne[m]))[:, None]
            glow[m] = glow[m] * (1 - wm) + farbe[None, :] * leucht * wm
    return base, glow


def bild(aktiv, passiv, gieren: float = 0.0, groesse: int = 900, leuchten: float = 0.5, titel: str = ""):
    z = np.load(CACHE / "texel.npz")
    voll = ~np.isnan(z["pos"][..., 0])
    P, Nn, roh = z["pos"][voll].astype(float), z["nor"][voll].astype(float), z["roh"][voll]
    base, glow = mischen(roh, aktiv, passiv)
    a = np.radians(gieren)
    R = np.array([[np.cos(a), 0, np.sin(a)], [0, 1, 0], [-np.sin(a), 0, np.cos(a)]])
    Q, Nq = P @ R.T, Nn @ R.T
    sicht = Nq[:, 2] > -0.05
    hell = 0.30 + 0.62 * np.clip(Nq @ an._norm(np.array([[0.3, 0.6, 0.75]]))[0], 0, 1) \
        + 0.18 * np.clip(Nq @ an._norm(np.array([[-0.6, 0.2, 0.4]]))[0], 0, 1)
    farbe = base * hell[:, None] + glow * leuchten
    farbe = np.clip(farbe, 0, 1) ** (1 / 1.1)
    s = 2
    W = H = groesse * s
    skal = H / 1.95
    x = (W / 2 + Q[:, 0] * skal).astype(int)
    y = (H * 0.97 - Q[:, 1] * skal).astype(int)
    ok = sicht & (x >= 0) & (x < W) & (y >= 0) & (y < H)
    ordnung = np.argsort(Q[ok, 2])
    img = np.zeros((H, W, 3))
    img[:] = (0.07, 0.075, 0.09)
    xs, ys, cs = x[ok][ordnung], y[ok][ordnung], farbe[ok][ordnung]
    for dy, dx in ((0, 0), (0, 1), (1, 0), (1, 1)):
        img[np.clip(ys + dy, 0, H - 1), np.clip(xs + dx, 0, W - 1)] = cs
    im = Image.fromarray((img * 255).astype(np.uint8)).resize((groesse, groesse), Image.LANCZOS)
    im = im.filter(ImageFilter.UnsharpMask(1, 40, 2))
    if titel:
        ImageDraw.Draw(im).text((12, 10), titel, fill=(220, 220, 225))
    return im


def tafel(aktiv, passiv, name: str, groesse: int = 620):
    ims = [bild(aktiv, passiv, g, groesse) for g in (0, 180)]
    t = Image.new("RGB", (groesse * 2, groesse + 34), (18, 19, 23))
    for k, im in enumerate(ims):
        t.paste(im, (k * groesse, 34))
    ImageDraw.Draw(t).text((12, 10), f"{name}  (Vorschau aus dem Werkzeug, nicht die App)", fill=(230, 230, 235))
    return t
