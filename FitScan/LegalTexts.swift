import Foundation

/// Ausführliche rechtliche Texte (erzeugt aus gen_legal.py – Änderungen dort machen).
enum LegalTexts {
    static let privacy: [(title: String, body: String)] = [
        ("Geltungsbereich", """
Diese Datenschutzerklärung gilt für die iPhone-App „Bodyformance“ (kurz BFC) und die Zusatz-App „BFC Scanner“. Sie erklärt, welche Daten die Apps verarbeiten, wozu, auf welcher Rechtsgrundlage, wie lange und welche Rechte du hast. Die Apps sind kein Online-Dienst mit Benutzerkonto: BFC läuft auf deinem Gerät und kennt dich nur über das, was du selbst eingibst oder freigibst.
Stand: Oktober 2026.
"""),
        ("1. Verantwortlicher", """
Verantwortlich für die Datenverarbeitung im Sinne der DSGVO ist:
\(LegalInfo.responsibleName)
\(LegalInfo.responsibleAddress)
E-Mail: \(LegalInfo.contactEmail)
Ein Datenschutzbeauftragter ist nicht bestellt, weil hierzu keine gesetzliche Pflicht besteht. Für alle Fragen zum Datenschutz erreichst du den Verantwortlichen unter der oben genannten E-Mail-Adresse.
"""),
        ("2. Grundprinzip: Deine Daten bleiben auf deinem Gerät", """
BFC speichert deine Daten ausschließlich lokal auf deinem iPhone (im geschützten App-Speicher). Es gibt keinen BFC-Server, kein Benutzerkonto und keine Registrierung. Gesundheitsdaten, Körpermaße, Trainings- und Ernährungsdaten, Scans, Fotos und deine GPS-Strecken werden von BFC nicht an den Entwickler übertragen. Der Entwickler hat auf diese Daten keinen Zugriff.
Ausnahmen, bei denen Daten dein Gerät verlassen, sind in den Abschnitten 7 (Lebensmittel-Datenbank), 12 (Teilen), 13 (Community, falls aktiviert) und 15 (anonyme Statistik, nur mit Einwilligung) beschrieben. Sie passieren nur durch eine Aktion von dir.
"""),
        ("3. Welche Daten verarbeitet werden", """
a) Profil- und Körperdaten: Alter, Größe, Gewicht, Taillen- und Halsumfang, Körperfett-Schätzung, Trainingstage, Ziel (Muskelaufbau, Erhalt, Diät), Tempo, Wunsch-Optik, Ausrüstung, Schwerpunkt-Muskeln. Du gibst sie selbst ein. Sie sind Gesundheitsdaten im Sinne von Art. 9 DSGVO.
b) Daten aus Apple Health (HealthKit), nur nach deiner Freigabe: Schritte, Distanz, aktive Energie, Gewicht, Körperfett, Ruhepuls, Herzfrequenz, Workouts und GPS-Strecken von Workouts, auch solche, die deine Apple Watch oder andere Geräte (z. B. Garmin über deren App) in Apple Health geschrieben haben. BFC liest diese Daten; es schreibt keine Daten zurück.
c) Live-Bewegungsdaten: Schritte, Strecke und Tempo vom Bewegungssensor deines iPhones (Core Motion).
d) Standort: Bei Training draußen (Laufen, Gehen, Draußen trainieren) zeichnet BFC deine GPS-Strecke auf, auch bei gesperrtem Bildschirm. Die Strecke wird nur lokal gespeichert.
e) Ernährung: Mahlzeiten, Kalorien, Nährwerte, Wasser, selbst angelegte Lebensmittel und Rezepte, gescannte Barcodes. Fotos zur Lebensmittelerkennung werden auf dem Gerät mit Apples Vision-Technik ausgewertet.
f) Körperscan: 3D-Scan über die LiDAR-Kamera (BFC und BFC Scanner) und Scan-Ergebnisse (Maße). Ein 3D-Körperscan kann sehr persönlich sein. Er wird nur lokal gespeichert und von dir selbst geteilt, wenn du ihn exportierst.
g) Profilname und Profilbild: freiwillig, nur lokal.
h) Fortschritt: Rang, Erfahrungspunkte (XP), Aktivitätstage, Trainingsverlauf.
i) Einstellungen und Einwilligungen: z. B. Zustimmung zur Verarbeitung von Apple-Health-Daten, Erinnerungen, Extrem-Modus-Bestätigung.
j) Technische Daten: BFC erhebt keine Nutzungsstatistiken, keine Absturzberichte und keine Werbe-ID. Apple kann nach deinen eigenen Geräteeinstellungen anonyme Absturz- und Nutzungsdaten an Entwickler weitergeben; darauf hat BFC keinen Einfluss.
"""),
        ("4. Zwecke und Rechtsgrundlagen", """
Gesundheitsdaten (3 a, b, c, d, f): Deine ausdrückliche Einwilligung, Art. 6 Abs. 1 lit. a und Art. 9 Abs. 2 lit. a DSGVO. Du erteilst sie beim ersten Start und kannst sie jederzeit unter Einstellungen → Datenschutz widerrufen.
Zweck: Berechnung deiner Kalorien- und Eiweißziele, Schrittziele und Trainingsvorschläge, Anzeige von Fortschritt und Verlauf, Rang-System, Diät-Coach, Teilen auf deinen Wunsch.
Übrige Daten (3 e, g, h, i): Durchführung der von dir genutzten App-Funktionen (Art. 6 Abs. 1 lit. b DSGVO, soweit man die Nutzung als Vertrag ansieht, andernfalls Art. 6 Abs. 1 lit. a und f DSGVO; das berechtigte Interesse ist die Bereitstellung der App).
Es findet kein Profiling im Sinne von Art. 22 DSGVO statt. Es gibt keine automatisierten Entscheidungen mit rechtlicher Wirkung. Die Berechnungen (z. B. Kalorienziel) sind einfache Formeln auf deinen eigenen Angaben; du entscheidest, was du damit tust.
"""),
        ("5. Speicherdauer und Löschung", """
Alle Daten bleiben auf deinem Gerät, bis du sie löschst. Du kannst jederzeit unter Einstellungen → Datenschutz → „Alle Daten in der App löschen“ alles entfernen oder einzelne Einträge (Training, Essen, Scans) in den jeweiligen Listen löschen. Beim Löschen der App werden die App-Daten ebenfalls entfernt. Daten in Apple Health löscht du in Apple Health selbst. Geteilte Bilder und Exporte, die du an andere gesendet hast, kann BFC nicht zurückholen.
Das Ernährungstagebuch behält die letzten 120 Tage.
"""),
        ("6. Apple Health, Apple Watch und andere Tracker", """
BFC fragt Zugriff auf Apple Health erst nach deiner Einwilligung an. Du entscheidest in Apple Health pro Datentyp, was BFC lesen darf, und kannst das jederzeit unter Einstellungen → Health → Datenzugriff & Geräte → BFC ändern. Daten aus Apple Health werden nicht für Werbung, Marketing oder Data-Mining verwendet, nicht an Dritte weitergegeben und nicht in iCloud gespeichert. Das entspricht den Regeln von Apple für Gesundheitsdaten.
Workouts und Strecken deiner Uhr (Apple Watch, Garmin und andere) übernimmt BFC aus Apple Health, sobald die Uhr sie dorthin geschrieben hat, also auch dann, wenn du dein Telefon beim Training nicht dabeihattest. BFC selbst kommuniziert nicht direkt mit Garmin- oder anderen Herstellerservern. Für die Datenverarbeitung bei diesen Herstellern gelten deren eigene Datenschutzhinweise.
"""),
        ("7. Lebensmittel-Datenbank (Open Food Facts)", """
Wenn du einen Barcode scannst oder in der Lebensmittelsuche nach einem Produkt suchst, sendet BFC den Barcode oder den Suchbegriff an die offene Datenbank Open Food Facts (world.openfoodfacts.org), um Nährwerte zu laden. Dabei erhält der Betreiber technisch zwangsläufig deine IP-Adresse. Es werden keine weiteren Angaben zu dir übertragen, keine Profil-, Gesundheits- oder Standortdaten.
Rechtsgrundlage ist Art. 6 Abs. 1 lit. a DSGVO (du löst die Abfrage selbst aus). Betreiber ist die gemeinnützige Open Food Facts Association (Frankreich, EU). Mehr dazu in deren Datenschutzhinweisen. Ohne diese Abfrage kannst du Lebensmittel auch von Hand eintragen.
"""),
        ("8. Kamera, LiDAR und Fotos", """
Die Kamera wird für den Körperscan (LiDAR), das Scannen von Barcodes und für Lebensmittel-Fotos genutzt. Die Auswertung erfolgt auf deinem Gerät. Es werden keine Bilder an BFC-Server gesendet, weil es keine gibt. Die Zugriffsberechtigung kannst du jederzeit in den iOS-Einstellungen ändern. Scans und Fotos sind sensibel. Gib Exporte nur an Personen oder Programme weiter, denen du vertraust.
"""),
        ("9. Standort und GPS-Strecke", """
BFC greift auf deinen Standort nur zu, wenn du ein Training startest, bei dem die Strecke aufgezeichnet wird (Laufen draußen, Gehen/Spazieren, Draußen trainieren), und nur solange das Training läuft. Bei gesperrtem Bildschirm läuft die Aufzeichnung weiter, iOS zeigt dafür einen Hinweis an. Die Strecke wird lokal im Trainingsverlauf gespeichert.
Wenn du eine Strecke als Bild teilst, erscheint sie als Linie. Mit der Option „Start und Ende kürzen“ werden die ersten und letzten 200 Meter weggelassen, damit nicht erkennbar ist, wo du wohnst. Du kannst den Standortzugriff jederzeit in den iOS-Einstellungen verbieten; dann gibt es keine Strecke, alles andere funktioniert.
"""),
        ("10. Berechtigungen im Überblick", """
Apple Health (lesen), Bewegung & Fitness (Schritte, Strecke), Kamera und LiDAR, Standort (nur während Training), Benachrichtigungen (lokale Erinnerungen, z. B. Scan-Termin). Jede Berechtigung ist freiwillig und kann in den iOS-Einstellungen widerrufen werden. Ohne eine Berechtigung entfällt nur die zugehörige Funktion.
"""),
        ("11. Empfänger und Auftragsverarbeiter", """
BFC gibt keine personenbezogenen Daten an Dritte weiter und verkauft keine Daten. Derzeit sind keine Werbe-, Tracking- oder Analyse-Dienste eingebunden; mögliche künftige Dienste (Firebase in Frankfurt, Werbung) sind vorab in den Abschnitten 15 bis 17 beschrieben und nur mit deiner Einwilligung aktiv. Technisch beteiligt sind allein Apple (iOS, Apple Health, Share-Sheet, App Store) nach deren eigenen Bedingungen und Open Food Facts bei Lebensmittelabfragen (Abschnitt 7). Eine Übermittlung in Drittländer durch BFC findet nicht statt. Gesundheitsdaten werden nie für Werbung oder Statistik verwendet.
"""),
        ("12. Teilen von Ergebnissen", """
Über „Teilen“ erzeugt BFC lokal ein Bild (Tageskarte, Schritte, Gym, Essen, Lauf-Strecke, Rang). Du siehst die Vorschau und entscheidest, ob und an wen (z. B. WhatsApp, Instagram) du es über das iOS-Teilen-Menü sendest. Ab dem Versand gelten die Datenschutzbestimmungen der gewählten App. Das Bild kann dein Profilbild, deinen Namen und Gesundheitsdaten (z. B. Schritte, Kalorien) zeigen. Du trägst die Verantwortung dafür, was du veröffentlichst.
"""),
        ("13. Community-Rezepte (nur wenn eingerichtet)", """
Die Community-Funktion ist optional und standardmäßig nicht verbunden. Falls du sie mit einem eigenen Firebase-Projekt verbindest, werden von dir veröffentlichte Rezepte und eine anonyme Kennung (anonyme Anmeldung) an Google Firebase übertragen, auch in die USA, abgesichert über Standardvertragsklauseln beziehungsweise das EU-US Data Privacy Framework. Es werden keine Gesundheitsdaten übertragen. Veröffentlichte Rezepte sind für andere sichtbar. Bei Nutzerinhalten gelten Melde- und Moderationsmöglichkeiten; rechtswidrige Inhalte werden entfernt.
"""),
        ("14. Extrem-Modus und Diät-Coach", """
Der Diät-Coach berechnet Vorschläge aus deinen eigenen Angaben. Der Extrem-Modus erfordert eine gesonderte, ausdrückliche Bestätigung, die nur lokal gespeichert wird und nach 28 Tagen verfällt. Die Vorschläge sind allgemeine Informationen und keine medizinische Beratung (siehe Haftungsausschluss).
"""),
        ("15. Nutzungsstatistik (optional, nur mit Einwilligung)", """
BFC kann anonyme Nutzungsstatistik erfassen, damit der Entwickler sieht, wie viele Personen die App nutzen, welche Funktionen genutzt werden und wo Abstürze auftreten. Das ist standardmäßig aus. Du schaltest es unter Einstellungen → Datenschutz → „Anonyme Nutzungsstatistik“ ein und kannst es dort jederzeit wieder ausschalten.
Stufe 1 (aktuell): Es läuft nur die Statistik von Apple (App Store Analytics, Abstürze). Sie ist aggregiert und für den Entwickler nur sichtbar, wenn du in den iOS-Einstellungen „Analyse und Verbesserungen → Mit App-Entwicklern teilen“ erlaubst. BFC sendet dafür selbst nichts.
Stufe 2 (geplant): Google Firebase (Analytics) mit Datenhaltung in der EU, Region Frankfurt (Deutschland). Mit Google besteht ein Auftragsverarbeitungsvertrag. Bei möglichen Zugriffen aus Drittländern gelten Standardvertragsklauseln beziehungsweise das EU-US Data Privacy Framework. Vor dem Start dieser Stufe wird diese Erklärung aktualisiert und BFC fragt dich erneut.
Erfasst werden nur anonyme Ereignisse (z. B. „Training gestartet“, „Scan abgeschlossen“, „Paywall geöffnet“), App-Version, iOS-Version, Gerätemodell, Sprache und eine zufällige Instanz-Kennung. Nie erfasst werden Name, E-Mail, Gesundheitswerte, Gewicht, Körperfett, Ernährung, Standort, Strecken, Fotos oder Scans.
Rechtsgrundlage ist deine Einwilligung (Art. 6 Abs. 1 lit. a DSGVO, § 25 TDDDG). Du kannst sie jederzeit mit Wirkung für die Zukunft widerrufen. Die Ereignisdaten werden höchstens 14 Monate gespeichert, vorgesehen sind 2 Monate.
"""),
        ("16. Werbung (vorbereitet, derzeit nicht aktiv)", """
BFC ist für optionale Werbung vorbereitet, um die App zu finanzieren. Solange in der App keine Werbung erscheint, wird dafür nichts verarbeitet. Bevor Werbung aktiviert wird, wird diese Erklärung um den Werbepartner, die übertragenen Daten und die Speicherdauer ergänzt.
Dann gilt: Werbung erscheint nur mit deiner Einwilligung (Abfrage der Einwilligung und, wo nötig, die Apple-Abfrage zur App-Verfolgung). Ohne Einwilligung gibt es nur nicht personalisierte Werbung oder keine. Auf Seiten mit Gesundheitsbezug (Scan, Körperwerte, Diät, Extrem-Modus, Analysen) wird keine Werbung gezeigt, und Gesundheitsdaten werden nie für Werbung verwendet oder an Werbepartner gegeben. Mit Premium entfällt die Werbung. Die Einwilligung kannst du unter Einstellungen → Datenschutz jederzeit widerrufen.
"""),
        ("17. Premium, Käufe und Abonnements (vorbereitet, derzeit nicht aktiv)", """
Während der Beta-Phase sind alle Funktionen kostenlos. Es wird nichts gekauft und kein Startdatum einer Testphase gespeichert. Die folgenden Angaben gelten ab dem Start von Premium; vorher wird die App entsprechend aktualisiert.
Premium-Funktionen (z. B. zweiter Scan, vollständige Makros, Entwicklung des 3D-Modells, vollständige Analysen) werden über den App Store gekauft. Die Zahlung, Abrechnung, Kündigung und Rückerstattung wickelt ausschließlich Apple ab. BFC erhält keine Zahlungsdaten, keinen Namen und keine Apple-ID. Ob Premium aktiv ist, prüft die App auf dem Gerät über Apples StoreKit; der Status wird lokal gespeichert, damit Premium auch ohne Internet funktioniert.
Abonnements verlängern sich automatisch, wenn du nicht mindestens 24 Stunden vor Ablauf kündigst. Du verwaltest und kündigst sie in den Einstellungen deiner Apple-ID unter „Abonnements“. Käufe lassen sich über „Käufe wiederherstellen“ auf neuen Geräten zurückholen.
Neue Nutzer können BFC sieben Tage mit allen Funktionen testen. Dafür wird nur das Startdatum der Testphase im iOS-Schlüsselbund deines Geräts gespeichert, damit eine Neuinstallation die Testphase nicht erneut startet (berechtigtes Interesse, Art. 6 Abs. 1 lit. f DSGVO, Vermeidung von Missbrauch). Das Datum enthält keinen Personenbezug und verlässt dein Gerät nicht. Es wird auch bei „Alle Daten in der App löschen“ nicht entfernt; du kannst es über die Schlüsselbund-Verwaltung von iOS beziehungsweise durch Zurücksetzen des Geräts löschen. Nach der Testphase bleiben Grundfunktionen frei, Premium-Funktionen brauchen ein Abonnement oder den Einmalkauf. Gesetzliche Widerrufs- und Gewährleistungsrechte bleiben unberührt; für digitale Inhalte gelten die Bedingungen des App Stores.
"""),
        ("18. Sicherheit", """
Deine Daten liegen im App-Speicher deines iPhones, der von iOS geschützt ist (Gerätesperre, Verschlüsselung bei gesetztem Code). Es gibt keine Datenübertragung zu BFC-Servern. Sichere dein Gerät mit einem Code oder Face ID. Der Export (JSON) und geteilte Dateien liegen unverschlüsselt in dem Ziel, das du wählst. Bei einer Verletzung des Schutzes personenbezogener Daten, soweit sie den Entwickler betrifft, werden Betroffene und gegebenenfalls die Aufsichtsbehörde nach den gesetzlichen Vorgaben informiert.
"""),
        ("19. Kinder und Jugendliche", """
BFC richtet sich an Personen ab 16 Jahren. Wenn du jünger bist, nutze die App nur mit Zustimmung deiner Eltern. Besonders Diät- und Extrem-Funktionen sind für Kinder und Jugendliche nicht geeignet.
"""),
        ("20. Deine Rechte", """
Du hast gegenüber dem Verantwortlichen folgende Rechte:
• Auskunft (Art. 15 DSGVO) und Kopie der Daten
• Berichtigung (Art. 16)
• Löschung (Art. 17)
• Einschränkung der Verarbeitung (Art. 18)
• Datenübertragbarkeit (Art. 20): Export als JSON unter Einstellungen → Datenschutz
• Widerspruch (Art. 21) gegen Verarbeitung auf Grundlage berechtigter Interessen
• Widerruf einer Einwilligung (Art. 7 Abs. 3) jederzeit mit Wirkung für die Zukunft, ohne dass die Rechtmäßigkeit der bisherigen Verarbeitung berührt wird
Da die Daten fast ausschließlich lokal bei dir liegen, kannst du die meisten Rechte direkt in der App ausüben. Für alles Weitere schreibe an \(LegalInfo.contactEmail).
Beschwerderecht: Du kannst dich bei einer Datenschutz-Aufsichtsbehörde beschweren, z. B. bei der Landesbeauftragten für Datenschutz und Informationsfreiheit Nordrhein-Westfalen (ldi.nrw.de), oder bei der Behörde an deinem Wohnort.
"""),
        ("21. Pflichtangaben und Folgen eines Widerrufs", """
Die Nutzung von BFC verlangt keine Pflichtangaben an den Entwickler. Ohne Einwilligung in die Verarbeitung von Apple-Health-Daten entfallen Schritt-Verlauf, Lifetime-Schritte, die Übernahme von Uhr-Workouts und Teile der Auswertung; du kannst weiter manuell Daten eintragen. Ein Widerruf wirkt nur für die Zukunft.
"""),
        ("22. Änderungen dieser Erklärung", """
Wenn sich die Apps oder die Rechtslage ändern, wird diese Erklärung angepasst. Die jeweils aktuelle Fassung findest du in der App unter Einstellungen → Datenschutz und online unter der in App Store Connect angegebenen Adresse. Bei wesentlichen Änderungen (z. B. neue Datenübertragungen) fragt BFC erneut um deine Einwilligung.
"""),
    ]
    static let disclaimer = """
BFC ist ausschließlich eine Hilfestellung. Die App liefert allgemeine Informationen zu Training, Ernährung und Bewegung. Es ist keine medizinische, therapeutische oder Ernährungsberatung und ersetzt keinen Arzt oder keine Ärztin. Alle Angaben, Berechnungen, Pläne, Kalorien- und Trainingsvorschläge, Körperfett- und Zeitschätzungen sind unverbindliche Richtwerte ohne Gewähr auf Richtigkeit, Vollständigkeit oder Eignung für deinen Einzelfall.
Die Nutzung der App und das Befolgen ihrer Vorschläge erfolgen auf eigene Verantwortung. Sprich vor einer Diät, vor Fasten, vor dem Extrem-Modus und vor neuem oder intensivem Training mit einem Arzt, besonders bei Vorerkrankungen, Medikamenten, Schwangerschaft, Stillzeit oder einer Essstörung. Brich bei Schwindel, Schmerzen, Herzrasen, Atemnot oder Ohnmacht sofort ab und hole ärztliche Hilfe.
Der Entwickler haftet nicht für Schäden, die aus der Nutzung der App oder dem Befolgen ihrer Vorschläge entstehen, soweit gesetzlich zulässig. Unberührt bleibt die Haftung für Vorsatz und grobe Fahrlässigkeit, für die Verletzung von Leben, Körper oder Gesundheit sowie nach zwingenden gesetzlichen Vorschriften (z. B. Produkthaftungsgesetz). Für die Richtigkeit von Nährwertdaten aus Open Food Facts und anderen Quellen übernimmt der Entwickler keine Gewähr.
Aus den Angaben, Plänen, Analysen und Auswertungen der App (auch aus KI-gestützten Auswertungen, 3D-Animationen und Körperscans) lassen sich keine Rechtsansprüche ableiten. Sie haben keine rechtliche Verbindlichkeit und sind weder Gutachten noch Diagnose noch Nachweis gegenüber Dritten, etwa Versicherungen, Behörden oder Arbeitgebern.
Die Sensoren des iPhones (Schritte, GPS, LiDAR, Kamera) und die Schätzungen sind nicht medizinisch genau. Der Extrem-Modus kann der Gesundheit schaden und ist nur für gesunde Erwachsene und nur kurzzeitig gedacht.
"""
    static let usageNotice = """
BFC ist nur eine Hilfestellung für Training, Ernährung und Bewegung. Die App ersetzt keine ärztliche, therapeutische oder Ernährungsberatung.
Alle Pläne, Analysen, Schätzungen (z. B. Körperfett) und Animationen sind unverbindliche Richtwerte. Sie haben keine rechtliche Verbindlichkeit, und es lassen sich keine Ansprüche daraus ableiten.
Du trainierst und ernährst dich auf eigene Verantwortung. Bei Schmerzen, Schwindel oder Vorerkrankungen sprich vorher mit einem Arzt.
"""
}
