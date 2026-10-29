"""Studio, materials, lights, camera and gym equipment in the look of the references:
deep navy studio, glossy blue floor, black rubber mat, glossy white porcelain figure
with blue rim light, red glowing target muscles."""
import math
import bpy
from mathutils import Vector

NAVY = (0.006, 0.016, 0.06, 1)
BLUE = (0.02, 0.07, 0.30, 1)


def reset():
    bpy.ops.wm.read_factory_settings(use_empty=True)


def enable_gpu():
    """Use an NVIDIA/AMD/Intel/Apple GPU when available (much faster). FITANIM_CPU=1 forces CPU."""
    import os
    if os.environ.get("FITANIM_CPU"):
        return False
    try:
        prefs = bpy.context.preferences.addons["cycles"].preferences
    except Exception:
        return False
    for kind in ("OPTIX", "CUDA", "HIP", "ONEAPI", "METAL"):
        try:
            prefs.compute_device_type = kind
            prefs.get_devices()
        except Exception:
            continue
        gpus = [d for d in prefs.devices if d.type == kind]
        if gpus:
            for d in prefs.devices:
                d.use = d.type == kind
            print(f"[fitanim] GPU rendering: {kind} ({', '.join(d.name for d in gpus)})")
            return True
    print("[fitanim] no GPU found - rendering on CPU")
    return False


def setup_render(scene, w=720, h=1280, fps=30, samples=24, engine="CYCLES"):
    scene.render.resolution_x, scene.render.resolution_y = w, h
    scene.render.resolution_percentage = 100
    scene.render.fps = fps
    scene.render.engine = engine
    if engine == "CYCLES":
        c = scene.cycles
        c.samples = samples
        c.use_denoising = True
        c.denoiser = "OPENIMAGEDENOISE"
        c.max_bounces = 6; c.diffuse_bounces = 2; c.glossy_bounces = 3
        c.transmission_bounces = 2; c.volume_bounces = 0; c.transparent_max_bounces = 24
        c.caustics_reflective = False; c.caustics_refractive = False
        c.use_adaptive_sampling = True; c.adaptive_threshold = 0.03
        gpu = enable_gpu()
        c.device = "GPU" if gpu else "CPU"
        if gpu:
            try:
                c.denoiser = "OPTIX"          # GPU denoiser (much faster than OIDN on CPU)
            except TypeError:
                pass
        scene.render.use_persistent_data = True
    else:
        e = scene.eevee
        e.taa_render_samples = samples
        try:
            e.use_raytracing = True
        except Exception:
            pass
    scene.view_settings.view_transform = "AgX"
    scene.view_settings.look = "AgX - Medium High Contrast"
    scene.render.film_transparent = False


# ---------------------------------------------------------------- materials
def _nodes(mat):
    mat.use_nodes = True
    nt = mat.node_tree
    for n in list(nt.nodes):
        nt.nodes.remove(n)
    return nt


ROUGH, COAT = 0.62, 0.0


