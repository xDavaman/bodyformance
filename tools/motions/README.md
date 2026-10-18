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
python3 -m motions pruefen                   # alle gebackenen Bewegungen auf Fehler prüfen
python3 -m motions pruefen row plank --bilder --ziel /tmp/befund   # mit Bildreihen
```

`pruefen` liest `FitScan_Motions.bin` und baut die Szene wie die App auf (Bank, Klimmzugstange, Wand, Hanteln
aus `tools/geraete`). Es meldet: Körper im Boden (`boden`), Füße schweben (`fuesse`), Füße rutschen am Boden
(`rutschen`), Rücken liegt nicht auf der Bank (`bank`), Hantel nicht in der Hand (`hantel`), Körperteile
ineinander (`durch`, oft gewollte Berührung) und falsch herum gebeugte Gelenke (`gelenk`). Ergebnis in `befund.json`.

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
| `lib_kraft.py` | Krafttraining mit Bank, Klimmzugstange, Kurz-/Langhantel, Matte, Ausfallschritte |
| `szene.py` | gebackene Bewegungen lesen, Gegenstände der App-Szene als Netze |
| `ansicht.py` | Renderer mit Tiefenpuffer (Durchdringungen sichtbar) |
| `pruefen.py` | Fehlerprüfung und Bildreihen |
| `bake.py` | Befehle `vorschau`, `backen` und `pruefen` |

Koordinaten: Meter, Y oben, die Figur schaut nach +Z, linke Seite +X. Einseitige Übungen beschreiben nur
die linke Seite (`mirror_half=True`); die rechte entsteht gespiegelt.

Hilfen für Gegenstände und Kontakte (`clip.py`):

- `Prop("dumbbell", hand="L")` setzt die Hantel an die Hand (`"LR"` für eine Hantel in beiden Händen,
  Langhantel mit `Prop("barbell", hand="LR")` liegt zwischen beiden Griffen).
- Kanal `twistL`/`twistR` dreht die Hand um den Unterarm; `align_grip` sucht Drehung und Handgelenk so, dass
  die Hantelachse in eine gewünschte Richtung zeigt.
- `Clip(rest=(oberkante, halbe_breite, z0, z1))` legt den Rücken auf eine Fläche (Bank), `ground=False` für
  Hängen und Bank, `step_lift` hebt Füße bei Schritten an, statt sie über den Boden zu ziehen.
