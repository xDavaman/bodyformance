#!/usr/bin/env python3
"""Automatischer Bewegungs-Prüfer ("Lint") für alle Bodyformance-Bewegungen.

Prüft jede Bewegung + Gerät auf typische Animationsfehler, bevor teuer gerendert wird:

 Skelett (jedes Frame)
  REACH     Arm/Bein überstreckt – Ziel außerhalb der Reichweite (Gelenk rastet ein)
  KNEE      Knie zeigt nicht in Richtung Fußspitze (X-/O-Bein, verdrehtes Knie)
  ROM       Gelenkwinkel außerhalb der klinischen Norm (AAOS / Norkin & White): Schulter, Ellbogen,
            Unterarm, Handgelenk, Hüfte, Knie, Sprunggelenk, Wirbelsäule, Nacken ("ausgekugelt")
  SPINE     Wirbelsäule / Nacken außerhalb des natürlichen Bereichs
  JUMP      Sprung / Ruck zwischen zwei Frames (Gelenk teleportiert)
  SLIDE     Fuß oder Hand rutscht, obwohl sie aufgesetzt ist
 Mesh (Stichproben-Frames)
  FLOOR     Körper steckt im Boden / in der Matte
  FLOAT     Körper schwebt ohne Kontakt zu Boden oder Gerät
  PROP      Körper steckt in Bank, Box, Stange, Turm …
  WEIGHT    Hantel / Kettlebell steckt im Körper oder Boden
  GRIP      Hand greift an Stange / Barren vorbei
  SELF      Körperteile durchdringen sich (Hand im Bauch, Beine ineinander …)

  python tools/motion_lint.py                        # alle 212 Familien-Clips (= 123 Bewegung/Gerät-Kombis)
  python tools/motion_lint.py --only curl:dumbbell pushup:none
  python tools/motion_lint.py --skeleton-only        # sehr schnell (ohne Mesh)
Ausgabe: out/lint/report.json + report.md (sortiert nach Schwere, mit Phase -> direkt mit tune.py ansehen)
"""
import argparse, json, math, os, sys, time
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT); sys.path.insert(0, os.path.join(ROOT, "tools"))

FPS = 30
LIMITS = dict(reach_cm=1.2, knee_deg=50, humerus_deg=110, femur_deg=55, wrist_swing=80, wrist_twist=60,
              ankle_deg=50, forearm_twist=150, spine_bend=(-45, 95), spine_side=40, spine_twist=55,
              neck_pitch=(-75, 60), vel=4.5, rot_jump=28, slide=0.30, floor_cm=1.5, float_cm=3.0,
              prop_cm=2.0, self_cm=2.2, grip_cm=5.0, rom_tol=4.0)
ROM_DE = {"shoulder.over": "Schulter überstreckt", "shoulder.flex": "Schulter Beugung/Streckung",
          "shoulder.abd": "Schulter Abspreizen", "shoulder.rot": "Oberarm verdreht", "elbow.flex": "Ellbogen",
          "elbow.bend_ok": "Ellbogen", "forearm.sup": "Unterarm Drehung", "wrist.flex": "Handgelenk Knick",
          "wrist.dev": "Handgelenk seitlich", "hip.over": "Hüfte überstreckt", "hip.flex": "Hüfte Beugung",
          "hip.abd": "Hüfte Abspreizen", "hip.rot": "Oberschenkel verdreht", "knee.flex": "Knie",
          "knee.bend_ok": "Knie", "ankle.dorsi": "Sprunggelenk", "spine.bend": "Rumpf vor/zurück",
          "spine.side": "Rumpf seitlich", "spine.twist": "Rumpf Drehung", "neck.pitch": "Nacken vor/zurück",
          "neck.yaw": "Kopf Drehung", "neck.tilt": "Kopf seitlich", "shrug": "Schulter hochgezogen"}

AIRBORNE_OK = {"jumpRope", "run"}            # flight phases are expected
NO_SUPPORT_CHECK = set()


# ------------------------------------------------------------------ helpers
def ang(a, b):
    d = max(-1.0, min(1.0, a.normalized().dot(b.normalized())))
    return math.degrees(math.acos(d))


