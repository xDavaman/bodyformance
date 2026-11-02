"""Gemeinsame Helfer für die Blender-Exporte der Boxhalle (Materialien, Netze)."""
import bpy, os

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
    "Plattform Eiche": ("old_wooden_floor_02", 1.2, (0.5, 0.9, 0.9), 1.0, 0.0, 1.0),
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

