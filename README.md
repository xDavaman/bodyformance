# Simulator-Rundgang

Commit: d91edd4 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Kniebeuge öffnen (Kniebeuge, Kraft · Langhantel und Bank, Aktiv: Oberschenkel vorne, Gesäß. Passiv: Beinbeuger, Unterer Rücken, Bauch)
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (452.058 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  27 E  FitScan[15137:e5a2] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14fd08b40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
  27 E  FitScan[15137:e5a2] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 15137, elementOrHash.elementID: 5753815488.4031) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 15137, elementOrHash.elementID: 5753815040.4030) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 15137, elementOrHash.elementID: 5996400128.4034) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 15137, elementOrHash.elementID: 5996405504.4033) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 15137, elementOrHash.elementID: 5996408640.4032) faulted in {
   9 E  FitScan[15137:fe81] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14fd08b40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15137:fe81] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[15137:f6d3] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14fd08b40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15137:f6d3] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[15137:10ecd] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14fd08b40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
   9 E  FitScan[15137:10ecd] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
   6 Df FitScan[15137:bd22] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   6 Df FitScan[15137:bd22] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[15137:ccf1] [com.apple.storekit:Default] AAFService connection invalidated
   2 Df FitScan[15137:cbfb] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 F  FitScan[15137:bd22] [com.apple.renderbox:error] building pipeline path_exterior-jba6la7jbebia3 took 0.937667 seconds
   1 E  FitScan[15137:fe86] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15137:fe85] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15137:fe81] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15137:f6d3] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15137:ccd2] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[15137:bd22] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 E  FitScan[15137:bd22] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x1069e21c0; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 12.610803958000002 seconds:
   1 E  FitScan[15137:bd22] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x11475bc00; id = 483; phase = failed(touchesEnded)>
   1 E  FitScan[15137:bd22] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x155203e80; id = 482; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[15137:bd22] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x1151f4780 "com.apple.UIKit.longPressClickDriverPrimary"; id = 500; phase = failed>
   1 E  FitScan[15137:bd22] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x11bedb000; id = 524; phase = failed(touchesEnded)>
   1 E  FitScan[15137:11478] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[15137:11476] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[15137:10366] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 Df FitScan[15137:e032] [com.apple.calls.callkit:Default] Call host has no calls
   1 Df FitScan[15137:ccf1] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[15137:ccd2] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[15137:ccd2] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[15137:bd67] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[15137:bd65] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[15137:bd5c] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[15137:bd22] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[15137:bd22] [com.apple.xpc:connection] [0x11be56440] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[15137:bd22] [com.apple.xpc:connection] [0x11be43ac0] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[15137:bd22] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
   1 Df FitScan[15137:bd22] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
   1 Df FitScan[15137:bd22] [com.apple.runningboard:general] Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x106984d60>
   1 Df FitScan[15137:bd22] [com.apple.re:Graphics] MTLLibrary /Library/Developer/CoreSimulator/Volumes/iOS_23E254a/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.4.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreRE.framework/default.metall
   1 Df FitScan[15137:bd22] [com.apple.re:Foundation.Profiling] MTLCounter API disabled. Enable with 'defaults write -g com.apple.re.showMTLCounterAPIStatistics 1'
   1 Df FitScan[15137:bd22] [com.apple.re:Audio] [RE] [Sleep/Wake] User Defaults set enableAudioEngineRunnableAutomationSupport=0
   1 Df FitScan[15137:bd22] [com.apple.network:activity] Unsetting the global parent activity <nw_activity 50:1 [69004A5F-5932-4F20-BA4C-1BC6CEB93B38] (global parent) (reporting strategy default) complete (reason success)>
   1 Df FitScan[15137:bd22] [com.apple.network:activity] Set activity <nw_activity 50:1 [69004A5F-5932-4F20-BA4C-1BC6CEB93B38] (reporting strategy default)> as the global parent
   1 Df FitScan[15137:bd22] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:2 [5E40527C-9EC3-4BA3-9D2C-A6DA5DB037D1] (reporting strategy default)>
   1 Df FitScan[15137:bd22] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:1 [69004A5F-5932-4F20-BA4C-1BC6CEB93B38] (reporting strategy default)>
   1 Df FitScan[15137:bd22] [com.apple.network:activity] <nw_activity 50:2 [5E40527C-9EC3-4BA3-9D2C-A6DA5DB037D1] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 33333ms
   1 Df FitScan[15137:bd22] [com.apple.network:activity] <nw_activity 50:1 [69004A5F-5932-4F20-BA4C-1BC6CEB93B38] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 33319ms
   1 Df FitScan[15137:bd22] [com.apple.BoardServices:XPCErrors] [C:4] Alloc com.apple.inputservice.input-ui-host
   1 Df FitScan[15137:bd22] [com.apple.BoardServices:XPCErrors] [C:2] Alloc com.apple.backboard.hid-services.xpc
   1 Df FitScan[15137:11475] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[15137:11475] [com.apple.dt.automationmode:Default] Handling posted change notification (com.apple.dt.automationmode.state-changed)
   1 Df FitScan[15137:11475] [com.apple.dt.automationmode:Default] Comparing previous enabled state (1) to current enabled state (0)
