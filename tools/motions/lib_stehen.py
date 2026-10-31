"""Bewegungen im Stand, die vorher nur als fertige Daten in der App lagen: Grundstand, Kniebeugen, Ausfallschritte,
Wadenheben, Hantelübungen im Stand, Gehen, Laufen und Aufwärmen.

Die alten Daten standen mit fast durchgestreckten, abgespreizten Armen und ohne jede Bewegung im Rumpf da. Hier
hängen die Arme locker, die Knie sind im Stand nur leicht gebeugt, und über Clip.alive atmet die Figur und pendelt
das Gewicht. Beim Gehen und Laufen schwingen die Arme gegengleich zu den Beinen, das Becken dreht mit.
"""

from __future__ import annotations

from .library import ANKLE, clip, flat_feet, mirror, reps, stand
from .lib_kraft import BARBELL, DUMBBELLS, STAND_KW, arms, sym

HIP = {"footL": (0.12, ANKLE, 0.0), "footR": (-0.12, ANKLE, 0.0), "kneeL": (0.15, 0.0, 1.0),
       "kneeR": (-0.15, 0.0, 1.0), **flat_feet(8.0)}
UP = stand(HIP)

# Hanteln: Griff je Übung (twist, wrist), mit clip.align_grip gesucht, damit die Hantel quer oder längs liegt
SUPINE = dict(twist=60.0, wrist=(0.0, 0.0))  # Handflächen nach vorn (Curl)
PRONE = dict(twist=-60.0, wrist=(0.0, 0.0))  # Handrücken nach vorn (Frontheben, Rudern zum Kinn)
NEUTRAL = dict(twist=0.0, wrist=(0.0, 0.0))  # Handflächen zueinander (Seitheben)


# =========================================================================== Grundstand

# Lockerer Stand: Atmung und Gewichtspendeln kommen aus Clip.alive, dazu ein ruhiger Blick nach links und rechts
LOOK_L = stand(UP, neck=(0.0, 0.0, 12.0), spine=(0.0, 0.0, 3.0))
LOOK_R = stand(UP, neck=(-3.0, 0.0, -10.0), spine=(0.0, 0.0, -2.0))
clip("idle", "Lockerer Stand", 6.0, [(0.0, UP), (1.2, UP), (2.4, LOOK_L), (3.2, LOOK_L), (4.6, LOOK_R), (5.2, LOOK_R)],
     **STAND_KW)


# =========================================================================== Kniebeugen

# Füße schulterbreit, Zehen leicht nach außen, Knie zeigen über die Zehen (nicht nach innen), Arme gehen zum
# Ausgleich nach vorn
SQ = {"footL": (0.17, ANKLE, 0.0), "footR": (-0.17, ANKLE, 0.0), "kneeL": (0.45, 0.0, 1.0),
      "kneeR": (-0.45, 0.0, 1.0), **flat_feet(20.0)}
SQ_UP = stand(SQ)
SQ_DOWN = stand(SQ, arms((0.17, 0.32, 0.42), (0.6, -1.0, 0.0), grip=0.4, twist=-20.0), root=(0.0, 0.58, -0.20),
                body=(0.0, 40.0, 0.0), spine=(-4.0, 0.0, 0.0), neck=(-28.0, 0.0, 0.0))
clip("squat", "Kniebeuge", 3.9, reps(SQ_UP, SQ_DOWN, 3.9, n=1, rest=0.12, up=0.42), **STAND_KW)

# Tiefe Hocke halten: Gesäß tief, Fersen am Boden, Ellbogen drücken die Knie sanft auseinander, Hände gefaltet
DEEP = stand(SQ, arms((0.03, -0.12, 0.30), (1.0, -1.0, 0.0), grip=0.5, twist=-30.0), root=(0.0, 0.40, -0.12),
             body=(0.0, 38.0, 0.0), spine=(8.0, 0.0, 0.0), neck=(-30.0, 0.0, 0.0), kneeL=(0.6, 0.0, 1.0),
             kneeR=(-0.6, 0.0, 1.0))
DEEP_B = stand(DEEP, spine=(4.0, 0.0, 0.0), neck=(-34.0, 0.0, 0.0))
clip("deepSquat", "Tiefe Hocke", 5.0, [(0.0, SQ_UP), (0.4, SQ_UP), (1.6, DEEP), (2.6, DEEP_B), (3.6, DEEP),
                                       (4.6, SQ_UP)], **STAND_KW)


