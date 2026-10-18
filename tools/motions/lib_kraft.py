"""Bewegungen, die vorher nur als fertige Daten in der App lagen und dort unnatürlich aussahen (Prüfung mit
`python -m motions pruefen`): Krafttraining an Bank, Hanteln und Stange, Übungen auf der Matte, Ausfallschritte,
Rückenlage.

Neu aufgebaut, damit die Figur natürlich liegt und steht: auf der Bank liegt der Rücken auf dem Polster und die
Füße stehen fest am Boden (Clip.rest), Hanteln sitzen in der Hand (Prop(hand=...)), an der Klimmzugstange hängt die
Figur frei, Hände und Knie bleiben auf dem Boden statt hindurchzugreifen, Füße machen Schritte statt zu rutschen
(Clip.step_lift).
"""

from __future__ import annotations

import math

from .clip import Prop
from .library import ANKLE, clip, flat_feet, reps, stand

# Hantelbank aus tools/geraete (Oberkante 0,30 m, Polster 0,29 m breit, Kopfende bei z = -0.82)
BENCH_REST = (0.30, 0.14, -0.82, 0.41)
DUMBBELLS = [Prop("dumbbell", hand="L"), Prop("dumbbell", hand="R")]
BARBELL = [Prop("barbell", hand="LR")]
# Schulter im Raum des Brustkorbs (Ursprung spine3)
SHOULDER = (0.20, 0.06, 0.03)


def sym(key: str, v) -> dict:
    """Kanal für beide Seiten, rechts gespiegelt (x negiert bzw. Winkel um die Hochachse gedreht)."""
    lk, rk = key.format("L"), key.format("R")
    if isinstance(v, tuple) and len(v) == 3:
        return {lk: v, rk: (-v[0], v[1], v[2])}
    if isinstance(v, tuple) and len(v) == 2:
        return {lk: v, rk: (v[0], -v[1])}
    return {lk: v, rk: v}


def arms(hand, elbow, grip=0.9, wrist=(0.0, 0.0), twist=0.0) -> dict:
    d = sym("twist{}", twist)
    d.update(sym("hand{}", hand))
    d.update(sym("elbow{}", elbow))
    d.update(sym("grip{}", grip))
    d.update(sym("wrist{}", wrist))
    d.update(sym("palm{}", (0.0, 0.0)))
    return d


def two_hands(w, pose):
    """Eine Kurzhantel mit beiden Händen gehalten (Überzüge, Swing): Achse in Richtung der Arme."""
    from .rig import between, normalize
    grip = (w["haL"] + w["haR"]) / 2
    sh = (w["uaL"] + w["uaR"]) / 2
    ax = normalize(grip - sh)
    return grip + ax * 0.09, between((0.0, 1.0, 0.0), ax)


def hang(x: float, length: float, pitch: float, fwd: float = 0.0, up: float = 0.0) -> tuple:
    """Ziel für eine senkrecht unter der Schulter hängende Hand im Raum des Brustkorbs, wenn der Brustkorb um
    pitch Grad nach vorn gekippt ist (Becken + Wirbelsäule). fwd verschiebt waagerecht nach vorn (Welt)."""
    c, s = math.cos(math.radians(pitch)), math.sin(math.radians(pitch))
    sx, sy, sz = SHOULDER
    down = length - up
    return (x, sy - down * c + fwd * s, sz + down * s + fwd * c)


# =========================================================================== Auf der Bank

# Drehung der Hand für neutralen Griff (Handflächen zueinander), mit clip.align_grip gesucht
FLY_TW, FLY_WR = -50.0, (-30.0, -15.0)
SKULL_TW, SKULL_WR = -45.0, (-15.0, 15.0)

# Rückenlage auf der Bank: Gesäß auf dem Sitz, Kopf auf der Lehne, Füße breit und fest neben der Bank
BENCH = stand(root=(0.0, 0.42, 0.10), body=(0.0, -90.0, 0.0), spine=(-4.0, 0.0, 0.0), neck=(4.0, 0.0, 0.0),
              footL=(0.30, ANKLE, 0.60), footR=(-0.30, ANKLE, 0.60), kneeL=(0.45, 1.0, 0.25),
              kneeR=(-0.45, 1.0, 0.25), **flat_feet(12.0))
BENCH_KW = dict(space={}, lying=True, bench=True, free=False, ground=False, rest=BENCH_REST, yaw=1.15,
                cam_y=0.55)

PRESS_TOP = stand(BENCH, arms((0.20, 0.02, 0.52), (1.0, 0.0, -0.3), twist=10.0, wrist=(10.0, 20.0)))
PRESS_LOW = stand(BENCH, arms((0.36, -0.02, 0.15), (1.0, -0.3, -0.8), twist=10.0, wrist=(10.0, 20.0)))
clip("benchPress", "Bankdrücken mit Kurzhanteln", 3.9, reps(PRESS_TOP, PRESS_LOW, 3.9, n=1, rest=0.12, up=0.42),
     props=DUMBBELLS, **BENCH_KW)