def swing_twist(q, axis):
    """twist angle (deg) of quaternion q around axis, swing angle (deg)."""
    from mathutils import Vector, Quaternion
    p = Vector((q.x, q.y, q.z)).project(axis)
    tw = Quaternion((q.w, p.x, p.y, p.z))
    if tw.magnitude < 1e-9:
        return 0.0, 180.0
    tw.normalize()
    t = 2 * math.atan2(Vector((tw.x, tw.y, tw.z)).dot(axis.normalized()), tw.w)
    t = (t + math.pi) % (2 * math.pi) - math.pi
    sw = q @ tw.inverted()
    s = 2 * math.acos(max(-1, min(1, abs(sw.w))))
    return math.degrees(t), math.degrees(s)


class Issues:
    def __init__(self):
        self.d = defaultdict(lambda: dict(n=0, worst=0.0, phase=None, frame=None, note=""))

    def add(self, code, where, value, limit, frame, phase, note=""):
        if value <= limit:
            return
        k = (code, where)
        e = self.d[k]
        e["n"] += 1
        sev = value / limit if limit else value
        if sev > e["worst"]:
            e.update(worst=round(sev, 2), value=round(value, 3), limit=limit, frame=frame,
                     phase=None if phase is None else round(phase, 3), note=note)

    def list(self, min_frames=1):
        out = []
        for (code, where), e in self.d.items():
            if e["n"] >= min_frames:
                out.append(dict(code=code, where=where, **e))
        return sorted(out, key=lambda x: -x["worst"])


