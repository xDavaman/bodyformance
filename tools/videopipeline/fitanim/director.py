"""Builds a complete shot for an exercise: figure, studio, props, baked animation,
camera move, muscle highlight timing and neon arrows. Then renders frames."""
import math, os, time
import bpy
from mathutils import Vector, Matrix, Quaternion, Euler

from . import scene as S, character as C, poser as PZ, exercises as EX, collide as CO

QUALITY = {
    "preview": dict(w=360, h=640, samples=8, subdiv=1),
    "draft": dict(w=540, h=960, samples=12, subdiv=1),
    "final": dict(w=720, h=1280, samples=24, subdiv=1),
    "hd": dict(w=1080, h=1920, samples=48, subdiv=2),
}

CAMERAS = {
    # name: (loc start, loc end, target start, target end, lens)
    "front": ((0.0, -4.9, 1.30), (0.0, -4.4, 1.22), (0, 0, 1.05), (0, 0, 0.98), 42),
    "front34": ((2.1, -4.3, 1.35), (1.5, -3.9, 1.25), (0, -0.2, 0.95), (0, -0.2, 0.9), 42),
    "front34_close": ((1.3, -3.0, 1.45), (0.9, -2.6, 1.40), (0, 0, 1.12), (0, 0, 1.10), 45),
    "side34": ((3.6, -2.6, 1.25), (3.2, -2.1, 1.15), (0, 0.05, 0.85), (0, 0.05, 0.8), 42),
    "side_low": ((2.9, -2.9, 1.05), (2.5, -2.4, 0.95), (0, -0.45, 0.32), (0, -0.45, 0.30), 36),
    "back34": ((2.0, 4.4, 1.75), (1.5, 3.9, 1.70), (0, 0, 1.55), (0, 0, 1.55), 40),
}


def _key_matrix(ob, m, frame):
    ob.matrix_world = m
    ob.keyframe_insert("location", frame=frame)
    ob.rotation_mode = "QUATERNION"
    ob.keyframe_insert("rotation_quaternion", frame=frame)


def _mat_from_axes(origin, x, z_hint=Vector((0, 0, 1))):
    x = x.normalized()
    z = (z_hint - x * z_hint.dot(x))
    if z.length < 1e-5:
        z = Vector((0, 1, 0)) - x * x.y
    z.normalize()
    y = z.cross(x)
    m = Matrix((x, y, z)).transposed().to_4x4()
    m.translation = origin
    return m


# ------------------------------------------------------------------ arrows
def make_arrow(name, p0, p1, color, radius=0.012, dashes=6, head=0.07):
    """Neon arrow from p0 to p1 (dashed shaft + cone head). Returns (root, mix-node)."""
    p0, p1 = Vector(p0), Vector(p1)
    mat = bpy.data.materials.new(name + "_mat")
    mat.use_nodes = True
    nt = mat.node_tree; N = nt.nodes; L = nt.links
    for n in list(N):
        N.remove(n)
    out = N.new("ShaderNodeOutputMaterial")
    em = N.new("ShaderNodeEmission"); em.inputs[0].default_value = (*color, 1); em.inputs[1].default_value = 9.0
    tr = N.new("ShaderNodeBsdfTransparent")
    mix = N.new("ShaderNodeMixShader"); mix.name = "VIS"
    mix.inputs[0].default_value = 0.0
    L.new(tr.outputs[0], mix.inputs[1]); L.new(em.outputs[0], mix.inputs[2]); L.new(mix.outputs[0], out.inputs[0])
    root = bpy.data.objects.new(name, None); bpy.context.scene.collection.objects.link(root)
    d = p1 - p0; length = d.length; u = d.normalized()
    shaft_len = length - head
    rot = u.to_track_quat("Z", "Y")
    n = max(1, dashes)
    gap = 0.35
    seg_len = shaft_len / (n + (n - 1) * gap)
    for i in range(n):
        a = p0 + u * (i * seg_len * (1 + gap))
        c = a + u * seg_len / 2
        bpy.ops.mesh.primitive_cylinder_add(vertices=12, radius=radius, depth=seg_len, location=c)
        ob = bpy.context.active_object; ob.rotation_mode = "QUATERNION"; ob.rotation_quaternion = rot
        ob.data.materials.append(mat); ob.parent = root
        ob.visible_shadow = False
    bpy.ops.mesh.primitive_cone_add(vertices=16, radius1=radius * 3.2, depth=head, location=p1 - u * head / 2)
    cone = bpy.context.active_object; cone.rotation_mode = "QUATERNION"; cone.rotation_quaternion = rot
    cone.data.materials.append(mat); cone.parent = root; cone.visible_shadow = False
    return root, mix


