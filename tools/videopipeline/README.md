# fitanim – 3D-Übungsanimationen im Stil „weißer Mannequin, blaues Studio“

Erzeugt vertikale Fitness-Clips (9:16, 30 fps): glänzende, gesichtslose, muskulöse Figur,
dunkelblaues Studio, schwarze Matte / Rack / Hanteln, rot leuchtende Zielmuskeln,
Neon-Pfeile und ein Glas-Panel mit Muskelkarte. Alles läuft headless mit Blender als
Python-Modul (`bpy`) – kein Blender-GUI nötig.

## Installation

```bash
pip install bpy==5.2.3 numpy pillow     # Blender als Python-Modul (~400 MB), Python 3.13
# ffmpeg muss im PATH sein
```

Mit einer GPU (NVIDIA/Apple) wird viel schneller gerendert: in `fitanim/scene.py`
→ `setup_render()` `c.device = "GPU"` setzen und in den Blender-Preferences das
Backend (CUDA/OPTIX/METAL) aktivieren.

## Benutzung

```bash
python render.py --list                                   # alle Übungen
python render.py squat --quality draft                    # 540x960
python render.py pushup curl --quality final --handle @deinaccount
python render.py all --quality preview                    # Test aller Übungen
python render.py squat --no-render --export-glb squat.glb # animiertes 3D-Modell für App/Web
python render.py squat --save-blend                       # .blend zum Weiterbearbeiten in Blender
```

Qualitätsstufen: `preview` 360×640 · `draft` 540×960 · `final` 720×1280 (wie die Vorlagen) · `hd` 1080×1920.
Optionen: `--reps N`, `--camera front|front34|front34_close|side34|side_low|back34`,
`--samples N`, `--every N` (nur jedes n-te Frame, für schnelle Tests), `--no-overlay`.

Ausgabe: `out/<übung>_<qualität>.mp4` + Einzelbilder in `out/<übung>/frames`.

## Enthaltene Übungen

| Key | Übung | Zielmuskeln |
|---|---|---|
| squat | Barbell Squat (Rack) | Quads, Glutes, Adduktoren |
| pushup | Liegestütz | Brust, Trizeps, vordere Schulter |
| lunge | Ausfallschritt (abwechselnd) | Quads, Glutes |
| curl | Kurzhantel-Curl | Bizeps, Unterarme |
| press | Kurzhantel-Schulterdrücken | Schultern, Trizeps |
| rdl | Rumänisches Kreuzheben | Hamstrings, Glutes, unterer Rücken |
| jack | Hampelmann | Waden, Schultern, Glutes |
| bridge | Glute Bridge | Glutes, Hamstrings |
| pullup | Klimmzug | Latissimus, Bizeps, Trapez |
| lateral | Seitheben | seitliche Schulter |
| crunch | Crunch | Bauch |
| bench | Bankdrücken | Brust, Trizeps, vordere Schulter |
| **Mobility** | | |
| catcow | Katze-Kuh | Wirbelsäule, unterer Rücken |
| child | Kindhaltung (Wippen) | Latissimus, unterer Rücken, Hüfte |
| downdog | Herabschauender Hund (Pedalieren) | Hamstrings, Waden |
| cobra | Kobra | Bauch, Hüftbeuger |
| hipflexor | Hüftbeuger-Dehnung kniend | Hüftbeuger, Quads, seitl. Bauch |
| squatrot | Tiefe Hocke mit BWS-Rotation | Hüfte, Adduktoren, oberer Rücken |
| toetouch | Vorbeuge stehend | Hamstrings, unterer Rücken |
| sidebend | Seitneigung stehend | seitl. Bauch, Latissimus |
| twist | Rumpfrotation stehend | seitl. Bauch |
| armcircles | Armkreisen | Schultern |
| hipcircles | Hüftkreisen | Hüfte, Glutes |
| legswings | Beinpendel | Hüftbeuger, Hamstrings |
| neckrolls | Nackenkreisen | Nacken, Trapez |

## Feinabstimmung (Figur, Posen, Material)

Körperprofil: `profiles/athlete.json` (Standard) bzw. `profiles/lean.json`.
Darin: MakeHuman-Targets (Muskelmasse, Proportionen, Hals, V-Form …), `head_scale`,
`neck_shorten`, `sculpt.strength`, `sculpt.grooves` (Tiefe der Muskel-Trennlinien),
`sculpt.groups` (chest, abs, obliques, back, glutes, shoulders, arms, forearms, legs, calves,
joints, traps) und `material` (roughness, coat, sheen, base).