# ------------------------------------------------------------------ skeleton checks
def skeleton_checks(ex, pz, iss, motion):
    from mathutils import Vector, Quaternion
    from fitanim import director as D, anat as AN
    sh = type("S", (), {})(); sh.ex = ex
    n = int(round((ex.intro + ex.reps * ex.rep_time + 0.6) * FPS))
    # instrument the 2-bone solver to measure over-reach
    reach = {}
    orig = pz._two_bone
    cur = {"limb": None}

    def tb(H, A, l1, l2, pole):
        over = (A - H).length - (l1 + l2)
        reach[cur["limb"]] = max(reach.get(cur["limb"], -1), over)
        return orig(H, A, l1, l2, pole)
    pz._two_bone = tb
    oleg, oarm = pz._solve_leg, pz._solve_arm

    def leg(s, *a):
        cur["limb"] = "Bein " + s; return oleg(s, *a)

    def arm(s, *a):
        cur["limb"] = "Arm " + s; return oarm(s, *a)
    pz._solve_leg, pz._solve_arm = leg, arm
    rest = pz.rest
    prev = None
    track = ["_palmL", "_palmR", "foot.L", "foot.R", "head", "wrist.L", "wrist.R", "toe1-1.L", "toe1-1.R"]
    hist = []
    import bodyformance_render as BR
    ctx = {"poser": pz, "corr": D.configure_corrector(BR.corrector(), ex)}
    try:
        for f in range(n):
            t = f / FPS
            ph, rep = D.Shot.phase_at(sh, t)
            reach.clear()
            P, posed = D.frame_pose(ex, sh, t, ctx)
            phs = ph if t >= ex.intro else None
            for limb, over in reach.items():
                iss.add("REACH", limb, over * 100, LIMITS["reach_cm"], f, phs, "Ziel außer Reichweite (cm)")
            chest = posed["spine01"].to_3x3() @ rest["spine01"].to_3x3().inverted()
            pelvis = posed["root"].to_3x3() @ rest["root"].to_3x3().inverted()
            for s in "LR":
                # knee direction vs foot direction
                H = posed[f"upperleg01.{s}"].translation; K = posed[f"lowerleg01.{s}"].translation
                A = posed[f"foot.{s}"].translation
                ha = A - H
                if ha.length > 1e-4:
                    bend = 180 - ang(H - K, A - K)
                    toe = posed.get(f"toe1-1.{s}")
                    fwd = (toe.translation - A) if toe else posed[f"foot.{s}"].to_3x3().col[1]
                    shin = (A - K).normalized()
                    if 25 < bend < 130 and abs(fwd.normalized().dot(shin)) < 0.8 and abs(fwd.normalized().dot(ha.normalized())) < 0.8:
                        axis = ha.normalized()
                        nrm = axis.cross(fwd)
                        if nrm.length > 1e-4:
                            nrm.normalize()
                            kd = (K - H) - axis * (K - H).dot(axis)
                            inpl = nrm.cross(axis)          # in leg plane, perpendicular to hip-ankle line
                            lat = math.degrees(math.atan2(kd.dot(nrm), kd.dot(inpl)))
                            # inpl points to the toe side: |lat| = deviation from "knee over toes"
                            iss.add("KNEE", "Knie " + s, abs(lat), LIMITS["knee_deg"], f, phs,
                                    "Knie seitlich aus der Bein-Ebene (Grad)")
            # anatomical range of motion (fitanim.anat): every joint against clinical ROM norms
            M = AN.measure(pz, posed, P)
            for joint, side, val, rng in AN.violations(M, tol=0.0):
                if rng is None:
                    iss.add("ROM", f"{ROM_DE.get(joint, joint)} {side}".strip(), 10.0, 1.0, f, phs,
                            "Gelenk knickt in die falsche Richtung")
                    continue
                ex_ = AN.excess(val, rng)
                if joint.endswith(".over"):
                    rng = (0, round(val - ex_))
                iss.add("ROM", f"{ROM_DE.get(joint, joint)} {side}".strip(), ex_, LIMITS["rom_tol"], f, phs,
                        f"Grad über Norm (Wert {val:.0f}, Norm {rng[0]}..{rng[1]})")
            b, sd, tw_ = P.get("spine", (0, 0, 0))
            lo, hi = LIMITS["spine_bend"]
            iss.add("SPINE", "Rumpf vor", b, hi, f, phs, "Grad"); iss.add("SPINE", "Rumpf zurück", -b, -lo, f, phs, "Grad")
            iss.add("SPINE", "Rumpf seitlich", abs(sd), LIMITS["spine_side"], f, phs, "Grad")
            iss.add("SPINE", "Rumpf Drehung", abs(tw_), LIMITS["spine_twist"], f, phs, "Grad")
            npch = P.get("neck", (0, 0, 0))[0] + P.get("head", (0, 0, 0))[0]
            lo, hi = LIMITS["neck_pitch"]
            iss.add("SPINE", "Kopf/Nacken nach vorn", npch, hi, f, phs, "Grad")
            iss.add("SPINE", "Kopf/Nacken nach hinten", -npch, -lo, f, phs, "Grad")
            pts = {}
            for k in track:
                if k in posed:
                    pts[k] = posed[k].copy() if isinstance(posed[k], Vector) else posed[k].translation.copy()
            rots = {k: posed[k].to_quaternion() for k in posed if not k.startswith("_")}
            hist.append(pts)
            if prev is not None:
                ppts, prots = prev
                for k, p in pts.items():
                    v = (p - ppts[k]).length * FPS
                    iss.add("JUMP", k, v, LIMITS["vel"], f, phs, "m/s")
                for k in ("upperarm01.L", "upperarm01.R", "upperleg01.L", "upperleg01.R", "spine01", "head",
                          "lowerarm01.L", "lowerarm01.R", "wrist.L", "wrist.R", "lowerleg01.L", "lowerleg01.R"):
                    if k in rots:
                        a = math.degrees(rots[k].rotation_difference(prots[k]).angle)
                        a = min(a, 360 - a)
                        iss.add("JUMP", k + " Drehung", a, LIMITS["rot_jump"], f, phs, "Grad/Frame")
            prev = (pts, rots)
        # sliding: planted contact that moves
        for k, zmax in (("toe1-1.L", 0.045), ("toe1-1.R", 0.045), ("foot.L", 0.095), ("foot.R", 0.095),
                        ("_palmL", 0.06), ("_palmR", 0.06)):
            for f in range(2, len(hist)):
                a, b, c = hist[f - 2].get(k), hist[f - 1].get(k), hist[f].get(k)
                if a is None:
                    break
                if a.z < zmax and b.z < zmax and c.z < zmax:
                    v = math.hypot(c.x - a.x, c.y - a.y) * FPS / 2
                    t = f / FPS
                    ph, _ = D.Shot.phase_at(sh, t)
                    iss.add("SLIDE", k, v, LIMITS["slide"], f, ph if t >= ex.intro else None, "m/s aufgesetzt")
    finally:
        pz._two_bone, pz._solve_leg, pz._solve_arm = orig, oleg, oarm
    return n


# ------------------------------------------------------------------ mesh checks
PARTS = {}


