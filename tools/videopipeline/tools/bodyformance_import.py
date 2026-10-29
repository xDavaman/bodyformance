#!/usr/bin/env python3
"""Liest die Übungsbibliothek aus Bodyformance (FitScan/ExerciseDB.swift) und schreibt
data/bodyformance_exercises.json: jede Übung mit Familie, Bewegung (motionKey), Gerät, Muskeln, Tipps.

    python tools/bodyformance_import.py /pfad/zu/bodyformance
"""
import json, os, re, sys
from collections import Counter

MUSCLE = {"ch": "chest", "la": "lats", "tr": "traps", "sh": "delts", "bi": "biceps", "tri": "triceps",
          "fo": "forearms", "ab": "abs", "lb": "lowerback", "gl": "glutes", "qu": "quads", "ha": "hamstrings",
          "ad": "adductors", "hf": "hipflexors", "ca": "calves", "ne": "neck"}


def block(src, name):
    m = re.search(r'static let %s = #"""\n(.*?)\n"""#' % name, src, re.S)
    if not m:
        raise SystemExit(f"Block {name} nicht gefunden")
    return [l for l in m.group(1).split("\n") if l.strip()]


def load(repo):
    src = open(os.path.join(repo, "FitScan", "ExerciseDB.swift"), encoding="utf-8").read()
    fams = []
    for line in block(src, "families"):
        p = line.split("|", 11)
        fams.append(dict(category=p[0], kind=p[1], primary=[MUSCLE.get(x, x) for x in p[2].split()],
                         secondary=[MUSCLE.get(x, x) for x in p[3].split()], motion=p[4], target=p[5],
                         region=p[6], dose=p[7], seconds=int(p[8] or 0), per_side=p[9] == "1",
                         start_factor=float(p[10] or 0), tips=p[11].split("~")))
    rows = []
    for line in block(src, "rows"):
        p = line.split("|", 3)
        if len(p) != 4:
            continue
        fi = int(p[1])
        rows.append(dict(name=p[0], family=fi, equipment=p[2], note=p[3], **{k: fams[fi][k] for k in
                    ("category", "motion", "primary", "secondary", "target")}))
    return fams, rows


if __name__ == "__main__":
    repo = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/xdavaman/bodyformance"
    fams, rows = load(repo)
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.makedirs(os.path.join(root, "data"), exist_ok=True)
    out = os.path.join(root, "data", "bodyformance_exercises.json")
    json.dump(dict(families=fams, exercises=rows), open(out, "w"), ensure_ascii=False, indent=1)
    print(f"{len(fams)} Familien, {len(rows)} Übungen -> {out}")
    mc = Counter(r["motion"] for r in rows)
    print(f"{len(mc)} Bewegungen:")
    for m, c in mc.most_common():
        eq = Counter(r["equipment"] for r in rows if r["motion"] == m)
        fams_m = sorted({r["family"] for r in rows if r["motion"] == m})
        ex = rows[[r["family"] for r in rows].index(fams_m[0])]["name"]
        print(f"  {m:16s} {c:5d}  Fam {len(fams_m):3d}  {dict(eq)}  z.B. {ex}")
