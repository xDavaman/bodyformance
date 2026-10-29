"""Motion fingerprints: decide whether an already rendered clip is still up to date.

For every clip a sidecar <clip>.fp.npz is written that stores the world positions of the key
joints for every frame plus a JSON meta string (props, camera, timing, title, quality).
Re-running a batch only re-renders clips whose motion moved by more than TOL metres or whose
meta changed - so fixing one exercise never forces the whole library to be rendered again.
"""
import json, os
import numpy as np

RENDER_VERSION = 2          # bump when the look (material, light, overlay) or the whole rig changes -> everything re-renders
                            # v2: anatomical joint limits (poser guards) + technique rework of the motions
TOL = 0.004                 # metres
JOINTS = ["root", "spine01", "neck01", "head", "upperarm01.L", "upperarm01.R", "lowerarm01.L", "lowerarm01.R",
          "wrist.L", "wrist.R", "finger3-1.L", "finger3-1.R", "upperleg01.L", "upperleg01.R",
          "lowerleg01.L", "lowerleg01.R", "foot.L", "foot.R", "toe1-1.L", "toe1-1.R"]


def meta_of(ex, quality, overlay=True):
    cam = getattr(ex, "cam", None) if ex.camera == "custom" else ex.camera
    m = dict(v=RENDER_VERSION, q=quality, overlay=bool(overlay), title=ex.title, sub=ex.subtitle,
             mus=list(ex.muscles), props=ex.props, cam=cam, rep=ex.rep_time, reps=ex.reps, intro=ex.intro)
    return json.dumps(m, sort_keys=True, default=str)


def trajectory(ex, poser, fps, n, corr=None):
    """(n, J, 3) joint positions, computed with the same pose pipeline as Shot.bake (no scene needed)."""
    from . import director as D
    sh = type("S", (), {})()
    sh.ex = ex
    names = [j for j in JOINTS if j in poser.rest]
    out = np.zeros((n, len(names) + 2, 3), np.float32)
    ctx = {"poser": poser}
    if corr is not None:
        ctx["corr"] = D.configure_corrector(corr, ex)
    for f in range(n):
        t = f / fps
        P, posed = D.frame_pose(ex, sh, t, ctx)
        for k, j in enumerate(names):
            out[f, k] = tuple(posed[j].translation)
        out[f, -2] = tuple(posed["_palmL"]); out[f, -1] = tuple(posed["_palmR"])
    return out


def path_for(mp4):
    return mp4[:-4] + ".fp.npz"


def save(mp4, traj, meta):
    np.savez_compressed(path_for(mp4), traj=traj, meta=np.array(meta))


def up_to_date(mp4, traj, meta):
    p = path_for(mp4)
    if not (os.path.exists(mp4) and os.path.exists(p)):
        return False, "neu"
    try:
        d = np.load(p, allow_pickle=False)
        if str(d["meta"]) != meta:
            return False, "Meta geändert"
        old = d["traj"]
        if old.shape != traj.shape:
            return False, "Länge geändert"
        dev = float(np.abs(old - traj).max())
        return (dev <= TOL), f"max Abweichung {dev * 100:.1f} cm"
    except Exception as e:
        return False, f"Fingerprint unlesbar ({e})"
