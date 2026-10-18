"""Dehnungen im Stand und Übungen am Boden, die vorher nur als fertige Daten in der App lagen.

Neu beschrieben mit lockerem Stand (leicht gebeugte Knie, hängende Arme) und Atmung über Clip.alive, damit die Figur
auch in Haltephasen lebendig bleibt. Einseitige Dehnungen beschreiben die linke Seite, die rechte entsteht
gespiegelt (mirror_half).
"""

from __future__ import annotations

from .library import ANKLE, WORLD_HANDS, clip, feet, flat_feet, hands, reps, sides, stand
from .lib_kraft import STAND_KW, arms, hang
from .lib_stehen import HIP, UP


def chest(x, y, z) -> tuple:
    """Weltpunkt (aufrechter Stand) im Raum des Brustkorbs, für Hände an Bein oder Fuß im Stand."""
    return (x, y - 1.36, z + 0.03)


# =========================================================================== Nacken und Schultern

# Kinn zurückziehen (Doppelkinn): Kopf gleitet nach hinten, Blick bleibt geradeaus
TUCK = stand(UP, neck=(9.0, 0.0, 0.0), spine=(-3.0, 0.0, 0.0))
clip("chinTuck", "Kinn zurückziehen", 4.0, reps(UP, TUCK, 4.0, n=1, rest=0.15, up=0.30),
     **dict(STAND_KW, yaw=1.2, cam_y=1.45))

# Nacken seitlich: Ohr zur Schulter, die Schultern bleiben unten
TILT_L = stand(UP, neck=(4.0, 30.0, 0.0), clavL=(-6.0, 0.0), clavR=(-8.0, 0.0))
clip("neckTilt", "Nacken seitlich dehnen", 6.0, [(0.0, UP), (0.4, UP), (1.3, TILT_L), (2.2, TILT_L), (2.8, UP)],
     mirror_half=True, **STAND_KW)

# Brustöffner: Arme im W nach hinten ziehen, Schulterblätter zusammen, Brust hebt sich
W_OPEN = stand(UP, arms((0.46, 0.20, -0.06), (1.0, -1.0, -0.4), grip=0.2, twist=40.0), spine=(-8.0, 0.0, 0.0),
               neck=(-6.0, 0.0, 0.0), clavL=(0.0, -10.0), clavR=(0.0, -10.0))
W_FRONT = stand(UP, arms((0.30, 0.20, 0.25), (1.0, -1.0, 0.0), grip=0.2, twist=40.0), spine=(4.0, 0.0, 0.0))
clip("chestStretch", "Brustdehnung", 5.0, [(0.0, UP), (0.5, W_FRONT), (1.6, W_OPEN), (3.4, W_OPEN), (4.3, W_FRONT)],
     **STAND_KW)

# Arm quer vor der Brust: rechte Hand zieht den linken Oberarm heran
CROSS_L = stand(UP, handL=(-0.30, 0.02, 0.24), elbowL=(0.0, -0.4, 1.0), twistL=-40.0, gripL=0.2,
                handR=(0.02, -0.01, 0.30), elbowR=(-1.0, -0.6, 0.0), gripR=0.6, turn=-8.0, neck=(0.0, 0.0, 10.0))
clip("crossBody", "Arm vor der Brust dehnen", 5.0, [(0.0, UP), (0.3, UP), (1.1, CROSS_L), (1.9, CROSS_L), (2.35, UP)],
     mirror_half=True, **STAND_KW)

# Trizepsdehnung über Kopf: linke Hand zwischen die Schulterblätter, rechte Hand drückt den Ellbogen
TRI_L = stand(UP, handL=(0.02, 0.22, -0.15), elbowL=(0.2, 1.0, 0.2), gripL=0.2, twistL=-20.0,
              handR=(0.10, 0.52, 0.02), elbowR=(-1.0, 0.2, 0.3), gripR=0.4, neck=(6.0, -6.0, 0.0))
clip("tricepStretch", "Trizeps über Kopf dehnen", 10.0, sides(UP, TRI_L, half=5.0), mirror_half=True,
     **dict(STAND_KW, yaw=0.35))