def part_of(bone):
    s = bone[-1] if bone[-2:] in (".L", ".R") else ""
    b = bone
    if b.startswith(("head", "jaw", "eye", "tongue", "special", "levator", "oris", "orbicularis", "risorius",
                     "temporalis", "nose", "tongue", "teeth")):
        return "head"
    if b.startswith("neck"):
        return "neck"
    if b.startswith("upperarm"):
        return "oberarm" + s
    if b.startswith("lowerarm"):
        return "unterarm" + s
    if b.startswith(("wrist", "finger", "metacarpal")):
        return "hand" + s
    if b.startswith("upperleg"):
        return "oberschenkel" + s
    if b.startswith("lowerleg"):
        return "unterschenkel" + s
    if b.startswith(("foot", "toe")):
        return "fuss" + s
    return "rumpf"


PAIRS = []
for s, o in (("L", "R"), ("R", "L")):
    for a in ("hand" + s, "unterarm" + s):
        for b in ("rumpf", "head", "oberschenkel" + s, "oberschenkel" + o, "unterschenkel" + s, "unterschenkel" + o):
            PAIRS.append((a, b))
    PAIRS += [("oberarm" + s, "head"), ("hand" + s, "unterarm" + o), ("hand" + s, "hand" + o),
              ("fuss" + s, "unterschenkel" + o), ("unterschenkel" + s, "oberschenkel" + o)]
PAIRS += [("oberschenkelL", "oberschenkelR"), ("unterschenkelL", "unterschenkelR"), ("fussL", "fussR"),
          ("head", "oberschenkelL"), ("head", "oberschenkelR")]

SUPPORT = ("Pad", "Bench", "Rail", "Box", "Foam", "DipBar", "PullBar", "Upright", "Beam", "Top", "Horn", "Tower")
GRIP_PROPS = ("PullBar", "DipBar")


def body_parts(body):
    import numpy as np
    me = body.data
    names = {g.index: g.name for g in body.vertex_groups}
    lab = []
    for v in me.vertices:
        best, bw = "rumpf", -1
        for g in v.groups:
            if g.weight > bw:
                bw, best = g.weight, part_of(names[g.group])
        lab.append(best)
    lab = np.array(lab)
    faces = np.array([p.vertices[:] for p in me.polygons], dtype=object)
    by = {}
    for p in set(lab):
        idx = np.where(lab == p)[0]
        sel = [list(f) for f in faces if all(lab[i] == p for i in f)]
        by[p] = (idx, sel)
    return lab, by


def eval_body(body):
    import numpy as np, bpy
    dg = bpy.context.evaluated_depsgraph_get()
    ev = body.evaluated_get(dg)
    me = ev.to_mesh()
    n = len(me.vertices)
    P = np.empty(n * 3, np.float32); me.vertices.foreach_get("co", P)
    ev.to_mesh_clear()
    P = P.reshape(-1, 3)
    M = np.array(body.matrix_world)
    return P @ M[:3, :3].T + M[:3, 3]


def prop_meshes(sh):
    """world-space (name, verts, polys) for every mesh prop in the scene except body/studio/lines."""
    import bpy, numpy as np
    out = []
    dg = bpy.context.evaluated_depsgraph_get()
    for ob in bpy.context.scene.objects:
        if ob.type != "MESH" or ob == sh.body or ob.name.startswith(("Backdrop", "Arrow", "Line", "Band", "Cable",
                                                                       "Sling")):
            continue
        if ob.hide_render:
            continue
        ev = ob.evaluated_get(dg)
        me = ev.to_mesh()
        M = ob.matrix_world
        V = [tuple(M @ v.co) for v in me.vertices]
        F = [tuple(p.vertices) for p in me.polygons]
        ev.to_mesh_clear()
        out.append((ob.name, V, F))
    return out


def inside_depth(Pq, tree, maxd=0.06):
    """max penetration depth (m) and count of points Pq inside the surface of tree."""
    from mathutils import Vector
    best, cnt, arg = 0.0, 0, -1
    for i, p in enumerate(Pq):
        r = tree.find_nearest(Vector(p), maxd)
        if r[0] is None:
            continue
        loc, nrm, _, dist = r
        if (Vector(p) - loc).dot(nrm) < 0:
            cnt += 1
            if dist > best:
                best, arg = dist, i
    return best, cnt, arg


