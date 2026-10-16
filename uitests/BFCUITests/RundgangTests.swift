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
        if tap(app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'KI-Coach'")).firstMatch, "KI-Coach öffnen") {
            wait(1.5)
            shot("KI-Coach")
            if tap(app.buttons.matching(NSPredicate(format: "label CONTAINS 'Muskelaufbau'")).firstMatch, "Ziel Muskelaufbau wählen") {
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
        if tap(app.buttons["Fitnessstudio erkunden"].firstMatch, "Fitnessstudio öffnen") {
            wait(5)
            shot("Fitnessstudio")
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
        if tap(app.buttons.matching(NSPredicate(format: "label CONTAINS 'kcal ·'")).firstMatch, "erstes Rezept öffnen") {
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
        guard scrollTo(library), tap(library, "Übungsbibliothek öffnen") else { return }
        let search = app.searchFields.firstMatch
        if !search.waitForExistence(timeout: 2) { app.swipeDown() }
        if tap(search, "Suche") {
            search.typeText(name)
        }
        let row = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", name)).firstMatch
        if tap(row, "Übung \(name) öffnen") {
            wait(3)
            shot("\(name) 3D")
            wait(1.2)
            shot("\(name) 3D Bewegung")
            let gym = app.buttons.matching(NSPredicate(format: "label ENDSWITH 'zeigen'")).firstMatch
            if scrollTo(gym, swipes: 4), tap(gym, "Station im Fitnessstudio") {
                wait(4)
                shot("\(name) im Fitnessstudio")
                back()
            }
            back()
        }
        // Suche beenden, dann zurück zum Trainingsplan
        for label in ["Abbrechen", "Cancel"] where app.buttons[label].exists {
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

    private func scrollTo(_ element: XCUIElement, swipes: Int = 8) -> Bool {
        if element.exists && element.isHittable { return true }
        for _ in 0..<swipes {
            app.swipeUp()
            if element.exists && element.isHittable { return true }
        }
        return element.exists
    }

    private func back() {
        let button = app.navigationBars.buttons.element(boundBy: 0)
        if button.exists && button.isHittable {
            button.tap()
            wait(0.8)
        }
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
