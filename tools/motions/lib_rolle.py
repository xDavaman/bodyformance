"""Faszienrolle: die Rolle liegt quer unter dem Körperteil und rollt mit halber Geschwindigkeit des Körpers mit."""

from __future__ import annotations

from .clip import Prop
from .library import (ANKLE, FLOOR, FLOOR_SPACE, HOOK, SEATED, SUPINE, clip, sides, stand)
from .rig import np, rot_x, rot_z

R = 0.075  # Radius der Rolle


def roller(z0: float, root_z0: float, x: float = 0.0, along: bool = False, kind: str = "roller") -> list:
    """Rolle quer (Achse x) bei z0, wandert mit halber Beckenbewegung (Rollen ohne Rutschen)."""
    rot = rot_x(90.0) if along else rot_z(90.0)
    y = R if kind == "roller" else 0.035

    def place(w, p):
        return np.array([x, y, z0 + 0.5 * (w["root"][2] - root_z0)]), rot
    return [Prop(kind, place)]


# Oberschenkel vorne: Unterarmstütz, Rolle unter den Oberschenkeln, Körper schiebt vor und zurück
_q = stand(handL=(0.16, 0.04, 0.42), handR=(-0.16, 0.04, 0.42), elbowL=(0.2, -1.0, -0.3), elbowR=(-0.2, -1.0, -0.3),
           palmL=(1.0, 0.0), palmR=(1.0, 0.0), gripL=0.1, gripR=0.1,
           footL=(0.11, 0.16, -0.86), footR=(-0.11, 0.16, -0.86), soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0),
           ankleL=60.0, ankleR=60.0, kneeL=(0.1, -1.0, 0.0), kneeR=(-0.1, -1.0, 0.0),
           root=(0.0, 0.29, 0.0), body=(0.0, 84.0, 0.0), neck=(-15.0, 0.0, 0.0))
_q2 = stand(_q, root=(0.0, 0.29, -0.22), footL=(0.11, 0.17, -1.08), footR=(-0.11, 0.17, -1.08),
            handL=(0.16, 0.04, 0.42), body=(0.0, 80.0, 0.0))
clip("rollQuad", "Faszienrolle Oberschenkel vorne", 8.0, [(0.0, _q), (1.0, _q), (4.0, _q2), (5.0, _q2)],
     space=FLOOR_SPACE, props=roller(-0.30, 0.0), fit_root=False, yaw=1.35, cam_y=0.35)

# Oberschenkel hinten: Sitz, Hände hinten am Boden, Becken angehoben, Rolle unter den Oberschenkeln
_h = stand(SEATED, handL=(0.24, FLOOR, -0.30), handR=(-0.24, FLOOR, -0.30), elbowL=(0.3, 0.0, -1.0),
           elbowR=(-0.3, 0.0, -1.0), footL=(0.11, 0.17, 0.82), footR=(-0.11, 0.17, 0.82),
           root=(0.0, 0.26, 0.0), body=(0.0, -25.0, 0.0), ankleL=10.0, ankleR=10.0, neck=(15.0, 0.0, 0.0))
_h2 = stand(_h, root=(0.0, 0.26, 0.24), footL=(0.11, 0.17, 1.04), footR=(-0.11, 0.17, 1.04),
            handL=(0.24, FLOOR, -0.30), body=(0.0, -32.0, 0.0))
clip("rollHam", "Faszienrolle Oberschenkel hinten", 8.0, [(0.0, _h), (1.0, _h), (4.0, _h2), (5.0, _h2)],
     space=FLOOR_SPACE, props=roller(0.30, 0.0), fit_root=False, ground=False, yaw=1.35, cam_y=0.35)

# Waden: wie oben, Rolle unter den Unterschenkeln
_c = stand(_h, root=(0.0, 0.22, 0.0), footL=(0.11, 0.19, 0.86), footR=(-0.11, 0.19, 0.86), body=(0.0, -22.0, 0.0))
_c2 = stand(_c, root=(0.0, 0.22, 0.22), footL=(0.11, 0.19, 1.08), footR=(-0.11, 0.19, 1.08))
clip("rollCalf", "Faszienrolle Waden", 8.0, [(0.0, _c), (1.0, _c), (4.0, _c2), (5.0, _c2)],
     space=FLOOR_SPACE, props=roller(0.62, 0.0), fit_root=False, ground=False, yaw=1.35, cam_y=0.3)

