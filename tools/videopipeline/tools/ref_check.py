#!/usr/bin/env python3
"""Vergleicht jede Bewegung mit Soll-Gelenkwinkeln aus data/exercise_refs.json (Technik-Referenzen)
und zeigt für eine Bewegung die Gelenkwinkel-Verläufe über eine Wiederholung.

  python tools/ref_check.py                       # alle Bewegungen mit Referenz -> out/refcheck/report.md
  python tools/ref_check.py --only curl:dumbbell  # nur diese
  python tools/ref_check.py --curves curl:dumbbell  # Kurven-Plot aller Gelenke gegen ROM-Bänder (PNG)
"""
import argparse, json, math, os, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT); sys.path.insert(0, os.path.join(ROOT, "tools"))
REFS = json.load(open(os.path.join(ROOT, "data", "exercise_refs.json")))
CURVE_KEYS = ["elbow.flex", "shoulder.elev", "shoulder.over", "forearm.sup", "wrist.flex", "wrist.dev",
              "hip.elev", "hip.over", "knee.flex", "ankle.dorsi", "trunk", "spine.bend"]


def sample(motion, eq, n=48):
    """per frame: {metric: (L, R)} over one repetition (+ intro start frame)."""
    from fitanim import director as D, bf_motions as BF, anat as AN
    import bodyformance_render as BR
    pz = BR.poser()
    ex = BF.make_exercise(motion, eq, motion.upper(), "", ["abs"])
    ctx = {"poser": pz, "corr": D.configure_corrector(BR.corrector(), ex)}
    sh = type("S", (), {})(); sh.ex = ex
    rows = []
    for i in range(n + 1):
        t = ex.intro + ex.rep_time * i / n
        P, posed = D.frame_pose(ex, sh, t, ctx)
        M = AN.measure(pz, posed, P)
        up = posed["head"].translation - posed["root"].translation
        trunk = math.degrees(math.acos(max(-1, min(1, up.normalized().z))))
        r = {}
        for k in CURVE_KEYS:
            if k == "trunk":
                r[k] = (trunk, trunk)
            elif k in M:
                r[k] = (M[k], M[k])
            else:
                r[k] = (M["L"].get(k), M["R"].get(k))
        rows.append(r)
    return ex, rows


def evaluate(motion, rows, eq=None):
    out = []
    for metric, agg, lo, hi, note in REFS.get(f"{motion}:{eq}", REFS.get(motion, [])):
        per_side = []
        for si in (0, 1):
            vals = [r[metric][si] for r in rows if r.get(metric) and r[metric][si] is not None]
            if vals:
                per_side.append((min(vals), max(vals)))
        if not per_side:
            continue
        v = {"max": max(p[1] for p in per_side), "min": min(p[0] for p in per_side),
             "max_lo": min(p[1] for p in per_side), "min_hi": max(p[0] for p in per_side)}[agg]
        ok = lo - 3 <= v <= hi + 3
        out.append(dict(metric=metric, agg=agg, value=round(v, 1), ref=[lo, hi], ok=ok, note=note))
    return out


def curves(motion, eq, rows, path):
    from PIL import Image, ImageDraw
    from fitanim import anat as AN
    W, H, pad = 1100, 120, 4
    keys = [k for k in CURVE_KEYS if any(r[k][0] is not None for r in rows)]
    img = Image.new("RGB", (W, H * len(keys) + 30), (18, 20, 28))
    dr = ImageDraw.Draw(img)
    dr.text((10, 8), f"{motion}:{eq}  Gelenkwinkel ueber 1 Wiederholung (L blau, R orange; grau = Norm, gruen = Soll)",
            fill=(230, 230, 230))
    refs = {}
    for metric, agg, lo, hi, note in REFS.get(motion, []):
        refs.setdefault(metric, []).append((lo, hi))
    for j, k in enumerate(keys):
        y0 = 30 + j * H
        vals = [v for r in rows for v in r[k] if v is not None]
        rom = AN.ROM.get(k) if k in AN.ROM and k not in AN.DISPLAY_ONLY else None
        lo_, hi_ = min(vals + [rom[0] if rom and rom[0] > -500 else 0]), max(vals + [rom[1] if rom else 0])
        lo_, hi_ = lo_ - 10, hi_ + 10
        Y = lambda v: y0 + H - 18 - (v - lo_) / max(hi_ - lo_, 1) * (H - 30)
        X = lambda i: 140 + i / (len(rows) - 1) * (W - 160)
        if rom:
            dr.rectangle([140, Y(min(rom[1], hi_)), W - 20, Y(max(rom[0], lo_))], fill=(40, 44, 54))
        for lo, hi in refs.get(k, []):
            dr.rectangle([140, Y(hi), W - 20, Y(lo)], outline=(60, 180, 90))
        for si, col in ((0, (90, 160, 255)), (1, (255, 160, 60))):
            pts = [(X(i), Y(r[k][si])) for i, r in enumerate(rows) if r[k][si] is not None]
            if len(pts) > 1:
                dr.line(pts, fill=col, width=2)
        dr.text((8, y0 + H / 2 - 12), k, fill=(220, 220, 220))
        dr.text((8, y0 + H / 2 + 2), f"{min(vals):.0f}..{max(vals):.0f}", fill=(150, 150, 150))
    img.save(path)
    return path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--curves", nargs="*")
    ap.add_argument("--out", default=os.path.join(ROOT, "out", "refcheck"))
    a = ap.parse_args()
    import bpy  # noqa
    import motion_lint as ML
    os.makedirs(a.out, exist_ok=True)
    if a.curves:
        for spec in a.curves:
            m, e = spec.split(":")
            ex, rows = sample(m, e)
            print(curves(m, e, rows, os.path.join(a.out, f"{m}_{e}_curves.png")))
            for r in evaluate(m, rows, e):
                print(("OK  " if r["ok"] else "FAIL"), r)
        return
    rep, lines = {}, ["# Soll/Ist-Vergleich Gelenkwinkel\n"]
    for (m, e), fams in ML.combos(a.only):
        if m not in REFS and f"{m}:{e}" not in REFS:
            continue
        ex, rows = sample(m, e, n=24)
        res = evaluate(m, rows, e)
        rep[f"{m}:{e}"] = res
        bad = [r for r in res if not r["ok"]]
        print(f"[ref] {m}:{e:10s} " + ("ok" if not bad else "; ".join(
            f"{r['metric']} {r['agg']}={r['value']} soll {r['ref']}" for r in bad)), flush=True)
        if bad:
            lines.append(f"## {m}:{e}")
            lines += [f"- {r['metric']} ({r['agg']}) = {r['value']}, Soll {r['ref'][0]}..{r['ref'][1]}  {r['note']}" for r in bad]
            lines.append("")
    json.dump(rep, open(os.path.join(a.out, "report.json"), "w"), indent=1, ensure_ascii=False)
    open(os.path.join(a.out, "report.md"), "w").write("\n".join(lines))


if __name__ == "__main__":
    main()
