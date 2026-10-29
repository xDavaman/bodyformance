#!/usr/bin/env python3
"""Animiert die Bodyformance-Übungen mit der fitanim-Pipeline.

  python tools/bodyformance_render.py --coverage                 # welche Bewegungen/Geräte es gibt
  python tools/bodyformance_render.py --sheet --out out/bf_check  # Posen-Kontaktbogen aller 73 Bewegungen (schnell)
  python tools/bodyformance_render.py --families all --quality final --out <ordner>   # ein Clip pro Familie (212)
  python tools/bodyformance_render.py --families 0 12 40 --quality preview
  python tools/bodyformance_render.py --motion curl --equipment cable
Schreibt zusätzlich <out>/bodyformance_index.json: jede der 4.294 Übungen -> Clip-Datei + Muskeln.
"""
import argparse, json, os, sys, time, shutil
from collections import Counter, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
DATA = os.path.join(ROOT, "data", "bodyformance_exercises.json")


def load():
    d = json.load(open(DATA, encoding="utf-8"))
    return d["families"], d["exercises"]


def family_choice(fams, rows):
    """Representative exercise (name + equipment) per family: the first row = base variant."""
    rep = {}
    for r in rows:
        rep.setdefault(r["family"], r)
    return rep


def clean_title(name):
    return name.split(" (")[0].upper()


_POSER = []


def poser():
    """One rig-only poser per process (for fingerprints; survives scene resets - it keeps copies)."""
    if not _POSER:
        from fitanim import scene as S, character as C, poser as PZ
        S.reset()
        ob, rig = C.build_character(subdiv=0)
        from fitanim import collide as CO
        pz = PZ.Poser(rig)
        _POSER.append(pz); _POSER.append(CO.corrector_for(pz, ob))
    return _POSER[0]


def corrector():
    poser()
    return _POSER[1]


def plan(motion, eq, title, subtitle, muscles, key, quality, overlay=True):
    from fitanim import bf_motions as BF, fingerprint as FP
    ex = BF.make_exercise(motion, eq, title, subtitle, muscles)
    ex.key = key
    fps = 30
    n = int(round((ex.intro + ex.reps * ex.rep_time + 0.6) * fps))
    return ex, FP.trajectory(ex, poser(), fps, n, corrector()), FP.meta_of(ex, quality, overlay)


def stop_requested():
    """_queue/STOP.txt mit Inhalt 'stop' hält an (nach dem aktuellen Clip), 'weiter' oder leer = weiter."""
    f = os.environ.get("FITANIM_STOP_FILE")
    try:
        return bool(f) and open(f, encoding="utf-8").read().strip().lower().startswith("stop")
    except OSError:
        return False


def render_one(motion, eq, title, subtitle, muscles, out_dir, quality, key, samples=None, overlay=True, still=None,
               fp=None):
    from fitanim import director as D, post as PO, bf_motions as BF, fingerprint as FP
    ex = BF.make_exercise(motion, eq, title, subtitle, muscles)
    ex.key = key
    sh = D.Shot(ex, quality).build()
    if samples:
        sh.scene.cycles.samples = samples
    n = sh.bake()
    base = os.path.join(out_dir, key)
    os.makedirs(base, exist_ok=True)
    if still is not None:     # single frame for contact sheets
        f = int((ex.intro + ex.rep_time * still) * sh.scene.render.fps) + 1
        sh.render(base, frames=[min(f, n)])
        return os.path.join(base, f"f_{min(f, n):04d}.png")
    cards = sh.render_muscle_card(os.path.join(base, "card.png")) if overlay else []
    frames = os.path.join(base, "frames")
    shutil.rmtree(frames, ignore_errors=True)
    sh.render(frames)
    mp4 = os.path.join(out_dir, f"{key}.mp4")
    PO.finish(frames, mp4, fps=sh.scene.render.fps, card_paths=cards, title=title if overlay else "", subtitle=subtitle)
    shutil.rmtree(frames, ignore_errors=True)
    shutil.rmtree(frames + "_comp", ignore_errors=True)
    if fp is not None:
        FP.save(mp4, *fp)
    return mp4