# Gesäß: auf der Rolle sitzen, linker Knöchel auf dem rechten Knie, zur linken Seite neigen und rollen
_g = stand(SEATED, root=(0.03, 0.24, 0.0), body=(0.0, -12.0, -12.0),
           handL=(0.30, FLOOR, -0.22), handR=(-0.26, FLOOR, -0.22), elbowL=(0.3, 0.0, -1.0), elbowR=(-0.3, 0.0, -1.0),
           footR=(-0.14, ANKLE, 0.48), kneeR=(-0.1, 1.0, 0.3), soleR=(1.0, 0.0, 0.0),
           footL=(-0.06, 0.48, 0.40), kneeL=(1.0, 0.5, 0.0), soleL=(0.0, 0.0, 0.0), ankleL=10.0)
_g2 = stand(_g, root=(0.03, 0.24, 0.14), footR=(-0.14, ANKLE, 0.56), footL=(-0.06, 0.48, 0.52))
clip("rollGlute", "Faszienrolle Gesäß", 16.0, sides(_g, _g2, extra=[(0.5, _g)]), space=FLOOR_SPACE,
     props=roller(0.0, 0.0), mirror_half=True, fit_root=False, yaw=0.9, cam_y=0.35)

# Außenseite (ITB): Seitlage links auf dem Unterarm, Rolle unter dem linken Oberschenkel, rechter Fuß vorn auf
_itb = stand(SUPINE, turn=90.0, root=(0.0, 0.36, 0.0), body=(0.0, -90.0, 12.0), spine=(0.0, -10.0, 0.0),
             handL=(0.12, 0.04, -0.62), elbowL=(1.0, -1.0, 0.0), palmL=(1.0, 90.0),
             handR=(0.26, FLOOR, -0.25), elbowR=(1.0, 1.0, 0.0), palmR=(1.0, 0.0),
             footL=(0.0, 0.09, 0.84), kneeL=(1.0, 0.0, 0.0), soleL=(0.0, 0.0, 0.0), ankleL=10.0,
             footR=(0.32, ANKLE, 0.32), kneeR=(1.0, 1.0, 0.0), soleR=(1.0, 90.0, 0.0), neck=(0.0, 10.0, 0.0))
_itb2 = stand(_itb, root=(0.0, 0.36, -0.22), footL=(0.0, 0.09, 0.62), handL=(0.12, 0.04, -0.62),
              footR=(0.32, ANKLE, 0.20))
clip("rollItb", "Faszienrolle Außenseite (ITB)", 16.0, sides(_itb, _itb2, extra=[(0.5, _itb)]),
     space=FLOOR_SPACE, props=roller(0.22, 0.0), mirror_half=True, fit_root=False, yaw=0.9, cam_y=0.35)

# oberer Rücken: Rückenlage, Rolle quer unter dem oberen Rücken, Becken angehoben, Hände am Hinterkopf
_ub = stand(HOOK, root=(0.0, 0.34, 0.0), body=(0.0, -100.0, 0.0), footL=(0.13, ANKLE, 0.46), footR=(-0.13, ANKLE, 0.46),
            handL=(0.08, 0.40, -0.62), handR=(-0.08, 0.40, -0.62), elbowL=(1.0, 0.3, 0.3), elbowR=(-1.0, 0.3, 0.3),
            palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.4, gripR=0.4, neck=(25.0, 0.0, 0.0))
_ub2 = stand(_ub, root=(0.0, 0.30, 0.16), footL=(0.13, ANKLE, 0.46), handL=(0.08, 0.42, -0.46),
             handR=(-0.08, 0.42, -0.46), body=(0.0, -96.0, 0.0))
clip("rollUpperBack", "Faszienrolle oberer Rücken", 8.0, [(0.0, _ub), (1.0, _ub), (4.0, _ub2), (5.0, _ub2)],
     space=FLOOR_SPACE, props=roller(-0.40, 0.0), fit_root=False, ground=False, yaw=1.35, cam_y=0.35)

