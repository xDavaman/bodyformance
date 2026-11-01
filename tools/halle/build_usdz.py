"""Baut FitScan/Gym_Halle.usdz aus dem Blender-Export der Boxhalle (export_app_halle.py).

python3 tools/halle/build_usdz.py <app_export-Ordner> <tex-Ordner> [Ziel.usdz]

- Koordinaten: Blender (Meter, Z oben) -> RealityKit (Y oben); Ursprung = freier Platz in der Gerätezone,
  Figur schaut nach +Z (in Blender -Y). Hallenboden bei 0, Gummimatten auf 4 mm abgeflacht.
- Poly-Haven-Materialien bekommen Würfel-UVs (wie die Box-Projektion in Blender); Farbtöne werden in die
  Texturen gebacken (UsdPreviewSurface kennt keinen Hue/Saturation-Knoten).
"""
import json
import re
import sys
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image
from pxr import Gf, Sdf, Usd, UsdGeom, UsdShade, UsdUtils, Vt

SRC = Path(sys.argv[1])
TEX = Path(sys.argv[2])
DST = Path(sys.argv[3]) if len(sys.argv) > 3 else Path(__file__).resolve().parents[2] / "FitScan" / "Gym_Halle.usdz"
FLOOR_DROP = 0.0
MAT_TOP = 0.004      # Gummimatten flach (4 mm), damit Figur und App-Geräte bei y = 0 weder schweben noch einsinken

meta = json.loads((SRC / "materials.json").read_text())
RX, RY = meta["origin"]
data = np.load(SRC / "halle.npz")

# Bibliotheksmaterialien ohne brauchbare Farbe (Texturen steckten im GLB)
FIX = {
    "aluminium": dict(color=[0.62, 0.62, 0.64], rough=0.3, metal=1.0),
    "leather_black": dict(color=[0.02, 0.02, 0.022], rough=0.5, metal=0.0),
    "Metal_Corrogated_Shiny_3": dict(color=[0.55, 0.55, 0.57], rough=0.35, metal=1.0),
    "Metal_Steel_Textured": dict(color=[0.5, 0.5, 0.52], rough=0.45, metal=1.0),
    "Metal_Seamed": dict(color=[0.5, 0.5, 0.52], rough=0.45, metal=1.0),
    "real_ryder": dict(color=[0.03, 0.03, 0.035], rough=0.5, metal=0.4),
    "material": dict(color=[0.03, 0.03, 0.035], rough=0.5, metal=0.4),
    "_default": dict(color=[0.3, 0.3, 0.3], rough=0.6, metal=0.0),
}


def ident(name):
    s = name.replace("ä", "ae").replace("ö", "oe").replace("ü", "ue").replace("Ä", "Ae").replace("Ö", "Oe").replace("Ü", "Ue").replace("ß", "ss")
    s = re.sub(r"[^A-Za-z0-9_]", "_", s)
    return ("M_" + s) if not s[0].isalpha() else s


def base(name):
    return re.sub(r"\.\d{3}$", "", name)


def to_srgb(x):
    return np.where(x <= 0.0031308, x * 12.92, 1.055 * np.power(np.clip(x, 0, None), 1 / 2.4) - 0.055)


def to_lin(x):
    return np.where(x <= 0.04045, x / 12.92, np.power((x + 0.055) / 1.055, 2.4))


def bake_diffuse(src, dst, hsv, size=1024):
    """Hue/Saturation/Value wie Blenders Knoten (auf linearen Farben) in die Textur backen."""
    img = Image.open(src).convert("RGB").resize((size, size), Image.LANCZOS)
    h_shift, s_mul, v_mul = hsv
    if (h_shift, s_mul, v_mul) != (0.5, 1, 1):
        a = to_lin(np.asarray(img, np.float32) / 255.0)
        mx, mn = a.max(-1), a.min(-1)
        v = mx
        d = mx - mn
        s = np.where(mx > 0, d / np.maximum(mx, 1e-8), 0)
        r, g, b = a[..., 0], a[..., 1], a[..., 2]
        dd = np.maximum(d, 1e-8)
        h = np.where(mx == r, ((g - b) / dd) % 6, np.where(mx == g, (b - r) / dd + 2, (r - g) / dd + 4)) / 6.0
        h = np.where(d == 0, 0, h)
        h = (h + h_shift - 0.5) % 1.0
        s = np.clip(s * s_mul, 0, 1)
        v = v * v_mul
        i = np.floor(h * 6).astype(int) % 6
        f = h * 6 - np.floor(h * 6)
        p, q, t = v * (1 - s), v * (1 - s * f), v * (1 - s * (1 - f))
        out = np.zeros_like(a)
        for k, c in enumerate(((v, t, p), (q, v, p), (p, v, t), (p, q, v), (t, p, v), (v, p, q))):
            out[i == k] = np.stack(c, -1)[i == k]
        img = Image.fromarray((np.clip(to_srgb(out), 0, 1) * 255 + 0.5).astype(np.uint8))
    img.save(dst, quality=85, optimize=True)