```bash
python tools/tune.py body                                    # Kontaktbogen der Figur (6 Ansichten, ~45 s)
python tools/tune.py body --compare lean athlete             # Profile nebeneinander
python tools/tune.py body --set sculpt.groups.arms=1.8 --set material.roughness=0.6
python tools/tune.py pose curl --phases 0 0.25 0.45 --views front34 side hands_l   # Griff/Pose prüfen
python tools/tune.py ref squat --image vorlage.png --phase 0.45                    # neben Vorlage
python render.py squat --profile lean --set sculpt.grooves=2.0                     # Werte direkt beim Rendern
```
Ansichten für `pose`: front, front34, side, back, back34, top, hands, hands_l, hands_r, shoulders, feet, torso.

## Aufbau

```
fitanim/
  character.py   Figur: MakeHuman-Basismesh (CC0) + Körper-Targets, Ei-Kopf ohne Gesicht,
                 Rig + Skin-Weights, Muskelmasken als Mesh-Attribute (m_quads, m_glutes …)
  sculpt.py      prozedurale Anatomie: Sixpack, Brustlinie, Delta/Bizeps/Trizeps-Trennung,
                 Quad-Tropfen, Waden, Rücken
  poser.py       Pose-Solver: Hüfte/Wirbelsäule/Kopf + analytische 2-Bone-IK für Arme & Beine,
                 Griff-Ziele (palm), Hand-Ausrichtung, Fingergriff; backt alles als FK-Keyframes
  exercises.py   Übungsbibliothek (je Übung eine Klasse mit pose(phase) …)
  scene.py       Studio, Licht, Materialien (Porzellan + Muskel-Highlight), Rack, Hantel, Bank, Matte
  director.py    baut den Shot: Props, Kamerafahrt, Highlight-Timing, Neon-Pfeile, Rendern, GLB-Export
  post.py        Bloom, Vignette, Glas-Panel mit Muskelkarte, Handle, MP4-Encoding
assets/          MakeHuman-Daten (CC0, siehe LICENSE.ASSETS.md), Font Anton (OFL)
```

## Neue Übung hinzufügen

```python
class GobletSquat(Exercise):
    key = "goblet"; title = "GOBLET SQUAT"; subtitle = "Quads · Glutes"
    muscles = ["quads", "glutes"]
    props = [dict(type="mat")]
    camera = "front34"; rep_time = 3.0; reps = 2

    def pose(self, ph, rep, ctx):
        d = cycle(ph)                       # 0 oben → 1 unten → 0
        P = stand(0.2, 15)                  # Füße, Kopfhaltung
        P["hips"] = (0, 0.15 * d, -0.5 * d) # Hüfte nach hinten/unten (m)
        P["hips_rot"] = (30 * d, 0, 0)      # Oberkörper-Neigung (Grad)
        for s, sg in (("L", 1), ("R", -1)):
            P["hand" + s] = dict(pos=(sg * 0.06, -0.25, 1.30), space="chest", pole=(sg, 0.5, -1))
        P["grip"] = 1.0
        return P
# … und in LIBRARY eintragen.
```

Pose-Schlüssel: `hips`, `hips_rot`, `spine` (Beugen, Seitneigung, Rotation), `neck`, `head`,
`footL/R` (`pos`, `rot`, `pole`, `knee_out`), `handL/R` (`pos` oder `palm`, `space`
= world/chest/root, `pole`, `aim`=(Fingerrichtung, Handflächen-Normal), `twist`, `flex`,
`hang`, `shrug`), `grip` 0..1.
Koordinaten: Figur schaut nach −Y, x = linke Körperseite, z = oben, Meter.

## In andere Projekte einbauen

* **Videos**: MP4 direkt verwenden (Reels/TikTok/App-Onboarding).
* **3D in App/Web**: `--export-glb` erzeugt ein geskinntes GLB mit Animation. Muskelmasken
  sind als Vertex-Attribute `_M_QUADS`, `_M_GLUTES` … (0..1) und `COLOR_0.r` (Zielmuskeln
  der Übung) enthalten – im Shader einfach `mix(weiß, rot, maske * intensität)`.
  Läuft in three.js, Babylon, Unity, Unreal, Godot, SceneKit/RealityKit (über Konvertierung).
* **Blender**: `--save-blend` speichert die komplette Szene zum Nachbearbeiten.

## Lizenzen

Basismesh, Rig, Gewichte und Shape-Targets: MakeHuman/MPFB2-Assets, **CC0**.
Font Anton: SIL Open Font License. Code: frei verwendbar.
