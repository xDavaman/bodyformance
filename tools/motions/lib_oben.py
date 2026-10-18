"""Nacken, Schultern, Brust, Arme und Handgelenke: Dehnungen und Mobilisation im Stand (Hände im Brustkorb-Raum)."""

from __future__ import annotations

from .clip import Prop
from .library import ELBOWS_BACK, P, clip, mirror, reps, sides, stand
from .rig import np, rot_y

STAND = stand()
HEAD_HANDS = {"handL": "head", "handR": "head"}

# =========================================================================== Nacken

# schräg nach vorn: Nase Richtung rechte Achsel, linke Schulter sinkt (dehnt den linken Schulterblattheber)
_diag = P(neck=(32.0, -14.0, -32.0), clavL=(-6.0, 0.0), handL=(0.25, -0.52, 0.02), gripL=0.1)
clip("neckDiag", "Nackendehnung schräg vorn", 16.0, sides(STAND, stand(_diag)), mirror_half=True, yaw=0.35, cam_y=1.25)

# nach vorn: Kinn zur Brust, Hände am Hinterkopf ziehen sanft mit
_clasp = P(handL=(0.05, 0.02, -0.13), handR=(-0.05, 0.02, -0.13), elbowL=(1.0, 0.0, 0.7), elbowR=(-1.0, 0.0, 0.7),
           gripL=0.35, gripR=0.35)
NECK_UP = stand(_clasp)
NECK_DOWN = stand(_clasp, neck=(42.0, 0.0, 0.0), spine=(6.0, 0.0, 0.0))
clip("neckFwd", "Nackendehnung vorn", 12.0, [
    (0.0, NECK_UP), (1.2, NECK_UP), (3.4, NECK_DOWN), (8.6, stand(NECK_DOWN, neck=(46.0, 0.0, 0.0))),
    (10.8, NECK_UP),
], space=HEAD_HANDS, yaw=0.9, cam_y=1.3)

# mit Hand: Kopf zur rechten Schulter, rechte Hand über dem Kopf zieht sanft, linker Arm lang nach unten
_side = stand(handR=(0.15, -0.01, 0.01), elbowR=(-1.0, 0.7, 0.2), gripR=0.45, handL=(0.25, -0.53, 0.0),
              neck=(4.0, -36.0, 0.0), clavL=(-6.0, 0.0))
_side_reach = stand(_side, handR=(0.10, 0.20, 0.03), neck=(4.0, -8.0, 0.0))
_neck_hand = sides(stand(handR=(-0.24, -0.78, 0.0)), _side, via=_side_reach)
clip("neckHand", "Nackendehnung mit Hand", 16.0, _neck_hand, space={"handR": "head"}, mirror_half=True,
     yaw=0.15, cam_y=1.25)

# Kopfdrehung: langsam nach links und rechts schauen
_rot = stand(neck=(0.0, 0.0, 65.0), spine=(0.0, 0.0, 6.0))
clip("neckRotate", "Nacken: Kopfdrehung", 10.0, [
    (0.0, STAND), (0.6, STAND), (2.4, _rot), (3.6, _rot), (5.0, STAND), (5.6, STAND), (7.4, mirror(_rot)),
    (8.6, mirror(_rot)),
], yaw=0.3, cam_y=1.25)

# =========================================================================== Schultern

# Arm hinter dem Rücken: rechte Hand zieht das linke Handgelenk zur Seite, Kopf neigt nach rechts
_behind = stand(handL=(-0.02, -0.40, -0.19), handR=(-0.10, -0.40, -0.21), elbowL=(1.0, -0.2, -0.6),
                elbowR=(-1.0, -0.2, -0.6), gripR=0.6, gripL=0.2, neck=(0.0, -28.0, 0.0))
clip("armBehind", "Schulterdehnung Arm hinter dem Rücken", 16.0, sides(STAND, _behind), mirror_half=True,
     yaw=2.6, cam_y=1.0)

# Handtuch: linke Hand hinter dem Kopf oben, rechte Hand unten am Rücken, Handtuch abwechselnd hoch und runter ziehen
_towel_up = stand(handL=(0.03, 0.30, -0.16), elbowL=(0.3, 1.0, -0.2), handR=(-0.02, -0.18, -0.21),
                  elbowR=(-1.0, -0.6, -0.2), gripL=0.6, gripR=0.6, neck=(-4.0, 0.0, 0.0))
_towel_down = stand(_towel_up, handL=(0.03, 0.22, -0.17), handR=(-0.02, -0.28, -0.21))
_towel_hi = stand(_towel_up, handL=(0.03, 0.36, -0.15), handR=(-0.02, -0.10, -0.21))
clip("towelStretch", "Schulterdehnung mit Handtuch", 16.0,
     sides(STAND, _towel_up, extra=[(0.3, _towel_down), (0.65, _towel_hi)]), mirror_half=True, yaw=2.5, cam_y=1.1)