# Langhantel: Griff etwas breiter als schulterbreit, Stange senkt sich zur unteren Brust
BAR_TOP = stand(BENCH, arms((0.31, 0.0, 0.52), (1.0, 0.0, -0.3), grip=0.95))
BAR_LOW = stand(BENCH, arms((0.33, -0.08, 0.19), (1.0, -0.4, -0.8), grip=0.95))
clip("benchBar", "Bankdrücken mit Langhantel", 4.2, reps(BAR_TOP, BAR_LOW, 4.2, n=1, rest=0.12, up=0.42),
     props=BARBELL, **BENCH_KW)

# Fliegende: Arme leicht gebeugt in einem weiten Bogen, Handflächen zeigen zueinander
FLY_TOP = stand(BENCH, arms((0.13, 0.02, 0.52), (1.0, 0.0, -0.2), twist=FLY_TW, wrist=FLY_WR))
FLY_LOW = stand(BENCH, arms((0.60, -0.02, 0.06), (0.4, -0.2, -1.0), twist=FLY_TW, wrist=FLY_WR))
clip("fly", "Fliegende mit Kurzhanteln", 4.2, reps(FLY_TOP, FLY_LOW, 4.2, n=1, rest=0.12, up=0.45),
     props=DUMBBELLS, **BENCH_KW)

# Überzüge: eine Kurzhantel mit beiden Händen, Arme fast gestreckt über die Brust nach hinten hinter den Kopf
PULL_TOP = stand(BENCH, arms((0.045, 0.06, 0.55), (1.0, 0.2, 0.0), grip=0.5))
PULL_LOW = stand(BENCH, arms((0.045, 0.50, 0.12), (1.0, 0.0, 0.3), grip=0.5), spine=(-10.0, 0.0, 0.0))
clip("pullover", "Überzüge mit Kurzhantel", 4.6, reps(PULL_TOP, PULL_LOW, 4.6, n=1, rest=0.12, up=0.45),
     props=[Prop("dumbbell", place=two_hands)], **BENCH_KW)

# French Press (Skull Crusher): Oberarme bleiben senkrecht, nur die Ellbogen beugen, Hanteln neben die Stirn
SKULL_TOP = stand(BENCH, arms((0.15, 0.06, 0.53), (0.3, -0.2, -1.0), twist=SKULL_TW, wrist=SKULL_WR))
SKULL_LOW = stand(BENCH, arms((0.15, 0.36, 0.22), (0.1, -0.4, 1.0), twist=SKULL_TW, wrist=SKULL_WR))
clip("skull", "French Press mit Kurzhanteln", 4.0, reps(SKULL_TOP, SKULL_LOW, 4.0, n=1, rest=0.12, up=0.42),
     props=DUMBBELLS, **BENCH_KW)


# =========================================================================== An der Klimmzugstange

# Stange wie in der App (BodyRig.pullBar): Höhe 2,03 m, z = 0,05. Die Figur hängt frei, Knie leicht gebeugt,
# Unterschenkel nach hinten, damit die Füße nicht den Boden berühren.
BAR_Y, BAR_Z = 2.03, 0.05
HANG_FEET = {"footL": (0.07, -0.66, -0.26), "footR": (-0.07, -0.64, -0.30), "kneeL": (0.1, 0.0, 1.0),
             "kneeR": (-0.1, 0.0, 1.0), "soleL": (0.0, 0.0, 0.0), "soleR": (0.0, 0.0, 0.0), "ankleL": 30.0,
             "ankleR": 30.0}
HANG_SPACE = {"handL": "world", "handR": "world", "footL": "root", "footR": "root"}
HANG_KW = dict(space=HANG_SPACE, ground=False, free=False, app_props="pullbar", yaw=0.35, cam_y=1.3)


def on_bar(width=0.30, **kw) -> dict:
    d = arms((width, BAR_Y - 0.055, BAR_Z), (1.0, -0.4, 0.3), grip=1.0, twist=-15.0)
    d.update(HANG_FEET)
    d.update(kw)
    return stand(d)


DEAD_HANG = on_bar(root=(0.0, 0.85, 0.02), neck=(-8.0, 0.0, 0.0))
CHIN_OVER = on_bar(root=(0.0, 1.45, 0.06), body=(0.0, -10.0, 0.0), spine=(-8.0, 0.0, 0.0), neck=(-12.0, 0.0, 0.0),
                   elbowL=(1.0, -1.0, 0.4), elbowR=(-1.0, -1.0, 0.4))
clip("pullup", "Klimmzug", 4.0, reps(DEAD_HANG, CHIN_OVER, 4.0, n=1, rest=0.12, up=0.40), **HANG_KW)

SCAP = on_bar(root=(0.0, 0.92, 0.02), neck=(-10.0, 0.0, 0.0), clavL=(-6.0, 0.0), clavR=(-6.0, 0.0))
clip("hang", "Hängen an der Stange", 4.0, [(0.0, DEAD_HANG), (1.4, DEAD_HANG), (2.2, SCAP), (3.2, SCAP)],
     **HANG_KW)

