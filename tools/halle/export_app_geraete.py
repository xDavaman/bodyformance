"""Exportiert einzelne Geräte der Boxhalle (fertig/boxing_gym.blend) als Rohdaten für die App (Gym_Echt_<Name>.usdz).

blender -b <W>/fertig/boxing_gym.blend --python export_app_geraete.py -- <W>

Jedes Gerät landet in seinem eigenen Koordinatensystem: Mitte der Grundfläche im Ursprung, Boden bei 0,
Ausrichtung wie in der Halle ohne die Drehung, mit der es dort aufgestellt ist. Schreibt
zwischen/app_export/geraete/<Name>.npz + <Name>.json (gleiches Format wie export_app_halle.py).
"""
import bpy, os, sys, json
import numpy as np
from mathutils import Matrix

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from halle_common import base_name, mat_info, top  # noqa: E402

ARGS = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
W = ARGS[0] if ARGS else r"C:\Users\sean\Claude-Work\Boxing-Gym"
OUT = os.path.join(W, "zwischen", "app_export", "geraete")
os.makedirs(OUT, exist_ok=True)

# App-Name -> Objekt in der Halle (Wurzel einer eigenen Maschine oder Instanz aus der Geräte-Bibliothek)
ZIELE = {
    "PowerRack": "Station rack",
    "Latzug": "Station latzug",
    "Beinpresse": "Station beinpresse",
    "Crossover": "Station crossover",
    "Hantelbank": "Station hantelbank",
    "Flachbank": "Flachbank mit Ablage",
    "Schraegbank": "Schrägbank mit Ablage",
    "Multistation": "Multistation",
    "ScottCurl": "Scott-Curl",
    "Scheibenstaender": "Scheibenständer",
    "Laufband": "Laufband",
    "Spinningrad": "Spinning-Rad",
    "Crosstrainer": "Crosstrainer",
}
MAX_TRIS = 1500       # je Teil; aus der Nähe (2–4 m) sichtbar, deshalb weniger stark reduziert als die Halle

for o in bpy.data.objects:
    if o.type == "MESH" and o.data:
        t = sum(len(p.vertices) - 2 for p in o.data.polygons)
        if t > MAX_TRIS:
            md = o.modifiers.new("App-Reduktion", "DECIMATE"); md.ratio = max(MAX_TRIS / t, 0.06); md.use_collapse_triangulate = True

roots = {}
for app, obj in ZIELE.items():
    cands = sorted(o.name for o in bpy.data.objects if base_name(o.name) == obj)
    if cands:
        roots[cands[0]] = app
print("Geräte gefunden:", roots, flush=True)

def frame(o):
    """Aufstellung des Geräts ohne Maßstab (Ort + Drehung um z)."""
    loc, rot, _ = o.matrix_world.decompose()
    return Matrix.Translation(loc) @ rot.to_matrix().to_4x4()

dg = bpy.context.evaluated_depsgraph_get()
data = {app: dict(buckets={}, mats={}) for app in roots.values()}
for inst in dg.object_instances:
    ob = inst.object
    if ob.type not in ("MESH", "FONT", "CURVE"):
        continue
    src = inst.parent.original if inst.is_instance and inst.parent else top(ob.original)
    app = roots.get(src.name)
    if app is None:
        continue
    M = np.array(frame(src).inverted() @ inst.matrix_world, np.float32)
    me = ob.to_mesh()
    if me is None or not me.polygons:
        ob.to_mesh_clear(); continue
    co = np.empty(len(me.vertices) * 3, np.float32); me.vertices.foreach_get("co", co); co = co.reshape(-1, 3)
    wco = co @ M[:3, :3].T + M[:3, 3]
    me.calc_loop_triangles()
    nt = len(me.loop_triangles)
    tl = np.empty(nt * 3, np.int32); me.loop_triangles.foreach_get("loops", tl)
    tm = np.empty(nt, np.int32); me.loop_triangles.foreach_get("material_index", tm)
    lv = np.empty(len(me.loops), np.int32); me.loops.foreach_get("vertex_index", lv)
    ln = np.empty(len(me.loops) * 3, np.float32)
    try:
        me.corner_normals.foreach_get("vector", ln)
    except Exception:
        me.loops.foreach_get("normal", ln)
    ln = ln.reshape(-1, 3)
    uv = None
    if me.uv_layers.active:
        uv = np.empty(len(me.loops) * 2, np.float32); me.uv_layers.active.data.foreach_get("uv", uv); uv = uv.reshape(-1, 2)
    P = wco[lv[tl]]
    N = ln[tl] @ np.linalg.inv(M[:3, :3])
    N /= np.maximum(np.linalg.norm(N, axis=1, keepdims=True), 1e-8)
    UV = uv[tl] if uv is not None else np.zeros((len(tl), 2), np.float32)
    slots = [s.material for s in ob.material_slots] or [None]
    d = data[app]
    for mi in np.unique(tm):
        mname, info = mat_info(slots[mi] if mi < len(slots) else None)
        d["mats"][mname] = info
        sel = np.repeat(tm == mi, 3)
        bk = d["buckets"].setdefault(mname, ([], [], []))
        bk[0].append(P[sel]); bk[1].append(N[sel]); bk[2].append(UV[sel])
    ob.to_mesh_clear()

for app, d in data.items():
    if not d["buckets"]:
        print("LEER", app); continue
    allp = np.concatenate([np.concatenate(b[0]) for b in d["buckets"].values()])
    lo, hi = allp.min(0), allp.max(0)
    off = np.array([(lo[0] + hi[0]) / 2, (lo[1] + hi[1]) / 2, lo[2]], np.float32)   # Grundfläche mittig, Boden bei 0
    arr = {}
    for i, (k, (p, n, u)) in enumerate(d["buckets"].items()):
        arr["p%d" % i] = np.concatenate(p) - off; arr["n%d" % i] = np.concatenate(n); arr["u%d" % i] = np.concatenate(u)
        d["mats"][k]["idx"] = i; d["mats"][k]["tris"] = len(arr["p%d" % i]) // 3
    np.savez_compressed(os.path.join(OUT, app + ".npz"), **arr)
    size = (hi - lo).round(3).tolist()
    json.dump(dict(materials=d["mats"], origin=[0.0, 0.0], size=size), open(os.path.join(OUT, app + ".json"), "w"), indent=1)
    print("GERAET", app, "Maße", size, "Dreiecke", sum(v["tris"] for v in d["mats"].values()), flush=True)
print("FERTIG", flush=True)