DE = {"chest": "Brust", "lats": "Latissimus", "traps": "Trapez", "delts": "Schultern", "biceps": "Bizeps",
      "triceps": "Trizeps", "forearms": "Unterarme", "abs": "Bauch", "lowerback": "Unterer Rücken", "glutes": "Gesäß",
      "quads": "Quadrizeps", "hamstrings": "Beinbeuger", "adductors": "Adduktoren", "hipflexors": "Hüftbeuger",
      "calves": "Waden", "neck": "Nacken"}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--coverage", action="store_true")
    ap.add_argument("--sheet", action="store_true")
    ap.add_argument("--families", nargs="*")
    ap.add_argument("--motion"); ap.add_argument("--equipment", default="none")
    ap.add_argument("--quality", default="preview"); ap.add_argument("--samples", type=int)
    ap.add_argument("--out", default=os.path.join(ROOT, "out", "bodyformance"))
    ap.add_argument("--no-overlay", action="store_true")
    ap.add_argument("--phase", type=float, default=0.42)
    ap.add_argument("--force", action="store_true", help="alles neu rendern, Fingerprints ignorieren")
    ap.add_argument("--adopt", action="store_true",
                    help="nur Fingerprints für vorhandene Clips schreiben (Clips gelten als aktuell)")
    ap.add_argument("--plan", action="store_true", help="nur anzeigen, welche Clips neu gerendert würden")
    a = ap.parse_args()
    fams, rows = load()
    rep = family_choice(fams, rows)
    import bpy  # noqa: F401  (provides mathutils)
    from fitanim import bf_motions as BF
    os.makedirs(a.out, exist_ok=True)

    if a.coverage:
        mc = Counter(r["motion"] for r in rows)
        missing = [m for m in mc if m not in BF.MOTIONS]
        print(f"{len(fams)} Familien, {len(rows)} Übungen, {len(mc)} Bewegungen, ohne Animation: {missing or 'keine'}")
        return

    if a.sheet:
        from PIL import Image, ImageDraw, ImageFont
        motions = sorted({r["motion"] for r in rows})
        tiles = []
        for m in motions:
            fam = next(f for f in range(len(fams)) if fams[f]["motion"] == m)
            r = rep[fam]
            t0 = time.time()
            try:
                p = render_one(m, r["equipment"], clean_title(r["name"]), "", r["primary"], os.path.join(a.out, "sheet"),
                               "preview", f"{m}_{r['equipment']}", samples=4, still=a.phase)
                tiles.append((m + " · " + r["equipment"], p))
            except Exception as e:
                print("FEHLER", m, e)
                tiles.append((m + " FEHLER", None))
            print(f"[sheet] {m} {time.time() - t0:.0f}s", flush=True)
        W, H = 180, 320
        cols = 8
        rows_n = (len(tiles) + cols - 1) // cols
        sheet = Image.new("RGB", (cols * W, rows_n * (H + 18)), (10, 14, 30))
        d = ImageDraw.Draw(sheet)
        for i, (lb, p) in enumerate(tiles):
            x, y = (i % cols) * W, (i // cols) * (H + 18)
            if p:
                sheet.paste(Image.open(p).convert("RGB").resize((W, H)), (x, y + 18))
            d.text((x + 4, y + 3), lb, fill=(220, 230, 255))
        out = os.path.join(a.out, f"sheet_{a.phase:.2f}.png")
        sheet.save(out); print("[sheet]", out)
        return

    jobs = []
    if a.motion:
        jobs.append((a.motion, a.equipment, a.motion.upper(), "", ["abs"], f"{a.motion}_{a.equipment}"))
    if a.families is not None:
        ids = range(len(fams)) if a.families in ([], ["all"]) else [int(x) for x in a.families]
        for fi in ids:
            r = rep[fi]
            f = fams[fi]
            sub = " · ".join(DE.get(m, m) for m in f["primary"][:3])
            from fitanim import bf_family as BFF
            m_, e_ = BFF.family_motion(fi, r["name"], f["motion"], r["equipment"])
            jobs.append((m_, e_, clean_title(r["name"]), sub, f["primary"], f"bf_{fi:03d}_{f['motion']}"))
    index_path = os.path.join(a.out, "bodyformance_index.json")
    done = {}
    from fitanim import fingerprint as FP
    todo = 0
    for motion, eq, title, sub, mus, key in jobs:
        if stop_requested():
            print("[stop] Stopp-Datei gefunden - beende nach dem letzten fertigen Clip", flush=True)
            break
        mp4 = os.path.join(a.out, key + ".mp4")
        ex, traj, meta = plan(motion, eq, title, sub, mus, key, a.quality, not a.no_overlay)
        if a.adopt:
            if os.path.exists(mp4):
                FP.save(mp4, traj, meta); print("[adopt]", key)
            continue
        ok, why = FP.up_to_date(mp4, traj, meta)
        if ok and not a.force:
            print(f"[skip] {key} ({why})"); done[key] = mp4; continue
        todo += 1
        if a.plan:
            print(f"[neu] {key} ({why})"); continue
        t0 = time.time()
        try:
            done[key] = render_one(motion, eq, title, sub, mus, a.out, a.quality, key, a.samples, not a.no_overlay,
                                   fp=(traj, meta))
            print(f"[ok] {key} {time.time() - t0:.0f}s ({why})", flush=True)
        except Exception as e:
            print(f"[FEHLER] {key}: {e}", flush=True)
    if a.plan or a.adopt:
        print(f"[plan] {todo} Clips müssten neu gerendert werden")
        return
    # index: every exercise -> its family clip
    idx = []
    for r in rows:
        key = f"bf_{r['family']:03d}_{r['motion']}"
        idx.append(dict(name=r["name"], family=r["family"], motion=r["motion"], equipment=r["equipment"],
                        primary=r["primary"], secondary=r["secondary"],
                        video=f"{key}.mp4" if os.path.exists(os.path.join(a.out, key + ".fp.npz")) else None))
    json.dump(idx, open(index_path, "w"), ensure_ascii=False, indent=1)
    print("[index]", index_path, sum(1 for i in idx if i["video"]), "von", len(idx), "Übungen haben ein Video")


if __name__ == "__main__":
    main()