KNEES_HIGH = on_bar(root=(0.0, 0.85, 0.02), body=(0.0, -12.0, 0.0), spine=(14.0, 0.0, 0.0),
                    footL=(0.09, -0.42, 0.40), footR=(-0.09, -0.42, 0.40), kneeL=(0.1, 1.0, 0.3),
                    kneeR=(-0.1, 1.0, 0.3), ankleL=20.0, ankleR=20.0)
clip("legRaise", "Hängendes Beinheben", 3.8, reps(DEAD_HANG, KNEES_HIGH, 3.8, n=1, rest=0.12, up=0.40), **HANG_KW)


# =========================================================================== Stehend mit Hanteln (Hüfte beugen)

ROW_TW, ROW_WR = -10.0, (0.0, 15.0)
RDL_TW, RDL_WR = 40.0, (0.0, 10.0)
STANCE = {"footL": (0.13, ANKLE, 0.0), "footR": (-0.13, ANKLE, 0.0), "kneeL": (0.2, 0.0, 1.0),
          "kneeR": (-0.2, 0.0, 1.0), **flat_feet(8.0)}
STAND_KW = dict(free=False, yaw=0.55, cam_y=0.9)


# Vorgebeugtes Rudern: Rücken gerade, etwa 45° vorgebeugt, Hanteln zur Hüfte ziehen, Ellbogen nah am Körper
ROW_BODY = dict(root=(0.0, 0.86, -0.10), body=(0.0, 50.0, 0.0), spine=(-5.0, 0.0, 0.0), neck=(-25.0, 0.0, 0.0))
ROW_LOW = stand(STANCE, ROW_BODY, arms(hang(0.19, 0.52, 45.0), (0.3, 0.0, -1.0), twist=ROW_TW, wrist=ROW_WR))
ROW_TOP = stand(STANCE, ROW_BODY, arms((0.21, -0.22, 0.04), (0.15, 0.0, -1.0), twist=ROW_TW, wrist=ROW_WR))
clip("row", "Rudern vorgebeugt mit Kurzhanteln", 3.6, reps(ROW_LOW, ROW_TOP, 3.6, n=1, rest=0.12, up=0.38),
     props=DUMBBELLS, **STAND_KW)

ROWB_LOW = stand(STANCE, ROW_BODY, arms(hang(0.25, 0.52, 45.0), (1.0, 0.0, -0.6), grip=0.95))
ROWB_TOP = stand(STANCE, ROW_BODY, arms((0.25, -0.28, 0.17), (0.6, 0.0, -1.0), grip=0.95))
clip("rowBar", "Rudern vorgebeugt mit Langhantel", 3.8, reps(ROWB_LOW, ROWB_TOP, 3.8, n=1, rest=0.12, up=0.38),
     props=BARBELL, **STAND_KW)

# Rumänisches Kreuzheben: Knie leicht gebeugt, Hüfte nach hinten, Hanteln gleiten nah an den Beinen nach unten
RDL_UP = stand(STANCE, arms(hang(0.16, 0.53, 0.0, fwd=0.10), (0.4, 0.0, -1.0), twist=RDL_TW, wrist=RDL_WR),
               root=(0.0, 0.93, 0.0))
RDL_DOWN = stand(STANCE, arms(hang(0.16, 0.53, 75.0, fwd=0.05), (0.4, 0.0, -1.0), twist=RDL_TW, wrist=RDL_WR),
                 root=(0.0, 0.88, -0.20), body=(0.0, 75.0, 0.0), spine=(0.0, 0.0, 0.0), neck=(-30.0, 0.0, 0.0),
                 kneeL=(0.15, 0.0, 1.0), kneeR=(-0.15, 0.0, 1.0))
clip("rdl", "Rumänisches Kreuzheben mit Kurzhanteln", 4.4, reps(RDL_UP, RDL_DOWN, 4.4, n=1, rest=0.12, up=0.42),
     props=DUMBBELLS, **STAND_KW)

RDLB_UP = stand(RDL_UP, arms(hang(0.24, 0.53, 0.0, fwd=0.08), (1.0, 0.0, -0.5), grip=0.95))
RDLB_DOWN = stand(RDL_DOWN, arms(hang(0.24, 0.53, 75.0, fwd=0.05), (1.0, 0.0, -0.5), grip=0.95))
clip("rdlBar", "Rumänisches Kreuzheben mit Langhantel", 4.6, reps(RDLB_UP, RDLB_DOWN, 4.6, n=1, rest=0.12, up=0.42),
     props=BARBELL, **STAND_KW)

# Trizeps-Kickback: vorgebeugt, Oberarme parallel zum Rumpf, nur der Unterarm streckt nach hinten
KB_BODY = dict(root=(0.0, 0.84, -0.12), body=(0.0, 60.0, 0.0), spine=(0.0, 0.0, 0.0), neck=(-30.0, 0.0, 0.0),
               kneeL=(0.2, 0.0, 1.0), kneeR=(-0.2, 0.0, 1.0))
KB_BENT = stand(STANCE, KB_BODY, arms((0.20, -0.35, 0.21), (0.1, 0.3, -1.0), twist=ROW_TW, wrist=ROW_WR))
KB_BACK = stand(STANCE, KB_BODY, arms((0.20, -0.47, -0.02), (0.1, 0.0, -1.0), twist=ROW_TW, wrist=ROW_WR))
clip("kickback", "Trizeps-Kickback mit Kurzhanteln", 3.6, reps(KB_BENT, KB_BACK, 3.6, n=1, rest=0.15, up=0.35),
     props=DUMBBELLS, **STAND_KW)

