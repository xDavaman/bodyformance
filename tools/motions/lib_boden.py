"""Dehnungen und Mobilisation am Boden: Rücken, Hüfte, Oberschenkel, Brust und Schulter im Liegen oder Knien."""

from __future__ import annotations

from .library import (ANKLE, ELBOWS_BACK, FLOOR, FLOOR_SPACE, HANDS_FLAT, HOOK, KNEES_DOWN, KNEEL, PRONE, QUAD,
                      SEATED, SUPINE, clip, flat_feet, foot_tops, hands, mirror, sides, stand)

# Seitlage links: Kopf bei -Z, Brust schaut nach +X, Knie leicht gebeugt nach vorn
SIDE_L = stand(SUPINE, turn=90.0, root=(0.0, 0.24, 0.0), neck=(0.0, 18.0, 0.0),
               handL=(0.28, 0.06, -0.20), elbowL=(1.0, 0.0, 0.0), handR=(0.20, 0.30, -0.05), elbowR=(0.3, 1.0, 0.3),
               palmL=(1.0, 90.0), palmR=(0.0, 0.0), gripL=0.1, gripR=0.1,
               footL=(0.22, 0.07, 0.55), footR=(0.20, 0.24, 0.58), kneeL=(1.0, 0.0, 0.0), kneeR=(1.0, 0.0, 0.0),
               soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=10.0, ankleR=10.0)

# =========================================================================== Schulter im Liegen

# Schlafposition: auf der linken Seite, linker Oberarm vorn auf Schulterhöhe, Unterarm senkrecht;
# die rechte Hand drückt den linken Unterarm langsam Richtung Boden (Innenrotation)
_sleep_up = stand(SIDE_L, handL=(0.30, 0.36, -0.40), elbowL=(1.0, -0.3, 0.0), palmL=(0.0, 0.0), gripL=0.2,
                  handR=(0.30, 0.40, -0.33), elbowR=(0.3, 1.0, 0.6), gripR=0.4)
_sleep_down = stand(_sleep_up, handL=(0.31, 0.17, -0.22), handR=(0.31, 0.24, -0.17))
clip("sleeper", "Schulterdehnung Schlafposition", 16.0, sides(_sleep_up, _sleep_down, move=0.35, hold=0.45),
     space=FLOOR_SPACE, mirror_half=True, yaw=0.9, cam_y=0.35)

# Brust auf dem Boden: Bauchlage, linker Arm seitlich ausgestreckt; rechte Hand drückt, der Körper dreht
# sich nach links auf die Seite, rechtes Knie stellt sich hinter dem Körper auf
_prone_arm = stand(PRONE, handL=(0.78, 0.05, 0.42), elbowL=(0.0, 1.0, 0.3), palmL=(1.0, 90.0),
                   handR=(-0.25, FLOOR, 0.42), elbowR=(-1.0, 0.4, -0.2), palmR=(1.0, 0.0))
_prone_roll = stand(_prone_arm, turn=-30.0, root=(0.0, 0.32, 0.0), spine=(0.0, 0.0, -30.0), neck=(0.0, 0.0, -35.0),
                    handR=(-0.32, FLOOR, 0.30), footR=(-0.05, 0.08, -0.32), kneeR=(-0.3, 1.0, 0.2),
                    soleR=(1.0, 0.0, 0.0))
_prone_knee = stand(_prone_arm, turn=-12.0, root=(0.0, 0.26, 0.0), footR=(-0.10, 0.40, -0.55),
                    kneeR=(-0.4, -0.2, 1.0), soleR=(0.0, 0.0, 0.0))
clip("floorChest", "Brustdehnung auf dem Boden", 16.0, sides(_prone_arm, _prone_roll, via=_prone_knee, back=_prone_knee),
     space=FLOOR_SPACE, mirror_half=True, yaw=0.6, cam_y=0.3)

# =========================================================================== Rücken

