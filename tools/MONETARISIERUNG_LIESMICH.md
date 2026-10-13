# BFC: Premium, Werbung, Statistik – später einschalten

Alles liegt in FitScan/Services.swift. Standard: alles frei, keine Werbung, Statistik aus.

## Premium
1. App Store Connect: Abo-Gruppe "BFC Premium", Produkte bfc.premium.monthly, bfc.premium.yearly, bfc.premium.lifetime (IDs stehen in PremiumConfig.productIDs).
2. Test in Xcode: StoreKit-Konfigurationsdatei anlegen (File > New > StoreKit Configuration) und im Schema auswählen.
3. Sperren: PremiumConfig.enforceGating = true. Funktionen mit .premiumGate(.secondScan) usw. umhüllen (zweiter Scan, Makros, 3D-Entwicklung, Analysen).
4. App Store verlangt: Abo-Bedingungen und Datenschutz-URL in den Metadaten, "Käufe wiederherstellen" (vorhanden).

## Statistik
Stufe 1: Apple App Analytics, nichts zu tun. Stufe 2: Firebase Frankfurt (europe-west3), Anleitung als Kommentar in Services.swift.
Danach Datenschutzerklärung Abschnitt 15, PrivacyInfo.xcprivacy und App-Store-Datenschutzangaben anpassen.

## Werbung
AdConfig.enabled = true, Ad-SDK (z. B. AdMob) einbinden, AdProvider ersetzen, Einwilligung (Google UMP) + ATT-Abfrage, NSUserTrackingUsageDescription in BFC-Info.plist, Datenschutz Abschnitt 16 mit Partner ergänzen.
AdBannerSlot() nur auf Seiten ohne Gesundheitsbezug einsetzen. Mit Premium keine Werbung.

## Recht
Texte in tools/gen_legal.py ändern, dann: python3 tools/gen_legal.py FitScan  (erzeugt LegalTexts.swift; die .md liegt danach in FitScan/ und wird nach tools/ verschoben).
