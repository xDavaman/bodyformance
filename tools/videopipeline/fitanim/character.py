"""Build a rigged, faceless, muscular mannequin from the CC0 MakeHuman base mesh.

All geometry, shape targets, skeleton and skin weights come from the MakeHuman /
MPFB2 asset set (CC0). Everything else (head reshaping, muscle masks, material)
is generated procedurally here.
"""
import gzip, json, os, math
import numpy as np
import bpy
from mathutils import Vector
from . import sculpt as sculpt_mod

ASSETS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "assets")
SCALE = 0.1
BODY_VERTS = 13380  # verts 0..13379 are the body; the rest are helpers / joint cubes


# --------------------------------------------------------------------------- io
def _obj_to_blender(a):
    """MakeHuman OBJ space (y-up, decimetres) -> Blender (z-up, metres)."""
    return np.stack([a[:, 0], -a[:, 2], a[:, 1]], axis=1) * SCALE


def load_basemesh():
    verts, faces, uvs, face_uvs = [], [], [], []
    group = None
    with open(os.path.join(ASSETS, "3dobjs", "base.obj")) as f:
        for line in f:
            if line.startswith("v "):
                verts.append([float(x) for x in line.split()[1:4]])
            elif line.startswith("vt "):
                uvs.append([float(x) for x in line.split()[1:3]])
            elif line.startswith("g "):
                group = line.split()[1]
            elif line.startswith("f ") and group == "body":
                parts = [p.split("/") for p in line.split()[1:]]
                faces.append([int(p[0]) - 1 for p in parts])
                face_uvs.append([int(p[1]) - 1 if len(p) > 1 and p[1] else 0 for p in parts])
    return np.array(verts, dtype=np.float64), faces, np.array(uvs), face_uvs


def load_target(rel):
    path = os.path.join(ASSETS, "targets", rel)
    idx, d = [], []
    with gzip.open(path, "rt") as f:
        for line in f:
            p = line.split()
            if len(p) == 4 and not line.startswith("#"):
                idx.append(int(p[0])); d.append([float(x) for x in p[1:]])
    return np.array(idx), np.array(d)


def vertex_groups_meta():
    with open(os.path.join(ASSETS, "mesh_metadata", "basemesh_vertex_groups.json")) as f:
        raw = json.load(f)
    out = {}
    for k, ranges in raw.items():
        ids = []
        for a, b in ranges:
            ids.extend(range(a, b + 1))
        out[k] = ids
    return out


# ----------------------------------------------------------------- body shape
DEFAULT_BODY = {
    # weights of MakeHuman macro targets (sum per family ~= 1)
    "macrodetails/universal-male-young-maxmuscle-minweight.target.gz": 0.55,
    "macrodetails/universal-male-young-maxmuscle-averageweight.target.gz": 0.45,
    "macrodetails/caucasian-male-young.target.gz": 0.34,
    "macrodetails/african-male-young.target.gz": 0.33,
    "macrodetails/asian-male-young.target.gz": 0.33,
    "macrodetails/proportions/male-young-maxmuscle-minweight-idealproportions.target.gz": 0.55,
    "macrodetails/proportions/male-young-maxmuscle-averageweight-idealproportions.target.gz": 0.45,
    # athletic detail: wide delts, defined arms/legs, narrow waist
    "arms/l-upperarm-shoulder-muscle-incr.target.gz": 0.7,
    "arms/r-upperarm-shoulder-muscle-incr.target.gz": 0.7,
    "arms/l-upperarm-muscle-incr.target.gz": 0.5,
    "arms/r-upperarm-muscle-incr.target.gz": 0.5,
    "arms/l-lowerarm-muscle-incr.target.gz": 0.4,
    "arms/r-lowerarm-muscle-incr.target.gz": 0.4,
    "legs/l-upperleg-muscle-incr.target.gz": 0.6,
    "legs/r-upperleg-muscle-incr.target.gz": 0.6,
    "legs/l-lowerleg-muscle-incr.target.gz": 0.5,
    "legs/r-lowerleg-muscle-incr.target.gz": 0.5,
    "neck/neck-scale-vert-incr.target.gz": 0.15,
}


