import Foundation

// AUTOMATISCH ERZEUGT (tools/exercises) – nicht von Hand bearbeiten.
// 174 Familien, 4294 Übungen. Aufbau siehe ExerciseGenerator.swift.
enum ExerciseDB {
    static let families = #"""
strength|w|ch|sh tri|benchPress|Mittlere Brust|||0|0|0.4|Schulterblätter zusammenziehen und leicht ins Polster drücken.~Gewicht kontrolliert zur unteren Brust senken, Unterarme bleiben senkrecht.~Füße fest am Boden, Gesäß bleibt auf der Bank.
strength|w|ch|sh tri|benchPress|Mittlere Brust|||0|0|0|Sitz so einstellen, dass die Griffe auf Brusthöhe starten.~Schulterblätter zurück und unten, Brust bleibt offen.~Arme nicht ganz durchdrücken, Spannung halten.
strength|w|ch|sh|fly|Brust (Dehnungsreiz)|||0|0|0.1|Ellbogen leicht gebeugt und fixiert, wie eine Umarmung bewegen.~Nur so weit öffnen, wie die Schulter schmerzfrei bleibt.~Oben Brust bewusst zusammendrücken, nicht Hantel gegen Hantel schlagen.
strength|w|ch|sh|flyCable|Innere Brust|||0|0|0|Leichter Ausfallschritt, Rumpf leicht vorgeneigt, Ellbogen leicht gebeugt.~Hände auf einem Bogen vor dem Körper zusammenführen.~Am Ende Brust anspannen, Schultern bleiben unten.
calisthenics|bw|ch|sh tri ab|pushup|Brust|||0|0|0|Körper bildet eine Linie von Kopf bis Ferse.~Ellbogen etwa 45 Grad vom Körper, Brust fast bis zum Boden.~Zu schwer: Hände erhöhen oder Knie abstützen. Zu leicht: Füße erhöhen.
calisthenics|bw|ch|sh tri|pushup|Brust (Schnellkraft)|||0|0|0|Kraftvoll nach oben abdrücken, bis die Hände den Boden verlassen.~Weich landen, Ellbogen leicht gebeugt.~Nur mit sauberer Technik, bei Ermüdung beenden.
calisthenics|bw|tri ch|sh|triceps|Trizeps / untere Brust|||0|0|0|Schultern runter, nicht in die Schultern hängen.~Oberkörper leicht nach vorn für mehr Brust, aufrecht für mehr Trizeps.~Nur so tief, wie die Schulter schmerzfrei bleibt.
calisthenics|bw|tri|sh ch|triceps|Trizeps|||0|0|0|Hände hinter dem Körper auf der Bank, Finger zeigen nach vorn.~Ellbogen zeigen nach hinten, nicht zur Seite.~Nur so tief, dass die Schulter nicht nach vorn rutscht.
strength|w|ch la|tri|pullover|Brust / Latissimus|||0|0|0|Arme nahezu gestreckt, Bewegung kommt aus der Schulter.~Rippen bleiben unten, nicht ins Hohlkreuz fallen.~Nur bis zu einer Dehnung gehen, die ohne Schmerz bleibt.
strength|w|ch sh|tri ab|overhead|Obere Brust / vordere Schulter|||0|0|0|Stange in Ecke oder Halterung, Last mit beiden Händen auf Brusthöhe greifen.~Schräg nach oben drücken, Rumpf bleibt fest.~Schulterblatt führt die Bewegung mit.
strength|w|ch|tri|benchPress|Innere Brust|||0|0|0|Hanteln aneinanderpressen und die ganze Zeit zusammenhalten.~Drückbewegung gerade nach oben, Ellbogen eng.~Die Spannung zwischen den Hanteln ist der Reiz, nicht das Gewicht.
strength|sec|ch|sh|benchPress|Innere Brust||3 × 15 s halten|0|0|0|Handflächen vor der Brust gegeneinanderdrücken.~Schultern unten, Ellbogen auf Höhe der Hände.~Spannung 10–20 Sekunden halten.
calisthenics|bw|la|bi tr fo|pullup|Latissimus|||0|0|0|Erst die Schulterblätter nach unten ziehen, dann die Arme beugen.~Kinn über die Stange, unten wieder ganz strecken.~Noch nicht möglich? Mit Gummiband oder langsamem Ablassen (Negativ) üben.
strength|w|la|bi tr|pullup|Latissimus|||0|0|0.5|Brust raus, Stange zur oberen Brust ziehen, nicht hinter den Nacken.~Ellbogen nach unten und hinten führen.~Oben nicht im Schwung zurücklehnen.
strength|w|la tr|bi lb|row|Mittlerer Rücken|||0|0|0.35|Oberkörper etwa 45 Grad vorgeneigt, Rücken gerade.~Ellbogen eng am Körper zum Bauchnabel ziehen.~Oberkörper bleibt stabil, kein Schwung aus dem Rücken.
strength|w|la tr|bi|row|Mittlerer Rücken|||0|0|0|Aufrecht sitzen, Brust raus, Schulterblätter zusammen.~Griff zum Bauch ziehen, Ellbogen eng.~Nicht mit dem Oberkörper schwingen.
strength|w|tr la|bi|row|Oberer Rücken|||0|0|0|Brust auf Pad oder Bank, Nacken neutral.~Ellbogen führen, Hände folgen.~Oben Schulterblätter kurz zusammenpressen.
strength|w|la|bi tr|row|Latissimus|||0|0|0.2|Eine Hand und ein Knie auf der Bank abstützen.~Hantel zur Hüfte ziehen, nicht zur Schulter.~Gewichtsangabe der einen Hantel eintragen.
strength|w|tr sh|la|facePull|Hintere Schulter / oberer Rücken|||0|0|0|Seil auf Gesichtshöhe, zu den Ohren ziehen.~Ellbogen hoch, Hände trennen sich am Ende.~Schultern unten, Nacken entspannt.
calisthenics|bw|la tr|sh|pullup|Schulterblatt-Stabilität|||0|0|0|Arme gestreckt hängen, nur die Schulterblätter nach unten ziehen.~Ohne Armbeugen.~Langsam wieder entspannen.
calisthenics|bw|la tr|bi|row|Rückenmitte|||0|0|0|Körper gerade wie ein Brett, Brust zur Stange ziehen.~Ellbogen eng am Körper.~Je flacher der Körperwinkel, desto schwerer.
strength|w|lb gl|ha tr qu|rdl|Rückenstrecker / Gesäß|||0|0|0.6|Stange nah am Körper, Rücken gerade, Brust raus.~Mit den Beinen anschieben, dann Hüfte strecken.~Oben nicht ins Hohlkreuz überstrecken.
strength|w|ha gl|lb|rdl|Beinbeuger / Gesäß|||0|0|0.4|Knie nur leicht gebeugt, Hüfte nach hinten schieben.~Last bleibt am Körper, Rücken gerade.~Bis zur Dehnung hinten am Oberschenkel senken, dann Hüfte nach vorn.
strength|w|lb ha|gl|rdl|Rückenstrecker|||0|0|0.2|Stange hoch auf dem Rücken, Knie leicht gebeugt.~Hüfte nach hinten schieben, Rücken bleibt lang.~Leicht starten, die Übung ist anspruchsvoll für den Rücken.
strength|bw|lb gl|ha|rdl|Rückenstrecker|||0|0|0|Polster unter dem Becken, Körper in einer Linie.~Hüfte beugen, Rücken bleibt gerade.~Oben nicht überstrecken, Gesäß anspannen.
strength|w|gl lb|ha|bridge|Gesäß / unterer Rücken|||0|0|0|Bauch auf dem Polster, Beine hängen.~Beine kontrolliert bis in die Verlängerung des Rückens heben.~Kein Schwung.
strength|w|tr la|bi|row|Oberer Rücken|||0|0|0|Arme gestreckt, nur Schulterblätter zusammenziehen.~Kurz halten.~Kontrolliert lösen.
strength|w|tr sh|la|lateral|Unterer Trapez|||0|0|0.04|Arme im Y schräg nach oben, Daumen zeigen nach oben.~Schulterblätter zurück und unten.~Leichte Gewichte reichen.
strength|w|tr sh|la|lateral|Mittlerer Trapez|||0|0|0.04|Arme waagerecht seitlich, Daumen nach oben.~Schulterblätter zusammenziehen.~Leicht und sauber.
strength|w|tr|fo|row|Oberer Trapez|||0|0|0.3|Schultern gerade nach oben ziehen, nicht kreisen.~Oben kurz halten.~Arme bleiben gestreckt.
strength|w|sh tr|bi|uprightRow|Seitliche Schulter / Trapez|||0|0|0.25|Last nah am Körper bis unter Brusthöhe ziehen.~Ellbogen führen, nicht höher als die Schultern bei Beschwerden.~Griff schulterbreit oder etwas breiter.
calisthenics|bw|lb gl|ha|cobra|Rückenstrecker|||0|0|0|Bauchlage, Arme und Beine gleichzeitig vom Boden heben.~Kurz halten, Nacken neutral.~Nicht überstrecken.
strength|w|sh|tri tr|overhead|Vordere und seitliche Schulter|||0|0|0.15|Core anspannen, nicht ins Hohlkreuz fallen.~Last auf Schulterhöhe starten, über dem Kopf strecken.~Kopf leicht nach hinten, dann wieder unter der Last.
strength|w|sh|tri qu|overhead|Schulter (explosiv)|||0|0|0|Kurzer Kniebeugeimpuls, dann explosiv drücken.~Last wandert gerade über dem Kopf.~Rumpf bleibt fest, kein Hohlkreuz.
strength|w|sh|tr|lateral|Seitliche Schulter|||0|0|0.07|Arme leicht gebeugt bis auf Schulterhöhe anheben.~Ohne Schwung, nicht höher als die Schulter.~Eher leicht wählen.
strength|w|sh|ch|frontRaise|Vordere Schulter|||0|0|0.06|Arme gerade nach vorn bis auf Schulterhöhe.~Rumpf bleibt gerade.~Nicht schwingen.
strength|w|sh tr|la|lateral|Hintere Schulter|||0|0|0.05|Vorgebeugt, Rücken gerade, Arme leicht gebeugt.~Zur Seite öffnen bis auf Schulterhöhe.~Schulterblätter nicht zu stark zusammenziehen.
strength|w|sh|tr|lateral|Rotatorenmanschette (hinten)|||0|0|0.02|Ellbogen eng am Körper, Unterarm nach außen drehen.~Sehr leichtes Gewicht, saubere Kontrolle.~Wichtig für gesunde Schultern.
strength|w|sh|ch|lateral|Rotatorenmanschette (vorn)|||0|0|0.02|Ellbogen eng am Körper, Unterarm nach innen drehen.~Sehr leicht und kontrolliert.~Schulter bleibt ruhig.
calisthenics|bw|sh|tri ch|pushup|Schulter|||0|0|0|Hüfte hoch, Körper bildet ein umgekehrtes V.~Kopf zwischen die Hände senken.~Steigerung auf dem Weg zum Handstand-Liegestütz.
calisthenics|bw|sh|tri tr|overhead|Schulter|||0|0|0|Nur mit sicherem Handstand an der Wand.~Kopf kontrolliert zum Boden, Ellbogen nach vorn.~Immer neben einer freien Fläche üben.
calisthenics|sec|sh|tri tr ab|plank|Schulter / Körperspannung||5 × 20 s|0|0|0|Hände schulterbreit, Finger gespreizt, Arme gestreckt.~Körper in einer Linie, Rippen unten.~Üben an der Wand, Sturz rechtzeitig abbrechen.
calisthenics|sec|sh|ab qu|plank|Schulter / Rumpf||3 × 20 m|0|0|0|Hände und Füße am Boden, Knie knapp über dem Boden.~Gegenseitig vorwärts bewegen.~Rücken bleibt flach.
strength|w|bi|fo|curl|Bizeps|||0|0|0.12|Ellbogen bleiben am Körper.~Oben kurz anspannen, unten ganz strecken.~Kein Schwung aus dem Rücken.
strength|w|bi|fo|curl|Bizeps (Spitze)|||0|0|0.08|Ellbogen innen am Oberschenkel abstützen.~Langsam und ohne Schwung.~Oben kräftig anspannen.
strength|w|bi|fo|curl|Bizeps (unterer Teil)|||0|0|0|Oberarme liegen auf dem Pult, Brust bleibt angelehnt.~Unten nicht ganz durchstrecken, wenn die Sehne zwickt.~Langsam absenken.
strength|w|bi|fo|curl|Bizeps (kurzer Kopf)|||0|0|0|Bauch auf der Schrägbank, Arme hängen senkrecht.~Ellbogen bleiben fixiert.~Oben stark anspannen.
strength|w|bi|fo|curl|Bizeps / Unterarm|||0|0|0|Hoch im Untergriff, oben die Hände drehen.~Im Obergriff langsam senken.~Leichte Gewichte.
strength|w|bi|fo|curl|Bizeps (Spitze)|||0|0|0|Arme seitlich auf Schulterhöhe, Griffe zum Kopf ziehen.~Ellbogen bleiben auf Höhe.~Oben Spannung.
calisthenics|bw|bi la|fo|pullup|Bizeps|||0|0|0|Hochspringen, im Untergriff langsam absenken.~5 Sekunden Ablassen.~Gut zum Aufbau von Klimmzügen.
calisthenics|bw|bi|fo|curl|Bizeps|||0|0|0|Rückenlage unter den Griffen, Körper gerade.~Arme beugen, Stirn zu den Händen.~Je flacher, desto schwerer.
strength|w|tri||pushdown|Trizeps|||0|0|0|Ellbogen eng am Körper, nur die Unterarme bewegen.~Unten vollständig strecken und kurz anspannen.~Oberkörper bleibt ruhig.
strength|w|tri||triceps|Trizeps (langer Kopf)|||0|0|0.1|Ellbogen zeigen nach vorn, Oberarme bleiben nahe am Kopf.~Unterarme beugen, dann strecken.~Rumpf stabil, kein Hohlkreuz.
strength|w|tri||skull|Trizeps|||0|0|0.15|Ellbogen zeigen zur Decke, Oberarme bleiben fest.~Last kontrolliert zur Stirn oder hinter den Kopf senken.~Dann strecken, ohne die Ellbogen zu öffnen.
strength|w|tri||kickback|Trizeps|||0|0|0.05|Oberkörper vorgebeugt, Oberarm parallel zum Körper.~Unterarm nach hinten strecken.~Leicht und sauber.
strength|w|tri|ch sh|benchPress|Trizeps|||0|0|0.35|Hände etwa schulterbreit, Ellbogen eng.~Stange zur unteren Brust.~Nicht zu schmal greifen (Handgelenke).
strength|w|tri|ch|triceps|Trizeps|||0|0|0.25|Mischform aus Skull Crusher und enges Bankdrücken.~Ellbogen bleiben nach vorn.~Mit leichtem Gewicht lernen.
strength|w|tri|ch|triceps|Trizeps|||0|0|0|Oberkörper aufrecht, Ellbogen eng.~Sitz so einstellen, dass die Schultern nicht hochgezogen werden.~Voll strecken.
calisthenics|bw|tri|ch sh|pushup|Trizeps|||0|0|0|Hände eng, Ellbogen bleiben am Körper.~Körper bleibt in einer Linie.~Stufe mit Knien oder Händen erhöht möglich.
calisthenics|bw|tri||triceps|Trizeps|||0|0|0|Hände unter dem Kopf auf einer Erhöhung, Körper schräg.~Ellbogen beugen, Stirn zu den Händen.~Gerade nach oben strecken.
strength|w|fo||curl|Handgelenkbeuger|||0|0|0.05|Unterarme aufgelegt, nur die Hände bewegen.~Langsam und vollständig.~Leichtes Gewicht, hohe Wiederholungen.
functional|sec|fo tr|ab gl|farmer|Griffkraft / Rumpf||3 × 30–40 m|0|0|0|Aufrecht gehen, Schultern unten, Bauch fest.~Gewicht gleich auf beide Seiten verteilen.~Kurze, kontrollierte Schritte.
calisthenics|sec|fo la|sh|hang|Griffkraft||3 × 20–40 s|0|0|0|Schultern leicht aktiv, Rippen unten.~Entspannt aber stabil hängen.~Griffwechsel bei Ermüdung.
strength|w|fo||curl|Finger|||0|0|0.03|Gewicht in den Fingern abrollen.~Langsam öffnen und wieder greifen.~Leicht beginnen.
functional|sec|fo||idle|Zangengriff||3 × 20–30 s|0|0|0|Scheiben glatt aneinander zwischen Daumen und Fingern halten.~Aufrecht stehen.~Zeit bis zur Ermüdung.
strength|w|fo|sh|curl|Unterarm|||0|0|0.04|Stab mit Seil und Gewicht aufrollen.~Arme gestreckt auf Schulterhöhe.~Beide Richtungen trainieren.
strength|sec|ne|tr|idle|Nacken||3 × 10 s|0|0|0|Kopf neutral, Bewegung klein und kontrolliert.~Mit Handwiderstand beginnen.~Nie ruckartig.
calisthenics|sec|ne|tr|bridge|Nacken||3 × 10 s|0|0|0|Nur mit Vorerfahrung, Gewicht größtenteils auf den Füßen.~Sehr kurze Halte.~Bei Schmerzen abbrechen.
strength|w|qu gl|ha lb ad|squat|Oberschenkel vorn / Gesäß|||0|0|0.5|Füße etwa schulterbreit, Knie folgen den Zehen.~Brust aufrecht, Rücken neutral, Gewicht auf dem ganzen Fuß.~Tief genug für Kontrolle, Fersen bleiben am Boden.
calisthenics|bw|qu gl|ha ad|squat|Beine|||0|0|0|Füße schulterbreit, Arme vorn zum Gleichgewicht.~Hüfte nach hinten und unten.~Fersen bleiben am Boden.
calisthenics|sec|qu|gl|squat|Oberschenkel vorn||3 × 30 s|0|0|0|Band hinter den Knien, nach hinten lehnen.~Knie bleiben vorn, Oberkörper aufrecht.~Quadrizeps arbeitet isometrisch.
calisthenics|bw|qu gl|ha ad|squat|Beine (einbeinig)|||0|0|0|Ein Bein nach vorn gestreckt, tief in die Hocke.~Ferse bleibt am Boden.~Erst mit Stütze oder Box üben.
strength|w|qu gl|ha ad|lunge|Beine (einseitig)|||0|0|0.2|Hinterer Fuß auf Bank, vorderer Fuß weit vorn.~Senkrecht absinken, Knie folgt Zehen.~Oberkörper aufrecht oder leicht vorgeneigt.
strength|w|qu gl|ha ad|lunge|Beine / Gesäß|||0|0|0.15|Großer Schritt, hinteres Knie fast zum Boden.~Vorderes Knie zeigt über die Zehen, Oberkörper aufrecht.~Mit der vorderen Ferse zurückdrücken.
strength|w|qu gl|ha|lunge|Beine / Gesäß|||0|0|0.12|Ganzer Fuß auf der Kiste, drücken aus dem vorderen Bein.~Nicht mit dem hinteren Fuß abstoßen.~Oben aufrecht stehen.
strength|w|qu gl|ha ad|squat|Beine|||0|0|0|Rücken und Becken bleiben am Polster.~Knie nie ganz durchstrecken.~Fußposition verändert den Schwerpunkt.
strength|w|qu|gl|squat|Oberschenkel vorn|||0|0|0|Rücken am Polster, Füße vorn.~Tief absenken.~Knie folgen den Zehen.
strength|w|qu||squat|Oberschenkel vorn|||0|0|0|Rücken an die Lehne, Polster oberhalb des Fußgelenks.~Oben voll strecken und kurz anspannen.~Langsam absenken.
calisthenics|bw|qu|hf|squat|Oberschenkel vorn (Dehnung)|||0|0|0|Auf den Zehen, Knie nach vorn schieben, Oberkörper zurück.~Sehr kontrolliert.~Nur mit gesunden Knien.
calisthenics|sec|qu|gl|squat|Oberschenkel vorn (isometrisch)||3 × 30–60 s|0|0|0|Rücken an der Wand, Knie 90 Grad.~Gewicht auf den Fersen.~Zeit steigern.
strength|w|ha|ca|rdl|Beinbeuger|||0|0|0|Polster am Fußgelenk, Becken fest.~Voll beugen, kurz anspannen.~Langsam zurück.
calisthenics|bw|ha|gl ca|rdl|Beinbeuger (exzentrisch)|||0|0|0|Fersen fixiert, Körper gerade wie ein Brett.~So langsam wie möglich nach vorn sinken.~Mit den Händen auffangen.
strength|w|gl|ha qu|bridge|Gesäß|||0|0|0.4|Schulterblätter an der Bank, Fersen unter den Knien.~Hüfte bis zur Streckung heben, Gesäß anspannen.~Kinn bleibt leicht Richtung Brust.
calisthenics|bw|gl|ha|bridge|Gesäß|||0|0|0.3|Rückenlage, Füße aufgestellt, Hüfte heben.~Oben Gesäß fest anspannen.~Nicht ins Hohlkreuz überstrecken.
strength|w|gl|ha|bridge|Gesäß|||0|0|0.05|Rumpf stabil, Bein nach hinten strecken.~Nicht ins Hohlkreuz schwingen.~Oben Gesäß anspannen.
strength|w|gl|ab|legSwing|Gesäß (seitlich)|||0|0|0|Becken bleibt stabil, Bein zur Seite führen.~Fuß zeigt gerade oder leicht nach unten.~Langsam zurück.
strength|w|ad||legSwing|Adduktoren|||0|0|0|Becken stabil, Bein nach innen führen.~Kontrolliert zurück.~Nicht ruckartig.
calisthenics|bw|gl|ad|bridge|Gesäß|||0|0|0|Fußsohlen zusammen, Knie fallen auseinander.~Hüfte schnell heben und senken.~Hohe Wiederholungen.
calisthenics|bw|ad gl|qu|cossack|Adduktoren / Gesäß|||0|0|0|Weiter Stand, zur Seite in die Hocke.~Gestrecktes Bein auf der Ferse.~Brust aufrecht.
strength|w|ca||calf|Wade|||0|0|0.3|Voller Bewegungsumfang: tief dehnen, hoch strecken.~Oben 1–2 Sekunden halten.~Nicht federn.
strength|w|ca||calf|Wade|||0|0|0|Fußballen auf dem unteren Rand, Knie fast gestreckt.~Voller Weg.~Kontrolliert.
strength|bw|ca||calf|Schienbeinmuskel|||0|0|0|Rücken an der Wand, Fersen am Boden, Zehen heben.~Langsam senken.~Schutz vor Schienbeinschmerzen.
strength|sec|ca||calf|Fußmuskulatur||3 × 15 s|0|0|0|Fußgewölbe leicht anheben, ohne die Zehen zu krallen.~Halten.~Barfuß üben.
core|bw|ab|hf|crunch|Gerade Bauchmuskeln|||0|0|0|Untere Rippen zum Becken ziehen, Kopf bleibt Verlängerung der Wirbelsäule.~Nicht am Nacken ziehen.~Langsam zurück, Spannung halten.
core|sec|ab|sh gl lb|plank|Rumpfstabilität||3 × 30–60 s|0|0|0|Körper bildet eine Linie, Gesäß und Bauch fest.~Ellbogen unter den Schultern.~Atmen, nicht ins Hohlkreuz fallen.
core|bw|ab hf|fo|legRaise|Untere Bauchmuskeln|||0|0|0|Rumpf stabil, Becken leicht nach hinten kippen.~Beine gestreckt oder gebeugt heben.~Kontrolliert absenken.
core|bw|ab|hf|deadBug|Tiefe Bauchmuskeln|||0|0|0|Rücken flach auf dem Boden, Arme und Beine im Wechsel.~Unterer Rücken verliert nie den Boden.~Langsam atmen.
core|sec|ab|hf|hollowHold|Rumpfspannung||3 × 20–30 s|0|0|0|Rücken flach, Arme und Beine knapp über dem Boden.~Rippen nach unten.~Aufhören, wenn der Rücken abhebt.
core|bw|ab|hf|crunch|Schräge Bauchmuskeln|||0|0|0|Oberkörper leicht zurück, Rücken gerade.~Nur den Rumpf drehen, nicht die Arme.~Kontrolliert wechseln.
core|w|ab|sh gl|crunch|Schräge Bauchmuskeln|||0|0|0.05|Aus den Hüften drehen, Arme folgen.~Gesäß angespannt, Füße stabil.~Kontrolliert zurück.
core|w|ab|sh|plank|Anti-Rotation|||0|0|0.05|Seitlich zum Zug, Hände vor der Brust, nach vorn drücken.~Rumpf darf sich nicht drehen.~Kurz halten.
core|bw|ab|sh la|plank|Rumpf|||0|0|0|Rücken bleibt gerade, Rippen nach unten.~Nur so weit rollen, wie du den Rücken stabil hältst.~Gesäß fest.
core|w|ab|lb|crunch|Schräge Bauchmuskeln|||0|0|0.1|Gerade zur Seite beugen, nicht vor- oder zurücklehnen.~Gewicht nur auf einer Seite.~Kontrolliert.
core|sec|ab|sh gl|plank|Schräge Bauchmuskeln||3 × 20–40 s|0|0|0|Ellbogen unter der Schulter, Hüfte hoch.~Körper bildet eine Linie.~Becken sinkt nicht ab.
core|sec|ab|sh hf|kneeRaise|Rumpf / Kondition||3 × 30 s|0|0|0|Stütz, Knie abwechselnd zur Brust.~Hüfte bleibt tief.~Tempo nach Gefühl.
core|bw|ab||crunch|Gerade Bauchmuskeln|||0|0|0|Beine senkrecht, Hände zu den Füßen.~Schulterblätter heben.~Kontrolle.
core|sec|ab hf||hollowHold|Rumpf / Hüftbeuger||3 × 20 s|0|0|0|Oberkörper und Beine zu einem V.~Rücken gerade.~Kurz halten.
calisthenics|sec|ab hf|tri sh|hollowHold|Rumpf / Stützkraft||5 × 10–20 s|0|0|0|Hände am Boden oder an Griffen, Beine waagerecht.~Schultern nach unten drücken.~Kurz, dafür sauber.
calisthenics|bw|ab|hf|hollowHold|Rumpf|||0|0|0|Schultern fixiert, Körper gestreckt.~Nur mit Vorerfahrung.~Langsam senken.
calisthenics|sec|la ab|sh|hang|Rumpf / Latissimus||5 × 5–10 s|0|0|0|Körper waagerecht unter der Stange.~Arme gestreckt.~Stufen: Tuck, Straddle, voll.
calisthenics|sec|ab la|sh|plank|Rumpf seitlich||5 × 3–8 s|0|0|0|An senkrechter Stange seitlich halten.~Unterer Arm drückt, oberer zieht.~Hohe Schulterbelastung.
core|w|ab||crunch|Gerade Bauchmuskeln|||0|0|0.3|Becken fixiert, Brust zum Becken.~Nicht mit den Armen ziehen.~Kontrolliert.
core|w|lb|gl|rdl|Unterer Rücken|||0|0|0.3|Polster fest, Rücken gerade bewegen.~Nicht überstrecken.~Kontrolliert.
core|bw|lb ab|gl sh|deadBug|Rumpfstabilität|||0|0|0|Vierfüßler, Arm und Gegenbein strecken.~Becken bleibt ruhig.~Kurz halten.
core|sec|ab sh|lb|plank|Rumpfstabilität||3 × 30 s|0|0|0|Plank, abwechselnd Arm nach vorn.~Hüfte ruhig.~Langsam.
functional|sec|ab|fo tr|farmer|Rumpf (seitlich)||3 × 30 m|0|0|0|Last auf einer Seite, aufrecht bleiben.~Nicht zur Last neigen.~Kleine Schritte.
functional|sec|sh ab|tr|farmer|Schulterstabilität||3 × 20–30 m|0|0|0|Last über dem Kopf, Rippen unten.~Arm gestreckt, Schulter aktiv.~Langsam gehen.
cardio|sec|qu ha|gl ca|run|Herz-Kreislauf||3 × 5 min|300|0|0|Aufrecht laufen, Blick nach vorn.~Landung unter dem Körper.~Gleichmäßig atmen.
cardio|sec|qu gl|ca ha|walk|Grundlagenausdauer||3 × 5 min|300|0|0|Aufrechte Haltung.~Ganzer Fußabrollschritt.~Zügig, aber entspannt.
cardio|sec|qu gl|ha ca|kneeRaise|Beinausdauer||3 × 5 min|300|0|0|Sattel richtig einstellen.~Rücken lang, Schultern locker.~Rund treten.
cardio|sec|la qu|gl ha bi|row|Ganzkörper-Ausdauer||3 × 5 min|300|0|0|Erst Beine drücken, dann Rücken, dann Arme.~Zurück in umgekehrter Reihenfolge.~Rücken lang.
cardio|sec|la sh|ab gl|pullup|Ganzkörper schonend||3 × 5 min|300|0|0|Lange Züge.~Rumpf stabil.~Ruhig ausatmen ins Wasser.
cardio|sec|qu hf|ab|kneeRaise|Gelenkschonend||3 × 5 min|300|0|0|Aufrecht.~Arme paddeln.~Gleichmäßig.
cardio|sec|qu gl|ca ha|kneeRaise|Beine/Gesäß||3 × 5 min|300|0|0|Ganzen Fuß aufsetzen.~Nicht auf dem Handlauf abstützen.~Aufrecht.
cardio|sec|qu gl|ha ca la|kneeRaise|Ganzkörper schonend||3 × 5 min|300|0|0|Aufrecht.~Gleichmäßig schieben und ziehen.~Nicht ins Geländer hängen.
cardio|sec|ca|qu fo|jumpRope|Koordination und Ausdauer||5 × 1 min|300|0|0|Handgelenke drehen, nicht die Arme.~Kleine Sprünge.~Weich landen.
cardio|sec|qu|ca gl|kneeRaise|Aufwärmen||2 × 45 s|300|0|0|Locker beginnen.~Gleichmäßig atmen.~Bewegung langsam steigern.
cardio|sec|qu gl|ab ca|kneeRaise|Intervall-Cardio||4 × 30 s|300|0|0|Höchstes Tempo bei sauberer Form.~Pausen einhalten.~Weich landen.
plyo|bw|qu gl|ca ha|squat|Schnellkraft|||0|0|0|Weich landen, Knie über den Zehen.~Kurze Bodenkontakte.~Nur mit ausgeruhten Beinen.
plyo|bw|ch tri|sh ab|pushup|Schnellkraft|||0|0|0|Weich landen, Knie über den Zehen.~Kurze Bodenkontakte.~Nur mit ausgeruhten Beinen.
plyo|bw|ch sh|tri ab|overhead|Explosive Ganzkörperkraft|||0|0|0|Weich landen, Knie über den Zehen.~Kurze Bodenkontakte.~Nur mit ausgeruhten Beinen.
strength|w|gl qu|sh tr ha|overhead|Ganzkörper-Schnellkraft|||0|0|0|Stange nah am Körper, Hüfte und Beine strecken.~Unter die Stange tauchen, Arme aktiv.~Kontrolliert ablegen.
strength|w|gl qu|tr ha lb|rdl|Ganzkörper-Schnellkraft|||0|0|0|Stange eng an den Beinen nach oben.~Ellbogen schnell unter die Stange.~In stabiler Front-Position landen.
strength|w|sh tri|gl qu|overhead|Schulter und Beine|||0|0|0|Mit Beinen Schwung holen.~Stange gerade über den Kopf.~Rumpf fest.
strength|w|gl ha|lb qu|swing|Hüftkraft|||0|0|0|Hüfte schnappt nach vorn, nicht die Arme heben.~Rücken lang, Kettlebell schwingt zwischen den Beinen.~Oben Gesäß und Bauch fest.
strength|w|sh ab|gl qu|bridge|Ganzkörper-Stabilität|||0|0|0|Blick bleibt auf der Kettlebell.~Arm bleibt senkrecht.~Jede Position kurz stabilisieren.
strength|w|qu gl|ab|squat|Beine|||0|0|0|Gewicht vor der Brust.~Tiefe Hocke.~Rücken lang.
core|w|ab|sh gl|bwsRotate|Rumpf und Schulter|||0|0|0|Blick zur Hand oben.~Hüfte nach hinten schieben.~Arm bleibt senkrecht.
functional|sec|qu gl|ca ha|squat|Beine, Kondition||4 × 20 m|0|0|0|Körper schräg, Arme gestreckt.~Kurze kräftige Schritte.~Rücken flach.
functional|sec|sh|ab bi tri|overhead|Schulterausdauer||4 × 30 s|0|0|0|Leicht gebeugte Knie.~Wellen aus Schultern und Hüfte.~Rücken stabil.
functional|w|gl qu|la ha|rdl|Ganzkörperkraft|||0|0|0|Reifen mit geradem Rücken unterfassen.~Aus den Beinen kippen.~Aufstehen mit Hüfte.
functional|sec|fo tr|ab gl|farmer|Griff und Rumpf||4 × 30 m|0|0|0|Aufrecht gehen, Schultern tief.~Fester Griff.~Kleine Schritte.
functional|w|gl qu|la ab|squat|Ganzkörper|||0|0|0|Sack eng am Körper.~Rumpf fest.~Aufrecht bleiben.
functional|bw|la ab|sh tri|overhead|Explosive Kraft|||0|0|0|Hochstrecken, dann mit ganzem Körper abwerfen.~Knie beugen.~Ball schnell wieder greifen.
calisthenics|sec|fo|la|hang|Griffkraft||3 × 20 s|0|0|0|Schultern aktiv.~Nicht ruckartig loslassen.~Kurze Intervalle.
drill|sec|sh ch|ab qu|jumpRope|Kondition, Koordination||5 × 2 min|0|0|0|Hände oben, Kinn runter.~Schläge aus der Hüfte.~Leichte Beinarbeit.
drill|sec|sh ch|ab tri|jumpRope|Schlagkraft||5 × 3 min|0|0|0|Handgelenk gerade.~Aus Beinen und Hüfte schlagen.~Sack mit Rumpfspannung treffen.
drill|bw|qu hf|gl ab|legSwing|Beinkoordination|||0|0|0|Standbein leicht gebeugt.~Aus der Hüfte treten.~Zurück in Deckung.
drill|sec|ca qu|ab|jumpRope|Beweglichkeit||3 × 1 min|0|0|0|Leicht auf den Fußballen.~Gewicht zwischen den Beinen.~Blick nach vorn.
functional|sec|sh ab|qu gl|plank|Ganzkörper||3 × 20 m|0|0|0|Hüfte tief, Rücken gerade.~Gegenarm-Gegenbein.~Langsam und kontrolliert.
functional|sec|qu gl|la ab|squat|Berufsfitness||3 × 2 min|0|0|0|Immer mit sauberer Technik.~Dosiert starten.~Auf Atmung achten.
functional|sec|la bi|fo ab|pullup|Zugkraft||4 × 1 min|0|0|0|Hüfte nah an der Wand.~Mit Beinen drücken.~Griffe sicher greifen.
cardio|sec|gl qu|ca ha|run|Beschleunigung||8 × 15 s|0|0|0|Körper leicht vorgelehnt.~Hohes Knie.~Vollgas nach oben, locker zurückgehen.
cardio|sec|qu gl|ca|walk|Beine, Kondition||6 × 30 s|0|0|0|Ganzen Fuß aufsetzen.~Aufrecht bleiben.~Beim Absteigen langsam.
plyo|bw|qu gl|ca ab|squat|Beweglichkeit|||0|0|0|Weich landen.~Blick nach vorn.~Mit niedrigen Hindernissen beginnen.
calisthenics|bw|la ch|tri bi ab|pullup|Ganzkörper|||0|0|0|Mit Aufwärmen beginnen.~Sauber vor viel.~Stange sicher greifen.
cardio|sec|qu gl|ca ha|walk|Ausdauer||60 min|0|0|0|Fester Schritt.~Stöcke einsetzen.~Auf Untergrund achten.
cardio|sec|la sh|ab bi|row|Oberkörper-Ausdauer||20 min|0|0|0|Aus dem Rumpf rotieren.~Rücken lang.~Gleichmäßiger Schlag.
cardio|sec|qu gl la|tri sh|kneeRaise|Ganzkörper||20 min|0|0|0|Rhythmisch.~Stockeinsatz mit dem Körper.~Aufrecht.
mobility|sec|lb|ab|childPose|Beweglichkeit|back|2 × 40 s|40|0|0|Atmung bestimmt das Tempo.~Spüren statt kämpfen.~Nie in Schmerz ziehen.
mobility|sec|ab|lb gl|hollowHold|Beweglichkeit|back|2 × 40 s|40|0|0|Rumpf aktiv.~Langsam und fließend.~Atmung koordinieren.
mobility|sec|ne|tr|neckTilt|Dehnung|neck|2 × 30 s pro Seite|30|1|0|Schulter bleibt tief.~Sehr sanft.~Kein Wippen.
mobility|sec|sh|tr|crossBody|Dehnung|shoulder|2 × 30 s pro Seite|30|1|0|Schulter nicht hochziehen.~Sanft ziehen.~Ruhig atmen.
mobility|sec|ch|sh|chestStretch|Dehnung|shoulder|2 × 30 s pro Seite|30|1|0|Brust öffnen.~Rippen unten.~Ruhig atmen.
mobility|sec|tri|sh|wallSlide|Dehnung|shoulder|2 × 30 s pro Seite|30|1|0|Rücken gerade.~Sanft.~Atmen.
mobility|sec|lb la|tr|childPose|Dehnung|back|2 × 30 s pro Seite|30|1|0|Nie in Schmerz.~Atmung führt.~Ruhig bleiben.
mobility|sec|hf gl|ad|hipStretch|Dehnung|hip|2 × 30 s pro Seite|30|1|0|Becken neutral.~Nicht ins Hohlkreuz.~Atmen.
mobility|sec|qu|hf|quadStretch|Dehnung|legs|2 × 30 s pro Seite|30|1|0|Becken aufrecht.~Sanft.~Atmen.
mobility|sec|ca|ha|calfWall|Dehnung|ankle|2 × 30 s pro Seite|30|1|0|Ferse bleibt am Boden.~Fuß gerade.~Atmen.
mobility|sec|ca|ha|kneeWall|Dehnung|ankle|2 × 30 s pro Seite|30|1|0|Ferse am Boden.~Knie folgt dem Fuß.~Langsam.
mobility|sec|fo|tri|wristRock|Dehnung|wrist|2 × 30 s|30|0|0|Sanft.~Nie ruckartig.~Hände schütteln zwischendurch.
mobility|sec|qu ha gl|la ca|idle|Dehnung|legs|2 × 45 s pro Seite|45|1|0|Langsam rollen.~Auf Druckpunkten kurz verweilen.~Nie auf Gelenken.
mobility|sec|sh tr|la|wallSlide|Dehnung|shoulder|2 × 40 s|40|0|0|Leicht und kontrolliert.~Schultern tief.~Nacken locker.
mobility|sec|gl lb|ab|bridge|Dehnung|back|2 × 30 s|30|0|0|Sehr kontrolliert.~Schmerzfrei bleiben.~Qualität vor Menge.
"""#

    static let rows = #"""
Bankdrücken (Langhantel)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Bankdrücken (Langhantel, Schrägbank 30°)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Bankdrücken (Langhantel, Schrägbank 45°)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Bankdrücken (Langhantel, Negativbank)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Bankdrücken (Langhantel, enger Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Langhantel, breiter Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Langhantel, neutraler Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Langhantel, Schrägbank 30°, enger Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Langhantel, Schrägbank 30°, breiter Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Langhantel, Schrägbank 30°, neutraler Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Langhantel, Schrägbank 45°, enger Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Langhantel, Schrägbank 45°, breiter Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Langhantel, Schrägbank 45°, neutraler Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Langhantel, Negativbank, enger Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Langhantel, Negativbank, breiter Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Langhantel, Negativbank, neutraler Griff)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Langhantel, Pause unten (2 s))|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Bankdrücken (Langhantel, langsames Tempo (4-1-1))|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Bankdrücken (Langhantel, explosiv heben)|0|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Bankdrücken (Kurzhantel)|0|dumbbell|Gewichtsangabe pro Hantel eintragen.
Bankdrücken (Kurzhantel, Schrägbank 30°)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Bankdrücken (Kurzhantel, Schrägbank 45°)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Bankdrücken (Kurzhantel, Negativbank)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Bankdrücken (Kurzhantel, enger Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Kurzhantel, breiter Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Kurzhantel, neutraler Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Kurzhantel, Schrägbank 30°, enger Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Kurzhantel, Schrägbank 30°, breiter Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Kurzhantel, Schrägbank 30°, neutraler Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Kurzhantel, Schrägbank 45°, enger Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Kurzhantel, Schrägbank 45°, breiter Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Kurzhantel, Schrägbank 45°, neutraler Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Kurzhantel, Negativbank, enger Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Kurzhantel, Negativbank, breiter Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Kurzhantel, Negativbank, neutraler Griff)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Kurzhantel, Pause unten (2 s))|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Bankdrücken (Kurzhantel, langsames Tempo (4-1-1))|0|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Bankdrücken (Kurzhantel, explosiv heben)|0|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Bankdrücken (Multipresse)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Bankdrücken (Multipresse, Schrägbank 30°)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Bankdrücken (Multipresse, Schrägbank 45°)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Bankdrücken (Multipresse, Negativbank)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Bankdrücken (Multipresse, enger Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Multipresse, breiter Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Multipresse, neutraler Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Multipresse, Schrägbank 30°, enger Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Multipresse, Schrägbank 30°, breiter Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Multipresse, Schrägbank 30°, neutraler Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Multipresse, Schrägbank 45°, enger Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Multipresse, Schrägbank 45°, breiter Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Multipresse, Schrägbank 45°, neutraler Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Multipresse, Negativbank, enger Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Enger Griff verlagert Arbeit auf Trizeps und innere Brust.
Bankdrücken (Multipresse, Negativbank, breiter Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Breiter Griff: Stange nicht tiefer als zur Brust, Schultern schützen.
Bankdrücken (Multipresse, Negativbank, neutraler Griff)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Handflächen zeigen zueinander, schont die Schultern.
Bankdrücken (Multipresse, Pause unten (2 s))|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Bankdrücken (Multipresse, langsames Tempo (4-1-1))|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Bankdrücken (Multipresse, explosiv heben)|0|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Brustpresse (Maschine)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Brustpresse (Maschine, Schräg aufwärts)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe von unten nach oben: mehr obere Brust.
Brustpresse (Maschine, Schräg abwärts)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe von oben nach unten: mehr untere Brust.
Brustpresse (Maschine, flache Position)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe auf Brusthöhe.
Brustpresse (Maschine, einarmig)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Maschine, Schräg aufwärts, einarmig)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe von unten nach oben: mehr obere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Maschine, Schräg abwärts, einarmig)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe von oben nach unten: mehr untere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Maschine, flache Position, einarmig)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Griffe auf Brusthöhe. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Maschine, Pause unten (2 s))|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Brustpresse (Maschine, langsames Tempo (4-1-1))|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Brustpresse (Maschine, explosiv heben)|1|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Brustpresse (Kabelzug)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Brustpresse (Kabelzug, Schräg aufwärts)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe von unten nach oben: mehr obere Brust.
Brustpresse (Kabelzug, Schräg abwärts)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe von oben nach unten: mehr untere Brust.
Brustpresse (Kabelzug, flache Position)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe auf Brusthöhe.
Brustpresse (Kabelzug, einarmig)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Kabelzug, Schräg aufwärts, einarmig)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe von unten nach oben: mehr obere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Kabelzug, Schräg abwärts, einarmig)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe von oben nach unten: mehr untere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Kabelzug, flache Position, einarmig)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Griffe auf Brusthöhe. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Kabelzug, Pause unten (2 s))|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Brustpresse (Kabelzug, langsames Tempo (4-1-1))|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Brustpresse (Kabelzug, explosiv heben)|1|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Brustpresse (Widerstandsband)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Brustpresse (Widerstandsband, Schräg aufwärts)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe von unten nach oben: mehr obere Brust.
Brustpresse (Widerstandsband, Schräg abwärts)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe von oben nach unten: mehr untere Brust.
Brustpresse (Widerstandsband, flache Position)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe auf Brusthöhe.
Brustpresse (Widerstandsband, einarmig)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Widerstandsband, Schräg aufwärts, einarmig)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe von unten nach oben: mehr obere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Widerstandsband, Schräg abwärts, einarmig)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe von oben nach unten: mehr untere Brust. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Widerstandsband, flache Position, einarmig)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Griffe auf Brusthöhe. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Brustpresse (Widerstandsband, Pause unten (2 s))|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Brustpresse (Widerstandsband, langsames Tempo (4-1-1))|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Brustpresse (Widerstandsband, explosiv heben)|1|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Fliegende (Kurzhantel)|2|dumbbell|Gewichtsangabe pro Hantel eintragen.
Fliegende (Kurzhantel, Schrägbank 30°)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Fliegende (Kurzhantel, Schrägbank 45°)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Fliegende (Kurzhantel, Negativbank)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Fliegende (Kurzhantel, einarmig)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Kurzhantel, Schrägbank 30°, einarmig)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Kurzhantel, Schrägbank 45°, einarmig)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Kurzhantel, Negativbank, einarmig)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Kurzhantel, Pause unten (2 s))|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Fliegende (Kurzhantel, langsames Tempo (4-1-1))|2|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Fliegende (Kurzhantel, explosiv heben)|2|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Fliegende (Maschine)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Fliegende (Maschine, Schrägbank 30°)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Fliegende (Maschine, Schrägbank 45°)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Fliegende (Maschine, Negativbank)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Fliegende (Maschine, einarmig)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Maschine, Schrägbank 30°, einarmig)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Maschine, Schrägbank 45°, einarmig)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Maschine, Negativbank, einarmig)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Maschine, Pause unten (2 s))|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Fliegende (Maschine, langsames Tempo (4-1-1))|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Fliegende (Maschine, explosiv heben)|2|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Fliegende (Widerstandsband)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Fliegende (Widerstandsband, Schrägbank 30°)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich.
Fliegende (Widerstandsband, Schrägbank 45°)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen.
Fliegende (Widerstandsband, Negativbank)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren.
Fliegende (Widerstandsband, einarmig)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Widerstandsband, Schrägbank 30°, einarmig)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank auf etwa 30 Grad: trainiert stärker den oberen Brustbereich. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Widerstandsband, Schrägbank 45°, einarmig)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank auf etwa 45 Grad: mehr Schulteranteil, Ellbogen nicht zu weit abspreizen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Widerstandsband, Negativbank, einarmig)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bank leicht fallend: betont den unteren Brustbereich, Füße sicher fixieren. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Fliegende (Widerstandsband, Pause unten (2 s))|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Fliegende (Widerstandsband, langsames Tempo (4-1-1))|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Fliegende (Widerstandsband, explosiv heben)|2|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Cable Crossover (Kabelzug)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Cable Crossover (Kabelzug, von oben nach unten)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von oben nach unten: untere und mittlere Brust.
Cable Crossover (Kabelzug, von unten nach oben)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von unten nach oben: obere Brust.
Cable Crossover (Kabelzug, auf Brusthöhe)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug auf Brusthöhe: mittlere Brust.
Cable Crossover (Kabelzug, einarmig)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen.
Cable Crossover (Kabelzug, kniend)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend, Rumpf aufrecht.
Cable Crossover (Kabelzug, im Stand mit Schritt)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Fuß vor, stabile Position.
Cable Crossover (Kabelzug, von oben nach unten, einarmig)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von oben nach unten: untere und mittlere Brust. Eine Seite nach der anderen.
Cable Crossover (Kabelzug, von oben nach unten, kniend)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von oben nach unten: untere und mittlere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Kabelzug, von oben nach unten, im Stand mit Schritt)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von oben nach unten: untere und mittlere Brust. Ein Fuß vor, stabile Position.
Cable Crossover (Kabelzug, von unten nach oben, einarmig)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von unten nach oben: obere Brust. Eine Seite nach der anderen.
Cable Crossover (Kabelzug, von unten nach oben, kniend)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von unten nach oben: obere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Kabelzug, von unten nach oben, im Stand mit Schritt)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug von unten nach oben: obere Brust. Ein Fuß vor, stabile Position.
Cable Crossover (Kabelzug, auf Brusthöhe, einarmig)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug auf Brusthöhe: mittlere Brust. Eine Seite nach der anderen.
Cable Crossover (Kabelzug, auf Brusthöhe, kniend)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug auf Brusthöhe: mittlere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Kabelzug, auf Brusthöhe, im Stand mit Schritt)|3|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zug auf Brusthöhe: mittlere Brust. Ein Fuß vor, stabile Position.
Cable Crossover (Widerstandsband)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Cable Crossover (Widerstandsband, von oben nach unten)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von oben nach unten: untere und mittlere Brust.
Cable Crossover (Widerstandsband, von unten nach oben)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von unten nach oben: obere Brust.
Cable Crossover (Widerstandsband, auf Brusthöhe)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug auf Brusthöhe: mittlere Brust.
Cable Crossover (Widerstandsband, einarmig)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen.
Cable Crossover (Widerstandsband, kniend)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kniend, Rumpf aufrecht.
Cable Crossover (Widerstandsband, im Stand mit Schritt)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Fuß vor, stabile Position.
Cable Crossover (Widerstandsband, von oben nach unten, einarmig)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von oben nach unten: untere und mittlere Brust. Eine Seite nach der anderen.
Cable Crossover (Widerstandsband, von oben nach unten, kniend)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von oben nach unten: untere und mittlere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Widerstandsband, von oben nach unten, im Stand mit Schritt)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von oben nach unten: untere und mittlere Brust. Ein Fuß vor, stabile Position.
Cable Crossover (Widerstandsband, von unten nach oben, einarmig)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von unten nach oben: obere Brust. Eine Seite nach der anderen.
Cable Crossover (Widerstandsband, von unten nach oben, kniend)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von unten nach oben: obere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Widerstandsband, von unten nach oben, im Stand mit Schritt)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug von unten nach oben: obere Brust. Ein Fuß vor, stabile Position.
Cable Crossover (Widerstandsband, auf Brusthöhe, einarmig)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug auf Brusthöhe: mittlere Brust. Eine Seite nach der anderen.
Cable Crossover (Widerstandsband, auf Brusthöhe, kniend)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug auf Brusthöhe: mittlere Brust. Kniend, Rumpf aufrecht.
Cable Crossover (Widerstandsband, auf Brusthöhe, im Stand mit Schritt)|3|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zug auf Brusthöhe: mittlere Brust. Ein Fuß vor, stabile Position.
Liegestütze (Körpergewicht)|4|none|
Liegestütze (Körpergewicht, breite Hände)|4|none|Hände weiter als schulterbreit: mehr Brust.
Liegestütze (Körpergewicht, enge Hände)|4|none|Hände eng unter der Brust: mehr Trizeps.
Liegestütze (Körpergewicht, Diamant)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps.
Liegestütze (Körpergewicht, Hände versetzt)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln.
Liegestütze (Körpergewicht, Fäuste)|4|none|Auf den Fäusten: Handgelenke gerade halten.
Liegestütze (Körpergewicht, Fingerspitzen)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken.
Liegestütze (Körpergewicht, Füße erhöht)|4|none|Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, Hände erhöht)|4|none|Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, auf den Knien)|4|none|Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, an der Wand)|4|none|An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, mit Pause unten)|4|none|Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, langsam (4-1-1))|4|none|4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, breite Hände, Füße erhöht)|4|none|Hände weiter als schulterbreit: mehr Brust. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, breite Hände, Hände erhöht)|4|none|Hände weiter als schulterbreit: mehr Brust. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, breite Hände, auf den Knien)|4|none|Hände weiter als schulterbreit: mehr Brust. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, breite Hände, an der Wand)|4|none|Hände weiter als schulterbreit: mehr Brust. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, breite Hände, mit Pause unten)|4|none|Hände weiter als schulterbreit: mehr Brust. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, breite Hände, langsam (4-1-1))|4|none|Hände weiter als schulterbreit: mehr Brust. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, enge Hände, Füße erhöht)|4|none|Hände eng unter der Brust: mehr Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, enge Hände, Hände erhöht)|4|none|Hände eng unter der Brust: mehr Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, enge Hände, auf den Knien)|4|none|Hände eng unter der Brust: mehr Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, enge Hände, an der Wand)|4|none|Hände eng unter der Brust: mehr Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, enge Hände, mit Pause unten)|4|none|Hände eng unter der Brust: mehr Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, enge Hände, langsam (4-1-1))|4|none|Hände eng unter der Brust: mehr Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, Diamant, Füße erhöht)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, Diamant, Hände erhöht)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, Diamant, auf den Knien)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, Diamant, an der Wand)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, Diamant, mit Pause unten)|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, Diamant, langsam (4-1-1))|4|none|Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, Hände versetzt, Füße erhöht)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, Hände versetzt, Hände erhöht)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, Hände versetzt, auf den Knien)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, Hände versetzt, an der Wand)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, Hände versetzt, mit Pause unten)|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, Hände versetzt, langsam (4-1-1))|4|none|Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, Fäuste, Füße erhöht)|4|none|Auf den Fäusten: Handgelenke gerade halten. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, Fäuste, Hände erhöht)|4|none|Auf den Fäusten: Handgelenke gerade halten. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, Fäuste, auf den Knien)|4|none|Auf den Fäusten: Handgelenke gerade halten. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, Fäuste, an der Wand)|4|none|Auf den Fäusten: Handgelenke gerade halten. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, Fäuste, mit Pause unten)|4|none|Auf den Fäusten: Handgelenke gerade halten. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, Fäuste, langsam (4-1-1))|4|none|Auf den Fäusten: Handgelenke gerade halten. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Körpergewicht, Fingerspitzen, Füße erhöht)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Körpergewicht, Fingerspitzen, Hände erhöht)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Körpergewicht, Fingerspitzen, auf den Knien)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Körpergewicht, Fingerspitzen, an der Wand)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Körpergewicht, Fingerspitzen, mit Pause unten)|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Körpergewicht, Fingerspitzen, langsam (4-1-1))|4|none|Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Liegestütze (Schlingentrainer, breite Hände)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust.
Liegestütze (Schlingentrainer, enge Hände)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps.
Liegestütze (Schlingentrainer, Diamant)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps.
Liegestütze (Schlingentrainer, Hände versetzt)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln.
Liegestütze (Schlingentrainer, Fäuste)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten.
Liegestütze (Schlingentrainer, Fingerspitzen)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken.
Liegestütze (Schlingentrainer, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, breite Hände, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, breite Hände, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, breite Hände, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, breite Hände, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, breite Hände, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, breite Hände, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände weiter als schulterbreit: mehr Brust. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, enge Hände, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, enge Hände, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, enge Hände, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, enge Hände, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, enge Hände, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, enge Hände, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände eng unter der Brust: mehr Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, Diamant, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, Diamant, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, Diamant, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, Diamant, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, Diamant, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, Diamant, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, Hände versetzt, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, Hände versetzt, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, Hände versetzt, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, Hände versetzt, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, Hände versetzt, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, Hände versetzt, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, Fäuste, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, Fäuste, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, Fäuste, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, Fäuste, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, Fäuste, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, Fäuste, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fäusten: Handgelenke gerade halten. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Schlingentrainer, Fingerspitzen, Füße erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Schlingentrainer, Fingerspitzen, Hände erhöht)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Schlingentrainer, Fingerspitzen, auf den Knien)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Schlingentrainer, Fingerspitzen, an der Wand)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Schlingentrainer, Fingerspitzen, mit Pause unten)|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Schlingentrainer, Fingerspitzen, langsam (4-1-1))|4|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Liegestütze (Widerstandsband, breite Hände)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust.
Liegestütze (Widerstandsband, enge Hände)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps.
Liegestütze (Widerstandsband, Diamant)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps.
Liegestütze (Widerstandsband, Hände versetzt)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln.
Liegestütze (Widerstandsband, Fäuste)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten.
Liegestütze (Widerstandsband, Fingerspitzen)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken.
Liegestütze (Widerstandsband, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, breite Hände, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, breite Hände, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, breite Hände, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, breite Hände, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, breite Hände, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, breite Hände, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände weiter als schulterbreit: mehr Brust. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, enge Hände, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, enge Hände, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, enge Hände, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, enge Hände, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, enge Hände, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, enge Hände, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände eng unter der Brust: mehr Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, Diamant, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, Diamant, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, Diamant, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, Diamant, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, Diamant, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, Diamant, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Daumen und Zeigefinger bilden ein Dreieck: sehr viel Trizeps. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, Hände versetzt, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, Hände versetzt, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, Hände versetzt, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, Hände versetzt, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, Hände versetzt, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, Hände versetzt, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand weiter vorn: ungleiche Belastung, Seiten wechseln. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, Fäuste, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, Fäuste, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, Fäuste, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, Fäuste, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, Fäuste, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, Fäuste, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fäusten: Handgelenke gerade halten. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze (Widerstandsband, Fingerspitzen, Füße erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Füße auf einer Bank: mehr Schulter und obere Brust.
Liegestütze (Widerstandsband, Fingerspitzen, Hände erhöht)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Hände auf einer Bank: leichter, gut für Einsteiger.
Liegestütze (Widerstandsband, Fingerspitzen, auf den Knien)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Auf den Knien: leichter, Körper bleibt gerade.
Liegestütze (Widerstandsband, Fingerspitzen, an der Wand)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. An der Wand: sehr leicht, für den Einstieg.
Liegestütze (Widerstandsband, Fingerspitzen, mit Pause unten)|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. Unten 2 Sekunden Pause ohne abzulegen.
Liegestütze (Widerstandsband, Fingerspitzen, langsam (4-1-1))|4|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Fingerspitzen: stärkt die Finger, nur mit gesunden Handgelenken. 4 Sekunden absenken, 1 halten, 1 drücken.
Liegestütze explosiv (Körpergewicht)|5|none|
Liegestütze explosiv (Körpergewicht, klatschen)|5|none|In der Luft klatschen, früh genug bremsen.
Liegestütze explosiv (Körpergewicht, Hände auf Bank)|5|none|Hände auf einer Bank: weniger Last.
Liegestütze explosiv (Körpergewicht, Hände wechseln)|5|none|Hände von Kasten zu Kasten springen.
Liegestütze explosiv (Körpergewicht, seitlich versetzt)|5|none|Hände springen nach links und rechts.
Dips (Stange)|6|bar|
Dips (Stange, Brust-Variante (vorgeneigt))|6|bar|Oberkörper nach vorn, Ellbogen etwas weiter außen.
Dips (Stange, Trizeps-Variante (aufrecht))|6|bar|Oberkörper aufrecht, Ellbogen eng am Körper.
Dips (Stange, mit Zusatzgewicht)|6|bar|Zusatzgewicht an Gürtel, nur bei sauberer Technik.
Dips (Stange, Negativ (5 s absenken))|6|bar|Langsam absenken, hochspringen oder helfen lassen.
Dips (Stange, Pause unten (2 s))|6|bar|Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Dips (Stange, langsames Tempo (4-1-1))|6|bar|4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Dips (Stange, explosiv heben)|6|bar|Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Dips (Ringe)|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Dips (Ringe, Brust-Variante (vorgeneigt))|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Oberkörper nach vorn, Ellbogen etwas weiter außen.
Dips (Ringe, Trizeps-Variante (aufrecht))|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Oberkörper aufrecht, Ellbogen eng am Körper.
Dips (Ringe, mit Zusatzgewicht)|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Zusatzgewicht an Gürtel, nur bei sauberer Technik.
Dips (Ringe, Negativ (5 s absenken))|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Langsam absenken, hochspringen oder helfen lassen.
Dips (Ringe, Pause unten (2 s))|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Dips (Ringe, langsames Tempo (4-1-1))|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Dips (Ringe, explosiv heben)|6|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Dips (Maschine)|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Dips (Maschine, Brust-Variante (vorgeneigt))|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oberkörper nach vorn, Ellbogen etwas weiter außen.
Dips (Maschine, Trizeps-Variante (aufrecht))|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oberkörper aufrecht, Ellbogen eng am Körper.
Dips (Maschine, mit Zusatzgewicht)|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zusatzgewicht an Gürtel, nur bei sauberer Technik.
Dips (Maschine, Negativ (5 s absenken))|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Langsam absenken, hochspringen oder helfen lassen.
Dips (Maschine, Pause unten (2 s))|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Dips (Maschine, langsames Tempo (4-1-1))|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Dips (Maschine, explosiv heben)|6|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Dips (Widerstandsband)|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Dips (Widerstandsband, Brust-Variante (vorgeneigt))|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oberkörper nach vorn, Ellbogen etwas weiter außen.
Dips (Widerstandsband, Trizeps-Variante (aufrecht))|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oberkörper aufrecht, Ellbogen eng am Körper.
Dips (Widerstandsband, mit Zusatzgewicht)|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zusatzgewicht an Gürtel, nur bei sauberer Technik.
Dips (Widerstandsband, Negativ (5 s absenken))|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam absenken, hochspringen oder helfen lassen.
Dips (Widerstandsband, Pause unten (2 s))|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Dips (Widerstandsband, langsames Tempo (4-1-1))|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Dips (Widerstandsband, explosiv heben)|6|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Bank-Dips (Bank)|7|none|Eine stabile Bank oder Kiste verwenden.
Bank-Dips (Bank, Beine gestreckt)|7|none|Eine stabile Bank oder Kiste verwenden. Gestreckte Beine machen es schwerer.
Bank-Dips (Bank, Beine gebeugt)|7|none|Eine stabile Bank oder Kiste verwenden. Gebeugte Knie sind leichter.
Bank-Dips (Bank, Füße erhöht)|7|none|Eine stabile Bank oder Kiste verwenden. Füße auf einer zweiten Bank: deutlich schwerer.
Bank-Dips (Bank, einbeinig)|7|none|Eine stabile Bank oder Kiste verwenden. Ein Bein angehoben: Rumpf stabil halten.
Pullover (Kurzhantel)|8|dumbbell|Gewichtsangabe pro Hantel eintragen.
Pullover (Kurzhantel, quer auf der Bank)|8|dumbbell|Gewichtsangabe pro Hantel eintragen. Quer auf der Bank: mehr Dehnung für die Brust.
Pullover (Kurzhantel, längs auf der Bank)|8|dumbbell|Gewichtsangabe pro Hantel eintragen. Längs: stabiler und für Einsteiger einfacher.
Pullover (Kurzhantel, geradarmig stehend)|8|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend am Kabel: gleichmäßiger Zug über den Weg.
Pullover (Kabelzug)|8|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Pullover (Kabelzug, quer auf der Bank)|8|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Quer auf der Bank: mehr Dehnung für die Brust.
Pullover (Kabelzug, längs auf der Bank)|8|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Längs: stabiler und für Einsteiger einfacher.
Pullover (Kabelzug, geradarmig stehend)|8|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend am Kabel: gleichmäßiger Zug über den Weg.
Pullover (Langhantel)|8|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Pullover (Langhantel, quer auf der Bank)|8|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Quer auf der Bank: mehr Dehnung für die Brust.
Pullover (Langhantel, längs auf der Bank)|8|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Längs: stabiler und für Einsteiger einfacher.
Pullover (Langhantel, geradarmig stehend)|8|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend am Kabel: gleichmäßiger Zug über den Weg.
Pullover (Maschine)|8|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Pullover (Maschine, quer auf der Bank)|8|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Quer auf der Bank: mehr Dehnung für die Brust.
Pullover (Maschine, längs auf der Bank)|8|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Längs: stabiler und für Einsteiger einfacher.
Pullover (Maschine, geradarmig stehend)|8|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend am Kabel: gleichmäßiger Zug über den Weg.
Landmine Press (Langhantel)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Landmine Press (Langhantel, einarmig)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit.
Landmine Press (Langhantel, kniend)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Kniend, Gesäß angespannt.
Landmine Press (Langhantel, halbkniend)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Halbkniend, Becken aufrecht.
Landmine Press (Langhantel, im Stand)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Stand mit festem Stand.
Landmine Press (Langhantel, einarmig, kniend)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit. Kniend, Gesäß angespannt.
Landmine Press (Langhantel, einarmig, halbkniend)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit. Halbkniend, Becken aufrecht.
Landmine Press (Langhantel, einarmig, im Stand)|9|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig und dreht nicht mit. Im Stand mit festem Stand.
Hex Press (Kurzhantel)|10|dumbbell|Gewichtsangabe pro Hantel eintragen.
Hex Press (Kurzhantel, Flachbank)|10|dumbbell|Gewichtsangabe pro Hantel eintragen. Flach liegend.
Hex Press (Kurzhantel, Schrägbank 30°)|10|dumbbell|Gewichtsangabe pro Hantel eintragen. Schräg: obere Brust.
Hex Press (Kurzhantel, im Stehen)|10|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Stehen mit Körperspannung.
Hex Press (Hantelscheibe)|10|barbell|Scheibe mit beiden Händen fest greifen.
Hex Press (Hantelscheibe, Flachbank)|10|barbell|Scheibe mit beiden Händen fest greifen. Flach liegend.
Hex Press (Hantelscheibe, Schrägbank 30°)|10|barbell|Scheibe mit beiden Händen fest greifen. Schräg: obere Brust.
Hex Press (Hantelscheibe, im Stehen)|10|barbell|Scheibe mit beiden Händen fest greifen. Im Stehen mit Körperspannung.
Isometrischer Brust-Squeeze|11|none|
Isometrischer Brust-Squeeze (im Stand)|11|none|Im Stand.
Isometrischer Brust-Squeeze (im Sitzen)|11|none|Im Sitzen.
Isometrischer Brust-Squeeze (kniend)|11|none|Kniend.
Isometrischer Brust-Squeeze (Medizinball)|11|medball|Ball nach Technik wählen, lieber leicht und sauber.
Isometrischer Brust-Squeeze (Medizinball, im Stand)|11|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Stand.
Isometrischer Brust-Squeeze (Medizinball, im Sitzen)|11|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sitzen.
Isometrischer Brust-Squeeze (Medizinball, kniend)|11|medball|Ball nach Technik wählen, lieber leicht und sauber. Kniend.
Klimmzüge (Stange)|12|bar|
Klimmzüge (Stange, Obergriff schulterbreit)|12|bar|Obergriff etwa schulterbreit.
Klimmzüge (Stange, Obergriff weit)|12|bar|Weiter Griff: mehr Latissimus, kürzerer Weg.
Klimmzüge (Stange, Untergriff (Chin-up))|12|bar|Untergriff: mehr Bizeps, Ellbogen nah am Körper.
Klimmzüge (Stange, neutraler Griff)|12|bar|Handflächen zueinander: schont Schultern und Ellbogen.
Klimmzüge (Stange, enger Griff)|12|bar|Enger Griff: mehr Bizepsanteil.
Klimmzüge (Stange, Wechselgriff)|12|bar|Eine Hand Ober-, eine Untergriff, Seiten wechseln.
Klimmzüge (Stange, mit Zusatzgewicht)|12|bar|Zusatzgewicht an Gürtel.
Klimmzüge (Stange, Negativ (5 s ablassen))|12|bar|Langsam absenken.
Klimmzüge (Stange, mit Pause oben (2 s))|12|bar|Oben 2 Sekunden halten.
Klimmzüge (Stange, strikt (ohne Schwung))|12|bar|Strikt ohne Schwung.
Klimmzüge (Stange, Obergriff schulterbreit, mit Zusatzgewicht)|12|bar|Obergriff etwa schulterbreit. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, Obergriff schulterbreit, Negativ (5 s ablassen))|12|bar|Obergriff etwa schulterbreit. Langsam absenken.
Klimmzüge (Stange, Obergriff schulterbreit, mit Pause oben (2 s))|12|bar|Obergriff etwa schulterbreit. Oben 2 Sekunden halten.
Klimmzüge (Stange, Obergriff schulterbreit, strikt (ohne Schwung))|12|bar|Obergriff etwa schulterbreit. Strikt ohne Schwung.
Klimmzüge (Stange, Obergriff weit, mit Zusatzgewicht)|12|bar|Weiter Griff: mehr Latissimus, kürzerer Weg. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, Obergriff weit, Negativ (5 s ablassen))|12|bar|Weiter Griff: mehr Latissimus, kürzerer Weg. Langsam absenken.
Klimmzüge (Stange, Obergriff weit, mit Pause oben (2 s))|12|bar|Weiter Griff: mehr Latissimus, kürzerer Weg. Oben 2 Sekunden halten.
Klimmzüge (Stange, Obergriff weit, strikt (ohne Schwung))|12|bar|Weiter Griff: mehr Latissimus, kürzerer Weg. Strikt ohne Schwung.
Klimmzüge (Stange, Untergriff (Chin-up), mit Zusatzgewicht)|12|bar|Untergriff: mehr Bizeps, Ellbogen nah am Körper. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, Untergriff (Chin-up), Negativ (5 s ablassen))|12|bar|Untergriff: mehr Bizeps, Ellbogen nah am Körper. Langsam absenken.
Klimmzüge (Stange, Untergriff (Chin-up), mit Pause oben (2 s))|12|bar|Untergriff: mehr Bizeps, Ellbogen nah am Körper. Oben 2 Sekunden halten.
Klimmzüge (Stange, Untergriff (Chin-up), strikt (ohne Schwung))|12|bar|Untergriff: mehr Bizeps, Ellbogen nah am Körper. Strikt ohne Schwung.
Klimmzüge (Stange, neutraler Griff, mit Zusatzgewicht)|12|bar|Handflächen zueinander: schont Schultern und Ellbogen. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, neutraler Griff, Negativ (5 s ablassen))|12|bar|Handflächen zueinander: schont Schultern und Ellbogen. Langsam absenken.
Klimmzüge (Stange, neutraler Griff, mit Pause oben (2 s))|12|bar|Handflächen zueinander: schont Schultern und Ellbogen. Oben 2 Sekunden halten.
Klimmzüge (Stange, neutraler Griff, strikt (ohne Schwung))|12|bar|Handflächen zueinander: schont Schultern und Ellbogen. Strikt ohne Schwung.
Klimmzüge (Stange, enger Griff, mit Zusatzgewicht)|12|bar|Enger Griff: mehr Bizepsanteil. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, enger Griff, Negativ (5 s ablassen))|12|bar|Enger Griff: mehr Bizepsanteil. Langsam absenken.
Klimmzüge (Stange, enger Griff, mit Pause oben (2 s))|12|bar|Enger Griff: mehr Bizepsanteil. Oben 2 Sekunden halten.
Klimmzüge (Stange, enger Griff, strikt (ohne Schwung))|12|bar|Enger Griff: mehr Bizepsanteil. Strikt ohne Schwung.
Klimmzüge (Stange, Wechselgriff, mit Zusatzgewicht)|12|bar|Eine Hand Ober-, eine Untergriff, Seiten wechseln. Zusatzgewicht an Gürtel.
Klimmzüge (Stange, Wechselgriff, Negativ (5 s ablassen))|12|bar|Eine Hand Ober-, eine Untergriff, Seiten wechseln. Langsam absenken.
Klimmzüge (Stange, Wechselgriff, mit Pause oben (2 s))|12|bar|Eine Hand Ober-, eine Untergriff, Seiten wechseln. Oben 2 Sekunden halten.
Klimmzüge (Stange, Wechselgriff, strikt (ohne Schwung))|12|bar|Eine Hand Ober-, eine Untergriff, Seiten wechseln. Strikt ohne Schwung.
Klimmzüge (Ringe)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Klimmzüge (Ringe, Obergriff schulterbreit)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff etwa schulterbreit.
Klimmzüge (Ringe, Obergriff weit)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Weiter Griff: mehr Latissimus, kürzerer Weg.
Klimmzüge (Ringe, Untergriff (Chin-up))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff: mehr Bizeps, Ellbogen nah am Körper.
Klimmzüge (Ringe, neutraler Griff)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handflächen zueinander: schont Schultern und Ellbogen.
Klimmzüge (Ringe, enger Griff)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enger Griff: mehr Bizepsanteil.
Klimmzüge (Ringe, Wechselgriff)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand Ober-, eine Untergriff, Seiten wechseln.
Klimmzüge (Ringe, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Langsam absenken.
Klimmzüge (Ringe, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Oben 2 Sekunden halten.
Klimmzüge (Ringe, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Strikt ohne Schwung.
Klimmzüge (Ringe, Obergriff schulterbreit, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff etwa schulterbreit. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, Obergriff schulterbreit, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff etwa schulterbreit. Langsam absenken.
Klimmzüge (Ringe, Obergriff schulterbreit, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff etwa schulterbreit. Oben 2 Sekunden halten.
Klimmzüge (Ringe, Obergriff schulterbreit, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff etwa schulterbreit. Strikt ohne Schwung.
Klimmzüge (Ringe, Obergriff weit, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Weiter Griff: mehr Latissimus, kürzerer Weg. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, Obergriff weit, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Weiter Griff: mehr Latissimus, kürzerer Weg. Langsam absenken.
Klimmzüge (Ringe, Obergriff weit, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Weiter Griff: mehr Latissimus, kürzerer Weg. Oben 2 Sekunden halten.
Klimmzüge (Ringe, Obergriff weit, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Weiter Griff: mehr Latissimus, kürzerer Weg. Strikt ohne Schwung.
Klimmzüge (Ringe, Untergriff (Chin-up), mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, Untergriff (Chin-up), Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Langsam absenken.
Klimmzüge (Ringe, Untergriff (Chin-up), mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Oben 2 Sekunden halten.
Klimmzüge (Ringe, Untergriff (Chin-up), strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Strikt ohne Schwung.
Klimmzüge (Ringe, neutraler Griff, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handflächen zueinander: schont Schultern und Ellbogen. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, neutraler Griff, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handflächen zueinander: schont Schultern und Ellbogen. Langsam absenken.
Klimmzüge (Ringe, neutraler Griff, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handflächen zueinander: schont Schultern und Ellbogen. Oben 2 Sekunden halten.
Klimmzüge (Ringe, neutraler Griff, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handflächen zueinander: schont Schultern und Ellbogen. Strikt ohne Schwung.
Klimmzüge (Ringe, enger Griff, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enger Griff: mehr Bizepsanteil. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, enger Griff, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enger Griff: mehr Bizepsanteil. Langsam absenken.
Klimmzüge (Ringe, enger Griff, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enger Griff: mehr Bizepsanteil. Oben 2 Sekunden halten.
Klimmzüge (Ringe, enger Griff, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enger Griff: mehr Bizepsanteil. Strikt ohne Schwung.
Klimmzüge (Ringe, Wechselgriff, mit Zusatzgewicht)|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Zusatzgewicht an Gürtel.
Klimmzüge (Ringe, Wechselgriff, Negativ (5 s ablassen))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Langsam absenken.
Klimmzüge (Ringe, Wechselgriff, mit Pause oben (2 s))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Oben 2 Sekunden halten.
Klimmzüge (Ringe, Wechselgriff, strikt (ohne Schwung))|12|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Strikt ohne Schwung.
Klimmzüge (Widerstandsband)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Klimmzüge (Widerstandsband, Obergriff schulterbreit)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff etwa schulterbreit.
Klimmzüge (Widerstandsband, Obergriff weit)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Weiter Griff: mehr Latissimus, kürzerer Weg.
Klimmzüge (Widerstandsband, Untergriff (Chin-up))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Bizeps, Ellbogen nah am Körper.
Klimmzüge (Widerstandsband, neutraler Griff)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont Schultern und Ellbogen.
Klimmzüge (Widerstandsband, enger Griff)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff: mehr Bizepsanteil.
Klimmzüge (Widerstandsband, Wechselgriff)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand Ober-, eine Untergriff, Seiten wechseln.
Klimmzüge (Widerstandsband, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam absenken.
Klimmzüge (Widerstandsband, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, Obergriff schulterbreit, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff etwa schulterbreit. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, Obergriff schulterbreit, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff etwa schulterbreit. Langsam absenken.
Klimmzüge (Widerstandsband, Obergriff schulterbreit, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff etwa schulterbreit. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, Obergriff schulterbreit, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff etwa schulterbreit. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, Obergriff weit, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Weiter Griff: mehr Latissimus, kürzerer Weg. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, Obergriff weit, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Weiter Griff: mehr Latissimus, kürzerer Weg. Langsam absenken.
Klimmzüge (Widerstandsband, Obergriff weit, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Weiter Griff: mehr Latissimus, kürzerer Weg. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, Obergriff weit, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Weiter Griff: mehr Latissimus, kürzerer Weg. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, Untergriff (Chin-up), mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, Untergriff (Chin-up), Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Langsam absenken.
Klimmzüge (Widerstandsband, Untergriff (Chin-up), mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, Untergriff (Chin-up), strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, neutraler Griff, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont Schultern und Ellbogen. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, neutraler Griff, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont Schultern und Ellbogen. Langsam absenken.
Klimmzüge (Widerstandsband, neutraler Griff, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont Schultern und Ellbogen. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, neutraler Griff, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont Schultern und Ellbogen. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, enger Griff, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff: mehr Bizepsanteil. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, enger Griff, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff: mehr Bizepsanteil. Langsam absenken.
Klimmzüge (Widerstandsband, enger Griff, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff: mehr Bizepsanteil. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, enger Griff, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff: mehr Bizepsanteil. Strikt ohne Schwung.
Klimmzüge (Widerstandsband, Wechselgriff, mit Zusatzgewicht)|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Zusatzgewicht an Gürtel.
Klimmzüge (Widerstandsband, Wechselgriff, Negativ (5 s ablassen))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Langsam absenken.
Klimmzüge (Widerstandsband, Wechselgriff, mit Pause oben (2 s))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Oben 2 Sekunden halten.
Klimmzüge (Widerstandsband, Wechselgriff, strikt (ohne Schwung))|12|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Strikt ohne Schwung.
Klimmzüge (Maschine)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Klimmzüge (Maschine, Obergriff schulterbreit)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff etwa schulterbreit.
Klimmzüge (Maschine, Obergriff weit)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Weiter Griff: mehr Latissimus, kürzerer Weg.
Klimmzüge (Maschine, Untergriff (Chin-up))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Bizeps, Ellbogen nah am Körper.
Klimmzüge (Maschine, neutraler Griff)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont Schultern und Ellbogen.
Klimmzüge (Maschine, enger Griff)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Griff: mehr Bizepsanteil.
Klimmzüge (Maschine, Wechselgriff)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Hand Ober-, eine Untergriff, Seiten wechseln.
Klimmzüge (Maschine, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Langsam absenken.
Klimmzüge (Maschine, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten.
Klimmzüge (Maschine, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Strikt ohne Schwung.
Klimmzüge (Maschine, Obergriff schulterbreit, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff etwa schulterbreit. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, Obergriff schulterbreit, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff etwa schulterbreit. Langsam absenken.
Klimmzüge (Maschine, Obergriff schulterbreit, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff etwa schulterbreit. Oben 2 Sekunden halten.
Klimmzüge (Maschine, Obergriff schulterbreit, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff etwa schulterbreit. Strikt ohne Schwung.
Klimmzüge (Maschine, Obergriff weit, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Weiter Griff: mehr Latissimus, kürzerer Weg. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, Obergriff weit, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Weiter Griff: mehr Latissimus, kürzerer Weg. Langsam absenken.
Klimmzüge (Maschine, Obergriff weit, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Weiter Griff: mehr Latissimus, kürzerer Weg. Oben 2 Sekunden halten.
Klimmzüge (Maschine, Obergriff weit, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Weiter Griff: mehr Latissimus, kürzerer Weg. Strikt ohne Schwung.
Klimmzüge (Maschine, Untergriff (Chin-up), mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, Untergriff (Chin-up), Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Langsam absenken.
Klimmzüge (Maschine, Untergriff (Chin-up), mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Oben 2 Sekunden halten.
Klimmzüge (Maschine, Untergriff (Chin-up), strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Bizeps, Ellbogen nah am Körper. Strikt ohne Schwung.
Klimmzüge (Maschine, neutraler Griff, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont Schultern und Ellbogen. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, neutraler Griff, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont Schultern und Ellbogen. Langsam absenken.
Klimmzüge (Maschine, neutraler Griff, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont Schultern und Ellbogen. Oben 2 Sekunden halten.
Klimmzüge (Maschine, neutraler Griff, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont Schultern und Ellbogen. Strikt ohne Schwung.
Klimmzüge (Maschine, enger Griff, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Griff: mehr Bizepsanteil. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, enger Griff, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Griff: mehr Bizepsanteil. Langsam absenken.
Klimmzüge (Maschine, enger Griff, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Griff: mehr Bizepsanteil. Oben 2 Sekunden halten.
Klimmzüge (Maschine, enger Griff, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Griff: mehr Bizepsanteil. Strikt ohne Schwung.
Klimmzüge (Maschine, Wechselgriff, mit Zusatzgewicht)|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Zusatzgewicht an Gürtel.
Klimmzüge (Maschine, Wechselgriff, Negativ (5 s ablassen))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Langsam absenken.
Klimmzüge (Maschine, Wechselgriff, mit Pause oben (2 s))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Oben 2 Sekunden halten.
Klimmzüge (Maschine, Wechselgriff, strikt (ohne Schwung))|12|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Hand Ober-, eine Untergriff, Seiten wechseln. Strikt ohne Schwung.
Latziehen (Kabelzug)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Latziehen (Kabelzug, breiter Obergriff)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: Latissimus außen.
Latziehen (Kabelzug, enger Untergriff)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Untergriff: Bizeps mehr beteiligt.
Latziehen (Kabelzug, neutraler enger Griff)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte.
Latziehen (Kabelzug, Wechselgriff)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel.
Latziehen (Kabelzug, einarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen.
Latziehen (Kabelzug, kniend)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend an hohem Zug.
Latziehen (Kabelzug, geradarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme gestreckt, Latissimus isoliert.
Latziehen (Kabelzug, breiter Obergriff, einarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: Latissimus außen. Eine Seite nach der anderen.
Latziehen (Kabelzug, breiter Obergriff, kniend)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: Latissimus außen. Kniend an hohem Zug.
Latziehen (Kabelzug, breiter Obergriff, geradarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: Latissimus außen. Arme gestreckt, Latissimus isoliert.
Latziehen (Kabelzug, enger Untergriff, einarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Untergriff: Bizeps mehr beteiligt. Eine Seite nach der anderen.
Latziehen (Kabelzug, enger Untergriff, kniend)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Untergriff: Bizeps mehr beteiligt. Kniend an hohem Zug.
Latziehen (Kabelzug, enger Untergriff, geradarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Untergriff: Bizeps mehr beteiligt. Arme gestreckt, Latissimus isoliert.
Latziehen (Kabelzug, neutraler enger Griff, einarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen.
Latziehen (Kabelzug, neutraler enger Griff, kniend)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte. Kniend an hohem Zug.
Latziehen (Kabelzug, neutraler enger Griff, geradarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte. Arme gestreckt, Latissimus isoliert.
Latziehen (Kabelzug, Wechselgriff, einarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel. Eine Seite nach der anderen.
Latziehen (Kabelzug, Wechselgriff, kniend)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel. Kniend an hohem Zug.
Latziehen (Kabelzug, Wechselgriff, geradarmig)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel. Arme gestreckt, Latissimus isoliert.
Latziehen (Kabelzug, Pause unten (2 s))|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Latziehen (Kabelzug, langsames Tempo (4-1-1))|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Latziehen (Kabelzug, explosiv heben)|13|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Latziehen (Maschine)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Latziehen (Maschine, breiter Obergriff)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: Latissimus außen.
Latziehen (Maschine, enger Untergriff)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Untergriff: Bizeps mehr beteiligt.
Latziehen (Maschine, neutraler enger Griff)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte.
Latziehen (Maschine, Wechselgriff)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel.
Latziehen (Maschine, einarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen.
Latziehen (Maschine, kniend)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kniend an hohem Zug.
Latziehen (Maschine, geradarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme gestreckt, Latissimus isoliert.
Latziehen (Maschine, breiter Obergriff, einarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: Latissimus außen. Eine Seite nach der anderen.
Latziehen (Maschine, breiter Obergriff, kniend)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: Latissimus außen. Kniend an hohem Zug.
Latziehen (Maschine, breiter Obergriff, geradarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: Latissimus außen. Arme gestreckt, Latissimus isoliert.
Latziehen (Maschine, enger Untergriff, einarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Untergriff: Bizeps mehr beteiligt. Eine Seite nach der anderen.
Latziehen (Maschine, enger Untergriff, kniend)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Untergriff: Bizeps mehr beteiligt. Kniend an hohem Zug.
Latziehen (Maschine, enger Untergriff, geradarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Enger Untergriff: Bizeps mehr beteiligt. Arme gestreckt, Latissimus isoliert.
Latziehen (Maschine, neutraler enger Griff, einarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen.
Latziehen (Maschine, neutraler enger Griff, kniend)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte. Kniend an hohem Zug.
Latziehen (Maschine, neutraler enger Griff, geradarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte. Arme gestreckt, Latissimus isoliert.
Latziehen (Maschine, Wechselgriff, einarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel. Eine Seite nach der anderen.
Latziehen (Maschine, Wechselgriff, kniend)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel. Kniend an hohem Zug.
Latziehen (Maschine, Wechselgriff, geradarmig)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel. Arme gestreckt, Latissimus isoliert.
Latziehen (Maschine, Pause unten (2 s))|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Latziehen (Maschine, langsames Tempo (4-1-1))|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Latziehen (Maschine, explosiv heben)|13|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Latziehen (Widerstandsband)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Latziehen (Widerstandsband, breiter Obergriff)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: Latissimus außen.
Latziehen (Widerstandsband, enger Untergriff)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Untergriff: Bizeps mehr beteiligt.
Latziehen (Widerstandsband, neutraler enger Griff)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte.
Latziehen (Widerstandsband, Wechselgriff)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel.
Latziehen (Widerstandsband, einarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen.
Latziehen (Widerstandsband, kniend)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kniend an hohem Zug.
Latziehen (Widerstandsband, geradarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme gestreckt, Latissimus isoliert.
Latziehen (Widerstandsband, breiter Obergriff, einarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: Latissimus außen. Eine Seite nach der anderen.
Latziehen (Widerstandsband, breiter Obergriff, kniend)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: Latissimus außen. Kniend an hohem Zug.
Latziehen (Widerstandsband, breiter Obergriff, geradarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: Latissimus außen. Arme gestreckt, Latissimus isoliert.
Latziehen (Widerstandsband, enger Untergriff, einarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Untergriff: Bizeps mehr beteiligt. Eine Seite nach der anderen.
Latziehen (Widerstandsband, enger Untergriff, kniend)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Untergriff: Bizeps mehr beteiligt. Kniend an hohem Zug.
Latziehen (Widerstandsband, enger Untergriff, geradarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Untergriff: Bizeps mehr beteiligt. Arme gestreckt, Latissimus isoliert.
Latziehen (Widerstandsband, neutraler enger Griff, einarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen.
Latziehen (Widerstandsband, neutraler enger Griff, kniend)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte. Kniend an hohem Zug.
Latziehen (Widerstandsband, neutraler enger Griff, geradarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte. Arme gestreckt, Latissimus isoliert.
Latziehen (Widerstandsband, Wechselgriff, einarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel. Eine Seite nach der anderen.
Latziehen (Widerstandsband, Wechselgriff, kniend)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel. Kniend an hohem Zug.
Latziehen (Widerstandsband, Wechselgriff, geradarmig)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel. Arme gestreckt, Latissimus isoliert.
Latziehen (Widerstandsband, Pause unten (2 s))|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Latziehen (Widerstandsband, langsames Tempo (4-1-1))|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Latziehen (Widerstandsband, explosiv heben)|13|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Rudern (Langhantel)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Rudern (Langhantel, Obergriff)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff: mehr oberer Rücken.
Rudern (Langhantel, Untergriff)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Untergriff: mehr Latissimus und Bizeps.
Rudern (Langhantel, Pendlay (Stange vom Boden))|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht.
Rudern (Langhantel, Brust abgestützt)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Brust auf Schrägbank abgestützt: Rücken entlastet.
Rudern (Langhantel, einarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Langhantel, beidarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beide Arme gleichzeitig.
Rudern (Langhantel, Obergriff, einarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff: mehr oberer Rücken. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Langhantel, Obergriff, beidarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff: mehr oberer Rücken. Beide Arme gleichzeitig.
Rudern (Langhantel, Untergriff, einarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Untergriff: mehr Latissimus und Bizeps. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Langhantel, Untergriff, beidarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Untergriff: mehr Latissimus und Bizeps. Beide Arme gleichzeitig.
Rudern (Langhantel, Pendlay (Stange vom Boden), einarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Langhantel, Pendlay (Stange vom Boden), beidarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Beide Arme gleichzeitig.
Rudern (Langhantel, Brust abgestützt, einarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Brust auf Schrägbank abgestützt: Rücken entlastet. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Langhantel, Brust abgestützt, beidarmig)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Brust auf Schrägbank abgestützt: Rücken entlastet. Beide Arme gleichzeitig.
Rudern (Langhantel, Pause unten (2 s))|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Rudern (Langhantel, langsames Tempo (4-1-1))|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Rudern (Langhantel, explosiv heben)|14|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Rudern (Kurzhantel)|14|dumbbell|Gewichtsangabe pro Hantel eintragen.
Rudern (Kurzhantel, Obergriff)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff: mehr oberer Rücken.
Rudern (Kurzhantel, Untergriff)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff: mehr Latissimus und Bizeps.
Rudern (Kurzhantel, Pendlay (Stange vom Boden))|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht.
Rudern (Kurzhantel, Brust abgestützt)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust auf Schrägbank abgestützt: Rücken entlastet.
Rudern (Kurzhantel, einarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Kurzhantel, beidarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Arme gleichzeitig.
Rudern (Kurzhantel, Obergriff, einarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff: mehr oberer Rücken. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Kurzhantel, Obergriff, beidarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff: mehr oberer Rücken. Beide Arme gleichzeitig.
Rudern (Kurzhantel, Untergriff, einarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff: mehr Latissimus und Bizeps. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Kurzhantel, Untergriff, beidarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff: mehr Latissimus und Bizeps. Beide Arme gleichzeitig.
Rudern (Kurzhantel, Pendlay (Stange vom Boden), einarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Kurzhantel, Pendlay (Stange vom Boden), beidarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Beide Arme gleichzeitig.
Rudern (Kurzhantel, Brust abgestützt, einarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust auf Schrägbank abgestützt: Rücken entlastet. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Kurzhantel, Brust abgestützt, beidarmig)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust auf Schrägbank abgestützt: Rücken entlastet. Beide Arme gleichzeitig.
Rudern (Kurzhantel, Pause unten (2 s))|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Rudern (Kurzhantel, langsames Tempo (4-1-1))|14|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Rudern (Kurzhantel, explosiv heben)|14|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Rudern (SZ-Stange)|14|barbell|Der gewinkelte Griff schont die Handgelenke.
Rudern (SZ-Stange, Obergriff)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff: mehr oberer Rücken.
Rudern (SZ-Stange, Untergriff)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff: mehr Latissimus und Bizeps.
Rudern (SZ-Stange, Pendlay (Stange vom Boden))|14|barbell|Der gewinkelte Griff schont die Handgelenke. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht.
Rudern (SZ-Stange, Brust abgestützt)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Brust auf Schrägbank abgestützt: Rücken entlastet.
Rudern (SZ-Stange, einarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (SZ-Stange, beidarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Beide Arme gleichzeitig.
Rudern (SZ-Stange, Obergriff, einarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff: mehr oberer Rücken. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (SZ-Stange, Obergriff, beidarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff: mehr oberer Rücken. Beide Arme gleichzeitig.
Rudern (SZ-Stange, Untergriff, einarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff: mehr Latissimus und Bizeps. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (SZ-Stange, Untergriff, beidarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff: mehr Latissimus und Bizeps. Beide Arme gleichzeitig.
Rudern (SZ-Stange, Pendlay (Stange vom Boden), einarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (SZ-Stange, Pendlay (Stange vom Boden), beidarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Beide Arme gleichzeitig.
Rudern (SZ-Stange, Brust abgestützt, einarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Brust auf Schrägbank abgestützt: Rücken entlastet. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (SZ-Stange, Brust abgestützt, beidarmig)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Brust auf Schrägbank abgestützt: Rücken entlastet. Beide Arme gleichzeitig.
Rudern (SZ-Stange, Pause unten (2 s))|14|barbell|Der gewinkelte Griff schont die Handgelenke. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Rudern (SZ-Stange, langsames Tempo (4-1-1))|14|barbell|Der gewinkelte Griff schont die Handgelenke. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Rudern (SZ-Stange, explosiv heben)|14|barbell|Der gewinkelte Griff schont die Handgelenke. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Rudern (Multipresse)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Rudern (Multipresse, Obergriff)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Obergriff: mehr oberer Rücken.
Rudern (Multipresse, Untergriff)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Untergriff: mehr Latissimus und Bizeps.
Rudern (Multipresse, Pendlay (Stange vom Boden))|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht.
Rudern (Multipresse, Brust abgestützt)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Brust auf Schrägbank abgestützt: Rücken entlastet.
Rudern (Multipresse, einarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Multipresse, beidarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Beide Arme gleichzeitig.
Rudern (Multipresse, Obergriff, einarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Obergriff: mehr oberer Rücken. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Multipresse, Obergriff, beidarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Obergriff: mehr oberer Rücken. Beide Arme gleichzeitig.
Rudern (Multipresse, Untergriff, einarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Untergriff: mehr Latissimus und Bizeps. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Multipresse, Untergriff, beidarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Untergriff: mehr Latissimus und Bizeps. Beide Arme gleichzeitig.
Rudern (Multipresse, Pendlay (Stange vom Boden), einarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Multipresse, Pendlay (Stange vom Boden), beidarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Beide Arme gleichzeitig.
Rudern (Multipresse, Brust abgestützt, einarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Brust auf Schrägbank abgestützt: Rücken entlastet. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Multipresse, Brust abgestützt, beidarmig)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Brust auf Schrägbank abgestützt: Rücken entlastet. Beide Arme gleichzeitig.
Rudern (Multipresse, Pause unten (2 s))|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Rudern (Multipresse, langsames Tempo (4-1-1))|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Rudern (Multipresse, explosiv heben)|14|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Rudern (Trap-Bar)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Rudern (Trap-Bar, Obergriff)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Obergriff: mehr oberer Rücken.
Rudern (Trap-Bar, Untergriff)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Untergriff: mehr Latissimus und Bizeps.
Rudern (Trap-Bar, Pendlay (Stange vom Boden))|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht.
Rudern (Trap-Bar, Brust abgestützt)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Brust auf Schrägbank abgestützt: Rücken entlastet.
Rudern (Trap-Bar, einarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Trap-Bar, beidarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Beide Arme gleichzeitig.
Rudern (Trap-Bar, Obergriff, einarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Obergriff: mehr oberer Rücken. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Trap-Bar, Obergriff, beidarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Obergriff: mehr oberer Rücken. Beide Arme gleichzeitig.
Rudern (Trap-Bar, Untergriff, einarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Untergriff: mehr Latissimus und Bizeps. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Trap-Bar, Untergriff, beidarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Untergriff: mehr Latissimus und Bizeps. Beide Arme gleichzeitig.
Rudern (Trap-Bar, Pendlay (Stange vom Boden), einarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Trap-Bar, Pendlay (Stange vom Boden), beidarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Stange jede Wiederholung am Boden ablegen, Rücken waagerecht. Beide Arme gleichzeitig.
Rudern (Trap-Bar, Brust abgestützt, einarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Brust auf Schrägbank abgestützt: Rücken entlastet. Eine Seite nach der anderen, Rumpf bleibt waagerecht.
Rudern (Trap-Bar, Brust abgestützt, beidarmig)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Brust auf Schrägbank abgestützt: Rücken entlastet. Beide Arme gleichzeitig.
Rudern (Trap-Bar, Pause unten (2 s))|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Rudern (Trap-Bar, langsames Tempo (4-1-1))|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Rudern (Trap-Bar, explosiv heben)|14|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Sitzendes Rudern (Kabelzug)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Sitzendes Rudern (Kabelzug, enger Griff)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte.
Sitzendes Rudern (Kabelzug, breiter Griff)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: mehr oberer Rücken und hintere Schulter.
Sitzendes Rudern (Kabelzug, Untergriff)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr Latissimus.
Sitzendes Rudern (Kabelzug, neutraler Griff)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zeigen zueinander.
Sitzendes Rudern (Kabelzug, einarmig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Kabelzug, wechselseitig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Kabelzug, enger Griff, einarmig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Kabelzug, enger Griff, wechselseitig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Griff: Latissimus und Rückenmitte. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Kabelzug, breiter Griff, einarmig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: mehr oberer Rücken und hintere Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Kabelzug, breiter Griff, wechselseitig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Griff: mehr oberer Rücken und hintere Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Kabelzug, Untergriff, einarmig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr Latissimus. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Kabelzug, Untergriff, wechselseitig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr Latissimus. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Kabelzug, neutraler Griff, einarmig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zeigen zueinander. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Kabelzug, neutraler Griff, wechselseitig)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zeigen zueinander. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Kabelzug, Pause unten (2 s))|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Sitzendes Rudern (Kabelzug, langsames Tempo (4-1-1))|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Sitzendes Rudern (Kabelzug, explosiv heben)|15|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Sitzendes Rudern (Maschine)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Sitzendes Rudern (Maschine, enger Griff)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte.
Sitzendes Rudern (Maschine, breiter Griff)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: mehr oberer Rücken und hintere Schulter.
Sitzendes Rudern (Maschine, Untergriff)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Latissimus.
Sitzendes Rudern (Maschine, neutraler Griff)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zeigen zueinander.
Sitzendes Rudern (Maschine, einarmig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Maschine, wechselseitig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Maschine, enger Griff, einarmig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Maschine, enger Griff, wechselseitig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Griff: Latissimus und Rückenmitte. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Maschine, breiter Griff, einarmig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: mehr oberer Rücken und hintere Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Maschine, breiter Griff, wechselseitig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Griff: mehr oberer Rücken und hintere Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Maschine, Untergriff, einarmig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Latissimus. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Maschine, Untergriff, wechselseitig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr Latissimus. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Maschine, neutraler Griff, einarmig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zeigen zueinander. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Maschine, neutraler Griff, wechselseitig)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zeigen zueinander. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Maschine, Pause unten (2 s))|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Sitzendes Rudern (Maschine, langsames Tempo (4-1-1))|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Sitzendes Rudern (Maschine, explosiv heben)|15|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Sitzendes Rudern (Widerstandsband)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Sitzendes Rudern (Widerstandsband, enger Griff)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte.
Sitzendes Rudern (Widerstandsband, breiter Griff)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: mehr oberer Rücken und hintere Schulter.
Sitzendes Rudern (Widerstandsband, Untergriff)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Latissimus.
Sitzendes Rudern (Widerstandsband, neutraler Griff)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zeigen zueinander.
Sitzendes Rudern (Widerstandsband, einarmig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Widerstandsband, wechselseitig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Widerstandsband, enger Griff, einarmig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Widerstandsband, enger Griff, wechselseitig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Griff: Latissimus und Rückenmitte. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Widerstandsband, breiter Griff, einarmig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: mehr oberer Rücken und hintere Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Widerstandsband, breiter Griff, wechselseitig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Griff: mehr oberer Rücken und hintere Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Widerstandsband, Untergriff, einarmig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Latissimus. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Widerstandsband, Untergriff, wechselseitig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr Latissimus. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Widerstandsband, neutraler Griff, einarmig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zeigen zueinander. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Sitzendes Rudern (Widerstandsband, neutraler Griff, wechselseitig)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zeigen zueinander. Seiten im Wechsel, Rumpf bleibt gerade.
Sitzendes Rudern (Widerstandsband, Pause unten (2 s))|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Sitzendes Rudern (Widerstandsband, langsames Tempo (4-1-1))|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Sitzendes Rudern (Widerstandsband, explosiv heben)|15|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Gestütztes Rudern (Kurzhantel)|16|dumbbell|Gewichtsangabe pro Hantel eintragen.
Gestütztes Rudern (Kurzhantel, Ellbogen weit)|16|dumbbell|Gewichtsangabe pro Hantel eintragen. Ellbogen nach außen: mehr hinterer Schulter- und oberer Rückenanteil.
Gestütztes Rudern (Kurzhantel, Ellbogen eng)|16|dumbbell|Gewichtsangabe pro Hantel eintragen. Ellbogen am Körper: Latissimus.
Gestütztes Rudern (Kurzhantel, einarmig)|16|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen.
Gestütztes Rudern (Kurzhantel, Pause unten (2 s))|16|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Gestütztes Rudern (Kurzhantel, langsames Tempo (4-1-1))|16|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Gestütztes Rudern (Kurzhantel, explosiv heben)|16|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Gestütztes Rudern (Maschine)|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Gestütztes Rudern (Maschine, Ellbogen weit)|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ellbogen nach außen: mehr hinterer Schulter- und oberer Rückenanteil.
Gestütztes Rudern (Maschine, Ellbogen eng)|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ellbogen am Körper: Latissimus.
Gestütztes Rudern (Maschine, einarmig)|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen.
Gestütztes Rudern (Maschine, Pause unten (2 s))|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Gestütztes Rudern (Maschine, langsames Tempo (4-1-1))|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Gestütztes Rudern (Maschine, explosiv heben)|16|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Gestütztes Rudern (Langhantel)|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Gestütztes Rudern (Langhantel, Ellbogen weit)|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ellbogen nach außen: mehr hinterer Schulter- und oberer Rückenanteil.
Gestütztes Rudern (Langhantel, Ellbogen eng)|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ellbogen am Körper: Latissimus.
Gestütztes Rudern (Langhantel, einarmig)|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen.
Gestütztes Rudern (Langhantel, Pause unten (2 s))|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Gestütztes Rudern (Langhantel, langsames Tempo (4-1-1))|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Gestütztes Rudern (Langhantel, explosiv heben)|16|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Kurzhantelrudern auf der Bank (Kurzhantel)|17|dumbbell|Gewichtsangabe pro Hantel eintragen.
Kurzhantelrudern auf der Bank (Kurzhantel, Ellbogen eng)|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Eng am Körper: Latissimus.
Kurzhantelrudern auf der Bank (Kurzhantel, Ellbogen weit)|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Weit: oberer Rücken.
Kurzhantelrudern auf der Bank (Kurzhantel, mit Rotation)|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Ende leicht aufdrehen: mehr Rückenstreckung.
Kurzhantelrudern auf der Bank (Kurzhantel, Pause oben (2 s))|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten.
Kurzhantelrudern auf der Bank (Kurzhantel, Pause unten (2 s))|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Kurzhantelrudern auf der Bank (Kurzhantel, langsames Tempo (4-1-1))|17|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Kurzhantelrudern auf der Bank (Kurzhantel, explosiv heben)|17|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Kurzhantelrudern auf der Bank (Kettlebell)|17|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Kurzhantelrudern auf der Bank (Kettlebell, Ellbogen eng)|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eng am Körper: Latissimus.
Kurzhantelrudern auf der Bank (Kettlebell, Ellbogen weit)|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Weit: oberer Rücken.
Kurzhantelrudern auf der Bank (Kettlebell, mit Rotation)|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Ende leicht aufdrehen: mehr Rückenstreckung.
Kurzhantelrudern auf der Bank (Kettlebell, Pause oben (2 s))|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten.
Kurzhantelrudern auf der Bank (Kettlebell, Pause unten (2 s))|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Kurzhantelrudern auf der Bank (Kettlebell, langsames Tempo (4-1-1))|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Kurzhantelrudern auf der Bank (Kettlebell, explosiv heben)|17|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Kurzhantelrudern auf der Bank (Kabelzug)|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Kurzhantelrudern auf der Bank (Kabelzug, Ellbogen eng)|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eng am Körper: Latissimus.
Kurzhantelrudern auf der Bank (Kabelzug, Ellbogen weit)|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Weit: oberer Rücken.
Kurzhantelrudern auf der Bank (Kabelzug, mit Rotation)|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Ende leicht aufdrehen: mehr Rückenstreckung.
Kurzhantelrudern auf der Bank (Kabelzug, Pause oben (2 s))|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten.
Kurzhantelrudern auf der Bank (Kabelzug, Pause unten (2 s))|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Kurzhantelrudern auf der Bank (Kabelzug, langsames Tempo (4-1-1))|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Kurzhantelrudern auf der Bank (Kabelzug, explosiv heben)|17|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Face Pulls (Kabelzug)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Face Pulls (Kabelzug, sitzend)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Face Pulls (Kabelzug, stehend)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Face Pulls (Kabelzug, halbkniend)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Face Pulls (Kabelzug, Außenrotation am Ende)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Ende die Hände nach hinten drehen.
Face Pulls (Kabelzug, mit Pause (2 s))|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Ende 2 Sekunden halten.
Face Pulls (Kabelzug, sitzend, Außenrotation am Ende)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende die Hände nach hinten drehen.
Face Pulls (Kabelzug, sitzend, mit Pause (2 s))|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende 2 Sekunden halten.
Face Pulls (Kabelzug, stehend, Außenrotation am Ende)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende die Hände nach hinten drehen.
Face Pulls (Kabelzug, stehend, mit Pause (2 s))|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende 2 Sekunden halten.
Face Pulls (Kabelzug, halbkniend, Außenrotation am Ende)|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende die Hände nach hinten drehen.
Face Pulls (Kabelzug, halbkniend, mit Pause (2 s))|18|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende 2 Sekunden halten.
Face Pulls (Widerstandsband)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Face Pulls (Widerstandsband, sitzend)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Face Pulls (Widerstandsband, stehend)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Face Pulls (Widerstandsband, halbkniend)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Face Pulls (Widerstandsband, Außenrotation am Ende)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Ende die Hände nach hinten drehen.
Face Pulls (Widerstandsband, mit Pause (2 s))|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Ende 2 Sekunden halten.
Face Pulls (Widerstandsband, sitzend, Außenrotation am Ende)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende die Hände nach hinten drehen.
Face Pulls (Widerstandsband, sitzend, mit Pause (2 s))|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende 2 Sekunden halten.
Face Pulls (Widerstandsband, stehend, Außenrotation am Ende)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende die Hände nach hinten drehen.
Face Pulls (Widerstandsband, stehend, mit Pause (2 s))|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende 2 Sekunden halten.
Face Pulls (Widerstandsband, halbkniend, Außenrotation am Ende)|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende die Hände nach hinten drehen.
Face Pulls (Widerstandsband, halbkniend, mit Pause (2 s))|18|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende 2 Sekunden halten.
Face Pulls (Schlingentrainer)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Face Pulls (Schlingentrainer, sitzend)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Face Pulls (Schlingentrainer, stehend)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Face Pulls (Schlingentrainer, halbkniend)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Face Pulls (Schlingentrainer, Außenrotation am Ende)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Am Ende die Hände nach hinten drehen.
Face Pulls (Schlingentrainer, mit Pause (2 s))|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Am Ende 2 Sekunden halten.
Face Pulls (Schlingentrainer, sitzend, Außenrotation am Ende)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende die Hände nach hinten drehen.
Face Pulls (Schlingentrainer, sitzend, mit Pause (2 s))|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Am Ende 2 Sekunden halten.
Face Pulls (Schlingentrainer, stehend, Außenrotation am Ende)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende die Hände nach hinten drehen.
Face Pulls (Schlingentrainer, stehend, mit Pause (2 s))|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Am Ende 2 Sekunden halten.
Face Pulls (Schlingentrainer, halbkniend, Außenrotation am Ende)|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende die Hände nach hinten drehen.
Face Pulls (Schlingentrainer, halbkniend, mit Pause (2 s))|18|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität. Am Ende 2 Sekunden halten.
Schulterblatt-Klimmzug (Stange)|19|bar|
Schulterblatt-Klimmzug (Stange, Obergriff)|19|bar|Obergriff.
Schulterblatt-Klimmzug (Stange, neutral)|19|bar|Neutraler Griff.
Schulterblatt-Klimmzug (Stange, einarmig (Annäherung))|19|bar|Beide Hände, eine stärker belasten.
Schulterblatt-Klimmzug (Ringe)|19|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Schulterblatt-Klimmzug (Ringe, Obergriff)|19|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff.
Schulterblatt-Klimmzug (Ringe, neutral)|19|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Neutraler Griff.
Schulterblatt-Klimmzug (Ringe, einarmig (Annäherung))|19|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Beide Hände, eine stärker belasten.
Australian Pull-ups (Stange)|20|bar|
Australian Pull-ups (Stange, Obergriff)|20|bar|Obergriff.
Australian Pull-ups (Stange, Untergriff)|20|bar|Untergriff.
Australian Pull-ups (Stange, Füße erhöht)|20|bar|Füße auf Bank: deutlich schwerer.
Australian Pull-ups (Stange, einarmig (Annäherung))|20|bar|Eine Hand führt, die andere hilft nur wenig.
Australian Pull-ups (Schlingentrainer)|20|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Australian Pull-ups (Schlingentrainer, Obergriff)|20|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Obergriff.
Australian Pull-ups (Schlingentrainer, Untergriff)|20|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Untergriff.
Australian Pull-ups (Schlingentrainer, Füße erhöht)|20|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße auf Bank: deutlich schwerer.
Australian Pull-ups (Schlingentrainer, einarmig (Annäherung))|20|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Eine Hand führt, die andere hilft nur wenig.
Australian Pull-ups (Ringe)|20|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Australian Pull-ups (Ringe, Obergriff)|20|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff.
Australian Pull-ups (Ringe, Untergriff)|20|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff.
Australian Pull-ups (Ringe, Füße erhöht)|20|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Füße auf Bank: deutlich schwerer.
Australian Pull-ups (Ringe, einarmig (Annäherung))|20|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Hand führt, die andere hilft nur wenig.
Kreuzheben (Langhantel)|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Kreuzheben (Langhantel, konventionell)|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße hüftbreit, Griff außerhalb der Beine.
Kreuzheben (Langhantel, Sumo)|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß.
Kreuzheben (Langhantel, Deficit)|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten.
Kreuzheben (Langhantel, aus dem Block (Rack Pull))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft.
Kreuzheben (Langhantel, Pause am Knie (2 s))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Langhantel, konventionell, Pause am Knie (2 s))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße hüftbreit, Griff außerhalb der Beine. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Langhantel, Sumo, Pause am Knie (2 s))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Langhantel, Deficit, Pause am Knie (2 s))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Langhantel, aus dem Block (Rack Pull), Pause am Knie (2 s))|21|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Trap-Bar)|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Kreuzheben (Trap-Bar, konventionell)|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Füße hüftbreit, Griff außerhalb der Beine.
Kreuzheben (Trap-Bar, Sumo)|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß.
Kreuzheben (Trap-Bar, Deficit)|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten.
Kreuzheben (Trap-Bar, aus dem Block (Rack Pull))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft.
Kreuzheben (Trap-Bar, Pause am Knie (2 s))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Trap-Bar, konventionell, Pause am Knie (2 s))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Füße hüftbreit, Griff außerhalb der Beine. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Trap-Bar, Sumo, Pause am Knie (2 s))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Trap-Bar, Deficit, Pause am Knie (2 s))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Trap-Bar, aus dem Block (Rack Pull), Pause am Knie (2 s))|21|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kurzhantel)|21|dumbbell|Gewichtsangabe pro Hantel eintragen.
Kreuzheben (Kurzhantel, konventionell)|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße hüftbreit, Griff außerhalb der Beine.
Kreuzheben (Kurzhantel, Sumo)|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß.
Kreuzheben (Kurzhantel, Deficit)|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten.
Kreuzheben (Kurzhantel, aus dem Block (Rack Pull))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft.
Kreuzheben (Kurzhantel, Pause am Knie (2 s))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kurzhantel, konventionell, Pause am Knie (2 s))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße hüftbreit, Griff außerhalb der Beine. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kurzhantel, Sumo, Pause am Knie (2 s))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kurzhantel, Deficit, Pause am Knie (2 s))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kurzhantel, aus dem Block (Rack Pull), Pause am Knie (2 s))|21|dumbbell|Gewichtsangabe pro Hantel eintragen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kettlebell)|21|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Kreuzheben (Kettlebell, konventionell)|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße hüftbreit, Griff außerhalb der Beine.
Kreuzheben (Kettlebell, Sumo)|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß.
Kreuzheben (Kettlebell, Deficit)|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten.
Kreuzheben (Kettlebell, aus dem Block (Rack Pull))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft.
Kreuzheben (Kettlebell, Pause am Knie (2 s))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kettlebell, konventionell, Pause am Knie (2 s))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße hüftbreit, Griff außerhalb der Beine. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kettlebell, Sumo, Pause am Knie (2 s))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kettlebell, Deficit, Pause am Knie (2 s))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Kettlebell, aus dem Block (Rack Pull), Pause am Knie (2 s))|21|kettlebell|Gewichtsangabe der Kettlebell eintragen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Multipresse)|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Kreuzheben (Multipresse, konventionell)|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Füße hüftbreit, Griff außerhalb der Beine.
Kreuzheben (Multipresse, Sumo)|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß.
Kreuzheben (Multipresse, Deficit)|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten.
Kreuzheben (Multipresse, aus dem Block (Rack Pull))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft.
Kreuzheben (Multipresse, Pause am Knie (2 s))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Multipresse, konventionell, Pause am Knie (2 s))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Füße hüftbreit, Griff außerhalb der Beine. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Multipresse, Sumo, Pause am Knie (2 s))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Weiter Stand, Griff innen: mehr Adduktoren und Gesäß. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Multipresse, Deficit, Pause am Knie (2 s))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf Erhöhung stehen: längerer Weg, Rücken extra gerade halten. Auf Kniehöhe 2 Sekunden Pause.
Kreuzheben (Multipresse, aus dem Block (Rack Pull), Pause am Knie (2 s))|21|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Von Blöcken oder Ablagen: kürzerer Weg, Rücken und Griffkraft. Auf Kniehöhe 2 Sekunden Pause.
Rumänisches Kreuzheben (Langhantel)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Rumänisches Kreuzheben (Langhantel, einbeinig)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Langhantel, Stiff-Leg (gestreckte Beine))|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Langhantel, Deficit)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Langhantel, Pause unten (2 s))|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Langhantel, mit Rotation)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Langhantel, einbeinig, mit Rotation)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Langhantel, Stiff-Leg (gestreckte Beine), mit Rotation)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Langhantel, Deficit, mit Rotation)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Langhantel, Pause unten (2 s), mit Rotation)|22|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kurzhantel)|22|dumbbell|Gewichtsangabe pro Hantel eintragen.
Rumänisches Kreuzheben (Kurzhantel, einbeinig)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Kurzhantel, Stiff-Leg (gestreckte Beine))|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Kurzhantel, Deficit)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Kurzhantel, Pause unten (2 s))|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Kurzhantel, mit Rotation)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kurzhantel, einbeinig, mit Rotation)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kurzhantel, Stiff-Leg (gestreckte Beine), mit Rotation)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kurzhantel, Deficit, mit Rotation)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kurzhantel, Pause unten (2 s), mit Rotation)|22|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kettlebell)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Rumänisches Kreuzheben (Kettlebell, einbeinig)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Kettlebell, Stiff-Leg (gestreckte Beine))|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Kettlebell, Deficit)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Kettlebell, Pause unten (2 s))|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Kettlebell, mit Rotation)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kettlebell, einbeinig, mit Rotation)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kettlebell, Stiff-Leg (gestreckte Beine), mit Rotation)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kettlebell, Deficit, mit Rotation)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kettlebell, Pause unten (2 s), mit Rotation)|22|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Multipresse)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Rumänisches Kreuzheben (Multipresse, einbeinig)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Multipresse, Stiff-Leg (gestreckte Beine))|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Multipresse, Deficit)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Multipresse, Pause unten (2 s))|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Multipresse, mit Rotation)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Multipresse, einbeinig, mit Rotation)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Multipresse, Stiff-Leg (gestreckte Beine), mit Rotation)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Multipresse, Deficit, mit Rotation)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Multipresse, Pause unten (2 s), mit Rotation)|22|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kabelzug)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Rumänisches Kreuzheben (Kabelzug, einbeinig)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Kabelzug, Stiff-Leg (gestreckte Beine))|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Kabelzug, Deficit)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Kabelzug, Pause unten (2 s))|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Kabelzug, mit Rotation)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kabelzug, einbeinig, mit Rotation)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kabelzug, Stiff-Leg (gestreckte Beine), mit Rotation)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kabelzug, Deficit, mit Rotation)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Kabelzug, Pause unten (2 s), mit Rotation)|22|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Widerstandsband)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Rumänisches Kreuzheben (Widerstandsband, einbeinig)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Widerstandsband, Stiff-Leg (gestreckte Beine))|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Widerstandsband, Deficit)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Widerstandsband, Pause unten (2 s))|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Widerstandsband, mit Rotation)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Widerstandsband, einbeinig, mit Rotation)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Widerstandsband, Stiff-Leg (gestreckte Beine), mit Rotation)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Widerstandsband, Deficit, mit Rotation)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Widerstandsband, Pause unten (2 s), mit Rotation)|22|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Trap-Bar)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Rumänisches Kreuzheben (Trap-Bar, einbeinig)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert.
Rumänisches Kreuzheben (Trap-Bar, Stiff-Leg (gestreckte Beine))|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Fast gestreckte Beine: stärkere Dehnung.
Rumänisches Kreuzheben (Trap-Bar, Deficit)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Auf Erhöhung: mehr Weg.
Rumänisches Kreuzheben (Trap-Bar, Pause unten (2 s))|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Unten 2 Sekunden halten.
Rumänisches Kreuzheben (Trap-Bar, mit Rotation)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Trap-Bar, einbeinig, mit Rotation)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Ein Bein: Gleichgewicht und Gesäß zusätzlich gefordert. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Trap-Bar, Stiff-Leg (gestreckte Beine), mit Rotation)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Fast gestreckte Beine: stärkere Dehnung. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Trap-Bar, Deficit, mit Rotation)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Auf Erhöhung: mehr Weg. Beim Heben leicht aufdrehen.
Rumänisches Kreuzheben (Trap-Bar, Pause unten (2 s), mit Rotation)|22|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Unten 2 Sekunden halten. Beim Heben leicht aufdrehen.
Good Morning (Langhantel)|23|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Good Morning (Langhantel, sitzend)|23|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: strenge Rückenstreckung.
Good Morning (Langhantel, stehend)|23|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend.
Good Morning (Multipresse)|23|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Good Morning (Multipresse, sitzend)|23|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Sitzend: strenge Rückenstreckung.
Good Morning (Multipresse, stehend)|23|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stehend.
Good Morning (Widerstandsband)|23|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Good Morning (Widerstandsband, sitzend)|23|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: strenge Rückenstreckung.
Good Morning (Widerstandsband, stehend)|23|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Good Morning (Kurzhantel)|23|dumbbell|Gewichtsangabe pro Hantel eintragen.
Good Morning (Kurzhantel, sitzend)|23|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: strenge Rückenstreckung.
Good Morning (Kurzhantel, stehend)|23|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Hyperextension (Maschine)|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Hyperextension (Maschine, 45°)|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 45°-Bank.
Hyperextension (Maschine, 90° (römischer Stuhl))|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Waagerechte Bank.
Hyperextension (Maschine, einbeinig)|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein: mehr Gesäßarbeit.
Hyperextension (Maschine, mit Rotation)|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beim Heben aufdrehen.
Hyperextension (Maschine, Pause oben (2 s))|24|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten.
Hyperextension (Körpergewicht)|24|none|
Hyperextension (Körpergewicht, 45°)|24|none|45°-Bank.
Hyperextension (Körpergewicht, 90° (römischer Stuhl))|24|none|Waagerechte Bank.
Hyperextension (Körpergewicht, einbeinig)|24|none|Ein Bein: mehr Gesäßarbeit.
Hyperextension (Körpergewicht, mit Rotation)|24|none|Beim Heben aufdrehen.
Hyperextension (Körpergewicht, Pause oben (2 s))|24|none|Oben 2 Sekunden halten.
Hyperextension (Hantelscheibe)|24|barbell|Scheibe mit beiden Händen fest greifen.
Hyperextension (Hantelscheibe, 45°)|24|barbell|Scheibe mit beiden Händen fest greifen. 45°-Bank.
Hyperextension (Hantelscheibe, 90° (römischer Stuhl))|24|barbell|Scheibe mit beiden Händen fest greifen. Waagerechte Bank.
Hyperextension (Hantelscheibe, einbeinig)|24|barbell|Scheibe mit beiden Händen fest greifen. Ein Bein: mehr Gesäßarbeit.
Hyperextension (Hantelscheibe, mit Rotation)|24|barbell|Scheibe mit beiden Händen fest greifen. Beim Heben aufdrehen.
Hyperextension (Hantelscheibe, Pause oben (2 s))|24|barbell|Scheibe mit beiden Händen fest greifen. Oben 2 Sekunden halten.
Reverse Hyper (Maschine)|25|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Reverse Hyper (Maschine, beidbeinig)|25|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beide Beine.
Reverse Hyper (Maschine, einbeinig)|25|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Reverse Hyper (Kabelzug)|25|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Reverse Hyper (Kabelzug, beidbeinig)|25|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Beine.
Reverse Hyper (Kabelzug, einbeinig)|25|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Bein.
Reverse Hyper (Widerstandsband)|25|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Reverse Hyper (Widerstandsband, beidbeinig)|25|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Beine.
Reverse Hyper (Widerstandsband, einbeinig)|25|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Schulterblatt-Rudern (Kabelzug)|26|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Schulterblatt-Rudern (Kabelzug, sitzend)|26|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterblatt-Rudern (Kabelzug, stehend)|26|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterblatt-Rudern (Kabelzug, halbkniend)|26|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Schulterblatt-Rudern (Widerstandsband)|26|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Schulterblatt-Rudern (Widerstandsband, sitzend)|26|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterblatt-Rudern (Widerstandsband, stehend)|26|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterblatt-Rudern (Widerstandsband, halbkniend)|26|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Schulterblatt-Rudern (Schlingentrainer)|26|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Schulterblatt-Rudern (Schlingentrainer, sitzend)|26|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterblatt-Rudern (Schlingentrainer, stehend)|26|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterblatt-Rudern (Schlingentrainer, halbkniend)|26|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Schulterblatt-Rudern (Kurzhantel)|26|dumbbell|Gewichtsangabe pro Hantel eintragen.
Schulterblatt-Rudern (Kurzhantel, sitzend)|26|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterblatt-Rudern (Kurzhantel, stehend)|26|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterblatt-Rudern (Kurzhantel, halbkniend)|26|dumbbell|Gewichtsangabe pro Hantel eintragen. Halbkniend: Becken aufrichten, Gesäß anspannen für Stabilität.
Y-Heben (Kurzhantel)|27|dumbbell|Gewichtsangabe pro Hantel eintragen.
Y-Heben (Kurzhantel, auf der Schrägbank (Brust abgestützt))|27|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust abgestützt.
Y-Heben (Kurzhantel, im Stehen vorgebeugt)|27|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorgebeugt, Rücken gerade.
Y-Heben (Kurzhantel, bäuchlings am Boden)|27|dumbbell|Gewichtsangabe pro Hantel eintragen. Bäuchlings, Stirn am Boden.
Y-Heben (Widerstandsband)|27|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Y-Heben (Widerstandsband, auf der Schrägbank (Brust abgestützt))|27|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Brust abgestützt.
Y-Heben (Widerstandsband, im Stehen vorgebeugt)|27|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorgebeugt, Rücken gerade.
Y-Heben (Widerstandsband, bäuchlings am Boden)|27|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bäuchlings, Stirn am Boden.
Y-Heben (Kabelzug)|27|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Y-Heben (Kabelzug, auf der Schrägbank (Brust abgestützt))|27|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Brust abgestützt.
Y-Heben (Kabelzug, im Stehen vorgebeugt)|27|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorgebeugt, Rücken gerade.
Y-Heben (Kabelzug, bäuchlings am Boden)|27|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Bäuchlings, Stirn am Boden.
Y-Heben (Körpergewicht)|27|none|
Y-Heben (Körpergewicht, auf der Schrägbank (Brust abgestützt))|27|none|Brust abgestützt.
Y-Heben (Körpergewicht, im Stehen vorgebeugt)|27|none|Vorgebeugt, Rücken gerade.
Y-Heben (Körpergewicht, bäuchlings am Boden)|27|none|Bäuchlings, Stirn am Boden.
T-Heben (Kurzhantel)|28|dumbbell|Gewichtsangabe pro Hantel eintragen.
T-Heben (Kurzhantel, auf der Schrägbank (Brust abgestützt))|28|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust abgestützt.
T-Heben (Kurzhantel, im Stehen vorgebeugt)|28|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorgebeugt.
T-Heben (Kurzhantel, bäuchlings am Boden)|28|dumbbell|Gewichtsangabe pro Hantel eintragen. Bäuchlings.
T-Heben (Widerstandsband)|28|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
T-Heben (Widerstandsband, auf der Schrägbank (Brust abgestützt))|28|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Brust abgestützt.
T-Heben (Widerstandsband, im Stehen vorgebeugt)|28|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorgebeugt.
T-Heben (Widerstandsband, bäuchlings am Boden)|28|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bäuchlings.
T-Heben (Kabelzug)|28|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
T-Heben (Kabelzug, auf der Schrägbank (Brust abgestützt))|28|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Brust abgestützt.
T-Heben (Kabelzug, im Stehen vorgebeugt)|28|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorgebeugt.
T-Heben (Kabelzug, bäuchlings am Boden)|28|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Bäuchlings.
T-Heben (Körpergewicht)|28|none|
T-Heben (Körpergewicht, auf der Schrägbank (Brust abgestützt))|28|none|Brust abgestützt.
T-Heben (Körpergewicht, im Stehen vorgebeugt)|28|none|Vorgebeugt.
T-Heben (Körpergewicht, bäuchlings am Boden)|28|none|Bäuchlings.
Schulterheben (Shrugs) (Kurzhantel)|29|dumbbell|Gewichtsangabe pro Hantel eintragen.
Schulterheben (Shrugs) (Kurzhantel, vor dem Körper)|29|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor dem Körper.
Schulterheben (Shrugs) (Kurzhantel, hinter dem Rücken)|29|dumbbell|Gewichtsangabe pro Hantel eintragen. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Kurzhantel, mit Pause oben (2 s))|29|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Kurzhantel, einarmig)|29|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Langhantel)|29|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Schulterheben (Shrugs) (Langhantel, vor dem Körper)|29|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor dem Körper.
Schulterheben (Shrugs) (Langhantel, hinter dem Rücken)|29|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Langhantel, mit Pause oben (2 s))|29|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Langhantel, einarmig)|29|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Multipresse)|29|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Schulterheben (Shrugs) (Multipresse, vor dem Körper)|29|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vor dem Körper.
Schulterheben (Shrugs) (Multipresse, hinter dem Rücken)|29|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Multipresse, mit Pause oben (2 s))|29|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Multipresse, einarmig)|29|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Kabelzug)|29|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Schulterheben (Shrugs) (Kabelzug, vor dem Körper)|29|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor dem Körper.
Schulterheben (Shrugs) (Kabelzug, hinter dem Rücken)|29|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Kabelzug, mit Pause oben (2 s))|29|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Kabelzug, einarmig)|29|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Maschine)|29|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Schulterheben (Shrugs) (Maschine, vor dem Körper)|29|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Last vor dem Körper.
Schulterheben (Shrugs) (Maschine, hinter dem Rücken)|29|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Maschine, mit Pause oben (2 s))|29|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Maschine, einarmig)|29|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Trap-Bar)|29|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Schulterheben (Shrugs) (Trap-Bar, vor dem Körper)|29|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Last vor dem Körper.
Schulterheben (Shrugs) (Trap-Bar, hinter dem Rücken)|29|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Trap-Bar, mit Pause oben (2 s))|29|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Trap-Bar, einarmig)|29|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Eine Seite nach der anderen.
Schulterheben (Shrugs) (Widerstandsband)|29|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Schulterheben (Shrugs) (Widerstandsband, vor dem Körper)|29|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor dem Körper.
Schulterheben (Shrugs) (Widerstandsband, hinter dem Rücken)|29|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last hinter dem Rücken: mehr hinterer Trapez.
Schulterheben (Shrugs) (Widerstandsband, mit Pause oben (2 s))|29|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten.
Schulterheben (Shrugs) (Widerstandsband, einarmig)|29|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen.
Aufrechtes Rudern (Langhantel)|30|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Aufrechtes Rudern (Langhantel, enger Griff)|30|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Enger Griff: mehr Trapez.
Aufrechtes Rudern (Langhantel, weiter Griff)|30|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Weiter Griff: mehr seitliche Schulter.
Aufrechtes Rudern (SZ-Stange)|30|barbell|Der gewinkelte Griff schont die Handgelenke.
Aufrechtes Rudern (SZ-Stange, enger Griff)|30|barbell|Der gewinkelte Griff schont die Handgelenke. Enger Griff: mehr Trapez.
Aufrechtes Rudern (SZ-Stange, weiter Griff)|30|barbell|Der gewinkelte Griff schont die Handgelenke. Weiter Griff: mehr seitliche Schulter.
Aufrechtes Rudern (Kurzhantel)|30|dumbbell|Gewichtsangabe pro Hantel eintragen.
Aufrechtes Rudern (Kurzhantel, enger Griff)|30|dumbbell|Gewichtsangabe pro Hantel eintragen. Enger Griff: mehr Trapez.
Aufrechtes Rudern (Kurzhantel, weiter Griff)|30|dumbbell|Gewichtsangabe pro Hantel eintragen. Weiter Griff: mehr seitliche Schulter.
Aufrechtes Rudern (Kabelzug)|30|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Aufrechtes Rudern (Kabelzug, enger Griff)|30|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Griff: mehr Trapez.
Aufrechtes Rudern (Kabelzug, weiter Griff)|30|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Weiter Griff: mehr seitliche Schulter.
Aufrechtes Rudern (Multipresse)|30|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Aufrechtes Rudern (Multipresse, enger Griff)|30|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Enger Griff: mehr Trapez.
Aufrechtes Rudern (Multipresse, weiter Griff)|30|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Weiter Griff: mehr seitliche Schulter.
Aufrechtes Rudern (Kettlebell)|30|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Aufrechtes Rudern (Kettlebell, enger Griff)|30|kettlebell|Gewichtsangabe der Kettlebell eintragen. Enger Griff: mehr Trapez.
Aufrechtes Rudern (Kettlebell, weiter Griff)|30|kettlebell|Gewichtsangabe der Kettlebell eintragen. Weiter Griff: mehr seitliche Schulter.
Superman (Körpergewicht)|31|none|
Superman (Körpergewicht, Arme vorn)|31|none|Arme gestreckt nach vorn.
Superman (Körpergewicht, Arme am Körper)|31|none|Arme am Körper.
Superman (Körpergewicht, Arme in T)|31|none|Arme seitlich.
Superman (Körpergewicht, abwechselnd (Gegenarm/-bein))|31|none|Diagonal heben.
Superman (Körpergewicht, mit Pause (3 s))|31|none|3 Sekunden oben halten.
Schulterdrücken (Kurzhantel)|32|dumbbell|Gewichtsangabe pro Hantel eintragen.
Schulterdrücken (Kurzhantel, sitzend)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Kurzhantel, stehend)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Kurzhantel, Arnold-Variante)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Kurzhantel, neutraler Griff)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Kurzhantel, einarmig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kurzhantel, wechselseitig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kurzhantel, sitzend, einarmig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kurzhantel, sitzend, wechselseitig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kurzhantel, stehend, einarmig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kurzhantel, stehend, wechselseitig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kurzhantel, Arnold-Variante, einarmig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kurzhantel, Arnold-Variante, wechselseitig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kurzhantel, neutraler Griff, einarmig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kurzhantel, neutraler Griff, wechselseitig)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kurzhantel, Pause unten (2 s))|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Kurzhantel, langsames Tempo (4-1-1))|32|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Kurzhantel, explosiv heben)|32|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Langhantel)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Schulterdrücken (Langhantel, sitzend)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Langhantel, stehend)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Langhantel, Arnold-Variante)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Langhantel, neutraler Griff)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Langhantel, einarmig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Langhantel, wechselseitig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Langhantel, sitzend, einarmig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Langhantel, sitzend, wechselseitig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Langhantel, stehend, einarmig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Langhantel, stehend, wechselseitig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Langhantel, Arnold-Variante, einarmig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Langhantel, Arnold-Variante, wechselseitig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Langhantel, neutraler Griff, einarmig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Langhantel, neutraler Griff, wechselseitig)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Langhantel, Pause unten (2 s))|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Langhantel, langsames Tempo (4-1-1))|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Langhantel, explosiv heben)|32|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Multipresse)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Schulterdrücken (Multipresse, sitzend)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Multipresse, stehend)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Multipresse, Arnold-Variante)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Multipresse, neutraler Griff)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Multipresse, einarmig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Multipresse, wechselseitig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Multipresse, sitzend, einarmig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Multipresse, sitzend, wechselseitig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Multipresse, stehend, einarmig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Multipresse, stehend, wechselseitig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Multipresse, Arnold-Variante, einarmig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Multipresse, Arnold-Variante, wechselseitig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Multipresse, neutraler Griff, einarmig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Multipresse, neutraler Griff, wechselseitig)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Multipresse, Pause unten (2 s))|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Multipresse, langsames Tempo (4-1-1))|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Multipresse, explosiv heben)|32|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Maschine)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Schulterdrücken (Maschine, sitzend)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Maschine, stehend)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Maschine, Arnold-Variante)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Maschine, neutraler Griff)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Maschine, einarmig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Maschine, wechselseitig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Maschine, sitzend, einarmig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Maschine, sitzend, wechselseitig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Maschine, stehend, einarmig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Maschine, stehend, wechselseitig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Maschine, Arnold-Variante, einarmig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Maschine, Arnold-Variante, wechselseitig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Maschine, neutraler Griff, einarmig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Maschine, neutraler Griff, wechselseitig)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Maschine, Pause unten (2 s))|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Maschine, langsames Tempo (4-1-1))|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Maschine, explosiv heben)|32|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Kettlebell)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Schulterdrücken (Kettlebell, sitzend)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Kettlebell, stehend)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Kettlebell, Arnold-Variante)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Kettlebell, neutraler Griff)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Kettlebell, einarmig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kettlebell, wechselseitig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kettlebell, sitzend, einarmig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kettlebell, sitzend, wechselseitig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kettlebell, stehend, einarmig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kettlebell, stehend, wechselseitig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kettlebell, Arnold-Variante, einarmig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kettlebell, Arnold-Variante, wechselseitig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kettlebell, neutraler Griff, einarmig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kettlebell, neutraler Griff, wechselseitig)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kettlebell, Pause unten (2 s))|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Kettlebell, langsames Tempo (4-1-1))|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Kettlebell, explosiv heben)|32|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Kabelzug)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Schulterdrücken (Kabelzug, sitzend)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Kabelzug, stehend)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Kabelzug, Arnold-Variante)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Kabelzug, neutraler Griff)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Kabelzug, einarmig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kabelzug, wechselseitig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kabelzug, sitzend, einarmig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kabelzug, sitzend, wechselseitig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kabelzug, stehend, einarmig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kabelzug, stehend, wechselseitig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kabelzug, Arnold-Variante, einarmig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kabelzug, Arnold-Variante, wechselseitig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kabelzug, neutraler Griff, einarmig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Kabelzug, neutraler Griff, wechselseitig)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Kabelzug, Pause unten (2 s))|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Kabelzug, langsames Tempo (4-1-1))|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Kabelzug, explosiv heben)|32|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Schulterdrücken (Widerstandsband)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Schulterdrücken (Widerstandsband, sitzend)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil.
Schulterdrücken (Widerstandsband, stehend)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen.
Schulterdrücken (Widerstandsband, Arnold-Variante)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen drehen sich beim Drücken von innen nach außen.
Schulterdrücken (Widerstandsband, neutraler Griff)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont die Schulter.
Schulterdrücken (Widerstandsband, einarmig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Widerstandsband, wechselseitig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Widerstandsband, sitzend, einarmig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Widerstandsband, sitzend, wechselseitig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: Rücken am Polster, Rumpf bleibt stabil. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Widerstandsband, stehend, einarmig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Widerstandsband, stehend, wechselseitig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: Körperspannung halten, nicht ins Hohlkreuz kippen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Widerstandsband, Arnold-Variante, einarmig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen drehen sich beim Drücken von innen nach außen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Widerstandsband, Arnold-Variante, wechselseitig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen drehen sich beim Drücken von innen nach außen. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Widerstandsband, neutraler Griff, einarmig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont die Schulter. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Schulterdrücken (Widerstandsband, neutraler Griff, wechselseitig)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander: schont die Schulter. Seiten im Wechsel, Rumpf bleibt gerade.
Schulterdrücken (Widerstandsband, Pause unten (2 s))|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Schulterdrücken (Widerstandsband, langsames Tempo (4-1-1))|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Schulterdrücken (Widerstandsband, explosiv heben)|32|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Push Press (Langhantel)|33|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Push Press (Langhantel, einarmig)|33|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Push Press (Langhantel, aus dem Rack)|33|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aus dem Rack starten.
Push Press (Langhantel, einarmig, aus dem Rack)|33|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen, Rumpf bleibt ruhig. Aus dem Rack starten.
Push Press (Kurzhantel)|33|dumbbell|Gewichtsangabe pro Hantel eintragen.
Push Press (Kurzhantel, einarmig)|33|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Push Press (Kurzhantel, aus dem Rack)|33|dumbbell|Gewichtsangabe pro Hantel eintragen. Aus dem Rack starten.
Push Press (Kurzhantel, einarmig, aus dem Rack)|33|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig. Aus dem Rack starten.
Push Press (Kettlebell)|33|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Push Press (Kettlebell, einarmig)|33|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig.
Push Press (Kettlebell, aus dem Rack)|33|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aus dem Rack starten.
Push Press (Kettlebell, einarmig, aus dem Rack)|33|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite nach der anderen, Rumpf bleibt ruhig. Aus dem Rack starten.
Seitheben (Kurzhantel)|34|dumbbell|Gewichtsangabe pro Hantel eintragen.
Seitheben (Kurzhantel, stehend)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Seitheben (Kurzhantel, sitzend)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung.
Seitheben (Kurzhantel, auf der Schrägbank seitlich liegend)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich auf Schrägbank: konstante Spannung.
Seitheben (Kurzhantel, Pause oben (2 s))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten.
Seitheben (Kurzhantel, Teilwiederholungen unten)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur untere Hälfte, hohe Spannung.
Seitheben (Kurzhantel, einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Kabel von der Gegenseite.
Seitheben (Kurzhantel, stehend, einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, stehend, über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend. Kabel von der Gegenseite.
Seitheben (Kurzhantel, sitzend, einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, sitzend, über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung. Kabel von der Gegenseite.
Seitheben (Kurzhantel, auf der Schrägbank seitlich liegend, einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich auf Schrägbank: konstante Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, auf der Schrägbank seitlich liegend, über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich auf Schrägbank: konstante Spannung. Kabel von der Gegenseite.
Seitheben (Kurzhantel, Pause oben (2 s), einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, Pause oben (2 s), über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten. Kabel von der Gegenseite.
Seitheben (Kurzhantel, Teilwiederholungen unten, einarmig)|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur untere Hälfte, hohe Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kurzhantel, Teilwiederholungen unten, über Kreuz (Kabel))|34|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur untere Hälfte, hohe Spannung. Kabel von der Gegenseite.
Seitheben (Kabelzug)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Seitheben (Kabelzug, stehend)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Seitheben (Kabelzug, sitzend)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung.
Seitheben (Kabelzug, auf der Schrägbank seitlich liegend)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlich auf Schrägbank: konstante Spannung.
Seitheben (Kabelzug, Pause oben (2 s))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten.
Seitheben (Kabelzug, Teilwiederholungen unten)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Nur untere Hälfte, hohe Spannung.
Seitheben (Kabelzug, einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kabel von der Gegenseite.
Seitheben (Kabelzug, stehend, einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, stehend, über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend. Kabel von der Gegenseite.
Seitheben (Kabelzug, sitzend, einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, sitzend, über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung. Kabel von der Gegenseite.
Seitheben (Kabelzug, auf der Schrägbank seitlich liegend, einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlich auf Schrägbank: konstante Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, auf der Schrägbank seitlich liegend, über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlich auf Schrägbank: konstante Spannung. Kabel von der Gegenseite.
Seitheben (Kabelzug, Pause oben (2 s), einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, Pause oben (2 s), über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten. Kabel von der Gegenseite.
Seitheben (Kabelzug, Teilwiederholungen unten, einarmig)|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Nur untere Hälfte, hohe Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kabelzug, Teilwiederholungen unten, über Kreuz (Kabel))|34|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Nur untere Hälfte, hohe Spannung. Kabel von der Gegenseite.
Seitheben (Maschine)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Seitheben (Maschine, stehend)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Seitheben (Maschine, sitzend)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung.
Seitheben (Maschine, auf der Schrägbank seitlich liegend)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlich auf Schrägbank: konstante Spannung.
Seitheben (Maschine, Pause oben (2 s))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten.
Seitheben (Maschine, Teilwiederholungen unten)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Nur untere Hälfte, hohe Spannung.
Seitheben (Maschine, einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kabel von der Gegenseite.
Seitheben (Maschine, stehend, einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, stehend, über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend. Kabel von der Gegenseite.
Seitheben (Maschine, sitzend, einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, sitzend, über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung. Kabel von der Gegenseite.
Seitheben (Maschine, auf der Schrägbank seitlich liegend, einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlich auf Schrägbank: konstante Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, auf der Schrägbank seitlich liegend, über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlich auf Schrägbank: konstante Spannung. Kabel von der Gegenseite.
Seitheben (Maschine, Pause oben (2 s), einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, Pause oben (2 s), über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten. Kabel von der Gegenseite.
Seitheben (Maschine, Teilwiederholungen unten, einarmig)|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Nur untere Hälfte, hohe Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Maschine, Teilwiederholungen unten, über Kreuz (Kabel))|34|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Nur untere Hälfte, hohe Spannung. Kabel von der Gegenseite.
Seitheben (Widerstandsband)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Seitheben (Widerstandsband, stehend)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Seitheben (Widerstandsband, sitzend)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung.
Seitheben (Widerstandsband, auf der Schrägbank seitlich liegend)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich auf Schrägbank: konstante Spannung.
Seitheben (Widerstandsband, Pause oben (2 s))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten.
Seitheben (Widerstandsband, Teilwiederholungen unten)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur untere Hälfte, hohe Spannung.
Seitheben (Widerstandsband, einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kabel von der Gegenseite.
Seitheben (Widerstandsband, stehend, einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, stehend, über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend. Kabel von der Gegenseite.
Seitheben (Widerstandsband, sitzend, einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, sitzend, über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung. Kabel von der Gegenseite.
Seitheben (Widerstandsband, auf der Schrägbank seitlich liegend, einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich auf Schrägbank: konstante Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, auf der Schrägbank seitlich liegend, über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich auf Schrägbank: konstante Spannung. Kabel von der Gegenseite.
Seitheben (Widerstandsband, Pause oben (2 s), einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, Pause oben (2 s), über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten. Kabel von der Gegenseite.
Seitheben (Widerstandsband, Teilwiederholungen unten, einarmig)|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur untere Hälfte, hohe Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Widerstandsband, Teilwiederholungen unten, über Kreuz (Kabel))|34|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur untere Hälfte, hohe Spannung. Kabel von der Gegenseite.
Seitheben (Kettlebell)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Seitheben (Kettlebell, stehend)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend.
Seitheben (Kettlebell, sitzend)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung.
Seitheben (Kettlebell, auf der Schrägbank seitlich liegend)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich auf Schrägbank: konstante Spannung.
Seitheben (Kettlebell, Pause oben (2 s))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten.
Seitheben (Kettlebell, Teilwiederholungen unten)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur untere Hälfte, hohe Spannung.
Seitheben (Kettlebell, einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Kabel von der Gegenseite.
Seitheben (Kettlebell, stehend, einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, stehend, über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend. Kabel von der Gegenseite.
Seitheben (Kettlebell, sitzend, einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, sitzend, über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung. Kabel von der Gegenseite.
Seitheben (Kettlebell, auf der Schrägbank seitlich liegend, einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich auf Schrägbank: konstante Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, auf der Schrägbank seitlich liegend, über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich auf Schrägbank: konstante Spannung. Kabel von der Gegenseite.
Seitheben (Kettlebell, Pause oben (2 s), einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, Pause oben (2 s), über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten. Kabel von der Gegenseite.
Seitheben (Kettlebell, Teilwiederholungen unten, einarmig)|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur untere Hälfte, hohe Spannung. Eine Seite nach der anderen, andere Hand stützt.
Seitheben (Kettlebell, Teilwiederholungen unten, über Kreuz (Kabel))|34|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur untere Hälfte, hohe Spannung. Kabel von der Gegenseite.
Frontheben (Kurzhantel)|35|dumbbell|Gewichtsangabe pro Hantel eintragen.
Frontheben (Kurzhantel, beidarmig)|35|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Arme.
Frontheben (Kurzhantel, wechselseitig)|35|dumbbell|Gewichtsangabe pro Hantel eintragen. Seiten im Wechsel.
Frontheben (Kurzhantel, neutraler Griff)|35|dumbbell|Gewichtsangabe pro Hantel eintragen. Handflächen zueinander.
Frontheben (Kurzhantel, Pause oben (2 s))|35|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten.
Frontheben (Langhantel)|35|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Frontheben (Langhantel, beidarmig)|35|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beide Arme.
Frontheben (Langhantel, wechselseitig)|35|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seiten im Wechsel.
Frontheben (Langhantel, neutraler Griff)|35|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Handflächen zueinander.
Frontheben (Langhantel, Pause oben (2 s))|35|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten.
Frontheben (Kabelzug)|35|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Frontheben (Kabelzug, beidarmig)|35|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Arme.
Frontheben (Kabelzug, wechselseitig)|35|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seiten im Wechsel.
Frontheben (Kabelzug, neutraler Griff)|35|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Handflächen zueinander.
Frontheben (Kabelzug, Pause oben (2 s))|35|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten.
Frontheben (Hantelscheibe)|35|barbell|Scheibe mit beiden Händen fest greifen.
Frontheben (Hantelscheibe, beidarmig)|35|barbell|Scheibe mit beiden Händen fest greifen. Beide Arme.
Frontheben (Hantelscheibe, wechselseitig)|35|barbell|Scheibe mit beiden Händen fest greifen. Seiten im Wechsel.
Frontheben (Hantelscheibe, neutraler Griff)|35|barbell|Scheibe mit beiden Händen fest greifen. Handflächen zueinander.
Frontheben (Hantelscheibe, Pause oben (2 s))|35|barbell|Scheibe mit beiden Händen fest greifen. Oben 2 Sekunden halten.
Frontheben (Widerstandsband)|35|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Frontheben (Widerstandsband, beidarmig)|35|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Arme.
Frontheben (Widerstandsband, wechselseitig)|35|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seiten im Wechsel.
Frontheben (Widerstandsband, neutraler Griff)|35|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Handflächen zueinander.
Frontheben (Widerstandsband, Pause oben (2 s))|35|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten.
Frontheben (SZ-Stange)|35|barbell|Der gewinkelte Griff schont die Handgelenke.
Frontheben (SZ-Stange, beidarmig)|35|barbell|Der gewinkelte Griff schont die Handgelenke. Beide Arme.
Frontheben (SZ-Stange, wechselseitig)|35|barbell|Der gewinkelte Griff schont die Handgelenke. Seiten im Wechsel.
Frontheben (SZ-Stange, neutraler Griff)|35|barbell|Der gewinkelte Griff schont die Handgelenke. Handflächen zueinander.
Frontheben (SZ-Stange, Pause oben (2 s))|35|barbell|Der gewinkelte Griff schont die Handgelenke. Oben 2 Sekunden halten.
Reverse Fly (Kurzhantel)|36|dumbbell|Gewichtsangabe pro Hantel eintragen.
Reverse Fly (Kurzhantel, vorgebeugt stehend)|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorgebeugt stehend.
Reverse Fly (Kurzhantel, Brust abgestützt)|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Brust an Schrägbank.
Reverse Fly (Kurzhantel, einarmig)|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen.
Reverse Fly (Kurzhantel, sitzend vorgebeugt)|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend, Brust auf Oberschenkel.
Reverse Fly (Kurzhantel, Pause unten (2 s))|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Reverse Fly (Kurzhantel, langsames Tempo (4-1-1))|36|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Reverse Fly (Kurzhantel, explosiv heben)|36|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Reverse Fly (Kabelzug)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Reverse Fly (Kabelzug, vorgebeugt stehend)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorgebeugt stehend.
Reverse Fly (Kabelzug, Brust abgestützt)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Brust an Schrägbank.
Reverse Fly (Kabelzug, einarmig)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen.
Reverse Fly (Kabelzug, sitzend vorgebeugt)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend, Brust auf Oberschenkel.
Reverse Fly (Kabelzug, Pause unten (2 s))|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Reverse Fly (Kabelzug, langsames Tempo (4-1-1))|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Reverse Fly (Kabelzug, explosiv heben)|36|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Reverse Fly (Maschine)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Reverse Fly (Maschine, vorgebeugt stehend)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Vorgebeugt stehend.
Reverse Fly (Maschine, Brust abgestützt)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Brust an Schrägbank.
Reverse Fly (Maschine, einarmig)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen.
Reverse Fly (Maschine, sitzend vorgebeugt)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend, Brust auf Oberschenkel.
Reverse Fly (Maschine, Pause unten (2 s))|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Reverse Fly (Maschine, langsames Tempo (4-1-1))|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Reverse Fly (Maschine, explosiv heben)|36|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Reverse Fly (Widerstandsband)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Reverse Fly (Widerstandsband, vorgebeugt stehend)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorgebeugt stehend.
Reverse Fly (Widerstandsband, Brust abgestützt)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Brust an Schrägbank.
Reverse Fly (Widerstandsband, einarmig)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite nach der anderen.
Reverse Fly (Widerstandsband, sitzend vorgebeugt)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend, Brust auf Oberschenkel.
Reverse Fly (Widerstandsband, Pause unten (2 s))|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Reverse Fly (Widerstandsband, langsames Tempo (4-1-1))|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Reverse Fly (Widerstandsband, explosiv heben)|36|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Außenrotation (Kurzhantel)|37|dumbbell|Gewichtsangabe pro Hantel eintragen.
Außenrotation (Kurzhantel, im Stand)|37|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Außenrotation (Kurzhantel, seitlich liegend)|37|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlage, Ellbogen auf der Hüfte.
Außenrotation (Kurzhantel, Ellbogen 90° abgespreizt)|37|dumbbell|Gewichtsangabe pro Hantel eintragen. Ellbogen auf Schulterhöhe, Unterarm nach oben drehen.
Außenrotation (Kabelzug)|37|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Außenrotation (Kabelzug, im Stand)|37|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Außenrotation (Kabelzug, seitlich liegend)|37|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlage, Ellbogen auf der Hüfte.
Außenrotation (Kabelzug, Ellbogen 90° abgespreizt)|37|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ellbogen auf Schulterhöhe, Unterarm nach oben drehen.
Außenrotation (Widerstandsband)|37|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Außenrotation (Widerstandsband, im Stand)|37|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Außenrotation (Widerstandsband, seitlich liegend)|37|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage, Ellbogen auf der Hüfte.
Außenrotation (Widerstandsband, Ellbogen 90° abgespreizt)|37|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ellbogen auf Schulterhöhe, Unterarm nach oben drehen.
Innenrotation (Kabelzug)|38|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Innenrotation (Kabelzug, im Stand)|38|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Innenrotation (Kabelzug, liegend)|38|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Liegend.
Innenrotation (Widerstandsband)|38|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Innenrotation (Widerstandsband, im Stand)|38|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Innenrotation (Widerstandsband, liegend)|38|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Liegend.
Innenrotation (Kurzhantel)|38|dumbbell|Gewichtsangabe pro Hantel eintragen.
Innenrotation (Kurzhantel, im Stand)|38|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Innenrotation (Kurzhantel, liegend)|38|dumbbell|Gewichtsangabe pro Hantel eintragen. Liegend.
Pike Push-ups (Körpergewicht)|39|none|
Pike Push-ups (Körpergewicht, Füße erhöht)|39|none|Füße auf Bank: mehr Last.
Pike Push-ups (Körpergewicht, breite Hände)|39|none|Breite Hände.
Pike Push-ups (Körpergewicht, enge Hände)|39|none|Enge Hände.
Pike Push-ups (Körpergewicht, Diamant)|39|none|Diamant-Griff.
Pike Push-ups (Schlingentrainer)|39|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Pike Push-ups (Schlingentrainer, Füße erhöht)|39|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße auf Bank: mehr Last.
Pike Push-ups (Schlingentrainer, breite Hände)|39|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Breite Hände.
Pike Push-ups (Schlingentrainer, enge Hände)|39|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Enge Hände.
Pike Push-ups (Schlingentrainer, Diamant)|39|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Diamant-Griff.
Pike Push-ups (Ringe)|39|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Pike Push-ups (Ringe, Füße erhöht)|39|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Füße auf Bank: mehr Last.
Pike Push-ups (Ringe, breite Hände)|39|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Breite Hände.
Pike Push-ups (Ringe, enge Hände)|39|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Enge Hände.
Pike Push-ups (Ringe, Diamant)|39|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Diamant-Griff.
Handstand-Liegestütze (Körpergewicht)|40|none|
Handstand-Liegestütze (Körpergewicht, an der Wand (Bauch zur Wand))|40|none|Bauch zur Wand: bessere Linie.
Handstand-Liegestütze (Körpergewicht, an der Wand (Rücken zur Wand))|40|none|Rücken zur Wand.
Handstand-Liegestütze (Körpergewicht, Negativ)|40|none|Nur kontrolliert absenken.
Handstand-Liegestütze (Körpergewicht, auf Erhöhung)|40|none|Hände auf Parallettes.
Handstand (Körpergewicht)|41|none|
Handstand (Körpergewicht, an der Wand (Bauch zur Wand))|41|none|Bauch zur Wand.
Handstand (Körpergewicht, Rücken zur Wand)|41|none|Rücken zur Wand.
Handstand (Körpergewicht, freistehend)|41|none|Freistehend: erst nach sicherer Wandübung.
Handstand (Körpergewicht, Schulterklopfen)|41|none|Abwechselnd Hand lösen.
Bear Walk (Körpergewicht)|42|none|
Bear Walk (Körpergewicht, vorwärts)|42|none|Vorwärts.
Bear Walk (Körpergewicht, rückwärts)|42|none|Rückwärts.
Bear Walk (Körpergewicht, seitwärts)|42|none|Seitwärts.
Bear Walk (Körpergewicht, mit Pause)|42|none|Alle 4 Schritte kurz halten.
Bizeps-Curl (Kurzhantel)|43|dumbbell|Gewichtsangabe pro Hantel eintragen.
Bizeps-Curl (Kurzhantel, stehend)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Bizeps-Curl (Kurzhantel, sitzend)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung.
Bizeps-Curl (Kurzhantel, Schrägbank 45°)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Kurzhantel, abwechselnd)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme im Wechsel.
Bizeps-Curl (Kurzhantel, mit Supination (Drehung))|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Kurzhantel, Pause oben (2 s))|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten.
Bizeps-Curl (Kurzhantel, langsam absenken (4 s))|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Exzentrisch 4 Sekunden.
Bizeps-Curl (Kurzhantel, Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Neutral.
Bizeps-Curl (Kurzhantel, Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Klassisch.
Bizeps-Curl (Kurzhantel, Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff.
Bizeps-Curl (Kurzhantel, stehend, Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend. Neutral.
Bizeps-Curl (Kurzhantel, stehend, Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend. Klassisch.
Bizeps-Curl (Kurzhantel, stehend, Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend. Obergriff.
Bizeps-Curl (Kurzhantel, sitzend, Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Kurzhantel, sitzend, Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Kurzhantel, sitzend, Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Kurzhantel, Schrägbank 45°, Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Kurzhantel, Schrägbank 45°, Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Kurzhantel, Schrägbank 45°, Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Kurzhantel, abwechselnd, Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme im Wechsel. Neutral.
Bizeps-Curl (Kurzhantel, abwechselnd, Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme im Wechsel. Klassisch.
Bizeps-Curl (Kurzhantel, abwechselnd, Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme im Wechsel. Obergriff.
Bizeps-Curl (Kurzhantel, mit Supination (Drehung), Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Kurzhantel, mit Supination (Drehung), Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Kurzhantel, mit Supination (Drehung), Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Kurzhantel, Pause oben (2 s), Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Kurzhantel, Pause oben (2 s), Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Kurzhantel, Pause oben (2 s), Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Kurzhantel, langsam absenken (4 s), Hammergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Kurzhantel, langsam absenken (4 s), Untergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Kurzhantel, langsam absenken (4 s), Obergriff)|43|dumbbell|Gewichtsangabe pro Hantel eintragen. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (Langhantel)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Bizeps-Curl (Langhantel, stehend)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend.
Bizeps-Curl (Langhantel, sitzend)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: weniger Schwung.
Bizeps-Curl (Langhantel, Schrägbank 45°)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Langhantel, abwechselnd)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Arme im Wechsel.
Bizeps-Curl (Langhantel, mit Supination (Drehung))|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Langhantel, Pause oben (2 s))|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten.
Bizeps-Curl (Langhantel, langsam absenken (4 s))|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Exzentrisch 4 Sekunden.
Bizeps-Curl (Langhantel, Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Neutral.
Bizeps-Curl (Langhantel, Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Klassisch.
Bizeps-Curl (Langhantel, Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff.
Bizeps-Curl (Langhantel, stehend, Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend. Neutral.
Bizeps-Curl (Langhantel, stehend, Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend. Klassisch.
Bizeps-Curl (Langhantel, stehend, Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend. Obergriff.
Bizeps-Curl (Langhantel, sitzend, Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Langhantel, sitzend, Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Langhantel, sitzend, Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Langhantel, Schrägbank 45°, Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Langhantel, Schrägbank 45°, Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Langhantel, Schrägbank 45°, Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Langhantel, abwechselnd, Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Arme im Wechsel. Neutral.
Bizeps-Curl (Langhantel, abwechselnd, Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Arme im Wechsel. Klassisch.
Bizeps-Curl (Langhantel, abwechselnd, Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Arme im Wechsel. Obergriff.
Bizeps-Curl (Langhantel, mit Supination (Drehung), Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Langhantel, mit Supination (Drehung), Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Langhantel, mit Supination (Drehung), Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Langhantel, Pause oben (2 s), Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Langhantel, Pause oben (2 s), Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Langhantel, Pause oben (2 s), Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Langhantel, langsam absenken (4 s), Hammergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Langhantel, langsam absenken (4 s), Untergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Langhantel, langsam absenken (4 s), Obergriff)|43|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (SZ-Stange)|43|barbell|Der gewinkelte Griff schont die Handgelenke.
Bizeps-Curl (SZ-Stange, stehend)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Stehend.
Bizeps-Curl (SZ-Stange, sitzend)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Sitzend: weniger Schwung.
Bizeps-Curl (SZ-Stange, Schrägbank 45°)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (SZ-Stange, abwechselnd)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Arme im Wechsel.
Bizeps-Curl (SZ-Stange, mit Supination (Drehung))|43|barbell|Der gewinkelte Griff schont die Handgelenke. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (SZ-Stange, Pause oben (2 s))|43|barbell|Der gewinkelte Griff schont die Handgelenke. Oben 2 Sekunden halten.
Bizeps-Curl (SZ-Stange, langsam absenken (4 s))|43|barbell|Der gewinkelte Griff schont die Handgelenke. Exzentrisch 4 Sekunden.
Bizeps-Curl (SZ-Stange, Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Neutral.
Bizeps-Curl (SZ-Stange, Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Klassisch.
Bizeps-Curl (SZ-Stange, Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff.
Bizeps-Curl (SZ-Stange, stehend, Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Stehend. Neutral.
Bizeps-Curl (SZ-Stange, stehend, Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Stehend. Klassisch.
Bizeps-Curl (SZ-Stange, stehend, Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Stehend. Obergriff.
Bizeps-Curl (SZ-Stange, sitzend, Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (SZ-Stange, sitzend, Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (SZ-Stange, sitzend, Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (SZ-Stange, Schrägbank 45°, Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (SZ-Stange, Schrägbank 45°, Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (SZ-Stange, Schrägbank 45°, Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (SZ-Stange, abwechselnd, Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Arme im Wechsel. Neutral.
Bizeps-Curl (SZ-Stange, abwechselnd, Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Arme im Wechsel. Klassisch.
Bizeps-Curl (SZ-Stange, abwechselnd, Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Arme im Wechsel. Obergriff.
Bizeps-Curl (SZ-Stange, mit Supination (Drehung), Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (SZ-Stange, mit Supination (Drehung), Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (SZ-Stange, mit Supination (Drehung), Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (SZ-Stange, Pause oben (2 s), Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (SZ-Stange, Pause oben (2 s), Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (SZ-Stange, Pause oben (2 s), Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (SZ-Stange, langsam absenken (4 s), Hammergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (SZ-Stange, langsam absenken (4 s), Untergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (SZ-Stange, langsam absenken (4 s), Obergriff)|43|barbell|Der gewinkelte Griff schont die Handgelenke. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (Kabelzug)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Bizeps-Curl (Kabelzug, stehend)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Bizeps-Curl (Kabelzug, sitzend)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung.
Bizeps-Curl (Kabelzug, Schrägbank 45°)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Kabelzug, abwechselnd)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme im Wechsel.
Bizeps-Curl (Kabelzug, mit Supination (Drehung))|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Kabelzug, Pause oben (2 s))|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten.
Bizeps-Curl (Kabelzug, langsam absenken (4 s))|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Exzentrisch 4 Sekunden.
Bizeps-Curl (Kabelzug, Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Neutral.
Bizeps-Curl (Kabelzug, Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Klassisch.
Bizeps-Curl (Kabelzug, Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff.
Bizeps-Curl (Kabelzug, stehend, Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend. Neutral.
Bizeps-Curl (Kabelzug, stehend, Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend. Klassisch.
Bizeps-Curl (Kabelzug, stehend, Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend. Obergriff.
Bizeps-Curl (Kabelzug, sitzend, Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Kabelzug, sitzend, Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Kabelzug, sitzend, Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Kabelzug, Schrägbank 45°, Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Kabelzug, Schrägbank 45°, Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Kabelzug, Schrägbank 45°, Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Kabelzug, abwechselnd, Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme im Wechsel. Neutral.
Bizeps-Curl (Kabelzug, abwechselnd, Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme im Wechsel. Klassisch.
Bizeps-Curl (Kabelzug, abwechselnd, Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme im Wechsel. Obergriff.
Bizeps-Curl (Kabelzug, mit Supination (Drehung), Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Kabelzug, mit Supination (Drehung), Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Kabelzug, mit Supination (Drehung), Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Kabelzug, Pause oben (2 s), Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Kabelzug, Pause oben (2 s), Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Kabelzug, Pause oben (2 s), Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Kabelzug, langsam absenken (4 s), Hammergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Kabelzug, langsam absenken (4 s), Untergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Kabelzug, langsam absenken (4 s), Obergriff)|43|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (Maschine)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Bizeps-Curl (Maschine, stehend)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Bizeps-Curl (Maschine, sitzend)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung.
Bizeps-Curl (Maschine, Schrägbank 45°)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Maschine, abwechselnd)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme im Wechsel.
Bizeps-Curl (Maschine, mit Supination (Drehung))|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Maschine, Pause oben (2 s))|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten.
Bizeps-Curl (Maschine, langsam absenken (4 s))|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Exzentrisch 4 Sekunden.
Bizeps-Curl (Maschine, Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Neutral.
Bizeps-Curl (Maschine, Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Klassisch.
Bizeps-Curl (Maschine, Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff.
Bizeps-Curl (Maschine, stehend, Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend. Neutral.
Bizeps-Curl (Maschine, stehend, Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend. Klassisch.
Bizeps-Curl (Maschine, stehend, Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend. Obergriff.
Bizeps-Curl (Maschine, sitzend, Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Maschine, sitzend, Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Maschine, sitzend, Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Maschine, Schrägbank 45°, Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Maschine, Schrägbank 45°, Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Maschine, Schrägbank 45°, Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Maschine, abwechselnd, Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme im Wechsel. Neutral.
Bizeps-Curl (Maschine, abwechselnd, Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme im Wechsel. Klassisch.
Bizeps-Curl (Maschine, abwechselnd, Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme im Wechsel. Obergriff.
Bizeps-Curl (Maschine, mit Supination (Drehung), Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Maschine, mit Supination (Drehung), Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Maschine, mit Supination (Drehung), Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Maschine, Pause oben (2 s), Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Maschine, Pause oben (2 s), Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Maschine, Pause oben (2 s), Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Maschine, langsam absenken (4 s), Hammergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Maschine, langsam absenken (4 s), Untergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Maschine, langsam absenken (4 s), Obergriff)|43|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (Widerstandsband)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Bizeps-Curl (Widerstandsband, stehend)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Bizeps-Curl (Widerstandsband, sitzend)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung.
Bizeps-Curl (Widerstandsband, Schrägbank 45°)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Widerstandsband, abwechselnd)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme im Wechsel.
Bizeps-Curl (Widerstandsband, mit Supination (Drehung))|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Widerstandsband, Pause oben (2 s))|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten.
Bizeps-Curl (Widerstandsband, langsam absenken (4 s))|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Exzentrisch 4 Sekunden.
Bizeps-Curl (Widerstandsband, Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Neutral.
Bizeps-Curl (Widerstandsband, Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Klassisch.
Bizeps-Curl (Widerstandsband, Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff.
Bizeps-Curl (Widerstandsband, stehend, Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend. Neutral.
Bizeps-Curl (Widerstandsband, stehend, Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend. Klassisch.
Bizeps-Curl (Widerstandsband, stehend, Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend. Obergriff.
Bizeps-Curl (Widerstandsband, sitzend, Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Widerstandsband, sitzend, Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Widerstandsband, sitzend, Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Widerstandsband, Schrägbank 45°, Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Widerstandsband, Schrägbank 45°, Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Widerstandsband, Schrägbank 45°, Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Widerstandsband, abwechselnd, Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme im Wechsel. Neutral.
Bizeps-Curl (Widerstandsband, abwechselnd, Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme im Wechsel. Klassisch.
Bizeps-Curl (Widerstandsband, abwechselnd, Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme im Wechsel. Obergriff.
Bizeps-Curl (Widerstandsband, mit Supination (Drehung), Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Widerstandsband, mit Supination (Drehung), Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Widerstandsband, mit Supination (Drehung), Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Widerstandsband, Pause oben (2 s), Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Widerstandsband, Pause oben (2 s), Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Widerstandsband, Pause oben (2 s), Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Widerstandsband, langsam absenken (4 s), Hammergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Widerstandsband, langsam absenken (4 s), Untergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Widerstandsband, langsam absenken (4 s), Obergriff)|43|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Exzentrisch 4 Sekunden. Obergriff.
Bizeps-Curl (Kettlebell)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Bizeps-Curl (Kettlebell, stehend)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend.
Bizeps-Curl (Kettlebell, sitzend)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung.
Bizeps-Curl (Kettlebell, Schrägbank 45°)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf der Schrägbank: Dehnung des langen Kopfes.
Bizeps-Curl (Kettlebell, abwechselnd)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Arme im Wechsel.
Bizeps-Curl (Kettlebell, mit Supination (Drehung))|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beim Heben die Hand nach außen drehen.
Bizeps-Curl (Kettlebell, Pause oben (2 s))|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten.
Bizeps-Curl (Kettlebell, langsam absenken (4 s))|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Exzentrisch 4 Sekunden.
Bizeps-Curl (Kettlebell, Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Neutral.
Bizeps-Curl (Kettlebell, Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Klassisch.
Bizeps-Curl (Kettlebell, Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Obergriff.
Bizeps-Curl (Kettlebell, stehend, Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend. Neutral.
Bizeps-Curl (Kettlebell, stehend, Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend. Klassisch.
Bizeps-Curl (Kettlebell, stehend, Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend. Obergriff.
Bizeps-Curl (Kettlebell, sitzend, Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung. Neutral.
Bizeps-Curl (Kettlebell, sitzend, Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung. Klassisch.
Bizeps-Curl (Kettlebell, sitzend, Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: weniger Schwung. Obergriff.
Bizeps-Curl (Kettlebell, Schrägbank 45°, Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Neutral.
Bizeps-Curl (Kettlebell, Schrägbank 45°, Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Klassisch.
Bizeps-Curl (Kettlebell, Schrägbank 45°, Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf der Schrägbank: Dehnung des langen Kopfes. Obergriff.
Bizeps-Curl (Kettlebell, abwechselnd, Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Arme im Wechsel. Neutral.
Bizeps-Curl (Kettlebell, abwechselnd, Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Arme im Wechsel. Klassisch.
Bizeps-Curl (Kettlebell, abwechselnd, Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Arme im Wechsel. Obergriff.
Bizeps-Curl (Kettlebell, mit Supination (Drehung), Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beim Heben die Hand nach außen drehen. Neutral.
Bizeps-Curl (Kettlebell, mit Supination (Drehung), Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beim Heben die Hand nach außen drehen. Klassisch.
Bizeps-Curl (Kettlebell, mit Supination (Drehung), Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beim Heben die Hand nach außen drehen. Obergriff.
Bizeps-Curl (Kettlebell, Pause oben (2 s), Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten. Neutral.
Bizeps-Curl (Kettlebell, Pause oben (2 s), Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten. Klassisch.
Bizeps-Curl (Kettlebell, Pause oben (2 s), Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 2 Sekunden halten. Obergriff.
Bizeps-Curl (Kettlebell, langsam absenken (4 s), Hammergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Exzentrisch 4 Sekunden. Neutral.
Bizeps-Curl (Kettlebell, langsam absenken (4 s), Untergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Exzentrisch 4 Sekunden. Klassisch.
Bizeps-Curl (Kettlebell, langsam absenken (4 s), Obergriff)|43|kettlebell|Gewichtsangabe der Kettlebell eintragen. Exzentrisch 4 Sekunden. Obergriff.
Konzentrations-Curl (Kurzhantel)|44|dumbbell|Gewichtsangabe pro Hantel eintragen.
Konzentrations-Curl (Kurzhantel, sitzend)|44|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend.
Konzentrations-Curl (Kurzhantel, stehend vorgebeugt)|44|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorgebeugt.
Konzentrations-Curl (Kurzhantel, kniend)|44|dumbbell|Gewichtsangabe pro Hantel eintragen. Kniend.
Konzentrations-Curl (Kabelzug)|44|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Konzentrations-Curl (Kabelzug, sitzend)|44|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Konzentrations-Curl (Kabelzug, stehend vorgebeugt)|44|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorgebeugt.
Konzentrations-Curl (Kabelzug, kniend)|44|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend.
Konzentrations-Curl (Widerstandsband)|44|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Konzentrations-Curl (Widerstandsband, sitzend)|44|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Konzentrations-Curl (Widerstandsband, stehend vorgebeugt)|44|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorgebeugt.
Konzentrations-Curl (Widerstandsband, kniend)|44|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kniend.
Preacher Curl (SZ-Stange)|45|barbell|Der gewinkelte Griff schont die Handgelenke.
Preacher Curl (SZ-Stange, Untergriff)|45|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff: klassischer Bizepsreiz.
Preacher Curl (SZ-Stange, Hammergriff)|45|barbell|Der gewinkelte Griff schont die Handgelenke. Hammergriff: Brachialis und Unterarm stärker.
Preacher Curl (SZ-Stange, Obergriff (Reverse))|45|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff: Unterarm und Brachialis.
Preacher Curl (SZ-Stange, einarmig)|45|barbell|Der gewinkelte Griff schont die Handgelenke. Eine Seite nach der anderen.
Preacher Curl (Kurzhantel)|45|dumbbell|Gewichtsangabe pro Hantel eintragen.
Preacher Curl (Kurzhantel, Untergriff)|45|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff: klassischer Bizepsreiz.
Preacher Curl (Kurzhantel, Hammergriff)|45|dumbbell|Gewichtsangabe pro Hantel eintragen. Hammergriff: Brachialis und Unterarm stärker.
Preacher Curl (Kurzhantel, Obergriff (Reverse))|45|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff: Unterarm und Brachialis.
Preacher Curl (Kurzhantel, einarmig)|45|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen.
Preacher Curl (Maschine)|45|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Preacher Curl (Maschine, Untergriff)|45|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: klassischer Bizepsreiz.
Preacher Curl (Maschine, Hammergriff)|45|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Hammergriff: Brachialis und Unterarm stärker.
Preacher Curl (Maschine, Obergriff (Reverse))|45|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff: Unterarm und Brachialis.
Preacher Curl (Maschine, einarmig)|45|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite nach der anderen.
Preacher Curl (Kabelzug)|45|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Preacher Curl (Kabelzug, Untergriff)|45|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: klassischer Bizepsreiz.
Preacher Curl (Kabelzug, Hammergriff)|45|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Hammergriff: Brachialis und Unterarm stärker.
Preacher Curl (Kabelzug, Obergriff (Reverse))|45|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff: Unterarm und Brachialis.
Preacher Curl (Kabelzug, einarmig)|45|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite nach der anderen.
Preacher Curl (Langhantel)|45|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Preacher Curl (Langhantel, Untergriff)|45|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Untergriff: klassischer Bizepsreiz.
Preacher Curl (Langhantel, Hammergriff)|45|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Hammergriff: Brachialis und Unterarm stärker.
Preacher Curl (Langhantel, Obergriff (Reverse))|45|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff: Unterarm und Brachialis.
Preacher Curl (Langhantel, einarmig)|45|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite nach der anderen.
Spider Curl (Kurzhantel)|46|dumbbell|Gewichtsangabe pro Hantel eintragen.
Spider Curl (Kurzhantel, Untergriff)|46|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff.
Spider Curl (Kurzhantel, Hammergriff)|46|dumbbell|Gewichtsangabe pro Hantel eintragen. Hammergriff.
Spider Curl (Kurzhantel, einarmig)|46|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite.
Spider Curl (SZ-Stange)|46|barbell|Der gewinkelte Griff schont die Handgelenke.
Spider Curl (SZ-Stange, Untergriff)|46|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff.
Spider Curl (SZ-Stange, Hammergriff)|46|barbell|Der gewinkelte Griff schont die Handgelenke. Hammergriff.
Spider Curl (SZ-Stange, einarmig)|46|barbell|Der gewinkelte Griff schont die Handgelenke. Eine Seite.
Spider Curl (Kabelzug)|46|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Spider Curl (Kabelzug, Untergriff)|46|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff.
Spider Curl (Kabelzug, Hammergriff)|46|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Hammergriff.
Spider Curl (Kabelzug, einarmig)|46|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite.
Zottman-Curl (Kurzhantel)|47|dumbbell|Gewichtsangabe pro Hantel eintragen.
Zottman-Curl (Kurzhantel, einarmig)|47|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite nach der anderen.
Zottman-Curl (Kurzhantel, im Sitzen)|47|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend.
Bizeps-Curl am Kabel über Kopf (Kabelzug)|48|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Bizeps-Curl am Kabel über Kopf (Kabelzug, beidarmig)|48|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Arme.
Bizeps-Curl am Kabel über Kopf (Kabelzug, einarmig)|48|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite.
Bizeps-Curl am Kabel über Kopf (Widerstandsband)|48|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Bizeps-Curl am Kabel über Kopf (Widerstandsband, beidarmig)|48|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Arme.
Bizeps-Curl am Kabel über Kopf (Widerstandsband, einarmig)|48|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite.
Chin-up Negativ (Stange)|49|bar|
Chin-up Negativ (Stange, Untergriff)|49|bar|Untergriff.
Chin-up Negativ (Stange, neutral)|49|bar|Neutraler Griff.
Chin-up Negativ (Ringe)|49|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Chin-up Negativ (Ringe, Untergriff)|49|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff.
Chin-up Negativ (Ringe, neutral)|49|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Neutraler Griff.
Bizeps-Curl am Sling (Schlingentrainer)|50|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Bizeps-Curl am Sling (Schlingentrainer, flache Position)|50|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Flacher Körperwinkel.
Bizeps-Curl am Sling (Schlingentrainer, steile Position)|50|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Steiler Winkel: leichter.
Bizeps-Curl am Sling (Ringe)|50|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Bizeps-Curl am Sling (Ringe, flache Position)|50|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Flacher Körperwinkel.
Bizeps-Curl am Sling (Ringe, steile Position)|50|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Steiler Winkel: leichter.
Bizeps-Curl am Sling (Stange)|50|bar|
Bizeps-Curl am Sling (Stange, flache Position)|50|bar|Flacher Körperwinkel.
Bizeps-Curl am Sling (Stange, steile Position)|50|bar|Steiler Winkel: leichter.
Trizeps-Drücken (Kabelzug)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Trizeps-Drücken (Kabelzug, Seil)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seil: am Ende die Enden auseinanderziehen.
Trizeps-Drücken (Kabelzug, gerade Stange)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Gerade Stange.
Trizeps-Drücken (Kabelzug, V-Stange)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Stange.
Trizeps-Drücken (Kabelzug, Obergriff)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff.
Trizeps-Drücken (Kabelzug, Untergriff (Reverse))|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr medialer Kopf.
Trizeps-Drücken (Kabelzug, einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite.
Trizeps-Drücken (Kabelzug, knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend.
Trizeps-Drücken (Kabelzug, Seil, einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seil: am Ende die Enden auseinanderziehen. Eine Seite.
Trizeps-Drücken (Kabelzug, Seil, knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seil: am Ende die Enden auseinanderziehen. Kniend.
Trizeps-Drücken (Kabelzug, gerade Stange, einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Gerade Stange. Eine Seite.
Trizeps-Drücken (Kabelzug, gerade Stange, knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Gerade Stange. Kniend.
Trizeps-Drücken (Kabelzug, V-Stange, einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Stange. Eine Seite.
Trizeps-Drücken (Kabelzug, V-Stange, knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. V-Stange. Kniend.
Trizeps-Drücken (Kabelzug, Obergriff, einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff. Eine Seite.
Trizeps-Drücken (Kabelzug, Obergriff, knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff. Kniend.
Trizeps-Drücken (Kabelzug, Untergriff (Reverse), einarmig)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr medialer Kopf. Eine Seite.
Trizeps-Drücken (Kabelzug, Untergriff (Reverse), knieend)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: mehr medialer Kopf. Kniend.
Trizeps-Drücken (Kabelzug, Pause unten (2 s))|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Drücken (Kabelzug, langsames Tempo (4-1-1))|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Drücken (Kabelzug, explosiv heben)|51|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Drücken (Widerstandsband)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Trizeps-Drücken (Widerstandsband, Seil)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seil: am Ende die Enden auseinanderziehen.
Trizeps-Drücken (Widerstandsband, gerade Stange)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gerade Stange.
Trizeps-Drücken (Widerstandsband, V-Stange)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Stange.
Trizeps-Drücken (Widerstandsband, Obergriff)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff.
Trizeps-Drücken (Widerstandsband, Untergriff (Reverse))|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr medialer Kopf.
Trizeps-Drücken (Widerstandsband, einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite.
Trizeps-Drücken (Widerstandsband, knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kniend.
Trizeps-Drücken (Widerstandsband, Seil, einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seil: am Ende die Enden auseinanderziehen. Eine Seite.
Trizeps-Drücken (Widerstandsband, Seil, knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seil: am Ende die Enden auseinanderziehen. Kniend.
Trizeps-Drücken (Widerstandsband, gerade Stange, einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gerade Stange. Eine Seite.
Trizeps-Drücken (Widerstandsband, gerade Stange, knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gerade Stange. Kniend.
Trizeps-Drücken (Widerstandsband, V-Stange, einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Stange. Eine Seite.
Trizeps-Drücken (Widerstandsband, V-Stange, knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Stange. Kniend.
Trizeps-Drücken (Widerstandsband, Obergriff, einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff. Eine Seite.
Trizeps-Drücken (Widerstandsband, Obergriff, knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff. Kniend.
Trizeps-Drücken (Widerstandsband, Untergriff (Reverse), einarmig)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr medialer Kopf. Eine Seite.
Trizeps-Drücken (Widerstandsband, Untergriff (Reverse), knieend)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: mehr medialer Kopf. Kniend.
Trizeps-Drücken (Widerstandsband, Pause unten (2 s))|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Drücken (Widerstandsband, langsames Tempo (4-1-1))|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Drücken (Widerstandsband, explosiv heben)|51|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Drücken (Maschine)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Trizeps-Drücken (Maschine, Seil)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seil: am Ende die Enden auseinanderziehen.
Trizeps-Drücken (Maschine, gerade Stange)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Gerade Stange.
Trizeps-Drücken (Maschine, V-Stange)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Stange.
Trizeps-Drücken (Maschine, Obergriff)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff.
Trizeps-Drücken (Maschine, Untergriff (Reverse))|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr medialer Kopf.
Trizeps-Drücken (Maschine, einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eine Seite.
Trizeps-Drücken (Maschine, knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kniend.
Trizeps-Drücken (Maschine, Seil, einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seil: am Ende die Enden auseinanderziehen. Eine Seite.
Trizeps-Drücken (Maschine, Seil, knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seil: am Ende die Enden auseinanderziehen. Kniend.
Trizeps-Drücken (Maschine, gerade Stange, einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Gerade Stange. Eine Seite.
Trizeps-Drücken (Maschine, gerade Stange, knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Gerade Stange. Kniend.
Trizeps-Drücken (Maschine, V-Stange, einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Stange. Eine Seite.
Trizeps-Drücken (Maschine, V-Stange, knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. V-Stange. Kniend.
Trizeps-Drücken (Maschine, Obergriff, einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff. Eine Seite.
Trizeps-Drücken (Maschine, Obergriff, knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Obergriff. Kniend.
Trizeps-Drücken (Maschine, Untergriff (Reverse), einarmig)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr medialer Kopf. Eine Seite.
Trizeps-Drücken (Maschine, Untergriff (Reverse), knieend)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Untergriff: mehr medialer Kopf. Kniend.
Trizeps-Drücken (Maschine, Pause unten (2 s))|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Drücken (Maschine, langsames Tempo (4-1-1))|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Drücken (Maschine, explosiv heben)|51|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (Kurzhantel)|52|dumbbell|Gewichtsangabe pro Hantel eintragen.
Trizeps-Überkopfstrecken (Kurzhantel, stehend)|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Trizeps-Überkopfstrecken (Kurzhantel, sitzend)|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend.
Trizeps-Überkopfstrecken (Kurzhantel, einarmig)|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite.
Trizeps-Überkopfstrecken (Kurzhantel, Seil am Kabel)|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (Kurzhantel, Pause unten (2 s))|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (Kurzhantel, langsames Tempo (4-1-1))|52|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (Kurzhantel, explosiv heben)|52|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (Kabelzug)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Trizeps-Überkopfstrecken (Kabelzug, stehend)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Trizeps-Überkopfstrecken (Kabelzug, sitzend)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Trizeps-Überkopfstrecken (Kabelzug, einarmig)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite.
Trizeps-Überkopfstrecken (Kabelzug, Seil am Kabel)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (Kabelzug, Pause unten (2 s))|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (Kabelzug, langsames Tempo (4-1-1))|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (Kabelzug, explosiv heben)|52|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (SZ-Stange)|52|barbell|Der gewinkelte Griff schont die Handgelenke.
Trizeps-Überkopfstrecken (SZ-Stange, stehend)|52|barbell|Der gewinkelte Griff schont die Handgelenke. Stehend.
Trizeps-Überkopfstrecken (SZ-Stange, sitzend)|52|barbell|Der gewinkelte Griff schont die Handgelenke. Sitzend.
Trizeps-Überkopfstrecken (SZ-Stange, einarmig)|52|barbell|Der gewinkelte Griff schont die Handgelenke. Eine Seite.
Trizeps-Überkopfstrecken (SZ-Stange, Seil am Kabel)|52|barbell|Der gewinkelte Griff schont die Handgelenke. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (SZ-Stange, Pause unten (2 s))|52|barbell|Der gewinkelte Griff schont die Handgelenke. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (SZ-Stange, langsames Tempo (4-1-1))|52|barbell|Der gewinkelte Griff schont die Handgelenke. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (SZ-Stange, explosiv heben)|52|barbell|Der gewinkelte Griff schont die Handgelenke. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (Langhantel)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Trizeps-Überkopfstrecken (Langhantel, stehend)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend.
Trizeps-Überkopfstrecken (Langhantel, sitzend)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend.
Trizeps-Überkopfstrecken (Langhantel, einarmig)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite.
Trizeps-Überkopfstrecken (Langhantel, Seil am Kabel)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (Langhantel, Pause unten (2 s))|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (Langhantel, langsames Tempo (4-1-1))|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (Langhantel, explosiv heben)|52|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (Widerstandsband)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Trizeps-Überkopfstrecken (Widerstandsband, stehend)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Trizeps-Überkopfstrecken (Widerstandsband, sitzend)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Trizeps-Überkopfstrecken (Widerstandsband, einarmig)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite.
Trizeps-Überkopfstrecken (Widerstandsband, Seil am Kabel)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (Widerstandsband, Pause unten (2 s))|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (Widerstandsband, langsames Tempo (4-1-1))|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (Widerstandsband, explosiv heben)|52|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Trizeps-Überkopfstrecken (Kettlebell)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Trizeps-Überkopfstrecken (Kettlebell, stehend)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend.
Trizeps-Überkopfstrecken (Kettlebell, sitzend)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend.
Trizeps-Überkopfstrecken (Kettlebell, einarmig)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite.
Trizeps-Überkopfstrecken (Kettlebell, Seil am Kabel)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seil, Enden am Ende auseinander.
Trizeps-Überkopfstrecken (Kettlebell, Pause unten (2 s))|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Trizeps-Überkopfstrecken (Kettlebell, langsames Tempo (4-1-1))|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Trizeps-Überkopfstrecken (Kettlebell, explosiv heben)|52|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (SZ-Stange)|53|barbell|Der gewinkelte Griff schont die Handgelenke.
Skull Crushers (SZ-Stange, Flachbank)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Flach.
Skull Crushers (SZ-Stange, Schrägbank)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (SZ-Stange, Negativbank)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Negativ.
Skull Crushers (SZ-Stange, hinter den Kopf)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Zur Bank hinter den Kopf.
Skull Crushers (SZ-Stange, enger Griff)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Enger Griff.
Skull Crushers (SZ-Stange, Pause unten (2 s))|53|barbell|Der gewinkelte Griff schont die Handgelenke. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (SZ-Stange, langsames Tempo (4-1-1))|53|barbell|Der gewinkelte Griff schont die Handgelenke. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (SZ-Stange, explosiv heben)|53|barbell|Der gewinkelte Griff schont die Handgelenke. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (Kurzhantel)|53|dumbbell|Gewichtsangabe pro Hantel eintragen.
Skull Crushers (Kurzhantel, Flachbank)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Flach.
Skull Crushers (Kurzhantel, Schrägbank)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (Kurzhantel, Negativbank)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Negativ.
Skull Crushers (Kurzhantel, hinter den Kopf)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Zur Bank hinter den Kopf.
Skull Crushers (Kurzhantel, enger Griff)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Enger Griff.
Skull Crushers (Kurzhantel, Pause unten (2 s))|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (Kurzhantel, langsames Tempo (4-1-1))|53|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (Kurzhantel, explosiv heben)|53|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (Langhantel)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Skull Crushers (Langhantel, Flachbank)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Flach.
Skull Crushers (Langhantel, Schrägbank)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (Langhantel, Negativbank)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Negativ.
Skull Crushers (Langhantel, hinter den Kopf)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Zur Bank hinter den Kopf.
Skull Crushers (Langhantel, enger Griff)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Enger Griff.
Skull Crushers (Langhantel, Pause unten (2 s))|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (Langhantel, langsames Tempo (4-1-1))|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (Langhantel, explosiv heben)|53|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (Kabelzug)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Skull Crushers (Kabelzug, Flachbank)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Flach.
Skull Crushers (Kabelzug, Schrägbank)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (Kabelzug, Negativbank)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Negativ.
Skull Crushers (Kabelzug, hinter den Kopf)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zur Bank hinter den Kopf.
Skull Crushers (Kabelzug, enger Griff)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Enger Griff.
Skull Crushers (Kabelzug, Pause unten (2 s))|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (Kabelzug, langsames Tempo (4-1-1))|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (Kabelzug, explosiv heben)|53|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (Multipresse)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Skull Crushers (Multipresse, Flachbank)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Flach.
Skull Crushers (Multipresse, Schrägbank)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (Multipresse, Negativbank)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Negativ.
Skull Crushers (Multipresse, hinter den Kopf)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Zur Bank hinter den Kopf.
Skull Crushers (Multipresse, enger Griff)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Enger Griff.
Skull Crushers (Multipresse, Pause unten (2 s))|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (Multipresse, langsames Tempo (4-1-1))|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (Multipresse, explosiv heben)|53|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Skull Crushers (Widerstandsband)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Skull Crushers (Widerstandsband, Flachbank)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Flach.
Skull Crushers (Widerstandsband, Schrägbank)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schräg: mehr Dehnung des langen Kopfes.
Skull Crushers (Widerstandsband, Negativbank)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Negativ.
Skull Crushers (Widerstandsband, hinter den Kopf)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zur Bank hinter den Kopf.
Skull Crushers (Widerstandsband, enger Griff)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Griff.
Skull Crushers (Widerstandsband, Pause unten (2 s))|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Skull Crushers (Widerstandsband, langsames Tempo (4-1-1))|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Skull Crushers (Widerstandsband, explosiv heben)|53|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Kickbacks (Kurzhantel)|54|dumbbell|Gewichtsangabe pro Hantel eintragen.
Kickbacks (Kurzhantel, einarmig stehend)|54|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite, anderer Arm stützt.
Kickbacks (Kurzhantel, beidarmig)|54|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Arme.
Kickbacks (Kurzhantel, auf der Bank abgestützt)|54|dumbbell|Gewichtsangabe pro Hantel eintragen. Knie und Hand auf der Bank.
Kickbacks (Kabelzug)|54|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Kickbacks (Kabelzug, einarmig stehend)|54|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite, anderer Arm stützt.
Kickbacks (Kabelzug, beidarmig)|54|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Arme.
Kickbacks (Kabelzug, auf der Bank abgestützt)|54|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Knie und Hand auf der Bank.
Kickbacks (Widerstandsband)|54|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Kickbacks (Widerstandsband, einarmig stehend)|54|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite, anderer Arm stützt.
Kickbacks (Widerstandsband, beidarmig)|54|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Arme.
Kickbacks (Widerstandsband, auf der Bank abgestützt)|54|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie und Hand auf der Bank.
Enges Bankdrücken (Langhantel)|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Enges Bankdrücken (Langhantel, Flachbank)|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Flach.
Enges Bankdrücken (Langhantel, Schrägbank 30°)|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Schräg.
Enges Bankdrücken (Langhantel, Pause unten (2 s))|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Enges Bankdrücken (Langhantel, langsames Tempo (4-1-1))|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Enges Bankdrücken (Langhantel, explosiv heben)|55|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Enges Bankdrücken (Multipresse)|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Enges Bankdrücken (Multipresse, Flachbank)|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Flach.
Enges Bankdrücken (Multipresse, Schrägbank 30°)|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Schräg.
Enges Bankdrücken (Multipresse, Pause unten (2 s))|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Enges Bankdrücken (Multipresse, langsames Tempo (4-1-1))|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Enges Bankdrücken (Multipresse, explosiv heben)|55|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Enges Bankdrücken (Kurzhantel)|55|dumbbell|Gewichtsangabe pro Hantel eintragen.
Enges Bankdrücken (Kurzhantel, Flachbank)|55|dumbbell|Gewichtsangabe pro Hantel eintragen. Flach.
Enges Bankdrücken (Kurzhantel, Schrägbank 30°)|55|dumbbell|Gewichtsangabe pro Hantel eintragen. Schräg.
Enges Bankdrücken (Kurzhantel, Pause unten (2 s))|55|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Enges Bankdrücken (Kurzhantel, langsames Tempo (4-1-1))|55|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Enges Bankdrücken (Kurzhantel, explosiv heben)|55|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Enges Bankdrücken (SZ-Stange)|55|barbell|Der gewinkelte Griff schont die Handgelenke.
Enges Bankdrücken (SZ-Stange, Flachbank)|55|barbell|Der gewinkelte Griff schont die Handgelenke. Flach.
Enges Bankdrücken (SZ-Stange, Schrägbank 30°)|55|barbell|Der gewinkelte Griff schont die Handgelenke. Schräg.
Enges Bankdrücken (SZ-Stange, Pause unten (2 s))|55|barbell|Der gewinkelte Griff schont die Handgelenke. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Enges Bankdrücken (SZ-Stange, langsames Tempo (4-1-1))|55|barbell|Der gewinkelte Griff schont die Handgelenke. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Enges Bankdrücken (SZ-Stange, explosiv heben)|55|barbell|Der gewinkelte Griff schont die Handgelenke. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
JM Press (Langhantel)|56|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
JM Press (Langhantel, Flachbank)|56|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Flach.
JM Press (Multipresse)|56|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
JM Press (Multipresse, Flachbank)|56|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Flach.
JM Press (SZ-Stange)|56|barbell|Der gewinkelte Griff schont die Handgelenke.
JM Press (SZ-Stange, Flachbank)|56|barbell|Der gewinkelte Griff schont die Handgelenke. Flach.
Trizeps-Dips am Gerät (Maschine)|57|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Trizeps-Dips am Gerät (Maschine, sitzend)|57|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Trizeps-Liegestütze (Körpergewicht)|58|none|
Trizeps-Liegestütze (Körpergewicht, Diamant)|58|none|Diamant.
Trizeps-Liegestütze (Körpergewicht, Hände erhöht)|58|none|Hände erhöht.
Trizeps-Liegestütze (Körpergewicht, auf den Knien)|58|none|Auf den Knien.
Trizeps-Liegestütze (Körpergewicht, Füße erhöht)|58|none|Füße erhöht.
Trizeps-Liegestütze (Körpergewicht, Ellbogen eng (Bauchlage))|58|none|Ellbogen eng an den Rippen.
Trizeps-Extension am Boden (Körpergewicht)|59|none|
Trizeps-Extension am Boden (Körpergewicht, flacher Winkel)|59|none|Flacher Winkel: schwerer.
Trizeps-Extension am Boden (Körpergewicht, steiler Winkel)|59|none|Steiler: leichter.
Trizeps-Extension am Boden (Schlingentrainer)|59|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Trizeps-Extension am Boden (Schlingentrainer, flacher Winkel)|59|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Flacher Winkel: schwerer.
Trizeps-Extension am Boden (Schlingentrainer, steiler Winkel)|59|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Steiler: leichter.
Trizeps-Extension am Boden (Ringe)|59|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Trizeps-Extension am Boden (Ringe, flacher Winkel)|59|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Flacher Winkel: schwerer.
Trizeps-Extension am Boden (Ringe, steiler Winkel)|59|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Steiler: leichter.
Trizeps-Extension am Boden (Stange)|59|bar|
Trizeps-Extension am Boden (Stange, flacher Winkel)|59|bar|Flacher Winkel: schwerer.
Trizeps-Extension am Boden (Stange, steiler Winkel)|59|bar|Steiler: leichter.
Handgelenk-Curl (Kurzhantel)|60|dumbbell|Gewichtsangabe pro Hantel eintragen.
Handgelenk-Curl (Kurzhantel, Untergriff)|60|dumbbell|Gewichtsangabe pro Hantel eintragen. Untergriff: Beuger.
Handgelenk-Curl (Kurzhantel, Obergriff (Reverse))|60|dumbbell|Gewichtsangabe pro Hantel eintragen. Obergriff: Strecker.
Handgelenk-Curl (Kurzhantel, einarmig)|60|dumbbell|Gewichtsangabe pro Hantel eintragen. Eine Seite.
Handgelenk-Curl (Kurzhantel, hinter dem Rücken)|60|dumbbell|Gewichtsangabe pro Hantel eintragen. Stange hinter dem Rücken.
Handgelenk-Curl (Langhantel)|60|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Handgelenk-Curl (Langhantel, Untergriff)|60|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Untergriff: Beuger.
Handgelenk-Curl (Langhantel, Obergriff (Reverse))|60|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Obergriff: Strecker.
Handgelenk-Curl (Langhantel, einarmig)|60|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eine Seite.
Handgelenk-Curl (Langhantel, hinter dem Rücken)|60|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange hinter dem Rücken.
Handgelenk-Curl (SZ-Stange)|60|barbell|Der gewinkelte Griff schont die Handgelenke.
Handgelenk-Curl (SZ-Stange, Untergriff)|60|barbell|Der gewinkelte Griff schont die Handgelenke. Untergriff: Beuger.
Handgelenk-Curl (SZ-Stange, Obergriff (Reverse))|60|barbell|Der gewinkelte Griff schont die Handgelenke. Obergriff: Strecker.
Handgelenk-Curl (SZ-Stange, einarmig)|60|barbell|Der gewinkelte Griff schont die Handgelenke. Eine Seite.
Handgelenk-Curl (SZ-Stange, hinter dem Rücken)|60|barbell|Der gewinkelte Griff schont die Handgelenke. Stange hinter dem Rücken.
Handgelenk-Curl (Kabelzug)|60|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Handgelenk-Curl (Kabelzug, Untergriff)|60|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Untergriff: Beuger.
Handgelenk-Curl (Kabelzug, Obergriff (Reverse))|60|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Obergriff: Strecker.
Handgelenk-Curl (Kabelzug, einarmig)|60|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Eine Seite.
Handgelenk-Curl (Kabelzug, hinter dem Rücken)|60|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stange hinter dem Rücken.
Handgelenk-Curl (Widerstandsband)|60|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Handgelenk-Curl (Widerstandsband, Untergriff)|60|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Untergriff: Beuger.
Handgelenk-Curl (Widerstandsband, Obergriff (Reverse))|60|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Obergriff: Strecker.
Handgelenk-Curl (Widerstandsband, einarmig)|60|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Eine Seite.
Handgelenk-Curl (Widerstandsband, hinter dem Rücken)|60|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stange hinter dem Rücken.
Handgelenk-Curl (Kettlebell)|60|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Handgelenk-Curl (Kettlebell, Untergriff)|60|kettlebell|Gewichtsangabe der Kettlebell eintragen. Untergriff: Beuger.
Handgelenk-Curl (Kettlebell, Obergriff (Reverse))|60|kettlebell|Gewichtsangabe der Kettlebell eintragen. Obergriff: Strecker.
Handgelenk-Curl (Kettlebell, einarmig)|60|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Seite.
Handgelenk-Curl (Kettlebell, hinter dem Rücken)|60|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stange hinter dem Rücken.
Farmer's Walk (Kurzhantel)|61|dumbbell|Gewichtsangabe pro Hantel eintragen.
Farmer's Walk (Kurzhantel, beidarmig)|61|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Seiten.
Farmer's Walk (Kurzhantel, einarmig (Suitcase))|61|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur eine Seite: Rumpf muss halten.
Farmer's Walk (Kurzhantel, Rack-Position)|61|dumbbell|Gewichtsangabe pro Hantel eintragen. Gewichte vor der Brust.
Farmer's Walk (Kurzhantel, Overhead)|61|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Gewicht über dem Kopf.
Farmer's Walk (Kettlebell)|61|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Farmer's Walk (Kettlebell, beidarmig)|61|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beide Seiten.
Farmer's Walk (Kettlebell, einarmig (Suitcase))|61|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur eine Seite: Rumpf muss halten.
Farmer's Walk (Kettlebell, Rack-Position)|61|kettlebell|Gewichtsangabe der Kettlebell eintragen. Gewichte vor der Brust.
Farmer's Walk (Kettlebell, Overhead)|61|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ein Gewicht über dem Kopf.
Farmer's Walk (Trap-Bar)|61|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Farmer's Walk (Trap-Bar, beidarmig)|61|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Beide Seiten.
Farmer's Walk (Trap-Bar, einarmig (Suitcase))|61|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Nur eine Seite: Rumpf muss halten.
Farmer's Walk (Trap-Bar, Rack-Position)|61|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Gewichte vor der Brust.
Farmer's Walk (Trap-Bar, Overhead)|61|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Ein Gewicht über dem Kopf.
Farmer's Walk (Hantelscheibe)|61|barbell|Scheibe mit beiden Händen fest greifen.
Farmer's Walk (Hantelscheibe, beidarmig)|61|barbell|Scheibe mit beiden Händen fest greifen. Beide Seiten.
Farmer's Walk (Hantelscheibe, einarmig (Suitcase))|61|barbell|Scheibe mit beiden Händen fest greifen. Nur eine Seite: Rumpf muss halten.
Farmer's Walk (Hantelscheibe, Rack-Position)|61|barbell|Scheibe mit beiden Händen fest greifen. Gewichte vor der Brust.
Farmer's Walk (Hantelscheibe, Overhead)|61|barbell|Scheibe mit beiden Händen fest greifen. Ein Gewicht über dem Kopf.
Hängen (Dead Hang) (Stange)|62|bar|
Hängen (Dead Hang) (Stange, beidarmig)|62|bar|Beide Arme.
Hängen (Dead Hang) (Stange, einarmig)|62|bar|Eine Seite: sehr anspruchsvoll.
Hängen (Dead Hang) (Stange, Obergriff)|62|bar|Obergriff.
Hängen (Dead Hang) (Stange, Untergriff)|62|bar|Untergriff.
Hängen (Dead Hang) (Stange, neutral)|62|bar|Neutral.
Hängen (Dead Hang) (Stange, Handtuch)|62|bar|Handtuch über der Stange: härter.
Hängen (Dead Hang) (Stange, aktiv (Schulterblätter unten))|62|bar|Aktiv.
Hängen (Dead Hang) (Ringe)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Hängen (Dead Hang) (Ringe, beidarmig)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Beide Arme.
Hängen (Dead Hang) (Ringe, einarmig)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Eine Seite: sehr anspruchsvoll.
Hängen (Dead Hang) (Ringe, Obergriff)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Obergriff.
Hängen (Dead Hang) (Ringe, Untergriff)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Untergriff.
Hängen (Dead Hang) (Ringe, neutral)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Neutral.
Hängen (Dead Hang) (Ringe, Handtuch)|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handtuch über der Stange: härter.
Hängen (Dead Hang) (Ringe, aktiv (Schulterblätter unten))|62|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Aktiv.
Fingerhantel / Fingerrollen (Kurzhantel)|63|dumbbell|Gewichtsangabe pro Hantel eintragen.
Fingerhantel / Fingerrollen (Kurzhantel, Stange abrollen)|63|dumbbell|Gewichtsangabe pro Hantel eintragen. Stange aus der Hand rollen.
Fingerhantel / Fingerrollen (Kurzhantel, Fingerstrecken mit Band)|63|dumbbell|Gewichtsangabe pro Hantel eintragen. Band um die Finger.
Fingerhantel / Fingerrollen (Langhantel)|63|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Fingerhantel / Fingerrollen (Langhantel, Stange abrollen)|63|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange aus der Hand rollen.
Fingerhantel / Fingerrollen (Langhantel, Fingerstrecken mit Band)|63|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Band um die Finger.
Fingerhantel / Fingerrollen (Widerstandsband)|63|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Fingerhantel / Fingerrollen (Widerstandsband, Stange abrollen)|63|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stange aus der Hand rollen.
Fingerhantel / Fingerrollen (Widerstandsband, Fingerstrecken mit Band)|63|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Band um die Finger.
Plate Pinch (Hantelscheibe)|64|barbell|Scheibe mit beiden Händen fest greifen.
Plate Pinch (Hantelscheibe, 2 Scheiben)|64|barbell|Scheibe mit beiden Händen fest greifen. Zwei Scheiben.
Plate Pinch (Hantelscheibe, 3 Scheiben)|64|barbell|Scheibe mit beiden Händen fest greifen. Drei Scheiben.
Plate Pinch (Hantelscheibe, gehen)|64|barbell|Scheibe mit beiden Händen fest greifen. Mit Gehen.
Unterarm-Rollen (Kurzhantel)|65|dumbbell|Gewichtsangabe pro Hantel eintragen.
Unterarm-Rollen (Kurzhantel, aufrollen)|65|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufrollen.
Unterarm-Rollen (Kurzhantel, abrollen)|65|dumbbell|Gewichtsangabe pro Hantel eintragen. Abrollen.
Unterarm-Rollen (Langhantel)|65|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Unterarm-Rollen (Langhantel, aufrollen)|65|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufrollen.
Unterarm-Rollen (Langhantel, abrollen)|65|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Abrollen.
Nackenstärkung|66|none|
Nackenstärkung (Beugung (vorn))|66|none|Kinn Richtung Brust gegen Widerstand.
Nackenstärkung (Streckung (hinten))|66|none|Kopf nach hinten gegen Widerstand.
Nackenstärkung (seitliche Neigung links)|66|none|Ohr zur Schulter.
Nackenstärkung (seitliche Neigung rechts)|66|none|Ohr zur Schulter.
Nackenstärkung (isometrisch (10 s))|66|none|Gegen die Hand drücken ohne Bewegung.
Nackenstärkung (Widerstandsband)|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Nackenstärkung (Widerstandsband, Beugung (vorn))|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kinn Richtung Brust gegen Widerstand.
Nackenstärkung (Widerstandsband, Streckung (hinten))|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kopf nach hinten gegen Widerstand.
Nackenstärkung (Widerstandsband, seitliche Neigung links)|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ohr zur Schulter.
Nackenstärkung (Widerstandsband, seitliche Neigung rechts)|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ohr zur Schulter.
Nackenstärkung (Widerstandsband, isometrisch (10 s))|66|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gegen die Hand drücken ohne Bewegung.
Nackenstärkung (Hantelscheibe)|66|barbell|Scheibe mit beiden Händen fest greifen.
Nackenstärkung (Hantelscheibe, Beugung (vorn))|66|barbell|Scheibe mit beiden Händen fest greifen. Kinn Richtung Brust gegen Widerstand.
Nackenstärkung (Hantelscheibe, Streckung (hinten))|66|barbell|Scheibe mit beiden Händen fest greifen. Kopf nach hinten gegen Widerstand.
Nackenstärkung (Hantelscheibe, seitliche Neigung links)|66|barbell|Scheibe mit beiden Händen fest greifen. Ohr zur Schulter.
Nackenstärkung (Hantelscheibe, seitliche Neigung rechts)|66|barbell|Scheibe mit beiden Händen fest greifen. Ohr zur Schulter.
Nackenstärkung (Hantelscheibe, isometrisch (10 s))|66|barbell|Scheibe mit beiden Händen fest greifen. Gegen die Hand drücken ohne Bewegung.
Nackenstärkung (Maschine)|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Nackenstärkung (Maschine, Beugung (vorn))|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kinn Richtung Brust gegen Widerstand.
Nackenstärkung (Maschine, Streckung (hinten))|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kopf nach hinten gegen Widerstand.
Nackenstärkung (Maschine, seitliche Neigung links)|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ohr zur Schulter.
Nackenstärkung (Maschine, seitliche Neigung rechts)|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ohr zur Schulter.
Nackenstärkung (Maschine, isometrisch (10 s))|66|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Gegen die Hand drücken ohne Bewegung.
Nacken-Brücke (Körpergewicht)|67|none|
Nacken-Brücke (Körpergewicht, Anfänger (Hände abstützen))|67|none|Mit Händen abstützen.
Nacken-Brücke (Körpergewicht, Fortgeschritten)|67|none|Nur mit Kopf und Füßen.
Kniebeuge (Langhantel)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Kniebeuge (Langhantel, Front-Kniebeuge)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps.
Kniebeuge (Langhantel, High Bar (Nacken))|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange auf dem Trapez.
Kniebeuge (Langhantel, Low Bar)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange tiefer auf dem hinteren Deltamuskel: mehr Hüfte.
Kniebeuge (Langhantel, Goblet)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor der Brust halten.
Kniebeuge (Langhantel, Zercher)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange in den Ellbogenbeugen.
Kniebeuge (Langhantel, Overhead)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last über dem Kopf: viel Rumpf und Beweglichkeit.
Kniebeuge (Langhantel, Box Squat)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf eine Kiste setzen und wieder aufstehen.
Kniebeuge (Langhantel, Pause unten (2 s))|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten.
Kniebeuge (Langhantel, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße etwa hüftbreit.
Kniebeuge (Langhantel, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Schulterbreit.
Kniebeuge (Langhantel, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Front-Kniebeuge, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Front-Kniebeuge, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Schulterbreit.
Kniebeuge (Langhantel, Front-Kniebeuge, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, High Bar (Nacken), hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange auf dem Trapez. Füße etwa hüftbreit.
Kniebeuge (Langhantel, High Bar (Nacken), schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange auf dem Trapez. Schulterbreit.
Kniebeuge (Langhantel, High Bar (Nacken), breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange auf dem Trapez. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Low Bar, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange tiefer auf dem hinteren Deltamuskel: mehr Hüfte. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Low Bar, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange tiefer auf dem hinteren Deltamuskel: mehr Hüfte. Schulterbreit.
Kniebeuge (Langhantel, Low Bar, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange tiefer auf dem hinteren Deltamuskel: mehr Hüfte. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Goblet, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor der Brust halten. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Goblet, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor der Brust halten. Schulterbreit.
Kniebeuge (Langhantel, Goblet, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor der Brust halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Zercher, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange in den Ellbogenbeugen. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Zercher, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange in den Ellbogenbeugen. Schulterbreit.
Kniebeuge (Langhantel, Zercher, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stange in den Ellbogenbeugen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Overhead, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last über dem Kopf: viel Rumpf und Beweglichkeit. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Overhead, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last über dem Kopf: viel Rumpf und Beweglichkeit. Schulterbreit.
Kniebeuge (Langhantel, Overhead, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last über dem Kopf: viel Rumpf und Beweglichkeit. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Box Squat, hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf eine Kiste setzen und wieder aufstehen. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Box Squat, schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf eine Kiste setzen und wieder aufstehen. Schulterbreit.
Kniebeuge (Langhantel, Box Squat, breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf eine Kiste setzen und wieder aufstehen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Langhantel, Pause unten (2 s), hüftbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten. Füße etwa hüftbreit.
Kniebeuge (Langhantel, Pause unten (2 s), schulterbreit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten. Schulterbreit.
Kniebeuge (Langhantel, Pause unten (2 s), breit)|68|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Multipresse)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Kniebeuge (Multipresse, Front-Kniebeuge)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps.
Kniebeuge (Multipresse, High Bar (Nacken))|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange auf dem Trapez.
Kniebeuge (Multipresse, Pause unten (2 s))|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten.
Kniebeuge (Multipresse, hüftbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Füße etwa hüftbreit.
Kniebeuge (Multipresse, schulterbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Schulterbreit.
Kniebeuge (Multipresse, breit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Multipresse, Front-Kniebeuge, hüftbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Füße etwa hüftbreit.
Kniebeuge (Multipresse, Front-Kniebeuge, schulterbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Schulterbreit.
Kniebeuge (Multipresse, Front-Kniebeuge, breit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn: aufrechter Oberkörper, mehr Quadrizeps. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Multipresse, High Bar (Nacken), hüftbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange auf dem Trapez. Füße etwa hüftbreit.
Kniebeuge (Multipresse, High Bar (Nacken), schulterbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange auf dem Trapez. Schulterbreit.
Kniebeuge (Multipresse, High Bar (Nacken), breit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stange auf dem Trapez. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Multipresse, Pause unten (2 s), hüftbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten. Füße etwa hüftbreit.
Kniebeuge (Multipresse, Pause unten (2 s), schulterbreit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten. Schulterbreit.
Kniebeuge (Multipresse, Pause unten (2 s), breit)|68|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kurzhantel)|68|dumbbell|Gewichtsangabe pro Hantel eintragen.
Kniebeuge (Kurzhantel, Goblet)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust halten.
Kniebeuge (Kurzhantel, Pause unten (2 s))|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten.
Kniebeuge (Kurzhantel, hüftbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße etwa hüftbreit.
Kniebeuge (Kurzhantel, schulterbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Schulterbreit.
Kniebeuge (Kurzhantel, breit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kurzhantel, Goblet, hüftbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust halten. Füße etwa hüftbreit.
Kniebeuge (Kurzhantel, Goblet, schulterbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust halten. Schulterbreit.
Kniebeuge (Kurzhantel, Goblet, breit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kurzhantel, Pause unten (2 s), hüftbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten. Füße etwa hüftbreit.
Kniebeuge (Kurzhantel, Pause unten (2 s), schulterbreit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten. Schulterbreit.
Kniebeuge (Kurzhantel, Pause unten (2 s), breit)|68|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kettlebell)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Kniebeuge (Kettlebell, Goblet)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust halten.
Kniebeuge (Kettlebell, Pause unten (2 s))|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten.
Kniebeuge (Kettlebell, hüftbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße etwa hüftbreit.
Kniebeuge (Kettlebell, schulterbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Schulterbreit.
Kniebeuge (Kettlebell, breit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kettlebell, Goblet, hüftbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust halten. Füße etwa hüftbreit.
Kniebeuge (Kettlebell, Goblet, schulterbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust halten. Schulterbreit.
Kniebeuge (Kettlebell, Goblet, breit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kettlebell, Pause unten (2 s), hüftbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten. Füße etwa hüftbreit.
Kniebeuge (Kettlebell, Pause unten (2 s), schulterbreit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten. Schulterbreit.
Kniebeuge (Kettlebell, Pause unten (2 s), breit)|68|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Maschine)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Kniebeuge (Maschine, Pause unten (2 s))|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden halten.
Kniebeuge (Maschine, hüftbreit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße etwa hüftbreit.
Kniebeuge (Maschine, schulterbreit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Schulterbreit.
Kniebeuge (Maschine, breit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Maschine, Pause unten (2 s), hüftbreit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden halten. Füße etwa hüftbreit.
Kniebeuge (Maschine, Pause unten (2 s), schulterbreit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden halten. Schulterbreit.
Kniebeuge (Maschine, Pause unten (2 s), breit)|68|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Widerstandsband)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Kniebeuge (Widerstandsband, Goblet)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust halten.
Kniebeuge (Widerstandsband, hüftbreit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit.
Kniebeuge (Widerstandsband, schulterbreit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit.
Kniebeuge (Widerstandsband, breit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Widerstandsband, Goblet, hüftbreit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust halten. Füße etwa hüftbreit.
Kniebeuge (Widerstandsband, Goblet, schulterbreit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust halten. Schulterbreit.
Kniebeuge (Widerstandsband, Goblet, breit)|68|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kabelzug)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Kniebeuge (Kabelzug, Goblet)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor der Brust halten.
Kniebeuge (Kabelzug, hüftbreit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Füße etwa hüftbreit.
Kniebeuge (Kabelzug, schulterbreit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Schulterbreit.
Kniebeuge (Kabelzug, breit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge (Kabelzug, Goblet, hüftbreit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor der Brust halten. Füße etwa hüftbreit.
Kniebeuge (Kabelzug, Goblet, schulterbreit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor der Brust halten. Schulterbreit.
Kniebeuge (Kabelzug, Goblet, breit)|68|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor der Brust halten. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge ohne Gewicht (Körpergewicht)|69|none|
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit)|69|none|Füße etwa hüftbreit.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit)|69|none|Schulterbreit.
Kniebeuge ohne Gewicht (Körpergewicht, breit)|69|none|Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo)|69|none|Sehr breit, Zehen nach außen.
Kniebeuge ohne Gewicht (Körpergewicht, eng)|69|none|Enger Stand: mehr Oberschenkel vorn.
Kniebeuge ohne Gewicht (Körpergewicht, mit Pause unten (3 s))|69|none|Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, langsam (4-1-1))|69|none|Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, Sprung (Jump Squat))|69|none|Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, Arme über Kopf)|69|none|Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, Zehenspitzen (Heel Raise Squat))|69|none|Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, Puls (halbe Wdh. unten))|69|none|Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, mit Pause unten (3 s))|69|none|Füße etwa hüftbreit. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, langsam (4-1-1))|69|none|Füße etwa hüftbreit. Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, Sprung (Jump Squat))|69|none|Füße etwa hüftbreit. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, Arme über Kopf)|69|none|Füße etwa hüftbreit. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, Zehenspitzen (Heel Raise Squat))|69|none|Füße etwa hüftbreit. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, hüftbreit, Puls (halbe Wdh. unten))|69|none|Füße etwa hüftbreit. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, mit Pause unten (3 s))|69|none|Schulterbreit. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, langsam (4-1-1))|69|none|Schulterbreit. Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, Sprung (Jump Squat))|69|none|Schulterbreit. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, Arme über Kopf)|69|none|Schulterbreit. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, Zehenspitzen (Heel Raise Squat))|69|none|Schulterbreit. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, schulterbreit, Puls (halbe Wdh. unten))|69|none|Schulterbreit. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Körpergewicht, breit, mit Pause unten (3 s))|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, breit, langsam (4-1-1))|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, breit, Sprung (Jump Squat))|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, breit, Arme über Kopf)|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, breit, Zehenspitzen (Heel Raise Squat))|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, breit, Puls (halbe Wdh. unten))|69|none|Breiter Stand: mehr Gesäß und Adduktoren. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, mit Pause unten (3 s))|69|none|Sehr breit, Zehen nach außen. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, langsam (4-1-1))|69|none|Sehr breit, Zehen nach außen. Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, Sprung (Jump Squat))|69|none|Sehr breit, Zehen nach außen. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, Arme über Kopf)|69|none|Sehr breit, Zehen nach außen. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, Zehenspitzen (Heel Raise Squat))|69|none|Sehr breit, Zehen nach außen. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, Sumo, Puls (halbe Wdh. unten))|69|none|Sehr breit, Zehen nach außen. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Körpergewicht, eng, mit Pause unten (3 s))|69|none|Enger Stand: mehr Oberschenkel vorn. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Körpergewicht, eng, langsam (4-1-1))|69|none|Enger Stand: mehr Oberschenkel vorn. Langsam.
Kniebeuge ohne Gewicht (Körpergewicht, eng, Sprung (Jump Squat))|69|none|Enger Stand: mehr Oberschenkel vorn. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Körpergewicht, eng, Arme über Kopf)|69|none|Enger Stand: mehr Oberschenkel vorn. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Körpergewicht, eng, Zehenspitzen (Heel Raise Squat))|69|none|Enger Stand: mehr Oberschenkel vorn. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Körpergewicht, eng, Puls (halbe Wdh. unten))|69|none|Enger Stand: mehr Oberschenkel vorn. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit.
Kniebeuge ohne Gewicht (Widerstandsband, breit)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen.
Kniebeuge ohne Gewicht (Widerstandsband, eng)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn.
Kniebeuge ohne Gewicht (Widerstandsband, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, hüftbreit, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße etwa hüftbreit. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, schulterbreit, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Schulterbreit. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband, breit, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, breit, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, breit, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, breit, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, breit, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, breit, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Breiter Stand: mehr Gesäß und Adduktoren. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, Sumo, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sehr breit, Zehen nach außen. Unten kleine Wippbewegungen.
Kniebeuge ohne Gewicht (Widerstandsband, eng, mit Pause unten (3 s))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Unten 3 Sekunden halten.
Kniebeuge ohne Gewicht (Widerstandsband, eng, langsam (4-1-1))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Langsam.
Kniebeuge ohne Gewicht (Widerstandsband, eng, Sprung (Jump Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Aus dem Tiefpunkt hochspringen.
Kniebeuge ohne Gewicht (Widerstandsband, eng, Arme über Kopf)|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Arme gestreckt über dem Kopf: Mobilität.
Kniebeuge ohne Gewicht (Widerstandsband, eng, Zehenspitzen (Heel Raise Squat))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Auf den Zehen am Ende hochdrücken.
Kniebeuge ohne Gewicht (Widerstandsband, eng, Puls (halbe Wdh. unten))|69|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Enger Stand: mehr Oberschenkel vorn. Unten kleine Wippbewegungen.
Spanische Kniebeuge (Widerstandsband)|70|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Spanische Kniebeuge (Widerstandsband, Wand)|70|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rücken an der Wand.
Pistol Squat (Körpergewicht)|71|none|
Pistol Squat (Körpergewicht, auf einer Box)|71|none|Auf Box sitzen.
Pistol Squat (Körpergewicht, mit Griff zum Festhalten)|71|none|Mit Stütze.
Pistol Squat (Körpergewicht, Negativ (5 s))|71|none|Langsam absenken.
Pistol Squat (Körpergewicht, Goblet)|71|none|Last vor der Brust.
Pistol Squat (Kettlebell)|71|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Pistol Squat (Kettlebell, auf einer Box)|71|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf Box sitzen.
Pistol Squat (Kettlebell, mit Griff zum Festhalten)|71|kettlebell|Gewichtsangabe der Kettlebell eintragen. Mit Stütze.
Pistol Squat (Kettlebell, Negativ (5 s))|71|kettlebell|Gewichtsangabe der Kettlebell eintragen. Langsam absenken.
Pistol Squat (Kettlebell, Goblet)|71|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust.
Pistol Squat (Widerstandsband)|71|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Pistol Squat (Widerstandsband, auf einer Box)|71|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf Box sitzen.
Pistol Squat (Widerstandsband, mit Griff zum Festhalten)|71|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Stütze.
Pistol Squat (Widerstandsband, Negativ (5 s))|71|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam absenken.
Pistol Squat (Widerstandsband, Goblet)|71|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust.
Pistol Squat (Ringe)|71|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Pistol Squat (Ringe, auf einer Box)|71|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Auf Box sitzen.
Pistol Squat (Ringe, mit Griff zum Festhalten)|71|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Mit Stütze.
Pistol Squat (Ringe, Negativ (5 s))|71|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Langsam absenken.
Pistol Squat (Ringe, Goblet)|71|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Last vor der Brust.
Bulgarian Split Squat (Kurzhantel)|72|dumbbell|Gewichtsangabe pro Hantel eintragen.
Bulgarian Split Squat (Kurzhantel, Quadrizeps betont (aufrecht))|72|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Kurzhantel, Gesäß betont (vorgebeugt))|72|dumbbell|Gewichtsangabe pro Hantel eintragen. Oberkörper vorgeneigt.
Bulgarian Split Squat (Kurzhantel, Pause unten (2 s))|72|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden.
Bulgarian Split Squat (Kurzhantel, Front-Rack)|72|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vorn.
Bulgarian Split Squat (Langhantel)|72|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Bulgarian Split Squat (Langhantel, Quadrizeps betont (aufrecht))|72|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Langhantel, Gesäß betont (vorgebeugt))|72|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oberkörper vorgeneigt.
Bulgarian Split Squat (Langhantel, Pause unten (2 s))|72|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden.
Bulgarian Split Squat (Langhantel, Front-Rack)|72|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn.
Bulgarian Split Squat (Multipresse)|72|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Bulgarian Split Squat (Multipresse, Quadrizeps betont (aufrecht))|72|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Multipresse, Gesäß betont (vorgebeugt))|72|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Oberkörper vorgeneigt.
Bulgarian Split Squat (Multipresse, Pause unten (2 s))|72|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden.
Bulgarian Split Squat (Multipresse, Front-Rack)|72|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn.
Bulgarian Split Squat (Kettlebell)|72|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Bulgarian Split Squat (Kettlebell, Quadrizeps betont (aufrecht))|72|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Kettlebell, Gesäß betont (vorgebeugt))|72|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oberkörper vorgeneigt.
Bulgarian Split Squat (Kettlebell, Pause unten (2 s))|72|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden.
Bulgarian Split Squat (Kettlebell, Front-Rack)|72|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vorn.
Bulgarian Split Squat (Körpergewicht)|72|none|
Bulgarian Split Squat (Körpergewicht, Quadrizeps betont (aufrecht))|72|none|Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Körpergewicht, Gesäß betont (vorgebeugt))|72|none|Oberkörper vorgeneigt.
Bulgarian Split Squat (Körpergewicht, Pause unten (2 s))|72|none|Unten 2 Sekunden.
Bulgarian Split Squat (Körpergewicht, Front-Rack)|72|none|Last vorn.
Bulgarian Split Squat (Kabelzug)|72|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Bulgarian Split Squat (Kabelzug, Quadrizeps betont (aufrecht))|72|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Kabelzug, Gesäß betont (vorgebeugt))|72|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oberkörper vorgeneigt.
Bulgarian Split Squat (Kabelzug, Pause unten (2 s))|72|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden.
Bulgarian Split Squat (Kabelzug, Front-Rack)|72|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vorn.
Bulgarian Split Squat (Widerstandsband)|72|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Bulgarian Split Squat (Widerstandsband, Quadrizeps betont (aufrecht))|72|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufrecht, Knie nach vorn.
Bulgarian Split Squat (Widerstandsband, Gesäß betont (vorgebeugt))|72|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oberkörper vorgeneigt.
Bulgarian Split Squat (Widerstandsband, Pause unten (2 s))|72|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden.
Bulgarian Split Squat (Widerstandsband, Front-Rack)|72|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vorn.
Ausfallschritte (Kurzhantel)|73|dumbbell|Gewichtsangabe pro Hantel eintragen.
Ausfallschritte (Kurzhantel, vorwärts)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorwärtsschritt.
Ausfallschritte (Kurzhantel, rückwärts)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückwärts: schonender für die Knie.
Ausfallschritte (Kurzhantel, seitlich)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Kurzhantel, über Kreuz (Curtsy))|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal hinter dem Standbein.
Ausfallschritte (Kurzhantel, gehend (Walking))|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Gehen, Schritt für Schritt.
Ausfallschritte (Kurzhantel, statisch)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Platz, nur hoch und runter.
Ausfallschritte (Kurzhantel, Deficit)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorderer Fuß erhöht.
Ausfallschritte (Kurzhantel, mit Sprung)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Sprung wechseln.
Ausfallschritte (Kurzhantel, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust.
Ausfallschritte (Kurzhantel, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vorn.
Ausfallschritte (Kurzhantel, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Last über Kopf.
Ausfallschritte (Kurzhantel, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, vorwärts, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Kurzhantel, vorwärts, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorwärtsschritt. Last vorn.
Ausfallschritte (Kurzhantel, vorwärts, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Kurzhantel, vorwärts, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, rückwärts, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Kurzhantel, rückwärts, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Kurzhantel, rückwärts, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Kurzhantel, rückwärts, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, seitlich, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Kurzhantel, seitlich, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Kurzhantel, seitlich, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Kurzhantel, seitlich, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, über Kreuz (Curtsy), Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Kurzhantel, über Kreuz (Curtsy), Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Kurzhantel, über Kreuz (Curtsy), Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Kurzhantel, über Kreuz (Curtsy), mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, gehend (Walking), Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Kurzhantel, gehend (Walking), Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Kurzhantel, gehend (Walking), Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Kurzhantel, gehend (Walking), mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, statisch, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Kurzhantel, statisch, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Kurzhantel, statisch, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Kurzhantel, statisch, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, Deficit, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Kurzhantel, Deficit, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Kurzhantel, Deficit, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Kurzhantel, Deficit, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kurzhantel, mit Sprung, Goblet)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Kurzhantel, mit Sprung, Front-Rack)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Sprung wechseln. Last vorn.
Ausfallschritte (Kurzhantel, mit Sprung, Overhead)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Kurzhantel, mit Sprung, mit Rotation)|73|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Ausfallschritte (Langhantel, vorwärts)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorwärtsschritt.
Ausfallschritte (Langhantel, rückwärts)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rückwärts: schonender für die Knie.
Ausfallschritte (Langhantel, seitlich)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Langhantel, über Kreuz (Curtsy))|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Diagonal hinter dem Standbein.
Ausfallschritte (Langhantel, gehend (Walking))|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Gehen, Schritt für Schritt.
Ausfallschritte (Langhantel, statisch)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Am Platz, nur hoch und runter.
Ausfallschritte (Langhantel, Deficit)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorderer Fuß erhöht.
Ausfallschritte (Langhantel, mit Sprung)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Sprung wechseln.
Ausfallschritte (Langhantel, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vor der Brust.
Ausfallschritte (Langhantel, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last vorn.
Ausfallschritte (Langhantel, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Last über Kopf.
Ausfallschritte (Langhantel, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, vorwärts, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Langhantel, vorwärts, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorwärtsschritt. Last vorn.
Ausfallschritte (Langhantel, vorwärts, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Langhantel, vorwärts, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, rückwärts, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Langhantel, rückwärts, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Langhantel, rückwärts, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Langhantel, rückwärts, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, seitlich, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Langhantel, seitlich, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Langhantel, seitlich, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Langhantel, seitlich, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, über Kreuz (Curtsy), Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Langhantel, über Kreuz (Curtsy), Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Langhantel, über Kreuz (Curtsy), Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Langhantel, über Kreuz (Curtsy), mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, gehend (Walking), Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Langhantel, gehend (Walking), Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Langhantel, gehend (Walking), Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Langhantel, gehend (Walking), mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, statisch, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Langhantel, statisch, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Langhantel, statisch, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Langhantel, statisch, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, Deficit, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Langhantel, Deficit, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Langhantel, Deficit, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Langhantel, Deficit, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Langhantel, mit Sprung, Goblet)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Langhantel, mit Sprung, Front-Rack)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Sprung wechseln. Last vorn.
Ausfallschritte (Langhantel, mit Sprung, Overhead)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Langhantel, mit Sprung, mit Rotation)|73|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht)|73|none|
Ausfallschritte (Körpergewicht, vorwärts)|73|none|Vorwärtsschritt.
Ausfallschritte (Körpergewicht, rückwärts)|73|none|Rückwärts: schonender für die Knie.
Ausfallschritte (Körpergewicht, seitlich)|73|none|Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Körpergewicht, über Kreuz (Curtsy))|73|none|Diagonal hinter dem Standbein.
Ausfallschritte (Körpergewicht, gehend (Walking))|73|none|Im Gehen, Schritt für Schritt.
Ausfallschritte (Körpergewicht, statisch)|73|none|Am Platz, nur hoch und runter.
Ausfallschritte (Körpergewicht, Deficit)|73|none|Vorderer Fuß erhöht.
Ausfallschritte (Körpergewicht, mit Sprung)|73|none|Im Sprung wechseln.
Ausfallschritte (Körpergewicht, Goblet)|73|none|Last vor der Brust.
Ausfallschritte (Körpergewicht, Front-Rack)|73|none|Last vorn.
Ausfallschritte (Körpergewicht, Overhead)|73|none|Last über Kopf.
Ausfallschritte (Körpergewicht, mit Rotation)|73|none|Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, vorwärts, Goblet)|73|none|Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Körpergewicht, vorwärts, Front-Rack)|73|none|Vorwärtsschritt. Last vorn.
Ausfallschritte (Körpergewicht, vorwärts, Overhead)|73|none|Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Körpergewicht, vorwärts, mit Rotation)|73|none|Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, rückwärts, Goblet)|73|none|Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Körpergewicht, rückwärts, Front-Rack)|73|none|Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Körpergewicht, rückwärts, Overhead)|73|none|Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Körpergewicht, rückwärts, mit Rotation)|73|none|Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, seitlich, Goblet)|73|none|Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Körpergewicht, seitlich, Front-Rack)|73|none|Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Körpergewicht, seitlich, Overhead)|73|none|Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Körpergewicht, seitlich, mit Rotation)|73|none|Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, über Kreuz (Curtsy), Goblet)|73|none|Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Körpergewicht, über Kreuz (Curtsy), Front-Rack)|73|none|Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Körpergewicht, über Kreuz (Curtsy), Overhead)|73|none|Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Körpergewicht, über Kreuz (Curtsy), mit Rotation)|73|none|Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, gehend (Walking), Goblet)|73|none|Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Körpergewicht, gehend (Walking), Front-Rack)|73|none|Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Körpergewicht, gehend (Walking), Overhead)|73|none|Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Körpergewicht, gehend (Walking), mit Rotation)|73|none|Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, statisch, Goblet)|73|none|Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Körpergewicht, statisch, Front-Rack)|73|none|Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Körpergewicht, statisch, Overhead)|73|none|Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Körpergewicht, statisch, mit Rotation)|73|none|Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, Deficit, Goblet)|73|none|Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Körpergewicht, Deficit, Front-Rack)|73|none|Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Körpergewicht, Deficit, Overhead)|73|none|Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Körpergewicht, Deficit, mit Rotation)|73|none|Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Körpergewicht, mit Sprung, Goblet)|73|none|Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Körpergewicht, mit Sprung, Front-Rack)|73|none|Im Sprung wechseln. Last vorn.
Ausfallschritte (Körpergewicht, mit Sprung, Overhead)|73|none|Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Körpergewicht, mit Sprung, mit Rotation)|73|none|Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Ausfallschritte (Kettlebell, vorwärts)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorwärtsschritt.
Ausfallschritte (Kettlebell, rückwärts)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rückwärts: schonender für die Knie.
Ausfallschritte (Kettlebell, seitlich)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Kettlebell, über Kreuz (Curtsy))|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal hinter dem Standbein.
Ausfallschritte (Kettlebell, gehend (Walking))|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Gehen, Schritt für Schritt.
Ausfallschritte (Kettlebell, statisch)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Platz, nur hoch und runter.
Ausfallschritte (Kettlebell, Deficit)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorderer Fuß erhöht.
Ausfallschritte (Kettlebell, mit Sprung)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Sprung wechseln.
Ausfallschritte (Kettlebell, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust.
Ausfallschritte (Kettlebell, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vorn.
Ausfallschritte (Kettlebell, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last über Kopf.
Ausfallschritte (Kettlebell, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, vorwärts, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Kettlebell, vorwärts, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorwärtsschritt. Last vorn.
Ausfallschritte (Kettlebell, vorwärts, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Kettlebell, vorwärts, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, rückwärts, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Kettlebell, rückwärts, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Kettlebell, rückwärts, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Kettlebell, rückwärts, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, seitlich, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Kettlebell, seitlich, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Kettlebell, seitlich, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Kettlebell, seitlich, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, über Kreuz (Curtsy), Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Kettlebell, über Kreuz (Curtsy), Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Kettlebell, über Kreuz (Curtsy), Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Kettlebell, über Kreuz (Curtsy), mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, gehend (Walking), Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Kettlebell, gehend (Walking), Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Kettlebell, gehend (Walking), Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Kettlebell, gehend (Walking), mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, statisch, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Kettlebell, statisch, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Kettlebell, statisch, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Kettlebell, statisch, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, Deficit, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Kettlebell, Deficit, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Kettlebell, Deficit, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Kettlebell, Deficit, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kettlebell, mit Sprung, Goblet)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Kettlebell, mit Sprung, Front-Rack)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Sprung wechseln. Last vorn.
Ausfallschritte (Kettlebell, mit Sprung, Overhead)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Kettlebell, mit Sprung, mit Rotation)|73|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Ausfallschritte (Multipresse, vorwärts)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorwärtsschritt.
Ausfallschritte (Multipresse, rückwärts)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rückwärts: schonender für die Knie.
Ausfallschritte (Multipresse, seitlich)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Multipresse, über Kreuz (Curtsy))|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Diagonal hinter dem Standbein.
Ausfallschritte (Multipresse, gehend (Walking))|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Gehen, Schritt für Schritt.
Ausfallschritte (Multipresse, statisch)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Am Platz, nur hoch und runter.
Ausfallschritte (Multipresse, Deficit)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorderer Fuß erhöht.
Ausfallschritte (Multipresse, mit Sprung)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Sprung wechseln.
Ausfallschritte (Multipresse, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vor der Brust.
Ausfallschritte (Multipresse, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last vorn.
Ausfallschritte (Multipresse, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Last über Kopf.
Ausfallschritte (Multipresse, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, vorwärts, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Multipresse, vorwärts, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorwärtsschritt. Last vorn.
Ausfallschritte (Multipresse, vorwärts, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Multipresse, vorwärts, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, rückwärts, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Multipresse, rückwärts, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Multipresse, rückwärts, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Multipresse, rückwärts, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, seitlich, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Multipresse, seitlich, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Multipresse, seitlich, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Multipresse, seitlich, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, über Kreuz (Curtsy), Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Multipresse, über Kreuz (Curtsy), Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Multipresse, über Kreuz (Curtsy), Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Multipresse, über Kreuz (Curtsy), mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, gehend (Walking), Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Multipresse, gehend (Walking), Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Multipresse, gehend (Walking), Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Multipresse, gehend (Walking), mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, statisch, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Multipresse, statisch, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Multipresse, statisch, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Multipresse, statisch, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, Deficit, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Multipresse, Deficit, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Multipresse, Deficit, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Multipresse, Deficit, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Multipresse, mit Sprung, Goblet)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Multipresse, mit Sprung, Front-Rack)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Sprung wechseln. Last vorn.
Ausfallschritte (Multipresse, mit Sprung, Overhead)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Multipresse, mit Sprung, mit Rotation)|73|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Ausfallschritte (Widerstandsband, vorwärts)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorwärtsschritt.
Ausfallschritte (Widerstandsband, rückwärts)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückwärts: schonender für die Knie.
Ausfallschritte (Widerstandsband, seitlich)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Widerstandsband, über Kreuz (Curtsy))|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal hinter dem Standbein.
Ausfallschritte (Widerstandsband, gehend (Walking))|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Gehen, Schritt für Schritt.
Ausfallschritte (Widerstandsband, statisch)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Platz, nur hoch und runter.
Ausfallschritte (Widerstandsband, Deficit)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderer Fuß erhöht.
Ausfallschritte (Widerstandsband, mit Sprung)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Sprung wechseln.
Ausfallschritte (Widerstandsband, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vor der Brust.
Ausfallschritte (Widerstandsband, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last vorn.
Ausfallschritte (Widerstandsband, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Last über Kopf.
Ausfallschritte (Widerstandsband, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, vorwärts, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Widerstandsband, vorwärts, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorwärtsschritt. Last vorn.
Ausfallschritte (Widerstandsband, vorwärts, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Widerstandsband, vorwärts, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, rückwärts, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Widerstandsband, rückwärts, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Widerstandsband, rückwärts, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Widerstandsband, rückwärts, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, seitlich, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Widerstandsband, seitlich, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Widerstandsband, seitlich, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Widerstandsband, seitlich, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, über Kreuz (Curtsy), Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Widerstandsband, über Kreuz (Curtsy), Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Widerstandsband, über Kreuz (Curtsy), Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Widerstandsband, über Kreuz (Curtsy), mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, gehend (Walking), Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Widerstandsband, gehend (Walking), Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Widerstandsband, gehend (Walking), Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Widerstandsband, gehend (Walking), mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, statisch, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Widerstandsband, statisch, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Widerstandsband, statisch, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Widerstandsband, statisch, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, Deficit, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Widerstandsband, Deficit, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Widerstandsband, Deficit, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Widerstandsband, Deficit, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Widerstandsband, mit Sprung, Goblet)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Widerstandsband, mit Sprung, Front-Rack)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Sprung wechseln. Last vorn.
Ausfallschritte (Widerstandsband, mit Sprung, Overhead)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Widerstandsband, mit Sprung, mit Rotation)|73|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Ausfallschritte (Kabelzug, vorwärts)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorwärtsschritt.
Ausfallschritte (Kabelzug, rückwärts)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückwärts: schonender für die Knie.
Ausfallschritte (Kabelzug, seitlich)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Kabelzug, über Kreuz (Curtsy))|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal hinter dem Standbein.
Ausfallschritte (Kabelzug, gehend (Walking))|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Gehen, Schritt für Schritt.
Ausfallschritte (Kabelzug, statisch)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Platz, nur hoch und runter.
Ausfallschritte (Kabelzug, Deficit)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorderer Fuß erhöht.
Ausfallschritte (Kabelzug, mit Sprung)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Sprung wechseln.
Ausfallschritte (Kabelzug, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vor der Brust.
Ausfallschritte (Kabelzug, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last vorn.
Ausfallschritte (Kabelzug, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Last über Kopf.
Ausfallschritte (Kabelzug, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, vorwärts, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Kabelzug, vorwärts, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorwärtsschritt. Last vorn.
Ausfallschritte (Kabelzug, vorwärts, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Kabelzug, vorwärts, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, rückwärts, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Kabelzug, rückwärts, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Kabelzug, rückwärts, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Kabelzug, rückwärts, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, seitlich, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Kabelzug, seitlich, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Kabelzug, seitlich, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Kabelzug, seitlich, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, über Kreuz (Curtsy), Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Kabelzug, über Kreuz (Curtsy), Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Kabelzug, über Kreuz (Curtsy), Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Kabelzug, über Kreuz (Curtsy), mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, gehend (Walking), Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Kabelzug, gehend (Walking), Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Kabelzug, gehend (Walking), Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Kabelzug, gehend (Walking), mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, statisch, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Kabelzug, statisch, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Kabelzug, statisch, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Kabelzug, statisch, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, Deficit, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Kabelzug, Deficit, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Kabelzug, Deficit, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Kabelzug, Deficit, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Kabelzug, mit Sprung, Goblet)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Kabelzug, mit Sprung, Front-Rack)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Sprung wechseln. Last vorn.
Ausfallschritte (Kabelzug, mit Sprung, Overhead)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Kabelzug, mit Sprung, mit Rotation)|73|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball)|73|medball|Ball nach Technik wählen, lieber leicht und sauber.
Ausfallschritte (Medizinball, vorwärts)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorwärtsschritt.
Ausfallschritte (Medizinball, rückwärts)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückwärts: schonender für die Knie.
Ausfallschritte (Medizinball, seitlich)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlicher Ausfallschritt: Adduktoren.
Ausfallschritte (Medizinball, über Kreuz (Curtsy))|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal hinter dem Standbein.
Ausfallschritte (Medizinball, gehend (Walking))|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Gehen, Schritt für Schritt.
Ausfallschritte (Medizinball, statisch)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Am Platz, nur hoch und runter.
Ausfallschritte (Medizinball, Deficit)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorderer Fuß erhöht.
Ausfallschritte (Medizinball, mit Sprung)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sprung wechseln.
Ausfallschritte (Medizinball, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Last vor der Brust.
Ausfallschritte (Medizinball, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Last vorn.
Ausfallschritte (Medizinball, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Last über Kopf.
Ausfallschritte (Medizinball, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, vorwärts, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorwärtsschritt. Last vor der Brust.
Ausfallschritte (Medizinball, vorwärts, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorwärtsschritt. Last vorn.
Ausfallschritte (Medizinball, vorwärts, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorwärtsschritt. Last über Kopf.
Ausfallschritte (Medizinball, vorwärts, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorwärtsschritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, rückwärts, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückwärts: schonender für die Knie. Last vor der Brust.
Ausfallschritte (Medizinball, rückwärts, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückwärts: schonender für die Knie. Last vorn.
Ausfallschritte (Medizinball, rückwärts, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückwärts: schonender für die Knie. Last über Kopf.
Ausfallschritte (Medizinball, rückwärts, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückwärts: schonender für die Knie. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, seitlich, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlicher Ausfallschritt: Adduktoren. Last vor der Brust.
Ausfallschritte (Medizinball, seitlich, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlicher Ausfallschritt: Adduktoren. Last vorn.
Ausfallschritte (Medizinball, seitlich, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlicher Ausfallschritt: Adduktoren. Last über Kopf.
Ausfallschritte (Medizinball, seitlich, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlicher Ausfallschritt: Adduktoren. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, über Kreuz (Curtsy), Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal hinter dem Standbein. Last vor der Brust.
Ausfallschritte (Medizinball, über Kreuz (Curtsy), Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal hinter dem Standbein. Last vorn.
Ausfallschritte (Medizinball, über Kreuz (Curtsy), Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal hinter dem Standbein. Last über Kopf.
Ausfallschritte (Medizinball, über Kreuz (Curtsy), mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal hinter dem Standbein. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, gehend (Walking), Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Gehen, Schritt für Schritt. Last vor der Brust.
Ausfallschritte (Medizinball, gehend (Walking), Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Gehen, Schritt für Schritt. Last vorn.
Ausfallschritte (Medizinball, gehend (Walking), Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Gehen, Schritt für Schritt. Last über Kopf.
Ausfallschritte (Medizinball, gehend (Walking), mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Gehen, Schritt für Schritt. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, statisch, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Am Platz, nur hoch und runter. Last vor der Brust.
Ausfallschritte (Medizinball, statisch, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Am Platz, nur hoch und runter. Last vorn.
Ausfallschritte (Medizinball, statisch, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Am Platz, nur hoch und runter. Last über Kopf.
Ausfallschritte (Medizinball, statisch, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Am Platz, nur hoch und runter. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, Deficit, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorderer Fuß erhöht. Last vor der Brust.
Ausfallschritte (Medizinball, Deficit, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorderer Fuß erhöht. Last vorn.
Ausfallschritte (Medizinball, Deficit, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorderer Fuß erhöht. Last über Kopf.
Ausfallschritte (Medizinball, Deficit, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Vorderer Fuß erhöht. Oberkörper zum vorderen Bein drehen.
Ausfallschritte (Medizinball, mit Sprung, Goblet)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sprung wechseln. Last vor der Brust.
Ausfallschritte (Medizinball, mit Sprung, Front-Rack)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sprung wechseln. Last vorn.
Ausfallschritte (Medizinball, mit Sprung, Overhead)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sprung wechseln. Last über Kopf.
Ausfallschritte (Medizinball, mit Sprung, mit Rotation)|73|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Sprung wechseln. Oberkörper zum vorderen Bein drehen.
Step-ups (Kurzhantel)|74|dumbbell|Gewichtsangabe pro Hantel eintragen.
Step-ups (Kurzhantel, niedrige Kiste)|74|dumbbell|Gewichtsangabe pro Hantel eintragen. Niedrig: Knie schonen.
Step-ups (Kurzhantel, hohe Kiste)|74|dumbbell|Gewichtsangabe pro Hantel eintragen. Hoch: mehr Gesäß.
Step-ups (Kurzhantel, seitlich)|74|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich aufsteigen.
Step-ups (Kurzhantel, mit Knieheben)|74|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben Knie heben.
Step-ups (Kurzhantel, abwärts (Step-down))|74|dumbbell|Gewichtsangabe pro Hantel eintragen. Langsam nach unten.
Step-ups (Langhantel)|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Step-ups (Langhantel, niedrige Kiste)|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Niedrig: Knie schonen.
Step-ups (Langhantel, hohe Kiste)|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Hoch: mehr Gesäß.
Step-ups (Langhantel, seitlich)|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitlich aufsteigen.
Step-ups (Langhantel, mit Knieheben)|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben Knie heben.
Step-ups (Langhantel, abwärts (Step-down))|74|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Langsam nach unten.
Step-ups (Körpergewicht)|74|none|
Step-ups (Körpergewicht, niedrige Kiste)|74|none|Niedrig: Knie schonen.
Step-ups (Körpergewicht, hohe Kiste)|74|none|Hoch: mehr Gesäß.
Step-ups (Körpergewicht, seitlich)|74|none|Seitlich aufsteigen.
Step-ups (Körpergewicht, mit Knieheben)|74|none|Oben Knie heben.
Step-ups (Körpergewicht, abwärts (Step-down))|74|none|Langsam nach unten.
Step-ups (Kettlebell)|74|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Step-ups (Kettlebell, niedrige Kiste)|74|kettlebell|Gewichtsangabe der Kettlebell eintragen. Niedrig: Knie schonen.
Step-ups (Kettlebell, hohe Kiste)|74|kettlebell|Gewichtsangabe der Kettlebell eintragen. Hoch: mehr Gesäß.
Step-ups (Kettlebell, seitlich)|74|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich aufsteigen.
Step-ups (Kettlebell, mit Knieheben)|74|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben Knie heben.
Step-ups (Kettlebell, abwärts (Step-down))|74|kettlebell|Gewichtsangabe der Kettlebell eintragen. Langsam nach unten.
Step-ups (Widerstandsband)|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Step-ups (Widerstandsband, niedrige Kiste)|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Niedrig: Knie schonen.
Step-ups (Widerstandsband, hohe Kiste)|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hoch: mehr Gesäß.
Step-ups (Widerstandsband, seitlich)|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich aufsteigen.
Step-ups (Widerstandsband, mit Knieheben)|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben Knie heben.
Step-ups (Widerstandsband, abwärts (Step-down))|74|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam nach unten.
Beinpresse (Maschine)|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Beinpresse (Maschine, Füße hoch (Gesäß))|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße hoch: mehr Gesäß und Beinbeuger.
Beinpresse (Maschine, Füße tief (Quadrizeps))|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße tief: mehr Oberschenkel vorn.
Beinpresse (Maschine, Füße breit (Adduktoren))|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breit: Adduktoren.
Beinpresse (Maschine, Füße eng)|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eng.
Beinpresse (Maschine, einbeinig)|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Beinpresse (Maschine, 45° Schlitten)|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Schlittenpresse 45°.
Beinpresse (Maschine, horizontal)|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Waagerechte Presse.
Beinpresse (Maschine, Pause unten (2 s))|75|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden.
Hackenschmidt-Kniebeuge (Maschine)|76|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Hackenschmidt-Kniebeuge (Maschine, Füße eng)|76|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Eng.
Hackenschmidt-Kniebeuge (Maschine, Füße breit)|76|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Breit.
Hackenschmidt-Kniebeuge (Maschine, Füße hoch)|76|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Hoch.
Hackenschmidt-Kniebeuge (Langhantel)|76|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Hackenschmidt-Kniebeuge (Langhantel, Füße eng)|76|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Eng.
Hackenschmidt-Kniebeuge (Langhantel, Füße breit)|76|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Breit.
Hackenschmidt-Kniebeuge (Langhantel, Füße hoch)|76|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Hoch.
Beinstrecker (Maschine)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Beinstrecker (Maschine, beidbeinig)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beide Beine.
Beinstrecker (Maschine, einbeinig)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Beinstrecker (Maschine, Pause oben (2 s))|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden.
Beinstrecker (Maschine, Zehen nach innen)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach innen: Außenkopf.
Beinstrecker (Maschine, Zehen nach außen)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach außen: Innenkopf.
Beinstrecker (Maschine, Pause unten (2 s))|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinstrecker (Maschine, langsames Tempo (4-1-1))|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinstrecker (Maschine, explosiv heben)|77|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Beinstrecker (Widerstandsband)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Beinstrecker (Widerstandsband, beidbeinig)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Beine.
Beinstrecker (Widerstandsband, einbeinig)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Beinstrecker (Widerstandsband, Pause oben (2 s))|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden.
Beinstrecker (Widerstandsband, Zehen nach innen)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach innen: Außenkopf.
Beinstrecker (Widerstandsband, Zehen nach außen)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach außen: Innenkopf.
Beinstrecker (Widerstandsband, Pause unten (2 s))|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinstrecker (Widerstandsband, langsames Tempo (4-1-1))|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinstrecker (Widerstandsband, explosiv heben)|77|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Beinstrecker (Kabelzug)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Beinstrecker (Kabelzug, beidbeinig)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Beine.
Beinstrecker (Kabelzug, einbeinig)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Bein.
Beinstrecker (Kabelzug, Pause oben (2 s))|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden.
Beinstrecker (Kabelzug, Zehen nach innen)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zehen nach innen: Außenkopf.
Beinstrecker (Kabelzug, Zehen nach außen)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zehen nach außen: Innenkopf.
Beinstrecker (Kabelzug, Pause unten (2 s))|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinstrecker (Kabelzug, langsames Tempo (4-1-1))|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinstrecker (Kabelzug, explosiv heben)|77|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Sissy Squat (Körpergewicht)|78|none|
Sissy Squat (Körpergewicht, an der Wand)|78|none|Stütze an der Wand.
Sissy Squat (Körpergewicht, mit Stütze)|78|none|Mit Halt.
Sissy Squat (Körpergewicht, freistehend)|78|none|Frei.
Sissy Squat (Maschine)|78|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Sissy Squat (Maschine, an der Wand)|78|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stütze an der Wand.
Sissy Squat (Maschine, mit Stütze)|78|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Halt.
Sissy Squat (Maschine, freistehend)|78|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Frei.
Wall Sit (Körpergewicht)|79|none|
Wall Sit (Körpergewicht, beidbeinig)|79|none|Beide Beine.
Wall Sit (Körpergewicht, einbeinig)|79|none|Ein Bein.
Wall Sit (Körpergewicht, Ball zwischen den Knien)|79|none|Ball halten.
Wall Sit (Kurzhantel)|79|dumbbell|Gewichtsangabe pro Hantel eintragen.
Wall Sit (Kurzhantel, beidbeinig)|79|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Beine.
Wall Sit (Kurzhantel, einbeinig)|79|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein.
Wall Sit (Kurzhantel, Ball zwischen den Knien)|79|dumbbell|Gewichtsangabe pro Hantel eintragen. Ball halten.
Wall Sit (Medizinball)|79|medball|Ball nach Technik wählen, lieber leicht und sauber.
Wall Sit (Medizinball, beidbeinig)|79|medball|Ball nach Technik wählen, lieber leicht und sauber. Beide Beine.
Wall Sit (Medizinball, einbeinig)|79|medball|Ball nach Technik wählen, lieber leicht und sauber. Ein Bein.
Wall Sit (Medizinball, Ball zwischen den Knien)|79|medball|Ball nach Technik wählen, lieber leicht und sauber. Ball halten.
Beinbeuger (Maschine)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Beinbeuger (Maschine, liegend)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Liegend.
Beinbeuger (Maschine, sitzend)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Beinbeuger (Maschine, stehend einbeinig)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend, ein Bein.
Beinbeuger (Maschine, Zehen nach innen)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach innen.
Beinbeuger (Maschine, Zehen nach außen)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach außen.
Beinbeuger (Maschine, Pause (2 s))|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Pause.
Beinbeuger (Maschine, Pause unten (2 s))|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinbeuger (Maschine, langsames Tempo (4-1-1))|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinbeuger (Maschine, explosiv heben)|80|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Beinbeuger (Kabelzug)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Beinbeuger (Kabelzug, liegend)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Liegend.
Beinbeuger (Kabelzug, sitzend)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Beinbeuger (Kabelzug, stehend einbeinig)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend, ein Bein.
Beinbeuger (Kabelzug, Zehen nach innen)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zehen nach innen.
Beinbeuger (Kabelzug, Zehen nach außen)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Zehen nach außen.
Beinbeuger (Kabelzug, Pause (2 s))|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Pause.
Beinbeuger (Kabelzug, Pause unten (2 s))|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinbeuger (Kabelzug, langsames Tempo (4-1-1))|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinbeuger (Kabelzug, explosiv heben)|80|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Beinbeuger (Widerstandsband)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Beinbeuger (Widerstandsband, liegend)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Liegend.
Beinbeuger (Widerstandsband, sitzend)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Beinbeuger (Widerstandsband, stehend einbeinig)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend, ein Bein.
Beinbeuger (Widerstandsband, Zehen nach innen)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach innen.
Beinbeuger (Widerstandsband, Zehen nach außen)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach außen.
Beinbeuger (Widerstandsband, Pause (2 s))|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Pause.
Beinbeuger (Widerstandsband, Pause unten (2 s))|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinbeuger (Widerstandsband, langsames Tempo (4-1-1))|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinbeuger (Widerstandsband, explosiv heben)|80|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Beinbeuger (Kurzhantel)|80|dumbbell|Gewichtsangabe pro Hantel eintragen.
Beinbeuger (Kurzhantel, liegend)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Liegend.
Beinbeuger (Kurzhantel, sitzend)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend.
Beinbeuger (Kurzhantel, stehend einbeinig)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend, ein Bein.
Beinbeuger (Kurzhantel, Zehen nach innen)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Zehen nach innen.
Beinbeuger (Kurzhantel, Zehen nach außen)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Zehen nach außen.
Beinbeuger (Kurzhantel, Pause (2 s))|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Pause.
Beinbeuger (Kurzhantel, Pause unten (2 s))|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Beinbeuger (Kurzhantel, langsames Tempo (4-1-1))|80|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Beinbeuger (Kurzhantel, explosiv heben)|80|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Nordic Curl (Körpergewicht)|81|none|
Nordic Curl (Körpergewicht, Negativ)|81|none|Nur nach vorn sinken.
Nordic Curl (Körpergewicht, mit Band-Hilfe)|81|none|Mit Bandhilfe.
Nordic Curl (Körpergewicht, voll)|81|none|Mit Hochdrücken.
Nordic Curl (Widerstandsband)|81|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Nordic Curl (Widerstandsband, Negativ)|81|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur nach vorn sinken.
Nordic Curl (Widerstandsband, mit Band-Hilfe)|81|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Bandhilfe.
Nordic Curl (Widerstandsband, voll)|81|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Hochdrücken.
Nordic Curl (Maschine)|81|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Nordic Curl (Maschine, Negativ)|81|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Nur nach vorn sinken.
Nordic Curl (Maschine, mit Band-Hilfe)|81|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Bandhilfe.
Nordic Curl (Maschine, voll)|81|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Hochdrücken.
Hip Thrust (Langhantel)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Hip Thrust (Langhantel, beidbeinig)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beide Beine.
Hip Thrust (Langhantel, einbeinig)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ein Bein.
Hip Thrust (Langhantel, Pause oben (3 s))|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 3 Sekunden halten.
Hip Thrust (Langhantel, Füße weit)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Langhantel, Füße eng)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße eng: mehr Quadrizeps.
Hip Thrust (Langhantel, Schultern auf Boden (Glute Bridge))|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rücken auf dem Boden.
Hip Thrust (Langhantel, auf Schrägbank)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf schräger Fläche.
Hip Thrust (Langhantel, Pause unten (2 s))|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Langhantel, langsames Tempo (4-1-1))|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Langhantel, explosiv heben)|82|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Kurzhantel)|82|dumbbell|Gewichtsangabe pro Hantel eintragen.
Hip Thrust (Kurzhantel, beidbeinig)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Beine.
Hip Thrust (Kurzhantel, einbeinig)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein.
Hip Thrust (Kurzhantel, Pause oben (3 s))|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 3 Sekunden halten.
Hip Thrust (Kurzhantel, Füße weit)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Kurzhantel, Füße eng)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße eng: mehr Quadrizeps.
Hip Thrust (Kurzhantel, Schultern auf Boden (Glute Bridge))|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Rücken auf dem Boden.
Hip Thrust (Kurzhantel, auf Schrägbank)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf schräger Fläche.
Hip Thrust (Kurzhantel, Pause unten (2 s))|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Kurzhantel, langsames Tempo (4-1-1))|82|dumbbell|Gewichtsangabe pro Hantel eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Kurzhantel, explosiv heben)|82|dumbbell|Gewichtsangabe pro Hantel eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Multipresse)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Hip Thrust (Multipresse, beidbeinig)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Beide Beine.
Hip Thrust (Multipresse, einbeinig)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Ein Bein.
Hip Thrust (Multipresse, Pause oben (3 s))|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Oben 3 Sekunden halten.
Hip Thrust (Multipresse, Füße weit)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Multipresse, Füße eng)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Füße eng: mehr Quadrizeps.
Hip Thrust (Multipresse, Schultern auf Boden (Glute Bridge))|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Rücken auf dem Boden.
Hip Thrust (Multipresse, auf Schrägbank)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf schräger Fläche.
Hip Thrust (Multipresse, Pause unten (2 s))|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Multipresse, langsames Tempo (4-1-1))|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Multipresse, explosiv heben)|82|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Maschine)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Hip Thrust (Maschine, beidbeinig)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beide Beine.
Hip Thrust (Maschine, einbeinig)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Hip Thrust (Maschine, Pause oben (3 s))|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 3 Sekunden halten.
Hip Thrust (Maschine, Füße weit)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Maschine, Füße eng)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße eng: mehr Quadrizeps.
Hip Thrust (Maschine, Schultern auf Boden (Glute Bridge))|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Rücken auf dem Boden.
Hip Thrust (Maschine, auf Schrägbank)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf schräger Fläche.
Hip Thrust (Maschine, Pause unten (2 s))|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Maschine, langsames Tempo (4-1-1))|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Maschine, explosiv heben)|82|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Körpergewicht)|82|none|
Hip Thrust (Körpergewicht, beidbeinig)|82|none|Beide Beine.
Hip Thrust (Körpergewicht, einbeinig)|82|none|Ein Bein.
Hip Thrust (Körpergewicht, Pause oben (3 s))|82|none|Oben 3 Sekunden halten.
Hip Thrust (Körpergewicht, Füße weit)|82|none|Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Körpergewicht, Füße eng)|82|none|Füße eng: mehr Quadrizeps.
Hip Thrust (Körpergewicht, Schultern auf Boden (Glute Bridge))|82|none|Rücken auf dem Boden.
Hip Thrust (Körpergewicht, auf Schrägbank)|82|none|Auf schräger Fläche.
Hip Thrust (Körpergewicht, Pause unten (2 s))|82|none|Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Körpergewicht, langsames Tempo (4-1-1))|82|none|4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Körpergewicht, explosiv heben)|82|none|Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Widerstandsband)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Hip Thrust (Widerstandsband, beidbeinig)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Beine.
Hip Thrust (Widerstandsband, einbeinig)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Hip Thrust (Widerstandsband, Pause oben (3 s))|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 3 Sekunden halten.
Hip Thrust (Widerstandsband, Füße weit)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Widerstandsband, Füße eng)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße eng: mehr Quadrizeps.
Hip Thrust (Widerstandsband, Schultern auf Boden (Glute Bridge))|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rücken auf dem Boden.
Hip Thrust (Widerstandsband, auf Schrägbank)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf schräger Fläche.
Hip Thrust (Widerstandsband, Pause unten (2 s))|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Widerstandsband, langsames Tempo (4-1-1))|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Widerstandsband, explosiv heben)|82|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Kettlebell)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Hip Thrust (Kettlebell, beidbeinig)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beide Beine.
Hip Thrust (Kettlebell, einbeinig)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ein Bein.
Hip Thrust (Kettlebell, Pause oben (3 s))|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 3 Sekunden halten.
Hip Thrust (Kettlebell, Füße weit)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Kettlebell, Füße eng)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße eng: mehr Quadrizeps.
Hip Thrust (Kettlebell, Schultern auf Boden (Glute Bridge))|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rücken auf dem Boden.
Hip Thrust (Kettlebell, auf Schrägbank)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf schräger Fläche.
Hip Thrust (Kettlebell, Pause unten (2 s))|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Kettlebell, langsames Tempo (4-1-1))|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Kettlebell, explosiv heben)|82|kettlebell|Gewichtsangabe der Kettlebell eintragen. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Hip Thrust (Kabelzug)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Hip Thrust (Kabelzug, beidbeinig)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beide Beine.
Hip Thrust (Kabelzug, einbeinig)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ein Bein.
Hip Thrust (Kabelzug, Pause oben (3 s))|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 3 Sekunden halten.
Hip Thrust (Kabelzug, Füße weit)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Füße weit: Beinbeuger und Gesäß.
Hip Thrust (Kabelzug, Füße eng)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Füße eng: mehr Quadrizeps.
Hip Thrust (Kabelzug, Schultern auf Boden (Glute Bridge))|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rücken auf dem Boden.
Hip Thrust (Kabelzug, auf Schrägbank)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf schräger Fläche.
Hip Thrust (Kabelzug, Pause unten (2 s))|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Unten 2 Sekunden still halten, ohne Spannung zu verlieren.
Hip Thrust (Kabelzug, langsames Tempo (4-1-1))|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 4 Sekunden senken, 1 Sekunde unten, 1 Sekunde heben.
Hip Thrust (Kabelzug, explosiv heben)|82|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufwärts kräftig und kontrolliert beschleunigen, abwärts ruhig.
Glute Bridge (Körpergewicht)|83|none|
Glute Bridge (Körpergewicht, beidbeinig)|83|none|Beide Beine.
Glute Bridge (Körpergewicht, einbeinig)|83|none|Ein Bein.
Glute Bridge (Körpergewicht, Füße erhöht)|83|none|Füße auf Bank: mehr Last.
Glute Bridge (Körpergewicht, Pause oben (3 s))|83|none|Oben 3 Sekunden.
Glute Bridge (Körpergewicht, Marsch (Hüfte oben))|83|none|Abwechselnd Beine heben.
Glute Bridge (Körpergewicht, Fersen heben)|83|none|Fersen leicht angehoben.
Glute Bridge (Widerstandsband)|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Glute Bridge (Widerstandsband, beidbeinig)|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Beine.
Glute Bridge (Widerstandsband, einbeinig)|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Glute Bridge (Widerstandsband, Füße erhöht)|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße auf Bank: mehr Last.
Glute Bridge (Widerstandsband, Pause oben (3 s))|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 3 Sekunden.
Glute Bridge (Widerstandsband, Marsch (Hüfte oben))|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Abwechselnd Beine heben.
Glute Bridge (Widerstandsband, Fersen heben)|83|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Fersen leicht angehoben.
Glute Bridge (Kurzhantel)|83|dumbbell|Gewichtsangabe pro Hantel eintragen.
Glute Bridge (Kurzhantel, beidbeinig)|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Beine.
Glute Bridge (Kurzhantel, einbeinig)|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein.
Glute Bridge (Kurzhantel, Füße erhöht)|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße auf Bank: mehr Last.
Glute Bridge (Kurzhantel, Pause oben (3 s))|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 3 Sekunden.
Glute Bridge (Kurzhantel, Marsch (Hüfte oben))|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Abwechselnd Beine heben.
Glute Bridge (Kurzhantel, Fersen heben)|83|dumbbell|Gewichtsangabe pro Hantel eintragen. Fersen leicht angehoben.
Glute Bridge (Langhantel)|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Glute Bridge (Langhantel, beidbeinig)|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beide Beine.
Glute Bridge (Langhantel, einbeinig)|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ein Bein.
Glute Bridge (Langhantel, Füße erhöht)|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Füße auf Bank: mehr Last.
Glute Bridge (Langhantel, Pause oben (3 s))|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 3 Sekunden.
Glute Bridge (Langhantel, Marsch (Hüfte oben))|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Abwechselnd Beine heben.
Glute Bridge (Langhantel, Fersen heben)|83|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Fersen leicht angehoben.
Glute Bridge (Schlingentrainer)|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Glute Bridge (Schlingentrainer, beidbeinig)|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Beide Beine.
Glute Bridge (Schlingentrainer, einbeinig)|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Ein Bein.
Glute Bridge (Schlingentrainer, Füße erhöht)|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße auf Bank: mehr Last.
Glute Bridge (Schlingentrainer, Pause oben (3 s))|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Oben 3 Sekunden.
Glute Bridge (Schlingentrainer, Marsch (Hüfte oben))|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Abwechselnd Beine heben.
Glute Bridge (Schlingentrainer, Fersen heben)|83|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Fersen leicht angehoben.
Glute Bridge (Medizinball)|83|medball|Ball nach Technik wählen, lieber leicht und sauber.
Glute Bridge (Medizinball, beidbeinig)|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Beide Beine.
Glute Bridge (Medizinball, einbeinig)|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Ein Bein.
Glute Bridge (Medizinball, Füße erhöht)|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Füße auf Bank: mehr Last.
Glute Bridge (Medizinball, Pause oben (3 s))|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Oben 3 Sekunden.
Glute Bridge (Medizinball, Marsch (Hüfte oben))|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Abwechselnd Beine heben.
Glute Bridge (Medizinball, Fersen heben)|83|medball|Ball nach Technik wählen, lieber leicht und sauber. Fersen leicht angehoben.
Kickback (Kabelzug)|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Kickback (Kabelzug, stehend)|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Kickback (Kabelzug, im Vierfüßler)|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vierfüßler.
Kickback (Kabelzug, Esel (Donkey Kick))|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Knie angewinkelt, Fuß zur Decke.
Kickback (Kabelzug, Fire Hydrant)|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Knie zur Seite öffnen.
Kickback (Kabelzug, mit Pause)|84|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Pause.
Kickback (Widerstandsband)|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Kickback (Widerstandsband, stehend)|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Kickback (Widerstandsband, im Vierfüßler)|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vierfüßler.
Kickback (Widerstandsband, Esel (Donkey Kick))|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie angewinkelt, Fuß zur Decke.
Kickback (Widerstandsband, Fire Hydrant)|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie zur Seite öffnen.
Kickback (Widerstandsband, mit Pause)|84|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Pause.
Kickback (Maschine)|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Kickback (Maschine, stehend)|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Kickback (Maschine, im Vierfüßler)|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Vierfüßler.
Kickback (Maschine, Esel (Donkey Kick))|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Knie angewinkelt, Fuß zur Decke.
Kickback (Maschine, Fire Hydrant)|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Knie zur Seite öffnen.
Kickback (Maschine, mit Pause)|84|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Pause.
Kickback (Körpergewicht)|84|none|
Kickback (Körpergewicht, stehend)|84|none|Stehend.
Kickback (Körpergewicht, im Vierfüßler)|84|none|Vierfüßler.
Kickback (Körpergewicht, Esel (Donkey Kick))|84|none|Knie angewinkelt, Fuß zur Decke.
Kickback (Körpergewicht, Fire Hydrant)|84|none|Knie zur Seite öffnen.
Kickback (Körpergewicht, mit Pause)|84|none|Pause.
Abduktion (Maschine)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Abduktion (Maschine, stehend)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Abduktion (Maschine, sitzend)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Abduktion (Maschine, seitlich liegend)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlage.
Abduktion (Maschine, Clamshell)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlage, Knie öffnen wie eine Muschel.
Abduktion (Maschine, Monster Walk)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Band um die Knöchel seitlich gehen.
Abduktion (Maschine, Fire Hydrant)|85|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Vierfüßler, Knie zur Seite.
Abduktion (Kabelzug)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Abduktion (Kabelzug, stehend)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Abduktion (Kabelzug, sitzend)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Abduktion (Kabelzug, seitlich liegend)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlage.
Abduktion (Kabelzug, Clamshell)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlage, Knie öffnen wie eine Muschel.
Abduktion (Kabelzug, Monster Walk)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Mit Band um die Knöchel seitlich gehen.
Abduktion (Kabelzug, Fire Hydrant)|85|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Vierfüßler, Knie zur Seite.
Abduktion (Widerstandsband)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Abduktion (Widerstandsband, stehend)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Abduktion (Widerstandsband, sitzend)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Abduktion (Widerstandsband, seitlich liegend)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage.
Abduktion (Widerstandsband, Clamshell)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage, Knie öffnen wie eine Muschel.
Abduktion (Widerstandsband, Monster Walk)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Band um die Knöchel seitlich gehen.
Abduktion (Widerstandsband, Fire Hydrant)|85|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vierfüßler, Knie zur Seite.
Abduktion (Körpergewicht)|85|none|
Abduktion (Körpergewicht, stehend)|85|none|Stehend.
Abduktion (Körpergewicht, sitzend)|85|none|Sitzend.
Abduktion (Körpergewicht, seitlich liegend)|85|none|Seitlage.
Abduktion (Körpergewicht, Clamshell)|85|none|Seitlage, Knie öffnen wie eine Muschel.
Abduktion (Körpergewicht, Monster Walk)|85|none|Mit Band um die Knöchel seitlich gehen.
Abduktion (Körpergewicht, Fire Hydrant)|85|none|Vierfüßler, Knie zur Seite.
Adduktion (Maschine)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Adduktion (Maschine, sitzend)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Adduktion (Maschine, stehend)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Adduktion (Maschine, seitlich liegend)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlage, oberes Bein vorn.
Adduktion (Maschine, Copenhagen Plank)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitstütz, oberes Bein auf Bank.
Adduktion (Maschine, mit Ball)|86|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ball zwischen den Knien drücken.
Adduktion (Kabelzug)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Adduktion (Kabelzug, sitzend)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Adduktion (Kabelzug, stehend)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Adduktion (Kabelzug, seitlich liegend)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlage, oberes Bein vorn.
Adduktion (Kabelzug, Copenhagen Plank)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitstütz, oberes Bein auf Bank.
Adduktion (Kabelzug, mit Ball)|86|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ball zwischen den Knien drücken.
Adduktion (Widerstandsband)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Adduktion (Widerstandsband, sitzend)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Adduktion (Widerstandsband, stehend)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Adduktion (Widerstandsband, seitlich liegend)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage, oberes Bein vorn.
Adduktion (Widerstandsband, Copenhagen Plank)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitstütz, oberes Bein auf Bank.
Adduktion (Widerstandsband, mit Ball)|86|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ball zwischen den Knien drücken.
Adduktion (Körpergewicht)|86|none|
Adduktion (Körpergewicht, sitzend)|86|none|Sitzend.
Adduktion (Körpergewicht, stehend)|86|none|Stehend.
Adduktion (Körpergewicht, seitlich liegend)|86|none|Seitlage, oberes Bein vorn.
Adduktion (Körpergewicht, Copenhagen Plank)|86|none|Seitstütz, oberes Bein auf Bank.
Adduktion (Körpergewicht, mit Ball)|86|none|Ball zwischen den Knien drücken.
Adduktion (Medizinball)|86|medball|Ball nach Technik wählen, lieber leicht und sauber.
Adduktion (Medizinball, sitzend)|86|medball|Ball nach Technik wählen, lieber leicht und sauber. Sitzend.
Adduktion (Medizinball, stehend)|86|medball|Ball nach Technik wählen, lieber leicht und sauber. Stehend.
Adduktion (Medizinball, seitlich liegend)|86|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlage, oberes Bein vorn.
Adduktion (Medizinball, Copenhagen Plank)|86|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitstütz, oberes Bein auf Bank.
Adduktion (Medizinball, mit Ball)|86|medball|Ball nach Technik wählen, lieber leicht und sauber. Ball zwischen den Knien drücken.
Frosch-Pumps (Körpergewicht)|87|none|
Frosch-Pumps (Körpergewicht, Rückenlage)|87|none|Auf dem Rücken.
Frosch-Pumps (Körpergewicht, mit Gewicht)|87|none|Mit Gewicht auf der Hüfte.
Frosch-Pumps (Widerstandsband)|87|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Frosch-Pumps (Widerstandsband, Rückenlage)|87|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf dem Rücken.
Frosch-Pumps (Widerstandsband, mit Gewicht)|87|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Gewicht auf der Hüfte.
Frosch-Pumps (Kurzhantel)|87|dumbbell|Gewichtsangabe pro Hantel eintragen.
Frosch-Pumps (Kurzhantel, Rückenlage)|87|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf dem Rücken.
Frosch-Pumps (Kurzhantel, mit Gewicht)|87|dumbbell|Gewichtsangabe pro Hantel eintragen. Mit Gewicht auf der Hüfte.
Cossack-Ausfallschritt (Körpergewicht)|88|none|
Cossack-Ausfallschritt (Körpergewicht, statisch)|88|none|Statisch.
Cossack-Ausfallschritt (Körpergewicht, Goblet)|88|none|Last vor der Brust.
Cossack-Ausfallschritt (Körpergewicht, mit Sprung)|88|none|Seitenwechsel im Sprung.
Cossack-Ausfallschritt (Kettlebell)|88|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Cossack-Ausfallschritt (Kettlebell, statisch)|88|kettlebell|Gewichtsangabe der Kettlebell eintragen. Statisch.
Cossack-Ausfallschritt (Kettlebell, Goblet)|88|kettlebell|Gewichtsangabe der Kettlebell eintragen. Last vor der Brust.
Cossack-Ausfallschritt (Kettlebell, mit Sprung)|88|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitenwechsel im Sprung.
Cossack-Ausfallschritt (Kurzhantel)|88|dumbbell|Gewichtsangabe pro Hantel eintragen.
Cossack-Ausfallschritt (Kurzhantel, statisch)|88|dumbbell|Gewichtsangabe pro Hantel eintragen. Statisch.
Cossack-Ausfallschritt (Kurzhantel, Goblet)|88|dumbbell|Gewichtsangabe pro Hantel eintragen. Last vor der Brust.
Cossack-Ausfallschritt (Kurzhantel, mit Sprung)|88|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitenwechsel im Sprung.
Wadenheben (Körpergewicht)|89|none|
Wadenheben (Körpergewicht, stehend)|89|none|Stehend: äußerer Wadenmuskel.
Wadenheben (Körpergewicht, sitzend)|89|none|Sitzend: tiefer Wadenmuskel.
Wadenheben (Körpergewicht, einbeinig)|89|none|Ein Bein.
Wadenheben (Körpergewicht, auf Stufe)|89|none|Auf einer Stufe für mehr Weg.
Wadenheben (Körpergewicht, Zehen nach innen)|89|none|Zehen nach innen.
Wadenheben (Körpergewicht, Zehen nach außen)|89|none|Zehen nach außen.
Wadenheben (Körpergewicht, Pause oben (3 s))|89|none|Oben 3 Sekunden.
Wadenheben (Körpergewicht, langsam (4-1-1))|89|none|Langsam.
Wadenheben (Kurzhantel)|89|dumbbell|Gewichtsangabe pro Hantel eintragen.
Wadenheben (Kurzhantel, stehend)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend: äußerer Wadenmuskel.
Wadenheben (Kurzhantel, sitzend)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Sitzend: tiefer Wadenmuskel.
Wadenheben (Kurzhantel, einbeinig)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Ein Bein.
Wadenheben (Kurzhantel, auf Stufe)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf einer Stufe für mehr Weg.
Wadenheben (Kurzhantel, Zehen nach innen)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Zehen nach innen.
Wadenheben (Kurzhantel, Zehen nach außen)|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Zehen nach außen.
Wadenheben (Kurzhantel, Pause oben (3 s))|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 3 Sekunden.
Wadenheben (Kurzhantel, langsam (4-1-1))|89|dumbbell|Gewichtsangabe pro Hantel eintragen. Langsam.
Wadenheben (Langhantel)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Wadenheben (Langhantel, stehend)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Stehend: äußerer Wadenmuskel.
Wadenheben (Langhantel, sitzend)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Sitzend: tiefer Wadenmuskel.
Wadenheben (Langhantel, einbeinig)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ein Bein.
Wadenheben (Langhantel, auf Stufe)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf einer Stufe für mehr Weg.
Wadenheben (Langhantel, Zehen nach innen)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Zehen nach innen.
Wadenheben (Langhantel, Zehen nach außen)|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Zehen nach außen.
Wadenheben (Langhantel, Pause oben (3 s))|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Oben 3 Sekunden.
Wadenheben (Langhantel, langsam (4-1-1))|89|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Langsam.
Wadenheben (Maschine)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Wadenheben (Maschine, stehend)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend: äußerer Wadenmuskel.
Wadenheben (Maschine, sitzend)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend: tiefer Wadenmuskel.
Wadenheben (Maschine, einbeinig)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Wadenheben (Maschine, auf Stufe)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf einer Stufe für mehr Weg.
Wadenheben (Maschine, Zehen nach innen)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach innen.
Wadenheben (Maschine, Zehen nach außen)|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Zehen nach außen.
Wadenheben (Maschine, Pause oben (3 s))|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 3 Sekunden.
Wadenheben (Maschine, langsam (4-1-1))|89|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Langsam.
Wadenheben (Multipresse)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen.
Wadenheben (Multipresse, stehend)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Stehend: äußerer Wadenmuskel.
Wadenheben (Multipresse, sitzend)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Sitzend: tiefer Wadenmuskel.
Wadenheben (Multipresse, einbeinig)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Ein Bein.
Wadenheben (Multipresse, auf Stufe)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Auf einer Stufe für mehr Weg.
Wadenheben (Multipresse, Zehen nach innen)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Zehen nach innen.
Wadenheben (Multipresse, Zehen nach außen)|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Zehen nach außen.
Wadenheben (Multipresse, Pause oben (3 s))|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Oben 3 Sekunden.
Wadenheben (Multipresse, langsam (4-1-1))|89|machine|Die Führung der Multipresse nimmt Stabilisation ab, Fußposition bewusst wählen. Langsam.
Wadenheben (Kettlebell)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Wadenheben (Kettlebell, stehend)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend: äußerer Wadenmuskel.
Wadenheben (Kettlebell, sitzend)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Sitzend: tiefer Wadenmuskel.
Wadenheben (Kettlebell, einbeinig)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ein Bein.
Wadenheben (Kettlebell, auf Stufe)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf einer Stufe für mehr Weg.
Wadenheben (Kettlebell, Zehen nach innen)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Zehen nach innen.
Wadenheben (Kettlebell, Zehen nach außen)|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Zehen nach außen.
Wadenheben (Kettlebell, Pause oben (3 s))|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Oben 3 Sekunden.
Wadenheben (Kettlebell, langsam (4-1-1))|89|kettlebell|Gewichtsangabe der Kettlebell eintragen. Langsam.
Wadenheben (Widerstandsband)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Wadenheben (Widerstandsband, stehend)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend: äußerer Wadenmuskel.
Wadenheben (Widerstandsband, sitzend)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend: tiefer Wadenmuskel.
Wadenheben (Widerstandsband, einbeinig)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Wadenheben (Widerstandsband, auf Stufe)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf einer Stufe für mehr Weg.
Wadenheben (Widerstandsband, Zehen nach innen)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach innen.
Wadenheben (Widerstandsband, Zehen nach außen)|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen nach außen.
Wadenheben (Widerstandsband, Pause oben (3 s))|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 3 Sekunden.
Wadenheben (Widerstandsband, langsam (4-1-1))|89|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam.
Wadenheben an der Beinpresse (Maschine)|90|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Wadenheben an der Beinpresse (Maschine, beidbeinig)|90|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beide.
Wadenheben an der Beinpresse (Maschine, einbeinig)|90|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Schienbein-Heben (Körpergewicht)|91|none|
Schienbein-Heben (Körpergewicht, an der Wand)|91|none|Wand.
Schienbein-Heben (Körpergewicht, sitzend)|91|none|Sitzend.
Schienbein-Heben (Körpergewicht, einbeinig)|91|none|Ein Bein.
Schienbein-Heben (Widerstandsband)|91|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Schienbein-Heben (Widerstandsband, an der Wand)|91|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Wand.
Schienbein-Heben (Widerstandsband, sitzend)|91|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Sitzend.
Schienbein-Heben (Widerstandsband, einbeinig)|91|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ein Bein.
Schienbein-Heben (Maschine)|91|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Schienbein-Heben (Maschine, an der Wand)|91|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Wand.
Schienbein-Heben (Maschine, sitzend)|91|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Schienbein-Heben (Maschine, einbeinig)|91|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Fußgewölbe-Training (Short Foot) (Körpergewicht)|92|none|
Fußgewölbe-Training (Short Foot) (Körpergewicht, im Sitzen)|92|none|Sitzend.
Fußgewölbe-Training (Short Foot) (Körpergewicht, im Stand)|92|none|Stehend.
Fußgewölbe-Training (Short Foot) (Körpergewicht, einbeinig)|92|none|Ein Bein.
Crunch (Körpergewicht)|93|none|
Crunch (Körpergewicht, klassisch)|93|none|Rückenlage, Füße aufgestellt.
Crunch (Körpergewicht, Beine hoch)|93|none|Beine in der Luft.
Crunch (Körpergewicht, Reverse (Becken heben))|93|none|Becken zur Brust.
Crunch (Körpergewicht, auf der Schrägbank)|93|none|Auf der Schrägbank: mehr Weg.
Crunch (Körpergewicht, Bicycle (Fahrrad))|93|none|Ellbogen zum Gegenknie.
Crunch (Körpergewicht, Vertical Leg)|93|none|Beine senkrecht nach oben, Becken heben.
Crunch (Körpergewicht, Pause oben (2 s))|93|none|Oben 2 Sekunden.
Crunch (Körpergewicht, Armen über Kopf)|93|none|Arme über dem Kopf.
Crunch (Körpergewicht, Sit-up)|93|none|Mit komplett aufrichten.
Crunch (Kabelzug)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Crunch (Kabelzug, klassisch)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Rückenlage, Füße aufgestellt.
Crunch (Kabelzug, Beine hoch)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beine in der Luft.
Crunch (Kabelzug, Reverse (Becken heben))|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Becken zur Brust.
Crunch (Kabelzug, auf der Schrägbank)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Schrägbank: mehr Weg.
Crunch (Kabelzug, Bicycle (Fahrrad))|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ellbogen zum Gegenknie.
Crunch (Kabelzug, Vertical Leg)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Beine senkrecht nach oben, Becken heben.
Crunch (Kabelzug, Pause oben (2 s))|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Oben 2 Sekunden.
Crunch (Kabelzug, Armen über Kopf)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme über dem Kopf.
Crunch (Kabelzug, Sit-up)|93|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Mit komplett aufrichten.
Crunch (Maschine)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Crunch (Maschine, klassisch)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Rückenlage, Füße aufgestellt.
Crunch (Maschine, Beine hoch)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beine in der Luft.
Crunch (Maschine, Reverse (Becken heben))|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Becken zur Brust.
Crunch (Maschine, auf der Schrägbank)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf der Schrägbank: mehr Weg.
Crunch (Maschine, Bicycle (Fahrrad))|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ellbogen zum Gegenknie.
Crunch (Maschine, Vertical Leg)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beine senkrecht nach oben, Becken heben.
Crunch (Maschine, Pause oben (2 s))|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Oben 2 Sekunden.
Crunch (Maschine, Armen über Kopf)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arme über dem Kopf.
Crunch (Maschine, Sit-up)|93|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit komplett aufrichten.
Crunch (Widerstandsband)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Crunch (Widerstandsband, klassisch)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rückenlage, Füße aufgestellt.
Crunch (Widerstandsband, Beine hoch)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beine in der Luft.
Crunch (Widerstandsband, Reverse (Becken heben))|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Becken zur Brust.
Crunch (Widerstandsband, auf der Schrägbank)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Schrägbank: mehr Weg.
Crunch (Widerstandsband, Bicycle (Fahrrad))|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ellbogen zum Gegenknie.
Crunch (Widerstandsband, Vertical Leg)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beine senkrecht nach oben, Becken heben.
Crunch (Widerstandsband, Pause oben (2 s))|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Oben 2 Sekunden.
Crunch (Widerstandsband, Armen über Kopf)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme über dem Kopf.
Crunch (Widerstandsband, Sit-up)|93|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit komplett aufrichten.
Crunch (Medizinball)|93|medball|Ball nach Technik wählen, lieber leicht und sauber.
Crunch (Medizinball, klassisch)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Rückenlage, Füße aufgestellt.
Crunch (Medizinball, Beine hoch)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine in der Luft.
Crunch (Medizinball, Reverse (Becken heben))|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Becken zur Brust.
Crunch (Medizinball, auf der Schrägbank)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Auf der Schrägbank: mehr Weg.
Crunch (Medizinball, Bicycle (Fahrrad))|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Ellbogen zum Gegenknie.
Crunch (Medizinball, Vertical Leg)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine senkrecht nach oben, Becken heben.
Crunch (Medizinball, Pause oben (2 s))|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Oben 2 Sekunden.
Crunch (Medizinball, Armen über Kopf)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Arme über dem Kopf.
Crunch (Medizinball, Sit-up)|93|medball|Ball nach Technik wählen, lieber leicht und sauber. Mit komplett aufrichten.
Crunch (Kurzhantel)|93|dumbbell|Gewichtsangabe pro Hantel eintragen.
Crunch (Kurzhantel, klassisch)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Rückenlage, Füße aufgestellt.
Crunch (Kurzhantel, Beine hoch)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Beine in der Luft.
Crunch (Kurzhantel, Reverse (Becken heben))|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Becken zur Brust.
Crunch (Kurzhantel, auf der Schrägbank)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Schrägbank: mehr Weg.
Crunch (Kurzhantel, Bicycle (Fahrrad))|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Ellbogen zum Gegenknie.
Crunch (Kurzhantel, Vertical Leg)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Beine senkrecht nach oben, Becken heben.
Crunch (Kurzhantel, Pause oben (2 s))|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Oben 2 Sekunden.
Crunch (Kurzhantel, Armen über Kopf)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme über dem Kopf.
Crunch (Kurzhantel, Sit-up)|93|dumbbell|Gewichtsangabe pro Hantel eintragen. Mit komplett aufrichten.
Crunch (Hantelscheibe)|93|barbell|Scheibe mit beiden Händen fest greifen.
Crunch (Hantelscheibe, klassisch)|93|barbell|Scheibe mit beiden Händen fest greifen. Rückenlage, Füße aufgestellt.
Crunch (Hantelscheibe, Beine hoch)|93|barbell|Scheibe mit beiden Händen fest greifen. Beine in der Luft.
Crunch (Hantelscheibe, Reverse (Becken heben))|93|barbell|Scheibe mit beiden Händen fest greifen. Becken zur Brust.
Crunch (Hantelscheibe, auf der Schrägbank)|93|barbell|Scheibe mit beiden Händen fest greifen. Auf der Schrägbank: mehr Weg.
Crunch (Hantelscheibe, Bicycle (Fahrrad))|93|barbell|Scheibe mit beiden Händen fest greifen. Ellbogen zum Gegenknie.
Crunch (Hantelscheibe, Vertical Leg)|93|barbell|Scheibe mit beiden Händen fest greifen. Beine senkrecht nach oben, Becken heben.
Crunch (Hantelscheibe, Pause oben (2 s))|93|barbell|Scheibe mit beiden Händen fest greifen. Oben 2 Sekunden.
Crunch (Hantelscheibe, Armen über Kopf)|93|barbell|Scheibe mit beiden Händen fest greifen. Arme über dem Kopf.
Crunch (Hantelscheibe, Sit-up)|93|barbell|Scheibe mit beiden Händen fest greifen. Mit komplett aufrichten.
Plank (Körpergewicht)|94|none|
Plank (Körpergewicht, auf den Unterarmen)|94|none|Auf den Unterarmen.
Plank (Körpergewicht, auf den Händen)|94|none|Hohe Plank.
Plank (Körpergewicht, Seitstütz links)|94|none|Seitlich, Körper gerade.
Plank (Körpergewicht, Seitstütz rechts)|94|none|Seitlich.
Plank (Körpergewicht, mit Beinheben)|94|none|Abwechselnd ein Bein heben.
Plank (Körpergewicht, mit Armheben)|94|none|Abwechselnd Arm heben.
Plank (Körpergewicht, Füße erhöht)|94|none|Füße erhöht.
Plank (Körpergewicht, RKC (maximale Spannung))|94|none|Alles maximal anspannen, kurz halten.
Plank (Körpergewicht, Plank Jacks)|94|none|Füße springen auseinander.
Plank (Körpergewicht, Bergsteiger)|94|none|Knie zur Brust im Wechsel.
Plank (Körpergewicht, Schulterklopfen)|94|none|Hände klopfen abwechselnd die Schulter.
Plank (Körpergewicht, Gewicht aufgelegt)|94|none|Scheibe auf dem Rücken.
Plank (Schlingentrainer)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Plank (Schlingentrainer, auf den Unterarmen)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Unterarmen.
Plank (Schlingentrainer, auf den Händen)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hohe Plank.
Plank (Schlingentrainer, Seitstütz links)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Seitlich, Körper gerade.
Plank (Schlingentrainer, Seitstütz rechts)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Seitlich.
Plank (Schlingentrainer, mit Beinheben)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Abwechselnd ein Bein heben.
Plank (Schlingentrainer, mit Armheben)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Abwechselnd Arm heben.
Plank (Schlingentrainer, Füße erhöht)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße erhöht.
Plank (Schlingentrainer, RKC (maximale Spannung))|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Alles maximal anspannen, kurz halten.
Plank (Schlingentrainer, Plank Jacks)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße springen auseinander.
Plank (Schlingentrainer, Bergsteiger)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Knie zur Brust im Wechsel.
Plank (Schlingentrainer, Schulterklopfen)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände klopfen abwechselnd die Schulter.
Plank (Schlingentrainer, Gewicht aufgelegt)|94|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Scheibe auf dem Rücken.
Plank (Ringe)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Plank (Ringe, auf den Unterarmen)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Auf den Unterarmen.
Plank (Ringe, auf den Händen)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Hohe Plank.
Plank (Ringe, Seitstütz links)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Seitlich, Körper gerade.
Plank (Ringe, Seitstütz rechts)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Seitlich.
Plank (Ringe, mit Beinheben)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Abwechselnd ein Bein heben.
Plank (Ringe, mit Armheben)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Abwechselnd Arm heben.
Plank (Ringe, Füße erhöht)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Füße erhöht.
Plank (Ringe, RKC (maximale Spannung))|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Alles maximal anspannen, kurz halten.
Plank (Ringe, Plank Jacks)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Füße springen auseinander.
Plank (Ringe, Bergsteiger)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Knie zur Brust im Wechsel.
Plank (Ringe, Schulterklopfen)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Hände klopfen abwechselnd die Schulter.
Plank (Ringe, Gewicht aufgelegt)|94|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Scheibe auf dem Rücken.
Plank (Medizinball)|94|medball|Ball nach Technik wählen, lieber leicht und sauber.
Plank (Medizinball, auf den Unterarmen)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Auf den Unterarmen.
Plank (Medizinball, auf den Händen)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Hohe Plank.
Plank (Medizinball, Seitstütz links)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlich, Körper gerade.
Plank (Medizinball, Seitstütz rechts)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlich.
Plank (Medizinball, mit Beinheben)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Abwechselnd ein Bein heben.
Plank (Medizinball, mit Armheben)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Abwechselnd Arm heben.
Plank (Medizinball, Füße erhöht)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Füße erhöht.
Plank (Medizinball, RKC (maximale Spannung))|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Alles maximal anspannen, kurz halten.
Plank (Medizinball, Plank Jacks)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Füße springen auseinander.
Plank (Medizinball, Bergsteiger)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Knie zur Brust im Wechsel.
Plank (Medizinball, Schulterklopfen)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Hände klopfen abwechselnd die Schulter.
Plank (Medizinball, Gewicht aufgelegt)|94|medball|Ball nach Technik wählen, lieber leicht und sauber. Scheibe auf dem Rücken.
Plank (Widerstandsband)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Plank (Widerstandsband, auf den Unterarmen)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Unterarmen.
Plank (Widerstandsband, auf den Händen)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hohe Plank.
Plank (Widerstandsband, Seitstütz links)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich, Körper gerade.
Plank (Widerstandsband, Seitstütz rechts)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich.
Plank (Widerstandsband, mit Beinheben)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Abwechselnd ein Bein heben.
Plank (Widerstandsband, mit Armheben)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Abwechselnd Arm heben.
Plank (Widerstandsband, Füße erhöht)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße erhöht.
Plank (Widerstandsband, RKC (maximale Spannung))|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Alles maximal anspannen, kurz halten.
Plank (Widerstandsband, Plank Jacks)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße springen auseinander.
Plank (Widerstandsband, Bergsteiger)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie zur Brust im Wechsel.
Plank (Widerstandsband, Schulterklopfen)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände klopfen abwechselnd die Schulter.
Plank (Widerstandsband, Gewicht aufgelegt)|94|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Scheibe auf dem Rücken.
Beinheben (Stange)|95|bar|
Beinheben (Stange, hängend)|95|bar|Hängend an der Stange.
Beinheben (Stange, hängend, Knie angewinkelt)|95|bar|Knie zur Brust.
Beinheben (Stange, hängend, gestreckt)|95|bar|Gestreckte Beine bis zur Stange.
Beinheben (Stange, liegend)|95|bar|Liegend.
Beinheben (Stange, liegend, Pendel (Windshield))|95|bar|Beine pendeln wie ein Scheibenwischer.
Beinheben (Stange, im Stütz (Captain’s Chair))|95|bar|Im Armstütz.
Beinheben (Stange, einbeinig)|95|bar|Ein Bein.
Beinheben (Stange, seitlich (Oblique))|95|bar|Seitlich zu den Rippen.
Beinheben (Stange, Toes to Bar)|95|bar|Füße bis zur Stange.
Beinheben (Ringe)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Beinheben (Ringe, hängend)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Hängend an der Stange.
Beinheben (Ringe, hängend, Knie angewinkelt)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Knie zur Brust.
Beinheben (Ringe, hängend, gestreckt)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Gestreckte Beine bis zur Stange.
Beinheben (Ringe, liegend)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Liegend.
Beinheben (Ringe, liegend, Pendel (Windshield))|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Beine pendeln wie ein Scheibenwischer.
Beinheben (Ringe, im Stütz (Captain’s Chair))|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Im Armstütz.
Beinheben (Ringe, einbeinig)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Ein Bein.
Beinheben (Ringe, seitlich (Oblique))|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Seitlich zu den Rippen.
Beinheben (Ringe, Toes to Bar)|95|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Füße bis zur Stange.
Beinheben (Körpergewicht)|95|none|
Beinheben (Körpergewicht, hängend)|95|none|Hängend an der Stange.
Beinheben (Körpergewicht, hängend, Knie angewinkelt)|95|none|Knie zur Brust.
Beinheben (Körpergewicht, hängend, gestreckt)|95|none|Gestreckte Beine bis zur Stange.
Beinheben (Körpergewicht, liegend)|95|none|Liegend.
Beinheben (Körpergewicht, liegend, Pendel (Windshield))|95|none|Beine pendeln wie ein Scheibenwischer.
Beinheben (Körpergewicht, im Stütz (Captain’s Chair))|95|none|Im Armstütz.
Beinheben (Körpergewicht, einbeinig)|95|none|Ein Bein.
Beinheben (Körpergewicht, seitlich (Oblique))|95|none|Seitlich zu den Rippen.
Beinheben (Körpergewicht, Toes to Bar)|95|none|Füße bis zur Stange.
Beinheben (Maschine)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Beinheben (Maschine, hängend)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Hängend an der Stange.
Beinheben (Maschine, hängend, Knie angewinkelt)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Knie zur Brust.
Beinheben (Maschine, hängend, gestreckt)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Gestreckte Beine bis zur Stange.
Beinheben (Maschine, liegend)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Liegend.
Beinheben (Maschine, liegend, Pendel (Windshield))|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Beine pendeln wie ein Scheibenwischer.
Beinheben (Maschine, im Stütz (Captain’s Chair))|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Im Armstütz.
Beinheben (Maschine, einbeinig)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Ein Bein.
Beinheben (Maschine, seitlich (Oblique))|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlich zu den Rippen.
Beinheben (Maschine, Toes to Bar)|95|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Füße bis zur Stange.
Beinheben (Schlingentrainer)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Beinheben (Schlingentrainer, hängend)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hängend an der Stange.
Beinheben (Schlingentrainer, hängend, Knie angewinkelt)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Knie zur Brust.
Beinheben (Schlingentrainer, hängend, gestreckt)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Gestreckte Beine bis zur Stange.
Beinheben (Schlingentrainer, liegend)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Liegend.
Beinheben (Schlingentrainer, liegend, Pendel (Windshield))|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Beine pendeln wie ein Scheibenwischer.
Beinheben (Schlingentrainer, im Stütz (Captain’s Chair))|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Im Armstütz.
Beinheben (Schlingentrainer, einbeinig)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Ein Bein.
Beinheben (Schlingentrainer, seitlich (Oblique))|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Seitlich zu den Rippen.
Beinheben (Schlingentrainer, Toes to Bar)|95|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Füße bis zur Stange.
Dead Bug (Körpergewicht)|96|none|
Dead Bug (Körpergewicht, klassisch)|96|none|Gegenseitig.
Dead Bug (Körpergewicht, gleichseitig)|96|none|Arm und Bein derselben Seite.
Dead Bug (Körpergewicht, nur Beine)|96|none|Nur Beine.
Dead Bug (Körpergewicht, mit Ball)|96|none|Ball zwischen Händen und Knien.
Dead Bug (Körpergewicht, mit Gewicht)|96|none|Leichtes Gewicht in den Händen.
Dead Bug (Widerstandsband)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Dead Bug (Widerstandsband, klassisch)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gegenseitig.
Dead Bug (Widerstandsband, gleichseitig)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arm und Bein derselben Seite.
Dead Bug (Widerstandsband, nur Beine)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur Beine.
Dead Bug (Widerstandsband, mit Ball)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ball zwischen Händen und Knien.
Dead Bug (Widerstandsband, mit Gewicht)|96|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Leichtes Gewicht in den Händen.
Dead Bug (Medizinball)|96|medball|Ball nach Technik wählen, lieber leicht und sauber.
Dead Bug (Medizinball, klassisch)|96|medball|Ball nach Technik wählen, lieber leicht und sauber. Gegenseitig.
Dead Bug (Medizinball, gleichseitig)|96|medball|Ball nach Technik wählen, lieber leicht und sauber. Arm und Bein derselben Seite.
Dead Bug (Medizinball, nur Beine)|96|medball|Ball nach Technik wählen, lieber leicht und sauber. Nur Beine.
Dead Bug (Medizinball, mit Ball)|96|medball|Ball nach Technik wählen, lieber leicht und sauber. Ball zwischen Händen und Knien.
Dead Bug (Medizinball, mit Gewicht)|96|medball|Ball nach Technik wählen, lieber leicht und sauber. Leichtes Gewicht in den Händen.
Dead Bug (Kurzhantel)|96|dumbbell|Gewichtsangabe pro Hantel eintragen.
Dead Bug (Kurzhantel, klassisch)|96|dumbbell|Gewichtsangabe pro Hantel eintragen. Gegenseitig.
Dead Bug (Kurzhantel, gleichseitig)|96|dumbbell|Gewichtsangabe pro Hantel eintragen. Arm und Bein derselben Seite.
Dead Bug (Kurzhantel, nur Beine)|96|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur Beine.
Dead Bug (Kurzhantel, mit Ball)|96|dumbbell|Gewichtsangabe pro Hantel eintragen. Ball zwischen Händen und Knien.
Dead Bug (Kurzhantel, mit Gewicht)|96|dumbbell|Gewichtsangabe pro Hantel eintragen. Leichtes Gewicht in den Händen.
Hollow Hold (Körpergewicht)|97|none|
Hollow Hold (Körpergewicht, Arme neben dem Körper)|97|none|Arme am Körper.
Hollow Hold (Körpergewicht, Arme über Kopf)|97|none|Arme nach vorn.
Hollow Hold (Körpergewicht, Hollow Rock)|97|none|Vor und zurück wippen.
Hollow Hold (Körpergewicht, Beine gebeugt)|97|none|Beine gebeugt: leichter.
Hollow Hold (Kurzhantel)|97|dumbbell|Gewichtsangabe pro Hantel eintragen.
Hollow Hold (Kurzhantel, Arme neben dem Körper)|97|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme am Körper.
Hollow Hold (Kurzhantel, Arme über Kopf)|97|dumbbell|Gewichtsangabe pro Hantel eintragen. Arme nach vorn.
Hollow Hold (Kurzhantel, Hollow Rock)|97|dumbbell|Gewichtsangabe pro Hantel eintragen. Vor und zurück wippen.
Hollow Hold (Kurzhantel, Beine gebeugt)|97|dumbbell|Gewichtsangabe pro Hantel eintragen. Beine gebeugt: leichter.
Hollow Hold (Medizinball)|97|medball|Ball nach Technik wählen, lieber leicht und sauber.
Hollow Hold (Medizinball, Arme neben dem Körper)|97|medball|Ball nach Technik wählen, lieber leicht und sauber. Arme am Körper.
Hollow Hold (Medizinball, Arme über Kopf)|97|medball|Ball nach Technik wählen, lieber leicht und sauber. Arme nach vorn.
Hollow Hold (Medizinball, Hollow Rock)|97|medball|Ball nach Technik wählen, lieber leicht und sauber. Vor und zurück wippen.
Hollow Hold (Medizinball, Beine gebeugt)|97|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine gebeugt: leichter.
Russian Twist (Körpergewicht)|98|none|
Russian Twist (Körpergewicht, Füße am Boden)|98|none|Füße am Boden.
Russian Twist (Körpergewicht, Füße angehoben)|98|none|Füße angehoben.
Russian Twist (Körpergewicht, mit Wurf an die Wand)|98|none|Ball an die Wand werfen.
Russian Twist (Körpergewicht, auf der Bank)|98|none|Auf der Bank.
Russian Twist (Medizinball)|98|medball|Ball nach Technik wählen, lieber leicht und sauber.
Russian Twist (Medizinball, Füße am Boden)|98|medball|Ball nach Technik wählen, lieber leicht und sauber. Füße am Boden.
Russian Twist (Medizinball, Füße angehoben)|98|medball|Ball nach Technik wählen, lieber leicht und sauber. Füße angehoben.
Russian Twist (Medizinball, mit Wurf an die Wand)|98|medball|Ball nach Technik wählen, lieber leicht und sauber. Ball an die Wand werfen.
Russian Twist (Medizinball, auf der Bank)|98|medball|Ball nach Technik wählen, lieber leicht und sauber. Auf der Bank.
Russian Twist (Kurzhantel)|98|dumbbell|Gewichtsangabe pro Hantel eintragen.
Russian Twist (Kurzhantel, Füße am Boden)|98|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße am Boden.
Russian Twist (Kurzhantel, Füße angehoben)|98|dumbbell|Gewichtsangabe pro Hantel eintragen. Füße angehoben.
Russian Twist (Kurzhantel, mit Wurf an die Wand)|98|dumbbell|Gewichtsangabe pro Hantel eintragen. Ball an die Wand werfen.
Russian Twist (Kurzhantel, auf der Bank)|98|dumbbell|Gewichtsangabe pro Hantel eintragen. Auf der Bank.
Russian Twist (Kettlebell)|98|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Russian Twist (Kettlebell, Füße am Boden)|98|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße am Boden.
Russian Twist (Kettlebell, Füße angehoben)|98|kettlebell|Gewichtsangabe der Kettlebell eintragen. Füße angehoben.
Russian Twist (Kettlebell, mit Wurf an die Wand)|98|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ball an die Wand werfen.
Russian Twist (Kettlebell, auf der Bank)|98|kettlebell|Gewichtsangabe der Kettlebell eintragen. Auf der Bank.
Russian Twist (Hantelscheibe)|98|barbell|Scheibe mit beiden Händen fest greifen.
Russian Twist (Hantelscheibe, Füße am Boden)|98|barbell|Scheibe mit beiden Händen fest greifen. Füße am Boden.
Russian Twist (Hantelscheibe, Füße angehoben)|98|barbell|Scheibe mit beiden Händen fest greifen. Füße angehoben.
Russian Twist (Hantelscheibe, mit Wurf an die Wand)|98|barbell|Scheibe mit beiden Händen fest greifen. Ball an die Wand werfen.
Russian Twist (Hantelscheibe, auf der Bank)|98|barbell|Scheibe mit beiden Händen fest greifen. Auf der Bank.
Russian Twist (Kabelzug)|98|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Russian Twist (Kabelzug, Füße am Boden)|98|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Füße am Boden.
Russian Twist (Kabelzug, Füße angehoben)|98|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Füße angehoben.
Russian Twist (Kabelzug, mit Wurf an die Wand)|98|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ball an die Wand werfen.
Russian Twist (Kabelzug, auf der Bank)|98|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Auf der Bank.
Russian Twist (Widerstandsband)|98|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Russian Twist (Widerstandsband, Füße am Boden)|98|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße am Boden.
Russian Twist (Widerstandsband, Füße angehoben)|98|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Füße angehoben.
Russian Twist (Widerstandsband, mit Wurf an die Wand)|98|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ball an die Wand werfen.
Russian Twist (Widerstandsband, auf der Bank)|98|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf der Bank.
Holzhacker (Wood Chop) (Kabelzug)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Holzhacker (Wood Chop) (Kabelzug, von oben nach unten)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal von oben nach unten.
Holzhacker (Wood Chop) (Kabelzug, von unten nach oben)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Diagonal von unten nach oben.
Holzhacker (Wood Chop) (Kabelzug, horizontal)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Waagerecht.
Holzhacker (Wood Chop) (Kabelzug, halbkniend)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend.
Holzhacker (Wood Chop) (Kabelzug, im Ausfallschritt)|99|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Im Ausfallschritt.
Holzhacker (Wood Chop) (Widerstandsband)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Holzhacker (Wood Chop) (Widerstandsband, von oben nach unten)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal von oben nach unten.
Holzhacker (Wood Chop) (Widerstandsband, von unten nach oben)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Diagonal von unten nach oben.
Holzhacker (Wood Chop) (Widerstandsband, horizontal)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Waagerecht.
Holzhacker (Wood Chop) (Widerstandsband, halbkniend)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend.
Holzhacker (Wood Chop) (Widerstandsband, im Ausfallschritt)|99|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Ausfallschritt.
Holzhacker (Wood Chop) (Medizinball)|99|medball|Ball nach Technik wählen, lieber leicht und sauber.
Holzhacker (Wood Chop) (Medizinball, von oben nach unten)|99|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal von oben nach unten.
Holzhacker (Wood Chop) (Medizinball, von unten nach oben)|99|medball|Ball nach Technik wählen, lieber leicht und sauber. Diagonal von unten nach oben.
Holzhacker (Wood Chop) (Medizinball, horizontal)|99|medball|Ball nach Technik wählen, lieber leicht und sauber. Waagerecht.
Holzhacker (Wood Chop) (Medizinball, halbkniend)|99|medball|Ball nach Technik wählen, lieber leicht und sauber. Halbkniend.
Holzhacker (Wood Chop) (Medizinball, im Ausfallschritt)|99|medball|Ball nach Technik wählen, lieber leicht und sauber. Im Ausfallschritt.
Holzhacker (Wood Chop) (Kurzhantel)|99|dumbbell|Gewichtsangabe pro Hantel eintragen.
Holzhacker (Wood Chop) (Kurzhantel, von oben nach unten)|99|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal von oben nach unten.
Holzhacker (Wood Chop) (Kurzhantel, von unten nach oben)|99|dumbbell|Gewichtsangabe pro Hantel eintragen. Diagonal von unten nach oben.
Holzhacker (Wood Chop) (Kurzhantel, horizontal)|99|dumbbell|Gewichtsangabe pro Hantel eintragen. Waagerecht.
Holzhacker (Wood Chop) (Kurzhantel, halbkniend)|99|dumbbell|Gewichtsangabe pro Hantel eintragen. Halbkniend.
Holzhacker (Wood Chop) (Kurzhantel, im Ausfallschritt)|99|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Ausfallschritt.
Holzhacker (Wood Chop) (Kettlebell)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Holzhacker (Wood Chop) (Kettlebell, von oben nach unten)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal von oben nach unten.
Holzhacker (Wood Chop) (Kettlebell, von unten nach oben)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen. Diagonal von unten nach oben.
Holzhacker (Wood Chop) (Kettlebell, horizontal)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen. Waagerecht.
Holzhacker (Wood Chop) (Kettlebell, halbkniend)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen. Halbkniend.
Holzhacker (Wood Chop) (Kettlebell, im Ausfallschritt)|99|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Ausfallschritt.
Pallof Press (Kabelzug)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Pallof Press (Kabelzug, im Stand)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Pallof Press (Kabelzug, halbkniend)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Halbkniend.
Pallof Press (Kabelzug, kniend)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend.
Pallof Press (Kabelzug, im Ausfallschritt)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Ausfallschritt.
Pallof Press (Kabelzug, mit Überkopf)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arme über Kopf.
Pallof Press (Kabelzug, mit Pause (5 s))|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. 5 Sekunden Pause.
Pallof Press (Kabelzug, Tall Kneeling)|100|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Aufrecht kniend.
Pallof Press (Widerstandsband)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Pallof Press (Widerstandsband, im Stand)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Pallof Press (Widerstandsband, halbkniend)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Halbkniend.
Pallof Press (Widerstandsband, kniend)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kniend.
Pallof Press (Widerstandsband, im Ausfallschritt)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ausfallschritt.
Pallof Press (Widerstandsband, mit Überkopf)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme über Kopf.
Pallof Press (Widerstandsband, mit Pause (5 s))|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 5 Sekunden Pause.
Pallof Press (Widerstandsband, Tall Kneeling)|100|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Aufrecht kniend.
Ab Rollout (Maschine)|101|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Ab Rollout (Maschine, kniend)|101|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Auf den Knien.
Ab Rollout (Maschine, stehend)|101|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Im Stehen: sehr schwer.
Ab Rollout (Maschine, gegen die Wand)|101|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. An der Wand stoppen.
Ab Rollout (Maschine, einseitig)|101|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Schrägzug.
Ab Rollout (Langhantel)|101|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Ab Rollout (Langhantel, kniend)|101|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Auf den Knien.
Ab Rollout (Langhantel, stehend)|101|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Stehen: sehr schwer.
Ab Rollout (Langhantel, gegen die Wand)|101|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. An der Wand stoppen.
Ab Rollout (Langhantel, einseitig)|101|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Mit Schrägzug.
Ab Rollout (Schlingentrainer)|101|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Ab Rollout (Schlingentrainer, kniend)|101|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf den Knien.
Ab Rollout (Schlingentrainer, stehend)|101|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Im Stehen: sehr schwer.
Ab Rollout (Schlingentrainer, gegen die Wand)|101|sling|Je flacher der Körperwinkel, desto schwerer die Übung. An der Wand stoppen.
Ab Rollout (Schlingentrainer, einseitig)|101|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Mit Schrägzug.
Ab Rollout (Ringe)|101|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Ab Rollout (Ringe, kniend)|101|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Auf den Knien.
Ab Rollout (Ringe, stehend)|101|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Im Stehen: sehr schwer.
Ab Rollout (Ringe, gegen die Wand)|101|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. An der Wand stoppen.
Ab Rollout (Ringe, einseitig)|101|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Mit Schrägzug.
Ab Rollout (Widerstandsband)|101|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Ab Rollout (Widerstandsband, kniend)|101|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf den Knien.
Ab Rollout (Widerstandsband, stehend)|101|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Im Stehen: sehr schwer.
Ab Rollout (Widerstandsband, gegen die Wand)|101|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. An der Wand stoppen.
Ab Rollout (Widerstandsband, einseitig)|101|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Schrägzug.
Seitbeugen (Kurzhantel)|102|dumbbell|Gewichtsangabe pro Hantel eintragen.
Seitbeugen (Kurzhantel, stehend)|102|dumbbell|Gewichtsangabe pro Hantel eintragen. Stehend.
Seitbeugen (Kurzhantel, auf der Römischen Bank)|102|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich auf Bank.
Seitbeugen (Kurzhantel, Windmühle)|102|dumbbell|Gewichtsangabe pro Hantel eintragen. Arm nach oben, zum Fuß drehen.
Seitbeugen (Kettlebell)|102|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Seitbeugen (Kettlebell, stehend)|102|kettlebell|Gewichtsangabe der Kettlebell eintragen. Stehend.
Seitbeugen (Kettlebell, auf der Römischen Bank)|102|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich auf Bank.
Seitbeugen (Kettlebell, Windmühle)|102|kettlebell|Gewichtsangabe der Kettlebell eintragen. Arm nach oben, zum Fuß drehen.
Seitbeugen (Kabelzug)|102|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Seitbeugen (Kabelzug, stehend)|102|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Stehend.
Seitbeugen (Kabelzug, auf der Römischen Bank)|102|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Seitlich auf Bank.
Seitbeugen (Kabelzug, Windmühle)|102|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Arm nach oben, zum Fuß drehen.
Seitbeugen (Maschine)|102|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Seitbeugen (Maschine, stehend)|102|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Stehend.
Seitbeugen (Maschine, auf der Römischen Bank)|102|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Seitlich auf Bank.
Seitbeugen (Maschine, Windmühle)|102|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Arm nach oben, zum Fuß drehen.
Seitbeugen (Widerstandsband)|102|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Seitbeugen (Widerstandsband, stehend)|102|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Stehend.
Seitbeugen (Widerstandsband, auf der Römischen Bank)|102|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich auf Bank.
Seitbeugen (Widerstandsband, Windmühle)|102|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arm nach oben, zum Fuß drehen.
Seitbeugen (Hantelscheibe)|102|barbell|Scheibe mit beiden Händen fest greifen.
Seitbeugen (Hantelscheibe, stehend)|102|barbell|Scheibe mit beiden Händen fest greifen. Stehend.
Seitbeugen (Hantelscheibe, auf der Römischen Bank)|102|barbell|Scheibe mit beiden Händen fest greifen. Seitlich auf Bank.
Seitbeugen (Hantelscheibe, Windmühle)|102|barbell|Scheibe mit beiden Händen fest greifen. Arm nach oben, zum Fuß drehen.
Seitstütz (Körpergewicht)|103|none|
Seitstütz (Körpergewicht, mit Hüftheben)|103|none|Hüfte auf und ab.
Seitstütz (Körpergewicht, mit Beinabduktion)|103|none|Oberes Bein heben.
Seitstütz (Körpergewicht, mit Rotation)|103|none|Arm durchfädeln.
Seitstütz (Körpergewicht, Knie gebeugt)|103|none|Knie gebeugt: leichter.
Seitstütz (Körpergewicht, Copenhagen)|103|none|Oberes Bein auf Bank.
Seitstütz (Schlingentrainer)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Seitstütz (Schlingentrainer, mit Hüftheben)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hüfte auf und ab.
Seitstütz (Schlingentrainer, mit Beinabduktion)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Oberes Bein heben.
Seitstütz (Schlingentrainer, mit Rotation)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Arm durchfädeln.
Seitstütz (Schlingentrainer, Knie gebeugt)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Knie gebeugt: leichter.
Seitstütz (Schlingentrainer, Copenhagen)|103|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Oberes Bein auf Bank.
Seitstütz (Ringe)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Seitstütz (Ringe, mit Hüftheben)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Hüfte auf und ab.
Seitstütz (Ringe, mit Beinabduktion)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Oberes Bein heben.
Seitstütz (Ringe, mit Rotation)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Arm durchfädeln.
Seitstütz (Ringe, Knie gebeugt)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Knie gebeugt: leichter.
Seitstütz (Ringe, Copenhagen)|103|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Oberes Bein auf Bank.
Bergsteiger (Mountain Climber) (Körpergewicht)|104|none|
Bergsteiger (Mountain Climber) (Körpergewicht, klassisch)|104|none|Klassisch.
Bergsteiger (Mountain Climber) (Körpergewicht, langsam)|104|none|Langsam, kontrolliert.
Bergsteiger (Mountain Climber) (Körpergewicht, diagonal (Cross))|104|none|Knie zum Gegenellbogen.
Bergsteiger (Mountain Climber) (Körpergewicht, auf Gleitern)|104|none|Auf Gleitern.
Bergsteiger (Mountain Climber) (Körpergewicht, Hände erhöht)|104|none|Hände erhöht.
Bergsteiger (Mountain Climber) (Schlingentrainer)|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Bergsteiger (Mountain Climber) (Schlingentrainer, klassisch)|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Klassisch.
Bergsteiger (Mountain Climber) (Schlingentrainer, langsam)|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Langsam, kontrolliert.
Bergsteiger (Mountain Climber) (Schlingentrainer, diagonal (Cross))|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Knie zum Gegenellbogen.
Bergsteiger (Mountain Climber) (Schlingentrainer, auf Gleitern)|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Auf Gleitern.
Bergsteiger (Mountain Climber) (Schlingentrainer, Hände erhöht)|104|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Hände erhöht.
Bergsteiger (Mountain Climber) (Medizinball)|104|medball|Ball nach Technik wählen, lieber leicht und sauber.
Bergsteiger (Mountain Climber) (Medizinball, klassisch)|104|medball|Ball nach Technik wählen, lieber leicht und sauber. Klassisch.
Bergsteiger (Mountain Climber) (Medizinball, langsam)|104|medball|Ball nach Technik wählen, lieber leicht und sauber. Langsam, kontrolliert.
Bergsteiger (Mountain Climber) (Medizinball, diagonal (Cross))|104|medball|Ball nach Technik wählen, lieber leicht und sauber. Knie zum Gegenellbogen.
Bergsteiger (Mountain Climber) (Medizinball, auf Gleitern)|104|medball|Ball nach Technik wählen, lieber leicht und sauber. Auf Gleitern.
Bergsteiger (Mountain Climber) (Medizinball, Hände erhöht)|104|medball|Ball nach Technik wählen, lieber leicht und sauber. Hände erhöht.
Bergsteiger (Mountain Climber) (Widerstandsband)|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Bergsteiger (Mountain Climber) (Widerstandsband, klassisch)|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Klassisch.
Bergsteiger (Mountain Climber) (Widerstandsband, langsam)|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Langsam, kontrolliert.
Bergsteiger (Mountain Climber) (Widerstandsband, diagonal (Cross))|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie zum Gegenellbogen.
Bergsteiger (Mountain Climber) (Widerstandsband, auf Gleitern)|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf Gleitern.
Bergsteiger (Mountain Climber) (Widerstandsband, Hände erhöht)|104|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hände erhöht.
Toe Touch (Körpergewicht)|105|none|
Toe Touch (Körpergewicht, beidarmig)|105|none|Beide Hände.
Toe Touch (Körpergewicht, abwechselnd)|105|none|Abwechselnd.
Toe Touch (Kurzhantel)|105|dumbbell|Gewichtsangabe pro Hantel eintragen.
Toe Touch (Kurzhantel, beidarmig)|105|dumbbell|Gewichtsangabe pro Hantel eintragen. Beide Hände.
Toe Touch (Kurzhantel, abwechselnd)|105|dumbbell|Gewichtsangabe pro Hantel eintragen. Abwechselnd.
V-Sit (Körpergewicht)|106|none|
V-Sit (Körpergewicht, Beine gebeugt)|106|none|Beine gebeugt.
V-Sit (Körpergewicht, gestreckt)|106|none|Beine gestreckt.
V-Sit (Körpergewicht, mit Wechsel)|106|none|Beinewechsel.
V-Sit (Medizinball)|106|medball|Ball nach Technik wählen, lieber leicht und sauber.
V-Sit (Medizinball, Beine gebeugt)|106|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine gebeugt.
V-Sit (Medizinball, gestreckt)|106|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine gestreckt.
V-Sit (Medizinball, mit Wechsel)|106|medball|Ball nach Technik wählen, lieber leicht und sauber. Beinewechsel.
V-Sit (Kurzhantel)|106|dumbbell|Gewichtsangabe pro Hantel eintragen.
V-Sit (Kurzhantel, Beine gebeugt)|106|dumbbell|Gewichtsangabe pro Hantel eintragen. Beine gebeugt.
V-Sit (Kurzhantel, gestreckt)|106|dumbbell|Gewichtsangabe pro Hantel eintragen. Beine gestreckt.
V-Sit (Kurzhantel, mit Wechsel)|106|dumbbell|Gewichtsangabe pro Hantel eintragen. Beinewechsel.
L-Sit (Körpergewicht)|107|none|
L-Sit (Körpergewicht, Knie gebeugt (Tuck))|107|none|Knie angewinkelt.
L-Sit (Körpergewicht, Beine einseitig)|107|none|Ein Bein gestreckt.
L-Sit (Körpergewicht, gestreckt)|107|none|Volle Position.
L-Sit (Körpergewicht, auf Parallettes)|107|none|Auf Parallettes.
L-Sit (Körpergewicht, auf Ringen)|107|none|Auf Ringen.
L-Sit (Stange)|107|bar|
L-Sit (Stange, Knie gebeugt (Tuck))|107|bar|Knie angewinkelt.
L-Sit (Stange, Beine einseitig)|107|bar|Ein Bein gestreckt.
L-Sit (Stange, gestreckt)|107|bar|Volle Position.
L-Sit (Stange, auf Parallettes)|107|bar|Auf Parallettes.
L-Sit (Stange, auf Ringen)|107|bar|Auf Ringen.
L-Sit (Ringe)|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
L-Sit (Ringe, Knie gebeugt (Tuck))|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Knie angewinkelt.
L-Sit (Ringe, Beine einseitig)|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Ein Bein gestreckt.
L-Sit (Ringe, gestreckt)|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Volle Position.
L-Sit (Ringe, auf Parallettes)|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Auf Parallettes.
L-Sit (Ringe, auf Ringen)|107|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Auf Ringen.
Drachenflagge (Dragon Flag) (Körpergewicht)|108|none|
Drachenflagge (Dragon Flag) (Körpergewicht, Negativ)|108|none|Negativ.
Drachenflagge (Dragon Flag) (Körpergewicht, Knie gebeugt (Tuck))|108|none|Tuck.
Drachenflagge (Dragon Flag) (Körpergewicht, voll)|108|none|Voll.
Front Lever (Stange)|109|bar|
Front Lever (Stange, Tuck)|109|bar|Knie angewinkelt.
Front Lever (Stange, Advanced Tuck)|109|bar|Rücken waagerecht.
Front Lever (Stange, Straddle)|109|bar|Beine gespreizt.
Front Lever (Stange, voll)|109|bar|Voll.
Front Lever (Stange, Negativ)|109|bar|Langsam senken.
Front Lever (Ringe)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Front Lever (Ringe, Tuck)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Knie angewinkelt.
Front Lever (Ringe, Advanced Tuck)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Rücken waagerecht.
Front Lever (Ringe, Straddle)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Beine gespreizt.
Front Lever (Ringe, voll)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Voll.
Front Lever (Ringe, Negativ)|109|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Langsam senken.
Human Flag (Stange)|110|bar|
Human Flag (Stange, Tuck)|110|bar|Knie angewinkelt.
Human Flag (Stange, Straddle)|110|bar|Beine gespreizt.
Human Flag (Stange, voll)|110|bar|Voll.
Bauchmaschine (Maschine)|111|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Bauchmaschine (Maschine, sitzend)|111|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Bauchmaschine (Maschine, mit Seil kniend)|111|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Kniend am Seilzug.
Bauchmaschine (Maschine, mit Rotation)|111|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Rotation.
Bauchmaschine (Kabelzug)|111|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft.
Bauchmaschine (Kabelzug, sitzend)|111|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Sitzend.
Bauchmaschine (Kabelzug, mit Seil kniend)|111|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Kniend am Seilzug.
Bauchmaschine (Kabelzug, mit Rotation)|111|cable|Höhe und Griff so einstellen, dass der Zug in Bewegungsrichtung läuft. Mit Rotation.
Rückenstrecker-Maschine (Maschine)|112|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt.
Rückenstrecker-Maschine (Maschine, sitzend)|112|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Sitzend.
Rückenstrecker-Maschine (Maschine, mit Rotation)|112|machine|Sitz so einstellen, dass das Gelenk auf Höhe der Drehachse liegt. Mit Drehung.
Bird Dog (Körpergewicht)|113|none|
Bird Dog (Körpergewicht, klassisch)|113|none|Gegenseitig.
Bird Dog (Körpergewicht, mit Ellbogen-Knie-Touch)|113|none|Ellbogen zum Knie.
Bird Dog (Körpergewicht, Knie schweben)|113|none|Knie knapp über dem Boden.
Bird Dog (Körpergewicht, mit Pause (5 s))|113|none|5 Sekunden.
Bird Dog (Widerstandsband)|113|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Bird Dog (Widerstandsband, klassisch)|113|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gegenseitig.
Bird Dog (Widerstandsband, mit Ellbogen-Knie-Touch)|113|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ellbogen zum Knie.
Bird Dog (Widerstandsband, Knie schweben)|113|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie knapp über dem Boden.
Bird Dog (Widerstandsband, mit Pause (5 s))|113|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. 5 Sekunden.
Bird Dog (Kurzhantel)|113|dumbbell|Gewichtsangabe pro Hantel eintragen.
Bird Dog (Kurzhantel, klassisch)|113|dumbbell|Gewichtsangabe pro Hantel eintragen. Gegenseitig.
Bird Dog (Kurzhantel, mit Ellbogen-Knie-Touch)|113|dumbbell|Gewichtsangabe pro Hantel eintragen. Ellbogen zum Knie.
Bird Dog (Kurzhantel, Knie schweben)|113|dumbbell|Gewichtsangabe pro Hantel eintragen. Knie knapp über dem Boden.
Bird Dog (Kurzhantel, mit Pause (5 s))|113|dumbbell|Gewichtsangabe pro Hantel eintragen. 5 Sekunden.
Bird Dog (Schlingentrainer)|113|sling|Je flacher der Körperwinkel, desto schwerer die Übung.
Bird Dog (Schlingentrainer, klassisch)|113|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Gegenseitig.
Bird Dog (Schlingentrainer, mit Ellbogen-Knie-Touch)|113|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Ellbogen zum Knie.
Bird Dog (Schlingentrainer, Knie schweben)|113|sling|Je flacher der Körperwinkel, desto schwerer die Übung. Knie knapp über dem Boden.
Bird Dog (Schlingentrainer, mit Pause (5 s))|113|sling|Je flacher der Körperwinkel, desto schwerer die Übung. 5 Sekunden.
Brett-Schwimmen (Plank Swim) (Körpergewicht)|114|none|
Brett-Schwimmen (Plank Swim) (Körpergewicht, Unterarme)|114|none|Unterarme.
Brett-Schwimmen (Plank Swim) (Körpergewicht, hohe Plank)|114|none|Hände.
Suitcase Carry (Kurzhantel)|115|dumbbell|Gewichtsangabe pro Hantel eintragen.
Suitcase Carry (Kurzhantel, rechts)|115|dumbbell|Gewichtsangabe pro Hantel eintragen. Rechte Seite.
Suitcase Carry (Kurzhantel, links)|115|dumbbell|Gewichtsangabe pro Hantel eintragen. Linke Seite.
Suitcase Carry (Kurzhantel, im Wechsel)|115|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitenwechsel.
Suitcase Carry (Kettlebell)|115|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Suitcase Carry (Kettlebell, rechts)|115|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rechte Seite.
Suitcase Carry (Kettlebell, links)|115|kettlebell|Gewichtsangabe der Kettlebell eintragen. Linke Seite.
Suitcase Carry (Kettlebell, im Wechsel)|115|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitenwechsel.
Suitcase Carry (Langhantel)|115|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Suitcase Carry (Langhantel, rechts)|115|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Rechte Seite.
Suitcase Carry (Langhantel, links)|115|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Linke Seite.
Suitcase Carry (Langhantel, im Wechsel)|115|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Seitenwechsel.
Suitcase Carry (Hantelscheibe)|115|barbell|Scheibe mit beiden Händen fest greifen.
Suitcase Carry (Hantelscheibe, rechts)|115|barbell|Scheibe mit beiden Händen fest greifen. Rechte Seite.
Suitcase Carry (Hantelscheibe, links)|115|barbell|Scheibe mit beiden Händen fest greifen. Linke Seite.
Suitcase Carry (Hantelscheibe, im Wechsel)|115|barbell|Scheibe mit beiden Händen fest greifen. Seitenwechsel.
Waiter Walk (Kettlebell)|116|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Waiter Walk (Kettlebell, rechts)|116|kettlebell|Gewichtsangabe der Kettlebell eintragen. Rechts.
Waiter Walk (Kettlebell, links)|116|kettlebell|Gewichtsangabe der Kettlebell eintragen. Links.
Waiter Walk (Kettlebell, Bottoms-up)|116|kettlebell|Gewichtsangabe der Kettlebell eintragen. Kettlebell umgedreht.
Waiter Walk (Kurzhantel)|116|dumbbell|Gewichtsangabe pro Hantel eintragen.
Waiter Walk (Kurzhantel, rechts)|116|dumbbell|Gewichtsangabe pro Hantel eintragen. Rechts.
Waiter Walk (Kurzhantel, links)|116|dumbbell|Gewichtsangabe pro Hantel eintragen. Links.
Waiter Walk (Kurzhantel, Bottoms-up)|116|dumbbell|Gewichtsangabe pro Hantel eintragen. Kettlebell umgedreht.
Waiter Walk (Hantelscheibe)|116|barbell|Scheibe mit beiden Händen fest greifen.
Waiter Walk (Hantelscheibe, rechts)|116|barbell|Scheibe mit beiden Händen fest greifen. Rechts.
Waiter Walk (Hantelscheibe, links)|116|barbell|Scheibe mit beiden Händen fest greifen. Links.
Waiter Walk (Hantelscheibe, Bottoms-up)|116|barbell|Scheibe mit beiden Händen fest greifen. Kettlebell umgedreht.
Laufen (Draußen)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Laufen (Draußen, lockeres Tempo (Zone 2))|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Du kannst dich noch unterhalten.
Laufen (Draußen, Intervalle 1:1)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. 1 Minute schnell, 1 Minute locker.
Laufen (Draußen, Tempolauf)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Zügig, aber gleichmäßig.
Laufen (Draußen, Bergauf)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Kurze Schritte, aufrecht.
Laufen (Draußen, Fahrtspiel)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Wechsel nach Gefühl.
Laufen (Draußen, Steigerungsläufe)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Von locker bis fast schnell.
Laufen (Draußen, Sprints 30 s)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Maximal, lange Pausen.
Laufen (Draußen, langer Lauf)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Ruhig und lang.
Laufen (Draußen, Ausdauer-Pyramide)|117|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Dauer steigt und fällt.
Laufen (Cardio-Gerät)|117|cardio|
Laufen (Cardio-Gerät, lockeres Tempo (Zone 2))|117|cardio|Du kannst dich noch unterhalten.
Laufen (Cardio-Gerät, Intervalle 1:1)|117|cardio|1 Minute schnell, 1 Minute locker.
Laufen (Cardio-Gerät, Tempolauf)|117|cardio|Zügig, aber gleichmäßig.
Laufen (Cardio-Gerät, Bergauf)|117|cardio|Kurze Schritte, aufrecht.
Laufen (Cardio-Gerät, Fahrtspiel)|117|cardio|Wechsel nach Gefühl.
Laufen (Cardio-Gerät, Steigerungsläufe)|117|cardio|Von locker bis fast schnell.
Laufen (Cardio-Gerät, Sprints 30 s)|117|cardio|Maximal, lange Pausen.
Laufen (Cardio-Gerät, langer Lauf)|117|cardio|Ruhig und lang.
Laufen (Cardio-Gerät, Ausdauer-Pyramide)|117|cardio|Dauer steigt und fällt.
Gehen (Draußen)|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Gehen (Draußen, zügig)|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Zügig, Arme schwingen mit.
Gehen (Draußen, Steigung)|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mit Steigung.
Gehen (Draußen, Nordic Walking)|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mit Stöcken, aktiver Armeinsatz.
Gehen (Draußen, mit Rucksack (Rucking))|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Gewicht im Rucksack, aufrecht.
Gehen (Draußen, Intervalle)|118|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Wechsel zügig und locker.
Gehen (Cardio-Gerät)|118|cardio|
Gehen (Cardio-Gerät, zügig)|118|cardio|Zügig, Arme schwingen mit.
Gehen (Cardio-Gerät, Steigung)|118|cardio|Mit Steigung.
Gehen (Cardio-Gerät, Nordic Walking)|118|cardio|Mit Stöcken, aktiver Armeinsatz.
Gehen (Cardio-Gerät, mit Rucksack (Rucking))|118|cardio|Gewicht im Rucksack, aufrecht.
Gehen (Cardio-Gerät, Intervalle)|118|cardio|Wechsel zügig und locker.
Radfahren (Fahrrad)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt.
Radfahren (Fahrrad, lockeres Tempo (Zone 2))|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. Du kannst dich noch unterhalten.
Radfahren (Fahrrad, Intervalle 30/30)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. 30 s hart, 30 s locker.
Radfahren (Fahrrad, Bergintervalle)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. Hoher Widerstand, niedrige Frequenz.
Radfahren (Fahrrad, Sprint)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. Kurze maximale Sprints.
Radfahren (Fahrrad, hohe Trittfrequenz)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. 100+ U/min.
Radfahren (Fahrrad, im Stehen)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. Im Wippen aus der Hüfte.
Radfahren (Fahrrad, lange Ausfahrt)|119|bike|Sattelhöhe so einstellen, dass das Knie unten leicht gebeugt bleibt. Gleichmäßig und lang.
Radfahren (Cardio-Gerät)|119|cardio|
Radfahren (Cardio-Gerät, lockeres Tempo (Zone 2))|119|cardio|Du kannst dich noch unterhalten.
Radfahren (Cardio-Gerät, Intervalle 30/30)|119|cardio|30 s hart, 30 s locker.
Radfahren (Cardio-Gerät, Bergintervalle)|119|cardio|Hoher Widerstand, niedrige Frequenz.
Radfahren (Cardio-Gerät, Sprint)|119|cardio|Kurze maximale Sprints.
Radfahren (Cardio-Gerät, hohe Trittfrequenz)|119|cardio|100+ U/min.
Radfahren (Cardio-Gerät, im Stehen)|119|cardio|Im Wippen aus der Hüfte.
Radfahren (Cardio-Gerät, lange Ausfahrt)|119|cardio|Gleichmäßig und lang.
Rudern (Cardio-Gerät)|120|cardio|
Rudern (Cardio-Gerät, lockeres Tempo (Zone 2))|120|cardio|Du kannst dich noch unterhalten.
Rudern (Cardio-Gerät, Intervalle 500 m)|120|cardio|500 m schnell, Pause.
Rudern (Cardio-Gerät, Sprints 250 m)|120|cardio|Kurze Sprints.
Rudern (Cardio-Gerät, Technik-Drill)|120|cardio|Beine, Rücken, Arme in Folge.
Rudern (Cardio-Gerät, Pyramide)|120|cardio|Distanz steigt/fällt.
Rudern (Cardio-Gerät, 2000 m Test)|120|cardio|Gleichmäßig stark.
Schwimmen (Schwimmbad)|121|pool|
Schwimmen (Schwimmbad, Kraul)|121|pool|Gleichmäßig atmen.
Schwimmen (Schwimmbad, Brust)|121|pool|Kraftvoller Beinschlag.
Schwimmen (Schwimmbad, Rücken)|121|pool|Hüfte hoch.
Schwimmen (Schwimmbad, Schmetterling)|121|pool|Wellenbewegung.
Schwimmen (Schwimmbad, nur Beine mit Brett)|121|pool|Brett vor dem Körper.
Schwimmen (Schwimmbad, nur Arme mit Pullbuoy)|121|pool|Auftrieb zwischen den Beinen.
Schwimmen (Schwimmbad, Intervalle 50 m)|121|pool|50 m schnell, Pause.
Schwimmen (Schwimmbad, lockere Bahnen)|121|pool|Technik vor Tempo.
Wasserlaufen (Schwimmbad)|122|pool|
Wasserlaufen (Schwimmbad, im tiefen Wasser)|122|pool|Aufrecht laufen ohne Bodenkontakt.
Wasserlaufen (Schwimmbad, mit Knieheben)|122|pool|Hohes Knie.
Wasserlaufen (Schwimmbad, Seitwärts)|122|pool|Seitlich bewegen.
Stepper (Cardio-Gerät)|123|cardio|
Stepper (Cardio-Gerät, lockeres Tempo (Zone 2))|123|cardio|Du kannst dich noch unterhalten.
Stepper (Cardio-Gerät, Intervalle)|123|cardio|Wechsel hart/locker.
Stepper (Cardio-Gerät, Seitschritt)|123|cardio|Seitlich steigen.
Stepper (Cardio-Gerät, Zwei Stufen)|123|cardio|Jede zweite Stufe.
Stepper (Cardio-Gerät, ohne Festhalten)|123|cardio|Hände frei.
Crosstrainer (Cardio-Gerät)|124|cardio|
Crosstrainer (Cardio-Gerät, lockeres Tempo (Zone 2))|124|cardio|Du kannst dich noch unterhalten.
Crosstrainer (Cardio-Gerät, Intervalle)|124|cardio|Wechsel hart/locker.
Crosstrainer (Cardio-Gerät, rückwärts)|124|cardio|Rückwärts treten.
Crosstrainer (Cardio-Gerät, ohne Festhalten)|124|cardio|Hände frei.
Crosstrainer (Cardio-Gerät, Bergprogramm)|124|cardio|Mit Steigung.
Seilspringen|125|none|
Seilspringen (Grundsprung)|125|none|Beidbeinig.
Seilspringen (Wechselsprung)|125|none|Abwechselnd rechts/links.
Seilspringen (einbeinig)|125|none|Ein Bein.
Seilspringen (Doppelsprung (Double Under))|125|none|Seil zweimal pro Sprung.
Seilspringen (Boxer-Schritt)|125|none|Leichtes Federn.
Seilspringen (Skier-Sprung)|125|none|Seitlich hüpfen.
Seilspringen (Kreuzsprung)|125|none|Arme kreuzen.
Seilspringen (Intervalle 30/30)|125|none|30 s schnell, 30 s Pause.
Aufwärmen|126|none|
Aufwärmen (Hampelmann)|126|none|Arme und Beine öffnen.
Aufwärmen (Hohes Knie)|126|none|Knie zur Hüfthöhe.
Aufwärmen (Anfersen)|126|none|Fersen zum Gesäß.
Aufwärmen (Skipping)|126|none|Schnelle kurze Schritte.
Aufwärmen (Seitgalopp)|126|none|Seitlich wechseln.
Aufwärmen (Armkreisen)|126|none|Große Kreise.
Aufwärmen (Ausfallschritt-Gehen)|126|none|Weite Schritte.
Aufwärmen (Inchworm)|126|none|Mit den Händen nach vorn wandern.
Aufwärmen (Hüftkreisen)|126|none|Große Kreise.
HIIT|127|none|
HIIT (Burpees)|127|none|Brust zum Boden, Sprung.
HIIT (Bergsteiger)|127|none|Knie schnell zur Brust.
HIIT (Jump Squats)|127|none|Explosive Kniebeuge mit Sprung.
HIIT (Skater)|127|none|Seitliche Sprünge.
HIIT (Hampelmann)|127|none|Schnell.
HIIT (Hohes Knie)|127|none|Rennen am Platz.
HIIT (Plank Jacks)|127|none|Springen in der Plank.
HIIT (Tuck Jumps)|127|none|Knie zur Brust springen.
HIIT (Sprint am Platz)|127|none|Maximal.
HIIT (Ausfallschritt-Sprünge)|127|none|Sprung im Wechsel.
HIIT (Burpee mit Sprung)|127|none|Sprung am Ende.
HIIT (Schattenboxen)|127|none|Schnelle Schläge.
HIIT (Tabata 20/10)|127|none|20 s Vollgas, 10 s Pause.
HIIT (EMOM)|127|none|Jede Minute neu starten.
Sprung (Körpergewicht)|128|none|
Sprung (Körpergewicht, Box Jump)|128|none|Auf eine Kiste springen.
Sprung (Körpergewicht, Drop Jump)|128|none|Von der Kiste fallen und sofort springen.
Sprung (Körpergewicht, Strecksprung)|128|none|Aus der Hocke hoch.
Sprung (Körpergewicht, Weitsprung)|128|none|Maximal weit.
Sprung (Körpergewicht, Froschsprung)|128|none|Tiefe Hocke, weit.
Sprung (Körpergewicht, Seitsprung)|128|none|Seitlich über eine Linie.
Sprung (Körpergewicht, Einbeinsprung)|128|none|Ein Bein.
Sprung (Körpergewicht, Hürdensprung)|128|none|Mehrere Hürden.
Sprung (Körpergewicht, Tuck Jump)|128|none|Knie anziehen.
Sprung (Körpergewicht, Skaters)|128|none|Seitlicher Sprung auf ein Bein.
Sprung (Körpergewicht, Bounding)|128|none|Lange Sprungschritte.
Sprung (Körpergewicht, Treppensprung)|128|none|Mehrere Stufen springen.
Sprung (Körpergewicht, Sternsprung)|128|none|Arme und Beine öffnen.
Sprung (Körpergewicht, Wadensprung)|128|none|Nur aus den Sprunggelenken.
Plyo Liegestütz (Körpergewicht)|129|none|
Plyo Liegestütz (Körpergewicht, Klatschen)|129|none|Explosiv hochdrücken und klatschen.
Plyo Liegestütz (Körpergewicht, Hände versetzt)|129|none|Hände springen im Wechsel.
Plyo Liegestütz (Körpergewicht, auf der Erhöhung)|129|none|Hände auf der Kiste.
Plyo Liegestütz (Körpergewicht, Superman)|129|none|Arme nach vorn.
Plyo Liegestütz (Körpergewicht, Diamant-Sprung)|129|none|Hände eng.
Plyo Liegestütz (Körpergewicht, Seitwechsel)|129|none|Seitlich über ein Medizinball springen.
Medizinballwurf (Medizinball)|130|medball|Ball nach Technik wählen, lieber leicht und sauber.
Medizinballwurf (Medizinball, Brustpass)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Aus der Brust explosiv nach vorn.
Medizinballwurf (Medizinball, Überkopf-Wurf)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Von hinten über den Kopf.
Medizinballwurf (Medizinball, seitlich rotierend)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Rotationswurf.
Medizinballwurf (Medizinball, Slam)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Von oben auf den Boden.
Medizinballwurf (Medizinball, Schmetterball nach vorn)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Wurf von unten nach vorn.
Medizinballwurf (Medizinball, Kniend)|130|medball|Ball nach Technik wählen, lieber leicht und sauber. Kniend werfen.
Reißen (Langhantel)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Reißen (Langhantel, aus dem Hang)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Start auf Kniehöhe.
Reißen (Langhantel, Power)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ohne tiefe Hocke fangen.
Reißen (Langhantel, Hocke (Squat Snatch))|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. In tiefer Hocke fangen.
Reißen (Langhantel, Split)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Im Ausfallschritt fangen.
Reißen (Langhantel, Ein Arm)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Einarmig.
Reißen (Langhantel, Hang Power)|131|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Hang plus Power-Fang.
Reißen (Kurzhantel)|131|dumbbell|Gewichtsangabe pro Hantel eintragen.
Reißen (Kurzhantel, aus dem Hang)|131|dumbbell|Gewichtsangabe pro Hantel eintragen. Start auf Kniehöhe.
Reißen (Kurzhantel, Power)|131|dumbbell|Gewichtsangabe pro Hantel eintragen. Ohne tiefe Hocke fangen.
Reißen (Kurzhantel, Hocke (Squat Snatch))|131|dumbbell|Gewichtsangabe pro Hantel eintragen. In tiefer Hocke fangen.
Reißen (Kurzhantel, Split)|131|dumbbell|Gewichtsangabe pro Hantel eintragen. Im Ausfallschritt fangen.
Reißen (Kurzhantel, Ein Arm)|131|dumbbell|Gewichtsangabe pro Hantel eintragen. Einarmig.
Reißen (Kurzhantel, Hang Power)|131|dumbbell|Gewichtsangabe pro Hantel eintragen. Hang plus Power-Fang.
Reißen (Kettlebell)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Reißen (Kettlebell, aus dem Hang)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. Start auf Kniehöhe.
Reißen (Kettlebell, Power)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ohne tiefe Hocke fangen.
Reißen (Kettlebell, Hocke (Squat Snatch))|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. In tiefer Hocke fangen.
Reißen (Kettlebell, Split)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. Im Ausfallschritt fangen.
Reißen (Kettlebell, Ein Arm)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. Einarmig.
Reißen (Kettlebell, Hang Power)|131|kettlebell|Gewichtsangabe der Kettlebell eintragen. Hang plus Power-Fang.
Umsetzen (Langhantel)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Umsetzen (Langhantel, aus dem Hang)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Start auf Kniehöhe.
Umsetzen (Langhantel, Power)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Hoch fangen.
Umsetzen (Langhantel, Hocke (Squat Clean))|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. In tiefer Hocke fangen.
Umsetzen (Langhantel, Split)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Ausfallschritt-Fang.
Umsetzen (Langhantel, Umsetzen und Drücken)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Direkt in den Press.
Umsetzen (Langhantel, Ein Arm)|132|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Einarmig.
Umsetzen (Kurzhantel)|132|dumbbell|Gewichtsangabe pro Hantel eintragen.
Umsetzen (Kurzhantel, aus dem Hang)|132|dumbbell|Gewichtsangabe pro Hantel eintragen. Start auf Kniehöhe.
Umsetzen (Kurzhantel, Power)|132|dumbbell|Gewichtsangabe pro Hantel eintragen. Hoch fangen.
Umsetzen (Kurzhantel, Hocke (Squat Clean))|132|dumbbell|Gewichtsangabe pro Hantel eintragen. In tiefer Hocke fangen.
Umsetzen (Kurzhantel, Split)|132|dumbbell|Gewichtsangabe pro Hantel eintragen. Ausfallschritt-Fang.
Umsetzen (Kurzhantel, Umsetzen und Drücken)|132|dumbbell|Gewichtsangabe pro Hantel eintragen. Direkt in den Press.
Umsetzen (Kurzhantel, Ein Arm)|132|dumbbell|Gewichtsangabe pro Hantel eintragen. Einarmig.
Umsetzen (Kettlebell)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Umsetzen (Kettlebell, aus dem Hang)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. Start auf Kniehöhe.
Umsetzen (Kettlebell, Power)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. Hoch fangen.
Umsetzen (Kettlebell, Hocke (Squat Clean))|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. In tiefer Hocke fangen.
Umsetzen (Kettlebell, Split)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ausfallschritt-Fang.
Umsetzen (Kettlebell, Umsetzen und Drücken)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. Direkt in den Press.
Umsetzen (Kettlebell, Ein Arm)|132|kettlebell|Gewichtsangabe der Kettlebell eintragen. Einarmig.
Stoßen (Langhantel)|133|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen.
Stoßen (Langhantel, Push Jerk)|133|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beinschwung, Fang in leichter Hocke.
Stoßen (Langhantel, Split Jerk)|133|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Fang im Ausfallschritt.
Stoßen (Langhantel, Push Press)|133|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Beinschwung ohne Fang.
Stoßen (Langhantel, Ein Arm)|133|barbell|Mit Hantelscheiben beladen, Sicherungsclips benutzen. Einarmig.
Stoßen (Kurzhantel)|133|dumbbell|Gewichtsangabe pro Hantel eintragen.
Stoßen (Kurzhantel, Push Jerk)|133|dumbbell|Gewichtsangabe pro Hantel eintragen. Beinschwung, Fang in leichter Hocke.
Stoßen (Kurzhantel, Split Jerk)|133|dumbbell|Gewichtsangabe pro Hantel eintragen. Fang im Ausfallschritt.
Stoßen (Kurzhantel, Push Press)|133|dumbbell|Gewichtsangabe pro Hantel eintragen. Beinschwung ohne Fang.
Stoßen (Kurzhantel, Ein Arm)|133|dumbbell|Gewichtsangabe pro Hantel eintragen. Einarmig.
Stoßen (Kettlebell)|133|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Stoßen (Kettlebell, Push Jerk)|133|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beinschwung, Fang in leichter Hocke.
Stoßen (Kettlebell, Split Jerk)|133|kettlebell|Gewichtsangabe der Kettlebell eintragen. Fang im Ausfallschritt.
Stoßen (Kettlebell, Push Press)|133|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beinschwung ohne Fang.
Stoßen (Kettlebell, Ein Arm)|133|kettlebell|Gewichtsangabe der Kettlebell eintragen. Einarmig.
Swing (Kettlebell)|134|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Swing (Kettlebell, beidhändig)|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Mit beiden Händen.
Swing (Kettlebell, einarmig)|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Eine Hand.
Swing (Kettlebell, Handwechsel)|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Hand oben wechseln.
Swing (Kettlebell, Russian (auf Brusthöhe))|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Bis zur Brusthöhe.
Swing (Kettlebell, American (über Kopf))|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Bis über den Kopf.
Swing (Kettlebell, Doppel)|134|kettlebell|Gewichtsangabe der Kettlebell eintragen. Zwei Kettlebells.
Turkish Get-up (Kettlebell)|135|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Turkish Get-up (Kettlebell, klassisch)|135|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vollständig.
Turkish Get-up (Kettlebell, Halbes Get-up)|135|kettlebell|Gewichtsangabe der Kettlebell eintragen. Bis zum Ellbogen.
Turkish Get-up (Kettlebell, Zum Knie)|135|kettlebell|Gewichtsangabe der Kettlebell eintragen. Bis zum Kniestand.
Turkish Get-up (Kurzhantel)|135|dumbbell|Gewichtsangabe pro Hantel eintragen.
Turkish Get-up (Kurzhantel, klassisch)|135|dumbbell|Gewichtsangabe pro Hantel eintragen. Vollständig.
Turkish Get-up (Kurzhantel, Halbes Get-up)|135|dumbbell|Gewichtsangabe pro Hantel eintragen. Bis zum Ellbogen.
Turkish Get-up (Kurzhantel, Zum Knie)|135|dumbbell|Gewichtsangabe pro Hantel eintragen. Bis zum Kniestand.
Turkish Get-up (Körpergewicht)|135|none|
Turkish Get-up (Körpergewicht, klassisch)|135|none|Vollständig.
Turkish Get-up (Körpergewicht, Halbes Get-up)|135|none|Bis zum Ellbogen.
Turkish Get-up (Körpergewicht, Zum Knie)|135|none|Bis zum Kniestand.
Goblet (Kettlebell)|136|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Goblet (Kettlebell, Kniebeuge)|136|kettlebell|Gewichtsangabe der Kettlebell eintragen. Klassische Hocke.
Goblet (Kettlebell, Cossack)|136|kettlebell|Gewichtsangabe der Kettlebell eintragen. Seitlich tief.
Goblet (Kettlebell, Reverse Lunge)|136|kettlebell|Gewichtsangabe der Kettlebell eintragen. Ausfallschritt zurück.
Goblet (Kettlebell, Pause unten)|136|kettlebell|Gewichtsangabe der Kettlebell eintragen. 2 s unten.
Goblet (Kurzhantel)|136|dumbbell|Gewichtsangabe pro Hantel eintragen.
Goblet (Kurzhantel, Kniebeuge)|136|dumbbell|Gewichtsangabe pro Hantel eintragen. Klassische Hocke.
Goblet (Kurzhantel, Cossack)|136|dumbbell|Gewichtsangabe pro Hantel eintragen. Seitlich tief.
Goblet (Kurzhantel, Reverse Lunge)|136|dumbbell|Gewichtsangabe pro Hantel eintragen. Ausfallschritt zurück.
Goblet (Kurzhantel, Pause unten)|136|dumbbell|Gewichtsangabe pro Hantel eintragen. 2 s unten.
Goblet (Hantelscheibe)|136|barbell|Scheibe mit beiden Händen fest greifen.
Goblet (Hantelscheibe, Kniebeuge)|136|barbell|Scheibe mit beiden Händen fest greifen. Klassische Hocke.
Goblet (Hantelscheibe, Cossack)|136|barbell|Scheibe mit beiden Händen fest greifen. Seitlich tief.
Goblet (Hantelscheibe, Reverse Lunge)|136|barbell|Scheibe mit beiden Händen fest greifen. Ausfallschritt zurück.
Goblet (Hantelscheibe, Pause unten)|136|barbell|Scheibe mit beiden Händen fest greifen. 2 s unten.
Windmühle (Kettlebell)|137|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Windmühle (Kettlebell, klassisch)|137|kettlebell|Gewichtsangabe der Kettlebell eintragen. Standard.
Windmühle (Kettlebell, Low Windmill)|137|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur die untere Hand zum Boden.
Windmühle (Kettlebell, Bent Press)|137|kettlebell|Gewichtsangabe der Kettlebell eintragen. Mit Presse.
Windmühle (Kurzhantel)|137|dumbbell|Gewichtsangabe pro Hantel eintragen.
Windmühle (Kurzhantel, klassisch)|137|dumbbell|Gewichtsangabe pro Hantel eintragen. Standard.
Windmühle (Kurzhantel, Low Windmill)|137|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur die untere Hand zum Boden.
Windmühle (Kurzhantel, Bent Press)|137|dumbbell|Gewichtsangabe pro Hantel eintragen. Mit Presse.
Schlittenschieben (Schlitten)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte.
Schlittenschieben (Schlitten, Schieben)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte. Hände am Rahmen.
Schlittenschieben (Schlitten, Ziehen rückwärts)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte. Mit Gurt.
Schlittenschieben (Schlitten, Ziehen mit Seil)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte. Seil in den Händen.
Schlittenschieben (Schlitten, Schwer, kurz)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte. Kurze Distanz, schwer.
Schlittenschieben (Schlitten, Leicht, schnell)|138|machine|Mit flachem Rücken schieben oder ziehen, kurze Schritte. Sprint.
Battle Rope (Battle Rope)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen.
Battle Rope (Battle Rope, Wechselschlag)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Arme im Wechsel.
Battle Rope (Battle Rope, Doppelschlag)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Beide gleichzeitig.
Battle Rope (Battle Rope, Slam)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Wuchtig auf den Boden.
Battle Rope (Battle Rope, Kreise)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Seilkreise.
Battle Rope (Battle Rope, Seitwellen)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Seitliche Wellen.
Battle Rope (Battle Rope, Jumping Jack)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Mit Sprung.
Battle Rope (Battle Rope, Hocke)|139|machine|Seil mit Körperspannung führen, nicht nur aus den Armen. Aus tiefer Hocke.
Reifenkippen (Reifen)|140|outdoor|Reifen mit geradem Rücken aus der Hocke anheben.
Reifenkippen (Reifen, Flip)|140|outdoor|Reifen mit geradem Rücken aus der Hocke anheben. Wuchtig kippen.
Reifenkippen (Reifen, Hammerschlag)|140|outdoor|Reifen mit geradem Rücken aus der Hocke anheben. Mit Vorschlaghammer auf Reifen.
Reifenkippen (Reifen, Sprung auf Reifen)|140|outdoor|Reifen mit geradem Rücken aus der Hocke anheben. Springen.
Farmer’s Walk (Kurzhantel)|141|dumbbell|Gewichtsangabe pro Hantel eintragen.
Farmer’s Walk (Kurzhantel, klassisch)|141|dumbbell|Gewichtsangabe pro Hantel eintragen. Beidseitig.
Farmer’s Walk (Kurzhantel, einseitig (Suitcase))|141|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur eine Seite.
Farmer’s Walk (Kurzhantel, vor der Brust)|141|dumbbell|Gewichtsangabe pro Hantel eintragen. Vor der Brust (Rack).
Farmer’s Walk (Kurzhantel, über Kopf)|141|dumbbell|Gewichtsangabe pro Hantel eintragen. Über Kopf.
Farmer’s Walk (Kurzhantel, Waiter Walk)|141|dumbbell|Gewichtsangabe pro Hantel eintragen. Nur eine Hand über Kopf.
Farmer’s Walk (Kettlebell)|141|kettlebell|Gewichtsangabe der Kettlebell eintragen.
Farmer’s Walk (Kettlebell, klassisch)|141|kettlebell|Gewichtsangabe der Kettlebell eintragen. Beidseitig.
Farmer’s Walk (Kettlebell, einseitig (Suitcase))|141|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur eine Seite.
Farmer’s Walk (Kettlebell, vor der Brust)|141|kettlebell|Gewichtsangabe der Kettlebell eintragen. Vor der Brust (Rack).
Farmer’s Walk (Kettlebell, über Kopf)|141|kettlebell|Gewichtsangabe der Kettlebell eintragen. Über Kopf.
Farmer’s Walk (Kettlebell, Waiter Walk)|141|kettlebell|Gewichtsangabe der Kettlebell eintragen. Nur eine Hand über Kopf.
Farmer’s Walk (Trap-Bar)|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig.
Farmer’s Walk (Trap-Bar, klassisch)|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Beidseitig.
Farmer’s Walk (Trap-Bar, einseitig (Suitcase))|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Nur eine Seite.
Farmer’s Walk (Trap-Bar, vor der Brust)|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Vor der Brust (Rack).
Farmer’s Walk (Trap-Bar, über Kopf)|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Über Kopf.
Farmer’s Walk (Trap-Bar, Waiter Walk)|141|barbell|Griffhöhe nach Beweglichkeit wählen, Last bleibt mittig. Nur eine Hand über Kopf.
Farmer’s Walk (Hantelscheibe)|141|barbell|Scheibe mit beiden Händen fest greifen.
Farmer’s Walk (Hantelscheibe, klassisch)|141|barbell|Scheibe mit beiden Händen fest greifen. Beidseitig.
Farmer’s Walk (Hantelscheibe, einseitig (Suitcase))|141|barbell|Scheibe mit beiden Händen fest greifen. Nur eine Seite.
Farmer’s Walk (Hantelscheibe, vor der Brust)|141|barbell|Scheibe mit beiden Händen fest greifen. Vor der Brust (Rack).
Farmer’s Walk (Hantelscheibe, über Kopf)|141|barbell|Scheibe mit beiden Händen fest greifen. Über Kopf.
Farmer’s Walk (Hantelscheibe, Waiter Walk)|141|barbell|Scheibe mit beiden Händen fest greifen. Nur eine Hand über Kopf.
Farmer’s Walk (Sandsack)|141|outdoor|Sandsack fest packen, damit nichts verrutscht.
Farmer’s Walk (Sandsack, klassisch)|141|outdoor|Sandsack fest packen, damit nichts verrutscht. Beidseitig.
Farmer’s Walk (Sandsack, einseitig (Suitcase))|141|outdoor|Sandsack fest packen, damit nichts verrutscht. Nur eine Seite.
Farmer’s Walk (Sandsack, vor der Brust)|141|outdoor|Sandsack fest packen, damit nichts verrutscht. Vor der Brust (Rack).
Farmer’s Walk (Sandsack, über Kopf)|141|outdoor|Sandsack fest packen, damit nichts verrutscht. Über Kopf.
Farmer’s Walk (Sandsack, Waiter Walk)|141|outdoor|Sandsack fest packen, damit nichts verrutscht. Nur eine Hand über Kopf.
Sandsack-Training (Sandsack)|142|outdoor|Sandsack fest packen, damit nichts verrutscht.
Sandsack-Training (Sandsack, Bear Hug Squat)|142|outdoor|Sandsack fest packen, damit nichts verrutscht. Sack vor der Brust.
Sandsack-Training (Sandsack, Schulter-Tragen)|142|outdoor|Sandsack fest packen, damit nichts verrutscht. Auf der Schulter tragen.
Sandsack-Training (Sandsack, Clean)|142|outdoor|Sandsack fest packen, damit nichts verrutscht. Vom Boden zur Schulter.
Sandsack-Training (Sandsack, Wurf nach vorn)|142|outdoor|Sandsack fest packen, damit nichts verrutscht. Wegschleudern.
Sandsack-Training (Sandsack, Zercher Squat)|142|outdoor|Sandsack fest packen, damit nichts verrutscht. Im Ellbogen.
Medizinball-Slam (Medizinball)|143|medball|Ball nach Technik wählen, lieber leicht und sauber.
Medizinball-Slam (Medizinball, klassisch)|143|medball|Ball nach Technik wählen, lieber leicht und sauber. Über Kopf nach unten.
Medizinball-Slam (Medizinball, seitlich)|143|medball|Ball nach Technik wählen, lieber leicht und sauber. Schräg.
Medizinball-Slam (Medizinball, Rotation)|143|medball|Ball nach Technik wählen, lieber leicht und sauber. Mit Drehung.
Fingerhang & Griff (Stange)|144|bar|
Fingerhang & Griff (Stange, beidarmig)|144|bar|Beide Arme.
Fingerhang & Griff (Stange, einarmig)|144|bar|Ein Arm.
Fingerhang & Griff (Stange, mit Zusatzgewicht)|144|bar|Gürtel/Weste.
Fingerhang & Griff (Stange, Fingerboard)|144|bar|Kleine Leiste.
Fingerhang & Griff (Stange, Towel Hang)|144|bar|Handtuch greifen.
Fingerhang & Griff (Ringe)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen.
Fingerhang & Griff (Ringe, beidarmig)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Beide Arme.
Fingerhang & Griff (Ringe, einarmig)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Ein Arm.
Fingerhang & Griff (Ringe, mit Zusatzgewicht)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Gürtel/Weste.
Fingerhang & Griff (Ringe, Fingerboard)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Kleine Leiste.
Fingerhang & Griff (Ringe, Towel Hang)|144|sling|Ringe instabil halten, Schultern aktiv nach unten ziehen. Handtuch greifen.
Schattenboxen|145|none|
Schattenboxen (Jab-Cross)|145|none|Gerade Schläge.
Schattenboxen (Haken)|145|none|Seitliche Schläge.
Schattenboxen (Uppercut)|145|none|Von unten.
Schattenboxen (Kombinationen)|145|none|Längere Folgen.
Schattenboxen (mit Ausweichen)|145|none|Pendeln und Ducken.
Schattenboxen (Kicks)|145|none|Mit Tritten.
Sandsack-Schlagen|146|none|
Sandsack-Schlagen (Jab-Cross)|146|none|Gerade Kombination.
Sandsack-Schlagen (Haken)|146|none|Seitlich.
Sandsack-Schlagen (Low Kicks)|146|none|Leichte Tritte.
Sandsack-Schlagen (Knie)|146|none|Muay-Thai-Knie.
Sandsack-Schlagen (Runden 3 min)|146|none|3 min Arbeit, 1 min Pause.
Beintritte|147|none|
Beintritte (Front Kick)|147|none|Gerade nach vorn.
Beintritte (Roundhouse)|147|none|Seitlich im Bogen.
Beintritte (Side Kick)|147|none|Seitlich.
Beintritte (Back Kick)|147|none|Nach hinten.
Beintritte (Knieschlag)|147|none|Knie nach oben.
Ausweichen & Beinarbeit|148|none|
Ausweichen & Beinarbeit (Schattenbeinarbeit)|148|none|Vor und zurück.
Ausweichen & Beinarbeit (Pendeln)|148|none|Unter dem Schlag wegtauchen.
Ausweichen & Beinarbeit (Seilspringen Boxer)|148|none|Locker federn.
Ausweichen & Beinarbeit (Seitschritt)|148|none|Seitlich schieben.
Bärengang & Kriechen (Körpergewicht)|149|none|
Bärengang & Kriechen (Körpergewicht, Bärengang)|149|none|Knie knapp über dem Boden.
Bärengang & Kriechen (Körpergewicht, Krabbengang)|149|none|Rückenlage, Hüfte oben.
Bärengang & Kriechen (Körpergewicht, Käfergang)|149|none|Unter der Hüfte.
Bärengang & Kriechen (Körpergewicht, Seitwärts)|149|none|Seitlich.
Bärengang & Kriechen (Körpergewicht, Rückwärts)|149|none|Rückwärts.
Bärengang & Kriechen (Körpergewicht, Löwengang)|149|none|Weite Schritte.
Bärengang & Kriechen (Körpergewicht, Froschgang)|149|none|Hocke mit Hüpfen.
Bärengang & Kriechen (Körpergewicht, Gorilla)|149|none|Tief seitlich.
Bärengang & Kriechen (Körpergewicht, Leopard)|149|none|Flach am Boden.
Feuerwehr-Fitness|150|none|
Feuerwehr-Fitness (Treppensteigen mit Last)|150|none|Schwer im Rucksack.
Feuerwehr-Fitness (Schlauch ziehen (Seil ziehen))|150|none|Seil zu sich ziehen.
Feuerwehr-Fitness (Dummy-Zug)|150|none|Last hinter sich herziehen.
Feuerwehr-Fitness (Leiterhochsteigen)|150|none|Leiter oder Stepper.
Feuerwehr-Fitness (Hammerschlag auf Reifen)|150|none|Aus Hüfte und Schultern.
Feuerwehr-Fitness (Hindernisparcours)|150|none|Mehrere Stationen.
Feuerwehr-Fitness (Atemschutz-Lauf)|150|none|Ruhig atmen.
Klettern (Stange)|151|bar|
Klettern (Stange, Seilklettern)|151|bar|Beine klemmen.
Klettern (Stange, Bouldern an der Wand)|151|bar|Kurze Routen.
Klettern (Stange, Kletterwand-Intervall)|151|bar|Kurz und intensiv.
Klettern (Stange, Dachkante hängen)|151|bar|Hängen und klettern.
Klettern (Wand)|151|none|Fläche und Boden müssen rutschfest sein.
Klettern (Wand, Seilklettern)|151|none|Fläche und Boden müssen rutschfest sein. Beine klemmen.
Klettern (Wand, Bouldern an der Wand)|151|none|Fläche und Boden müssen rutschfest sein. Kurze Routen.
Klettern (Wand, Kletterwand-Intervall)|151|none|Fläche und Boden müssen rutschfest sein. Kurz und intensiv.
Klettern (Wand, Dachkante hängen)|151|none|Fläche und Boden müssen rutschfest sein. Hängen und klettern.
Hügelsprint (Draußen)|152|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Hügelsprint (Draußen, kurz)|152|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. 10 s.
Hügelsprint (Draußen, mittel)|152|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. 20 s.
Hügelsprint (Draußen, lang)|152|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. 40 s.
Hügelsprint (Draußen, Trabrückweg)|152|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Locker zurück.
Treppentraining (Treppe)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit.
Treppentraining (Treppe, Steigen)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Normal.
Treppentraining (Treppe, Zwei Stufen)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Jede zweite Stufe.
Treppentraining (Treppe, Sprünge)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Beidbeinig hoch.
Treppentraining (Treppe, Seitwärts)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Seitlich.
Treppentraining (Treppe, Einbeinig)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Mit einem Bein.
Treppentraining (Treppe, Sprint)|153|outdoor|Immer ganzen Fuß aufsetzen, Handlauf nur zur Sicherheit. Schnell hoch.
Parkour-Grundübungen (Draußen)|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Parkour-Grundübungen (Draußen, Präzisionssprung)|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Genau treffen.
Parkour-Grundübungen (Draußen, Rolle)|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Über die Schulter abrollen.
Parkour-Grundübungen (Draußen, Vault (Hürde überwinden))|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mit einer Hand abstützen.
Parkour-Grundübungen (Draußen, Balancieren)|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Auf Balken.
Parkour-Grundübungen (Draußen, Katzensprung)|154|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. An der Wand hängen.
Calisthenics im Park (Stange)|155|bar|
Calisthenics im Park (Stange, Klimmzug-Variante)|155|bar|Mit variierendem Griff.
Calisthenics im Park (Stange, Dips an der Parkbank)|155|bar|Zwischen Stützen.
Calisthenics im Park (Stange, Liegestütze an der Bank)|155|bar|Erhöht.
Calisthenics im Park (Stange, Beinheben an der Stange)|155|bar|Hängend.
Calisthenics im Park (Stange, Bankstütz)|155|bar|Hände auf Bank.
Calisthenics im Park (Draußen)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Calisthenics im Park (Draußen, Klimmzug-Variante)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mit variierendem Griff.
Calisthenics im Park (Draußen, Dips an der Parkbank)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Zwischen Stützen.
Calisthenics im Park (Draußen, Liegestütze an der Bank)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Erhöht.
Calisthenics im Park (Draußen, Beinheben an der Stange)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Hängend.
Calisthenics im Park (Draußen, Bankstütz)|155|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Hände auf Bank.
Wanderung (Draußen)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Wanderung (Draußen, flach)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Eben.
Wanderung (Draußen, bergauf)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Hoch.
Wanderung (Draußen, bergab)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Bergab, kontrolliert.
Wanderung (Draußen, mit Rucksack)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mit Gepäck.
Wanderung (Draußen, Mehrtagestour)|156|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Mehrere Tage.
Kajak & Wassersport (Schwimmbad)|157|pool|
Kajak & Wassersport (Schwimmbad, Paddeln)|157|pool|Gleichmäßig.
Kajak & Wassersport (Schwimmbad, Intervalle)|157|pool|Kurz und hart.
Kajak & Wassersport (Schwimmbad, Stand-up-Paddling)|157|pool|Stehend.
Kajak & Wassersport (Draußen)|157|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Kajak & Wassersport (Draußen, Paddeln)|157|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Gleichmäßig.
Kajak & Wassersport (Draußen, Intervalle)|157|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Kurz und hart.
Kajak & Wassersport (Draußen, Stand-up-Paddling)|157|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Stehend.
Skilanglauf-Imitation (Draußen)|158|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten.
Skilanglauf-Imitation (Draußen, klassisch)|158|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Diagonalschritt.
Skilanglauf-Imitation (Draußen, Skating)|158|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Seitliche Schritte.
Skilanglauf-Imitation (Draußen, Doppelstock)|158|outdoor|Auf ebenen, rutschfesten Untergrund und passende Schuhe achten. Beide Stöcke.
Skilanglauf-Imitation (Cardio-Gerät)|158|cardio|
Skilanglauf-Imitation (Cardio-Gerät, klassisch)|158|cardio|Diagonalschritt.
Skilanglauf-Imitation (Cardio-Gerät, Skating)|158|cardio|Seitliche Schritte.
Skilanglauf-Imitation (Cardio-Gerät, Doppelstock)|158|cardio|Beide Stöcke.
Yoga (Körpergewicht)|159|none|
Yoga (Körpergewicht, Kind (Balasana))|159|none|Stirn auf den Boden, Arme nach vorn.
Yoga (Körpergewicht, Katze-Kuh)|159|none|Wirbelsäule im Wechsel runden und strecken.
Yoga (Körpergewicht, Herabschauender Hund)|159|none|Hüfte hoch, Fersen Richtung Boden.
Yoga (Körpergewicht, Kobra)|159|none|Brust heben, Beine ruhig.
Yoga (Körpergewicht, Krieger I)|159|none|Hinteres Bein gestreckt, Hüfte nach vorn.
Yoga (Körpergewicht, Krieger II)|159|none|Weite Grätsche, Blick über die Hand.
Yoga (Körpergewicht, Dreieck)|159|none|Seitlich öffnen.
Yoga (Körpergewicht, Baum)|159|none|Auf einem Bein stehen.
Yoga (Körpergewicht, Taube)|159|none|Hüfte öffnen.
Yoga (Körpergewicht, Brücke)|159|none|Hüfte heben.
Yoga (Körpergewicht, Boot)|159|none|V-Sitz.
Yoga (Körpergewicht, Stuhl)|159|none|Hocke mit hohem Armen.
Yoga (Körpergewicht, Raupe (Uttanasana))|159|none|Vorbeuge.
Yoga (Körpergewicht, Sonnengruß A)|159|none|Fließende Folge.
Yoga (Körpergewicht, Sonnengruß B)|159|none|Fließende Folge, tiefer.
Yoga (Körpergewicht, Drehsitz)|159|none|Wirbelsäule drehen.
Yoga (Körpergewicht, Krieger III)|159|none|Balance auf einem Bein.
Yoga (Körpergewicht, Halber Mond)|159|none|Seitliche Balance.
Yoga (Körpergewicht, Pflug)|159|none|Beine über den Kopf (nur wenn geübt).
Yoga (Körpergewicht, Kamel)|159|none|Brust öffnen.
Pilates (Körpergewicht)|160|none|
Pilates (Körpergewicht, Hundred)|160|none|Arme pumpen, Beine in der Luft.
Pilates (Körpergewicht, Roll-up)|160|none|Wirbel für Wirbel.
Pilates (Körpergewicht, Single Leg Stretch)|160|none|Knie abwechselnd zur Brust.
Pilates (Körpergewicht, Double Leg Stretch)|160|none|Beide Beine.
Pilates (Körpergewicht, Schere)|160|none|Beine abwechselnd.
Pilates (Körpergewicht, Teaser)|160|none|V-Position.
Pilates (Körpergewicht, Swan)|160|none|Brust heben.
Pilates (Körpergewicht, Seitlicher Beinkreis)|160|none|Seitlage.
Pilates (Körpergewicht, Swimming)|160|none|Bauchlage, Arme/Beine im Wechsel.
Pilates (Körpergewicht, Spine Stretch)|160|none|Wirbelsäule langziehen.
Pilates (Widerstandsband)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Pilates (Widerstandsband, Hundred)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Arme pumpen, Beine in der Luft.
Pilates (Widerstandsband, Roll-up)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Wirbel für Wirbel.
Pilates (Widerstandsband, Single Leg Stretch)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie abwechselnd zur Brust.
Pilates (Widerstandsband, Double Leg Stretch)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beide Beine.
Pilates (Widerstandsband, Schere)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beine abwechselnd.
Pilates (Widerstandsband, Teaser)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. V-Position.
Pilates (Widerstandsband, Swan)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Brust heben.
Pilates (Widerstandsband, Seitlicher Beinkreis)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage.
Pilates (Widerstandsband, Swimming)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bauchlage, Arme/Beine im Wechsel.
Pilates (Widerstandsband, Spine Stretch)|160|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Wirbelsäule langziehen.
Pilates (Medizinball)|160|medball|Ball nach Technik wählen, lieber leicht und sauber.
Pilates (Medizinball, Hundred)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Arme pumpen, Beine in der Luft.
Pilates (Medizinball, Roll-up)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Wirbel für Wirbel.
Pilates (Medizinball, Single Leg Stretch)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Knie abwechselnd zur Brust.
Pilates (Medizinball, Double Leg Stretch)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Beide Beine.
Pilates (Medizinball, Schere)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Beine abwechselnd.
Pilates (Medizinball, Teaser)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. V-Position.
Pilates (Medizinball, Swan)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Brust heben.
Pilates (Medizinball, Seitlicher Beinkreis)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Seitlage.
Pilates (Medizinball, Swimming)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Bauchlage, Arme/Beine im Wechsel.
Pilates (Medizinball, Spine Stretch)|160|medball|Ball nach Technik wählen, lieber leicht und sauber. Wirbelsäule langziehen.
Nackendehnung (Körpergewicht)|161|none|
Nackendehnung (Körpergewicht, seitlich)|161|none|Ohr zur Schulter.
Nackendehnung (Körpergewicht, schräg vorn)|161|none|Nase zur Achsel.
Nackendehnung (Körpergewicht, vorn)|161|none|Kinn zur Brust.
Nackendehnung (Körpergewicht, mit Hand)|161|none|Hand zieht sanft.
Nackendehnung (Körpergewicht, Kopfdrehung)|161|none|Blick zur Schulter.
Schulterdehnung (Körpergewicht)|162|none|
Schulterdehnung (Körpergewicht, Arm quer vor dem Körper)|162|none|Arm quer zur Gegenseite ziehen.
Schulterdehnung (Körpergewicht, Arm hinter dem Rücken)|162|none|Hand hinter den Rücken.
Schulterdehnung (Körpergewicht, Tür-Dehnung)|162|none|Unterarm am Türrahmen.
Schulterdehnung (Körpergewicht, Schlafposition)|162|none|Seitlage, Unterarm sanft drücken.
Schulterdehnung (Körpergewicht, Handtuch)|162|none|Handtuch hinter dem Rücken.
Schulterdehnung (Körpergewicht, Wand)|162|none|Hand an der Wand.
Schulterdehnung (Körpergewicht, Arm über Kopf)|162|none|Ellbogen hinter den Kopf ziehen.
Brustdehnung (Körpergewicht)|163|none|
Brustdehnung (Körpergewicht, im Türrahmen)|163|none|Unterarm am Rahmen.
Brustdehnung (Körpergewicht, Hände hinter dem Rücken)|163|none|Hände verschränken, Arme heben.
Brustdehnung (Körpergewicht, auf dem Boden)|163|none|Bauchlage, Arm seitlich.
Brustdehnung (Körpergewicht, an der Stange)|163|none|Hand an Stange, wegdrehen.
Brustdehnung (Körpergewicht, Faszienrolle quer)|163|none|Rolle längs der Wirbelsäule.
Brustdehnung (Faszienrolle)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken.
Brustdehnung (Faszienrolle, im Türrahmen)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Unterarm am Rahmen.
Brustdehnung (Faszienrolle, Hände hinter dem Rücken)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Hände verschränken, Arme heben.
Brustdehnung (Faszienrolle, auf dem Boden)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Bauchlage, Arm seitlich.
Brustdehnung (Faszienrolle, an der Stange)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Hand an Stange, wegdrehen.
Brustdehnung (Faszienrolle, Faszienrolle quer)|163|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Rolle längs der Wirbelsäule.
Trizepsdehnung (Körpergewicht)|164|none|
Trizepsdehnung (Körpergewicht, Überkopf)|164|none|Ellbogen nach oben ziehen.
Trizepsdehnung (Körpergewicht, mit Handtuch)|164|none|Handtuch im Nacken.
Trizepsdehnung (Körpergewicht, Wand)|164|none|Ellbogen an der Wand.
Rückendehnung (Körpergewicht)|165|none|
Rückendehnung (Körpergewicht, Kind-Position)|165|none|Gesäß zu den Fersen, Arme vorn.
Rückendehnung (Körpergewicht, Katze-Kuh)|165|none|Wirbelsäule rund/lang.
Rückendehnung (Körpergewicht, Knie zur Brust)|165|none|Rückenlage.
Rückendehnung (Körpergewicht, Rotation in Rückenlage)|165|none|Knie fallen seitlich.
Rückendehnung (Körpergewicht, Seitbeuge im Stand)|165|none|Arm über Kopf.
Rückendehnung (Körpergewicht, Hängende Dehnung)|165|none|Hängen an der Stange.
Rückendehnung (Körpergewicht, Nadelöhr)|165|none|Arm unter dem Körper hindurch.
Rückendehnung (Körpergewicht, Sphinx)|165|none|Unterarme, Brust heben.
Rückendehnung (Körpergewicht, Vorbeuge im Sitzen)|165|none|Beine gestreckt.
Rückendehnung (Körpergewicht, Latissimus am Türrahmen)|165|none|Hände am Rahmen, Hüfte zurück.
Rückendehnung (Faszienrolle)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken.
Rückendehnung (Faszienrolle, Kind-Position)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Gesäß zu den Fersen, Arme vorn.
Rückendehnung (Faszienrolle, Katze-Kuh)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Wirbelsäule rund/lang.
Rückendehnung (Faszienrolle, Knie zur Brust)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Rückenlage.
Rückendehnung (Faszienrolle, Rotation in Rückenlage)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Knie fallen seitlich.
Rückendehnung (Faszienrolle, Seitbeuge im Stand)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Arm über Kopf.
Rückendehnung (Faszienrolle, Hängende Dehnung)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Hängen an der Stange.
Rückendehnung (Faszienrolle, Nadelöhr)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Arm unter dem Körper hindurch.
Rückendehnung (Faszienrolle, Sphinx)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Unterarme, Brust heben.
Rückendehnung (Faszienrolle, Vorbeuge im Sitzen)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Beine gestreckt.
Rückendehnung (Faszienrolle, Latissimus am Türrahmen)|165|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Hände am Rahmen, Hüfte zurück.
Hüftdehnung (Körpergewicht)|166|none|
Hüftdehnung (Körpergewicht, Hüftbeuger-Ausfallschritt)|166|none|Hinteres Knie am Boden, Hüfte vor.
Hüftdehnung (Körpergewicht, Taube)|166|none|Unterschenkel quer.
Hüftdehnung (Körpergewicht, Schmetterling)|166|none|Fußsohlen zusammen.
Hüftdehnung (Körpergewicht, Frosch)|166|none|Knie weit, Hüfte zurück.
Hüftdehnung (Körpergewicht, Tiefe Hocke)|166|none|Ellbogen drücken Knie.
Hüftdehnung (Körpergewicht, 90/90)|166|none|Beide Knie 90°.
Hüftdehnung (Körpergewicht, Figur-Vier)|166|none|Fuß auf Knie.
Hüftdehnung (Körpergewicht, Adduktoren seitlich)|166|none|Grätsche, Gewicht verlagern.
Hüftdehnung (Körpergewicht, Piriformis)|166|none|Rückenlage.
Hüftdehnung (Körpergewicht, Couch-Stretch)|166|none|Fuß an der Wand.
Hüftdehnung (Körpergewicht, Glute Bridge Hold)|166|none|Kurzer Halt.
Oberschenkeldehnung (Körpergewicht)|167|none|
Oberschenkeldehnung (Körpergewicht, Quadrizeps stehend)|167|none|Ferse zum Gesäß.
Oberschenkeldehnung (Körpergewicht, Quadrizeps liegend)|167|none|Seitlage.
Oberschenkeldehnung (Körpergewicht, Beinbeuger sitzend)|167|none|Vorbeuge.
Oberschenkeldehnung (Körpergewicht, Beinbeuger im Stand)|167|none|Ferse auf Erhöhung.
Oberschenkeldehnung (Körpergewicht, Beinbeuger liegend mit Band)|167|none|Band um den Fuß.
Oberschenkeldehnung (Körpergewicht, Adduktoren)|167|none|Grätsche.
Oberschenkeldehnung (Körpergewicht, Abduktoren (ITB))|167|none|Beine kreuzen.
Oberschenkeldehnung (Körpergewicht, Kniesehne im Ausfallschritt)|167|none|Vorderbein gestreckt.
Oberschenkeldehnung (Widerstandsband)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Oberschenkeldehnung (Widerstandsband, Quadrizeps stehend)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ferse zum Gesäß.
Oberschenkeldehnung (Widerstandsband, Quadrizeps liegend)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage.
Oberschenkeldehnung (Widerstandsband, Beinbeuger sitzend)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorbeuge.
Oberschenkeldehnung (Widerstandsband, Beinbeuger im Stand)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ferse auf Erhöhung.
Oberschenkeldehnung (Widerstandsband, Beinbeuger liegend mit Band)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Band um den Fuß.
Oberschenkeldehnung (Widerstandsband, Adduktoren)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Grätsche.
Oberschenkeldehnung (Widerstandsband, Abduktoren (ITB))|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Beine kreuzen.
Oberschenkeldehnung (Widerstandsband, Kniesehne im Ausfallschritt)|167|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Vorderbein gestreckt.
Wadendehnung (Körpergewicht)|168|none|
Wadendehnung (Körpergewicht, an der Wand, gestreckt)|168|none|Hinteres Bein gestreckt.
Wadendehnung (Körpergewicht, an der Wand, gebeugt)|168|none|Knie gebeugt (Soleus).
Wadendehnung (Körpergewicht, auf der Treppenstufe)|168|none|Ferse tiefer.
Wadendehnung (Körpergewicht, Herabschauender Hund)|168|none|Fersen abwechselnd.
Wadendehnung (Körpergewicht, mit Band)|168|none|Band um den Fuß.
Wadendehnung (Widerstandsband)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Wadendehnung (Widerstandsband, an der Wand, gestreckt)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hinteres Bein gestreckt.
Wadendehnung (Widerstandsband, an der Wand, gebeugt)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie gebeugt (Soleus).
Wadendehnung (Widerstandsband, auf der Treppenstufe)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Ferse tiefer.
Wadendehnung (Widerstandsband, Herabschauender Hund)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Fersen abwechselnd.
Wadendehnung (Widerstandsband, mit Band)|168|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Band um den Fuß.
Sprunggelenk-Mobilisation (Körpergewicht)|169|none|
Sprunggelenk-Mobilisation (Körpergewicht, Knie zur Wand)|169|none|Knie über den Zeh bringen.
Sprunggelenk-Mobilisation (Körpergewicht, Kreisen)|169|none|Fuß kreisen.
Sprunggelenk-Mobilisation (Körpergewicht, Tiefe Hocke halten)|169|none|Tief sitzen.
Sprunggelenk-Mobilisation (Körpergewicht, Fußwippe)|169|none|Zehen heben/senken.
Sprunggelenk-Mobilisation (Körpergewicht, Band-Mobilisation)|169|none|Band zieht den Unterschenkel.
Sprunggelenk-Mobilisation (Widerstandsband)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Sprunggelenk-Mobilisation (Widerstandsband, Knie zur Wand)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie über den Zeh bringen.
Sprunggelenk-Mobilisation (Widerstandsband, Kreisen)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Fuß kreisen.
Sprunggelenk-Mobilisation (Widerstandsband, Tiefe Hocke halten)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Tief sitzen.
Sprunggelenk-Mobilisation (Widerstandsband, Fußwippe)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen heben/senken.
Sprunggelenk-Mobilisation (Widerstandsband, Band-Mobilisation)|169|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Band zieht den Unterschenkel.
Handgelenk-Mobilisation (Körpergewicht)|170|none|
Handgelenk-Mobilisation (Körpergewicht, Kreisen)|170|none|Große Kreise.
Handgelenk-Mobilisation (Körpergewicht, Vierfüßler-Wippe)|170|none|Hände flach, Gewicht vor/zurück.
Handgelenk-Mobilisation (Körpergewicht, Beuger dehnen)|170|none|Handfläche nach vorn.
Handgelenk-Mobilisation (Körpergewicht, Strecker dehnen)|170|none|Handrücken zu sich.
Handgelenk-Mobilisation (Körpergewicht, Gebet)|170|none|Handflächen zusammen.
Handgelenk-Mobilisation (Körpergewicht, Rückwärts-Hände)|170|none|Finger zu den Knien.
Faszienrolle (Faszienrolle)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken.
Faszienrolle (Faszienrolle, Oberschenkel vorne)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Auf dem Bauch rollen.
Faszienrolle (Faszienrolle, Oberschenkel hinten)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Im Sitz rollen.
Faszienrolle (Faszienrolle, Waden)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Beine gestreckt.
Faszienrolle (Faszienrolle, Gesäß)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Auf der Rolle sitzen.
Faszienrolle (Faszienrolle, Außenseite (ITB))|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Seitlage.
Faszienrolle (Faszienrolle, oberer Rücken)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Arme vor der Brust.
Faszienrolle (Faszienrolle, Latissimus)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Seitlage.
Faszienrolle (Faszienrolle, Brust)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Auf dem Bauch an der Rolle.
Faszienrolle (Faszienrolle, Fußsohle)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Mit Ball.
Faszienrolle (Faszienrolle, Nacken)|171|foam|Langsam rollen, auf Druckpunkten kurz verweilen, nie auf Gelenken. Kopf auf der Rolle.
Schulter-Aktivierung (Körpergewicht)|172|none|
Schulter-Aktivierung (Körpergewicht, Wall Slides)|172|none|Rücken an der Wand, Arme gleiten.
Schulter-Aktivierung (Körpergewicht, Band Pull-Apart)|172|none|Band auseinanderziehen.
Schulter-Aktivierung (Körpergewicht, Schulterkreisen)|172|none|Große Kreise.
Schulter-Aktivierung (Körpergewicht, Y-T-W)|172|none|Bauchlage, Arme in Buchstaben.
Schulter-Aktivierung (Körpergewicht, Außenrotation liegend)|172|none|Seitlage, Hantel leicht.
Schulter-Aktivierung (Körpergewicht, Scapula Push-up)|172|none|Nur Schulterblätter bewegen.
Schulter-Aktivierung (Körpergewicht, Face Pull leicht)|172|none|Leichtes Band.
Schulter-Aktivierung (Körpergewicht, Bear Hold)|172|none|Knie 2 cm über dem Boden.
Schulter-Aktivierung (Widerstandsband)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Schulter-Aktivierung (Widerstandsband, Wall Slides)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Rücken an der Wand, Arme gleiten.
Schulter-Aktivierung (Widerstandsband, Band Pull-Apart)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Band auseinanderziehen.
Schulter-Aktivierung (Widerstandsband, Schulterkreisen)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Große Kreise.
Schulter-Aktivierung (Widerstandsband, Y-T-W)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Bauchlage, Arme in Buchstaben.
Schulter-Aktivierung (Widerstandsband, Außenrotation liegend)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage, Hantel leicht.
Schulter-Aktivierung (Widerstandsband, Scapula Push-up)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Nur Schulterblätter bewegen.
Schulter-Aktivierung (Widerstandsband, Face Pull leicht)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Leichtes Band.
Schulter-Aktivierung (Widerstandsband, Bear Hold)|172|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Knie 2 cm über dem Boden.
Rehab & Prävention (Körpergewicht)|173|none|
Rehab & Prävention (Körpergewicht, Bird Dog)|173|none|Gegenarm-Gegenbein.
Rehab & Prävention (Körpergewicht, Clam Shell)|173|none|Seitlage, Knie öffnen.
Rehab & Prävention (Körpergewicht, Gesäßbrücke)|173|none|Hüfte heben.
Rehab & Prävention (Körpergewicht, Dead Bug)|173|none|Gegenseitig.
Rehab & Prävention (Körpergewicht, McGill Curl-up)|173|none|Kopf leicht heben.
Rehab & Prävention (Körpergewicht, Seitstütz)|173|none|Seitlich halten.
Rehab & Prävention (Körpergewicht, Monster Walk)|173|none|Mit Band seitlich.
Rehab & Prävention (Körpergewicht, Einbeinstand)|173|none|Balance.
Rehab & Prävention (Körpergewicht, Fersengang)|173|none|Zehen hoch.
Rehab & Prävention (Körpergewicht, Zehengang)|173|none|Auf Zehen.
Rehab & Prävention (Widerstandsband)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen.
Rehab & Prävention (Widerstandsband, Bird Dog)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gegenarm-Gegenbein.
Rehab & Prävention (Widerstandsband, Clam Shell)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlage, Knie öffnen.
Rehab & Prävention (Widerstandsband, Gesäßbrücke)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Hüfte heben.
Rehab & Prävention (Widerstandsband, Dead Bug)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Gegenseitig.
Rehab & Prävention (Widerstandsband, McGill Curl-up)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Kopf leicht heben.
Rehab & Prävention (Widerstandsband, Seitstütz)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Seitlich halten.
Rehab & Prävention (Widerstandsband, Monster Walk)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Mit Band seitlich.
Rehab & Prävention (Widerstandsband, Einbeinstand)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Balance.
Rehab & Prävention (Widerstandsband, Fersengang)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Zehen hoch.
Rehab & Prävention (Widerstandsband, Zehengang)|173|band|Band bleibt über die ganze Bewegung gespannt, Stärke nach Gefühl wählen. Auf Zehen.
"""#
}
