# Simulator-Rundgang

Commit: f5a84d2 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: Übungsbibliothek nicht erreicht (für Kniebeuge)
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (296.447 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 9327, elementOrHash.elementID: 6051509376.3566) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 9327, elementOrHash.elementID: 5973611776.3565) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 9327, elementOrHash.elementID: 6051504448.3569) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 9327, elementOrHash.elementID: 6051497728.3568) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 9327, elementOrHash.elementID: 6051507584.3567) faulted in {
   9 E  FitScan[9327:adc4] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11c30d080>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={NS
   9 E  FitScan[9327:adc4] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file."
   9 E  FitScan[9327:aae4] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11c30d080>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={NS
   9 E  FitScan[9327:aae4] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file."
   9 E  FitScan[9327:7bd2] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11c30d080>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={NS
   9 E  FitScan[9327:7bd2] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file."
   4 Df FitScan[9327:7b93] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   4 Df FitScan[9327:7b93] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[9327:7bd4] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 E  FitScan[9327:b6c4] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main 
   1 E  FitScan[9327:b6c1] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main 
   1 E  FitScan[9327:9d28] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main 
   1 E  FitScan[9327:7bd7] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[9327:7b93] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 Df FitScan[9327:f136] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[9327:f136] [com.apple.dt.automationmode:Default] Handling posted change notification (com.apple.dt.automationmode.state-changed)
   1 Df FitScan[9327:f136] [com.apple.dt.automationmode:Default] Comparing previous enabled state (1) to current enabled state (0)
   1 Df FitScan[9327:9d28] [com.apple.calls.callkit:Default] Call host has no calls
   1 Df FitScan[9327:7bdb] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[9327:7bdb] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[9327:7bdb] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[9327:7bd7] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[9327:7bd5] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[9327:7bd5] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[9327:7bd3] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[9327:7bcc] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[9327:7b93] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[9327:7b93] [com.apple.xpc:connection] [0x11ade4c80] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[9327:7b93] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
   1 Df FitScan[9327:7b93] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
   1 Df FitScan[9327:7b93] [com.apple.runningboard:general] Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x10516d4e0>
   1 Df FitScan[9327:7b93] [com.apple.re:Graphics] MTLLibrary /Library/Developer/CoreSimulator/Volumes/iOS_23E254a/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.4.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreRE.framework/default.metalli
   1 Df FitScan[9327:7b93] [com.apple.re:Foundation.Profiling] MTLCounter API disabled. Enable with 'defaults write -g com.apple.re.showMTLCounterAPIStatistics 1'
   1 Df FitScan[9327:7b93] [com.apple.re:Audio] [RE] [Sleep/Wake] User Defaults set enableAudioEngineRunnableAutomationSupport=0
   1 Df FitScan[9327:7b93] [com.apple.network:activity] Unsetting the global parent activity <nw_activity 50:1 [E431285B-6045-48A9-BB60-622F01DAFCA5] (global parent) (reporting strategy default) complete (reason success)>
   1 Df FitScan[9327:7b93] [com.apple.network:activity] Set activity <nw_activity 50:1 [E431285B-6045-48A9-BB60-622F01DAFCA5] (reporting strategy default)> as the global parent
   1 Df FitScan[9327:7b93] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:2 [E1309627-74CE-41CE-A2D0-6CE937F90633] (reporting strategy default)>
   1 Df FitScan[9327:7b93] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:1 [E431285B-6045-48A9-BB60-622F01DAFCA5] (reporting strategy default)>
   1 Df FitScan[9327:7b93] [com.apple.network:activity] <nw_activity 50:2 [E1309627-74CE-41CE-A2D0-6CE937F90633] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 3452ms
   1 Df FitScan[9327:7b93] [com.apple.network:activity] <nw_activity 50:1 [E431285B-6045-48A9-BB60-622F01DAFCA5] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 3440ms
   1 Df FitScan[9327:7b93] [com.apple.BoardServices:XPCErrors] [C:4] Alloc com.apple.inputservice.input-ui-host
   1 Df FitScan[9327:7b93] [com.apple.BoardServices:XPCErrors] [C:2] Alloc com.apple.backboard.hid-services.xpc
```
## Dateien
```
out:
total 360808
drwxr-xr-x  10 runner  staff       320 Oct 18 07:15 .
drwxr-xr-x  19 runner  staff       608 Oct 18 07:08 ..
drwxr-xr-x   2 runner  staff        64 Oct 18 07:15 abstuerze
-rw-r--r--   1 runner  staff  71216422 Oct 18 07:14 app-protokoll.txt
-rw-r--r--   1 runner  staff        92 Oct 18 07:15 avconvert.txt
drwxr-xr-x  30 runner  staff       960 Oct 18 07:14 bilder
-rw-r--r--   1 runner  staff      8505 Oct 18 07:15 ERGEBNIS.md
-rw-r--r--   1 runner  staff  94791853 Oct 18 07:15 rundgang.mp4
drwxr-xr-x   4 runner  staff       128 Oct 18 07:14 rundgang.xcresult
-rw-r--r--   1 runner  staff    130459 Oct 18 07:14 test.log

out/bilder:
total 51696
drwxr-xr-x  30 runner  staff      960 Oct 18 07:14 .
drwxr-xr-x  10 runner  staff      320 Oct 18 07:15 ..
-rw-r--r--   1 runner  staff   283778 Oct 18 07:09 01 Willkommen.png
-rw-r--r--   1 runner  staff   393115 Oct 18 07:10 02 Profil.png
-rw-r--r--   1 runner  staff   433178 Oct 18 07:10 03 Profil unten.png
-rw-r--r--   1 runner  staff   328901 Oct 18 07:10 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Oct 18 07:10 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Oct 18 07:10 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   310937 Oct 18 07:10 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   422468 Oct 18 07:10 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  2598363 Oct 18 07:11 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  2609827 Oct 18 07:11 10 Fitnessstudio Blick 2.png
-rw-r--r--   1 runner  staff  2624212 Oct 18 07:11 11 Fitnessstudio Blick 3.png
-rw-r--r--   1 runner  staff  2381364 Oct 18 07:11 12 Fitnessstudio Blick 4.png
-rw-r--r--   1 runner  staff  2716189 Oct 18 07:11 13 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1517820 Oct 18 07:12 14 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1468459 Oct 18 07:12 15 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326625 Oct 18 07:12 16 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff   514736 Oct 18 07:13 17 Übungsbibliothek fehlt.png
-rw-r--r--   1 runner  staff   377680 Oct 18 07:13 18 Rezepte.png
-rw-r--r--   1 runner  staff   787353 Oct 18 07:13 19 Rezept.png
-rw-r--r--   1 runner  staff   192811 Oct 18 07:13 20 Kochmodus.png
-rw-r--r--   1 runner  staff   173777 Oct 18 07:13 21 Kochmodus Schritt 1.png
-rw-r--r--   1 runner  staff   133839 Oct 18 07:13 22 Kochmodus Schritt 2.png
-rw-r--r--   1 runner  staff   433303 Oct 18 07:14 23 Mobility.png
-rw-r--r--   1 runner  staff   346794 Oct 18 07:14 24 Einstellungen.png
-rw-r--r--   1 runner  staff  1876599 Oct 18 07:14 25 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1826692 Oct 18 07:14 26 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   457028 Oct 18 07:14 27 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    42512 Oct 18 07:12 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
IOServiceMatchingfailed for: AppleM2ScalerParavirtDriver
avconvert completed with error:0.

```
## Bildschirmfotos

**01 Willkommen**

<img src="bilder/01%20Willkommen.jpg" width="300">

**02 Profil**

<img src="bilder/02%20Profil.jpg" width="300">

**03 Profil unten**

<img src="bilder/03%20Profil%20unten.jpg" width="300">

**04 Trainingsplan**

<img src="bilder/04%20Trainingsplan.jpg" width="300">

**05 KI-Coach**

<img src="bilder/05%20KI-Coach.jpg" width="300">

**06 KI-Coach Ziel wählen**

<img src="bilder/06%20KI-Coach%20Ziel%20wählen.jpg" width="300">

**07 KI-Coach Plan**

<img src="bilder/07%20KI-Coach%20Plan.jpg" width="300">

**08 KI-Coach Plan unten**

<img src="bilder/08%20KI-Coach%20Plan%20unten.jpg" width="300">

**09 Fitnessstudio**

<img src="bilder/09%20Fitnessstudio.jpg" width="300">

**10 Fitnessstudio Blick 2**

<img src="bilder/10%20Fitnessstudio%20Blick%202.jpg" width="300">

**11 Fitnessstudio Blick 3**

<img src="bilder/11%20Fitnessstudio%20Blick%203.jpg" width="300">

**12 Fitnessstudio Blick 4**

<img src="bilder/12%20Fitnessstudio%20Blick%204.jpg" width="300">

**13 Fitnessstudio Stationen**

<img src="bilder/13%20Fitnessstudio%20Stationen.jpg" width="300">

**14 Bankdrücken 3D**

<img src="bilder/14%20Bankdrücken%203D.jpg" width="300">

**15 Bankdrücken 3D Bewegung**

<img src="bilder/15%20Bankdrücken%203D%20Bewegung.jpg" width="300">

**16 Bankdrücken im Fitnessstudio**

<img src="bilder/16%20Bankdrücken%20im%20Fitnessstudio.jpg" width="300">

**17 Übungsbibliothek fehlt**

<img src="bilder/17%20Übungsbibliothek%20fehlt.jpg" width="300">

**18 Rezepte**

<img src="bilder/18%20Rezepte.jpg" width="300">

**19 Rezept**

<img src="bilder/19%20Rezept.jpg" width="300">

**20 Kochmodus**

<img src="bilder/20%20Kochmodus.jpg" width="300">

**21 Kochmodus Schritt 1**

<img src="bilder/21%20Kochmodus%20Schritt%201.jpg" width="300">

**22 Kochmodus Schritt 2**

<img src="bilder/22%20Kochmodus%20Schritt%202.jpg" width="300">

**23 Mobility**

<img src="bilder/23%20Mobility.jpg" width="300">

**24 Einstellungen**

<img src="bilder/24%20Einstellungen.jpg" width="300">

**25 Eigene Figur vorne**

<img src="bilder/25%20Eigene%20Figur%20vorne.jpg" width="300">

**26 Eigene Figur hinten**

<img src="bilder/26%20Eigene%20Figur%20hinten.jpg" width="300">

**27 Eigene Figur Regler**

<img src="bilder/27%20Eigene%20Figur%20Regler.jpg" width="300">

[Video vom Rundgang](rundgang.mp4)
