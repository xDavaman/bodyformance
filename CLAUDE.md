# Bodyformance (BFC) – Hinweise für Claude

iOS-Fitness-App (SwiftUI). Besitzer: Sean-John Davis. Auf Deutsch sprechen, Oberflächentexte auf Deutsch.
Xcode-Projekt im Repo-Root: `FitScan.xcodeproj`, Quellen in `FitScan/` (Name stammt aus der Anfangszeit; die App heißt Bodyformance/BFC).

## Regeln
- Keine Gesundheitsdaten ins Internet. Premium ist aus (`PremiumConfig.enforceGating` in `FitScan/Services.swift`).
- Rechtstexte nur über `tools/gen_legal.py` ändern (erzeugt `LegalTexts.swift`).
- Keine Geheimnisse einchecken. GitHub-Token trägt Sean selbst ein.
- Die FormScan-Avatar-App ist gelöscht; die 3D-Figur steht neu zur Entscheidung.

Offene Funktionen: `docs/ROADMAP.md`. Monetarisierung: `docs/MONETARISIERUNG.md`.
