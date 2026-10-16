# Simulator-Rundgang

Commit: 93e0e98 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: öffnet nicht beim ersten Tippen: erstes Rezept öffnen (🥛, 🫐, 🥣, Protein-Overnight-Oats, 458 kcal · 40 g Eiweiß · 0.3 g Salz · 1.33 €, Frühstück · 5 Min. · Meal Prep · vegetarisch, High Protein)
RUNDGANG: öffnet nicht: erstes Rezept öffnen
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (349.853 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  18 E  FitScan[14444:e077] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11ee55e00>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
  18 E  FitScan[14444:e077] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 14444, elementOrHash.elementID: 4462872768.2886) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 14444, elementOrHash.elementID: 6284097088.2885) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 14444, elementOrHash.elementID: 6285743808.2889) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 14444, elementOrHash.elementID: 6285740224.2888) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 14444, elementOrHash.elementID: 6283450496.2887) faulted in {
   9 E  FitScan[14444:e06e] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11ee55e00>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[14444:e06e] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   4 Df FitScan[14444:bdaf] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   4 Df FitScan[14444:bdaf] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[14444:bdcb] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 F  FitScan[14444:bdaf] [com.apple.renderbox:error] building pipeline path_exterior-jba6la7jbebia3 took 1.176795 seconds
   1 E  FitScan[14444:ebce] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:e725] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:e724] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:e723] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:e143] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:d961] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[14444:bdcd] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[14444:bdaf] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 E  FitScan[14444:bdaf] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x1065c1f40; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 15.617923 seconds:
   1 E  FitScan[14444:bdaf] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x11b83d900; id = 421; phase = failed(touchesEnded)>
   1 E  FitScan[14444:bdaf] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x11473f5c0; id = 420; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[14444:bdaf] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x11b9fb000 "com.apple.UIKit.longPressClickDriverPrimary"; id = 438; phase = failed>
   1 E  FitScan[14444:bdaf] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x11b89fa00; id = 462; phase = failed(touchesEnded)>
   1 Df FitScan[14444:bdce] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[14444:bdcd] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[14444:bdcb] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[14444:bdcb] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[14444:bdcb] [com.apple.calls.callkit:Default] Call host has no calls
   1 Df FitScan[14444:bdcb] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[14444:bdc9] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[14444:bdc9] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[14444:bdc9] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[14444:bdaf] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[14444:bdaf] [com.apple.xpc:connection] [0x11bab9a40] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[14444:bdaf] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
   1 Df FitScan[14444:bdaf] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
   1 Df FitScan[14444:bdaf] [com.apple.runningboard:general] Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x106574cc0>
   1 Df FitScan[14444:bdaf] [com.apple.re:Graphics] MTLLibrary /Library/Developer/CoreSimulator/Volumes/iOS_23E254a/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.4.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreRE.framework/default.metall
   1 Df FitScan[14444:bdaf] [com.apple.re:Foundation.Profiling] MTLCounter API disabled. Enable with 'defaults write -g com.apple.re.showMTLCounterAPIStatistics 1'
   1 Df FitScan[14444:bdaf] [com.apple.re:Audio] [RE] [Sleep/Wake] User Defaults set enableAudioEngineRunnableAutomationSupport=0
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] Unsetting the global parent activity <nw_activity 50:1 [2A7AD853-8028-4827-920C-4E8BB17738D4] (global parent) (reporting strategy default) complete (reason success)>
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] Set activity <nw_activity 50:1 [2A7AD853-8028-4827-920C-4E8BB17738D4] (reporting strategy default)> as the global parent
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:2 [11C835ED-C86F-45BF-AC96-B116078D9BE0] (reporting strategy default)>
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:1 [2A7AD853-8028-4827-920C-4E8BB17738D4] (reporting strategy default)>
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] <nw_activity 50:2 [11C835ED-C86F-45BF-AC96-B116078D9BE0] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 5069ms
   1 Df FitScan[14444:bdaf] [com.apple.network:activity] <nw_activity 50:1 [2A7AD853-8028-4827-920C-4E8BB17738D4] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 5069ms
   1 Df FitScan[14444:bdaf] [com.apple.BoardServices:XPCErrors] [C:4] Alloc com.apple.inputservice.input-ui-host
   1 Df FitScan[14444:bdaf] [com.apple.BoardServices:XPCErrors] [C:2] Alloc com.apple.backboard.hid-services.xpc
   1 Df FitScan[14444:101b9] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[14444:101b9] [com.apple.dt.automationmode:Default] Handling posted change notification (com.apple.dt.automationmode.state-changed)
   1 Df FitScan[14444:101b9] [com.apple.dt.automationmode:Default] Comparing previous enabled state (1) to current enabled state (0)
   1 :
