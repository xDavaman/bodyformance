"""Schulter-Aktivierung, Reha und Prävention, Pilates-Ergänzungen."""

from __future__ import annotations

from .library import (ANKLE, FLOOR, FLOOR_SPACE, HANDS_FLAT, HOOK, KNEES_DOWN, PLANK, PRONE, QUAD, SUPINE, clip,
                      flat_feet, foot_tops, mirror, on_toes, reps, sides, stand)
from .lib_boden import SIDE_L

STAND = stand()
STAND_W = stand(handL=(0.24, 0.86, 0.04), handR=(-0.24, 0.86, 0.04))
WORLD = {"handL": "world", "handR": "world"}
STRAIGHT = {"elbowL": (1.0, 0.0, -0.4), "elbowR": (-1.0, 0.0, -0.4)}

# =========================================================================== Schulter-Aktivierung

# Band Pull-Apart: gestreckte Arme vor der Brust, Band auseinanderziehen bis die Arme seitlich sind
_pa_in = stand(STRAIGHT, handL=(0.12, 0.08, 0.56), handR=(-0.12, 0.08, 0.56), gripL=0.7, gripR=0.7,
               elbowL=(1.0, 0.3, 0.0), elbowR=(-1.0, 0.3, 0.0))
_pa_out = stand(_pa_in, handL=(0.64, 0.08, 0.14), handR=(-0.64, 0.08, 0.14), clavL=(0.0, -10.0), clavR=(0.0, -10.0))
clip("pullApart", "Band Pull-Apart", 6.0, reps(_pa_in, _pa_out, 6.0, n=2), yaw=0.4, cam_y=1.15)

# Schulterkreisen: Schultern hoch, nach hinten, tief, nach vorn
_sc = [stand(clavL=(u, f), clavR=(u, f)) for u, f in ((14.0, 0.0), (4.0, -12.0), (-5.0, 0.0), (4.0, 12.0))]
clip("shoulderCircle", "Schulterkreisen", 5.0, [(0.0, _sc[0]), (1.25, _sc[1]), (2.5, _sc[2]), (3.75, _sc[3])],
     yaw=0.6, cam_y=1.2)

# Y-T-W: Oberkörper vorgebeugt, Arme formen nacheinander Y, T und W
_hinge = dict(root=(0.0, 0.88, -0.10), body=(0.0, 48.0, 0.0), kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0),
              neck=(-15.0, 0.0, 0.0), gripL=0.3, gripR=0.3)
_hang = stand(_hinge, handL=(0.18, -0.28, 0.40), handR=(-0.18, -0.28, 0.40), elbowL=(1.0, 0.0, 0.0),
              elbowR=(-1.0, 0.0, 0.0))
_Y = stand(_hinge, handL=(0.40, 0.58, 0.12), handR=(-0.40, 0.58, 0.12), elbowL=(1.0, 0.0, -0.3),
           elbowR=(-1.0, 0.0, -0.3), gripL=0.1, gripR=0.1)
_T = stand(_hinge, handL=(0.74, 0.06, 0.02), handR=(-0.74, 0.06, 0.02), elbowL=(0.0, 0.0, -1.0),
           elbowR=(0.0, 0.0, -1.0), gripL=0.1, gripR=0.1)
_W = stand(_hinge, handL=(0.40, 0.18, -0.06), handR=(-0.40, 0.18, -0.06), elbowL=(0.6, -1.0, -0.6),
           elbowR=(-0.6, -1.0, -0.6), clavL=(0.0, -12.0), clavR=(0.0, -12.0))
clip("ytw", "Schulter-Aktivierung Y-T-W", 12.0, [
    (0.0, _hang), (1.5, _Y), (2.8, _Y), (4.0, _hang), (5.5, _T), (6.8, _T), (8.0, _hang), (9.5, _W), (10.8, _W),
], yaw=1.25, cam_y=1.0)

