"""Schreibt Modelle als .usdz (für die App, RealityKit) und als .glb (für die Browser-Vorschau)."""
import json
import struct

import numpy as np

from .materialien import MATERIALIEN, linear


def usdz(model, name, path):
    """Schreibt das Modell binär (usdc) und packt es als .usdz (braucht usd-core)."""
    import tempfile
    from pathlib import Path

    from pxr import Gf, Sdf, Usd, UsdGeom, UsdShade, UsdUtils, Vt

    parts = model.merged()
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / (name + ".usdc")
        st = Usd.Stage.CreateNew(str(src))
        UsdGeom.SetStageUpAxis(st, UsdGeom.Tokens.y)
        UsdGeom.SetStageMetersPerUnit(st, 1.0)
        root = UsdGeom.Xform.Define(st, "/" + name)
        st.SetDefaultPrim(root.GetPrim())
        for mat, (v, n, f) in parts.items():
            m = MATERIALIEN[mat]
            mp = UsdShade.Material.Define(st, f"/{name}/Materialien/{mat}")
            sh = UsdShade.Shader.Define(st, f"/{name}/Materialien/{mat}/Shader")
            sh.CreateIdAttr("UsdPreviewSurface")
            sh.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*linear(m["farbe"])))
            sh.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(float(m.get("rau", 0.5)))
            sh.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(float(m.get("metall", 0.0)))
            if m.get("lack"):
                sh.CreateInput("clearcoat", Sdf.ValueTypeNames.Float).Set(float(m["lack"]))
                sh.CreateInput("clearcoatRoughness", Sdf.ValueTypeNames.Float).Set(0.1)
            if m.get("leucht"):
                sh.CreateInput("emissiveColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*linear(m["farbe"])))
            mp.CreateSurfaceOutput().ConnectToSource(sh.ConnectableAPI(), "surface")
            mesh = UsdGeom.Mesh.Define(st, f"/{name}/{mat}_netz")
            mesh.CreatePointsAttr(Vt.Vec3fArray.FromNumpy(v.astype(np.float32)))
            mesh.CreateNormalsAttr(Vt.Vec3fArray.FromNumpy(n.astype(np.float32)))
            mesh.SetNormalsInterpolation(UsdGeom.Tokens.vertex)
            mesh.CreateFaceVertexCountsAttr(Vt.IntArray.FromNumpy(np.full(len(f), 3, np.int32)))
            mesh.CreateFaceVertexIndicesAttr(Vt.IntArray.FromNumpy(f.reshape(-1).astype(np.int32)))
            mesh.CreateSubdivisionSchemeAttr(UsdGeom.Tokens.none)
            lo, hi = v.min(axis=0), v.max(axis=0)
            mesh.CreateExtentAttr(Vt.Vec3fArray([Gf.Vec3f(*map(float, lo)), Gf.Vec3f(*map(float, hi))]))
            UsdShade.MaterialBindingAPI.Apply(mesh.GetPrim()).Bind(mp)
        st.GetRootLayer().Save()
        if path.exists():
            path.unlink()
        UsdUtils.CreateNewUsdzPackage(Sdf.AssetPath(str(src)), str(path))


def glb(model, path):
    parts = model.merged()
    binbuf = bytearray()
    views, accs, prims, mats = [], [], [], []

    def add_view(arr, target):
        nonlocal binbuf
        while len(binbuf) % 4:
            binbuf += b"\0"
        off = len(binbuf)
        b = arr.tobytes()
        binbuf += b
        views.append({"buffer": 0, "byteOffset": off, "byteLength": len(b), "target": target})
        return len(views) - 1

    for mat, (v, n, f) in parts.items():
        m = MATERIALIEN[mat]
        v32, n32, f32 = v.astype(np.float32), n.astype(np.float32), f.astype(np.uint32)
        iv = add_view(v32, 34962)
        accs.append({"bufferView": iv, "componentType": 5126, "count": len(v32), "type": "VEC3",
                     "min": v32.min(axis=0).tolist(), "max": v32.max(axis=0).tolist()})
        a_pos = len(accs) - 1
        accs.append({"bufferView": add_view(n32, 34962), "componentType": 5126, "count": len(n32), "type": "VEC3"})
        a_n = len(accs) - 1
        accs.append({"bufferView": add_view(f32.reshape(-1), 34963), "componentType": 5125, "count": f32.size,
                     "type": "SCALAR"})
        a_i = len(accs) - 1
        r, g, b = linear(m["farbe"])
        mm = {"name": mat, "pbrMetallicRoughness": {"baseColorFactor": [r, g, b, 1], "metallicFactor": m.get("metall", 0.0),
                                                   "roughnessFactor": m.get("rau", 0.5)}}
        if m.get("leucht"):
            mm["emissiveFactor"] = [r, g, b]
        mats.append(mm)
        prims.append({"attributes": {"POSITION": a_pos, "NORMAL": a_n}, "indices": a_i, "material": len(mats) - 1})
    while len(binbuf) % 4:
        binbuf += b"\0"
    doc = {"asset": {"version": "2.0"}, "scene": 0, "scenes": [{"nodes": [0]}], "nodes": [{"mesh": 0}],
           "meshes": [{"primitives": prims}], "materials": mats, "accessors": accs, "bufferViews": views,
           "buffers": [{"byteLength": len(binbuf)}]}
    js = json.dumps(doc).encode()
    while len(js) % 4:
        js += b" "
    total = 12 + 8 + len(js) + 8 + len(binbuf)
    out = struct.pack("<III", 0x46546C67, 2, total) + struct.pack("<II", len(js), 0x4E4F534A) + js
    out += struct.pack("<II", len(binbuf), 0x004E4942) + bytes(binbuf)
    path.write_bytes(out)