def mesh_checks(ex, motion, eq, iss, phases=None, quick=False):
    import bpy, numpy as np
    from mathutils import Vector
    from mathutils.bvhtree import BVHTree
    from fitanim import director as D
    sh = D.Shot(ex, "preview").build()
    for m in sh.body.modifiers:
        if m.type == "SUBSURF":
            m.levels = 0; m.render_levels = 0
    lab, parts = body_parts(sh.body)
    hand_mask = np.isin(lab, ["handL", "handR"])
    phases = phases or ([0.0, 0.12, 0.25, 0.37, 0.5, 0.62, 0.75, 0.87] if not quick else [0.0, 0.25, 0.5, 0.75])
    frames = [1] + [int(round((ex.intro + ex.rep_time * p) * FPS)) + 1 for p in phases]
    pz = sh.poser
    ctx = sh.ctx
    hang_like = any(p["type"] in ("pullbar", "rack", "dipbars") for p in ex.props) and motion in (
        "pullup", "hang", "legRaise", "triceps", "kneeRaise")
    for f in frames:
        t = (f - 1) / FPS
        ph, rep = sh.phase_at(t)
        P, posed = D.frame_pose(ex, sh, t, ctx)
        pz.apply(posed)
        sh._props_at(posed, P, f)
        sh.scene.frame_set(f)
        B = eval_body(sh.body)
        phs = ph if t >= ex.intro else None
        props = prop_meshes(sh)
        # ---- floor / mat
        mats = [(np.min(np.array(V), 0), np.max(np.array(V), 0)) for n_, V, F in props if n_.startswith("Mat")]
        sup = np.zeros(len(B), np.float32)
        for lo, hi in mats:
            inm = (B[:, 0] > lo[0]) & (B[:, 0] < hi[0]) & (B[:, 1] > lo[1]) & (B[:, 1] < hi[1])
            sup[inm] = np.maximum(sup[inm], hi[2])
        pen = float((sup - B[:, 2]).max())
        k = int((sup - B[:, 2]).argmax())
        iss.add("FLOOR", "Körper im Boden (" + lab[k] + ")", pen * 100, LIMITS["floor_cm"], f, phs, "cm")
        # ---- props: penetration, support contact, grips
        min_gap = float((B[:, 2] - sup).min())
        trees = {}
        sample = B[::3]
        for name, V, F in props:
            if name.startswith(("Floor", "Mat")) or not F:
                continue
            tree = BVHTree.FromPolygons(V, F)
            trees[name] = tree
            Vn = np.array(V)
            lo, hi = Vn.min(0) - 0.08, Vn.max(0) + 0.08
            near = np.where(np.all((B > lo) & (B < hi), 1))[0]
            handheld = name.startswith(("Dumbbell", "Kettlebell", "Barbell", "MedBall", "Medball"))
            if near.size:
                # hands are allowed to wrap grips; the holding hand is allowed into handheld implements
                q = near[~hand_mask[near]] if (handheld or name.startswith(GRIP_PROPS)) else near
                if q.size:
                    d, c, a = inside_depth(B[q], tree)
                    if c >= 4:
                        code = "WEIGHT" if handheld else "PROP"
                        lim = LIMITS["prop_cm"] * (1.6 if "Barbell" in name and ex.props and any(
                            p.get("mode") == "chest" for p in ex.props) else 1)
                        iss.add(code, f"{lab[q[a]]} in {name.split('.')[0]}", d * 100, lim, f, phs, "cm")
            if any(name.startswith(s) for s in SUPPORT):
                for p_ in sample[np.all((sample > lo) & (sample < hi), 1)]:
                    r = tree.find_nearest(Vector(p_), 0.2)
                    if r[0] is not None:
                        min_gap = min(min_gap, r[3])
            if handheld:
                zmin = float(Vn[:, 2].min())
                floor_here = 0.012 if mats else 0.0
                iss.add("WEIGHT", f"{name.split('_')[0]} im Boden", (floor_here - zmin) * 100, 1.0, f, phs, "cm")
        if motion not in AIRBORNE_OK:
            iss.add("FLOAT", "Körper schwebt", min_gap * 100, LIMITS["float_cm"], f, phs, "cm Abstand")
        # grip on bars
        bars = [n_ for n_ in trees if n_.startswith(GRIP_PROPS)]
        if bars and hang_like:
            for s in "LR":
                pl = posed["_palm" + s]
                dmin = min(trees[b].find_nearest(pl, 1.0)[3] or 9 for b in bars)
                iss.add("GRIP", "Hand " + s + " neben Stange/Barren", dmin * 100, LIMITS["grip_cm"], f, phs, "cm")
        # ---- self intersection
        tcache = {}
        for a, b in PAIRS:
            if a not in parts or b not in parts:
                continue
            ia, _ = parts[a]; ib, fb = parts[b]
            if not fb:
                continue
            Pa = B[ia]
            lo, hi = B[ib].min(0) - 0.05, B[ib].max(0) + 0.05
            m = np.all((Pa > lo) & (Pa < hi), 1)
            if not m.any():
                continue
            if b not in tcache:
                tcache[b] = BVHTree.FromPolygons([tuple(v) for v in B], fb)
            d, c, _ = inside_depth(Pa[m][::2], tcache[b], 0.07)
            if c >= 6:
                iss.add("SELF", f"{a} in {b}", d * 100, LIMITS["self_cm"], f, phs, "cm")
    return len(frames)


