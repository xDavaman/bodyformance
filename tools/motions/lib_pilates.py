"""Pilates-Matte und Sitzhaltungen: Teaser, Single/Double Leg Stretch, Swimming, sitzende Vorbeuge, Drehsitz.

Diese sechs Bewegungen stammten noch aus der ersten Version (ohne Bibliothek) und sanken in den Boden oder hatten
falsch herum gebeugte Knie. Hier sind sie mit Zielen für Hände und Füße neu beschrieben.
"""

from __future__ import annotations

from .library import (ANKLE, FLOOR, FLOOR_SPACE, HANDS_FLAT, KNEES_DOWN, KNEES_UP, PRONE, SEATED, SUPINE, clip,
                      foot_tops, reps, sides, stand)

# Kopf und Schultern eingerollt, Blick zum Bauch (Grundhaltung der Pilates-Bauchserie)
CURL = dict(spine=(32.0, 0.0, 0.0), neck=(14.0, 0.0, 0.0))
STRAIGHT_LEGS = {"kneeL": (0.1, 1.0, 0.0), "kneeR": (-0.1, 1.0, 0.0)}
POINTED = dict(soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=40.0, ankleR=40.0)

# Single Leg Stretch: linkes Knie zur Brust, Hände am Schienbein, rechtes Bein lang und flach über dem Boden
_sls = stand(SUPINE, CURL, POINTED,
             footL=(0.10, 0.40, 0.30), kneeL=(0.1, 1.0, -0.6),
             footR=(-0.10, 0.34, 0.84), kneeR=(-0.1, 1.0, 0.0),
             handL=(0.15, 0.44, 0.26), handR=(0.03, 0.47, 0.10), elbowL=(1.0, 0.2, -0.3), elbowR=(-1.0, 0.2, -0.3),
             palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.5, gripR=0.5)
clip("singleLegStretch", "Pilates: Single Leg Stretch", 4.0, [(0.0, _sls), (0.7, _sls)], space=FLOOR_SPACE,
     mirror_half=True, lying=True, free=False, yaw=1.2, cam_y=0.4)

# Double Leg Stretch: beide Knie zur Brust, dann Arme über den Kopf und Beine schräg nach vorn strecken
_dls_in = stand(SUPINE, CURL, POINTED,
                footL=(0.10, 0.42, 0.30), footR=(-0.10, 0.42, 0.30), kneeL=(0.15, 1.0, -0.6), kneeR=(-0.15, 1.0, -0.6),
                handL=(0.15, 0.46, 0.24), handR=(-0.15, 0.46, 0.24), elbowL=(1.0, 0.2, -0.3), elbowR=(-1.0, 0.2, -0.3),
                palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.5, gripR=0.5)
_dls_out = stand(_dls_in, STRAIGHT_LEGS, footL=(0.08, 0.50, 0.80), footR=(-0.08, 0.50, 0.80),
                 handL=(0.16, 0.50, -0.62), handR=(-0.16, 0.50, -0.62), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
                 gripL=0.1, gripR=0.1)
clip("doubleLegStretch", "Pilates: Double Leg Stretch", 4.0, reps(_dls_in, _dls_out, 4.0, n=1, rest=0.1, up=0.3),
     space=FLOOR_SPACE, lying=True, free=False, yaw=1.2, cam_y=0.4)

# Teaser: aus der Rückenlage Wirbel für Wirbel in den V-Sitz, Arme parallel zu den Beinen, halten, abrollen
_tz_flat = stand(SUPINE, POINTED, STRAIGHT_LEGS, footL=(0.09, 0.07, 0.86), footR=(-0.09, 0.07, 0.86),
                 handL=(0.20, 0.10, 0.10), handR=(-0.20, 0.10, 0.10), elbowL=(1.0, 0.3, 0.0), elbowR=(-1.0, 0.3, 0.0))
_tz_roll = stand(_tz_flat, spine=(40.0, 0.0, 0.0), neck=(16.0, 0.0, 0.0), body=(0.0, -72.0, 0.0),
                 footL=(0.09, 0.28, 0.80), footR=(-0.09, 0.28, 0.80),
                 handL=(0.16, 0.42, 0.40), handR=(-0.16, 0.42, 0.40))