# Swing: eine Hantel mit beiden Händen, aus der Hüfte zwischen den Beinen nach vorn bis auf Schulterhöhe
SWING_STANCE = {"footL": (0.18, ANKLE, 0.0), "footR": (-0.18, ANKLE, 0.0), "kneeL": (0.35, 0.0, 1.0),
                "kneeR": (-0.35, 0.0, 1.0), **flat_feet(15.0)}
SWING_LOW = stand(SWING_STANCE, arms(hang(0.035, 0.52, 65.0, fwd=-0.16), (1.0, 0.0, -0.3), grip=1.0),
                  root=(0.0, 0.80, -0.18), body=(0.0, 65.0, 0.0), neck=(-35.0, 0.0, 0.0))
SWING_MID = stand(SWING_STANCE, arms(hang(0.035, 0.52, 20.0, fwd=0.25), (1.0, 0.0, -0.3), grip=1.0),
                  root=(0.0, 0.90, -0.05), body=(0.0, 20.0, 0.0), neck=(-10.0, 0.0, 0.0))
SWING_TOP = stand(SWING_STANCE, arms((0.035, 0.02, 0.55), (1.0, -0.3, 0.0), grip=1.0), root=(0.0, 0.93, 0.0),
                  body=(0.0, -3.0, 0.0))
clip("swing", "Swing mit Kurzhantel", 2.6,
     [(0.0, SWING_LOW), (0.55, SWING_MID), (1.0, SWING_TOP), (1.25, SWING_TOP), (1.75, SWING_MID), (2.25, SWING_LOW)],
     props=[Prop("dumbbell", place=two_hands)], **STAND_KW)

# Kniebeuge mit Langhantel: Stange liegt auf dem oberen Rücken, Fersen bleiben am Boden, Knie über den Zehen
SQ_STANCE = {"footL": (0.17, ANKLE, 0.0), "footR": (-0.17, ANKLE, 0.0), "kneeL": (0.4, 0.0, 1.0),
             "kneeR": (-0.4, 0.0, 1.0), **flat_feet(20.0)}
BAR_BACK = arms((0.40, 0.09, -0.13), (1.0, -1.0, -0.4), grip=1.0, wrist=(-25.0, 0.0))
SQ_UP = stand(SQ_STANCE, BAR_BACK, root=(0.0, 0.93, 0.0), neck=(-5.0, 0.0, 0.0))
SQ_DOWN = stand(SQ_STANCE, BAR_BACK, root=(0.0, 0.56, -0.22), body=(0.0, 42.0, 0.0), spine=(-6.0, 0.0, 0.0),
                neck=(-25.0, 0.0, 0.0))
clip("squatBar", "Kniebeuge mit Langhantel", 4.4, reps(SQ_UP, SQ_DOWN, 4.4, n=1, rest=0.12, up=0.45),
     props=BARBELL, **STAND_KW)

# Kniebeuge mit Kurzhanteln: Hanteln hängen seitlich, nicht ganz so tief
SQD_UP = stand(SQ_STANCE, arms(hang(0.24, 0.53, 0.0, fwd=0.02), (0.4, 0.0, -1.0), twist=RDL_TW, wrist=RDL_WR),
               root=(0.0, 0.93, 0.0))
SQD_DOWN = stand(SQ_STANCE, arms(hang(0.31, 0.53, 30.0, fwd=0.0), (0.4, 0.0, -1.0), twist=RDL_TW, wrist=RDL_WR),
                 root=(0.0, 0.62, -0.18), body=(0.0, 32.0, 0.0), spine=(-2.0, 0.0, 0.0), neck=(-20.0, 0.0, 0.0))
clip("squatDb", "Kniebeuge mit Kurzhanteln", 3.9, reps(SQD_UP, SQD_DOWN, 3.9, n=1, rest=0.12, up=0.45),
     props=DUMBBELLS, **STAND_KW)


# =========================================================================== Auf der Matte

# Hände flach am Boden (Welt), Rumpf darüber; aus den Grundhaltungen der Bibliothek, aber mit Händen und Knien,
# die am Boden bleiben, statt durch ihn hindurch zu greifen.
from .library import (CHATURANGA, FLOOR, HANDS_FLAT, HOOK, KNEES_DOWN, PLANK, PRONE, QUAD,  # noqa: E402
                      WORLD_HANDS, feet, hands, on_toes)

MAT_KW = dict(space=WORLD_HANDS, free=True, yaw=1.2, cam_y=0.45)

# Unterarmstütz: Ellbogen unter den Schultern, Körper eine Linie von Kopf bis Ferse
FOREARM = stand(hands(0.12, 0.045, 0.30, **HANDS_FLAT), {"elbowL": (0.1, -1.0, -0.3), "elbowR": (-0.1, -1.0, -0.3)},
                feet(0.10, 0.17, -1.24), on_toes(), KNEES_DOWN, root=(0.0, 0.31, -0.42), body=(0.0, 84.0, 0.0),
                neck=(-12.0, 0.0, 0.0), palmL=(1.0, -15.0), palmR=(1.0, 15.0))
