# fitanim – Stand 28.10.2026 (Übergabe)

## Läuft gerade
- Render-Auftrag `005_bodyformance_v3` (alle 212 Familien, final 720x1280, neuer Code, RENDER_VERSION 2)
- Start 01:38 Uhr, ca. 6 min pro Clip -> voraussichtlich fertig ca. 23 Uhr (28.10.)
- Ausgabe: `03_Videos\Bodyformance\bf_XXX_*.mp4` (+ `.fp.npz` Fingerabdruck)
- Stichprobe geprüft (Bankdrücken, Liegestütz, Klimmzug, Australian Pull-up, Kreuzheben, Schulterdrücken): sauber

## Neu in diesem Stand
- `fitanim/anat.py`: Gelenkwinkel gegen klinische Normen (AAOS / Norkin & White)
- Gelenk-Begrenzer im Solver (`poser.py`): Knie, Ellbogen, Unterarm, Handgelenk können nicht mehr "auskugeln"
- `tools/motion_lint.py`: Prüfcode ROM (Gelenk außerhalb der Norm)
- `tools/ref_check.py` + `data/exercise_refs.json`: Soll/Ist-Vergleich mit Technik-Referenzen, Gelenkkurven (`--curves motion:geraet`)
- Viele Übungen nach Technik neu gebaut (Kickback, Schulterdrücken, Liegestütz, Plank, Seitstütz, Boot, Teaser, Herabschauender Hund,
  Kreuzheben, KH-Bankdrücken, Skull Crusher, Inverted Row, Latziehen, Dead Hang, Beinpresse, Beinstrecker, L-Sit, Bird Dog, Superman, ...)

## Erledigt am 29.10.
- Render 005 komplett: 212/212 Clips, 0 Fehler (fertig 01:03)
- Kamel: Hände starten am Kreuzbein und erreichen jetzt die Fersen (Rücklage passt sich an), Ellbogen zeigen nach hinten
- Single Leg Stretch: Hände halten das gebeugte Bein (außen Knöchel, innen Knie)
- Auftrag 006 rendert nur diese 2 Clips neu (bf_186, bf_189)

## Offen (optional)
- Stichprobe 24 Clips quer durch alle Kategorien gesichtet: sauber.
- Kleine Restbefunde ohne sichtbaren Fehler: Drehsitz und Baum (starke Hüft-Außenrotation, bei diesen Posen normal),
  Single Leg Stretch (Oberarm-Rotation kurz beim Beinwechsel).
- Weitere Korrekturen: nur betroffene Familien rendern (Job mit "families": [..], "force": true).