def bake_rough(src, dst, mul, size=512):
    a = np.asarray(Image.open(src).convert("L").resize((size, size), Image.LANCZOS), np.float32) * mul
    Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).save(dst, quality=85, optimize=True)


def bake_normal(src, dst, size=512):
    Image.open(src).convert("RGB").resize((size, size), Image.LANCZOS).save(dst, quality=90, optimize=True)


def box_uv(P, N, size):
    """Würfel-Projektion je Dreieck (eine Achse pro Dreieck, damit keine Naht durchs Dreieck läuft)."""
    fn = N.reshape(-1, 3, 3).mean(1)
    ax = np.abs(fn).argmax(1).repeat(3)
    uv = np.empty((len(P), 2), np.float32)
    x, y, z = P[:, 0], P[:, 1], P[:, 2]
    m = ax == 0; uv[m] = np.stack([y[m], z[m]], 1)
    m = ax == 1; uv[m] = np.stack([x[m], z[m]], 1)
    m = ax == 2; uv[m] = np.stack([x[m], y[m]], 1)
    return uv / size


def weld(P, N, U):
    key = np.concatenate([np.round(P * 2000), np.round(N * 200), np.round(U * 2000)], 1).astype(np.int64)
    _, first, inv = np.unique(key, axis=0, return_index=True, return_inverse=True)
    return P[first], N[first], U[first], inv.reshape(-1).astype(np.int32)


# Materialien zusammenfassen (Gusseisen.001 … -> Gusseisen)
groups = {}
for name, info in meta["materials"].items():
    groups.setdefault(base(name), []).append(info)

