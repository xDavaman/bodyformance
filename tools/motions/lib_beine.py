"""Waden, Sprunggelenke und Handgelenke."""

from __future__ import annotations

from .clip import Prop
from .library import ANKLE, SEATED, FLOOR_SPACE, clip, reps, sides, stand
from .rig import np, rot_z

STAND = stand()
STAND_W = stand(handL=(0.24, 0.86, 0.04), handR=(-0.24, 0.86, 0.04))
WORLD = {"handL": "world", "handR": "world"}

# =========================================================================== Waden

# an der Wand, gebeugt (Soleus): Hände an der Wand, linker Fuß hinten, beide Knie beugen sich
_wall_hands = dict(handL=(0.22, 1.22, 0.58), handR=(-0.22, 1.22, 0.58), elbowL=(0.5, -1.0, 0.0),
                   elbowR=(-0.5, -1.0, 0.0), gripL=0.0, gripR=0.0)
_sol_set = stand(STAND_W, _wall_hands, footL=(0.12, ANKLE, -0.28), footR=(-0.12, ANKLE, 0.28),
                 root=(0.0, 0.90, 0.16), body=(0.0, 16.0, 0.0), kneeR=(-0.1, 0.0, 1.0))
_sol = stand(_sol_set, root=(0.0, 0.80, 0.16), kneeL=(0.1, 0.0, 1.0), body=(0.0, 12.0, 0.0))
clip("soleusWall", "Wadendehnung an der Wand, gebeugt", 16.0, sides(_sol_set, _sol, move=0.3), space=WORLD,
     mirror_half=True, wall_z=0.64, yaw=1.15, cam_y=0.9)

# auf der Treppenstufe: Vorfuß auf der Kante, Fersen sinken langsam unter die Stufe und heben sich wieder
STEP_H = 0.15
STEP = [Prop("step", lambda w, p: (np.array([0.0, STEP_H / 2, 0.10]), rot_z(90.0)))]
_on_step = stand(footL=(0.12, STEP_H + ANKLE, -0.02), footR=(-0.12, STEP_H + ANKLE, -0.02),
                 root=(0.0, 0.93 + STEP_H, 0.0))
_heels_down = stand(_on_step, soleL=(1.0, 6.0, -22.0), soleR=(1.0, -6.0, -22.0),
                    footL=(0.12, STEP_H + ANKLE - 0.03, -0.03), footR=(-0.12, STEP_H + ANKLE - 0.03, -0.03),
                    root=(0.0, 0.90 + STEP_H, 0.0))
_heels_up = stand(_on_step, soleL=(1.0, 6.0, 30.0), soleR=(1.0, -6.0, 30.0),
                  footL=(0.12, STEP_H + ANKLE + 0.06, 0.01), footR=(-0.12, STEP_H + ANKLE + 0.06, 0.01),
                  root=(0.0, 0.99 + STEP_H, 0.0))
clip("calfStep", "Wadendehnung auf der Treppenstufe", 10.0, [
    (0.0, _on_step), (1.0, _on_step), (3.0, _heels_down), (6.0, _heels_down), (8.0, _heels_up), (9.0, _heels_up),
], ground=False, props=STEP, yaw=1.3, cam_y=0.8)

# mit Band: Langsitz, Band um den linken Vorfuß, die Hände ziehen die Fußspitze zum Körper
_band = stand(SEATED, handL=(0.08, 0.42, 0.40), handR=(0.00, 0.42, 0.40), elbowL=(1.0, -0.5, -0.5),
              elbowR=(-1.0, -0.5, -0.5), gripL=0.8, gripR=0.8, palmL=(0.0, 0.0), palmR=(0.0, 0.0),
              body=(0.0, 0.0, 0.0), spine=(6.0, 0.0, 0.0))
_band_pull = stand(_band, ankleL=-15.0, handL=(0.08, 0.40, 0.32), handR=(0.00, 0.40, 0.32),
                   spine=(2.0, 0.0, 0.0))
clip("calfBand", "Wadendehnung mit Band", 16.0, sides(_band, _band_pull, extra=[(0.5, stand(_band_pull, ankleL=-5.0))]),
     space=FLOOR_SPACE, mirror_half=True, yaw=1.2, cam_y=0.4)

# =========================================================================== Sprunggelenk

# Kreisen: linker Fuß leicht angehoben, Fußspitze beschreibt einen Kreis
_lift = stand(STAND_W, footL=(0.14, 0.20, 0.15), kneeL=(0.1, 0.0, 1.0), soleL=(0.0, 0.0, 0.0), ankleL=10.0,
              root=(-0.03, 0.93, 0.0), handL=(0.32, 0.95, 0.04), handR=(-0.32, 0.95, 0.04))
_circ = []
for k, (ank, dx, dy) in enumerate(((30.0, 0.0, 0.0), (10.0, 0.03, 0.02), (-15.0, 0.0, 0.03), (10.0, -0.03, 0.02))):
    _circ.append(stand(_lift, ankleL=ank, footL=(0.14 + dx, 0.20 + dy, 0.15)))