# Nadelöhr: aus dem Vierfüßlerstand fädelt der linke Arm unter dem rechten durch, Schulter und Schläfe sinken
_thread_open = stand(QUAD, handL=(0.45, 0.85, 0.20), elbowL=(1.0, 0.0, 0.0), palmL=(0.0, 0.0),
                     spine=(0.0, 0.0, 45.0), neck=(0.0, 0.0, 35.0))
_thread = stand(QUAD, handL=(-0.50, 0.07, 0.28), elbowL=(0.0, 0.0, 1.0), palmL=(0.0, 0.0), gripL=0.1,
                handR=(-0.24, FLOOR, 0.40), root=(0.0, 0.50, -0.22), spine=(10.0, 0.0, -50.0),
                neck=(0.0, 10.0, -35.0))
clip("threadNeedle", "Rückendehnung Nadelöhr", 16.0, sides(QUAD, _thread, via=_thread_open, move=0.32),
     space=FLOOR_SPACE, mirror_half=True, yaw=0.5, cam_y=0.4)

# Latissimus am Türrahmen: linke Hand greift den Rahmen über Kopfhöhe, Becken schiebt nach links-hinten,
# Oberkörper neigt sich zur Seite
STAND_W = stand(handL=(0.24, 0.86, 0.04), handR=(-0.24, 0.86, 0.04))
from .lib_oben import POST_L  # noqa: E402
_lat_hold = stand(STAND_W, handL=(0.58, 1.75, 0.10), elbowL=(1.0, 0.0, -0.3), gripL=0.8,
                  handR=(0.57, 1.58, 0.13), elbowR=(-0.5, -1.0, 0.2), gripR=0.8)
_lat = stand(_lat_hold, root=(-0.10, 0.86, -0.12), body=(10.0, 18.0, -12.0), spine=(10.0, -18.0, 10.0),
             neck=(0.0, -8.0, 0.0), kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0))
clip("latDoor", "Rückendehnung Latissimus am Türrahmen", 16.0, sides(STAND_W, _lat, via=_lat_hold),
     space={"handL": "world", "handR": "world"}, props=POST_L, mirror_half=True, yaw=0.4, cam_y=1.1)

# =========================================================================== Hüfte

# Schmetterling: Sitz, Fußsohlen aneinander, Knie sinken nach außen, Oberkörper neigt sich nach vorn
_bfly = stand(SEATED, root=(0.0, 0.13, 0.0), body=(0.0, 0.0, 0.0), spine=(5.0, 0.0, 0.0),
              footL=(0.05, 0.09, 0.42), footR=(-0.05, 0.09, 0.42), kneeL=(1.0, 0.45, 0.2), kneeR=(-1.0, 0.45, 0.2),
              soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=10.0, ankleR=10.0,
              handL=(0.06, 0.12, 0.47), handR=(-0.06, 0.12, 0.47), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
              gripL=0.6, gripR=0.6)
_bfly_fwd = stand(_bfly, body=(0.0, 22.0, 0.0), spine=(25.0, 0.0, 0.0), neck=(10.0, 0.0, 0.0),
                  kneeL=(1.0, 0.25, 0.2), kneeR=(-1.0, 0.25, 0.2))
clip("butterfly", "Hüftdehnung Schmetterling", 12.0, [
    (0.0, _bfly), (1.5, _bfly), (4.0, _bfly_fwd), (8.5, _bfly_fwd), (10.5, _bfly),
], space=FLOOR_SPACE, yaw=0.5, cam_y=0.4)

# Frosch: Vierfüßler mit weit gespreizten Knien, Unterarme am Boden, Becken schiebt langsam nach hinten
_frog = stand(QUAD, footL=(0.46, 0.10, -0.70), footR=(-0.46, 0.10, -0.70), kneeL=(1.0, 0.0, 0.5),
              kneeR=(-1.0, 0.0, 0.5), soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=-10.0, ankleR=-10.0,
              handL=(0.17, FLOOR, 0.55), handR=(-0.17, FLOOR, 0.55), elbowL=(0.3, -1.0, 0.0),
              elbowR=(-0.3, -1.0, 0.0), root=(0.0, 0.40, -0.25), body=(0.0, 85.0, 0.0), neck=(-10.0, 0.0, 0.0))