_tz_v = stand(_tz_flat, spine=(18.0, 0.0, 0.0), neck=(6.0, 0.0, 0.0), body=(0.0, -42.0, 0.0), root=(0.0, 0.13, 0.0),
              footL=(0.08, 0.72, 0.60), footR=(-0.08, 0.72, 0.60),
              handL=(0.14, 0.80, 0.42), handR=(-0.14, 0.80, 0.42), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0))
clip("teaser", "Pilates: Teaser", 7.0, [(0.0, _tz_flat), (0.6, _tz_flat), (1.9, _tz_roll), (3.0, _tz_v), (4.4, _tz_v),
                                         (5.6, _tz_roll)],
     space=FLOOR_SPACE, free=False, yaw=1.2, cam_y=0.5)

# Swimming: Bauchlage, Arme lang nach vorn, Brust leicht angehoben; linker Arm und rechtes Bein flattern hoch
_sw = stand(PRONE, KNEES_DOWN, foot_tops(70.0), spine=(-14.0, 0.0, 0.0), neck=(-16.0, 0.0, 0.0),
            handL=(0.22, 0.40, 0.82), handR=(-0.22, 0.22, 0.80), elbowL=(1.0, 0.2, 0.0), elbowR=(-1.0, 0.2, 0.0),
            palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.1, gripR=0.1,
            footL=(0.11, 0.12, -0.86), footR=(-0.11, 0.30, -0.84))
clip("swimming", "Pilates: Swimming", 2.0, [(0.0, _sw), (0.25, _sw)], space=FLOOR_SPACE, mirror_half=True,
     lying=True, free=False, yaw=1.2, cam_y=0.3)

# Sitzende Vorbeuge: Langsitz, aufrichten, dann aus der Hüfte nach vorn falten, Hände Richtung Füße
_sf_up = stand(SEATED, KNEES_UP, handL=(0.16, 0.30, 0.18), handR=(-0.16, 0.30, 0.18), elbowL=(1.0, -0.5, -0.3),
               elbowR=(-1.0, -0.5, -0.3), palmL=(0.0, 0.0), palmR=(0.0, 0.0), body=(0.0, 0.0, 0.0))
_sf_fold = stand(_sf_up, body=(0.0, 38.0, 0.0), spine=(26.0, 0.0, 0.0), neck=(14.0, 0.0, 0.0),
                 handL=(0.13, 0.14, 0.74), handR=(-0.13, 0.14, 0.74), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
                 gripL=0.3, gripR=0.3)
clip("sitFold", "Sitzende Vorbeuge", 8.0, reps(_sf_up, _sf_fold, 8.0, n=1, rest=0.12, up=0.33),
     space=FLOOR_SPACE, free=False, yaw=1.2, cam_y=0.4)

# Drehsitz: Langsitz, linker Fuß über das rechte Knie gestellt, Oberkörper dreht nach links, rechter Ellbogen
# außen am linken Knie, linke Hand stützt hinter dem Becken
_st = stand(SEATED, body=(0.0, 0.0, 0.0), handL=(0.24, FLOOR, -0.12, ), handR=(-0.24, FLOOR, -0.12),
            footL=(-0.02, ANKLE, 0.42), kneeL=(0.25, 1.0, 0.2), soleL=(1.0, 0.0, 0.0), ankleL=0.0, **HANDS_FLAT)
_st_turn = stand(_st, spine=(4.0, 0.0, 38.0), neck=(0.0, 0.0, 30.0), handL=(0.16, FLOOR, -0.30),
                 handR=(0.18, 0.40, 0.30), elbowR=(-0.2, 0.3, 1.0), palmR=(0.0, 0.0), gripR=0.4)
clip("seatTwist", "Drehsitz", 10.0, sides(_st, _st_turn, half=5.0, move=0.25, hold=0.5), space=FLOOR_SPACE,
     mirror_half=True, free=False, yaw=0.12, cam_y=0.5)
