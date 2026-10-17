"""Muskelkarte backen: UV-Abwicklung der Figur, Muskelzugehörigkeit je Texel, Datei für die App.

Ergebnis:
- FitScan/FitScan_Skin.usdz bekommt Texturkoordinaten (primvars:st), sonst bleibt das Modell gleich.
- FitScan/FitScan_Muscles.bin: je Texel die zwei stärksten Muskeln mit Gewicht, Faserhelligkeit und Sehnenanteil.

Dateiformat FitScan_Muscles.bin (little endian):
    "BFMK", u32 Version (1), u32 N (Kantenlänge), u32 Rohlänge, danach Deflate ohne Kopf (wie Apples .zlib)
    Rohdaten: N*N Texel, Zeile 0 oben, je Texel 8 Byte: zwei Plätze (stärkster Muskel zuerst) mit je
    id (0 = Haut, sonst Index in Muscle.allCases + 1), Gewicht, Faserhelligkeit, Sehnenanteil (0…255)
In der App wird die Karte oben und gespiegelt darunter in eine Textur der Höhe 2N gelegt; die Texturkoordinate v
liegt in 0…0.5. So passt sie, egal ob RealityKit v von oben oder von unten zählt.
"""

from __future__ import annotations

import io
import struct
import tempfile
import zipfile
import zlib
from pathlib import Path

import numpy as np

from . import anatomie as an

ROOT = Path(__file__).resolve().parents[2]
SKIN = ROOT / "FitScan" / "FitScan_Skin.usdz"
KARTE = ROOT / "FitScan" / "FitScan_Muscles.bin"
CACHE = Path(__file__).resolve().parent / ".cache"
N = 1024


def lade_netz():
    """Punkte, Dreiecke, Normalen und usda-Text der Figur (ohne alte Texturkoordinaten)."""
    from pxr import Usd, UsdGeom  # usd-core

    text = zipfile.ZipFile(SKIN).read("FitScan_Skin.usda").decode()
    text = _ohne_st(text)
    with tempfile.TemporaryDirectory() as d:
        f = Path(d) / "FitScan_Skin.usda"
        f.write_text(text)
        stage = Usd.Stage.Open(str(f))
        mesh = UsdGeom.Mesh(stage.GetPrimAtPath("/Body/Mesh"))
        P = np.array(mesh.GetPointsAttr().Get(), np.float64)
        F = np.array(mesh.GetFaceVertexIndicesAttr().Get(), np.int64).reshape(-1, 3)
        Nn = np.array(mesh.GetNormalsAttr().Get(), np.float64)
    return P, F, Nn, text


def _ohne_st(text: str) -> str:
    out, skip = [], 0
    for line in text.split("\n"):
        if skip:
            skip -= 1
            continue
        if "primvars:st = " in line:
            skip = 0 if line.rstrip().endswith(")") and "interpolation" in line else 2
            continue
        if "primvars:st:indices" in line:
            continue
        out.append(line)
    return "\n".join(out)


def abwickeln(P, F):
    """UV-Abwicklung mit xatlas (zwischengespeichert). uv in 0…1, Zeile 0 = oben."""
    CACHE.mkdir(exist_ok=True)
    c = CACHE / "uv.npz"
    if c.exists():
        z = np.load(c)
        if len(z["idx"]) == len(F):
            return z["idx"], z["uv"]
    import xatlas

    atlas = xatlas.Atlas()
    atlas.add_mesh(P.astype(np.float32), F.astype(np.uint32))
    po = xatlas.PackOptions()
    po.resolution = N
    po.padding = 4
    po.bilinear = True
    atlas.generate(xatlas.ChartOptions(), po)
    vm, idx, uv = atlas[0]
    assert (vm[idx] == F).all()
    np.savez(c, idx=idx, uv=uv)
    return idx, uv


def rastern(P, F, Nn, idx, uv):
    """Je Texel Lage und Normale auf der Haut (Ruhepose); leere Texel = nan. Ränder um 4 Texel aufgefüllt."""
    pos = np.full((N, N, 3), np.nan)
    nor = np.zeros((N, N, 3))
    U = uv * N - 0.5
    for t in range(len(F)):
        a, b, c = U[idx[t]]
        x0, x1 = int(np.floor(min(a[0], b[0], c[0]))), int(np.ceil(max(a[0], b[0], c[0])))
        y0, y1 = int(np.floor(min(a[1], b[1], c[1]))), int(np.ceil(max(a[1], b[1], c[1])))
        x0, y0, x1, y1 = max(x0, 0), max(y0, 0), min(x1, N - 1), min(y1, N - 1)
        xs, ys = np.meshgrid(np.arange(x0, x1 + 1), np.arange(y0, y1 + 1))
        xs, ys = xs.ravel(), ys.ravel()
        det = (b[1] - c[1]) * (a[0] - c[0]) + (c[0] - b[0]) * (a[1] - c[1])
        if abs(det) < 1e-12:
            continue
        l1 = ((b[1] - c[1]) * (xs - c[0]) + (c[0] - b[0]) * (ys - c[1])) / det
        l2 = ((c[1] - a[1]) * (xs - c[0]) + (a[0] - c[0]) * (ys - c[1])) / det
        l3 = 1 - l1 - l2
        ok = (l1 >= -0.02) & (l2 >= -0.02) & (l3 >= -0.02)
        if not ok.any():
            continue
        L = np.stack([l1[ok], l2[ok], l3[ok]], 1)
        L = np.clip(L, 0, None)
        L /= L.sum(1, keepdims=True)
        v = F[t]
        pos[ys[ok], xs[ok]] = L @ P[v]
        nor[ys[ok], xs[ok]] = L @ Nn[v]
    nor[np.isnan(pos[..., 0])] = np.nan
    for _ in range(4):
        leer = np.isnan(pos[..., 0])
        sp, sn, k = np.zeros_like(nor), np.zeros_like(nor), np.zeros((N, N, 1))
        for dy, dx in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            q = np.roll(pos, (dy, dx), (0, 1))
            qn = np.roll(nor, (dy, dx), (0, 1))
            ok = ~np.isnan(q[..., :1]) & ~np.isnan(qn[..., :1])
            sp += np.where(ok, q, 0)
            sn += np.where(ok, np.nan_to_num(qn), 0)
            k += ok
        fill = leer & (k[..., 0] > 0)
        pos[fill] = sp[fill] / k[fill]
        nor[fill] = sn[fill] / k[fill]
    nor = np.nan_to_num(nor)
    nor /= np.linalg.norm(nor, axis=2, keepdims=True) + 1e-12
    return pos, nor