def mat_porcelain(name="Porcelain", muscles=(), highlight_color=(0.9, 0.025, 0.02), roughness=None, coat=None,
                  sheen=None, base=None):
    """Glossy white figure. Target muscles are blended to red via mesh attributes
    'm_<muscle>' and the value node 'HL' (0..1, animatable)."""
    mat = bpy.data.materials.new(name)
    nt = _nodes(mat)
    N, L = nt.nodes, nt.links
    out = N.new("ShaderNodeOutputMaterial"); out.location = (900, 0)
    bsdf = N.new("ShaderNodeBsdfPrincipled"); bsdf.location = (600, 0)
    # satin porcelain / clay: soft sheen instead of a lacquered gloss
    bsdf.inputs["Roughness"].default_value = ROUGH if roughness is None else roughness
    bsdf.inputs["Coat Weight"].default_value = COAT if coat is None else coat
    bsdf.inputs["Coat Roughness"].default_value = 0.3
    bsdf.inputs["Specular IOR Level"].default_value = 0.42
    bsdf.inputs["Sheen Weight"].default_value = 0.25 if sheen is None else sheen
    bsdf.inputs["Sheen Roughness"].default_value = 0.45
    bsdf.inputs["Subsurface Weight"].default_value = 0.18
    bsdf.inputs["Subsurface Radius"].default_value = (0.02, 0.02, 0.03)
    bsdf.inputs["Subsurface Scale"].default_value = 0.05

    white = tuple(base) + (1,) if base else (0.80, 0.82, 0.86, 1)
    # cool tint at grazing angles (porcelain picks up the blue studio)
    lw = N.new("ShaderNodeLayerWeight"); lw.location = (-600, 200); lw.inputs[0].default_value = 0.35
    tint = N.new("ShaderNodeMix"); tint.data_type = "RGBA"; tint.location = (-350, 200)
    tint.inputs[6].default_value = white
    tint.inputs[7].default_value = (0.55, 0.68, 0.95, 1)
    L.new(lw.outputs["Facing"], tint.inputs[0])
    col = tint.outputs[2]

    hl = N.new("ShaderNodeValue"); hl.name = hl.label = "HL"; hl.location = (-600, -250)
    hl.outputs[0].default_value = 0.0
    mask_socket = None
    x = -900
    for m in muscles:
        a = N.new("ShaderNodeAttribute"); a.attribute_name = "m_" + m; a.location = (x, -400)
        x += 0
        if mask_socket is None:
            mask_socket = a.outputs["Fac"]
        else:
            mx = N.new("ShaderNodeMath"); mx.operation = "MAXIMUM"; mx.location = (x + 200, -400)
            L.new(mask_socket, mx.inputs[0]); L.new(a.outputs["Fac"], mx.inputs[1])
            mask_socket = mx.outputs[0]
    if mask_socket is not None:
        # body of the muscle (soft) + bright rim (edge of mask)
        body = N.new("ShaderNodeMapRange"); body.location = (-350, -350)
        body.inputs[1].default_value = 0.25; body.inputs[2].default_value = 0.6
        L.new(mask_socket, body.inputs[0])
        mul = N.new("ShaderNodeMath"); mul.operation = "MULTIPLY"; mul.location = (-150, -300)
        L.new(body.outputs[0], mul.inputs[0]); L.new(hl.outputs[0], mul.inputs[1])
        mix = N.new("ShaderNodeMix"); mix.data_type = "RGBA"; mix.location = (100, 100)
        L.new(mul.outputs[0], mix.inputs[0]); L.new(col, mix.inputs[6])
        mix.inputs[7].default_value = (*highlight_color, 1)
        col = mix.outputs[2]
        # glow
        em_mul = N.new("ShaderNodeMath"); em_mul.operation = "MULTIPLY"; em_mul.location = (100, -300)
        L.new(mul.outputs[0], em_mul.inputs[0]); em_mul.inputs[1].default_value = 0.9
        bsdf.inputs["Emission Color"].default_value = (*highlight_color, 1)
        L.new(em_mul.outputs[0], bsdf.inputs["Emission Strength"])
        # slightly rougher where red so it reads as a flat overlay
        rg = N.new("ShaderNodeMapRange"); rg.location = (300, -450)
        L.new(mul.outputs[0], rg.inputs[0]); rg.inputs[3].default_value = bsdf.inputs["Roughness"].default_value; rg.inputs[4].default_value = 0.55
        L.new(rg.outputs[0], bsdf.inputs["Roughness"])
    L.new(col, bsdf.inputs["Base Color"])
    L.new(bsdf.outputs[0], out.inputs[0])
    return mat


def mat_simple(name, color, rough=0.5, metal=0.0, coat=0.0, emission=None, strength=0.0):
    mat = bpy.data.materials.new(name)
    nt = _nodes(mat)
    b = nt.nodes.new("ShaderNodeBsdfPrincipled")
    o = nt.nodes.new("ShaderNodeOutputMaterial")
    b.inputs["Base Color"].default_value = color
    b.inputs["Roughness"].default_value = rough
    b.inputs["Metallic"].default_value = metal
    b.inputs["Coat Weight"].default_value = coat
    if emission:
        b.inputs["Emission Color"].default_value = emission
        b.inputs["Emission Strength"].default_value = strength
    nt.links.new(b.outputs[0], o.inputs[0])
    return mat