```
## Dateien
```
out:
total 166400
drwxr-xr-x  10 runner  staff       320 Oct 16 06:39 .
drwxr-xr-x  19 runner  staff       608 Oct 16 06:30 ..
drwxr-xr-x   2 runner  staff        64 Oct 16 06:39 abstuerze
-rw-r--r--   1 runner  staff  61149481 Oct 16 06:39 app-protokoll.txt
-rw-r--r--   1 runner  staff        92 Oct 16 06:39 avconvert.txt
drwxr-xr-x  24 runner  staff       768 Oct 16 06:39 bilder
-rw-r--r--   1 runner  staff     10025 Oct 16 06:39 ERGEBNIS.md
-rw-r--r--   1 runner  staff  22397552 Oct 16 06:39 rundgang.mp4
drwxr-xr-x   4 runner  staff       128 Oct 16 06:39 rundgang.xcresult
-rw-r--r--   1 runner  staff    123951 Oct 16 06:39 test.log

out/bilder:
total 25768
drwxr-xr-x  24 runner  staff      768 Oct 16 06:39 .
drwxr-xr-x  10 runner  staff      320 Oct 16 06:39 ..
-rw-r--r--   1 runner  staff   283778 Oct 16 06:33 01 Willkommen.png
-rw-r--r--   1 runner  staff   391263 Oct 16 06:33 02 Profil.png
-rw-r--r--   1 runner  staff   447510 Oct 16 06:33 03 Profil unten.png
-rw-r--r--   1 runner  staff   328901 Oct 16 06:33 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Oct 16 06:34 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Oct 16 06:34 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   316191 Oct 16 06:34 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   429604 Oct 16 06:34 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  1494524 Oct 16 06:35 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  1542577 Oct 16 06:35 10 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1102300 Oct 16 06:36 11 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1128846 Oct 16 06:36 12 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326663 Oct 16 06:36 13 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff   377680 Oct 16 06:37 14 Rezepte.png
-rw-r--r--   1 runner  staff   433303 Oct 16 06:38 15 Mobility.png
-rw-r--r--   1 runner  staff   346794 Oct 16 06:38 16 Einstellungen.png
-rw-r--r--   1 runner  staff  1368195 Oct 16 06:38 17 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1328615 Oct 16 06:39 18 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   464334 Oct 16 06:39 19 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    81011 Oct 16 06:38 Aufbau nach zweitem Versuch erstes Rezept öffnen.txt
-rw-r--r--@  1 runner  staff    81011 Oct 16 06:38 Aufbau vor zweitem Versuch erstes Rezept öffnen.txt
-rw-r--r--@  1 runner  staff    43274 Oct 16 06:36 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
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

**10 Fitnessstudio Stationen**

<img src="bilder/10%20Fitnessstudio%20Stationen.jpg" width="300">

**11 Bankdrücken 3D**

<img src="bilder/11%20Bankdrücken%203D.jpg" width="300">

**12 Bankdrücken 3D Bewegung**

<img src="bilder/12%20Bankdrücken%203D%20Bewegung.jpg" width="300">

**13 Bankdrücken im Fitnessstudio**

<img src="bilder/13%20Bankdrücken%20im%20Fitnessstudio.jpg" width="300">

**14 Rezepte**

<img src="bilder/14%20Rezepte.jpg" width="300">

**15 Mobility**

<img src="bilder/15%20Mobility.jpg" width="300">

**16 Einstellungen**

<img src="bilder/16%20Einstellungen.jpg" width="300">

**17 Eigene Figur vorne**

<img src="bilder/17%20Eigene%20Figur%20vorne.jpg" width="300">

**18 Eigene Figur hinten**

<img src="bilder/18%20Eigene%20Figur%20hinten.jpg" width="300">

**19 Eigene Figur Regler**

<img src="bilder/19%20Eigene%20Figur%20Regler.jpg" width="300">

[Video vom Rundgang](rundgang.mp4)