# Wand: linke Hand flach an der Wand vorn-seitlich auf Schulterhöhe, Oberkörper dreht nach rechts weg
STAND_W = stand(handL=(0.24, 0.86, 0.04), handR=(-0.24, 0.86, 0.04))
_wall_arm = stand(STAND_W, handL=(0.62, 1.36, 0.50), elbowL=(0.0, -1.0, 0.0), palmL=(0.0, 0.0),
                  wristL=(-60.0, 0.0), gripL=0.0)
_wall_turn = stand(_wall_arm, body=(-30.0, 0.0, 0.0), spine=(0.0, 0.0, -20.0), neck=(0.0, 0.0, -25.0),
                   root=(-0.05, 0.93, -0.05))
clip("wallShoulder", "Schulter- und Brustdehnung an der Wand", 16.0, sides(STAND_W, _wall_turn, via=_wall_arm),
     space={"handL": "world", "handR": "world"}, mirror_half=True, wall_z=0.56, yaw=1.9, cam_y=1.0)

# =========================================================================== Brust

POSTS = [Prop("post", lambda w, p: (np.array([0.47, 1.0, 0.16]), np.eye(3))),
         Prop("post", lambda w, p: (np.array([-0.47, 1.0, 0.16]), np.eye(3)))]
_door = stand(STAND_W, handL=(0.43, 1.52, 0.16), handR=(-0.43, 1.52, 0.16), elbowL=(1.0, -0.6, 0.0),
              elbowR=(-1.0, -0.6, 0.0), gripL=0.0, gripR=0.0, palmL=(0.0, 0.0), palmR=(0.0, 0.0))
_door_lean = stand(_door, root=(0.0, 0.90, 0.20), body=(0.0, 4.0, 0.0), footL=(0.12, 0.08, 0.36),
                   footR=(-0.12, 0.08, -0.10), soleR=(1.0, -6.0, 10.0), kneeL=(0.1, 0.0, 1.0), neck=(-6.0, 0.0, 0.0))
# im Türrahmen: Unterarme am Rahmen, linker Fuß vor, Brust schiebt durch die Tür (zweite Hälfte rechter Fuß vor)
clip("doorChest", "Brustdehnung im Türrahmen", 16.0, sides(STAND_W, _door_lean, via=_door),
     space={"handL": "world", "handR": "world"}, props=POSTS, mirror_half=True, yaw=1.5, cam_y=1.1,
     step_lift=0.08)

# Hände hinter dem Rücken verschränken, Arme strecken und anheben, Brust öffnet sich
_clasp_b = stand(handL=(0.03, -0.46, -0.20), handR=(-0.03, -0.46, -0.20), elbowL=(1.0, 0.0, -0.5),
                 elbowR=(-1.0, 0.0, -0.5), gripL=0.5, gripR=0.5, clavL=(0.0, -8.0), clavR=(0.0, -8.0))
_clasp_up = stand(_clasp_b, handL=(0.03, -0.38, -0.36), handR=(-0.03, -0.38, -0.36), spine=(-10.0, 0.0, 0.0),
                  neck=(-12.0, 0.0, 0.0), clavL=(0.0, -14.0), clavR=(0.0, -14.0))
clip("handsBehind", "Brustdehnung Hände hinter dem Rücken", 12.0, [
    (0.0, STAND), (1.2, _clasp_b), (2.0, _clasp_b), (4.0, _clasp_up), (9.0, _clasp_up), (10.6, _clasp_b),
], yaw=2.2, cam_y=1.0)

# an der Stange: linke Hand hält eine senkrechte Stange auf Schulterhöhe, Körper dreht nach rechts weg
POST_L = [Prop("post", lambda w, p: (np.array([0.62, 1.0, 0.10]), np.eye(3)))]
_bar_hold = stand(STAND_W, handL=(0.60, 1.42, 0.06), elbowL=(0.0, -1.0, 0.0), gripL=0.8, palmL=(0.0, 0.0),
                  wristL=(0.0, 0.0))
_bar_turn = stand(_bar_hold, body=(-32.0, 0.0, 0.0), spine=(0.0, 0.0, -18.0), neck=(0.0, 0.0, -20.0),
                  root=(-0.05, 0.93, -0.08), footR=(-0.16, 0.08, -0.12), soleR=(1.0, -30.0, 0.0))
clip("barChest", "Brustdehnung an der Stange", 16.0, sides(STAND_W, _bar_turn, via=_bar_hold),
     space={"handL": "world", "handR": "world"}, props=POST_L, mirror_half=True, yaw=1.9, cam_y=1.0)
