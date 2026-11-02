"""Bau-Helfer für Ergänzungen an der fertigen Boxhalle (add_extras.py, retro_remaster.py).
Beim Import: Texturpfade auf <zwischen-Ordner>/tex umbiegen, Materialien der Halle in MAT bereitstellen.
"""
import bpy, bmesh, math, os, sys
from mathutils import Vector
ARGS = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
Z = ARGS[0]
TEX = os.path.join(Z, "tex")
R = math.radians
RW, RD, RH = 24.0, 15.0, 5.6
sc = bpy.context.scene
COL = sc.collection
# Texturpfade auf den neuen Arbeitsordner umbiegen (Claude-Work liegt jetzt unter C:\Users\sean\Claude)
for im in bpy.data.images:
    p = bpy.path.abspath(im.filepath)
    if "tex" in p.replace("/", "\\").split("\\"):
        parts = p.replace("/", "\\").split("\\")
        i = parts.index("tex")
        np_ = os.path.join(TEX, *parts[i + 1:])
        if os.path.exists(np_):
            im.filepath = np_; im.reload()
MATNAMES = dict(mat="Gummimatte", wood="Holz dunkel", rubber="Gerät Gummi", leather_blk="Leder Schwarz", leather_red="Leder Rot",
                tape="Klebeband", steel="Stahlträger alt", poster_ink="Druckfarbe", poster_red="Plakat Rot")
MAT = {k: bpy.data.materials[v] for k, v in MATNAMES.items()}
def node_mat(name):
    m = bpy.data.materials.new(name); m.use_nodes = True
    nt = m.node_tree; b = nt.nodes["Principled BSDF"]
    return m, nt, b

def simple(name, col, rough=0.5, metal=0.0, emit=None, es=0.0, alpha=1.0, trans=0.0):
    m, nt, b = node_mat(name)
    b.inputs["Base Color"].default_value = (*col, 1); b.inputs["Roughness"].default_value = rough
    b.inputs["Metallic"].default_value = metal
    if emit:
        b.inputs["Emission Color"].default_value = (*emit, 1); b.inputs["Emission Strength"].default_value = es
    if trans:
        b.inputs["Transmission Weight"].default_value = trans
    return m

def pbr(name, slug, size=1.0, hsv=(0.5, 1.0, 1.0), rough_mul=1.0, metal=0.0, nstr=1.0, coords="Object"):
    """Material aus Poly-Haven-Texturen (diff/nor/rough), Box-Projektion in Metern."""
    m, nt, b = node_mat(name)
    tc = nt.nodes.new("ShaderNodeTexCoord"); mp = nt.nodes.new("ShaderNodeMapping")
    mp.inputs["Scale"].default_value = (1 / size, 1 / size, 1 / size); nt.links.new(tc.outputs[coords], mp.inputs["Vector"])
    def img(f, color=True):
        n = nt.nodes.new("ShaderNodeTexImage"); n.projection = "BOX"; n.projection_blend = 0.25
        path = os.path.join(TEX, slug, f)
        if os.path.exists(path):
            n.image = bpy.data.images.load(path, check_existing=True)
            if not color:
                n.image.colorspace_settings.name = "Non-Color"
        nt.links.new(mp.outputs[0], n.inputs["Vector"]); return n
    d = img("diff.jpg")
    hs = nt.nodes.new("ShaderNodeHueSaturation"); hs.inputs["Hue"].default_value, hs.inputs["Saturation"].default_value, hs.inputs["Value"].default_value = hsv
    nt.links.new(d.outputs["Color"], hs.inputs["Color"]); nt.links.new(hs.outputs["Color"], b.inputs["Base Color"])
    if os.path.exists(os.path.join(TEX, slug, "rough.jpg")):
        r = img("rough.jpg", False); mm = nt.nodes.new("ShaderNodeMath"); mm.operation = "MULTIPLY"; mm.inputs[1].default_value = rough_mul
        nt.links.new(r.outputs["Color"], mm.inputs[0]); nt.links.new(mm.outputs[0], b.inputs["Roughness"])
    if os.path.exists(os.path.join(TEX, slug, "nor.jpg")):
        nimg = img("nor.jpg", False); nm = nt.nodes.new("ShaderNodeNormalMap"); nm.inputs["Strength"].default_value = nstr
        nt.links.new(nimg.outputs["Color"], nm.inputs["Color"]); nt.links.new(nm.outputs["Normal"], b.inputs["Normal"])
    b.inputs["Metallic"].default_value = metal
    return m

def _link(ob):
    COL.objects.link(ob); return ob

def box(size, loc, m, rot=(0, 0, 0), name="Box", bevel=0.0):
    me = bpy.data.meshes.new(name); bm = bmesh.new(); bmesh.ops.create_cube(bm, size=1)
    bmesh.ops.scale(bm, vec=Vector(size), verts=bm.verts); bm.to_mesh(me); bm.free()
    ob = _link(bpy.data.objects.new(name, me)); ob.location = loc; ob.rotation_euler = [R(a) for a in rot]
    me.materials.append(m)
    if bevel:
        bv = ob.modifiers.new("F", "BEVEL"); bv.width = bevel; bv.segments = 3
    return ob

def cyl(r, h, loc, m, rot=(0, 0, 0), seg=32, name="Zyl", r2=None, smooth=True):
    me = bpy.data.meshes.new(name); bm = bmesh.new()
    bmesh.ops.create_cone(bm, cap_ends=True, segments=seg, radius1=r, radius2=r if r2 is None else r2, depth=h)
    bm.to_mesh(me); bm.free()
    if smooth:
        for p in me.polygons: p.use_smooth = True
    ob = _link(bpy.data.objects.new(name, me)); ob.location = loc; ob.rotation_euler = [R(a) for a in rot]
    me.materials.append(m); return ob

def between(ob, a, b):
    a, b = Vector(a), Vector(b); ob.location = (a + b) / 2; ob.rotation_euler = (b - a).to_track_quat("Z", "Y").to_euler()

def rod(a, b, r, m, seg=16, name="Stab"):
    o = cyl(r, (Vector(b) - Vector(a)).length, (0, 0, 0), m, seg=seg, name=name); between(o, a, b); return o

def text(body, loc, size, m, rot=(90, 0, 0), extrude=0.004, align="CENTER", name="Text"):
    cu = bpy.data.curves.new(name, "FONT"); cu.body = body; cu.size = size; cu.extrude = extrude; cu.align_x = align
    ob = _link(bpy.data.objects.new(name, cu)); ob.location = loc; ob.rotation_euler = [R(a) for a in rot]
    cu.materials.append(m); return ob

