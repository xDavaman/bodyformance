import XCTest

/// Rundgang durch die App im Simulator: tippt sich durch alle Hauptbereiche und macht nach jedem Schritt ein Bildschirmfoto.
/// Die App wird über ihre Bundle-ID gesteuert (sie muss vorher im Simulator installiert sein).
final class RundgangTests: XCTestCase {
    private let app = XCUIApplication(bundleIdentifier: "test.FitScan")
    private let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    private var shotNumber = 0
    private var crashes: [String] = []

    override func setUp() {
        continueAfterFailure = true
        app.launchArguments = ["-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
    }

    func testRundgang() {
        app.launch()
        wait(2)
        shot("Willkommen")
        tap(app.buttons["Ohne Apple Health fortfahren"], "Datenschutz-Dialog bestätigen")
        wait(2)
        allowSystemAlerts()
        check("Start")

        // Profil
        openTab(0, "Profil")
        shot("Profil")
        app.swipeUp()
        shot("Profil unten")

        // Trainingsplan mit KI-Coach und Fitnessstudio
        openTab(1, "Trainingsplan")
        shot("Trainingsplan")
        if tap(visible(app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'KI-Coach'"))), "KI-Coach öffnen") {
            wait(1.5)
            shot("KI-Coach")
            if tap(visible(app.buttons.matching(NSPredicate(format: "label CONTAINS 'Muskelaufbau'"))), "Ziel Muskelaufbau wählen") {
                wait(1)
                shot("KI-Coach Ziel wählen")
                let take = app.buttons["Übernehmen"].firstMatch
                if tap(take, "Ziel übernehmen") {
                    wait(1.5)
                    shot("KI-Coach Plan")
                    app.swipeUp()
                    shot("KI-Coach Plan unten")
                }
            }
            back()
        }
        if tap(visible(app.buttons.matching(NSPredicate(format: "label == 'Fitnessstudio erkunden'"))), "Fitnessstudio öffnen") {
            wait(5)
            shot("Fitnessstudio")
            // Einmal im Kreis umschauen (je Wischer gut eine Vierteldrehung)
            for name in ["Blick 2", "Blick 3", "Blick 4"] {
                let from = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.85, dy: 0.42))
                let to = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.20, dy: 0.42))
                from.press(forDuration: 0.1, thenDragTo: to)
                wait(1.5)
                shot("Fitnessstudio \(name)")
            }
            // Station über die Leiste wählen: Liste schließen, dann muss der Kabelturm ganz zu sehen sein
            if tap(visible(app.buttons.matching(NSPredicate(format: "label CONTAINS 'Kabelturm'"))), "Station Kabelturm") {
                wait(1.5)
                _ = tap(visible(app.buttons.matching(NSPredicate(format: "label == 'Fertig'"))), "Liste schließen")
                wait(2)
                shot("Fitnessstudio Kabelturm")
            }
            app.swipeUp()
            wait(1)
            shot("Fitnessstudio Stationen")
            back()
        }

        // 3D-Bewegungen in zwei Übungen
        for name in ["Bankdrücken", "Kniebeuge"] {
            exercise(name)
        }

        // Rezepte und Kochmodus
        openTab(2, "Rezepte")
        wait(1)
        shot("Rezepte")
        if push(visible(app.buttons.matching(NSPredicate(format: "label CONTAINS 'kcal ·'"))), "erstes Rezept öffnen") {
            wait(1.5)
            shot("Rezept")
            let cook = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Kochen starten'")).firstMatch
            if scrollTo(cook), tap(cook, "Kochmodus starten") {
                wait(1.5)
                shot("Kochmodus")
                if tap(app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Los geht'")).firstMatch, "Kochmodus Los geht's") {
                    wait(1)
                    shot("Kochmodus Schritt 1")
                    tap(app.buttons["Weiter"].firstMatch, "Kochmodus Weiter")
                    wait(1)
                    shot("Kochmodus Schritt 2")
                }
                tap(app.buttons["Schließen"].firstMatch, "Kochmodus schließen")
            }
            back()
        }

        // Mobility
        openTab(3, "Mobility")
        wait(1)
        shot("Mobility")

        // Einstellungen und eigene 3D-Figur
        openTab(4, "Einstellungen")
        wait(1)
        shot("Einstellungen")
        let figure = app.buttons.matching(NSPredicate(format: "label CONTAINS '3D-Figur an deinen Körper anpassen'")).firstMatch
        if scrollTo(figure), tap(figure, "Eigene 3D-Figur öffnen") {
            wait(5)
            shot("Eigene Figur vorne")
            if tap(app.buttons["Hinten"].firstMatch, "Figur von hinten") {
                wait(2)
                shot("Eigene Figur hinten")
            }
            app.swipeUp()
            shot("Eigene Figur Regler")
            back()
        }

        openTab(0, "Profil")
        wait(1)
        check("Ende")
        XCTAssert(crashes.isEmpty, "Abstürze: " + crashes.joined(separator: ", "))
    }

    // MARK: Schritte

    private func exercise(_ name: String) {
        openTab(1, "Trainingsplan")
        let library = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Alle Übungen'")).firstMatch
        guard scrollTo(library), tap(library, "Übungsbibliothek öffnen") else {
            note("Übungsbibliothek nicht erreicht (für \(name))")
            shot("Übungsbibliothek fehlt")
            return
        }
        let search = app.searchFields.firstMatch
        if !search.waitForExistence(timeout: 2) { app.swipeDown() }
        if tap(search, "Suche") {
            search.typeText(name)
        }
        let row = visible(app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", name)))
        if push(row, "Übung \(name) öffnen") {
            wait(3)
            shot("\(name) 3D")
            wait(1.2)
            shot("\(name) 3D Bewegung")
            let gym = app.buttons.matching(NSPredicate(format: "label ENDSWITH 'zeigen'")).firstMatch
            if scrollTo(gym, swipes: 4), tap(gym, "Station im Fitnessstudio") {
                wait(4)
                shot("\(name) im Fitnessstudio")
                // Die Station öffnet ein Blatt über dem Studio, das erst geschlossen werden muss
                let done = app.buttons["Fertig"].firstMatch
                if done.exists && done.isHittable { done.tap(); wait(0.8) }
                back()
            }
            back()
        }
        // Suche beenden, dann zurück zum Trainingsplan
        for label in ["close", "Abbrechen", "Cancel"] where app.buttons[label].exists && app.buttons[label].isHittable {
            app.buttons[label].tap()
            break
        }
        back()
    }

    // MARK: Hilfen

    private func openTab(_ index: Int, _ title: String) {
        let byId = app.buttons["tab.\(index)"]
        tap(byId.exists ? byId : app.buttons.matching(NSPredicate(format: "label == %@", title)).lastMatch, "Bereich \(title)")
        wait(1)
        check(title)
    }

    @discardableResult
    private func tap(_ element: XCUIElement, _ what: String, timeout: TimeInterval = 4) -> Bool {
        // Listen laden Zeilen erst beim Scrollen; was nicht sichtbar ist, erst suchen
        if !element.waitForExistence(timeout: timeout) { _ = scrollTo(element) }
        guard element.exists else {
            note("nicht gefunden: \(what)")
            return false
        }
        if !element.isHittable { _ = scrollTo(element) }
        element.tap()
        allowSystemAlerts()
        check(what)
        return app.state == .runningForeground
    }

    /// Tippt eine Listenzeile und prüft, ob sich die nächste Seite öffnet; sonst zweiter Versuch und Aufzeichnung der Oberfläche
    private func push(_ element: XCUIElement, _ what: String) -> Bool {
        let backButton = app.navigationBars.buttons["BackButton"]
        let before = backButton.exists && backButton.isHittable ? backButton.label : nil
        // Zeilen ganz unten liegen halb unter Suchfeld und Tab-Leiste: erst ein Stück nach oben schieben
        if element.exists && element.frame.maxY > app.frame.height * 0.7 {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
                .press(forDuration: 0.05, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3)))
            wait(0.8)
        }
        guard tap(element, what) else { return false }
        if opened(backButton, after: before) { return true }
        note("öffnet nicht beim ersten Tippen: \(what) (\(element.label))")
        dump("vor zweitem Versuch \(what)")
        if element.exists {
            element.coordinate(withNormalizedOffset: CGVector(dx: 0.4, dy: 0.5)).tap()
            if opened(backButton, after: before) { return true }
        }
        note("öffnet nicht: \(what)")
        dump("nach zweitem Versuch \(what)")
        return false
    }

    private func opened(_ backButton: XCUIElement, after before: String?) -> Bool {
        for _ in 0..<10 {
            if backButton.exists && backButton.isHittable && backButton.label != before { return true }
            wait(0.3)
        }
        return false
    }

    /// Schreibt den Aufbau der Oberfläche als Text neben die Bilder (zur Fehlersuche)
    private func dump(_ name: String) {
        guard let dir = ProcessInfo.processInfo.environment["BFC_SHOTS"] else { return }
        let url = URL(fileURLWithPath: dir).appendingPathComponent("Aufbau \(name).txt")
        try? app.debugDescription.write(to: url, atomically: true, encoding: .utf8)
    }

    private func scrollTo(_ element: XCUIElement, swipes: Int = 8) -> Bool {
        if element.exists && element.isHittable { return true }
        for _ in 0..<swipes {
            app.swipeUp()
            if element.exists && element.isHittable { return true }
        }
        return element.exists
    }

    /// Zurück nur über den echten Zurück-Knopf (sonst würde z. B. „Eigenes Rezept“ links oben getippt)
    private func back() {
        let button = app.navigationBars.buttons["BackButton"]
        if button.exists && button.isHittable {
            button.tap()
        } else {
            // Wischen vom linken Rand, wie mit dem Daumen
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
            start.press(forDuration: 0.05, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5)))
        }
        wait(0.8)
    }

    /// Erstes sichtbares Element: ausgeblendete Bereiche und frühere Seiten im Stapel enthalten oft gleich benannte Knöpfe
    private func visible(_ query: XCUIElementQuery) -> XCUIElement {
        _ = query.firstMatch.waitForExistence(timeout: 4)
        for i in 0..<min(query.count, 40) {
            let e = query.element(boundBy: i)
            if e.isHittable { return e }
        }
        return query.firstMatch
    }

    /// Prüft, ob die App noch läuft; nach einem Absturz wird sie neu gestartet, damit der Rundgang weitergeht.
    private func check(_ step: String) {
        if app.state != .runningForeground {
            crashes.append(step)
            XCTFail("App läuft nicht mehr nach: \(step) (Zustand \(app.state.rawValue))")
            shot("ABSTURZ nach \(step)")
            app.launch()
            wait(2)
        }
    }

    private func allowSystemAlerts() {
        let alert = springboard.alerts.firstMatch
        guard alert.waitForExistence(timeout: 0.5) else { return }
        for label in ["Beim Verwenden der App erlauben", "Erlauben", "Allow While Using App", "Allow", "OK"] {
            let b = alert.buttons[label]
            if b.exists { b.tap(); return }
        }
    }

    private func shot(_ name: String) {
        shotNumber += 1
        let file = String(format: "%02d %@", shotNumber, name)
        let image = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: image)
        attachment.name = file
        attachment.lifetime = .keepAlways
        add(attachment)
        if let dir = ProcessInfo.processInfo.environment["BFC_SHOTS"] {
            let url = URL(fileURLWithPath: dir).appendingPathComponent(file + ".png")
            try? image.pngRepresentation.write(to: url)
        }
    }

    private func note(_ text: String) {
        print("RUNDGANG: \(text)")
        XCTContext.runActivity(named: text) { _ in }
    }

    private func wait(_ seconds: TimeInterval) {
        Thread.sleep(forTimeInterval: seconds)
    }
}

private extension XCUIElementQuery {
    var lastMatch: XCUIElement { element(boundBy: max(0, count - 1)) }
}