def apply_targets(base, targets):
    v = base.copy()
    for rel, w in targets.items():
        if not os.path.exists(os.path.join(ASSETS, "targets", rel)):
            print("[fitanim] missing target", rel)
            continue
        idx, d = load_target(rel)
        v[idx] += d * w
    return v


# ------------------------------------------------------------ mesh utilities
def build_adjacency(faces, n):
    nb = [set() for _ in range(n)]
    for f in faces:
        k = len(f)
        for i in range(k):
            a, b = f[i], f[(i + 1) % k]
            nb[a].add(b); nb[b].add(a)
    return nb


def laplacian(v, nb, mask, iters=5, lam=0.5):
    idx = np.where(mask > 0)[0]
    lists = [list(nb[i]) for i in idx]
    for _ in range(iters):
        avg = np.array([v[l].mean(axis=0) if l else v[i] for i, l in zip(idx, lists)])
        v[idx] += (avg - v[idx]) * (lam * mask[idx])[:, None]
    return v


def smooth_scalar(s, nb, iters=4):
    s = s.copy()
    lists = [list(x) for x in nb]
    for _ in range(iters):
        s = np.array([0.5 * s[i] + 0.5 * (s[l].mean() if l else s[i]) for i, l in enumerate(lists)])
    return s


def smoothstep(e0, e1, x):
    t = np.clip((x - e0) / (e1 - e0), 0, 1)
    return t * t * (3 - 2 * t)


# --------------------------------------------------------------- faceless egg
HEAD_BONES_PREFIX = ("head", "jaw", "eye", "oris", "temporalis", "oculi", "orbicularis",
                     "risorius", "levator", "special", "tongue")


def make_faceless(v, faces, weights, nb, head_scale=1.0):
    n = BODY_VERTS
    wh = np.zeros(n)
    for bone, lst in weights.items():
        if bone.startswith(HEAD_BONES_PREFIX):
            for i, w in lst:
                if i < n:
                    wh[i] += w
    wh = np.clip(wh, 0, 1)
    head = wh > 0.95
    hv = v[:n][head]
    zmax = hv[:, 2].max()
    # chin: lowest fully-head vertex in the front half
    front = hv[hv[:, 1] < np.median(hv[:, 1])]
    zmin = np.percentile(front[:, 2], 1.0)
    H = zmax - zmin
    cy = np.median(hv[:, 1]) + 0.004
    c = np.array([0.0, cy, zmin + 0.50 * H])
    r = np.array([0.355 * H, 0.43 * H, 0.52 * H]) * head_scale
    c[2] += (head_scale - 1) * 0.45 * H

    def egg(p):
        q = (p - c) / r
        d = q / np.linalg.norm(q, axis=1)[:, None]
        # taper the lower half (jaw/chin) and slightly flatten back of head
        taper = 1.0 - 0.16 * np.clip(-d[:, 2], 0, 1) ** 1.4
        out = c + d * r * taper[:, None]
        # subtle brow/nose ridge to read direction of face (as in the reference)
        front_amt = np.clip(-d[:, 1], 0, 1) ** 6
        ridge = np.exp(-((d[:, 2] - 0.05) / 0.35) ** 2) * np.exp(-(d[:, 0] / 0.12) ** 2)
        out[:, 1] -= front_amt * ridge * 0.012 * H / 0.22
        return out

    blend = smoothstep(0.35, 0.97, wh)
    # do not let the egg pull the neck: fade below the chin
    blend *= smoothstep(zmin - 0.25 * H, zmin + 0.05 * H, v[:n, 2])
    target = egg(v[:n])
    v[:n] = v[:n] * (1 - blend[:, None]) + target * blend[:, None]
    # relax + reproject so ears / mouth fold away cleanly
    full = np.zeros(len(v)); full[:n] = blend
    for _ in range(12):
        laplacian(v, nb, full, iters=1, lam=0.6)
        t = egg(v[:n])
        hard = (blend > 0.9)
        v[:n][hard] = t[hard]
    band = np.zeros(len(v)); band[:n] = np.clip(blend * (1 - blend) * 4, 0, 1)
    laplacian(v, nb, band, iters=6, lam=0.5)
    return v