def mat_emission(name, color, strength=5.0):
    mat = bpy.data.materials.new(name)
    nt = _nodes(mat)
    e = nt.nodes.new("ShaderNodeEmission"); o = nt.nodes.new("ShaderNodeOutputMaterial")
    e.inputs[0].default_value = color; e.inputs[1].default_value = strength
    nt.links.new(e.outputs[0], o.inputs[0])
    return mat


def mat_backdrop():
    """Navy backdrop with a soft lighter spot behind the figure."""
    mat = bpy.data.materials.new("Backdrop")
    nt = _nodes(mat); N, L = nt.nodes, nt.links
    o = N.new("ShaderNodeOutputMaterial")
    b = N.new("ShaderNodeBsdfPrincipled")
    b.inputs["Base Color"].default_value = (0.008, 0.022, 0.10, 1)
    b.inputs["Roughness"].default_value = 0.9
    b.inputs["Emission Color"].default_value = (0.02, 0.06, 0.25, 1)
    b.inputs["Emission Strength"].default_value = 0.10
    L.new(b.outputs[0], o.inputs[0])
    return mat


def mat_floor():
    mat = bpy.data.materials.new("Floor")
    nt = _nodes(mat); N, L = nt.nodes, nt.links
    o = N.new("ShaderNodeOutputMaterial")
    b = N.new("ShaderNodeBsdfPrincipled")
    b.inputs["Base Color"].default_value = (0.004, 0.012, 0.05, 1)
    b.inputs["Roughness"].default_value = 0.38
    b.inputs["Specular IOR Level"].default_value = 0.18
    b.inputs["Coat Weight"].default_value = 0.0
    L.new(b.outputs[0], o.inputs[0])
    return mat


# -------------------------------------------------------------- primitives
def _link(ob, coll=None):
    (coll or bpy.context.scene.collection).objects.link(ob)
    return ob


def add_mesh_primitive(kind, name, mat=None, **kw):
    fn = {"cube": bpy.ops.mesh.primitive_cube_add, "cyl": bpy.ops.mesh.primitive_cylinder_add,
          "plane": bpy.ops.mesh.primitive_plane_add, "sphere": bpy.ops.mesh.primitive_uv_sphere_add,
          "torus": bpy.ops.mesh.primitive_torus_add}[kind]
    fn(**kw)
    ob = bpy.context.active_object
    ob.name = name
    if mat:
        ob.data.materials.append(mat)
    return ob


def bevel(ob, w=0.004, seg=2):
    m = ob.modifiers.new("Bevel", "BEVEL"); m.width = w; m.segments = seg
    m.limit_method = "ANGLE"
    for p in ob.data.polygons:
        p.use_smooth = True
    try:
        ob.data.set_sharp_from_angle(angle=math.radians(40))
    except Exception:
        pass
    return ob


# ------------------------------------------------------------------ studio
def build_studio(floor_mat=None):
    # curved cyclorama: floor + backdrop
    bpy.ops.mesh.primitive_plane_add(size=40, location=(0, 0, 0))
    floor = bpy.context.active_object; floor.name = "Floor"
    floor.data.materials.append(floor_mat or mat_floor())
    bpy.ops.mesh.primitive_cylinder_add(vertices=128, radius=11, depth=30, location=(0, 0, 0))
    wall = bpy.context.active_object; wall.name = "Backdrop"
    wall.data.materials.append(mat_backdrop())
    for p in wall.data.polygons:
        p.use_smooth = True
    wall.visible_shadow = False

    w = bpy.data.worlds.new("World"); bpy.context.scene.world = w
    w.use_nodes = True
    bg = w.node_tree.nodes["Background"]
    bg.inputs[0].default_value = (0.01, 0.025, 0.09, 1); bg.inputs[1].default_value = 0.25

    def area(name, loc, rot, size, energy, color, shape="RECTANGLE", sx=None):
        ld = bpy.data.lights.new(name, "AREA"); ld.energy = energy; ld.color = color
        ld.shape = shape; ld.size = size
        if sx:
            ld.size_y = sx
        ob = bpy.data.objects.new(name, ld); _link(ob)
        ob.location = loc; ob.rotation_euler = [math.radians(a) for a in rot]
        return ob

    lights = {
        # soft key from front/above (white with a hint of cool)
        "Key": area("Key", (1.6, -3.2, 3.6), (52, 0, 26), 2.5, 260, (0.93, 0.96, 1.0)),
        "Fill": area("Fill", (-2.6, -2.6, 1.8), (70, 0, -45), 3.0, 45, (0.55, 0.7, 1.0)),
        # strong blue rims from behind left/right
        "RimL": area("RimL", (-2.4, 1.6, 2.2), (70, 0, -125), 0.6, 300, (0.25, 0.45, 1.0), "RECTANGLE", 3.0),
        "RimR": area("RimR", (2.4, 1.6, 2.2), (70, 0, 125), 0.6, 300, (0.25, 0.45, 1.0), "RECTANGLE", 3.0),
        "Top": area("Top", (0, 0.2, 4.5), (0, 0, 0), 2.0, 90, (0.85, 0.9, 1.0)),
        # glow on the backdrop behind the figure
        "Wash": area("Wash", (0, 2.0, 0.6), (95, 0, 0), 5.0, 1400, (0.15, 0.3, 1.0)),
    }
    return floor, wall, lights