ARROW_COLORS = {"blue": (0.25, 0.6, 1.0), "red": (1.0, 0.08, 0.05), "green": (0.1, 1.0, 0.35),
                "white": (0.9, 0.95, 1.0)}


def arrows_for(ex, spec):
    k = spec["kind"]; col = ARROW_COLORS[spec.get("color", "blue")]
    made = []
    if k == "spine_down":
        made.append(make_arrow("ArrowSpine", (0, -0.42, 2.02), (0, -0.42, 1.55), col, 0.01, 5))
    elif k == "feet_out":
        for sg in (1, -1):
            made.append(make_arrow("ArrowFoot", (sg * 0.30, -0.32, 0.03), (sg * 0.46, -0.62, 0.03), col, 0.011, 3, 0.08))
    elif k == "body_down":
        made.append(make_arrow("ArrowDown", (0.0, -0.72, 1.0), (0.0, -0.72, 0.66), col, 0.011, 4))
    elif k == "up_both":
        for sg in (1, -1):
            made.append(make_arrow("ArrowUp", (sg * 0.55, -0.1, 1.55), (sg * 0.55, -0.1, 2.05), col, 0.011, 4))
    elif k == "bench_up":
        for sg in (1, -1):
            made.append(make_arrow("ArrowBench", (sg * 0.62, 0.5, 0.85), (sg * 0.62, 0.6, 1.2), col, 0.011, 3))
    elif k == "hips_up":
        made.append(make_arrow("ArrowHips", (0.32, -0.15, 0.30), (0.32, -0.15, 0.62), col, 0.011, 3))
    return made