def felder(p, n):
    """Je Punkt die zwei stärksten Muskeln: (id, Gewicht, Faserhelligkeit, Sehnenanteil) je Platz."""
    region, kern = an.gewichte(p, n)
    region[:, 0] = 0
    order = np.argsort(-region, 1)
    s = an._seite(p)
    out = []
    for platz in (0, 1):
        ids = order[:, platz]
        w = region[np.arange(len(p)), ids]
        bauch = kern[np.arange(len(p)), ids]
        faser = np.full(len(p), 0.5)
        sehne = np.zeros(len(p))
        for k, name in enumerate(an.MUSKELN, 1):
            m = ids == k
            if not m.any():
                continue
            pm, sm = p[m], s[m]
            f = an.fasern(name, pm, sm)
            f *= 1 - 0.55 * an.trennlinien(name, pm, sm)
            # Wölbung: Mitte des Muskelbauchs heller, Ränder dunkler
            f *= 0.6 + 0.4 * bauch[m]
            faser[m] = f
            sehne[m] = an.sehne(name, pm, sm)
        ids = np.where(w < 0.004, 0, ids)
        out += [ids, w, np.clip(faser, 0, 1), np.clip(sehne, 0, 1)]
    return out


def backen(stueck: int = 120_000):
    P, F, Nn, text = lade_netz()
    idx, uv = abwickeln(P, F)
    r = CACHE / "raster.npz"
    if r.exists():
        z = np.load(r)
        pos, nor = z["pos"].astype(float), z["nor"].astype(float)
    else:
        pos, nor = rastern(P, F, Nn, idx, uv)
        np.savez(r, pos=pos.astype(np.float32), nor=nor.astype(np.float32))
    voll = ~np.isnan(pos[..., 0])
    p, n = pos[voll], nor[voll]
    teile = [felder(p[i:i + stueck], n[i:i + stueck]) for i in range(0, len(p), stueck)]
    cols = [np.concatenate([t[k] for t in teile]) for k in range(8)]
    roh = np.zeros((N, N, 8), np.uint8)
    for k in range(8):
        roh[voll, k] = cols[k] if k % 4 == 0 else np.round(cols[k] * 255)
    _schreibe_karte(roh)
    _schreibe_skin(text, idx, uv)
    np.savez_compressed(CACHE / "texel.npz", pos=pos.astype(np.float32), nor=nor.astype(np.float32), roh=roh)
    print(f"Muskelkarte {N}x{N}, {voll.sum()} Texel belegt → {KARTE.name} ({KARTE.stat().st_size // 1024} KB)")


def _schreibe_karte(roh: np.ndarray):
    data = roh.tobytes()
    c = zlib.compressobj(9, zlib.DEFLATED, -15)
    packed = c.compress(data) + c.flush()
    KARTE.write_bytes(b"BFMK" + struct.pack("<III", 1, N, len(data)) + packed)


def lies_karte() -> np.ndarray:
    d = KARTE.read_bytes()
    assert d[:4] == b"BFMK"
    _, n, ln = struct.unpack_from("<III", d, 4)
    raw = zlib.decompress(d[16:], -15)
    assert len(raw) == ln
    return np.frombuffer(raw, np.uint8).reshape(n, n, 8)


def _schreibe_skin(text: str, idx, uv):
    """Texturkoordinaten als faceVarying-primvar einfügen und usdz neu packen."""
    st = np.stack([uv[:, 0], uv[:, 1] * 0.5], 1)
    werte = ", ".join(f"({a:.6f},{b:.6f})" for a, b in st)
    indizes = ",".join(str(int(i)) for i in idx.ravel())
    zeilen = text.split("\n")
    k = next(i for i, z in enumerate(zeilen) if z.strip().startswith("normal3f[] normals"))
    ein = " " * (len(zeilen[k]) - len(zeilen[k].lstrip()))
    neu = [f"{ein}texCoord2f[] primvars:st = [{werte}] (", f'{ein}    interpolation = "faceVarying"', f"{ein})",
           f"{ein}int[] primvars:st:indices = [{indizes}]"]
    text = "\n".join(zeilen[:k + 1] + neu + zeilen[k + 1:])
    _usdz(text.encode())


def _usdz(usda: bytes):
    """usdz = unkomprimiertes zip, Dateidaten auf 64 Byte ausgerichtet."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED) as z:
        name = "FitScan_Skin.usda"
        kopf = 30 + len(name)
        pad = (64 - (kopf + 4) % 64) % 64
        info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
        info.extra = struct.pack("<HH", 0x1986, pad) + b"\0" * pad
        z.writestr(info, usda)
    SKIN.write_bytes(buf.getvalue())