def soften_details(v, nb, meta_points, radius, iters=8):
    """Smooth away nipples / navel (the reference figure has none)."""
    n = BODY_VERTS
    mask = np.zeros(len(v))
    for p in meta_points:
        d = np.linalg.norm(v[:n] - p, axis=1)
        mask[:n] = np.maximum(mask[:n], 1 - smoothstep(radius * 0.4, radius, d))
    return laplacian(v, nb, mask, iters=iters, lam=0.6)


# ------------------------------------------------------------------- the rig
def joint_pos(spec, v, vg):
    s = spec["strategy"]
    if s == "CUBE":
        return v[vg[spec["cube_name"]]].mean(axis=0)
    if s == "VERTEX":
        return v[spec["vertex_index"]]
    if s == "MEAN":
        return v[spec["vertex_indices"]].mean(axis=0)
    raise ValueError(s)


SKIP_BONES_PREFIX = ("tongue", "oris", "temporalis", "oculi", "orbicularis", "risorius",
                     "levator", "eye", "jaw", "special0", "breast")


def build_armature(name, v, vg, rig):
    arm = bpy.data.armatures.new(name + "_rig")
    arm.display_type = "STICK"
    ob = bpy.data.objects.new(name + "_rig", arm)
    bpy.context.scene.collection.objects.link(ob)
    bpy.context.view_layer.objects.active = ob
    bpy.ops.object.mode_set(mode="EDIT")
    keep = {k: b for k, b in rig.items() if not k.startswith(SKIP_BONES_PREFIX)}
    for bname, b in keep.items():
        eb = arm.edit_bones.new(bname)
        eb.head = Vector(joint_pos(b["head"], v, vg))
        eb.tail = Vector(joint_pos(b["tail"], v, vg))
        if (eb.tail - eb.head).length < 1e-4:
            eb.tail = eb.head + Vector((0, 0, 0.01))
        eb.roll = b.get("roll", 0.0)
    for bname, b in keep.items():
        p = b.get("parent")
        if p and p in arm.edit_bones:
            arm.edit_bones[bname].parent = arm.edit_bones[p]
            arm.edit_bones[bname].use_connect = bool(b.get("use_connect")) and \
                (arm.edit_bones[bname].head - arm.edit_bones[p].tail).length < 1e-4
    bpy.ops.object.mode_set(mode="OBJECT")
    return ob, set(keep)