_frog_back = stand(_frog, root=(0.0, 0.36, -0.42), body=(0.0, 72.0, 0.0), footL=(0.46, 0.10, -0.76),
                   footR=(-0.46, 0.10, -0.76))
clip("frog", "Hüftdehnung Frosch", 12.0, [
    (0.0, _frog), (1.5, _frog), (4.5, _frog_back), (7.0, _frog_back), (10.0, _frog),
], space=FLOOR_SPACE, yaw=0.3, cam_y=0.35)

# 90/90: Sitz, linkes Bein vorn im rechten Winkel, rechtes Bein seitlich hinten im rechten Winkel;
# Oberkörper lehnt sich über das vordere Schienbein
_ninety = stand(SEATED, root=(0.0, 0.13, 0.0), body=(25.0, 0.0, 0.0), spine=(5.0, 0.0, 0.0),
                footL=(-0.12, 0.07, 0.48), kneeL=(1.0, -0.2, 0.6), soleL=(0.0, 0.0, 0.0), ankleL=15.0,
                footR=(-0.55, 0.07, -0.25), kneeR=(-0.4, -0.3, 1.0), soleR=(0.0, 0.0, 0.0), ankleR=40.0,
                handL=(0.25, FLOOR, 0.15), handR=(-0.25, FLOOR, 0.05))
_ninety_lean = stand(_ninety, body=(25.0, 30.0, 0.0), spine=(25.0, 0.0, 0.0), neck=(10.0, 0.0, 0.0),
                     handL=(0.15, FLOOR, 0.55), handR=(-0.15, FLOOR, 0.52))
clip("ninety", "Hüftdehnung 90/90", 16.0, sides(_ninety, _ninety_lean), space=FLOOR_SPACE, mirror_half=True,
     yaw=0.4, cam_y=0.35)

# Figur-Vier (Piriformis): Rückenlage, linker Knöchel auf dem rechten Knie, beide Hände ziehen den rechten
# Oberschenkel zur Brust
_fig4 = stand(HOOK, footL=(-0.02, 0.36, 0.38), kneeL=(1.0, 0.6, 0.0), soleL=(0.0, 0.0, 0.0), ankleL=10.0)
_fig4_pull = stand(_fig4, footR=(-0.12, 0.42, 0.20), kneeR=(-0.1, 1.0, 0.4), soleR=(0.0, 0.0, 0.0), ankleR=10.0,
                   footL=(-0.04, 0.60, 0.05),
                   handL=(-0.02, 0.48, 0.12), handR=(-0.18, 0.48, 0.12), elbowL=(1.0, 0.0, -0.5),
                   elbowR=(-1.0, 0.0, -0.5), palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.6, gripR=0.6,
                   neck=(15.0, 0.0, 0.0))
clip("figureFour", "Hüftdehnung Figur-Vier", 16.0, sides(HOOK, _fig4_pull, via=_fig4), space=FLOOR_SPACE,
     mirror_half=True, yaw=1.2, cam_y=0.35)

