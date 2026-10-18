# Simulator-Rundgang

Commit: 3dad504 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Kniebeuge öffnen (Kniebeuge, Kraft · Langhantel und Bank, Aktiv: Oberschenkel vorne, Gesäß. Passiv: Beinbeuger, Unterer Rücken, Bauch)
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (469.543 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  18 E  FitScan[18272:1124c] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14df02580>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
  18 E  FitScan[18272:1124c] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 18272, elementOrHash.elementID: 5783340800.4080) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 18272, elementOrHash.elementID: 5782796288.4079) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 18272, elementOrHash.elementID: 5630112448.4083) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 18272, elementOrHash.elementID: 5630107072.4082) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 18272, elementOrHash.elementID: 5783354688.4081) faulted in {
   9 E  FitScan[18272:1248c] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14df02580>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
   9 E  FitScan[18272:1248c] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
   9 E  FitScan[18272:11995] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14df02580>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
   9 E  FitScan[18272:11995] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
   9 E  FitScan[18272:1075c] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14df02580>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
   9 E  FitScan[18272:1075c] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
   9 E  FitScan[18272:1075a] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x14df02580>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={
   9 E  FitScan[18272:1075a] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file
   6 Df FitScan[18272:dabb] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   6 Df FitScan[18272:dabb] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[18272:daef] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 F  FitScan[18272:dabb] [com.apple.renderbox:error] building pipeline path_exterior-jba6la7jbebia3 took 1.111715 seconds
   1 E  FitScan[18272:dae8] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[18272:dabb] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x1049a2080; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 39.006437917 seconds:
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x1049a2080; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 28.978448625000002 seconds:
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors] [!] <_UISystemGestureGateGestureRecognizer: 0x1049a2080; id = 2; phase = possible | failed(timeout)> is blocking its subgraph for 10.122744249999998 seconds:
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x119938780; id = 250; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x112717c00; id = 489; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x112717980; id = 181; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewPanGestureRecognizer: 0x112716300; id = 127; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x1551f3c00; id = 488; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x118fd7e80; id = 249; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x118549040; id = 126; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIScrollViewDelayedTouchesBeganGestureRecognizer: 0x1132fb840; id = 180; phase = failed(delayedTouchesDenied)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIKitResponderGestureRecognizer: 0x118cfa280; id = 267; phase = failed>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <UIKitResponderGestureRecognizer: 0x118cf9c80; id = 266; phase = ended>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x119a7ab80 "com.apple.UIKit.longPressClickDriverPrimary"; id = 506; phase = failed>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x1126bb000 "com.apple.UIKit.longPressClickDriverPrimary"; id = 144; phase = failed>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UITouchDurationObservingGestureRecognizer: 0x1126b9c80 "com.apple.UIKit.longPressClickDriverPrimary"; id = 198; phase = failed>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x1552d0000; id = 530; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x11877b400; id = 211; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UISwipeActionPanGestureRecognizer: 0x118779a00; id = 157; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UIParallaxTransitionPanGestureRecognizer: 0x112715e00 "UINavigationController.contentSwipe"; id = 125; phase = failed(touchesEnded)>
   1 E  FitScan[18272:dabb] [com.apple.Gestures:Errors]     <_UIParallaxTransitionPanGestureRecognizer: 0x112715b80 "UINavigationController.edgeSwipe"; id = 124; phase = failed>
   1 E  FitScan[18272:12baa] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:12a4b] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:1248c] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:11997] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:11996] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:11995] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:1198e] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 E  FitScan[18272:1075a] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a mai
   1 Df FitScan[18272:daf2] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[18272:daf1] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[18272:daef] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[18272:daef] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[18272:dae8] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[18272:dae8] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[18272:dae3] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[18272:dae3] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[18272:dabb] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[18272:dabb] [com.apple.xpc:connection] [0x15bc08280] failed to do a bootstrap look-up: xpc_error=[3: No such process]