# Außenrotation liegend: Seitlage links, rechter Ellbogen am Körper, Unterarm dreht vom Bauch nach oben
_er_in = stand(SIDE_L, handR=(0.24, 0.32, -0.20), elbowR=(0.0, 0.3, 1.0), palmR=(0.0, 0.0), gripR=0.5)
_er_out = stand(_er_in, handR=(0.05, 0.66, -0.20))
clip("extRotation", "Außenrotation liegend", 16.0, sides(_er_in, _er_out, move=0.3, hold=0.12),
     space=FLOOR_SPACE, mirror_half=True, yaw=0.9, cam_y=0.4)

# Scapula Push-up: Liegestützhaltung, nur die Schulterblätter bewegen sich (zusammen und auseinander)
_sp_down = stand(PLANK, clavL=(0.0, -10.0), clavR=(0.0, -10.0), root=(0.0, 0.48, -0.12))
_sp_up = stand(PLANK, clavL=(0.0, 14.0), clavR=(0.0, 14.0), root=(0.0, 0.53, -0.12), spine=(6.0, 0.0, 0.0))
clip("scapPushup", "Scapula Push-up", 5.0, reps(_sp_down, _sp_up, 5.0, n=2, up=0.3), space=WORLD,
     yaw=1.35, cam_y=0.45)

# Bear Hold: Vierfüßler, Knie schweben wenige Zentimeter über dem Boden
_bear = stand(QUAD, on_toes(60.0), footL=(0.11, 0.17, -0.58),
              footR=(-0.11, 0.17, -0.58), root=(0.0, 0.62, -0.22), body=(0.0, 85.0, 0.0),
              kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0))
_bear_low = stand(_bear, root=(0.0, 0.60, -0.20))
clip("bearHold", "Bear Hold", 8.0, [(0.0, _bear), (1.0, _bear), (4.0, _bear_low), (5.0, _bear_low)],
     space=WORLD, yaw=1.3, cam_y=0.4)

# =========================================================================== Reha und Prävention