clip("plank", "Unterarmstütz", 6.0, [(0.0, FOREARM),
                                     (3.0, stand(FOREARM, root=(0.0, 0.32, -0.42), spine=(2.0, 0.0, 0.0)))],
     **MAT_KW)

# Liegestütz: Hände etwas breiter als die Schultern, Ellbogen etwa 45° vom Körper, Brust fast am Boden
PUSH_UP = stand(PLANK, hands(0.24, FLOOR, 0.40, **HANDS_FLAT), feet(0.10, 0.17, -1.02),
                elbowL=(0.6, 0.0, -1.0), elbowR=(-0.6, 0.0, -1.0))
PUSH_DOWN = stand(CHATURANGA, hands(0.24, FLOOR, 0.40, **HANDS_FLAT), feet(0.10, 0.17, -1.02),
                  root=(0.0, 0.26, -0.10), body=(0.0, 85.0, 0.0), elbowL=(0.7, 0.4, -1.0), elbowR=(-0.7, 0.4, -1.0),
                  neck=(-12.0, 0.0, 0.0))
clip("pushup", "Liegestütz", 3.8, reps(PUSH_UP, PUSH_DOWN, 3.8, n=1, rest=0.12, up=0.42), **dict(MAT_KW, cam_y=0.4))

# Glute Bridge: Rückenlage, Füße aufgestellt, Hüfte heben bis Knie, Hüfte und Schultern eine Linie bilden
BRIDGE_DOWN = stand(HOOK, hands(0.27, 0.05, -0.10, **HANDS_FLAT), feet(0.13, ANKLE, 0.40))
BRIDGE_UP = stand(BRIDGE_DOWN, root=(0.0, 0.34, 0.02), body=(0.0, -124.0, 0.0), neck=(30.0, 0.0, 0.0),
                  kneeL=(0.15, 1.0, 0.6), kneeR=(-0.15, 1.0, 0.6))
clip("bridge", "Glute Bridge", 4.4, reps(BRIDGE_DOWN, BRIDGE_UP, 4.4, n=1, rest=0.12, up=0.40),
     **dict(MAT_KW, cam_y=0.4))

# Vierfüßlerstand mit Händen weiter vorn (für den Übergang in den herabschauenden Hund, Hände bleiben stehen)
QUAD_FWD = stand(QUAD, hands(0.21, FLOOR, 0.40, **HANDS_FLAT), root=(0.0, 0.55, -0.16))

# Katze-Kuh: Rücken rund machen und Kopf sinken lassen, dann Brust nach vorn, Blick nach vorn
CAT = stand(QUAD, spine=(28.0, 0.0, 0.0), neck=(25.0, 0.0, 0.0), body=(0.0, 92.0, 0.0), root=(0.0, 0.56, -0.24))
COW = stand(QUAD, spine=(-16.0, 0.0, 0.0), neck=(-20.0, 0.0, 0.0), body=(0.0, 87.0, 0.0), root=(0.0, 0.53, -0.21))
clip("catCow", "Katze-Kuh", 5.0, [(0.0, QUAD), (0.4, QUAD), (1.7, CAT), (2.3, CAT), (3.9, COW), (4.5, COW)],
     **MAT_KW)

# Handgelenke: im Vierfüßlerstand vor und zurück schaukeln, Hände flach am Boden
ROCK_FWD = stand(QUAD, root=(0.0, 0.52, -0.08), body=(0.0, 80.0, 0.0))
ROCK_BACK = stand(QUAD, root=(0.0, 0.50, -0.34), body=(0.0, 95.0, 0.0))
clip("wristRock", "Handgelenke schaukeln", 6.0, [(0.0, QUAD), (1.4, ROCK_FWD), (2.2, ROCK_FWD), (3.6, QUAD),
                                                 (4.6, ROCK_BACK), (5.4, ROCK_BACK)], **MAT_KW)

# Kindhaltung: aus dem Kniestand auf die Fersen setzen, Arme lang nach vorn, Stirn Richtung Boden
CHILD = stand(QUAD, hands(0.18, FLOOR, 0.42, **HANDS_FLAT), {"elbowL": (1.0, 0.5, 0.0), "elbowR": (-1.0, 0.5, 0.0)},
              root=(0.0, 0.25, -0.50), body=(0.0, 80.0, 0.0), spine=(28.0, 0.0, 0.0), neck=(10.0, 0.0, 0.0))
clip("childPose", "Kindhaltung", 8.0, [(0.0, QUAD), (1.0, QUAD), (2.8, CHILD),
                                       (6.4, stand(CHILD, spine=(22.0, 0.0, 0.0)))],
     **dict(MAT_KW, cam_y=0.4))

# Kobra: Bauchlage, Hände neben der Brust, Oberkörper aufrichten, Becken bleibt am Boden
COBRA_DOWN = stand(PRONE, hands(0.26, FLOOR, 0.12, **HANDS_FLAT),
                   {"elbowL": (0.4, 1.0, -0.6), "elbowR": (-0.4, 1.0, -0.6)})