# Latissimus: Seitlage links, linker Arm lang über dem Kopf, Rolle unter der Achsel
_lat = stand(SUPINE, turn=90.0, root=(0.0, 0.28, 0.0), body=(0.0, -90.0, 6.0),
             handL=(0.05, 0.10, -1.00), elbowL=(1.0, 0.5, 0.0), palmL=(0.0, 0.0), gripL=0.1,
             handR=(0.26, FLOOR, -0.15), elbowR=(1.0, 1.0, 0.0), palmR=(1.0, 0.0),
             footL=(0.10, 0.07, 0.80), footR=(0.30, ANKLE, 0.42), kneeR=(1.0, 1.0, 0.0), soleR=(1.0, 90.0, 0.0),
             kneeL=(1.0, 0.0, 0.0), soleL=(0.0, 0.0, 0.0), neck=(0.0, -10.0, 0.0))
_lat2 = stand(_lat, root=(0.0, 0.28, 0.14), handL=(0.05, 0.10, -0.92), footL=(0.10, 0.07, 0.92),
              footR=(0.30, ANKLE, 0.52))
clip("rollLat", "Faszienrolle Latissimus", 16.0, sides(_lat, _lat2, extra=[(0.5, _lat)]), space=FLOOR_SPACE,
     props=roller(-0.36, 0.0), mirror_half=True, fit_root=False, yaw=0.9, cam_y=0.35)

# Nacken: Rückenlage, Rolle unter dem Nacken, Kopf dreht langsam nach links und rechts
_nk = stand(HOOK, root=(0.0, 0.11, 0.0), neck=(-12.0, 0.0, 0.0))
_nkL = stand(_nk, neck=(-12.0, 0.0, 45.0))
clip("rollNeck", "Faszienrolle Nacken", 8.0, [(0.0, _nk), (1.0, _nkL), (2.5, _nkL), (4.0, _nk),
                                               (5.0, stand(_nk, neck=(-12.0, 0.0, -45.0))),
                                               (6.5, stand(_nk, neck=(-12.0, 0.0, -45.0)))],
     space=FLOOR_SPACE, props=[Prop("roller", lambda w, p: (np.array([0.0, R, w["neck1"][2] - 0.03]), rot_z(90.0)))],
     ground=False, yaw=1.35, cam_y=0.3)

# Fußsohle: Stand, linker Fuß rollt einen kleinen Ball vor und zurück
STAND_W = stand(handL=(0.24, 0.86, 0.04), handR=(-0.24, 0.86, 0.04))
_ft = stand(STAND_W, footL=(0.13, ANKLE + 0.05, 0.05), soleL=(1.0, 6.0, 0.0), root=(-0.02, 0.95, 0.0),
            handL=(0.30, 0.92, 0.04), handR=(-0.30, 0.92, 0.04))
_ft2 = stand(_ft, footL=(0.13, ANKLE + 0.05, 0.20))


def _ball(w, p):
    f, t = w["ftL"], w["toeL"]
    m = f + 0.55 * (t - f)
    return np.array([m[0], 0.035, m[2]]), np.eye(3)


clip("rollFoot", "Faszienrolle Fußsohle", 12.0, [(0.0, STAND_W), (0.8, _ft), (2.0, _ft2), (3.2, _ft), (4.4, _ft2),
                                                (5.4, _ft)],
     space={"handL": "world", "handR": "world"}, props=[Prop("ball", _ball)], ground=False, mirror_half=True,
     yaw=1.2, cam_y=0.4)

# Brust (Rolle längs unter der Wirbelsäule): Rückenlage, Arme öffnen sich langsam zur Seite
_ch = stand(HOOK, root=(0.0, 0.24, 0.0), body=(0.0, -88.0, 0.0), footL=(0.15, ANKLE, 0.46), footR=(-0.15, ANKLE, 0.46),
            handL=(0.16, 0.62, -0.35), handR=(-0.16, 0.62, -0.35), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
            palmL=(0.0, 0.0), palmR=(0.0, 0.0), gripL=0.1, gripR=0.1)
_ch_open = stand(_ch, handL=(0.70, 0.12, -0.30), handR=(-0.70, 0.12, -0.30), elbowL=(0.3, -1.0, 0.0),
                 elbowR=(-0.3, -1.0, 0.0))
clip("rollerChest", "Brustdehnung auf der Faszienrolle", 12.0, [
    (0.0, _ch), (1.0, _ch), (4.0, _ch_open), (8.5, _ch_open), (11.0, _ch),
], space=FLOOR_SPACE, props=[Prop("roller", lambda w, p: (np.array([0.0, R, -0.30]), rot_x(90.0)))],
    fit_root=False, ground=False, yaw=1.35, cam_y=0.35)
