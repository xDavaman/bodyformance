#!/usr/bin/env python3
"""Fine-tuning tools (fast, low-res contact sheets).

  # Figure: front / 3/4 / side / back + torso and arm close-ups
  python tools/tune.py body                                   # default profile (athlete)
  python tools/tune.py body --profile lean --set sculpt.groups.arms=1.8
  python tools/tune.py body --compare lean athlete            # side by side

  # Pose check: any exercise at given phases from several angles, with close-ups
  python tools/tune.py pose pushup --phases 0 0.45 --views front34 side top hands
  python tools/tune.py pose curl --phases 0 0.25 0.45 --views front34 hands_l

  # Next to a reference frame (e.g. a frame of an inspiration video)
  python tools/tune.py ref squat --image ref.png --phase 0.45

Views: front, front34, side, back, back34, top, hands, hands_l, hands_r, shoulders, feet, torso
Output: out/tune/<name>.png (labelled grid)
"""
import argparse, math, os, sys, subprocess, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)


def labelled_grid(paths, labels, out, cols):
    from PIL import Image, ImageDraw, ImageFont
    ims = [Image.open(p).convert("RGB") for p in paths]
    w = max(i.width for i in ims); h = max(i.height for i in ims)
    rows = (len(ims) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * w, rows * (h + 26)), (10, 14, 30))
    d = ImageDraw.Draw(sheet)
    try:
        f = ImageFont.truetype("/usr/share/fonts/opentype/inter/Inter-Bold.otf", 15)
    except Exception:
        f = ImageFont.load_default()
    for k, (im, lb) in enumerate(zip(ims, labels)):
        x, y = (k % cols) * w, (k // cols) * (h + 26)
        sheet.paste(im, (x, y + 26))
        d.text((x + 8, y + 5), lb, font=f, fill=(220, 230, 255))
    os.makedirs(os.path.dirname(out), exist_ok=True)
    sheet.save(out)
    print("[tune] wrote", out)
    return out


def _cam(sc, loc, tgt, lens=50, ortho=None):
    import bpy
    from mathutils import Vector
    cam = sc.camera
    cam.location = loc
    d = Vector(tgt) - Vector(loc)
    cam.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()
    cam.data.type = "ORTHO" if ortho else "PERSP"
    if ortho:
        cam.data.ortho_scale = ortho
    cam.data.lens = lens


def view_spec(name, posed_pts):
    """camera (loc, target, lens, ortho) for a named view. posed_pts: dict of world points."""
    c = posed_pts["center"]
    hl, hr = posed_pts["handL"], posed_pts["handR"]
    sh = posed_pts["shoulders"]
    ft = posed_pts["feet"]
    span = posed_pts["span"]
    dist = max(2.4, span * 1.9)
    cx, cy, cz = c
    V = {
        "front": ((cx, cy - dist, cz + 0.1), c, 50, None),
        "front34": ((cx + dist * 0.62, cy - dist * 0.78, cz + 0.35), c, 50, None),
        "side": ((cx + dist, cy, cz + 0.05), c, 50, None),
        "back": ((cx, cy + dist, cz + 0.1), c, 50, None),
        "back34": ((cx + dist * 0.62, cy + dist * 0.78, cz + 0.35), c, 50, None),
        "top": ((cx + 0.01, cy - 0.01, cz + dist * 1.2), c, 50, None),
        "torso": ((sh[0], sh[1] - 1.3, sh[2] - 0.15), (sh[0], sh[1], sh[2] - 0.2), 50, None),
        "shoulders": ((sh[0] + 0.7, sh[1] - 0.9, sh[2] + 0.25), sh, 55, None),
        "feet": ((ft[0] + 0.5, ft[1] - 0.8, 0.45), (ft[0], ft[1], 0.08), 50, None),
    }
    def hand_view(p):
        return ((p[0] + 0.25, p[1] - 0.45, p[2] + 0.25), p, 50, None)
    mid = tuple((a + b) / 2 for a, b in zip(hl, hr))
    V["hands"] = ((mid[0] + 0.35, mid[1] - 0.9, mid[2] + 0.35), mid, 45, None)
    V["hands_l"] = hand_view(hl)
    V["hands_r"] = ((hr[0] - 0.25, hr[1] - 0.45, hr[2] + 0.25), hr, 50, None)
    return V[name]


def posed_points(sh):
    import bpy
    from mathutils import Vector
    dg = bpy.context.evaluated_depsgraph_get()
    ev = sh.body.evaluated_get(dg)
    me = ev.to_mesh()
    import numpy as np
    n = len(me.vertices)
    P = np.empty(n * 3, np.float32); me.vertices.foreach_get("co", P); P = P.reshape(-1, 3)
    ev.to_mesh_clear()
    M = np.array(sh.body.matrix_world)
    P = P @ M[:3, :3].T + M[:3, 3]
    lo, hi = P.min(0), P.max(0)
    rig = sh.rig
    pb = rig.pose.bones
    w = lambda b: tuple(rig.matrix_world @ pb[b].head)
    sL, sR = w("upperarm01.L"), w("upperarm01.R")
    fL, fR = w("foot.L"), w("foot.R")
    return {"center": tuple((lo + hi) / 2), "span": float(max(hi - lo)),
            "handL": w("finger3-1.L"), "handR": w("finger3-1.R"),
            "shoulders": tuple((a + b) / 2 for a, b in zip(sL, sR)),
            "feet": tuple((a + b) / 2 for a, b in zip(fL, fR))}


def render_views(sh, frame, views, prefix, size=(300, 420), samples=6):
    import bpy
    sc = sh.scene
    sc.render.resolution_x, sc.render.resolution_y = size
    sc.cycles.samples = samples
    for ob in (sh.cam, sh.cam_tgt):
        ob.animation_data_clear()
    for c in list(sh.cam.constraints):
        sh.cam.constraints.remove(c)
    sc.frame_set(frame)
    pts = posed_points(sh)
    outs = []
    for v in views:
        loc, tgt, lens, ortho = view_spec(v, pts)
        _cam(sc, loc, tgt, lens, ortho)
        p = f"{prefix}_{frame:04d}_{v}.png"
        sc.render.filepath = p
        bpy.ops.render.render(write_still=True)
        outs.append(p)
    return outs


def parse_set(items):
    return dict(kv.split("=", 1) for kv in items)


def cmd_body(a):
    import bpy
    from fitanim import scene as S, character as C, poser as PZ, exercises as EX
    profiles = a.compare or [a.profile]
    paths, labels = [], []
    for prof in profiles:
        S.reset(); sc = bpy.context.scene
        S.setup_render(sc, 300, 460, samples=a.samples)
        ob, rig = C.build_character(subdiv=1, profile=prof, overrides=parse_set(a.set))
        mp = C.load_profile(prof, parse_set(a.set)).get("material", {})
        mat = S.mat_porcelain(muscles=a.muscles or [], roughness=mp.get("roughness"), coat=mp.get("coat"),
                              sheen=mp.get("sheen"), base=mp.get("base"))
        mat.node_tree.nodes["HL"].outputs[0].default_value = 1.0 if a.muscles else 0.0
        ob.data.materials.append(mat)
        S.build_studio()
        pz = PZ.Poser(rig)
        P = EX.arms_down(EX.stand(0.14, 8), 0.28, 0.88) if not a.apose else {}
        pz.apply(pz.solve(P))
        cam, tgt = S.add_camera()
        for c in list(cam.constraints):
            cam.constraints.remove(c)
        views = [("front", (0, -3.6, 1.0), (0, 0, 0.95), 42), ("3/4", (2.4, -2.7, 1.15), (0, 0, 0.95), 42),
                 ("side", (3.6, 0, 1.0), (0, 0, 0.95), 42), ("back", (0, 3.6, 1.0), (0, 0, 0.95), 42),
                 ("torso", (0.35, -1.5, 1.3), (0, 0, 1.25), 50), ("arm", (1.0, -1.1, 1.3), (0.25, 0, 1.15), 50)]
        tag = (prof if isinstance(prof, str) else "custom") + ("+" + ",".join(a.set) if a.set else "")
        for name, loc, tg, lens in views:
            _cam(sc, loc, tg, lens)
            p = os.path.join(ROOT, "out", "tune", "tmp", f"body_{abs(hash(tag))}_{name.replace('/', '')}.png")
            sc.render.filepath = p
            bpy.ops.render.render(write_still=True)
            paths.append(p); labels.append(f"{tag} · {name}")
    out = os.path.join(ROOT, "out", "tune", a.name or ("body_" + "_vs_".join(map(str, profiles)) + ".png"))
    labelled_grid(paths, labels, out, cols=6)


def resolve_exercise(name):
    """'squat' = fitanim library, 'bf:curl:cable' = Bodyformance motion + equipment."""
    if name.startswith("bf:"):
        from fitanim import bf_motions as BF
        parts = name.split(":")
        return BF.make_exercise(parts[1], parts[2] if len(parts) > 2 else "none", parts[1].upper(), "", ["abs"])
    return name


def cmd_pose(a):
    from fitanim import director as D
    sh = D.Shot(resolve_exercise(a.exercise), "preview", profile=a.profile, overrides=parse_set(a.set)).build()
    sh.bake()
    fps = sh.scene.render.fps
    paths, labels = [], []
    for ph in a.phases:
        f = int(round((sh.ex.intro + sh.ex.rep_time * ph) * fps)) + 1
        outs = render_views(sh, f, a.views, os.path.join(ROOT, "out", "tune", "tmp", a.exercise.replace(":", "_")),
                            samples=a.samples)
        paths += outs; labels += [f"{a.exercise} phase {ph:.2f} · {v}" for v in a.views]
    out = os.path.join(ROOT, "out", "tune", a.name or f"pose_{a.exercise.replace(':', '_')}.png")
    labelled_grid(paths, labels, out, cols=len(a.views))


def cmd_ref(a):
    from PIL import Image
    from fitanim import director as D
    sh = D.Shot(a.exercise, "preview", profile=a.profile, overrides=parse_set(a.set)).build()
    sh.bake()
    f = int(round((sh.ex.intro + sh.ex.rep_time * a.phase) * sh.scene.render.fps)) + 1
    sh.scene.cycles.samples = a.samples
    p = os.path.join(ROOT, "out", "tune", "tmp", f"ref_{a.exercise}.png")
    sh.render(os.path.dirname(p), frames=[f])
    mine = os.path.join(os.path.dirname(p), f"f_{f:04d}.png")
    r = Image.open(a.image).convert("RGB"); m = Image.open(mine).convert("RGB")
    r = r.resize((int(r.width * m.height / r.height), m.height))
    out = os.path.join(ROOT, "out", "tune", a.name or f"ref_{a.exercise}.png")
    labelled_grid([a.image and _save(r, p + "_r.png"), mine], ["reference", "fitanim"], out, cols=2)


def _save(im, p):
    im.save(p); return p


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--profile", default=None)
    common.add_argument("--set", action="append", default=[], metavar="KEY=VAL")
    common.add_argument("--samples", type=int, default=6)
    common.add_argument("--name", help="output file name")
    b = sub.add_parser("body", parents=[common])
    b.add_argument("--compare", nargs="+")
    b.add_argument("--muscles", nargs="*", help="highlight these muscles")
    b.add_argument("--apose", action="store_true", help="rest pose instead of arms down")
    p = sub.add_parser("pose", parents=[common])
    p.add_argument("exercise")
    p.add_argument("--phases", type=float, nargs="+", default=[0.0, 0.45])
    p.add_argument("--views", nargs="+", default=["front34", "side", "hands"])
    r = sub.add_parser("ref", parents=[common])
    r.add_argument("exercise"); r.add_argument("--image", required=True); r.add_argument("--phase", type=float, default=0.45)
    a = ap.parse_args()
    t = time.time()
    {"body": cmd_body, "pose": cmd_pose, "ref": cmd_ref}[a.cmd](a)
    print(f"[tune] done in {time.time() - t:.0f}s")


if __name__ == "__main__":
    main()