COBRA_UP = stand(COBRA_DOWN, hands(0.24, FLOOR, 0.24, **HANDS_FLAT), root=(0.0, 0.19, -0.02), body=(0.0, 82.0, 0.0),
                 spine=(-48.0, 0.0, 0.0), neck=(-18.0, 0.0, 0.0), elbowL=(0.3, 0.2, -1.0), elbowR=(-0.3, 0.2, -1.0))
clip("cobra", "Kobra", 7.0, [(0.0, COBRA_DOWN), (1.0, COBRA_DOWN), (2.8, COBRA_UP), (5.2, COBRA_UP)],
     **dict(MAT_KW, cam_y=0.3))

# Herabschauender Hund: aus dem Vierfüßlerstand Zehen aufstellen, Knie heben, Hüfte hoch, Fersen Richtung Boden
TUCK = stand(QUAD_FWD, on_toes(), feet(0.11, 0.10, -0.60))
DOG = stand(TUCK, flat_feet(0.0), feet(0.12, ANKLE, -0.62), {"kneeL": (0.1, 0.0, 1.0), "kneeR": (-0.1, 0.0, 1.0)},
            {"elbowL": (1.0, 0.3, 0.0), "elbowR": (-1.0, 0.3, 0.0)}, root=(0.0, 0.84, -0.20), body=(0.0, 128.0, 0.0),
            spine=(-8.0, 0.0, 0.0), neck=(5.0, 0.0, 0.0), soleL=(1.0, 0.0, 0.0), soleR=(1.0, 0.0, 0.0))
DOG_LIFT = stand(TUCK, {"kneeL": (0.1, -0.3, 1.0), "kneeR": (-0.1, -0.3, 1.0)}, root=(0.0, 0.70, -0.20),
                 body=(0.0, 110.0, 0.0))
clip("downDog", "Herabschauender Hund", 8.0, [(0.0, QUAD_FWD), (0.6, TUCK), (1.4, DOG_LIFT), (2.4, DOG), (5.6, DOG),
                                              (6.6, DOG_LIFT), (7.4, TUCK)], **MAT_KW)

# Brustwirbelsäule drehen: Vierfüßlerstand, linke Hand am Hinterkopf, Ellbogen zur rechten Hand und dann zur Decke
BWS_SPACE = {"handL": "head", "handR": "world"}
BWS = stand(QUAD, {"handL": (0.13, 0.03, -0.16), "elbowL": (1.0, 0.0, 0.3), "gripL": 0.1, "palmL": (0.0, 0.0)})
BWS_DOWN = stand(BWS, spine=(10.0, 0.0, -32.0), neck=(10.0, 0.0, -15.0), turn=-8.0)
BWS_UP = stand(BWS, spine=(-4.0, 0.0, 50.0), neck=(-6.0, 0.0, 30.0), turn=18.0)
clip("bwsRotate", "Rotation der Brustwirbelsäule", 12.0,
     [(0.0, QUAD), (0.5, BWS), (1.5, BWS_DOWN), (2.3, BWS_UP), (3.1, BWS_UP), (4.0, BWS_DOWN), (4.8, BWS_UP),
      (5.4, BWS)], space=BWS_SPACE, free=True, yaw=0.9, cam_y=0.5, mirror_half=True)


# =========================================================================== Ausfallschritte ohne Rutschen

# Aus dem Stand macht nur das hintere (rechte) Bein einen Schritt nach hinten; der vordere Fuß bleibt stehen.
# step_lift hebt den Fuß im Bogen, statt ihn über den Boden zu schieben. Rechts entsteht gespiegelt.
from .library import sides  # noqa: E402

UPRIGHT = stand(arms(hang(0.21, 0.53, 0.0), (0.4, -0.2, -1.0), grip=0.15))
ARMS_HIGH = arms((0.14, 0.62, 0.04), (1.0, 0.0, 0.0), grip=0.05)
LUNGE_KW = dict(mirror_half=True, step_lift=0.10, free=False, yaw=0.9, cam_y=0.8)


def _shoulder(pose: dict, side: str, space=None):
    """Weltlage der Schulter in einer Haltung (zum Ausrichten von Händen in der Welt)."""
    from .pose import Rig
    rig = _shoulder.rig = getattr(_shoulder, "rig", None) or Rig()
    _, _, wp = rig.solve(rig.fit_root(pose, space), space)
    return wp[rig.sk.i(f"ua{side}")]


# Hüftbeuger-Dehnung im Kniestand: rechts nach hinten absetzen, Knie ab, Becken nach vorn, Arme hoch
_HIP_HALF = stand(UPRIGHT, footR=(-0.13, ANKLE + 0.02, -0.55), kneeR=(-0.1, -0.4, 1.0), soleR=(1.0, -6.0, 30.0),
                  root=(0.0, 0.78, -0.22), body=(0.0, 8.0, 0.0))
