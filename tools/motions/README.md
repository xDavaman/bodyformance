# Bewegungen für die 3D-Figur

Werkzeug, mit dem die Übungsanimationen der App entstehen. Jede Übung ist eine Folge von Schlüsselhaltungen
(Hand- und Fußziele, Rumpf-, Hals- und Beckenwinkel). Daraus werden die Gelenkdrehungen des Skeletts aus
`FitScan/FitScan_Skin.usdz` berechnet, weich überblendet, auf den Boden gestellt und in
`FitScan/FitScan_Motions.bin` geschrieben. Die App spielt sie mit RealityKit ab.

Der Ansatz stammt aus dem FitScan-Projekt (Haltungen über Richtungen und Ziele, monotone kubische
Interpolation, Bodenkontakt), übertragen auf das Skelett der App.

## Einrichten

```bash
python3 -m pip install usd-core numpy pillow
```

## Benutzen (im Ordner `tools`)

```bash
python3 -m motions vorschau pigeon frog      # Bildreihen nach tools/motions/vorschau/ zum Prüfen
python3 -m motions backen                    # alle Bewegungen in die App schreiben
python3 -m motions backen pigeon frog        # nur diese
```

`backen` lässt alle vorhandenen Bewegungen in der .bin-Datei unverändert, ersetzt gleichnamige und hängt neue an.
`FitScan/BodyMotions.swift` wird dabei neu erzeugt (bestehende Einträge bleiben). Danach in
`BodyRig.swift` unter `variants` eintragen, welche Übungsvariante die neue Bewegung bekommt.
`python3 -m pytest tests` prüft, dass alles zusammenpasst.

## Aufbau

| Datei | Aufgabe |
|---|---|
| `rig.py` | Skelett und Haut laden, Vorwärtskinematik, Skinning, Zwei-Glied-IK |
| `pose.py` | Haltung (Kanäle wie `handL`, `kneeR`, `spine`, `turn`) → Gelenkdrehungen |
| `clip.py` | Schlüsselhaltungen überblenden, Becken an Hand-/Fußziele anpassen, Bodenkontakt, Spiegeln links ↔ rechts |
| `preview.py` | einfacher Software-Renderer für Vorschaubilder |
| `library.py` | Grundhaltungen und Hilfen (`stand`, `sides`, `mirror`), Yoga |
| `lib_oben.py`, `lib_boden.py`, `lib_beine.py`, `lib_rolle.py`, `lib_aktiv.py` | Nacken/Schulter/Brust, Boden-Dehnungen, Waden/Sprunggelenk/Handgelenk, Faszienrolle, Aktivierung/Reha/Pilates |
| `bake.py` | Befehle `vorschau` und `backen` |

Koordinaten: Meter, Y oben, die Figur schaut nach +Z, linke Seite +X. Einseitige Übungen beschreiben nur
die linke Seite (`mirror_half=True`); die rechte entsteht gespiegelt.
