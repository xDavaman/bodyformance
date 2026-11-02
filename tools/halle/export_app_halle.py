"""Exportiert die Boxhalle (fertig/boxing_gym.blend) als Rohdaten für die App (Gym_Halle.usdz).

blender -b <W>/fertig/boxing_gym.blend --python export_app_halle.py -- <W>

- Ursprung der App-Szene = Gerätezone (RX, RY); dort ein freier Bereich für Figur und App-Geräte
- schreibt zwischen/app_export/halle.npz (Dreiecke je Material, Weltkoordinaten Blender) und materials.json
"""
import bpy, os, sys, json
import numpy as np
from mathutils import Vector

ARGS = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
W = ARGS[0] if ARGS else r"C:\Users\sean\Claude-Work\Boxing-Gym"
OUT = os.path.join(W, "zwischen", "app_export")
os.makedirs(OUT, exist_ok=True)
RX, RY = -5.0, 0.6
CLEAR = 4.45          # halbe Kantenlänge des freien Bereichs (App-Geräte stehen bis ±3,7 m)
KEEP = ("Gummiboden Gerätezone", "Dielenboden", "Holzdecke")

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from halle_common import PBR, base_name, mat_info, top  # noqa: E402

mats = {}
# Geräte aus der Bibliothek sind sehr fein: für das iPhone stark reduzieren (stehen alle ≥ 4,5 m von der Figur weg)
for o in bpy.data.objects:
    if o.type == 'MESH' and o.data:
        t = sum(len(p.vertices) - 2 for p in o.data.polygons)
        if t > 300:
            md = o.modifiers.new('App-Reduktion', 'DECIMATE'); md.ratio = max(300.0 / t, 0.025); md.use_collapse_triangulate = True
dg = bpy.context.evaluated_depsgraph_get()
buckets = {}   # name -> lists
stats = dict(objects=0, dropped=[], tris=0)
for inst in dg.object_instances:
    ob = inst.object
    if ob.type not in ("MESH", "FONT", "CURVE"):
        continue
    src = inst.parent.original if inst.is_instance and inst.parent else top(ob.original)
    M = inst.matrix_world.copy()
    try:
        me = ob.to_mesh()
    except Exception:
        continue
    if me is None or not me.polygons:
        ob.to_mesh_clear(); continue
    co = np.empty(len(me.vertices) * 3, np.float32); me.vertices.foreach_get("co", co); co = co.reshape(-1, 3)
    Mn = np.array(M, np.float32)
    wco = co @ Mn[:3, :3].T + Mn[:3, 3]
    lo, hi = wco.min(0), wco.max(0)
    name = base_name(ob.original.name)
    if src.type == "EMPTY":
        key = np.array(src.matrix_world.translation, np.float32)
    else:
        key = (lo + hi) / 2
    big = (hi - lo).max() > 7.0
    if not big and not name.startswith(KEEP) and abs(key[0] - RX) < CLEAR and abs(key[1] - RY) < CLEAR and lo[2] < 3.0:
        stats["dropped"].append(src.name); ob.to_mesh_clear(); continue
    me.calc_loop_triangles()
    nt = len(me.loop_triangles)
    tri_loops = np.empty(nt * 3, np.int32); me.loop_triangles.foreach_get("loops", tri_loops)
    tri_mat = np.empty(nt, np.int32); me.loop_triangles.foreach_get("material_index", tri_mat)
    loop_v = np.empty(len(me.loops), np.int32); me.loops.foreach_get("vertex_index", loop_v)
    ln = np.empty(len(me.loops) * 3, np.float32)
    try:
        me.corner_normals.foreach_get("vector", ln)
    except Exception:
        me.loops.foreach_get("normal", ln)
    ln = ln.reshape(-1, 3)
    uv = None
    if me.uv_layers.active:
        uv = np.empty(len(me.loops) * 2, np.float32); me.uv_layers.active.data.foreach_get("uv", uv); uv = uv.reshape(-1, 2)
    Nm = np.linalg.inv(Mn[:3, :3]).T
    P = wco[loop_v[tri_loops]]
    N = ln[tri_loops] @ Nm.T
    N /= np.maximum(np.linalg.norm(N, axis=1, keepdims=True), 1e-8)
    UV = uv[tri_loops] if uv is not None else np.zeros((len(tri_loops), 2), np.float32)
    slots = [s.material for s in ob.material_slots] or [None]
    for mi in np.unique(tri_mat):
        m = slots[mi] if mi < len(slots) else None
        mname, info = mat_info(m)
        mats[mname] = info
        sel = np.repeat(tri_mat == mi, 3)
        bk = buckets.setdefault(mname, ([], [], []))
        bk[0].append(P[sel]); bk[1].append(N[sel]); bk[2].append(UV[sel])
    stats["objects"] += 1; stats["tris"] += nt
    ob.to_mesh_clear()

arr = {}
for i, (k, (p, n, u)) in enumerate(buckets.items()):
    arr["p%d" % i] = np.concatenate(p); arr["n%d" % i] = np.concatenate(n); arr["u%d" % i] = np.concatenate(u)
    mats[k]["idx"] = i; mats[k]["tris"] = len(arr["p%d" % i]) // 3
np.savez_compressed(os.path.join(OUT, "halle.npz"), **arr)
stats["dropped"] = sorted(set(stats["dropped"]))
json.dump(dict(materials=mats, stats=stats, origin=[RX, RY]), open(os.path.join(OUT, "materials.json"), "w"), indent=1)
print("FERTIG", stats["objects"], stats["tris"], len(mats), flush=True)
