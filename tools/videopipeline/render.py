#!/usr/bin/env python3
"""fitanim — render 3D exercise animations (glossy mannequin, blue studio, muscle highlights).

Examples:
  python render.py --list
  python render.py squat --quality draft
  python render.py pushup curl --quality final --reps 3 --handle @meinaccount
  python render.py squat --export-glb out/squat.glb --no-render     # animated model for apps/web
  python render.py all --quality preview
"""
import argparse, os, sys, time, shutil

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("exercises", nargs="*", help="exercise keys or 'all'")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--quality", default="draft", choices=["preview", "draft", "final", "hd"])
    ap.add_argument("--reps", type=int)
    ap.add_argument("--camera")
    ap.add_argument("--reel", action="store_true", help="camera cuts between angles at each rep")
    ap.add_argument("--handle", default=None, help="text bottom-left, e.g. @deinaccount")
    ap.add_argument("--out", default="out")
    ap.add_argument("--every", type=int, default=1, help="render every n-th frame (fast tests)")
    ap.add_argument("--no-overlay", action="store_true")
    ap.add_argument("--no-render", action="store_true")
    ap.add_argument("--export-glb")
    ap.add_argument("--web", action="store_true", help="GLB small for web (Draco, only target mask)")
    ap.add_argument("--save-blend", action="store_true")
    ap.add_argument("--samples", type=int)
    ap.add_argument("--profile", help="body profile name in profiles/ or path to .json (default athlete)")
    ap.add_argument("--set", action="append", default=[], metavar="KEY=VAL",
                    help="override profile values, e.g. --set sculpt.groups.arms=1.6")
    a = ap.parse_args()

    from fitanim import director as D, post as PO
    if a.list:
        for k, c in D.EX.LIBRARY.items():
            print(f"{k:10s} {c.title:26s} {c.subtitle}")
        return
    keys = list(D.EX.LIBRARY) if (not a.exercises or a.exercises == ["all"]) else a.exercises
    for k in keys:
        t0 = time.time()
        ov = dict(kv.split('=', 1) for kv in a.set)
        sh = D.Shot(k, a.quality, reps=a.reps, camera=a.camera, reel=a.reel, profile=a.profile, overrides=ov).build()
        if a.samples:
            sh.scene.cycles.samples = a.samples
        n = sh.bake()
        base = os.path.join(a.out, k)
        os.makedirs(base, exist_ok=True)
        if a.save_blend:
            sh.save(os.path.join(base, f"{k}.blend"))
        if a.export_glb:
            sh.export_glb(a.export_glb if len(keys) == 1 else os.path.join(a.export_glb, f"{k}.glb"), web=a.web)
        if a.no_render:
            continue
        cards = [] if a.no_overlay else sh.render_muscle_card(os.path.join(base, "card.png"))
        frames_dir = os.path.join(base, "frames")
        if os.path.isdir(frames_dir):
            shutil.rmtree(frames_dir)
        sh.render(frames_dir, every=a.every)
        fps = sh.scene.render.fps // a.every
        mp4 = os.path.join(a.out, f"{k}_{a.quality}.mp4")
        PO.finish(frames_dir, mp4, fps=fps, card_paths=cards,
                  title="" if a.no_overlay else sh.ex.title,
                  subtitle=sh.ex.subtitle, handle=a.handle)
        print(f"[fitanim] {k}: {mp4}  ({n} frames, {time.time() - t0:.0f}s)")


if __name__ == "__main__":
    main()
