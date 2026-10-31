# Simulator-Rundgang

Commit: 722c660 · Ergebnis: success

## Fehler und Hinweise
```
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Bankdrücken öffnen (Bankdrücken, Kraft · Langhantel und Bank, Aktiv: Brust. Passiv: Schultern, Trizeps)
RUNDGANG: öffnet nicht beim ersten Tippen: Übung Kniebeuge öffnen (Kniebeuge, Kraft · Langhantel und Bank, Aktiv: Oberschenkel vorne, Gesäß. Passiv: Beinbeuger, Unterer Rücken, Bauch)
Test Case '-[BFCUITests.RundgangTests testRundgang]' passed (453.204 seconds).
```
## App-Protokoll (Fehler und Warnungen)
```
  18 E  FitScan[13100:cf4a] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11b44fb40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
  18 E  FitScan[13100:cf4a] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
  18 E  FitScan[13100:cf49] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11b44fb40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
  18 E  FitScan[13100:cf49] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
  16 nicht trainiert, Aktiv: Trapez / oberer Rücken, Schultern. Passiv: ' (AX element pid: 13100, elementOrHash.elementID: 5959841344.4316) faulted in {
  16 ht trainiert, Aktiv: Hüftbeuger. Passiv: Oberschenkel vorne' (AX element pid: 13100, elementOrHash.elementID: 5959829248.4315) faulted in {
  16 gen nicht trainiert, Aktiv: Waden. Passiv: ' (AX element pid: 13100, elementOrHash.elementID: 6003263232.4319) faulted in {
  16 gen nicht trainiert, Aktiv: Beinbeuger. Passiv: Unterer Rücken, Waden' (AX element pid: 13100, elementOrHash.elementID: 6002280192.4318) faulted in {
  16 cht trainiert, Aktiv: Unterer Rücken, Latissimus. Passiv: Brust' (AX element pid: 13100, elementOrHash.elementID: 6002289152.4317) faulted in {
   9 E  FitScan[13100:d7b1] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11b44fb40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[13100:d7b1] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   9 E  FitScan[13100:c3fe] [com.apple.UIKit:UIKBFeedbackGenerator] <_UIKBFeedbackGenerator: 0x11b44fb40>: Error creating CHHapticPattern: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file." UserInfo={N
   9 E  FitScan[13100:c3fe] (CoreHaptics)        CHHapticPattern.mm:487   +[CHHapticPattern patternForKey:error:]: Failed to read pattern library data: Error Domain=NSCocoaErrorDomain Code=260 "The file “hapticpatternlibrary.plist” couldn’t be opened because there is no such file.
   6 Df FitScan[13100:af81] [com.apple.re:Audio] Using default phaseStopOnIdle from user defaults = true
   6 Df FitScan[13100:af81] [com.apple.re:Audio] [RE/ECS] [Update] Set sceneID to default reverbPreset with no valid reverb components in scene.
   2 Df FitScan[13100:af9e] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 F  FitScan[13100:af81] [com.apple.renderbox:error] building pipeline path_exterior-jba6la7jbebia3 took 0.983397 seconds
   1 E  FitScan[13100:f053] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:f008] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:ec13] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:d7b7] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:d7b1] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:d673] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:d671] [com.apple.coreanimation:API] warning, deleted thread with uncommitted CATransaction; set CA_DEBUG_TRANSACTIONS=1 in environment to log backtraces, or set CA_ASSERT_MAIN_THREAD_TRANSACTIONS=1 to abort when an implicit transaction isn't created on a main
   1 E  FitScan[13100:af97] [com.apple.HealthKit:default] connection error: Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit entitlement.}
   1 E  FitScan[13100:af81] [com.apple.re:Foundation.IO] Could not locate file 'default-binaryarchive.metallib' in bundle.
   1 Df FitScan[13100:f274] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[13100:f274] [com.apple.dt.automationmode:Default] Handling posted change notification (com.apple.dt.automationmode.state-changed)
   1 Df FitScan[13100:f274] [com.apple.dt.automationmode:Default] Comparing previous enabled state (1) to current enabled state (0)
   1 Df FitScan[13100:c4a1] [com.apple.calls.callkit:Default] Call host has no calls
   1 Df FitScan[13100:afa4] [com.apple.storekit:Default] Registering for 'transactionsupdated' daemon notification
   1 Df FitScan[13100:afa4] [com.apple.storekit:Default] [Default] Finished iterating transaction batches
   1 Df FitScan[13100:afa3] [com.apple.dt.automationmode:Default] Returning 1 for enabled state
   1 Df FitScan[13100:af9e] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[13100:af9c] [com.apple.dt.automationmode:Default] XAM shared observer connecting to com.apple.dt.automationmode.reader
   1 Df FitScan[13100:af9a] [com.apple.storekit:Default] AAFService connection invalidated
   1 Df FitScan[13100:af97] [com.apple.BoardServices:XPCErrors] [C:1] Alloc com.apple.frontboard.systemappservices
   1 Df FitScan[13100:af8b] [com.apple.BoardServices:XPCErrors] [C:4] Alloc com.apple.PointerUI.pointeruid.service
   1 Df FitScan[13100:af81] [PrototypeTools:domain] Not observing PTDefaults on customer install.
   1 Df FitScan[13100:af81] [com.apple.xpc:connection] [0x16ccae6c0] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[13100:af81] [com.apple.xpc:connection] [0x11b747200] failed to do a bootstrap look-up: xpc_error=[3: No such process]
   1 Df FitScan[13100:af81] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
   1 Df FitScan[13100:af81] [com.apple.UIKit:KeyWindow] Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
   1 Df FitScan[13100:af81] [com.apple.runningboard:general] Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x106d74d00>
   1 Df FitScan[13100:af81] [com.apple.re:Graphics] MTLLibrary /Library/Developer/CoreSimulator/Volumes/iOS_23E254a/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.4.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreRE.framework/default.metall
   1 Df FitScan[13100:af81] [com.apple.re:Foundation.Profiling] MTLCounter API disabled. Enable with 'defaults write -g com.apple.re.showMTLCounterAPIStatistics 1'
   1 Df FitScan[13100:af81] [com.apple.re:Audio] [RE] [Sleep/Wake] User Defaults set enableAudioEngineRunnableAutomationSupport=0
   1 Df FitScan[13100:af81] [com.apple.network:activity] Unsetting the global parent activity <nw_activity 50:1 [2AB26E09-D777-4BA2-B168-30C81F31C662] (global parent) (reporting strategy default) complete (reason success)>
   1 Df FitScan[13100:af81] [com.apple.network:activity] Set activity <nw_activity 50:1 [2AB26E09-D777-4BA2-B168-30C81F31C662] (reporting strategy default)> as the global parent
   1 Df FitScan[13100:af81] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:2 [79D0C5EC-EC8A-4EFC-8A8C-9CAE9C9EA316] (reporting strategy default)>
   1 Df FitScan[13100:af81] [com.apple.network:activity] Create activity from XPC object <nw_activity 50:1 [2AB26E09-D777-4BA2-B168-30C81F31C662] (reporting strategy default)>
   1 Df FitScan[13100:af81] [com.apple.network:activity] <nw_activity 50:2 [79D0C5EC-EC8A-4EFC-8A8C-9CAE9C9EA316] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 8524ms
   1 Df FitScan[13100:af81] [com.apple.network:activity] <nw_activity 50:1 [2AB26E09-D777-4BA2-B168-30C81F31C662] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 8523ms
   1 Df FitScan[13100:af81] [com.apple.BoardServices:XPCErrors] [C:5] Alloc com.apple.inputservice.input-ui-host
   1 Df FitScan[13100:af81] [com.apple.BoardServices:XPCErrors] [C:3] Alloc com.apple.sessionservices
   1 Df FitScan[13100:af81] [com.apple.BoardServices:XPCErrors] [C:2] Alloc com.apple.backboard.hid-services.xpc
   1 :
```
## Dateien
```
out:
total 356864
drwxr-xr-x  10 runner  staff        320 Oct 31 09:45 .
drwxr-xr-x  23 runner  staff        736 Oct 31 09:33 ..
drwxr-xr-x   2 runner  staff         64 Oct 31 09:45 abstuerze
-rw-r--r--   1 runner  staff  110931821 Oct 31 09:44 app-protokoll.txt
-rw-r--r--   1 runner  staff         92 Oct 31 09:45 avconvert.txt
drwxr-xr-x  34 runner  staff       1088 Oct 31 09:44 bilder
-rw-r--r--   1 runner  staff      10745 Oct 31 09:45 ERGEBNIS.md
-rw-r--r--   1 runner  staff   65041443 Oct 31 09:45 rundgang.mp4
drwxr-xr-x   4 runner  staff        128 Oct 31 09:44 rundgang.xcresult
-rw-r--r--   1 runner  staff     142656 Oct 31 09:44 test.log

out/bilder:
total 64112
drwxr-xr-x  34 runner  staff     1088 Oct 31 09:44 .
drwxr-xr-x  10 runner  staff      320 Oct 31 09:45 ..
-rw-r--r--   1 runner  staff   291818 Oct 31 09:37 01 Willkommen.png
-rw-r--r--   1 runner  staff   392265 Oct 31 09:37 02 Profil.png
-rw-r--r--   1 runner  staff   444941 Oct 31 09:37 03 Profil unten.png
-rw-r--r--   1 runner  staff   325639 Oct 31 09:37 04 Trainingsplan.png
-rw-r--r--   1 runner  staff   310925 Oct 31 09:38 05 KI-Coach.png
-rw-r--r--   1 runner  staff   521555 Oct 31 09:38 06 KI-Coach Ziel wählen.png
-rw-r--r--   1 runner  staff   316191 Oct 31 09:38 07 KI-Coach Plan.png
-rw-r--r--   1 runner  staff   434166 Oct 31 09:38 08 KI-Coach Plan unten.png
-rw-r--r--   1 runner  staff  2594873 Oct 31 09:39 09 Fitnessstudio.png
-rw-r--r--   1 runner  staff  2610540 Oct 31 09:39 10 Fitnessstudio Blick 2.png
-rw-r--r--   1 runner  staff  2638258 Oct 31 09:39 11 Fitnessstudio Blick 3.png
-rw-r--r--   1 runner  staff  2383533 Oct 31 09:39 12 Fitnessstudio Blick 4.png
-rw-r--r--   1 runner  staff  2678133 Oct 31 09:39 13 Fitnessstudio Kabelturm.png
-rw-r--r--   1 runner  staff  2868244 Oct 31 09:39 14 Fitnessstudio Stationen.png
-rw-r--r--   1 runner  staff  1573898 Oct 31 09:40 15 Bankdrücken 3D.png
-rw-r--r--   1 runner  staff  1568899 Oct 31 09:40 16 Bankdrücken 3D Bewegung.png
-rw-r--r--   1 runner  staff   326625 Oct 31 09:41 17 Bankdrücken im Fitnessstudio.png
-rw-r--r--   1 runner  staff  1674359 Oct 31 09:42 18 Kniebeuge 3D.png
-rw-r--r--   1 runner  staff  1675918 Oct 31 09:42 19 Kniebeuge 3D Bewegung.png
-rw-r--r--   1 runner  staff   343373 Oct 31 09:42 20 Kniebeuge im Fitnessstudio.png
-rw-r--r--   1 runner  staff   418343 Oct 31 09:42 21 Rezepte.png
-rw-r--r--   1 runner  staff   787353 Oct 31 09:43 22 Rezept.png
-rw-r--r--   1 runner  staff   192811 Oct 31 09:43 23 Kochmodus.png
-rw-r--r--   1 runner  staff   173777 Oct 31 09:43 24 Kochmodus Schritt 1.png
-rw-r--r--   1 runner  staff   133839 Oct 31 09:43 25 Kochmodus Schritt 2.png
-rw-r--r--   1 runner  staff   433303 Oct 31 09:43 26 Mobility.png
-rw-r--r--   1 runner  staff   346794 Oct 31 09:43 27 Einstellungen.png
-rw-r--r--   1 runner  staff  1883975 Oct 31 09:44 28 Eigene Figur vorne.png
-rw-r--r--   1 runner  staff  1869176 Oct 31 09:44 29 Eigene Figur hinten.png
-rw-r--r--   1 runner  staff   454796 Oct 31 09:44 30 Eigene Figur Regler.png
-rw-r--r--@  1 runner  staff    44545 Oct 31 09:40 Aufbau vor zweitem Versuch Übung Bankdrücken öffnen.txt
-rw-r--r--@  1 runner  staff    45066 Oct 31 09:41 Aufbau vor zweitem Versuch Übung Kniebeuge öffnen.txt
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
