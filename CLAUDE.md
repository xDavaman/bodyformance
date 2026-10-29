# Bodyformance (BFC) – Hinweise für Claude

iOS-Fitness-App (SwiftUI). Besitzer: Sean-John Davis. Auf Deutsch sprechen, Oberflächentexte auf Deutsch.
Xcode-Projekt im Repo-Root: `FitScan.xcodeproj`, Quellen in `FitScan/` (Name stammt aus der Anfangszeit; die App heißt Bodyformance/BFC).

## Regeln
- Keine Gesundheitsdaten ins Internet. Premium ist aus (`PremiumConfig.enforceGating` in `FitScan/Services.swift`).
- Rechtstexte nur über `tools/gen_legal.py` ändern (erzeugt `LegalTexts.swift`).
- Keine Geheimnisse einchecken. GitHub-Token trägt Sean selbst ein.
- Die FormScan-Avatar-App ist gelöscht; die 3D-Figur steht neu zur Entscheidung.

## Übungsvideos
- 212 gerenderte Clips (eine pro Übungsfamilie) liegen in `FitScan/ExerciseVideos/bf_XXX_<motion>.mp4` (720×1280, H.264).
- `ExerciseGenerator` setzt `Exercise.videoName`; `ExerciseDetailView` zeigt das Video (`ExerciseVideoView.swift`),
  ohne Video fällt sie auf die 3D-Figur (`MuscleModelView`) zurück.
- Erzeugt werden die Clips mit der Blender-Pipeline in `tools/videopipeline` (läuft auf Seans Windows-PC, siehe dortige README/STATUS).

Offene Funktionen: `docs/ROADMAP.md`. Monetarisierung: `docs/MONETARISIERUNG.md`.