# Seitbeuge: linker Arm über den Kopf, der Oberkörper neigt sich nach rechts
SIDE_L = stand(HIP, handL=(0.05, 0.62, 0.02), elbowL=(1.0, 0.3, 0.0), gripL=0.1, handR=(-0.34, -0.40, 0.14),
               body=(0.0, 0.0, -5.0), root=(0.04, 0.96, 0.0), spine=(0.0, -28.0, 0.0), neck=(0.0, -8.0, 0.0),
               footL=(0.14, ANKLE, 0.0), footR=(-0.14, ANKLE, 0.0))
clip("sideBend", "Seitbeuge im Stand", 10.0, sides(UP, SIDE_L, half=5.0), mirror_half=True,
     **dict(STAND_KW, yaw=0.35))

# Schulterkreisen mit Stab: gestreckte Arme weit gefasst von vorn über den Kopf nach hinten und zurück
STAB = dict(gripL=0.9, gripR=0.9, twistL=-50.0, twistR=-50.0)
STAB_FRONT = stand(UP, STAB, arms((0.52, -0.40, 0.28), (1.0, 0.0, -0.3), grip=0.9, twist=-50.0))
STAB_UP = stand(UP, STAB, arms((0.55, 0.50, 0.12), (1.0, 0.0, 0.0), grip=0.9, twist=-50.0), neck=(-4.0, 0.0, 0.0))
STAB_BACK = stand(UP, STAB, arms((0.55, -0.28, -0.32), (1.0, 0.0, 0.3), grip=0.9, twist=-50.0),
                  body=(0.0, 6.0, 0.0), spine=(-4.0, 0.0, 0.0))
clip("stabDislocate", "Schulterkreisen mit Stab", 7.0,
     [(0.0, STAB_FRONT), (0.6, STAB_FRONT), (1.9, STAB_UP), (3.0, STAB_BACK), (3.8, STAB_BACK), (5.0, STAB_UP)],
     **dict(STAND_KW, yaw=0.5, cam_y=1.0))

# Wall Slides: Rücken und Unterarme an der Wand (hinten), Arme gleiten im W nach oben und zurück
WALL_BACK = -0.125
_WS = dict(root=(0.0, 0.96, WALL_BACK + 0.15), footL=(0.12, ANKLE, WALL_BACK + 0.22),
           footR=(-0.12, ANKLE, WALL_BACK + 0.22), neck=(4.0, 0.0, 0.0))
WS_LOW = stand(UP, _WS, hands(0.42, 1.25, WALL_BACK + 0.04), elbowL=(1.0, -1.0, -0.3), elbowR=(-1.0, -1.0, -0.3),
               twistL=60.0, twistR=60.0, gripL=0.1, gripR=0.1)
WS_HIGH = stand(WS_LOW, hands(0.30, 1.78, WALL_BACK + 0.04), elbowL=(1.0, -0.2, -0.3), elbowR=(-1.0, -0.2, -0.3))
clip("wallSlide", "Wall Slides", 5.0, reps(WS_LOW, WS_HIGH, 5.0, n=1, rest=0.12, up=0.40), space=WORLD_HANDS,
     wall_z=WALL_BACK, **dict(STAND_KW, yaw=1.15, cam_y=0.95))


# =========================================================================== Beine im Stand

# Oberschenkel vorn: linke Ferse zum Gesäß, die linke Hand hält den Fuß, rechter Arm zur Seite
QUAD_L = stand(UP, footL=(0.10, 0.62, -0.26), kneeL=(0.05, -1.0, 0.1), soleL=(0.0, 0.0, 0.0), ankleL=45.0,
               handL=chest(0.12, 0.66, -0.31), elbowL=(0.3, 0.0, -1.0), gripL=0.8, twistL=-30.0,
               handR=chest(-0.42, 1.10, 0.20), elbowR=(-1.0, -0.4, -0.2), root=(-0.03, 0.96, 0.0))