# ------------------------------------------------------------------ main
def combos(only=None):
    import bodyformance_render as BR
    fams, rows = BR.load(); rep = BR.family_choice(fams, rows)
    seen = {}
    from fitanim import bf_family as BFF
    for fi in range(len(fams)):
        key = BFF.family_motion(fi, rep[fi]["name"], fams[fi]["motion"], rep[fi]["equipment"])
        seen.setdefault(key, []).append(fi)
    out = sorted(seen.items())
    if only:
        want = {tuple(o.split(":")) if ":" in o else (o, None) for o in only}
        out = [(k, v) for k, v in out if k in want or (k[0], None) in want]
    return out


def lint_one(motion, eq, skeleton_only=False, quick=False):
    from fitanim import bf_motions as BF
    import bodyformance_render as BR
    iss = Issues()
    ex = BF.make_exercise(motion, eq, motion.upper(), "", ["abs"])
    skeleton_checks(ex, BR.poser(), iss, motion)
    if not skeleton_only:
        mesh_checks(ex, motion, eq, iss, quick=quick)
    return iss.list()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--skeleton-only", action="store_true")
    ap.add_argument("--quick", action="store_true", help="weniger Mesh-Stichproben")
    ap.add_argument("--out", default=os.path.join(ROOT, "out", "lint"))
    ap.add_argument("--shard", default="0/1", help="i/n: nur jede n-te Kombi (parallel laufen lassen)")
    a = ap.parse_args()
    import bpy  # noqa
    os.makedirs(a.out, exist_ok=True)
    cs = combos(a.only)
    si, sn = map(int, a.shard.split("/"))
    cs = cs[si::sn]
    rep = {}
    t0 = time.time()
    for (motion, eq), fams in cs:
        t1 = time.time()
        try:
            res = lint_one(motion, eq, a.skeleton_only, a.quick)
        except Exception as e:
            import traceback; traceback.print_exc()
            res = [dict(code="CRASH", where=str(e)[:200], worst=99, n=1, phase=None, frame=None, note="")]
        rep[f"{motion}:{eq}"] = dict(families=fams, issues=res)
        bad = [r for r in res if r["worst"] > 1]
        print(f"[lint] {motion}:{eq:10s} {len(bad):2d} Befunde  {time.time() - t1:.0f}s  "
              + "; ".join(f"{r['code']} {r['where']} x{r['worst']}" for r in bad[:4]), flush=True)
    tag = "" if a.shard == "0/1" else "_" + a.shard.replace("/", "of")
    json.dump(rep, open(os.path.join(a.out, f"report{tag}.json"), "w"), ensure_ascii=False, indent=1)
    write_md(rep, os.path.join(a.out, f"report{tag}.md"))
    print(f"[lint] fertig in {time.time() - t0:.0f}s -> {a.out}")


def write_md(rep, path):
    lines = ["# Bewegungs-Lint\n"]
    items = sorted(rep.items(), key=lambda kv: -max([i["worst"] for i in kv[1]["issues"]] or [0]))
    for k, v in items:
        if not v["issues"]:
            continue
        lines.append(f"## {k}  (Familien {v['families']})")
        for i in v["issues"]:
            lines.append(f"- **{i['code']}** {i['where']}: {i.get('value')} (Grenze {i.get('limit')}, x{i['worst']}) "
                         f"in {i['n']} Frames, schlimmste Phase {i['phase']} / Frame {i['frame']} {i['note']}")
        lines.append("")
    open(path, "w").write("\n".join(lines))


if __name__ == "__main__":
    main()