# ------------------------------------------------------------------ build
class Shot:
    def __init__(self, ex_key, quality="preview", reps=None, handle=None, camera=None, reel=False,
                 profile=None, overrides=None):
        self.profile, self.overrides = profile, overrides
        self.ex = ex_key if isinstance(ex_key, EX.Exercise) else EX.LIBRARY[ex_key]()
        if reps:
            self.ex.reps = reps
        self.q = QUALITY[quality]
        self.camera_name = camera or self.ex.camera
        self.handle = handle
        self.reel = reel

    def build(self):
        S.reset()
        sc = self.scene = bpy.context.scene
        S.setup_render(sc, self.q["w"], self.q["h"], samples=self.q["samples"])
        self.body, self.rig = C.build_character(subdiv=self.q["subdiv"], profile=self.profile,
                                                overrides=self.overrides)
        mp = C.load_profile(self.profile, self.overrides).get("material", {})
        self.mat = S.mat_porcelain(muscles=self.ex.muscles, roughness=mp.get("roughness"), coat=mp.get("coat"),
                                   sheen=mp.get("sheen"), base=mp.get("base"))
        self.body.data.materials.append(self.mat)
        self.hl_node = self.mat.node_tree.nodes["HL"]
        S.build_studio()
        self.poser = PZ.Poser(self.rig)
        self.ctx = {"poser": self.poser}
        self.corr = CO.corrector_for(self.poser, self.body)
        configure_corrector(self.corr, self.ex)
        self.ctx["corr"] = self.corr
        self.props = []
        for p in self.ex.props:
            self.props.append((p, self._make_prop(p)))
        self.arrows = []
        for a in self.ex.arrows:
            for root, mix in arrows_for(self.ex, a):
                self.arrows.append((a, mix, [root] + list(root.children)))
        self.cam, self.cam_tgt = S.add_camera()
        if self.camera_name.startswith("back"):
            ld = bpy.data.lights.new("Wash2", "AREA"); ld.energy = 1400; ld.size = 5; ld.color = (0.15, 0.3, 1.0)
            w2 = bpy.data.objects.new("Wash2", ld); self.scene.collection.objects.link(w2)
            w2.location = (0, -2.0, 0.6); w2.rotation_euler = (math.radians(-95), 0, 0)
        return self

    def _make_prop(self, p):
        t = p["type"]
        if t == "rack":
            return S.add_rack(height=p.get("height", 2.3))
        if t == "mat":
            return S.add_mat(size=p.get("size", (1.6, 2.2)), loc=p.get("loc", (0, 0.05, 0)), text=p.get("text"))
        if t == "barbell":
            return S.add_barbell(plates=p.get("plates", 2), length=p.get("length", 2.2))
        if t == "dumbbell":
            return S.add_dumbbell(name="Dumbbell" + p["hand"])
        if t == "bench":
            return S.add_bench(loc=p.get("loc", (0, 0, 0)), length=p.get("length", 1.2))
        if t == "kettlebell":
            return S.add_kettlebell(name="Kettlebell" + p["hand"])
        if t == "medball":
            return S.add_medball()
        if t == "line":          # band / cable / sling strap between a hand and an anchor
            return S.add_line(p.get("color", "band"), p.get("radius", 0.008))
        if t == "cable_tower":
            return S.add_cable_tower(loc=p.get("loc", (0, 0.9, 0)))
        if t == "box":
            if "follow" in p:          # moving machine part (pad / platform) that follows the body
                return S.add_box(loc=(0, 0, 0), size=p["size"], rot=(0, 0, 0))
            return S.add_box(loc=p["loc"], size=p["size"], rot=p.get("rot", (0, 0, 0)))
        if t == "foam":
            return S.add_foam(loc=p.get("loc", (0, 0, 0.075)), rot=p.get("rot", (0, 90, 0)))
        if t == "rope":
            return S.add_rope()
        if t == "dipbars":
            return S.add_dipbars()
        if t == "pullbar":
            bar = S.add_mesh_primitive("cyl", "PullBar", S.chrome(), vertices=24, radius=0.016, depth=1.32,
                                       location=(0, -0.05, p.get("z", 2.32)))
            bar.rotation_euler = (0, math.radians(90), 0)
            for poly in bar.data.polygons:
                poly.use_smooth = True
            return bar
        raise ValueError(t)

    # -------------------------------------------------------------- timing
    def frames(self):
        fps = self.scene.render.fps
        total = self.ex.intro + self.ex.reps * self.ex.rep_time + 0.6
        return int(round(total * fps))

    def phase_at(self, t):
        ex = self.ex
        if t < ex.intro:
            return 0.0, 0
        u = t - ex.intro
        rep = int(u // ex.rep_time)
        if rep >= ex.reps:            # hold the end of the last rep (continuous for non-cyclic motions)
            return 0.9999, ex.reps - 1
        return (u - rep * ex.rep_time) / ex.rep_time, rep

    # -------------------------------------------------------------- bake
    def bake(self):
        sc = self.scene
        fps = sc.render.fps
        n = self.frames()
        sc.frame_start, sc.frame_end = 1, n
        t0 = time.time()
        for f in range(1, n + 1):
            t = (f - 1) / fps
            P, posed = frame_pose(self.ex, self, t, self.ctx)
            ph, rep = self.phase_at(t)
            self.poser.apply(posed, frame=f)
            self._props_at(posed, P, f)
            # highlight
            fade = EX.ss(t / max(0.01, self.ex.intro + 0.3))
            hl = self.ex.intensity(ph) * fade
            self.hl_node.outputs[0].default_value = hl
            self.hl_node.outputs[0].keyframe_insert("default_value", frame=f)
            for spec, mix, obs in self.arrows:
                vis = self._arrow_vis(spec, t, ph)
                mix.inputs[0].default_value = vis
                mix.inputs[0].keyframe_insert("default_value", frame=f)
                for o in obs:                       # fully hidden when invisible (no dark artefacts)
                    o.hide_render = vis < 0.01
                    o.keyframe_insert("hide_render", frame=f)
        self._camera(n)
        print(f"[fitanim] baked {n} frames in {time.time() - t0:.1f}s")
        return n

    def _arrow_vis(self, spec, t, ph):
        if spec.get("intro"):
            # visible in the intro, fades out with the first rep
            return 1.0 - EX.ss((t - self.ex.intro) / 0.4)
        a, b = spec.get("when", (0, 1))
        if t < self.ex.intro:
            return 0.0
        fade = 0.06
        return EX.ss((ph - a) / fade) * (1 - EX.ss((ph - b) / fade + 1))

    def _props_at(self, posed, P, f):
        pz = self.poser
        for spec, ob in self.props:
            t = spec["type"]
            if "follow" in spec:
                pts = [_body_point(posed, n) for n in spec["follow"]]
                pos = sum(pts, Vector()) / len(pts) + Vector(spec.get("offset", (0, 0, 0)))
                m = Euler([math.radians(a) for a in spec.get("rot", (0, 0, 0))], "XYZ").to_matrix().to_4x4()
                m.translation = pos
                _key_matrix(ob, m, f)
                continue
            if t == "barbell":
                if spec.get("mode") == "chest":
                    M = posed["spine01"] @ pz.rest["spine01"].inverted()
                    pos = M @ Vector(spec["pos"])
                    x = (M.to_3x3() @ Vector((1, 0, 0)))
                    _key_matrix(ob, _mat_from_axes(pos, x), f)
                else:
                    pl, pr = posed["_palmL"], posed["_palmR"]
                    mid = (pl + pr) / 2
                    _key_matrix(ob, _mat_from_axes(mid, pl - pr), f)
            elif t == "kettlebell":
                s = spec["hand"]
                if s == "M":            # held with both hands
                    pl, pr = posed["_palmL"], posed["_palmR"]
                    _key_matrix(ob, _mat_from_axes((pl + pr) / 2, pl - pr, Vector((0, 0, 1))), f)
                    continue
                w = posed[f"wrist.{s}"]
                across = w.to_3x3() @ Vector(pz._across_local[s])
                _key_matrix(ob, _mat_from_axes(posed["_palm" + s], across, Vector((0, 0, 1))), f)
            elif t == "medball":
                mid = (posed["_palmL"] + posed["_palmR"]) / 2
                fwd = (posed["spine01"].to_3x3() @ Vector((0, 0, 1)))       # bone Z ~ front of chest
                _key_matrix(ob, _mat_from_axes(mid + fwd.normalized() * spec.get("offset", 0.06), Vector((1, 0, 0))), f)
            elif t == "line":
                a = _body_point(posed, spec["from"]) if "from" in spec else posed["_palm" + spec["hand"]]
                b = Vector(spec["anchor"]) if "anchor" in spec else posed["_palm" + spec["to_hand"]]
                if spec.get("anchor_space") == "foot":
                    b = posed[f"foot.{spec['foot']}"].translation + Vector(spec.get("foot_offset", (0, -0.08, -0.06)))
                d = b - a
                m = _mat_from_axes((a + b) / 2, d, Vector((0, 0, 1)) if abs(d.normalized().z) < 0.95 else Vector((0, 1, 0)))
                ob.matrix_world = m
                ob.scale = (max(0.001, d.length), 1, 1)
                ob.keyframe_insert("location", frame=f); ob.rotation_mode = "QUATERNION"
                ob.keyframe_insert("rotation_quaternion", frame=f); ob.keyframe_insert("scale", frame=f)
            elif t == "rope":
                S.key_rope(ob, posed["_palmL"], posed["_palmR"], P.get("_rope_phase", 0.0), f)
            elif t == "dumbbell" and spec["hand"] == "M":      # one dumbbell held with both hands
                pl, pr = posed["_palmL"], posed["_palmR"]
                _key_matrix(ob, _mat_from_axes((pl + pr) / 2, pl - pr, Vector((0, 0, 1))), f)
            elif t == "dumbbell":
                s = spec["hand"]
                w = posed[f"wrist.{s}"]
                across = w.to_3x3() @ Vector(pz._across_local[s])
                fdir = w.to_3x3() @ Vector(pz._fdir_local[s])
                _key_matrix(ob, _mat_from_axes(posed["_palm" + s], across, fdir), f)

    def _preset(self, name):
        if name == self.ex.camera and getattr(self.ex, "cam", None):
            return self.ex.cam
        if isinstance(name, tuple):
            return name
        return CAMERAS[name]

    def _camera(self, n):
        fps = self.scene.render.fps
        if self.reel and getattr(self.ex, "reel", None):
            names = self.ex.reel
            # cut at every rep boundary (first segment includes the intro)
            bounds = [1]
            for r in range(1, self.ex.reps):
                bounds.append(int(round((self.ex.intro + r * self.ex.rep_time) * fps)) + 1)
            bounds.append(n + 1)
            segs = [(names[i % len(names)], bounds[i], bounds[i + 1] - 1) for i in range(len(bounds) - 1)]
        else:
            segs = [(self.camera_name, 1, n)]
        for name, f0, f1 in segs:
            a, b, ta, tb, lens = self._preset(name)
            for f, (loc, tg) in ((f0, (a, ta)), (f1, (b, tb))):
                self.cam.location = loc; self.cam.keyframe_insert("location", frame=f)
                self.cam_tgt.location = tg; self.cam_tgt.keyframe_insert("location", frame=f)
                self.cam.data.lens = lens; self.cam.data.keyframe_insert("lens", frame=f)
        for ob in (self.cam, self.cam_tgt, self.cam.data):
            if ob.animation_data and ob.animation_data.action:
                _set_interp(ob.animation_data.action, "SINE")

    # -------------------------------------------------------------- render
    def render(self, out_dir, frames=None, every=1):
        os.makedirs(out_dir, exist_ok=True)
        sc = self.scene
        fr = frames or range(sc.frame_start, sc.frame_end + 1, every)
        t0 = time.time()
        for i, f in enumerate(fr):
            sc.frame_set(f)
            sc.render.filepath = os.path.join(out_dir, f"f_{f:04d}.png")
            bpy.ops.render.render(write_still=True)
            if i % 10 == 0:
                el = time.time() - t0
                print(f"[fitanim] frame {f} ({i + 1}/{len(fr)}) {el / (i + 1):.1f}s/frame", flush=True)
        return out_dir

    def render_muscle_card(self, path, size=(260, 470)):
        """Front + back thumbnails of the figure with the target muscles lit (for the overlay)."""
        sc = self.scene
        keep = (sc.render.resolution_x, sc.render.resolution_y, sc.camera, sc.render.film_transparent)
        # neutral pose
        P = EX.arms_down(EX.stand(0.13, 6), 0.27, 0.87)
        posed = self.poser.solve(P)
        self.poser.apply(posed)
        hidden = []
        for ob in sc.objects:
            if ob.type in ("MESH", "CURVE", "FONT") and ob != self.body and not ob.hide_render:
                ob.hide_render = True; hidden.append(ob)
        if self.body.animation_data:
            pass
        fc = self.mat.node_tree.animation_data
        sc.render.film_transparent = True
        sc.render.resolution_x, sc.render.resolution_y = size
        cd = bpy.data.cameras.new("CardCam"); cd.type = "ORTHO"; cd.ortho_scale = 2.05
        cam = bpy.data.objects.new("CardCam", cd); sc.collection.objects.link(cam)
        sc.camera = cam
        outs = []
        old_hl_action = None
        for name, loc, rot in (("front", (0, -6, 0.97), (90, 0, 0)), ("back", (0, 6, 0.97), (90, 0, 180))):
            cam.location = loc; cam.rotation_euler = [math.radians(r) for r in rot]
            p = path.replace(".png", f"_{name}.png")
            sc.render.filepath = p
            # force full highlight on a still frame: temporarily mute HL animation
            self._render_still_hl(1.0)
            outs.append(p)
        # restore
        for ob in hidden:
            ob.hide_render = False
        sc.render.resolution_x, sc.render.resolution_y, sc.camera, sc.render.film_transparent = keep
        bpy.data.objects.remove(cam)
        return outs

    def _render_still_hl(self, value):
        nt = self.mat.node_tree
        ad = nt.animation_data
        act = ad.action if ad else None
        if ad:
            ad.action = None
        self.hl_node.outputs[0].default_value = value
        # pose bones also animated: render current frame after muting rig action
        rad = self.rig.animation_data
        ract = rad.action if rad else None
        if rad:
            rad.action = None
        bpy.ops.render.render(write_still=True)
        if ad:
            ad.action = act
        if rad:
            rad.action = ract

    def save(self, path):
        bpy.ops.wm.save_as_mainfile(filepath=os.path.abspath(path))

    def export_glb(self, path, web=False, with_props=True):
        """Animated, skinned GLB for apps / web / game engines.
        COLOR_0.r = highlight mask of this exercise's target muscles; every muscle is also
        exported as custom attribute _M_<NAME> (0..1) so the app can light any muscle."""
        import numpy as np
        me = self.body.data
        n = len(me.vertices)
        mask = np.zeros(n, np.float32)
        for m in self.ex.muscles:
            a = np.empty(n, np.float32); me.attributes["m_" + m].data.foreach_get("value", a)
            mask = np.maximum(mask, a)
        col = me.color_attributes.get("Target") or me.color_attributes.new("Target", "FLOAT_COLOR", "POINT")
        rgba = np.stack([mask, np.zeros(n), np.zeros(n), np.ones(n)], 1).astype(np.float32)
        col.data.foreach_set("color", rgba.ravel())
        me.color_attributes.active_color = col
        for k in ([] if web else list(self.body["fitanim_muscles"])):
            nm = "_M_" + k.upper()
            if nm not in me.attributes:
                a = np.empty(n, np.float32); me.attributes["m_" + k].data.foreach_get("value", a)
                me.attributes.new(nm, "FLOAT", "POINT").data.foreach_set("value", a)
        keep = {self.body, self.rig}
        if with_props:
            for _, root in self.props:
                keep.add(root)
                keep.update(root.children_recursive)
        for ob in bpy.context.scene.objects:
            ob.select_set(ob in keep)
        bpy.context.view_layer.objects.active = self.rig
        kw = dict(filepath=os.path.abspath(path), use_selection=True, export_apply=False,
                  export_animations=True, export_skins=True, export_attributes=not web)
        if web:
            kw.update(export_draco_mesh_compression_enable=True, export_draco_mesh_compression_level=7,
                      export_draco_position_quantization=12, export_draco_normal_quantization=8,
                      export_draco_color_quantization=8)
        try:
            bpy.ops.export_scene.gltf(**kw, export_vertex_color="ACTIVE")
        except TypeError:
            bpy.ops.export_scene.gltf(**kw, export_colors=True)


def _body_point(posed, name):
    """named body point for props: palmL, footL, kneeL, hipL, shinL, heelL, toeL, chest, pelvis, head."""
    s = name[-1] if name[-1] in "LR" else ""
    b = name[:-1] if s else name
    if b == "palm":
        return posed["_palm" + s].copy()
    table = {"foot": f"foot.{s}", "knee": f"lowerleg01.{s}", "hip": f"upperleg01.{s}", "toe": f"toe1-1.{s}",
             "wrist": f"wrist.{s}", "elbow": f"lowerarm01.{s}", "chest": "spine01", "pelvis": "root", "head": "head"}
    if b == "shin":
        return (posed[f"lowerleg01.{s}"].translation + posed[f"foot.{s}"].translation) / 2
    if b == "thigh":
        return (posed[f"upperleg01.{s}"].translation + posed[f"lowerleg01.{s}"].translation) / 2
    if b == "heel":
        return posed[f"foot.{s}"] @ Vector((0, -0.02, -0.05)) if False else posed[f"foot.{s}"].translation + Vector((0, 0.04, -0.05))
    return posed[table[b]].translation.copy()


def configure_corrector(corr, ex):
    """floor mats and two-handed implements of this exercise -> collision corrector settings."""
    corr.sup_rect = []
    for p in ex.props:
        if p["type"] == "mat":
            sx, sy = p.get("size", (1.6, 2.2)); lx, ly = p.get("loc", (0, 0.05, 0))[:2]
            corr.sup_rect.append((lx - sx / 2, lx + sx / 2, ly - sy / 2, ly + sy / 2, CO.MAT_TOP))
    corr.two_hand = any((p["type"] == "barbell" and p.get("mode") != "chest") or p["type"] in ("medball", "rope")
                        or (p["type"] in ("kettlebell", "dumbbell") and p.get("hand") == "M") for p in ex.props)
    # fixed equipment the hands hold on to (no free weight): don't lift the hands with the body
    corr.two_hand_fixed = any(p["type"] in ("pullbar", "dipbars", "rack", "cable", "line", "rings")
                              for p in ex.props)
    c = getattr(ex, "collide", True)
    corr.enabled = bool(c)
    corr.opts = c if isinstance(c, dict) else {}
    corr.prev = None
    return corr


def frame_pose(ex, timing, t, ctx):
    """The one place that turns time -> final pose (used by bake, lint, fingerprints, review)."""
    ph, rep = Shot.phase_at(timing, t)
    P = _alive(ex.pose(ph, rep, ctx), t)
    corr = ctx.get("corr")
    if corr is not None:
        return corr.solve(P, t=t)
    return P, ctx["poser"].solve(P)


def _alive(P, t):
    """Subtle 'life' layer on every pose: breathing in the spine/ribcage, tiny head and weight drift.
    Keeps the figure from looking frozen between and during reps."""
    P = dict(P)
    b, sd, tw = P.get("spine", (0, 0, 0))      # (bend, side, twist) - see poser.solve
    P["spine"] = (b + 1.1 * math.sin(2 * math.pi * t / 4.2), sd + 0.5 * math.sin(2 * math.pi * t / 5.3),
                  tw + 0.6 * math.sin(2 * math.pi * t / 7.1))
    n = P.get("neck", (0, 0, 0))
    P["neck"] = (n[0] + 0.8 * math.sin(2 * math.pi * t / 4.2 + 1.0), n[1] + 1.2 * math.sin(2 * math.pi * t / 8.3), n[2])
    return P


def _set_interp(action, mode):
    try:
        curves = action.fcurves
    except AttributeError:
        curves = []
        for layer in action.layers:
            for strip in layer.strips:
                for bag in strip.channelbags:
                    curves.extend(bag.fcurves)
    for fc in curves:
        for kp in fc.keyframe_points:
            kp.interpolation = mode
            kp.easing = "EASE_IN_OUT"