def add_camera(loc=(0, -5.2, 1.15), target=(0, 0, 1.0), lens=50):
    cd = bpy.data.cameras.new("Cam"); cd.lens = lens
    cd.sensor_fit = "VERTICAL"; cd.sensor_height = 24 * 16 / 9 / 1.0
    cam = bpy.data.objects.new("Cam", cd); _link(cam)
    cam.location = loc
    tgt = bpy.data.objects.new("CamTarget", None); _link(tgt); tgt.location = target
    c = cam.constraints.new("TRACK_TO"); c.target = tgt
    c.track_axis = "TRACK_NEGATIVE_Z"; c.up_axis = "UP_Y"
    bpy.context.scene.camera = cam
    return cam, tgt


# ---------------------------------------------------------------- equipment
def black_metal():
    return bpy.data.materials.get("BlackMetal") or mat_simple("BlackMetal", (0.012, 0.012, 0.014, 1), 0.28, 0.6, 0.4)


def chrome():
    return bpy.data.materials.get("Chrome") or mat_simple("Chrome", (0.8, 0.8, 0.82, 1), 0.12, 1.0)


def rubber():
    m = bpy.data.materials.get("Rubber")
    if not m:
        m = mat_simple("Rubber", (0.004, 0.004, 0.005, 1), 0.7)
        m.node_tree.nodes["Principled BSDF"].inputs["Specular IOR Level"].default_value = 0.25
    return m


def add_mat(size=(1.6, 2.4), loc=(0, 0.05, 0), text=None):
    bpy.ops.mesh.primitive_cube_add(size=1, location=(loc[0], loc[1], 0.006))
    m = bpy.context.active_object; m.name = "Mat"
    m.scale = (size[0], size[1], 0.012)
    bpy.ops.object.transform_apply(scale=True)
    m.data.materials.append(rubber())
    bevel(m, 0.004)
    if text:
        bpy.ops.object.text_add(location=(loc[0] + size[0] / 2 - 0.12, loc[1] - size[1] / 2 + 0.6, 0.0125))
        t = bpy.context.active_object; t.data.body = text
        t.data.size = 0.11; t.data.align_x = "CENTER"
        t.rotation_euler = (0, 0, math.radians(-90))
        t.data.materials.append(mat_simple("MatText", (0.8, 0.8, 0.8, 1), 0.6))
    return m