with tempfile.TemporaryDirectory() as tmp:
    tmp = Path(tmp)
    (tmp / "tex").mkdir()
    st = Usd.Stage.CreateNew(str(tmp / "Gym_Halle.usdc"))
    UsdGeom.SetStageUpAxis(st, UsdGeom.Tokens.y)
    UsdGeom.SetStageMetersPerUnit(st, 1.0)
    root = UsdGeom.Xform.Define(st, "/Gym_Halle")
    st.SetDefaultPrim(root.GetPrim())
    total_tris = total_verts = 0
    baked = set()
    for name, infos in sorted(groups.items()):
        info = dict(infos[0])
        info.update(FIX.get(name, {}))
        P = np.concatenate([data["p%d" % i["idx"]] for i in infos]).astype(np.float64)
        N = np.concatenate([data["n%d" % i["idx"]] for i in infos]).astype(np.float64)
        U = np.concatenate([data["u%d" % i["idx"]] for i in infos]).astype(np.float64)
        if info["kind"] == "pbr":
            U = box_uv(P, N, info["size"])
        # Blender -> RealityKit
        P = np.stack([P[:, 0] - RX, P[:, 2] - FLOOR_DROP, -(P[:, 1] - RY)], 1)
        N = np.stack([N[:, 0], N[:, 2], -N[:, 1]], 1)
        if name == "Gummimatte":
            P[:, 1] = np.where(P[:, 1] > 0.001, MAT_TOP, P[:, 1])
        P, N, U, idx = weld(P, N, U)
        total_tris += len(idx) // 3
        total_verts += len(P)
        mid = ident(name)
        mp = UsdShade.Material.Define(st, f"/Gym_Halle/Materialien/{mid}")
        sh = UsdShade.Shader.Define(st, f"/Gym_Halle/Materialien/{mid}/Oberflaeche")
        sh.CreateIdAttr("UsdPreviewSurface")
        mp.CreateSurfaceOutput().ConnectToSource(sh.ConnectableAPI(), "surface")
        if info["kind"] == "pbr":
            slug = info["slug"]
            tag = ident(name).lower()
            files = {"diff": f"./tex/{tag}_diff.jpg", "rough": f"./tex/{tag}_rough.jpg", "nor": f"./tex/{slug}_nor.jpg"}
            bake_diffuse(TEX / slug / "diff.jpg", tmp / files["diff"], tuple(info["hsv"]))
            bake_rough(TEX / slug / "rough.jpg", tmp / files["rough"], info["rough_mul"])
            if slug not in baked:
                bake_normal(TEX / slug / "nor.jpg", tmp / files["nor"])
                baked.add(slug)
            reader = UsdShade.Shader.Define(st, f"/Gym_Halle/Materialien/{mid}/UV")
            reader.CreateIdAttr("UsdPrimvarReader_float2")
            reader.CreateInput("varname", Sdf.ValueTypeNames.Token).Set("st")
            uv_out = reader.CreateOutput("result", Sdf.ValueTypeNames.Float2)

            def tex(key, cs, out_name, out_type, scale=None, bias=None):
                t = UsdShade.Shader.Define(st, f"/Gym_Halle/Materialien/{mid}/{key}")
                t.CreateIdAttr("UsdUVTexture")
                t.CreateInput("file", Sdf.ValueTypeNames.Asset).Set(files[key])
                t.CreateInput("st", Sdf.ValueTypeNames.Float2).ConnectToSource(uv_out)
                t.CreateInput("wrapS", Sdf.ValueTypeNames.Token).Set("repeat")
                t.CreateInput("wrapT", Sdf.ValueTypeNames.Token).Set("repeat")
                t.CreateInput("sourceColorSpace", Sdf.ValueTypeNames.Token).Set(cs)
                if scale is not None:
                    t.CreateInput("scale", Sdf.ValueTypeNames.Float4).Set(Gf.Vec4f(*scale))
                    t.CreateInput("bias", Sdf.ValueTypeNames.Float4).Set(Gf.Vec4f(*bias))
                return t.CreateOutput(out_name, out_type)

            sh.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).ConnectToSource(tex("diff", "sRGB", "rgb", Sdf.ValueTypeNames.Float3))
            sh.CreateInput("roughness", Sdf.ValueTypeNames.Float).ConnectToSource(tex("rough", "raw", "r", Sdf.ValueTypeNames.Float))
            ns = float(info.get("nstr", 1.0))
            sh.CreateInput("normal", Sdf.ValueTypeNames.Normal3f).ConnectToSource(
                tex("nor", "raw", "rgb", Sdf.ValueTypeNames.Float3, (2 * ns, 2 * ns, 2, 1), (-ns, -ns, -1, 0)))
            sh.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(float(info.get("metal", 0)))
        else:
            col = [float(c) for c in info["color"]]
            rough, metal = float(info.get("rough", 0.5)), float(info.get("metal", 0.0))
            if info.get("glass"):           # verschmutzte Scheiben: hell und matt, wirken wie Tageslicht
                col, rough, metal = [0.78, 0.8, 0.78], 0.6, 0.0
                sh.CreateInput("emissiveColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.55, 0.58, 0.56))
            if info.get("emit"):
                e = np.clip(np.array(info["emit"]) * min(info.get("es", 1.0) / 10.0, 1.0), 0, 1)
                sh.CreateInput("emissiveColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*map(float, e)))
            sh.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*col))
            sh.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(max(rough, 0.05))
            sh.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(metal)
        mesh = UsdGeom.Mesh.Define(st, f"/Gym_Halle/{mid}_netz")
        mesh.CreatePointsAttr(Vt.Vec3fArray.FromNumpy(P.astype(np.float32)))
        mesh.CreateNormalsAttr(Vt.Vec3fArray.FromNumpy(N.astype(np.float32)))
        mesh.SetNormalsInterpolation(UsdGeom.Tokens.vertex)
        if info["kind"] != "flat":
            pv = UsdGeom.PrimvarsAPI(mesh).CreatePrimvar("st", Sdf.ValueTypeNames.TexCoord2fArray, UsdGeom.Tokens.vertex)
            pv.Set(Vt.Vec2fArray.FromNumpy(U.astype(np.float32)))
        mesh.CreateFaceVertexCountsAttr(Vt.IntArray.FromNumpy(np.full(len(idx) // 3, 3, np.int32)))
        mesh.CreateFaceVertexIndicesAttr(Vt.IntArray.FromNumpy(idx))
        mesh.CreateSubdivisionSchemeAttr(UsdGeom.Tokens.none)
        mesh.CreateDoubleSidedAttr(False)
        lo, hi = P.min(0), P.max(0)
        mesh.CreateExtentAttr(Vt.Vec3fArray([Gf.Vec3f(*map(float, lo)), Gf.Vec3f(*map(float, hi))]))
        UsdShade.MaterialBindingAPI.Apply(mesh.GetPrim()).Bind(mp)
    st.GetRootLayer().Save()
    if DST.exists():
        DST.unlink()
    UsdUtils.CreateNewUsdzPackage(Sdf.AssetPath(str(tmp / "Gym_Halle.usdc")), str(DST))
    print(f"{DST}: {DST.stat().st_size / 1e6:.1f} MB, {total_tris} Dreiecke, {total_verts} Punkte, {len(groups)} Materialien")
