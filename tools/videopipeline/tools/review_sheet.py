#!/usr/bin/env python3
"""Schnelle Sichtprüfung (Workbench-Renderer, Sekunden statt Minuten):
für jede Bewegung/Gerät-Kombi ein Bogen mit mehreren Phasen x Ansichten (Clip-Kamera, frontal, seitlich).

  python tools/review_sheet.py                         # alle Kombis -> out/review/<motion>_<eq>.png
  python tools/review_sheet.py --only curl:dumbbell --phases 0 0.25 0.5 --views clip side hands
"""
import argparse, os, sys, time
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT); sys.path.insert(0, os.path.join(ROOT, "tools"))


def review(motion, eq, phases, views, out, size=(200, 356)):
    import bpy
    from fitanim import director as D, bf_motions as BF
    import tune as T
    ex = BF.make_exercise(motion, eq, motion.upper(), "", ["abs"])
    sh = D.Shot(ex, "preview").build()
    sc = sh.scene
    sc.render.engine = "BLENDER_WORKBENCH"
    sh_ = sc.display.shading
    sh_.light = "STUDIO"; sh_.color_type = "OBJECT"; sh_.show_shadows = True; sh_.show_cavity = True
    sc.display.shading.cavity_type = "WORLD"
    for ob in sc.objects:
        if ob.name.startswith(("Backdrop",)):
            ob.hide_render = True
        if ob == sh.body:
            ob.color = (0.92, 0.92, 0.95, 1)
        elif ob.type == "MESH":
            ob.color = (0.25, 0.3, 0.45, 1) if not ob.name.startswith(("Floor",)) else (0.55, 0.57, 0.6, 1)
    sc.render.resolution_x, sc.render.resolution_y = size
    n = sh.frames()
    sh._camera(n)
    fps = sc.render.fps
    paths, labels = [], []
    tmp = os.path.join(ROOT, "out", "review", "tmp"); os.makedirs(tmp, exist_ok=True)
    ctx = sh.ctx
    cam_anim = sh.cam.animation_data.action if sh.cam.animation_data else None
    for ph in phases:
        f = int(round((ex.intro + ex.rep_time * ph) * fps)) + 1 if ph >= 0 else 1
        t = (f - 1) / fps
        P, posed = D.frame_pose(ex, sh, t, ctx)
        sh.poser.apply(posed)
        sh._props_at(posed, P, f)
        for v in views:
            if v == "clip":
                if sh.cam.animation_data:
                    sh.cam.animation_data.action = cam_anim
                if sh.cam_tgt.animation_data is None:
                    pass
                sc.frame_set(f)
            else:
                sc.frame_set(f)
                if sh.cam.animation_data:
                    sh.cam.animation_data.action = None
                cons = list(sh.cam.constraints)
                pts = T.posed_points(sh)
                loc, tgt, lens, _ = T.view_spec(v, pts)
                for c in cons:
                    c.mute = True
                T._cam(sc, loc, tgt, lens * 1.45)
            p = os.path.join(tmp, f"{motion}_{eq}_{f:04d}_{v}.png")
            sc.render.filepath = p
            bpy.ops.render.render(write_still=True)
            for c in sh.cam.constraints:
                c.mute = False
            paths.append(p); labels.append(f"{ph:.2f} {v}" if ph >= 0 else f"start {v}")
    T.labelled_grid(paths, labels, out, cols=len(views) * min(len(phases), 3 if len(views) > 2 else 4))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--phases", type=float, nargs="+", default=[-1, 0.15, 0.3, 0.45, 0.65, 0.85])
    ap.add_argument("--views", nargs="+", default=["clip", "side", "front"])
    ap.add_argument("--out", default=os.path.join(ROOT, "out", "review"))
    ap.add_argument("--tag", default="")
    ap.add_argument("--shard", default="0/1")
    a = ap.parse_args()
    import bpy  # noqa
    import motion_lint as ML
    cs = ML.combos(a.only)
    si, sn = map(int, a.shard.split("/"))
    for (m, e), fams in cs[si::sn]:
        t = time.time()
        try:
            review(m, e, a.phases, a.views, os.path.join(a.out, f"{m}_{e}{a.tag}.png"))
        except Exception as ex:
            import traceback; traceback.print_exc()
        print(f"[review] {m}:{e} {time.time() - t:.0f}s", flush=True)


if __name__ == "__main__":
    main()
