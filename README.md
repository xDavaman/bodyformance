# Simulator-Rundgang

Commit: 8a7c955 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Kniebeuge öffnen (Kniebeuge, Kraft · Langhantel und Bank, Aktiv: Oberschenkel vorne, Gesäß. Passiv: Beinbeuger, Unterer Rücken, Bauch)
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (471.360 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  18 E  FitScan[15147:bce6] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14f32dec0>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
  18 E  FitScan[15147:bce6] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 15147, elementOrHash.elementID: 5932892160.4312) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 15147, elementOrHash.elementID: 5892816896.4311) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 15147, elementOrHash.elementID: 5932022656.4315) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 15147, elementOrHash.elementID: 5932907392.4314) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 15147, elementOrHash.elementID: 5932898432.4313) faulted in {
   9 E  FitScan[15147:f770] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14f32dec0>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15147:f770] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[15147:f762] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14f32dec0>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15147:f762] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[15147:f03f] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14f32dec0>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15147:f03f] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[15147:cbce] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14f32dec0>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[15147:cbce] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   6 Df FitScan[15147:bcad] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   6 Df FitScan[15147:bcad] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[15147:bcf1] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 F  FitScan[15147:bcad] [com.apple.renderbox:error] building pipeline path_exterior-jba6la7jbebia3 took 0.977159 seconds
   1 E  FitScan[15147:f770] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15147:f762] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15147:f03f] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15147:cbce] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[15147:bcf0] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[15147:bcad] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 E  FitScan[15147:bcad] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x104dc21c0; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 11.071481208 seconds:
   1 E  FitScan[15147:bcad] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x112babc00; id = 499; phase = failed(touchesEnded)>
   1 E  FitScan[15147:bcad] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x11a157340; id = 498; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[15147:bcad] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x118c23a80 "com.apple.UIKit.longPressClickDriverPrimary"; id = 516; phase = failed>
   1 E  FitScan[15147:bcad] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x119de4000; id = 540; phase = failed(touchesEnded)>
   1 E  FitScan[15147:10eb2] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[15147:10b8a] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 Df FitScan[15147:cbce] [com.apple.calls.callkit:Default] Call host has no calls
   1 Df FitScan[15147:bcf2] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[15147:bcf1] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[15147:bcf1] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[15147:bcf1] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[15147:bcf0] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[15147:bce6] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[15147:bce5] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[15147:bce3] [com.apple.BoardServices:XPCErrors] [C:4] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[15147:bcad] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[15147:bcad] [com.apple.xpc:connection] [0x11a04e940] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[15147:bcad] [com.apple.xpc:connection] [0x11a04c640] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[15147:bcad] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
   1 Df FitScan[15147:bcad] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
   1 Df FitScan[15147:bcad] [com.apple.runningboard:general] Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x104d68ce0>
   1 Df FitScan[15147:bcad] [com.apple.re:Graphics] MTLLibrary /Library/Developer/CoreSimulator/Volumes/iOS_23E254a/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.4.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreRE.framework/default.metall
   1 Df FitScan[15147:bcad] [com.apple.re:Foundation.Profiling] MTLCounter API disabled. Enable with 'defaults write -g com.apple.re.showMTLCounterAPIStatistics 1'
   1 Df FitScan[15147:bcad] [com.apple.re:Audio] [RE] [Sleep/Wake] User Defaults set enableAudioEngineRunnableAutomationSupport=0
   1 Df FitScan[15147:bcad] [com.apple.network:activity] Unsetting the global parent activity <nw_activity 50:1 [457A00B0-FD50-4F2B-B0CC-ECAB038246C4] (global parent) (reporting strategy default) complete (reason success)>
   1 Df FitScan[15147:bcad] [com.apple.network:activity] Set activity <nw_activity 50:1 [457A00B0-FD50-4F2B-B0CC-ECAB038246C4] (reporting strategy default)> as the global parent
   1 Df FitScan[15147:bcad] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:2 [F3AF0DEB-7B42-4BBB-BD7A-B41CD82F8CF6] (reporting strategy default)>
   1 Df FitScan[15147:bcad] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:1 [457A00B0-FD50-4F2B-B0CC-ECAB038246C4] (reporting strategy default)>
   1 Df FitScan[15147:bcad] [com.apple.network:activity] <nw_activity 50:2 [F3AF0DEB-7B42-4BBB-BD7A-B41CD82F8CF6] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 11588ms
   1 Df FitScan[15147:bcad] [com.apple.network:activity] <nw_activity 50:1 [457A00B0-FD50-4F2B-B0CC-ECAB038246C4] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 11588ms
   1 Df FitScan[15147:bcad] [com.apple.BoardServices:XPCErrors] [C:5] Alloc com.apple.inputservice.input-ui-host
   1 Df FitScan[15147:bcad] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.sessionservices
   1 Df FitScan[15147:bcad] [com.apple.BoardServices:XPCErrors] [C:2] Alloc com.apple.backboard.hid-services.xpc
   1 Df FitScan[15147:10e4e] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