def add_barbell(name="Barbell", length=2.2, plates=2, plate_r=0.225):
    """Barbell along X, centred at origin. Returns parent empty."""
    root = bpy.data.objects.new(name, None); _link(root)
    parts = []
    bar = add_mesh_primitive("cyl", name + "_bar", chrome(), vertices=24, radius=0.014, depth=length)
    bar.rotation_euler = (0, math.radians(90), 0); parts.append(bar)
    for s in (-1, 1):
        sl = add_mesh_primitive("cyl", name + "_sleeve", chrome(), vertices=24, radius=0.025, depth=0.4,
                                location=(s * (length / 2 - 0.2), 0, 0))
        sl.rotation_euler = (0, math.radians(90), 0); parts.append(sl)
        col = add_mesh_primitive("cyl", name + "_collar", chrome(), vertices=24, radius=0.04, depth=0.03,
                                 location=(s * (length / 2 - 0.42), 0, 0))
        col.rotation_euler = (0, math.radians(90), 0); parts.append(col)
        for i in range(plates):
            r = plate_r if i == 0 else plate_r * 0.82
            p = add_mesh_primitive("cyl", name + "_plate", black_metal(), vertices=64, radius=r, depth=0.045,
                                   location=(s * (length / 2 - 0.375 + i * 0.05), 0, 0))
            p.rotation_euler = (0, math.radians(90), 0)
            bevel(p, 0.006, 3); parts.append(p)
            hub = add_mesh_primitive("cyl", name + "_hub", chrome(), vertices=32, radius=0.06, depth=0.05,
                                     location=p.location)
            hub.rotation_euler = p.rotation_euler; parts.append(hub)
    for p in parts:
        bpy.context.scene.collection.objects.unlink(p) if False else None
        p.parent = root
        for poly in p.data.polygons:
            poly.use_smooth = True
    return root


def add_dumbbell(name="Dumbbell", handle=0.14, r=0.065):
    root = bpy.data.objects.new(name, None); _link(root)
    h = add_mesh_primitive("cyl", name + "_h", chrome(), vertices=20, radius=0.016, depth=handle + 0.12)
    h.rotation_euler = (0, math.radians(90), 0); h.parent = root
    for s in (-1, 1):
        for i, (rr, d) in enumerate(((r, 0.035), (r * 0.85, 0.03))):
            hd = add_mesh_primitive("cyl", name + "_w", black_metal(), vertices=6 if i == 0 else 32,
                                    radius=rr, depth=d, location=(s * (handle / 2 + 0.02 + i * 0.033), 0, 0))
            hd.rotation_euler = (0, math.radians(90), 0); hd.parent = root
            bevel(hd, 0.004)
    return root


def add_rack(width=1.25, depth=1.0, height=2.3, loc=(0, 0.15, 0)):
    """Black power rack / smith-style frame."""
    root = bpy.data.objects.new("Rack", None); _link(root); root.location = loc
    up = 0.06
    for sx in (-1, 1):
        for sy in (-1, 1):
            p = add_mesh_primitive("cube", "Upright", black_metal(), size=1,
                                   location=(sx * width / 2, sy * depth / 2, height / 2))
            p.scale = (up, up, height); bpy.ops.object.transform_apply(scale=True); bevel(p, 0.006)
            p.parent = root
            # holes / pegs
            for k in range(14):
                peg = add_mesh_primitive("cyl", "Peg", black_metal(), vertices=12, radius=0.012, depth=0.12,
                                         location=(sx * (width / 2 + 0.06), sy * depth / 2, 0.45 + k * 0.1))
                peg.rotation_euler = (0, math.radians(90), 0); peg.parent = root
        # side beams
        for z in (0.03, height - 0.03):
            b = add_mesh_primitive("cube", "Beam", black_metal(), size=1, location=(sx * width / 2, 0, z))
            b.scale = (up, depth, up); bpy.ops.object.transform_apply(scale=True); bevel(b, 0.006); b.parent = root
        # base feet
        f = add_mesh_primitive("cube", "Foot", black_metal(), size=1, location=(sx * width / 2, 0, 0.03))
        f.scale = (0.1, depth + 0.5, 0.06); bpy.ops.object.transform_apply(scale=True); bevel(f, 0.008); f.parent = root
        # weight horns
        for k in range(3):
            hrn = add_mesh_primitive("cyl", "Horn", black_metal(), vertices=24, radius=0.025, depth=0.22,
                                     location=(sx * (width / 2 + 0.14), -depth / 2 + 0.1, 0.5 + k * 0.32))
            hrn.rotation_euler = (0, math.radians(90), 0); hrn.parent = root
    for sy in (-1, 1):
        t = add_mesh_primitive("cube", "Top", black_metal(), size=1, location=(0, sy * depth / 2, height - 0.03))
        t.scale = (width, up, up); bpy.ops.object.transform_apply(scale=True); bevel(t, 0.006); t.parent = root
    return root