```
## Dateien
```
out:
total 291320
drwxr-xr-x  10 runner  staff       320 Oct 18 15:18 .
drwxr-xr-x  19 runner  staff       608 Oct 18 15:07 ..
drwxr-xr-x   2 runner  staff        64 Oct 18 15:18 abstuerze
-rw-r--r--   1 runner  staff  81601247 Oct 18 15:18 app-protokoll.txt
-rw-r--r--   1 runner  staff        92 Oct 18 15:18 avconvert.txt
drwxr-xr-x  34 runner  staff      1088 Oct 18 15:17 bilder
-rw-r--r--   1 runner  staff     11424 Oct 18 15:18 ERGEBNIS.md
-rw-r--r--   1 runner  staff  64474616 Oct 18 15:18 rundgang.mp4
drwxr-xr-x   4 runner  staff       128 Oct 18 15:18 rundgang.xcresult
-rw-r--r--   1 runner  staff    141492 Oct 18 15:18 test.log

out/bilder:
total 63872
drwxr-xr-x  34 runner  staff     1088 Oct 18 15:17 .
drwxr-xr-x  10 runner  staff      320 Oct 18 15:18 ..
-rw-r--r--   1 runner  staff   283778 Oct 18 15:11 01 Willkommen.png
-rw-r--r--   1 runner  staff   393115 Oct 18 15:11 02 Profil.png
-rw-r--r--   1 runner  staff   451848 Oct 18 15:11 03 Profil unten.png
-rw-r--r--   1 runner  staff   328901 Oct 18 15:11 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Oct 18 15:11 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Oct 18 15:11 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   316191 Oct 18 15:11 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   431523 Oct 18 15:11 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  2601295 Oct 18 15:12 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  2607606 Oct 18 15:12 10 Fitnessstudio Blick 2.png
-rw-r--r--   1 runner  staff  2624949 Oct 18 15:12 11 Fitnessstudio Blick 3.png
-rw-r--r--   1 runner  staff  2383666 Oct 18 15:12 12 Fitnessstudio Blick 4.png
-rw-r--r--   1 runner  staff  2677526 Oct 18 15:13 13 Fitnessstudio Kabelturm.png
-rw-r--r--   1 runner  staff  2872179 Oct 18 15:13 14 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1557610 Oct 18 15:14 15 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1530775 Oct 18 15:14 16 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326625 Oct 18 15:14 17 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff  1662739 Oct 18 15:15 18 Kniebeuge 3D.png
-rw-r--r--   1 runner  staff  1686696 Oct 18 15:15 19 Kniebeuge 3D Bewegung.png
-rw-r--r--   1 runner  staff   343373 Oct 18 15:15 20 Kniebeuge im Fitnessstudio.png
-rw-r--r--   1 runner  staff   377680 Oct 18 15:16 21 Rezepte.png
-rw-r--r--   1 runner  staff   787353 Oct 18 15:16 22 Rezept.png
-rw-r--r--   1 runner  staff   192811 Oct 18 15:16 23 Kochmodus.png
-rw-r--r--   1 runner  staff   173777 Oct 18 15:16 24 Kochmodus Schritt 1.png
-rw-r--r--   1 runner  staff   133839 Oct 18 15:16 25 Kochmodus Schritt 2.png
-rw-r--r--   1 runner  staff   433303 Oct 18 15:17 26 Mobility.png
-rw-r--r--   1 runner  staff   346794 Oct 18 15:17 27 Einstellungen.png
-rw-r--r--   1 runner  staff  1875716 Oct 18 15:17 28 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1858885 Oct 18 15:17 29 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   462912 Oct 18 15:17 30 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    43566 Oct 18 15:13 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
-rw-r--r--@  1 runner  staff    44087 Oct 18 15:15 Aufbau vor zweitem Versuch Übung Kniebeuge öffnen.txt
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

**13 Fitnessstudio Kabelturm**

<img src="bilder/13%20Fitnessstudio%20Kabelturm.jpg" width="300">

**14 Fitnessstudio Stationen**

<img src="bilder/14%20Fitnessstudio%20Stationen.jpg" width="300">

**15 Bankdrücken 3D**

<img src="bilder/15%20Bankdrücken%203D.jpg" width="300">

**16 Bankdrücken 3D Bewegung**

<img src="bilder/16%20Bankdrücken%203D%20Bewegung.jpg" width="300">

**17 Bankdrücken im Fitnessstudio**

<img src="bilder/17%20Bankdrücken%20im%20Fitnessstudio.jpg" width="300">

**18 Kniebeuge 3D**

<img src="bilder/18%20Kniebeuge%203D.jpg" width="300">

**19 Kniebeuge 3D Bewegung**

<img src="bilder/19%20Kniebeuge%203D%20Bewegung.jpg" width="300">

**20 Kniebeuge im Fitnessstudio**

<img src="bilder/20%20Kniebeuge%20im%20Fitnessstudio.jpg" width="300">

**21 Rezepte**

<img src="bilder/21%20Rezepte.jpg" width="300">

**22 Rezept**

<img src="bilder/22%20Rezept.jpg" width="300">

**23 Kochmodus**

<img src="bilder/23%20Kochmodus.jpg" width="300">

**24 Kochmodus Schritt 1**

<img src="bilder/24%20Kochmodus%20Schritt%201.jpg" width="300">

**25 Kochmodus Schritt 2**

<img src="bilder/25%20Kochmodus%20Schritt%202.jpg" width="300">

**26 Mobility**

<img src="bilder/26%20Mobility.jpg" width="300">

**27 Einstellungen**

<img src="bilder/27%20Einstellungen.jpg" width="300">

**28 Eigene Figur vorne**

<img src="bilder/28%20Eigene%20Figur%20vorne.jpg" width="300">

**29 Eigene Figur hinten**

<img src="bilder/29%20Eigene%20Figur%20hinten.jpg" width="300">

**30 Eigene Figur Regler**

<img src="bilder/30%20Eigene%20Figur%20Regler.jpg" width="300">

[Video vom Rundgang](rundgang.mp4)