# Bird Dog: aus dem Vierfüßler linken Arm nach vorn und rechtes Bein nach hinten strecken
_bird = stand(QUAD, handL=(0.14, 0.66, 0.92), elbowL=(1.0, 0.0, 0.0), palmL=(0.0, 0.0), gripL=0.1,
              footR=(-0.11, 0.62, -1.08), kneeR=(-0.1, -1.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleR=20.0)
clip("birdDog", "Bird Dog", 8.0, sides(QUAD, _bird, half=4.0, move=0.3, hold=0.4), space=WORLD, mirror_half=True,
     yaw=1.3, cam_y=0.45)

# Clam Shell: Seitlage, Hüften und Knie gebeugt, Füße bleiben zusammen, oberes Knie öffnet sich
_clam = stand(SIDE_L, footL=(0.06, 0.08, 0.58), footR=(0.06, 0.24, 0.58), kneeL=(1.0, 0.0, 0.0), kneeR=(1.0, 0.0, 0.0),
              handR=(0.30, FLOOR, -0.05), palmR=(1.0, 0.0),
              elbowR=(1.0, 1.0, 0.0))
_clam_open = stand(_clam, kneeR=(0.6, 1.0, 0.0))
clip("clamShell", "Clam Shell", 8.0, sides(_clam, _clam_open, half=4.0, move=0.22, hold=0.22, extra=[(0.5, _clam_open)]),
     space=FLOOR_SPACE, mirror_half=True, yaw=0.9, cam_y=0.35)

# McGill Curl-up: Rückenlage, rechtes Bein gestreckt, linkes aufgestellt, Hände unter dem unteren Rücken;
# Kopf und Schultern heben sich nur wenige Zentimeter
_mg = stand(SUPINE, footL=(0.13, ANKLE, 0.44), kneeL=(0.2, 1.0, 0.3), soleL=(1.0, 0.0, 0.0), ankleL=0.0,
            handL=(0.06, 0.06, -0.10), handR=(-0.06, 0.06, -0.10), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
            palmL=(1.0, 0.0), palmR=(1.0, 0.0))
_mg_up = stand(_mg, spine=(14.0, 0.0, 0.0), neck=(6.0, 0.0, 0.0))
clip("mcgill", "McGill Curl-up", 12.0, sides(_mg, _mg_up, move=0.2, hold=0.45), space=FLOOR_SPACE,
     mirror_half=True, yaw=1.3, cam_y=0.3)

# Seitstütz: auf dem linken Unterarm, Körper eine Linie, rechte Hand an der Hüfte
_spl_down = stand(SIDE_L, body=(0.0, -58.0, 0.0), root=(0.0, 0.15, 0.0),
                  footL=(0.0, 0.07, 0.86), footR=(0.0, 0.21, 0.86), kneeL=(1.0, 0.0, 0.0), kneeR=(1.0, 0.0, 0.0),
                  soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=0.0, ankleR=0.0,
                  handL=(0.27, 0.05, -0.36), elbowL=(0.0, -1.0, 0.0), palmL=(1.0, 90.0),
                  handR=(0.08, 0.48, -0.02), elbowR=(0.0, 1.0, -0.4), palmR=(0.0, 0.0), neck=(0.0, 0.0, 0.0))
_spl = stand(_spl_down, body=(0.0, -64.0, 0.0), root=(0.0, 0.34, 0.0))
clip("sidePlank", "Seitstütz", 16.0, sides(_spl_down, _spl, move=0.2, hold=0.6), space=FLOOR_SPACE,
     mirror_half=True, yaw=0.9, cam_y=0.4)

# Monster Walk: halbe Hocke, Seitschritte nach links und wieder zurück (Band über den Knien)
_mw = stand(STAND_W, root=(0.0, 0.84, -0.02), body=(0.0, 12.0, 0.0), footL=(0.16, ANKLE, 0.0),
            footR=(-0.16, ANKLE, 0.0), kneeL=(0.4, 0.0, 1.0), kneeR=(-0.4, 0.0, 1.0),
            handL=(0.20, 1.02, 0.25), handR=(-0.20, 1.02, 0.25), elbowL=(0.3, -1.0, -0.3),
            elbowR=(-0.3, -1.0, -0.3), gripL=0.6, gripR=0.6)
_mw_lift = stand(_mw, footL=(0.26, ANKLE + 0.07, 0.02), root=(0.04, 0.84, -0.02))
_mw_wide = stand(_mw, footL=(0.36, ANKLE, 0.02), root=(0.10, 0.83, -0.02))
_mw_follow = stand(_mw_wide, footR=(-0.02, ANKLE + 0.07, 0.0), root=(0.16, 0.84, -0.02))
_mw_2 = stand(_mw, footL=(0.36, ANKLE, 0.02), footR=(0.04, ANKLE, 0.0), root=(0.20, 0.84, -0.02))
clip("monsterWalk", "Monster Walk", 6.0, [
    (0.0, _mw), (0.6, _mw_lift), (1.1, _mw_wide), (1.7, _mw_follow), (2.2, _mw_2),
    (2.5, _mw_2),
], space=WORLD, mirror_half=True, yaw=0.3, cam_y=0.7)

# Einbeinstand: auf dem linken Bein, rechtes Knie auf Hüfthöhe, Arme leicht seitlich zum Ausbalancieren
_one = stand(STAND_W, footL=(0.06, ANKLE, 0.0), root=(0.04, 0.93, 0.0), footR=(-0.12, 0.50, 0.30),
             kneeR=(-0.1, 0.0, 1.0), soleR=(0.0, 0.0, 0.0), ankleR=15.0,
             handL=(0.42, 1.02, 0.04), handR=(-0.42, 1.02, 0.04))
_one_sway = stand(_one, root=(0.06, 0.93, 0.01), body=(0.0, 0.0, 2.0), handL=(0.44, 1.05, 0.06))
clip("singleLeg", "Einbeinstand", 16.0, sides(STAND_W, _one, move=0.18, hold=0.6,
                                              extra=[(0.3, _one_sway), (0.7, _one)]),
     space=WORLD, mirror_half=True, yaw=0.5, cam_y=0.9)


# Fersengang und Zehengang: Gehen auf der Stelle
def _walk(heel: float, lift_h: float, root_y: float, key: str, title: str):
    base = stand(STAND_W, soleL=(1.0, 6.0, heel), soleR=(1.0, -6.0, heel), root=(0.0, root_y, 0.0),
                 handL=(0.24, root_y - 0.06, 0.04), handR=(-0.24, root_y - 0.06, 0.04))
    if heel > 0:
        base.update(footL=(0.12, ANKLE + 0.07, 0.02), footR=(-0.12, ANKLE + 0.07, 0.02))
    up = stand(base, footL=(base["footL"][0], base["footL"][1] + lift_h, 0.10), kneeL=(0.1, 0.0, 1.0),
               handL=(0.24, root_y - 0.06, -0.06), handR=(-0.24, root_y - 0.06, 0.14))
    clip(key, title, 2.4, [(0.0, base), (0.3, up), (0.7, base)], space=WORLD, mirror_half=True,
         yaw=1.2, cam_y=0.6)


_walk(-25.0, 0.10, 0.92, "heelWalk", "Fersengang")
_walk(32.0, 0.08, 1.00, "toeWalk", "Zehengang")

# =========================================================================== Pilates

# Seitlicher Beinkreis: Seitlage links, Kopf auf der Hand, oberes Bein gestreckt und kreist
_slc = stand(SIDE_L, body=(0.0, -90.0, -8.0), root=(0.0, 0.24, 0.0),
             footL=(0.10, 0.07, 0.86), kneeL=(1.0, 0.0, 0.0), soleL=(0.0, 0.0, 0.0), ankleL=20.0,
             footR=(0.10, 0.36, 0.86), kneeR=(1.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleR=20.0,
             handL=(0.05, 0.40, -0.72), elbowL=(0.0, -1.0, 0.0), palmL=(0.0, 0.0),
             handR=(0.32, FLOOR, -0.25), palmR=(1.0, 0.0), elbowR=(1.0, 1.0, 0.0), neck=(0.0, 20.0, 0.0))
_slc_c = [stand(_slc, footR=(0.10 + dx, 0.36 + dy, 0.84)) for dx, dy in
          ((0.16, 0.05), (0.0, 0.20), (-0.16, 0.05), (0.0, -0.10))]
clip("sideLegCircle", "Pilates: Seitlicher Beinkreis", 12.0, [
    (0.0, _slc), (0.5, _slc_c[0]), (1.25, _slc_c[1]), (2.0, _slc_c[2]), (2.75, _slc_c[3]), (3.5, _slc_c[0]),
    (4.25, _slc_c[3]), (5.0, _slc_c[2]), (5.5, _slc),
], space=FLOOR_SPACE, mirror_half=True, yaw=0.9, cam_y=0.4)

# Swan: Bauchlage, Hände unter den Schultern, Oberkörper hebt sich in die Streckung, Becken bleibt am Boden
_sw = stand(PRONE, handL=(0.24, FLOOR, 0.40), handR=(-0.24, FLOOR, 0.40), elbowL=(0.3, 0.5, -1.0),
            elbowR=(-0.3, 0.5, -1.0), palmL=(1.0, 0.0), palmR=(1.0, 0.0), neck=(-5.0, 0.0, 0.0))
_sw_up = stand(_sw, body=(0.0, 72.0, 0.0), spine=(-32.0, 0.0, 0.0), neck=(-18.0, 0.0, 0.0),
               handL=(0.24, FLOOR, 0.36), handR=(-0.24, FLOOR, 0.36))
clip("swan", "Pilates: Swan", 8.0, reps(_sw, _sw_up, 8.0, n=2, up=0.35), space=FLOOR_SPACE, yaw=1.3, cam_y=0.4)