```
## Dateien
```
out:
total 350704
drwxr-xr-x  10 runner  staff        320 Nov  1 16:12 .
drwxr-xr-x  23 runner  staff        736 Nov  1 16:01 ..
drwxr-xr-x   2 runner  staff         64 Nov  1 16:12 abstuerze
-rw-r--r--   1 runner  staff  107967648 Nov  1 16:11 app-protokoll.txt
-rw-r--r--   1 runner  staff         92 Nov  1 16:12 avconvert.txt
drwxr-xr-x  34 runner  staff       1088 Nov  1 16:11 bilder
-rw-r--r--   1 runner  staff      11625 Nov  1 16:12 ERGEBNIS.md
-rw-r--r--   1 runner  staff   61205548 Nov  1 16:12 rundgang.mp4
drwxr-xr-x   4 runner  staff        128 Nov  1 16:11 rundgang.xcresult
-rw-r--r--   1 runner  staff     142666 Nov  1 16:11 test.log

out/bilder:
total 68448
drwxr-xr-x  34 runner  staff     1088 Nov  1 16:11 .
drwxr-xr-x  10 runner  staff      320 Nov  1 16:12 ..
-rw-r--r--   1 runner  staff   291818 Nov  1 16:04 01 Willkommen.png
-rw-r--r--   1 runner  staff   390935 Nov  1 16:04 02 Profil.png
-rw-r--r--   1 runner  staff   449019 Nov  1 16:04 03 Profil unten.png
-rw-r--r--   1 runner  staff   325639 Nov  1 16:04 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Nov  1 16:04 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Nov  1 16:05 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   316191 Nov  1 16:05 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   421061 Nov  1 16:05 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  2756505 Nov  1 16:05 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  2695910 Nov  1 16:05 10 Fitnessstudio Blick 2.png
-rw-r--r--   1 runner  staff  3032338 Nov  1 16:05 11 Fitnessstudio Blick 3.png
-rw-r--r--   1 runner  staff  2965138 Nov  1 16:06 12 Fitnessstudio Blick 4.png
-rw-r--r--   1 runner  staff  2509044 Nov  1 16:06 13 Fitnessstudio Kabelturm.png
-rw-r--r--   1 runner  staff  2124763 Nov  1 16:06 14 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1622365 Nov  1 16:07 15 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1597630 Nov  1 16:07 16 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326625 Nov  1 16:07 17 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff  1699759 Nov  1 16:08 18 Kniebeuge 3D.png
-rw-r--r--   1 runner  staff  1706108 Nov  1 16:08 19 Kniebeuge 3D Bewegung.png
-rw-r--r--   1 runner  staff  2170988 Nov  1 16:09 20 Kniebeuge im Fitnessstudio.png
-rw-r--r--   1 runner  staff   418343 Nov  1 16:09 21 Rezepte.png
-rw-r--r--   1 runner  staff   787353 Nov  1 16:10 22 Rezept.png
-rw-r--r--   1 runner  staff   192811 Nov  1 16:10 23 Kochmodus.png
-rw-r--r--   1 runner  staff   173777 Nov  1 16:10 24 Kochmodus Schritt 1.png
-rw-r--r--   1 runner  staff   133839 Nov  1 16:10 25 Kochmodus Schritt 2.png
-rw-r--r--   1 runner  staff   433303 Nov  1 16:10 26 Mobility.png
-rw-r--r--   1 runner  staff   346794 Nov  1 16:10 27 Einstellungen.png
-rw-r--r--   1 runner  staff  1904659 Nov  1 16:11 28 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1807465 Nov  1 16:11 29 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   457956 Nov  1 16:11 30 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    43667 Nov  1 16:07 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
-rw-r--r--@  1 runner  staff    44188 Nov  1 16:08 Aufbau vor zweitem Versuch Übung Kniebeuge öffnen.txt
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