# =========================================================================== Wadenheben

TOES_UP = {"soleL": (1.0, 8.0, 42.0), "soleR": (1.0, -8.0, 42.0)}
CALF_UP = stand(HIP, TOES_UP, root=(0.0, 1.09, 0.02), footL=(0.12, ANKLE + 0.09, 0.0), footR=(-0.12, ANKLE + 0.09, 0.0))
clip("calf", "Wadenheben", 3.2, reps(UP, CALF_UP, 3.2, n=1, rest=0.15, up=0.35), **STAND_KW)

CALF_DB = arms((0.23, -0.49, 0.06), (0.1, 0.0, -1.0), **NEUTRAL)
clip("calfDb", "Wadenheben mit Kurzhanteln", 3.2,
     reps(stand(UP, CALF_DB), stand(CALF_UP, CALF_DB), 3.2, n=1, rest=0.15, up=0.35), props=DUMBBELLS, **STAND_KW)


# =========================================================================== Hantelübungen im Stand

# Bizeps-Curl: Oberarme bleiben am Körper, nur die Unterarme beugen; Hände etwas seitlich und vorn,
# damit die quer liegende Hantel unten nicht im Oberschenkel steckt
CURL_LOW = stand(UP, arms((0.27, -0.46, 0.15), (0.1, 0.0, -1.0), **SUPINE))
CURL_TOP = stand(UP, arms((0.24, -0.03, 0.14), (0.05, -1.0, -0.2), **SUPINE), neck=(-3.0, 0.0, 0.0))
clip("curl", "Bizeps-Curl mit Kurzhanteln", 3.8, reps(CURL_LOW, CURL_TOP, 3.8, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

CURLB_LOW = stand(UP, arms((0.19, -0.47, 0.13), (0.1, 0.0, -1.0), grip=0.95, twist=60.0))
CURLB_TOP = stand(UP, arms((0.19, -0.03, 0.15), (0.05, -1.0, -0.2), grip=0.95, twist=60.0), neck=(-3.0, 0.0, 0.0))
clip("curlBar", "Bizeps-Curl mit Langhantel", 3.8, reps(CURLB_LOW, CURLB_TOP, 3.8, n=1, rest=0.12, up=0.40),
     props=BARBELL, **STAND_KW)

# Seitheben: Arme leicht gebeugt seitlich bis auf Schulterhöhe, Handflächen nach unten
LAT_LOW = stand(UP, arms((0.24, -0.46, 0.09), (0.3, 0.0, -1.0), **NEUTRAL))
LAT_TOP = stand(UP, arms((0.69, 0.03, 0.12), (0.0, 0.2, -1.0), **NEUTRAL))
clip("lateral", "Seitheben mit Kurzhanteln", 3.6, reps(LAT_LOW, LAT_TOP, 3.6, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

# Frontheben: Arme fast gestreckt nach vorn bis auf Schulterhöhe
FR_LOW = stand(UP, arms((0.18, -0.47, 0.13), (0.3, 0.0, -1.0), **PRONE))
FR_TOP = stand(UP, arms((0.19, 0.05, 0.56), (0.3, 1.0, -0.4), **PRONE))
clip("frontRaise", "Frontheben mit Kurzhanteln", 3.8, reps(FR_LOW, FR_TOP, 3.8, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

# Schulterdrücken: Hanteln von Schulterhöhe über den Kopf, Ellbogen unter den Händen
OH_LOW = stand(UP, arms((0.31, 0.09, 0.07), (1.0, -1.0, 0.0), **PRONE))
OH_TOP = stand(UP, arms((0.21, 0.55, 0.06), (1.0, -0.2, 0.0), **PRONE))
clip("overhead", "Schulterdrücken mit Kurzhanteln", 3.6, reps(OH_LOW, OH_TOP, 3.6, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

# Langhantel: Stange vor dem Kinn, der Kopf weicht beim Drücken kurz nach hinten aus
OHB_LOW = stand(UP, arms((0.27, 0.10, 0.21), (0.6, -1.0, 0.4), grip=0.95, twist=-60.0), neck=(-8.0, 0.0, 0.0))
OHB_TOP = stand(UP, arms((0.27, 0.58, 0.08), (1.0, -0.2, 0.0), grip=0.95, twist=-60.0))
clip("overheadBar", "Schulterdrücken mit Langhantel", 4.0, reps(OHB_LOW, OHB_TOP, 4.0, n=1, rest=0.12, up=0.40),
     props=BARBELL, **STAND_KW)

# Rudern zum Kinn: Hanteln nah am Körper nach oben, Ellbogen führen nach außen oben
UR_LOW = stand(UP, arms((0.12, -0.46, 0.14), (0.6, 0.0, -1.0), **PRONE))
UR_TOP = stand(UP, arms((0.12, -0.02, 0.13), (1.0, 0.6, -0.3), **PRONE))
clip("uprightRow", "Rudern zum Kinn mit Kurzhanteln", 3.8, reps(UR_LOW, UR_TOP, 3.8, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

# Trizepsdrücken über Kopf: Oberarme neben dem Kopf, Unterarme senken die Hanteln hinter den Kopf
TRI_TOP = stand(UP, arms((0.13, 0.58, 0.04), (0.3, 1.0, 0.1), **NEUTRAL))
TRI_LOW = stand(UP, arms((0.13, 0.22, -0.13), (0.3, 1.0, 0.4), **NEUTRAL), neck=(4.0, 0.0, 0.0))
clip("triceps", "Trizepsdrücken über Kopf mit Kurzhanteln", 3.8, reps(TRI_TOP, TRI_LOW, 3.8, n=1, rest=0.12, up=0.42),
     props=DUMBBELLS, **STAND_KW)

# Am Kabelzug (die App zeigt Kabel und Griffe an den Händen): Trizepsdrücken nach unten, Face Pull, Kabelfliegende
PD_TOP = stand(UP, arms((0.15, -0.05, 0.22), (0.1, -1.0, -0.3), **PRONE), body=(0.0, 8.0, 0.0))
PD_LOW = stand(UP, arms((0.15, -0.44, 0.15), (0.1, 0.0, -1.0), **PRONE), body=(0.0, 8.0, 0.0))
clip("pushdown", "Trizepsdrücken am Kabel", 3.4, reps(PD_TOP, PD_LOW, 3.4, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

FP_FRONT = stand(UP, arms((0.15, 0.10, 0.55), (0.6, 0.0, -1.0), grip=0.9, twist=-20.0))
FP_BACK = stand(UP, arms((0.30, 0.16, 0.10), (1.0, 0.3, -0.6), grip=0.9, twist=20.0), neck=(-3.0, 0.0, 0.0))
clip("facePull", "Face Pull am Kabel", 3.8, reps(FP_FRONT, FP_BACK, 3.8, n=1, rest=0.12, up=0.40),
     props=DUMBBELLS, **STAND_KW)

FC_OPEN = stand(UP, arms((0.58, 0.00, 0.22), (0.3, 1.0, -0.8), **NEUTRAL), body=(0.0, 10.0, 0.0),
                footL=(0.12, ANKLE, 0.12), footR=(-0.12, ANKLE, -0.16))
FC_CLOSE = stand(FC_OPEN, arms((0.08, -0.14, 0.45), (1.0, 0.3, -0.4), **NEUTRAL))
clip("flyCable", "Kabelfliegende", 3.8, reps(FC_OPEN, FC_CLOSE, 3.8, n=1, rest=0.12, up=0.42), props=DUMBBELLS,
     **STAND_KW)


# =========================================================================== Ausfallschritte

# Großer Schritt nach vorn, beide Knie etwa 90°, hinteres Knie knapp über dem Boden, Oberkörper aufrecht. Nur die
# linke Seite beschrieben, die rechte entsteht gespiegelt.
LUNGE_DOWN = stand(UP, root=(0.03, 0.55, 0.04), body=(0.0, 4.0, 0.0), footL=(0.13, ANKLE, 0.42),
                   footR=(-0.12, 0.16, -0.40), kneeL=(0.1, 0.0, 1.0), kneeR=(-0.05, -0.3, 1.0),
                   soleR=(0.0, 0.0, 0.0), ankleR=-10.0, toesR=55.0)
LUNGE_STEP = stand(UP, footL=(0.13, ANKLE, 0.42), root=(0.03, 0.96, 0.18))
LUNGE_KEYS = [(0.0, UP), (0.4, UP), (1.0, LUNGE_STEP), (1.9, LUNGE_DOWN), (2.3, LUNGE_DOWN), (3.1, LUNGE_STEP),
              (3.7, UP)]
clip("lunge", "Ausfallschritt", 8.0, LUNGE_KEYS, mirror_half=True, step_lift=0.10, **STAND_KW)

LDB = arms((0.23, -0.49, 0.06), (0.1, 0.0, -1.0), **NEUTRAL)
clip("lungeDb", "Ausfallschritt mit Kurzhanteln", 8.0, [(t, stand(p, LDB)) for t, p in LUNGE_KEYS],
     mirror_half=True, step_lift=0.10, props=DUMBBELLS, **STAND_KW)


# =========================================================================== Gehen, Laufen, Aufwärmen

def gait(period, stride, lift, bob, lean, arm_front, arm_back, knee_up, heel_up, crouch=0.0) -> list:
    """Ein Schrittzyklus auf der Stelle (wie auf dem Laufband): das Standbein gleitet unter dem Körper nach hinten,
    das Schwungbein schwingt angehoben nach vorn. Arme schwingen gegengleich (Hand vorn arm_front, hinten arm_back
    im Raum des Brustkorbs, linke Seite), das Becken dreht und neigt sich mit.
    Beschrieben ist der Schritt mit dem linken Bein, der rechte ist sein Spiegelbild.
    """
    h = period / 2
    y0 = 0.96 - crouch
    front, back = arm_front, arm_back
    middle = tuple((a + b) / 2 for a, b in zip(front, back))

    def right(v):
        return (-v[0], v[1], v[2])

    def pose(fl, fr, kl, kr, hl, hr, sl, sr, ry, turn):
        el = (0.1, -0.3, -1.0)
        return stand(sym("grip{}", 0.45), sym("twist{}", -25.0), root=(0.0, ry, 0.0), body=(-turn, lean, 0.0),
                     spine=(0.0, 0.0, 1.6 * turn), neck=(-lean * 0.6, 0.0, -0.6 * turn),
                     footL=fl, footR=fr, kneeL=kl, kneeR=kr, soleL=sl, soleR=sr,
                     handL=hl, handR=right(hr), elbowL=el, elbowR=right(el))

    flat = (1.0, 8.0, 0.0)
    # Kontakt: linke Ferse setzt vorn auf, rechter Fuß hinten auf den Zehen; linker Arm hinten, rechter vorn
    contact = pose((0.11, ANKLE, stride), (-0.11, ANKLE + 0.03, -stride), (0.12, 0.0, 1.0), (-0.12, 0.0, 1.0),
                   back, front, (1.0, 8.0, -8.0), (0.0, 0.0, 0.0), y0 - bob, 6.0)
    # Mitte: linkes Bein trägt unter dem Körper, rechtes schwingt angehoben nach vorn
    mid = pose((0.11, ANKLE, 0.0), (-0.11, ANKLE + lift, -0.02 + knee_up * 0.5), (0.12, 0.0, 1.0),
               (-0.12, 0.3, 1.0), middle, middle, flat, (0.0, 0.0, 0.0), y0 + bob, 0.0)
    for p in (contact, mid):
        p["ankleR"] = 5.0 + heel_up
        p["toesR"] = 15.0 if p is contact else 0.0
    return [(0.0, contact), (0.5 * h, mid), (h, mirror(contact)), (1.5 * h, mirror(mid))]


# Gehen: Arme fast gestreckt, pendeln locker vor und zurück
WALK = gait(1.15, 0.30, 0.10, 0.012, 2.0, (0.19, -0.44, 0.24), (0.21, -0.46, -0.10), 0.12, 15.0)
clip("walk", "Gehen", 1.15, WALK, **STAND_KW)
# Laufen: Ellbogen etwa 90° gebeugt, Hand schwingt von der Hüfte bis vor die Brust
RUN = gait(0.72, 0.38, 0.22, 0.03, 8.0, (0.17, -0.12, 0.24), (0.21, -0.32, -0.08), 0.35, 70.0, crouch=0.03)
clip("run", "Laufen", 0.72, RUN, **STAND_KW)

FARM_HANDS = arms((0.24, -0.50, 0.06), (0.1, 0.0, -1.0), **NEUTRAL)
FARMER = gait(1.3, 0.24, 0.08, 0.008, 0.0, (0.2, -0.5, 0.1), (0.2, -0.5, 0.1), 0.10, 12.0)
clip("farmer", "Farmer's Walk", 1.3, [(t, stand(p, FARM_HANDS)) for t, p in FARMER], props=DUMBBELLS, **STAND_KW)

# Kniehebelauf und Anfersen auf der Stelle: Arme schwingen im Lauf-Rhythmus mit
_run_arms = {"gripL": 0.6, "gripR": 0.6, "elbowL": (0.1, -0.3, -1.0), "elbowR": (-0.1, -0.3, -1.0)}
KR_UP = stand(HIP, _run_arms, footL=(0.11, 0.55, 0.30), kneeL=(0.1, 1.0, 1.0), soleL=(0.0, 0.0, 0.0), ankleL=15.0,
              handL=(0.21, -0.25, -0.18), handR=(-0.21, -0.12, 0.30), root=(0.0, 0.97, 0.0), body=(0.0, -2.0, 0.0))
KR_DOWN = stand(HIP, _run_arms, handL=(0.21, -0.20, 0.10), handR=(-0.21, -0.20, 0.10), root=(0.0, 0.94, 0.0))
clip("kneeRaise", "Kniehebelauf", 2.0, [(0.0, KR_DOWN), (0.45, KR_UP), (0.8, KR_DOWN)], mirror_half=True,
     **STAND_KW)

BK_UP = stand(HIP, _run_arms, footL=(0.11, 0.62, -0.30), kneeL=(0.1, -1.0, 0.3), soleL=(0.0, 0.0, 0.0),
              ankleL=40.0, handL=(0.21, -0.12, 0.30), handR=(-0.21, -0.25, -0.18), root=(0.0, 0.97, 0.0),
              body=(0.0, 6.0, 0.0))
BK_DOWN = stand(HIP, _run_arms, handL=(0.21, -0.20, 0.10), handR=(-0.21, -0.20, 0.10), root=(0.0, 0.94, 0.0),
                body=(0.0, 4.0, 0.0))
clip("buttKick", "Anfersen", 1.6, [(0.0, BK_DOWN), (0.35, BK_UP), (0.65, BK_DOWN)], mirror_half=True, **STAND_KW)

# Seilspringen: kleine Sprünge auf den Fußballen, Hände drehen das Seil neben der Hüfte
JR_HANDS = arms((0.30, -0.30, 0.14), (0.3, -0.2, -1.0), grip=0.9, twist=-20.0)
JR_DOWN = stand(HIP, JR_HANDS, TOES_UP, root=(0.0, 1.04, 0.02), body=(0.0, 3.0, 0.0),
                footL=(0.10, ANKLE + 0.05, 0.0), footR=(-0.10, ANKLE + 0.05, 0.0))
JR_UP = stand(JR_DOWN, arms((0.31, -0.33, 0.10), (0.3, -0.2, -1.0), grip=0.9, twist=-20.0), root=(0.0, 1.10, 0.02),
              footL=(0.10, ANKLE + 0.09, 0.0), footR=(-0.10, ANKLE + 0.09, 0.0), ankleL=25.0, ankleR=25.0,
              soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0))
clip("jumpRope", "Seilspringen", 0.9, [(0.0, JR_DOWN), (0.45, JR_UP)], ground=False, alive=0.0, **STAND_KW)

# Beinschwingen: ein Bein schwingt locker vor und zurück, die Arme halten das Gleichgewicht
LS_BASE = stand(HIP, footR=(-0.12, ANKLE, 0.0), handL=(0.45, -0.20, 0.10), handR=(-0.45, -0.20, 0.10),
                elbowL=(0.3, -0.5, -1.0), elbowR=(-0.3, -0.5, -1.0))
LS_FWD = stand(LS_BASE, footL=(0.13, 0.55, 0.55), kneeL=(0.1, 1.0, 0.5), soleL=(0.0, 0.0, 0.0), ankleL=10.0,
               body=(0.0, -6.0, 0.0), root=(-0.02, 0.97, -0.03))
LS_BACK = stand(LS_BASE, footL=(0.13, 0.30, -0.45), kneeL=(0.1, -0.2, 1.0), soleL=(0.0, 0.0, 0.0), ankleL=20.0,
                body=(0.0, 8.0, 0.0), root=(-0.02, 0.97, 0.02))
clip("legSwing", "Beinschwingen", 2.4, [(0.0, LS_BASE), (0.25, LS_BACK), (0.7, LS_FWD), (1.05, LS_BASE)],
     mirror_half=True, **STAND_KW)