```
## Dateien
```
out:
total 279016
drwxr-xr-x  10 runner  staff       320 Oct 18 08:41 .
drwxr-xr-x  19 runner  staff       608 Oct 18 08:31 ..
drwxr-xr-x   2 runner  staff        64 Oct 18 08:41 abstuerze
-rw-r--r--   1 runner  staff  82146494 Oct 18 08:41 app-protokoll.txt
-rw-r--r--   1 runner  staff        92 Oct 18 08:41 avconvert.txt
drwxr-xr-x  34 runner  staff      1088 Oct 18 08:40 bilder
-rw-r--r--   1 runner  staff     11982 Oct 18 08:41 ERGEBNIS.md
-rw-r--r--@  1 runner  staff  58348442 Oct 18 08:41 rundgang.mp4
drwxr-xr-x   4 runner  staff       128 Oct 18 08:40 rundgang.xcresult
-rw-r--r--   1 runner  staff    141853 Oct 18 08:40 test.log

out/bilder:
total 64208
drwxr-xr-x  34 runner  staff     1088 Oct 18 08:40 .
drwxr-xr-x  10 runner  staff      320 Oct 18 08:41 ..
-rw-r--r--   1 runner  staff   283778 Oct 18 08:33 01 Willkommen.png
-rw-r--r--   1 runner  staff   393115 Oct 18 08:33 02 Profil.png
-rw-r--r--   1 runner  staff   445501 Oct 18 08:33 03 Profil unten.png
-rw-r--r--   1 runner  staff   328901 Oct 18 08:33 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Oct 18 08:33 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Oct 18 08:34 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   316191 Oct 18 08:34 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   416135 Oct 18 08:34 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  2591754 Oct 18 08:35 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  2690832 Oct 18 08:35 10 Fitnessstudio Blick 2.png
-rw-r--r--   1 runner  staff  2760397 Oct 18 08:35 11 Fitnessstudio Blick 3.png
-rw-r--r--   1 runner  staff  2573903 Oct 18 08:35 12 Fitnessstudio Blick 4.png
-rw-r--r--   1 runner  staff  2655836 Oct 18 08:36 13 Fitnessstudio Kabelturm.png
-rw-r--r--   1 runner  staff  2844924 Oct 18 08:36 14 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1517174 Oct 18 08:37 15 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1515692 Oct 18 08:37 16 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326625 Oct 18 08:37 17 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff  1657633 Oct 18 08:38 18 Kniebeuge 3D.png
-rw-r--r--   1 runner  staff  1620124 Oct 18 08:38 19 Kniebeuge 3D Bewegung.png
-rw-r--r--   1 runner  staff   343373 Oct 18 08:38 20 Kniebeuge im Fitnessstudio.png
-rw-r--r--   1 runner  staff   377680 Oct 18 08:39 21 Rezepte.png
-rw-r--r--   1 runner  staff   787353 Oct 18 08:39 22 Rezept.png
-rw-r--r--   1 runner  staff   192811 Oct 18 08:39 23 Kochmodus.png
-rw-r--r--   1 runner  staff   173777 Oct 18 08:39 24 Kochmodus Schritt 1.png
-rw-r--r--   1 runner  staff   133839 Oct 18 08:39 25 Kochmodus Schritt 2.png
-rw-r--r--   1 runner  staff   433303 Oct 18 08:40 26 Mobility.png
-rw-r--r--   1 runner  staff   346794 Oct 18 08:40 27 Einstellungen.png
-rw-r--r--   1 runner  staff  1874165 Oct 18 08:40 28 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1829613 Oct 18 08:40 29 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   465219 Oct 18 08:40 30 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    43285 Oct 18 08:37 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
-rw-r--r--@  1 runner  staff    43806 Oct 18 08:38 Aufbau vor zweitem Versuch Übung Kniebeuge öffnen.txt
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
