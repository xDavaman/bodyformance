# Geräte für das Fitnessstudio

Werkzeug, mit dem die 3D-Geräte im Studio der App entstehen (Bänke, Racks, Kabelzug, Beinpresse,
Brustpresse, Laufband, Hanteln …). Die Modelle werden aus echten Bauteilen zusammengesetzt: Vierkantrohre
mit Lochreihen und Schweißnähten, gebogene Rohre, gepolsterte Kissen mit Nähten, Hantelscheiben mit Profil,
Kettlebells, Rollen und Seile. Abmessungen orientieren sich an üblichen Studiogeräten.

Jedes Gerät landet als `FitScan/Gym_<Name>.usdz` in der App. `FitScan/GymModels.swift` lädt es einmal und
gibt für jede Verwendung eine Kopie aus; platziert werden die Geräte in `GymScene.swift` und `GymExplore.swift`.

## Einrichten

```bash
python3 -m pip install usd-core numpy
```

## Benutzen (im Ordner `tools`)

```bash
python3 -m geraete backen                 # alle Geräte neu in die App schreiben
python3 -m geraete backen Bank PowerRack  # nur diese
python3 -m geraete vorschau /tmp/glb      # .glb-Dateien zum Ansehen im Browser (z. B. three.js)
```

`python3 -m pytest tests` prüft, dass jedes Gerät, das die App lädt, auch als Datei vorhanden ist.

## Aufbau

- `mesh.py` – Grundformen (Drehkörper, Rohre entlang Pfaden, abgerundete Quader, Kissen), Netz-Sammlung
- `teile.py` – Bauteile (Pfosten mit Lochreihen, Scheiben, Hanteln, Polster, Rollen …)
- `modelle.py` – die Geräte; `MODELLE` ordnet jedem Dateinamen eine Bau-Funktion zu
- `materialien.py` – Farben und Oberflächen (pulverbeschichteter Stahl, Chrom, Gummi, Polster …)
- `export.py` – Ausgabe als `.usdz` (App) und `.glb` (Vorschau)

Koordinaten: Meter, y nach oben, Boden bei y = 0. Die Lage jedes Geräts steht in seiner Bau-Funktion.