# --------------------------------------------------------------- muscle masks
def muscle_masks(v, normals, J):
    """Procedural muscle regions (0..1 per vertex) in rest pose.
    Limbs use cylindrical coordinates (angle around the bone), the torso uses a
    front/back projection gated by the surface normal."""
    from .sculpt import Limb, _ss as ss
    P = v; N = normals
    x, z = P[:, 0], P[:, 2]
    ax = np.abs(x)
    nf, nb = -N[:, 1], N[:, 1]
    neck, pelvis = J["neck"], J["pelvis"]
    H = neck[2] - pelvis[2]
    zc = lambda f: pelvis[2] + f * H
    shoulder_x = abs(J["shoulderL"][0])
    torso = (1 - ss(shoulder_x * 0.88, shoulder_x * 1.02, ax)) * ss(zc(-0.45), zc(-0.3), z) * \
        (1 - ss(zc(1.0), zc(1.06), z))
    XZ = np.stack([ax, z], 1)

    def ell(cx, cz, rx, rz, e0=0.7):
        d = np.linalg.norm((XZ - np.array([cx, cz])) / np.array([rx, rz]), axis=1)
        return 1 - ss(e0, 1.0, d)

    m = {}
    side = {"L": x > 0, "R": x < 0}
    lat = {"L": 1, "R": -1}

    def limb(a, b, s, t0, t1, a0, aw, radmax):
        L = Limb(P, J[a + s], J[b + s], lat[s])
        along = ss(t0 - 0.06, t0 + 0.04, L.t) * (1 - ss(t1 - 0.04, t1 + 0.06, L.t))
        da = (L.ang - a0 + 180) % 360 - 180
        return side[s] * along * (1 - ss(aw * 0.75, aw, np.abs(da))) * (1 - ss(radmax * 0.9, radmax, L.rad))

    def both(fn):
        return np.maximum(fn("L"), fn("R"))

    m["quads"] = both(lambda s: limb("upleg", "knee", s, 0.12, 0.93, 0, 95, 0.14))
    m["hamstrings"] = both(lambda s: limb("upleg", "knee", s, 0.18, 0.88, 180, 70, 0.14))
    m["adductors"] = both(lambda s: limb("upleg", "knee", s, 0.02, 0.62, -95, 40, 0.14))
    m["calves"] = both(lambda s: limb("knee", "ankle", s, 0.06, 0.62, 180, 80, 0.11))
    m["biceps"] = both(lambda s: limb("shoulder", "elbow", s, 0.28, 0.92, 0, 60, 0.09))
    m["triceps"] = both(lambda s: limb("shoulder", "elbow", s, 0.18, 0.92, 180, 75, 0.09))
    m["forearms"] = both(lambda s: limb("elbow", "wrist", s, 0.0, 0.72, 30, 120, 0.08))
    m["delts"] = both(lambda s: side[s] * (1 - ss(0.085, 0.115, np.linalg.norm(
        P - (J["shoulder" + s] + np.array([lat[s] * 0.02, 0, 0.0])), axis=1))))
    fr = torso * ss(0.1, 0.45, nf)
    bk = torso * ss(0.1, 0.45, nb)
    m["chest"] = fr * ell(0.09, zc(0.70), 0.11, 0.085)
    m["abs"] = fr * ell(0.0, zc(0.28), 0.085, 0.27, 0.8)
    m["obliques"] = torso * ss(-0.3, 0.3, nf) * ell(0.125, zc(0.25), 0.045, 0.16)
    m["lats"] = bk * ell(0.12, zc(0.55), 0.085, 0.24)
    m["traps"] = bk * np.maximum(ell(0.0, zc(0.82), 0.12, 0.2), ell(0.07, zc(1.0), 0.08, 0.08))
    m["lowerback"] = bk * ell(0.0, zc(0.18), 0.075, 0.15)
    m["glutes"] = ss(0.0, 0.4, nb) * ell(0.085, zc(-0.17), 0.095, 0.12) * (1 - ss(0.2, 0.24, ax))
    m["core"] = np.maximum(m["abs"], m["obliques"])
    return m


# -------------------------------------------------------------------- build
PROFILES = os.path.join(os.path.dirname(ASSETS), "profiles")


def load_profile(profile=None, overrides=None):
    """profile: dict, path or name in profiles/ (default: $FITANIM_PROFILE or 'athlete').
    overrides: {"sculpt.groups.arms": 1.6, "targets.torso/torso-vshape-incr.target.gz": 0.8, ...}"""
    if profile is None:
        profile = os.environ.get("FITANIM_PROFILE", "athlete")
    if isinstance(profile, str):
        path = profile if profile.endswith(".json") else os.path.join(PROFILES, profile + ".json")
        with open(path) as f:
            profile = json.load(f)
    prof = json.loads(json.dumps(profile))
    for key, val in (overrides or {}).items():
        head, _, rest = key.partition(".")
        node = prof.setdefault(head, {})
        if head == "targets":
            node[rest] = float(val)
            continue
        parts = rest.split(".") if rest else []
        if not parts:
            prof[head] = float(val); continue
        for p in parts[:-1]:
            node = node.setdefault(p, {})
        node[parts[-1]] = float(val)
    return prof


