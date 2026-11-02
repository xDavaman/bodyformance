"""Ergänzt die fertige Boxhalle (boxing_gym.blend) um Dinge, die in echten Box-/Kraft-Gyms nicht fehlen dürfen,
und rendert Vorschaubilder.  blender -b boxing_gym.blend --python add_extras.py -- <zwischen-Ordner>
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

# ------------------------------------------------------------------ Was in echten Box-/Kraft-Gyms nicht fehlen darf
# (Hebeplattform, Standsack, Slam-Balls, Fächer für Bandagen, Desinfektion, Erste Hilfe, Wasserspender, Trainingstafel)
def lifting_platform(cx, cy):
    box((2.4, 2.4, 0.04), (cx, cy, 0.02), MAT["mat"], name="Hebeplattform Gummi")
    box((1.0, 2.4, 0.045), (cx, cy, 0.0225), pbr("Plattform Eiche", "old_wooden_floor_02", 1.2, hsv=(0.5, 0.9, 0.9)), name="Hebeplattform Holz")
    rod((cx - 1.1, cy, 0.225), (cx + 1.1, cy, 0.225), 0.014, simple("Hantelstange Chrom", (0.8, 0.8, 0.82), 0.15, 1.0), name="Langhantel Plattform")
    bm_ = bpy.data.materials.get("Bumper") or simple("Bumper", (0.025, 0.025, 0.027), 0.8)
    for s_ in (-1, 1):
        for k in range(2):
            cyl(0.225, 0.06, (cx + s_ * (0.78 + k * 0.065), cy, 0.225), bm_, rot=(0, 90, 0), seg=48, name="Bumper Plattform")
    box((0.35, 0.35, 0.3), (cx, cy - 1.5, 0.15), MAT["wood"], name="Kreidekiste", bevel=0.01)

def standing_bag(x, y):
    cyl(0.3, 0.25, (x, y, 0.125), MAT["rubber"], seg=40, name="Standsack Fuß")
    cyl(0.17, 1.1, (x, y, 0.85), MAT["leather_blk"], seg=40, name="Standsack")
    cyl(0.175, 0.05, (x, y, 0.35), MAT["tape"], seg=40, name="Standsack Ring")

def ball_rack(x, y):
    for z in (0.05, 0.55):
        box((1.4, 0.4, 0.04), (x, y, z), MAT["steel"], name="Ballregal Boden")
    for dx in (-0.68, 0.68):
        box((0.04, 0.4, 0.95), (x + dx, y, 0.475), MAT["steel"], name="Ballregal Seite")
    cols = [(0.08, 0.08, 0.08), (0.25, 0.04, 0.03), (0.05, 0.1, 0.25)]
    for i in range(5):
        for row, z in enumerate((0.07, 0.57)):
            r = 0.13 + 0.015 * ((i + row) % 3)
            bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x - 0.52 + i * 0.26, y, z + r))
            b = bpy.context.active_object; b.data.materials.append(simple("Slamball %d" % ((i + row) % 3), cols[(i + row) % 3], 0.8))
            for pp in b.data.polygons: pp.use_smooth = True

def cubbies(x, y, nx=4, ny=3):
    W_, H_ = 0.38, 0.32
    box((nx * W_ + 0.04, 0.4, ny * H_ + 0.04), (x, y, ny * H_ / 2 + 0.3), MAT["wood"], name="Fächerregal")
    for i in range(nx):
        for j in range(ny):
            box((W_ - 0.04, 0.05, H_ - 0.04), (x - nx * W_ / 2 + W_ * (i + 0.5), y - 0.18, 0.3 + H_ * (j + 0.5)), MAT["poster_ink"], name="Fach")
            if (i + j) % 2 == 0:
                cyl(0.06, 0.1, (x - nx * W_ / 2 + W_ * (i + 0.5), y - 0.22, 0.3 + H_ * j + 0.08), MAT["leather_red"] if (i + j) % 4 == 0 else MAT["poster_red"], rot=(0, 90, 0), name="Bandage")

def wall_station(x, y):
    box((0.35, 0.1, 0.45), (x, y, 1.35), simple("Erste Hilfe Grün", (0.02, 0.3, 0.1), 0.4), name="Erste-Hilfe-Kasten")
    box((0.06, 0.012, 0.22), (x, y - 0.056, 1.35), simple("Weiß", (0.85, 0.85, 0.85), 0.5), name="Kreuz senkrecht")
    box((0.22, 0.012, 0.06), (x, y - 0.056, 1.35), simple("Weiß", (0.85, 0.85, 0.85), 0.5), name="Kreuz waagrecht")
    box((0.3, 0.12, 0.08), (x + 0.6, y, 1.0), MAT["steel"], name="Desinfektion Ablage")
    for k in range(2):
        cyl(0.04, 0.22, (x + 0.52 + k * 0.16, y - 0.01, 1.15), simple("Sprühflasche", (0.1, 0.35, 0.7), 0.3), name="Sprühflasche")
    box((0.25, 0.1, 0.32), (x + 0.6, y, 1.45), simple("Papierspender", (0.75, 0.75, 0.72), 0.4), name="Papierspender")

def water_fountain(x, y):
    box((0.4, 0.35, 0.9), (x, y, 0.45), simple("Edelstahl", (0.6, 0.6, 0.62), 0.25, 1.0), name="Wasserspender", bevel=0.02)
    box((0.36, 0.3, 0.05), (x, y - 0.02, 0.92), simple("Edelstahl", (0.6, 0.6, 0.62), 0.25, 1.0), name="Wasserspender Becken")
    cyl(0.12, 0.45, (x, y + 0.05, 1.2), simple("Wasserflasche", (0.4, 0.6, 0.85), 0.1, trans=0.6), name="Wasserflasche")

def chalkboard(x, y, rot):
    box((1.3, 0.04, 0.95), (x, y, 1.95), MAT["wood"], rot=(0, 0, rot), name="Tafel Rahmen")
    box((1.2, 0.045, 0.85), (x, y, 1.95), simple("Tafel", (0.03, 0.05, 0.04), 0.9), rot=(0, 0, rot), name="Tafel")
    chalk = simple("Kreideschrift", (0.8, 0.8, 0.76), 0.95)
    lines = ["TODAY", "6 RDS SKIPPING  3:00", "6 RDS HEAVY BAG  3:00", "5x5 DEADLIFT", "100 PUSH-UPS"]
    for i, t in enumerate(lines):
        o = text(t, (x, y, 2.27 - i * 0.15), 0.13 if i == 0 else 0.085, chalk, rot=(90, 0, rot), extrude=0.0005)
        o.location.x += 0.03 * (1 if rot > 0 else -1)

lifting_platform(8.4, 1.4)
standing_bag(0.6, -3.5)
ball_rack(-3.0, RD / 2 - 0.3)
cubbies(-1.2, RD / 2 - 0.22)
wall_station(0.3, RD / 2 - 0.05)
water_fountain(1.6, RD / 2 - 0.22)
chalkboard(-RW / 2 + 0.04, -1.8, 90)

# Vorschau-Renders: die gespeicherten Kameras + ein Blick auf die neue Wand-Ecke
cd = bpy.data.cameras.new("06_rueckwand"); cd.lens = 20; cam = _link(bpy.data.objects.new("06_rueckwand", cd))
cam.location = (-1.0, 1.0, 1.7); tgt = Vector((-1.0, RD / 2, 1.3))
cam.rotation_euler = (tgt - Vector(cam.location)).to_track_quat("-Z", "Y").to_euler()
cd2 = bpy.data.cameras.new("07_plattform"); cd2.lens = 22; cam2 = _link(bpy.data.objects.new("07_plattform", cd2))
cam2.location = (4.5, -2.0, 1.8); tgt2 = Vector((8.4, 1.6, 0.4))
cam2.rotation_euler = (tgt2 - Vector(cam2.location)).to_track_quat("-Z", "Y").to_euler()
out = os.path.join(Z, "renders"); os.makedirs(out, exist_ok=True)
sc.cycles.samples = 64; sc.render.resolution_x, sc.render.resolution_y = 1280, 720
try:
    pr = bpy.context.preferences.addons["cycles"].preferences; pr.compute_device_type = "OPTIX"; pr.get_devices()
    for d in pr.devices: d.use = d.type != "CPU"
    sc.cycles.device = "GPU"
except Exception: pass
sc.cycles.denoiser = "OPENIMAGEDENOISE"
for o in [o for o in sc.objects if o.type == "CAMERA"]:
    sc.camera = o; sc.render.filepath = os.path.join(out, o.name + ".png")
    bpy.ops.render.render(write_still=True); print("[gym] gerendert", o.name, flush=True)
bpy.ops.wm.save_as_mainfile(filepath=os.path.join(Z, "boxing_gym_v8.blend"))
print("FERTIG", flush=True)
