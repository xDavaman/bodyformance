# Simulator-Rundgang

`BFCUITests/RundgangTests.swift` startet die App im iPhone-Simulator, geht alle Hauptbereiche durch
(Profil, Trainingsplan, Fitnessstudio, 3D-Bewegungen, KI-Coach, Rezepte mit Kochmodus, Mobility,
Einstellungen mit eigener 3D-Figur) und speichert nach jedem Schritt ein Bildschirmfoto.
Stürzt die App ab, schlägt der Test fehl.

Läuft über `.github/workflows/ios-simulator-test.yml` (nach App-Änderungen auf `main`,
oder von Hand unter Actions → iOS-Simulator-Test → Run workflow). Ergebnis: Artefakt `simulator-rundgang`
mit Bildschirmfotos, Video, App-Protokoll und ggf. Absturzberichten.

Lokal auf einem Mac: `brew install xcodegen`, App einmal im Simulator starten, dann
`cd uitests && xcodegen && xcodebuild test -project BFCUITests.xcodeproj -scheme BFCUITests -destination 'platform=iOS Simulator,name=iPhone 17'`.
