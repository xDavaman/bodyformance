# Boxhalle für die App (`FitScan/Gym_Halle.usdz`)

Die Studio-Ansichten (`GymRoom` in `GymScene.swift`) stehen in der „BFC Boxing Club“-Halle aus Blender
(heruntergekommene amerikanische Boxhalle, 24 × 15 m, moderne Geräte). Fehlt die Datei, baut die App den alten
Raum prozedural (`buildInterior`/`buildDecorations` in `GymLook.swift`).

## Neu erzeugen

1. Halle in Blender bauen (Seans PC, `Claude-Work\Boxing-Gym`): `boxing_gym.py … final` → `fertig\boxing_gym.blend`
2. Rohdaten exportieren:
   `blender -b fertig\boxing_gym.blend --python export_app_halle.py -- C:\Users\sean\Claude-Work\Boxing-Gym`
   → `zwischen\app_export\halle.npz` + `materials.json`
   - Ursprung = Gerätezone (Blender −5,0 / 0,6); alles Bodenstehende im Quadrat ±4,45 m wird entfernt,
     dort stehen Figur, Kabelturm und die App-Geräte.
   - Bibliotheksgeräte werden auf ≤ 300 Dreiecke je Teil reduziert (gesamt ≈ 260 000 Dreiecke).
3. USDZ bauen (braucht `usd-core`, `pillow`, `numpy`):
   `python3 tools/halle/build_usdz.py <app_export> <tex>` → `FitScan/Gym_Halle.usdz` (≈ 12 MB)
   - Blender Z-oben → RealityKit Y-oben, Figur schaut nach +Z (Fensterfront), Rückwand mit Plakaten bei −Z.
   - Poly-Haven-Texturen (CC0) bekommen Würfel-UVs, Farbtöne werden eingebacken (Diffus 1024 px, Normal/Rauheit 512 px).