_HIP_KNEEL = stand(UPRIGHT, footR=(-0.13, 0.08, -1.02), kneeR=(-0.1, -1.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleR=75.0,
                   kneeL=(0.1, 0.0, 1.0), root=(0.0, 0.52, -0.42), body=(0.0, 0.0, 0.0))
_HIP_PUSH = stand(_HIP_KNEEL, ARMS_HIGH, root=(0.0, 0.48, -0.36), body=(0.0, -6.0, 0.0), spine=(-6.0, 0.0, 0.0))
clip("hipStretch", "Hüftbeuger-Dehnung im Kniestand", 14.0,
     sides(UPRIGHT, _HIP_PUSH, half=7.0, move=0.30, hold=0.46, via=_HIP_KNEEL, back=_HIP_HALF),
     **dict(LUNGE_KW, step_lift=0.16))

# Krieger I: rechter Fuß weit nach hinten, schräg gestellt, vorderes Knie über dem Fuß, Arme über dem Kopf
_W1 = stand(ARMS_HIGH, footR=(-0.16, ANKLE, -1.08), soleR=(1.0, -45.0, 0.0), kneeR=(-0.4, 0.0, 1.0),
            kneeL=(0.1, 0.0, 1.0), root=(0.0, 0.72, -0.48), body=(8.0, 0.0, 0.0), spine=(-8.0, 0.0, 0.0),
            neck=(-8.0, 0.0, 0.0))
_W1_STEP = stand(UPRIGHT, footR=(-0.16, ANKLE, -1.08), soleR=(1.0, -45.0, 0.0), kneeR=(-0.4, 0.0, 1.0),
                 root=(0.0, 0.84, -0.50))
clip("warrior1", "Yoga: Krieger I", 14.0,
     sides(UPRIGHT, _W1, half=7.0, move=0.30, hold=0.46, via=_W1_STEP, back=_W1_STEP), **LUNGE_KW)

# Krieger II: linker Fuß weit zur Seite und nach außen gedreht, Knie gebeugt, Arme waagerecht, Blick über die Hand
_W2 = stand(arms((0.78, 0.06, 0.0), (0.0, -1.0, 0.0), grip=0.05), footL=(0.66, ANKLE, 0.0),
            footR=(-0.12, ANKLE, 0.0), soleL=(1.0, 85.0, 0.0), soleR=(1.0, 10.0, 0.0), kneeL=(1.0, 0.0, 0.25),
            kneeR=(-0.3, 0.0, 1.0), root=(0.26, 0.76, 0.0), neck=(0.0, 0.0, 70.0))
_W2_STEP = stand(UPRIGHT, footL=(0.66, ANKLE, 0.0), soleL=(1.0, 85.0, 0.0), kneeL=(1.0, 0.0, 0.25),
                 root=(0.26, 0.88, 0.0))
clip("warrior2", "Yoga: Krieger II", 10.0,
     sides(UPRIGHT, _W2, half=5.0, move=0.30, hold=0.46, via=_W2_STEP, back=_W2_STEP),
     **dict(LUNGE_KW, free=True, yaw=0.15, cam_y=0.85))

# World's Greatest Stretch: tiefer Ausfallschritt, rechte Hand neben dem linken Fuß am Boden, linker Ellbogen zum
# Fußinnenrist, dann den linken Arm zur Decke drehen
WGS_SPACE = {"handL": "world", "handR": "world"}
_WGS_LUNGE = stand(footR=(-0.15, 0.17, -1.20), soleR=(0.0, 0.0, 0.0), ankleR=-5.0, toesR=70.0, kneeR=(-0.1, -1.0, 0.2),
                   kneeL=(0.25, 0.0, 1.0), footL=(0.14, ANKLE, 0.0), soleL=(1.0, 6.0, 0.0),
                   root=(0.0, 0.50, -0.44), body=(0.0, 60.0, 0.0), spine=(15.0, 0.0, 0.0), neck=(-15.0, 0.0, 0.0))
_WGS_LUNGE.update({"handR": (-0.04, FLOOR, 0.10), "palmR": (1.0, 0.0), "elbowR": (-1.0, 0.0, -0.5), "gripR": 0.05,
                   "handL": (0.10, 0.35, 0.05), "elbowL": (1.0, -0.5, 0.0), "gripL": 0.2, "palmL": (0.0, 0.0)})
_WGS_ELBOW = stand(_WGS_LUNGE, handL=(0.05, 0.25, 0.12), spine=(25.0, 0.0, -10.0))
_WGS_OPEN = stand(_WGS_LUNGE, spine=(5.0, 0.0, 45.0), turn=20.0, neck=(-10.0, 0.0, 40.0), gripL=0.05)
_WGS_OPEN["handL"] = tuple(float(v) for v in _shoulder(_WGS_OPEN, "L", WGS_SPACE) + [0.10, 0.52, -0.05])
_WGS_STAND = stand(UPRIGHT)
_WGS_STAND.update({k: tuple(float(v) for v in _shoulder(_WGS_STAND, s) + [g * 0.01, -0.53, 0.04])
                   for k, s, g in (("handL", "L", 1), ("handR", "R", -1))})
_WGS_STAND.update({"palmL": (0.0, 0.0), "palmR": (0.0, 0.0)})
_WGS_STEP = stand(_WGS_STAND, footR=(-0.15, 0.17, -1.20), soleR=(0.0, 0.0, 0.0), toesR=70.0, kneeR=(-0.1, -1.0, 0.2),
                  root=(0.0, 0.70, -0.45), body=(0.0, 25.0, 0.0))
_WGS_STEP.update({k: tuple(float(v) for v in _shoulder(_WGS_STEP, s, WGS_SPACE) + [g * 0.02, -0.50, 0.12])
                  for k, s, g in (("handL", "L", 1), ("handR", "R", -1))})
clip("wgs", "World's Greatest Stretch", 15.0,
     sides(_WGS_STAND, _WGS_ELBOW, half=7.5, move=0.26, hold=0.52, via=_WGS_STEP, back=_WGS_STEP,
           extra=[(0.30, _WGS_LUNGE), (0.55, _WGS_OPEN), (0.80, _WGS_OPEN)]),
     space=WGS_SPACE, **LUNGE_KW)


# =========================================================================== Rückenlage

from .library import SUPINE  # noqa: E402

# Liegende Drehung: Arme seitlich am Boden, Knie fallen zur Seite, Blick zur anderen Seite, Schultern bleiben liegen
_T_ARMS = {"handL": (0.70, 0.05, -0.44), "handR": (-0.70, 0.05, -0.44), "palmL": (1.0, 90.0), "palmR": (1.0, -90.0),
           "elbowL": (0.0, 1.0, -0.3), "elbowR": (0.0, 1.0, -0.3), "gripL": 0.05, "gripR": 0.05}
TWIST_BASE = stand(HOOK, _T_ARMS)
TWIST_LEFT = stand(TWIST_BASE, feet(0.0, 0.10, 0.40), footL=(0.34, 0.08, 0.36), footR=(0.20, 0.20, 0.40),
                   kneeL=(1.0, 0.2, 0.3), kneeR=(1.0, 0.4, 0.3), turn=45.0, spine=(0.0, 0.0, -40.0),
                   neck=(0.0, 0.0, -45.0), soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=20.0, ankleR=20.0)
clip("supTwist", "Liegende Drehung", 10.0, sides(TWIST_BASE, TWIST_LEFT, half=5.0, move=0.30, hold=0.50),
     space=WORLD_HANDS, mirror_half=True, free=True, yaw=0.25, cam_y=0.5)

# Dead Bug: Arme zur Decke, Hüfte und Knie 90°, gegengleich Arm über den Kopf und Bein lang, Rücken bleibt am Boden
_TABLE = {"footL": (0.11, 0.50, 0.42), "footR": (-0.11, 0.50, 0.42),
          "kneeL": (0.1, 1.0, 0.2), "kneeR": (-0.1, 1.0, 0.2),
          "soleL": (0.0, 0.0, 0.0), "soleR": (0.0, 0.0, 0.0), "ankleL": 10.0, "ankleR": 10.0}
BUG = stand(SUPINE, _TABLE, arms((0.18, 0.05, 0.50), (1.0, -0.2, 0.0), grip=0.1))
BUG_REACH = stand(BUG, handL=(0.18, 0.56, 0.02), elbowL=(1.0, 0.0, 0.3), footR=(-0.11, 0.18, 0.86),
                  kneeR=(-0.1, 1.0, 0.0), ankleR=20.0)
clip("deadBug", "Dead Bug", 8.0, [(0.0, BUG), (0.4, BUG), (1.6, BUG_REACH), (2.4, BUG_REACH), (3.6, BUG)],
     mirror_half=True, free=True, yaw=1.2, cam_y=0.4)

# Roll-up: aus der Rückenlage mit Armen über dem Kopf Wirbel für Wirbel aufrollen bis zu den Zehen, dann zurück
ROLL_FLAT = stand(SUPINE, arms((0.17, 0.56, 0.02), (1.0, 0.0, 0.3), grip=0.05), ankleL=-10.0, ankleR=-10.0)
ROLL_ARMS = stand(ROLL_FLAT, arms((0.17, 0.10, 0.52), (1.0, -0.2, 0.0), grip=0.05), neck=(25.0, 0.0, 0.0))
ROLL_MID = stand(ROLL_ARMS, body=(0.0, -55.0, 0.0), spine=(45.0, 0.0, 0.0),
                 neck=(25.0, 0.0, 0.0), root=(0.0, 0.12, 0.0))
ROLL_FOLD = stand(ROLL_ARMS, arms((0.15, 0.02, 0.56), (1.0, 0.0, 0.0), grip=0.05), body=(0.0, 2.0, 0.0),
                  spine=(42.0, 0.0, 0.0), neck=(22.0, 0.0, 0.0), root=(0.0, 0.13, 0.0))
clip("rollUp", "Roll-up", 7.0, [(0.0, ROLL_FLAT), (0.6, ROLL_FLAT), (1.4, ROLL_ARMS), (2.3, ROLL_MID), (3.2, ROLL_FOLD),
                                (4.0, ROLL_FOLD), (5.0, ROLL_MID), (6.0, ROLL_ARMS)],
     free=True, yaw=1.2, cam_y=0.5)