clip("ankleCircle", "Sprunggelenk kreisen", 12.0, [
    (0.0, STAND_W), (0.6, _lift), (1.1, _circ[0]), (1.6, _circ[1]), (2.1, _circ[2]), (2.6, _circ[3]),
    (3.1, _circ[0]), (3.6, _circ[3]), (4.1, _circ[2]), (4.6, _circ[1]), (5.1, _circ[0]), (5.6, _lift),
], space=WORLD, mirror_half=True, yaw=1.0, cam_y=0.5)

# Fußwippe: auf die Zehen hoch, dann auf die Fersen mit angehobenen Fußspitzen
_toes = stand(STAND_W, soleL=(1.0, 6.0, 35.0), soleR=(1.0, -6.0, 35.0), footL=(0.12, ANKLE + 0.07, 0.02),
              footR=(-0.12, ANKLE + 0.07, 0.02), root=(0.0, 1.00, 0.0))
_heels = stand(STAND_W, soleL=(1.0, 6.0, -25.0), soleR=(1.0, -6.0, -25.0), root=(0.0, 0.92, -0.03),
               body=(0.0, 4.0, 0.0), handL=(0.24, 0.90, 0.12), handR=(-0.24, 0.90, 0.12))
clip("ankleRock", "Fußwippe", 6.0, [
    (0.0, STAND_W), (0.6, STAND_W), (1.6, _toes), (2.4, _toes), (3.4, STAND_W), (4.2, _heels), (5.2, _heels),
], space=WORLD, yaw=1.3, cam_y=0.5)

# =========================================================================== Handgelenke (Hände im Brustraum)

_fwd = dict(handL=(0.12, -0.10, 0.36), handR=(-0.12, -0.10, 0.36), elbowL=(1.0, -1.0, 0.0),
            elbowR=(-1.0, -1.0, 0.0), gripL=0.35, gripR=0.35)
_w = [stand(_fwd, wristL=(f, d), wristR=(f, -d)) for f, d in ((45.0, 0.0), (0.0, 25.0), (-45.0, 0.0), (0.0, -20.0))]
clip("wristCircle", "Handgelenke kreisen", 6.0, [
    (0.0, _w[0]), (0.75, _w[1]), (1.5, _w[2]), (2.25, _w[3]), (3.0, _w[0]), (3.75, _w[3]), (4.5, _w[2]),
    (5.25, _w[1]),
], yaw=0.5, cam_y=1.1)

# Beuger dehnen: linker Arm gestreckt nach vorn, Handgelenk überstreckt, rechte Hand zieht die Finger zurück
_flex = stand(handL=(0.10, -0.02, 0.58), elbowL=(1.0, -1.0, 0.0), wristL=(-75.0, 0.0), gripL=0.0,
              handR=(0.04, -0.12, 0.50), elbowR=(-1.0, -1.0, 0.0), wristR=(-20.0, 0.0), gripR=0.4)
_flex_in = stand(_flex, wristL=(-30.0, 0.0), handR=(-0.10, -0.25, 0.30))
clip("wristFlexor", "Handgelenk: Beuger dehnen", 12.0, sides(STAND, _flex, half=6.0, via=_flex_in), mirror_half=True,
     yaw=1.1, cam_y=1.1)

# Strecker dehnen: Handgelenk gebeugt, rechte Hand drückt den Handrücken
_ext = stand(_flex, wristL=(75.0, 0.0), gripL=0.3, handR=(0.08, -0.04, 0.56), wristR=(10.0, 0.0))
_ext_in = stand(_ext, wristL=(30.0, 0.0), handR=(-0.10, -0.25, 0.30))
clip("wristExtensor", "Handgelenk: Strecker dehnen", 12.0, sides(STAND, _ext, half=6.0, via=_ext_in), mirror_half=True,
     yaw=1.1, cam_y=1.1)

# Gebet: Handflächen vor der Brust aneinander, Hände sinken langsam bei gleichem Druck
_pray = stand(handL=(0.035, 0.0, 0.26), handR=(-0.035, 0.0, 0.26), elbowL=(1.0, -0.4, 0.0),
              elbowR=(-1.0, -0.4, 0.0), wristL=(-80.0, 0.0), wristR=(-80.0, 0.0), gripL=0.0, gripR=0.0)
_pray_low = stand(_pray, handL=(0.035, -0.16, 0.26), handR=(-0.035, -0.16, 0.26), elbowL=(1.0, -0.1, 0.0),
                  elbowR=(-1.0, -0.1, 0.0))
clip("prayer", "Handgelenk: Gebetsdehnung", 10.0, [
    (0.0, STAND), (1.0, _pray), (2.0, _pray), (4.0, _pray_low), (7.5, _pray_low), (9.0, _pray),
], yaw=1.0, cam_y=1.1)