def add_bench(loc=(0, 0, 0), incline_deg=0.0, length=1.2):  # noqa: C901
    root = bpy.data.objects.new("Bench", None); _link(root); root.location = loc
    pad_mat = mat_simple("Pad", (0.01, 0.01, 0.012, 1), 0.45, 0.0, 0.2)
    pad = add_mesh_primitive("cube", "Pad", pad_mat, size=1, location=(0, 0, 0.44))
    pad.scale = (0.3, length, 0.08); bpy.ops.object.transform_apply(scale=True); bevel(pad, 0.02, 4)
    pad.parent = root
    for y in (-length / 2 + 0.1, length / 2 - 0.1):
        leg = add_mesh_primitive("cube", "BenchLeg", black_metal(), size=1, location=(0, y, 0.2))
        leg.scale = (0.06, 0.06, 0.4); bpy.ops.object.transform_apply(scale=True); bevel(leg); leg.parent = root
        ft = add_mesh_primitive("cube", "BenchFoot", black_metal(), size=1, location=(0, y, 0.025))
        ft.scale = (0.45, 0.07, 0.05); bpy.ops.object.transform_apply(scale=True); bevel(ft); ft.parent = root
    rail = add_mesh_primitive("cube", "Rail", black_metal(), size=1, location=(0, 0, 0.37))
    rail.scale = (0.06, length - 0.1, 0.06); bpy.ops.object.transform_apply(scale=True); bevel(rail); rail.parent = root
    return root


# ---------------------------------------------------------------- more equipment (Bodyformance library)
def add_kettlebell(name="Kettlebell", r=0.085):
    root = bpy.data.objects.new(name, None); _link(root)
    body = add_mesh_primitive("sphere", name + "_b", black_metal(), segments=32, ring_count=16, radius=r,
                              location=(0, 0, -0.04 - r))
    body.parent = root
    h = add_mesh_primitive("torus", name + "_h", black_metal(), major_radius=0.055, minor_radius=0.012,
                           location=(0, 0, -0.02))
    h.rotation_euler = (math.radians(90), 0, 0); h.parent = root
    for o in (body, h):
        for p in o.data.polygons:
            p.use_smooth = True
    return root


def add_medball(r=0.12):
    mat = bpy.data.materials.get("MedBall") or mat_simple("MedBall", (0.02, 0.025, 0.04, 1), 0.7)
    b = add_mesh_primitive("sphere", "MedBall", mat, segments=32, ring_count=16, radius=r)
    for p in b.data.polygons:
        p.use_smooth = True
    return b


def add_line(kind="band", radius=0.008):
    """Unit-length cylinder along local X, scaled per frame between two points."""
    colors = {"band": ((0.9, 0.35, 0.05, 1), 0.6), "cable": ((0.02, 0.02, 0.02, 1), 0.3),
              "sling": ((0.03, 0.03, 0.035, 1), 0.7), "bar": ((0.55, 0.56, 0.6, 1), 0.25),
              "rope": ((0.02, 0.02, 0.022, 1), 0.8)}
    col, rough = colors.get(kind, colors["band"])
    mat = bpy.data.materials.get("Line_" + kind) or mat_simple("Line_" + kind, col, rough)
    bpy.ops.mesh.primitive_cylinder_add(vertices=12, radius=radius if kind != "sling" else 0.018, depth=1.0)
    ob = bpy.context.active_object; ob.name = "Line_" + kind
    for v in ob.data.vertices:            # align cylinder to X
        x, y, z = v.co; v.co = (z, y, -x)
    if kind == "sling":
        for v in ob.data.vertices:
            v.co.z *= 0.35
    ob.data.materials.append(mat)
    for p in ob.data.polygons:
        p.use_smooth = True
    return ob