clip("quadStretch", "Oberschenkel vorn dehnen", 5.0,
     [(0.0, UP), (0.3, UP), (1.0, QUAD_L), (1.9, QUAD_L), (2.35, UP)],
     mirror_half=True, **STAND_KW)

# Knie zur Brust: linkes Knie mit beiden Händen an die Brust ziehen
HUG_L = stand(UP, footL=(0.08, 0.50, 0.12), kneeL=(0.1, 1.0, 1.0), soleL=(0.0, 0.0, 0.0), ankleL=10.0,
              handL=chest(0.17, 0.76, 0.34), handR=chest(0.00, 0.76, 0.36), elbowL=(1.0, -0.6, 0.0),
              elbowR=(-1.0, -0.6, 0.0),
              gripL=0.7, gripR=0.7, root=(-0.03, 0.96, 0.0))
clip("kneeHug", "Knie zur Brust", 4.0, [(0.0, UP), (0.2, UP), (0.8, HUG_L), (1.5, HUG_L), (1.9, UP)],
     mirror_half=True, **STAND_KW)

# Vorbeuge: Knie weich, Oberkörper hängt locker nach vorn, Hände Richtung Boden
FOLD_DOWN = stand(UP, arms(hang(0.15, 0.50, 118.0), (1.0, 0.0, -0.3), grip=0.2, twist=-30.0), root=(0.0, 0.92, -0.18),
                  body=(0.0, 88.0, 0.0), spine=(30.0, 0.0, 0.0), neck=(18.0, 0.0, 0.0), kneeL=(0.15, 0.0, 1.0),
                  kneeR=(-0.15, 0.0, 1.0))
FOLD_DEEP = stand(FOLD_DOWN, arms(hang(0.15, 0.50, 130.0), (1.0, 0.0, -0.3), grip=0.2, twist=-30.0),
                  spine=(36.0, 0.0, 0.0), body=(0.0, 94.0, 0.0))
clip("forwardFold", "Vorbeuge im Stand", 6.0, [(0.0, UP), (0.4, UP), (2.0, FOLD_DOWN), (3.0, FOLD_DEEP),
                                               (4.0, FOLD_DOWN), (5.4, UP)], **STAND_KW)

# Waden an der Wand: Hände an der Wand, linkes Bein hinten gestreckt, Ferse bleibt am Boden
WALL_FRONT = 0.64
CW_BASE = stand(UP, hands(0.22, 1.32, WALL_FRONT - 0.04), elbowL=(1.0, -1.0, -0.5), elbowR=(-1.0, -1.0, -0.5),
                palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.05, gripR=0.05, root=(0.0, 0.96, 0.10),
                footL=(0.12, ANKLE, 0.22), footR=(-0.12, ANKLE, 0.22))
CW_L = stand(CW_BASE, footL=(0.12, ANKLE, -0.48), kneeL=(0.1, 0.0, 1.0), soleL=(1.0, 4.0, 0.0),
             footR=(-0.12, ANKLE, 0.28), kneeR=(-0.1, 0.0, 1.0), root=(0.0, 0.88, 0.02), body=(0.0, 18.0, 0.0))
clip("calfWall", "Waden an der Wand dehnen", 8.0, sides(CW_BASE, CW_L, half=4.0), space=WORLD_HANDS,
     mirror_half=True, step_lift=0.10, wall_z=WALL_FRONT, **dict(STAND_KW, yaw=1.15))

# Knie zur Wand: linker Fuß vor, das Knie schiebt sich über die Zehen zur Wand, die Ferse bleibt unten
KW_BASE = stand(CW_BASE, footL=(0.12, ANKLE, 0.42), footR=(-0.12, ANKLE, -0.10), kneeL=(0.1, 0.0, 1.0),
                root=(0.0, 0.90, 0.10))
KW_IN = stand(KW_BASE, root=(0.0, 0.80, 0.24), kneeL=(0.05, -0.1, 1.0), body=(0.0, 6.0, 0.0),
              footR=(-0.12, ANKLE, -0.10), soleR=(0.0, 0.0, 0.0), ankleR=-15.0, toesR=35.0)
