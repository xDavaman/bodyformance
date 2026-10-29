#!/usr/bin/env python3
"""Render-Warteschlange für den PC.

Einmal starten (START_RENDER_WORKER.bat) und laufen lassen. Der Worker schaut alle 10 s in
Desktop\\Fitness-Video-Pipeline\\_queue nach Auftragsdateien (*.job, JSON) und arbeitet sie nacheinander ab.
Erlaubt sind NUR Render-Aufträge der Pipeline – keine beliebigen Befehle:

  {"type": "fitanim", "keys": ["squat", "pushup"], "quality": "final"}
  {"type": "bodyformance", "families": [0, 5, 12] | "all", "quality": "final"}
  {"type": "bodyformance_motion", "motion": "curl", "equipment": "cable", "quality": "preview"}
  {"type": "sheet", "phase": 0.42}

Anhalten: _queue\\STOP.txt mit dem Wort "stop" -> laufender Batch endet nach dem aktuellen Clip,
neue Aufträge warten. "weiter" hineinschreiben (oder Datei leeren) -> geht weiter.
Status: _queue\\status.txt · Protokolle: _queue\\logs\\<auftrag>.log · erledigte Aufträge: _queue\\done\\
"""
import json, os, re, subprocess, sys, time, shutil

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))          # .../fitanim
PIPE = os.path.join(os.path.expanduser("~"), "Desktop", "Fitness-Video-Pipeline")
Q = os.path.join(PIPE, "_queue")
OUT3D = os.path.join(PIPE, "03_Videos", "3D")
OUTBF = os.path.join(PIPE, "03_Videos", "Bodyformance")
SAFE = re.compile(r"^[A-Za-z0-9_]{1,40}$")
QUALITIES = {"preview", "draft", "final", "hd"}


def status(msg):
    os.makedirs(Q, exist_ok=True)
    with open(os.path.join(Q, "status.txt"), "w", encoding="utf-8") as f:
        f.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')}  {msg}\n")


def build_cmd(job):
    py = sys.executable
    q = job.get("quality", "final")
    if q not in QUALITIES:
        raise ValueError(f"Qualität {q!r} nicht erlaubt")
    t = job.get("type")
    if t == "fitanim":
        keys = job.get("keys", [])
        if not keys or not all(SAFE.match(k) for k in keys):
            raise ValueError("ungültige Übungs-Keys")
        return [py, os.path.join(HERE, "render.py"), *keys, "--quality", q, "--out", OUT3D]
    if t == "bodyformance":
        fam = job.get("families", "all")
        ids = ["all"] if fam == "all" else [str(int(x)) for x in fam]
        extra = [f for f in ("force", "adopt", "plan") if job.get(f)]
        return [py, os.path.join(HERE, "tools", "bodyformance_render.py"), "--families", *ids, "--quality", q, "--out", OUTBF,
                *["--" + f for f in extra]]
    if t == "bodyformance_motion":
        m, e = job.get("motion", ""), job.get("equipment", "none")
        if not (SAFE.match(m) and SAFE.match(e)):
            raise ValueError("ungültige Bewegung/Gerät")
        return [py, os.path.join(HERE, "tools", "bodyformance_render.py"), "--motion", m, "--equipment", e,
                "--quality", q, "--out", OUTBF]
    if t == "sheet":
        return [py, os.path.join(HERE, "tools", "bodyformance_render.py"), "--sheet", "--phase",
                str(float(job.get("phase", 0.42))), "--out", os.path.join(OUTBF, "_check")]
    raise ValueError(f"Auftragstyp {t!r} nicht erlaubt")


STOP = os.path.join(Q, "STOP.txt")


def stopped():
    try:
        return open(STOP, encoding="utf-8").read().strip().lower().startswith("stop")
    except OSError:
        return False


def main():
    os.environ["FITANIM_STOP_FILE"] = STOP
    for d in ("logs", "done", "failed"):
        os.makedirs(os.path.join(Q, d), exist_ok=True)
    status("bereit – warte auf Aufträge")
    print("Render-Worker läuft. Aufträge in:", Q)
    while True:
        jobs = sorted(f for f in os.listdir(Q) if f.endswith(".job"))
        if jobs and stopped():
            status(f"angehalten (STOP.txt) – {len(jobs)} Auftrag/Aufträge warten")
            time.sleep(10)
            continue
        if not jobs:
            time.sleep(10)
            continue
        name = jobs[0]
        path = os.path.join(Q, name)
        log = os.path.join(Q, "logs", name.replace(".job", ".log"))
        try:
            job = json.load(open(path, encoding="utf-8"))
            cmd = build_cmd(job)
        except Exception as e:
            open(log, "w", encoding="utf-8").write(f"Auftrag abgelehnt: {e}\n")
            shutil.move(path, os.path.join(Q, "failed", name))
            continue
        status(f"läuft: {name}  ({' '.join(cmd[2:])})")
        print(time.strftime("%H:%M:%S"), "starte", name)
        t0 = time.time()
        with open(log, "w", encoding="utf-8") as lf:
            rc = subprocess.call(cmd, cwd=HERE, stdout=lf, stderr=subprocess.STDOUT)
        dest = "done" if rc == 0 else "failed"
        shutil.move(path, os.path.join(Q, dest, name))
        status(f"{'fertig' if rc == 0 else 'FEHLER'}: {name} in {time.time() - t0:.0f}s – warte auf Aufträge")
        print(time.strftime("%H:%M:%S"), dest, name)


if __name__ == "__main__":
    main()