def add_cable_tower(loc=(0, 0.9, 0), height=2.2):
    root = bpy.data.objects.new("CableTower", None); _link(root); root.location = loc
    col = add_mesh_primitive("cube", "TowerCol", black_metal(), size=1, location=(0, 0, height / 2))
    col.scale = (0.16, 0.16, height); bpy.ops.object.transform_apply(scale=True); bevel(col, 0.01); col.parent = root
    base = add_mesh_primitive("cube", "TowerBase", black_metal(), size=1, location=(0, 0, 0.03))
    base.scale = (0.6, 0.6, 0.06); bpy.ops.object.transform_apply(scale=True); bevel(base, 0.01); base.parent = root
    for z in (0.25, 1.1, 2.0):
        pul = add_mesh_primitive("cyl", "Pulley", chrome(), vertices=24, radius=0.045, depth=0.03,
                                 location=(0, -0.1, z))
        pul.rotation_euler = (0, math.radians(90), 0); pul.parent = root
    return root


def add_box(loc, size, rot=(0, 0, 0)):
    pad = bpy.data.materials.get("Pad") or mat_simple("Pad", (0.01, 0.01, 0.012, 1), 0.45, 0.0, 0.2)
    b = add_mesh_primitive("cube", "Box", pad, size=1, location=loc)
    b.scale = size; bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    b.rotation_euler = [math.radians(a) for a in rot]
    bevel(b, 0.015, 3)
    return b


def add_foam(loc=(0, 0, 0.075), rot=(0, 90, 0)):
    mat = bpy.data.materials.get("Foam") or mat_simple("Foam", (0.02, 0.05, 0.2, 1), 0.8)
    f = add_mesh_primitive("cyl", "FoamRoller", mat, vertices=32, radius=0.075, depth=0.9, location=loc)
    f.rotation_euler = [math.radians(a) for a in rot]
    for p in f.data.polygons:
        p.use_smooth = True
    return f


def add_rope():
    cd = bpy.data.curves.new("JumpRope", "CURVE"); cd.dimensions = "3D"
    cd.bevel_depth = 0.01; cd.bevel_resolution = 3
    sp = cd.splines.new("BEZIER"); sp.bezier_points.add(2)
    for bp in sp.bezier_points:
        bp.handle_left_type = bp.handle_right_type = "AUTO"
    ob = bpy.data.objects.new("JumpRope", cd); _link(ob)
    cd.materials.append(bpy.data.materials.get("Line_cable") or mat_simple("Line_cable", (0.02, 0.02, 0.02, 1), 0.3))
    return ob


def key_rope(ob, pl, pr, phase, frame):
    """Rope arc between the hands, rotating around the body (phase 0..1 per turn)."""
    from mathutils import Vector
    mid = (pl + pr) / 2
    a = 2 * math.pi * phase
    bottom = Vector((mid.x, mid.y + 0.25 * math.sin(a) - 0.05, max(0.02, mid.z - (mid.z - 0.02) * (0.5 + 0.5 * math.cos(a)) * 1.0)))
    bottom.z = mid.z + (0.02 - mid.z) * (0.5 + 0.5 * math.cos(a)) + 1.15 * max(0.0, -math.cos(a)) * 0.6
    bottom.y = mid.y - 0.35 * math.sin(a)
    pts = ob.data.splines[0].bezier_points
    for bp, co in zip(pts, (pl, bottom, pr)):
        bp.co = co
        bp.keyframe_insert("co", frame=frame)
        bp.handle_left_type = bp.handle_right_type = "AUTO"


def add_dipbars(width=0.54, z=1.12, length=0.95, y=0.0):
    root = bpy.data.objects.new("DipBars", None); _link(root)
    for sg in (1, -1):
        bar = add_mesh_primitive("cyl", "DipBar", chrome(), vertices=20, radius=0.02, depth=length,
                                 location=(sg * width / 2, y, z))
        bar.rotation_euler = (math.radians(90), 0, 0); bar.parent = root
        for yy in (-length / 2 + 0.06, length / 2 - 0.06):
            post = add_mesh_primitive("cube", "DipPost", black_metal(), size=1, location=(sg * (width / 2 + 0.05), y + yy, z / 2))
            post.scale = (0.05, 0.05, z); bpy.ops.object.transform_apply(scale=True); bevel(post); post.parent = root
        foot_ = add_mesh_primitive("cube", "DipFoot", black_metal(), size=1, location=(sg * (width / 2 + 0.05), y, 0.025))
        foot_.scale = (0.08, length + 0.1, 0.05); bpy.ops.object.transform_apply(scale=True); bevel(foot_); foot_.parent = root
    return root