KW_STEP1 = stand(CW_BASE, footL=(0.12, ANKLE, 0.42), root=(0.0, 0.94, 0.16))
KW_STEP2 = stand(KW_BASE, footR=(-0.12, ANKLE, 0.22), root=(0.0, 0.94, 0.16))
clip("kneeWall", "Knie zur Wand", 5.0, [(0.0, CW_BASE), (0.35, KW_STEP1), (0.7, KW_BASE), (1.3, KW_IN), (1.7, KW_IN),
                                        (2.0, KW_BASE), (2.25, KW_STEP2)],
     space=WORLD_HANDS, mirror_half=True, step_lift=0.10, wall_z=WALL_FRONT, **dict(STAND_KW, yaw=1.15))


# =========================================================================== Yoga im Stand

# Baum: auf dem rechten Bein, linke Fußsohle innen am rechten Oberschenkel, Hände vor der Brust, dann nach oben
TREE_FOOT = dict(footL=(-0.02, 0.50, 0.04), kneeL=(1.0, 0.0, 0.3), soleL=(0.0, 0.0, 0.0), ankleL=10.0,
                 footR=(-0.06, ANKLE, 0.0), root=(-0.06, 0.96, 0.0))
TREE_PRAY = stand(UP, TREE_FOOT, arms((0.04, -0.10, 0.25), (1.0, -1.0, 0.0), grip=0.0, twist=-60.0))
TREE_UP = stand(TREE_PRAY, arms((0.10, 0.62, 0.05), (1.0, 0.2, 0.0), grip=0.0, twist=-60.0))
clip("tree", "Yoga: Baum", 14.0, [(0.0, UP), (0.6, UP), (1.8, TREE_PRAY), (3.0, TREE_PRAY), (4.2, TREE_UP),
                                  (5.6, TREE_UP), (6.4, TREE_PRAY)],
     mirror_half=True, **dict(STAND_KW, free=True, yaw=0.35, cam_y=0.85))

# Stuhl: Gesäß nach hinten unten wie auf einen Stuhl, Arme gestreckt nach oben neben den Ohren
CHAIR_IN = stand(UP, feet(0.10, ANKLE, 0.0), flat_feet(4.0), arms((0.17, 0.10, 0.50), (1.0, -0.2, 0.0), grip=0.05))
CHAIR = stand(CHAIR_IN, arms((0.15, 0.58, 0.12), (1.0, 0.0, 0.0), grip=0.05, twist=-40.0), root=(0.0, 0.66, -0.20),
              body=(0.0, 28.0, 0.0), spine=(4.0, 0.0, 0.0), neck=(-10.0, 0.0, 0.0), kneeL=(0.1, 0.0, 1.0),
              kneeR=(-0.1, 0.0, 1.0))
clip("chair", "Yoga: Stuhl", 7.0, [(0.0, UP), (0.5, UP), (1.4, CHAIR_IN), (2.4, CHAIR), (4.8, CHAIR), (6.0, CHAIR_IN)],
     **STAND_KW)


# =========================================================================== Am Boden

from .library import HOOK, KNEEL, WORLD_HANDS as FLOOR_HANDS  # noqa: E402

# Crunch: Rückenlage mit aufgestellten Füßen, Fingerspitzen an den Schläfen, Schultern heben sich vom Boden
CR_FLAT = stand(HOOK, handL=(0.13, -0.02, -0.03), handR=(-0.13, -0.02, -0.03), elbowL=(1.0, 0.2, 0.2),
                elbowR=(-1.0, 0.2, 0.2), gripL=0.2, gripR=0.2, palmL=(0.0, 0.0), palmR=(0.0, 0.0), twistL=-60.0,
                twistR=-60.0, neck=(6.0, 0.0, 0.0))
CR_UP = stand(CR_FLAT, spine=(34.0, 0.0, 0.0), neck=(14.0, 0.0, 0.0))
clip("crunch", "Crunch", 3.2, reps(CR_FLAT, CR_UP, 3.2, n=1, rest=0.15, up=0.35),
     space={"handL": "head", "handR": "head"}, lying=True, free=False, yaw=1.2, cam_y=0.5)