def build_character(name="Mannequin", body=None, subdiv=2, height=None, hires=True, sculpt_strength=None,
                    profile=None, overrides=None):
    prof = load_profile(profile, overrides)
    if body is None:
        body = dict(DEFAULT_BODY); body.update(prof.get("targets", {}))
    height = height or prof.get("height", 1.84)
    sc = prof.get("sculpt", {})
    if sculpt_strength is None:
        sculpt_strength = sc.get("strength", 1.0)
    sculpt_groups = sc.get("groups", {})
    base, faces, uvs, face_uvs = load_basemesh()
    vg = vertex_groups_meta()
    v = apply_targets(base, body)
    v = _obj_to_blender(v)
    with open(os.path.join(ASSETS, "rigs", "weights.default.json")) as f:
        weights = json.load(f)["weights"]
    with open(os.path.join(ASSETS, "rigs", "rig.default.json")) as f:
        rig = json.load(f)

    nb = build_adjacency(faces, len(v))
    v = make_faceless(v, faces, weights, nb, prof.get("head_scale", 1.0))
    # shorter neck: slide head + upper neck down (the rig is built afterwards, so it follows)
    ns = prof.get("neck_shorten", 0.0)
    if ns:
        neck_z = v[vg["joint-neck"]].mean(axis=0)[2]
        head_z = v[vg["joint-head"]].mean(axis=0)[2]
        w = smoothstep(neck_z - 0.01, head_z, v[:, 2])
        v[:, 2] -= ns * w

    # feet on the floor, normalise height
    v[:, 2] -= v[:BODY_VERTS, 2].min()
    v *= height / v[:BODY_VERTS, 2].max()

    # joints (for masks / soft details)
    def cube(nm):
        return v[vg[nm]].mean(axis=0)
    J = {"neck": cube("joint-neck"), "pelvis": cube("joint-pelvis"), "spine2": cube("joint-spine-2"),
         "spine1": cube("joint-spine-1")}
    for s, c in (("L", "l"), ("R", "r")):
        J[f"upleg{s}"] = cube(f"joint-{c}-upper-leg"); J[f"knee{s}"] = cube(f"joint-{c}-knee")
        J[f"ankle{s}"] = cube(f"joint-{c}-ankle"); J[f"shoulder{s}"] = cube(f"joint-{c}-shoulder")
        J[f"elbow{s}"] = cube(f"joint-{c}-elbow"); J[f"wrist{s}"] = cube(f"joint-{c}-hand")
    # MakeHuman "l" is the character's left = +X in Blender
    if J["uplegL"][0] < 0:
        for k in list(J):
            if k.endswith("L"):
                kk = k[:-1] + "R"; J[k], J[kk] = J[kk], J[k]

    # remove nipples + navel
    chest_z = J["spine1"][2] + 0.02
    pts = []
    front_chest = np.where((np.abs(v[:BODY_VERTS, 2] - (J["neck"][2] - 0.17)) < 0.05))[0]
    if len(front_chest):
        for sgn in (1, -1):
            cand = front_chest[(np.sign(v[front_chest, 0]) == sgn) & (np.abs(v[front_chest, 0]) > 0.06)]
            if len(cand):
                pts.append(v[cand[np.argmin(v[cand, 1])]])
    belly = np.where((np.abs(v[:BODY_VERTS, 0]) < 0.02) &
                     (v[:BODY_VERTS, 2] > J["pelvis"][2]) & (v[:BODY_VERTS, 2] < J["spine2"][2]))[0]
    soften_details(v, nb, pts, 0.035, iters=10)
    if len(belly):
        navel_z = J["pelvis"][2] + 0.6 * (J["spine2"][2] - J["pelvis"][2])
        cand = belly[np.abs(v[belly, 2] - navel_z) < 0.05]
        if len(cand):
            soften_details(v, nb, [v[cand[np.argmin(v[cand, 1])]] + [0, 0.01, 0]], 0.03, iters=12)

    # ---- mesh
    me = bpy.data.meshes.new(name)
    body_v = v[:BODY_VERTS]
    me.from_pydata(body_v.tolist(), [], faces)
    me.update()
    for p in me.polygons:
        p.use_smooth = True
    ob = bpy.data.objects.new(name, me)
    bpy.context.scene.collection.objects.link(ob)

    # ---- armature + weights
    rig_ob, kept = build_armature(name, v, vg, rig)
    groups = {}
    for bone, lst in weights.items():
        if bone not in kept:
            # fold dropped face bones into head
            if bone.startswith("breast"):
                bone = "spine03" if "spine03" in kept else "spine02"
            else:
                bone = "head"
        g = groups.get(bone) or ob.vertex_groups.new(name=bone)
        groups[bone] = g
        for i, w in lst:
            if i < BODY_VERTS:
                g.add([i], w, "ADD")
    # ---- hi-res + procedural anatomy sculpt (in rest pose)
    if hires:
        bpy.context.view_layer.objects.active = ob
        ob.select_set(True)
        pre = ob.modifiers.new("pre", "SUBSURF"); pre.levels = 1
        bpy.ops.object.modifier_apply(modifier="pre")
    P, Nrm = mesh_arrays(me)
    edges = np.array([e.vertices[:] for e in me.edges])
    if sculpt_strength:
        disp = sculpt_mod.sculpt(P, Nrm, J, sculpt_strength, sculpt_groups)
        disp = smooth_edges(disp, edges, len(P), iters=1)
        disp = np.where(disp < 0, disp * sc.get("grooves", 1.0), disp)
        P = P + Nrm * disp[:, None]
        me.vertices.foreach_set("co", P.astype(np.float32).ravel())
        me.update()
        P, Nrm = mesh_arrays(me)

    ob.parent = rig_ob
    mod = ob.modifiers.new("Armature", "ARMATURE")
    mod.object = rig_ob
    mod.use_deform_preserve_volume = True
    # corrective smooth: removes pinching / bulging at shoulders, hips and knees in extreme poses
    cs = ob.modifiers.new("CorrectiveSmooth", "CORRECTIVE_SMOOTH")
    cs.rest_source = "ORCO"; cs.smooth_type = "LENGTH_WEIGHTED"
    cs.factor = 0.75; cs.iterations = 10; cs.use_pin_boundary = True
    if subdiv:
        s = ob.modifiers.new("Subsurf", "SUBSURF")
        s.levels = 1; s.render_levels = subdiv

    # ---- muscle masks as attributes
    masks = muscle_masks(P, Nrm, J)
    for k, arr in masks.items():
        arr = smooth_edges(np.clip(arr, 0, 1), edges, len(P), iters=4)
        at = me.attributes.new("m_" + k, "FLOAT", "POINT")
        at.data.foreach_set("value", arr.astype(np.float32))
    ob["fitanim_muscles"] = list(masks.keys())
    ob["fitanim_joints"] = {k: list(map(float, p)) for k, p in J.items()}
    return ob, rig_ob


def mesh_arrays(me):
    n = len(me.vertices)
    P = np.empty(n * 3, np.float32); me.vertices.foreach_get("co", P)
    N = np.empty(n * 3, np.float32); me.vertices.foreach_get("normal", N)
    return P.reshape(-1, 3).astype(np.float64), N.reshape(-1, 3).astype(np.float64)


def smooth_edges(s, edges, n, iters=3):
    s = s.astype(np.float64).copy()
    deg = np.bincount(edges.ravel(), minlength=n).astype(np.float64)
    deg[deg == 0] = 1
    for _ in range(iters):
        acc = np.zeros(n)
        np.add.at(acc, edges[:, 0], s[edges[:, 1]])
        np.add.at(acc, edges[:, 1], s[edges[:, 0]])
        s = 0.5 * s + 0.5 * acc / deg
    return s
