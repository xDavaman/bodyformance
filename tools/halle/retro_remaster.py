"""Retro-Remaster der Boxhalle: 70er/80er-Look, frisch neu eröffnet, mit etwas Eisen-Chaos.
blender -b boxing_gym_v8.blend --python retro_remaster.py -- <zwischen-Ordner>
(nutzt die Helfer aus halle_bau.py; speichert boxing_gym_v9.blend und rendert Tag- und Abend-Vorschau)
"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from halle_bau import *  # noqa: F401,F403  (box, cyl, rod, text, simple, pbr, MAT, RW, RD, Z, sc …)
import bpy
from mathutils import Vector

import random
random.seed(74)

# --- Retro-Streifen (Orange/Gelb/Braun) über dem grünen Sockelanstrich: frisch gestrichen
STRIPES = [(1.42, simple("Retro Braun", (0.18, 0.07, 0.02), 0.55)), (1.52, simple("Retro Orange", (0.65, 0.18, 0.02), 0.5)),
           (1.62, simple("Retro Gelb", (0.75, 0.45, 0.05), 0.5))]
for z, m in STRIPES:
    box((RW, 0.012, 0.08), (0, RD / 2 - 0.006, z), m, name="Retrostreifen hinten")
    box((0.012, RD, 0.08), (-RW / 2 + 0.006, 0, z), m, name="Retrostreifen links")
    box((0.012, RD, 0.08), (RW / 2 - 0.006, 0, z), m, name="Retrostreifen rechts")

# --- Leuchtschriften im 80er-Stil
def neon(body, loc, size, col, rot, strength=18):
    m = simple("Neon " + body[:8], col, 0.3, emit=col, es=strength)
    o = text(body, loc, size, m, rot=rot, extrude=0.012)
    back = simple("Neon Träger", (0.02, 0.02, 0.02), 0.4)
    return o
neon("NO EXCUSES", (7.6, RD / 2 - 0.03, 2.95), 0.42, (1.0, 0.08, 0.35), (90, 0, 0))
neon("PUMP IT UP", (RW / 2 - 0.03, -1.5, 3.4), 0.5, (0.1, 0.75, 1.0), (90, 0, -90))
neon("OPEN 5AM - 11PM", (-RW / 2 + 0.03, 3.6, 3.3), 0.26, (1.0, 0.55, 0.05), (90, 0, 90), 14)
text("RENOVATED 2026", (1.5, RD / 2 - 0.02, 3.25), 0.22, MAT["poster_red"], rot=(90, 0, 0), extrude=0.001, name="Wandschrift")

# --- Eisen-Chaos: Scheiben, Kurzhanteln und Stangen liegen und lehnen herum
iron = simple("Gusseisen Retro", (0.03, 0.03, 0.03), 0.55, 0.8)
chrome = simple("Chrom Retro", (0.8, 0.8, 0.82), 0.12, 1.0)
def plate(x, y, z, r=0.225, t=0.04, rot=(0, 0, 0)):
    cyl(r, t, (x, y, z), iron, rot=rot, seg=40, name="Hantelscheibe")
    cyl(0.03, t + 0.004, (x, y, z), chrome, rot=rot, seg=16, name="Scheibenloch")
def dumbbell(x, y, rz, s=1.0):
    rod((x - 0.18 * s, y, 0.09 * s), (x + 0.18 * s, y, 0.09 * s), 0.016, chrome, name="Kurzhantelgriff")
    for d in (-1, 1):
        cyl(0.09 * s, 0.07 * s, (x + d * 0.15 * s, y, 0.09 * s), iron, rot=(0, 90, 0), seg=24, name="Kurzhantelkopf")
# Scheibenstapel an der Rückwand
for k in range(6):
    plate(2.4 + random.uniform(-0.02, 0.02), RD / 2 - 0.6, 0.022 + k * 0.042, r=0.225 - (k // 2) * 0.04)
# Kurzhanteln auf dem Boden
for (x, y, s) in ((-0.4, RD / 2 - 0.9, 1.0), (-0.1, RD / 2 - 1.1, 1.0), (3.8, -1.2, 1.2), (-7.6, -6.4, 0.9), (6.8, 4.6, 1.1)):
    dumbbell(x, y, 0, s)
# Langhantel und Scheiben an die linke Wand gelehnt
rod((-RW / 2 + 0.25, -0.2, 0.05), (-RW / 2 + 0.12, -0.1, 2.15), 0.014, chrome, name="Langhantel gelehnt")
for k in range(3):
    plate(-RW / 2 + 0.12 + k * 0.05, 0.6, 0.225 - k * 0.03, r=0.225 - k * 0.03, rot=(0, 80, 0))
# Kettlebells unordentlich vor dem Fächerregal
for i, (x, y) in enumerate(((-2.2, RD / 2 - 0.8), (-1.85, RD / 2 - 1.0), (-2.5, RD / 2 - 1.1))):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.1 + 0.02 * i, location=(x, y, 0.1 + 0.02 * i)); k = bpy.context.active_object
    k.data.materials.append(iron)
    for pp in k.data.polygons: pp.use_smooth = True
    bpy.ops.mesh.primitive_torus_add(major_radius=0.065 + 0.012 * i, minor_radius=0.015, location=(x, y, 0.22 + 0.04 * i), rotation=(R(90), 0, 0))
    bpy.context.active_object.data.materials.append(iron)
# Handtücher und Flaschen herumliegend
towel = simple("Handtuch Retro", (0.65, 0.2, 0.05), 0.95)
for (x, y, rz) in ((3.0, -1.0, 25), (-6.9, -5.8, -15)):
    box((0.55, 0.3, 0.02), (x, y, 0.01), towel, rot=(0, 0, rz), name="Handtuch", bevel=0.01)

# --- Vorschau: Tag (Sonne, Fenster) und Abend (Sonne aus, Lampen wärmer, dunkler)
out = os.path.join(Z, "renders"); os.makedirs(out, exist_ok=True)
sc.cycles.samples = 64; sc.render.resolution_x, sc.render.resolution_y = 1280, 720
try:
    pr = bpy.context.preferences.addons["cycles"].preferences; pr.compute_device_type = "OPTIX"; pr.get_devices()
    for d in pr.devices: d.use = d.type != "CPU"
    sc.cycles.device = "GPU"
except Exception: pass
sc.cycles.denoiser = "OPENIMAGEDENOISE"
bpy.ops.wm.save_as_mainfile(filepath=os.path.join(Z, "boxing_gym_v9.blend"))
cams = [o for o in sc.objects if o.type == "CAMERA" and o.name[:2] in ("01", "03", "04", "06")]
for o in cams:
    sc.camera = o; sc.render.filepath = os.path.join(out, "tag_" + o.name + ".png")
    bpy.ops.render.render(write_still=True); print("[gym] gerendert tag", o.name, flush=True)
# Abend
for o in sc.objects:
    if o.type == "LIGHT":
        if o.data.type == "SUN":
            o.data.energy = 0.0
        elif o.name.startswith(("Raumlicht", "Wandlicht")):
            o.data.energy *= 0.25
        elif o.data.type == "SPOT":
            o.data.energy *= 1.6
bg = sc.world.node_tree.nodes.get("Background")
if bg:
    bg.inputs[1].default_value = 0.08
for m in bpy.data.materials:
    if m.name.startswith("Glas verschmutzt"):
        b = m.node_tree.nodes.get("Principled BSDF")
        if b: b.inputs["Base Color"].default_value = (0.02, 0.025, 0.04, 1)
for o in cams:
    sc.camera = o; sc.render.filepath = os.path.join(out, "abend_" + o.name + ".png")
    bpy.ops.render.render(write_still=True); print("[gym] gerendert abend", o.name, flush=True)
print("FERTIG", flush=True)