# Couch-Stretch: rechtes Knie am Boden vor der Wand, Fußrücken an der Wand, linker Fuß vorn aufgestellt,
# Oberkörper richtet sich auf
_couch_low = stand(KNEEL, footL=(0.13, ANKLE, 0.38), kneeL=(0.1, 0.0, 1.0), soleL=(1.0, 0.0, 0.0), ankleL=0.0,
                   footR=(-0.12, 0.38, -0.50), kneeR=(-0.1, -1.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleR=60.0,
                   root=(0.0, 0.50, -0.12), body=(0.0, 35.0, 0.0), handL=(0.30, FLOOR, 0.42),
                   handR=(-0.30, FLOOR, 0.42), palmL=(1.0, 0.0), palmR=(1.0, 0.0))
_couch_up = stand(_couch_low, root=(0.0, 0.52, -0.16), body=(0.0, -5.0, 0.0), spine=(-6.0, 0.0, 0.0),
                  handL=(0.22, 0.72, 0.30), handR=(-0.22, 0.72, 0.30), palmL=(0.0, 0.0), palmR=(0.0, 0.0),
                  elbowL=(1.0, -0.3, -0.3), elbowR=(-1.0, -0.3, -0.3), gripL=0.3, gripR=0.3)
clip("couchStretch", "Hüftdehnung Couch-Stretch", 16.0, sides(_couch_low, _couch_up, move=0.3), space=FLOOR_SPACE,
     mirror_half=True, wall_z=-0.62, yaw=1.3, cam_y=0.5)

# =========================================================================== Oberschenkel

# Quadrizeps liegend: Seitlage links, rechte Hand zieht den rechten Fuß zum Gesäß
_qlie = stand(SIDE_L, footR=(0.0, 0.32, 0.15), kneeR=(0.3, 0.0, 1.0), soleR=(0.0, 0.0, 0.0), ankleR=40.0,
              handR=(0.0, 0.34, 0.20), elbowR=(0.0, 0.5, -1.0), gripR=0.7,
              footL=(0.20, 0.07, 0.62), kneeL=(1.0, 0.0, 0.0))
_qlie_pull = stand(_qlie, footR=(-0.05, 0.30, 0.05), handR=(-0.05, 0.32, 0.10))
clip("quadLying", "Quadrizepsdehnung liegend", 16.0, sides(SIDE_L, _qlie_pull, via=_qlie), space=FLOOR_SPACE,
     mirror_half=True, yaw=0.9, cam_y=0.35)

# ITB/Abduktoren im Stand: rechtes Bein hinter dem linken gekreuzt, Hüfte schiebt nach rechts, linker Arm über Kopf
_itb = stand(STAND_W, footR=(0.18, ANKLE, 0.02), footL=(0.08, ANKLE, -0.10), kneeR=(0.0, 0.0, 1.0),
             root=(-0.10, 0.92, 0.0), body=(0.0, 0.0, 10.0), spine=(0.0, 25.0, 0.0),
             handL=(-0.15, 1.85, 0.0), elbowL=(1.0, 0.3, 0.0), handR=(-0.32, 0.92, 0.02), gripL=0.1)
_itb_cross = stand(STAND_W, footR=(0.18, ANKLE, 0.02), footL=(0.08, ANKLE, -0.10), kneeR=(0.0, 0.0, 1.0))
clip("itbStretch", "Dehnung Abduktoren und Tractus (ITB)", 16.0, sides(STAND_W, _itb, via=_itb_cross),
     space={"handL": "world", "handR": "world"}, mirror_half=True, yaw=0.1, cam_y=0.9)

# Kniesehne im Ausfallschritt (halber Spagat): rechtes Knie am Boden, linkes Bein gestreckt nach vorn,
# Oberkörper lang nach vorn, Hände neben dem vorderen Bein
_hs_lunge = stand(KNEEL, footL=(0.13, ANKLE, 0.42), kneeL=(0.1, 0.0, 1.0), soleL=(1.0, 0.0, 0.0),
                  footR=(-0.12, 0.06, -0.48), root=(0.0, 0.50, -0.05), body=(0.0, 30.0, 0.0),
                  handL=(0.28, FLOOR, 0.42), handR=(-0.10, FLOOR, 0.42), palmL=(1.0, 0.0), palmR=(1.0, 0.0))
_hs = stand(_hs_lunge, footL=(0.12, 0.10, 0.62), kneeL=(0.1, 1.0, 0.0), soleL=(0.0, 0.0, 0.0), ankleL=-25.0,
            root=(0.0, 0.50, -0.22), body=(0.0, 55.0, 0.0), spine=(20.0, 0.0, 0.0),
            handL=(0.28, FLOOR, 0.30), handR=(-0.08, FLOOR, 0.30))
clip("halfSplit", "Kniesehnen-Dehnung im Ausfallschritt", 16.0, sides(_hs_lunge, _hs, move=0.32),
     space=FLOOR_SPACE, mirror_half=True, yaw=1.3, cam_y=0.45)
