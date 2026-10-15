# Bodyformance (BFC)

iOS-Fitness-App (SwiftUI, RealityKit): 3D-animierte Übungen, Trainingsplan, Ernährung mit Barcode-Scan, Körperscan mit Intervall, Schritt- und Workout-Tracking, Rezept-Community.

## Schnellstart (ca. 10 Minuten)

Voraussetzung: Mac mit aktuellem Xcode, iOS 17+ als Ziel.

1. Repository klonen und `FitScan.xcodeproj` in Xcode öffnen.
2. Projekt anklicken → Target **FitScan** → *Signing & Capabilities*:
   - **Team**: eigene Apple-ID wählen (kostenlos genügt zum Testen).
   - **Bundle Identifier** auf etwas Eindeutiges ändern, z. B. `de.<dein-kürzel>.fitscan`. Diese Änderung **nicht committen** (`git update-index --assume-unchanged FitScan.xcodeproj/project.pbxproj` oder die Datei vor dem Commit zurücksetzen).
   - Capability **HealthKit** ist nötig, wenn Apple-Health-Daten gelesen werden sollen.
3. Ziel wählen und **Run**:
   - *iPhone-Simulator* oder *My Mac (Designed for iPad)*: Ernährung, Training, 3D-Ansicht, Profil laufen.
   - *Echtes iPhone*: nötig für Kamera, Barcode-Scan, Schrittzähler, LiDAR-Körperscan. Beim ersten Mal: Einstellungen → Datenschutz & Sicherheit → Entwicklermodus, dann Entwickler-App vertrauen.

Neue `.swift`-Dateien im Ordner `FitScan/FitScan/` werden automatisch ins Projekt übernommen (Xcode synchronisiert den Ordner).

## Aufbau

| Bereich | Dateien |
|---|---|
| App/Navigation | `FitScanApp.swift` (alle Stores als `@EnvironmentObject`), `ContentView.swift` (eigene untere Tab-Leiste, Dashboard), `EssenHub.swift` (`AppNav`, Essen-Unterleiste) |
| Training | `TrainingView`, `PlanBuilder`, `TrainingStore`, `Progression`, `Exercise*`, `WorkoutLogView` |
| 3D-Modell | `MuscleModelView`, `BodyRig`, `BodyMotions`, `GymScene`, `FitScan_Skin.usdz`, `FitScan_Motions.bin` |
| Ernährung | `NutritionView`, `NutritionEngine`, `RecipeStore`, `FoodDB`, `FoodScan`, `FoodData` (generiert, siehe unten) |
| Community | `Community.swift` (Firebase per REST, kein SDK) |
| Profil / Scan | `ProfileView`, `UserProfile`, `ScanView`, `BodyScanView`, `ScanSchedule` (Intervall + Verlauf), `ProfileAvatar` |
| Aktivität | `Activity`, `HealthManager`, `SportView`, `MobilityView` |

Daten werden lokal gespeichert (UserDefaults als JSON, `@AppStorage`, Profilbild als Datei in Documents).

## Generierte Dateien – nicht von Hand ändern

`FoodData.swift` entsteht aus `tools/food/` (`gen.py` → `more.py` → `emit.py`). Änderungen an Zutaten oder Rezepten dort machen und neu erzeugen. Brand-Produkte der Lebensmitteldatenbank kommen aus `tools/food/fooddb.py`. Die Skripte brauchen nur Python 3.

## Community (Firebase) einrichten

Die Rezept-Community läuft über ein eigenes Firebase-Projekt, das **nicht im Repository** liegt. In der App: Essen → Alle Rezepte → Community → *Community einrichten* (6 Schritte mit den Sicherheitsregeln). Projekt-ID und Web-API-Key werden in der App eingetragen, nie im Code. Jeder Entwickler kann dafür ein eigenes Test-Projekt anlegen.

## Spielregeln im Team

- Kein Commit direkt auf `main`: pro Aufgabe ein Branch (`feature/…`, `fix/…`), dann Pull Request und kurzes Review durch den anderen.
- Kleine Commits, verständliche Nachrichten (deutsch oder englisch, aber einheitlich).
- Vor dem Push: Projekt baut fehlerfrei, App startet.
- Keine Schlüssel, Zertifikate oder `GoogleService-Info.plist` einchecken (`.gitignore` schützt davor).
- Große Binärdateien (`.usdz`, `.bin`) nur ändern, wenn nötig, und vorher absprechen, weil Git sie nicht zusammenführen kann.
- Bei gleichzeitiger Arbeit an derselben Datei: vorher kurz absprechen, `git pull --rebase` vor dem Push.

## Bekannte offene Punkte

- Test auf echtem iPhone (Kamera, Barcode, Schrittzähler, Erinnerungen).
- Community noch nicht gegen ein echtes Firebase-Projekt getestet; für den öffentlichen Start fehlen Moderation und Nutzer-Sperren (Apple-Vorgabe für nutzergenerierte Inhalte).
- 4-Positionen-LiDAR-Scan für automatische Körperfett-Berechnung.
- Neue Kabelübungen, überarbeitete Muskelfarben, eigene Übungen.