# Fersensitz: auf den Fersen sitzen, Hände ruhen auf den Oberschenkeln, ruhig atmen
HEEL = stand(KNEEL, hands(0.15, 0.30, -0.02), feet(0.10, 0.06, -0.30), root=(0.0, 0.27, -0.27), elbowL=(0.3, 0.0, -1.0),
             elbowR=(-0.3, 0.0, -1.0), palmL=(0.8, 0.0), palmR=(0.8, 0.0), gripL=0.2, gripR=0.2,
             spine=(-2.0, 0.0, 0.0), neck=(-4.0, 0.0, 0.0))
HEEL_B = stand(HEEL, spine=(2.0, 0.0, 0.0), neck=(4.0, 0.0, 0.0))
clip("heelSit", "Fersensitz", 6.0, [(0.0, HEEL), (3.0, HEEL_B)], space=FLOOR_HANDS, alive=1.5,
     **dict(STAND_KW, free=True, yaw=0.9, cam_y=0.6))

# Kamel: aus dem aufrechten Kniestand Hüfte nach vorn, Brust öffnet sich, Hände greifen die Fersen
CAMEL_UP = stand(KNEEL, hands(0.20, 0.40, 0.06), elbowL=(0.3, 0.0, -1.0), elbowR=(-0.3, 0.0, -1.0), gripL=0.2,
                 gripR=0.2, root=(0.0, 0.53, 0.0))
CAMEL = stand(CAMEL_UP, hands(0.13, 0.16, -0.44), elbowL=(1.0, 0.0, 0.3), elbowR=(-1.0, 0.0, 0.3),
              palmL=(0.0, 0.0), palmR=(0.0, 0.0), root=(0.0, 0.52, 0.06), body=(0.0, -18.0, 0.0),
              spine=(-42.0, 0.0, 0.0), neck=(-35.0, 0.0, 0.0))
CAMEL_HALF = stand(CAMEL_UP, hands(0.14, 0.42, -0.12), root=(0.0, 0.53, 0.04), body=(0.0, -10.0, 0.0),
                   spine=(-18.0, 0.0, 0.0), neck=(-10.0, 0.0, 0.0))
clip("camel", "Yoga: Kamel", 8.0, [(0.0, CAMEL_UP), (0.8, CAMEL_UP), (2.0, CAMEL_HALF), (3.0, CAMEL), (5.4, CAMEL),
                                   (6.4, CAMEL_HALF)],
     space=FLOOR_HANDS, **dict(STAND_KW, free=True, yaw=1.2, cam_y=0.6))

# Cossack Squat: breiter Stand, das Gewicht sinkt tief auf das linke Bein, das rechte bleibt gestreckt mit den Zehen
# nach oben; Hände vor der Brust gefaltet
WIDE = {"footL": (0.42, ANKLE, 0.0), "footR": (-0.42, ANKLE, 0.0), "kneeL": (0.6, 0.0, 1.0),
        "kneeR": (-0.6, 0.0, 1.0), **flat_feet(30.0)}
COSS_HANDS = arms((0.04, -0.12, 0.30), (1.0, -1.0, 0.0), grip=0.5, twist=-30.0)
COSS_UP = stand(UP, WIDE, COSS_HANDS)
COSS_L = stand(COSS_UP, root=(0.28, 0.50, -0.12), body=(-10.0, 30.0, 6.0), spine=(-4.0, 0.0, 0.0),
               neck=(-20.0, 0.0, 0.0), kneeL=(0.7, 0.0, 1.0), kneeR=(-0.3, 1.0, 0.3), soleR=(0.0, 0.0, 0.0),
               ankleR=-25.0, footR=(-0.45, ANKLE + 0.02, 0.0))
clip("cossack", "Cossack Squat", 10.0, [(0.0, COSS_UP), (0.6, COSS_UP), (2.0, COSS_L), (3.2, COSS_L), (4.5, COSS_UP)],
     mirror_half=True, **dict(STAND_KW, free=True, yaw=0.2, cam_y=0.8))
