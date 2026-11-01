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

# Poly-Haven-Materialien aus boxing_gym.py: Name -> (slug, size, hsv, rough_mul, metal, nstr)
PBR = {
    "Ziegel alt": ("red_brick_03", 1.4, (0.5, 1, 1), 1.0, 0.0, 1.4),
    "Anstrich abblätternd": ("peeling_painted_wall", 1.6, (0.88, 0.75, 0.55), 1.0, 0.0, 1.0),
    "Holzdielen abgenutzt": ("old_wooden_floor_02", 2.2, (0.5, 1, 1), 1.0, 0.0, 0.8),
    "Beton fleckig": ("concrete_wall_006", 1.5, (0.5, 1, 1), 1.0, 0.0, 1.0),
    "Stahlträger alt": ("rusty_painted_metal", 1.2, (0.5, 0.35, 0.18), 1.0, 0.3, 1.0),
    "Leder Rot": ("fabric_leather_02", 0.6, (0.43, 1.6, 0.55), 0.8, 0.0, 1.0),
    "Leder Schwarz": ("fabric_leather_02", 0.6, (0.5, 0.0, 0.12), 0.8, 0.0, 1.0),
    "Leder Braun": ("brown_leather", 0.6, (0.5, 1, 1), 0.9, 0.0, 1.0),
    "Spind Grün": ("green_metal_rust", 1.0, (0.5, 1, 1), 1.0, 0.4, 1.0),
    "Holz dunkel": ("old_planks_02", 1.5, (0.5, 1, 1.0), 1.0, 0.0, 1.0),
    "Gummimatte": ("rubber_tiles", 2.0, (0.5, 1, 1), 1.1, 0.0, 1.0),
}

def base_name(n):
    return n.split(".")[0] if n[-4:-3] == "." and n[-3:].isdigit() else n

def trace_color(sock, depth=0):
    if not sock.is_linked:
        v = sock.default_value
        return [v[0], v[1], v[2]] if hasattr(v, "__len__") else [v, v, v]
    if depth > 5:
        return None
    nd = sock.links[0].from_node
    if nd.type == "RGB":
        v = nd.outputs[0].default_value; return [v[0], v[1], v[2]]
    if nd.type == "VALTORGB":
        e = nd.color_ramp.elements; v = e[len(e) - 1].color; return [v[0], v[1], v[2]]
    for name in ("A", "Color1", "Color", "Base Color"):
        if name in nd.inputs:
            for s in nd.inputs:
                if s.name == name and s.type == "RGBA":
                    c = trace_color(s, depth + 1)
                    if c:
                        return c
    return None

def find_image(nt, sock_name, b):
    s = b.inputs[sock_name]
    seen = [s.links[0].from_node] if s.is_linked else []
    while seen:
        nd = seen.pop()
        if nd.type == "TEX_IMAGE" and nd.image:
            return bpy.path.abspath(nd.image.filepath)
        for i in nd.inputs:
            if i.is_linked:
                seen.append(i.links[0].from_node)
    return None

mats = {}
def mat_info(m):
    if m is None:
        return "_default", dict(kind="flat", color=[0.5, 0.5, 0.5], rough=0.6, metal=0.0)
    bn = base_name(m.name)
    if bn in PBR:
        slug, size, hsv, rm, metal, nstr = PBR[bn]
        return bn, dict(kind="pbr", slug=slug, size=size, hsv=hsv, rough_mul=rm, metal=metal, nstr=nstr)
    b = m.node_tree.nodes.get("Principled BSDF") if m.use_nodes else None
    if b is None:
        c = list(m.diffuse_color)[:3]
        return m.name, dict(kind="flat", color=c, rough=0.6, metal=0.0)
    d = dict(kind="flat", color=trace_color(b.inputs["Base Color"]) or [0.5, 0.5, 0.5],
             rough=float(b.inputs["Roughness"].default_value), metal=float(b.inputs["Metallic"].default_value))
    es = float(b.inputs["Emission Strength"].default_value)
    if es > 0:
        d["emit"] = list(b.inputs["Emission Color"].default_value)[:3]; d["es"] = es
    if b.inputs["Transmission Weight"].default_value > 0.5:
        d["glass"] = True
    img = find_image(m.node_tree, "Base Color", b)
    if img and os.path.exists(img):
        d["kind"] = "uvtex"; d["image"] = img
        n = find_image(m.node_tree, "Normal", b)
        if n and os.path.exists(n):
            d["normal"] = n
    return m.name, d

def top(o):
    while o.parent:
        o = o.parent
    return o

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
