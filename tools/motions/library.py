"""Bewegungsbibliothek: jede Mobility-, Yoga-, Pilates-, Dehn- und Reha-Übung als Folge von Schlüsselhaltungen.

Koordinaten: Meter, Y oben, die Figur schaut nach +Z, linke Seite +X. Hände standardmäßig im Raum des Brustkorbs
(Ursprung Mitte Brustwirbel, Schultern bei etwa x = ±0.20, y = +0.06), Füße in der Welt (Sprunggelenk 8 cm über
dem Boden, wenn der Fuß flach steht). Die Höhe des Beckens stellt das Backen automatisch so ein, dass der tiefste
Punkt den Boden berührt. Rückenlage: Kopf bei -Z (wie auf der Hantelbank), Bauchlage und Vierfüßler: Kopf bei +Z.
"""

from __future__ import annotations

import numpy as np

from .clip import Clip, Prop
from .rig import axis_angle, normalize

CLIPS: list[Clip] = []

ARMS_DOWN = {"handL": (0.24, -0.47, 0.05), "handR": (-0.24, -0.47, 0.05)}
ANKLE = 0.08


def clip(key, title, period, keys, **kw) -> Clip:
    c = Clip(key=key, title=title, keys=keys, period=period, **kw)
    CLIPS.append(c)
    return c


def both(fmt: str, left, right=None, mirror=True) -> dict:
    """Gleicher Kanal für beide Seiten; mirror spiegelt x (und Drehrichtungen der Sohle)."""
    if right is None:
        if isinstance(left, tuple) and mirror and len(left) == 3:
            right = (-left[0], left[1], left[2])
        else:
            right = left
    return {fmt.format("L"): left, fmt.format("R"): right}


def P(**kw) -> dict:
    """Haltung aus Schlüsselwörtern; erlaubt Gruppen wie arms=..., legs=... über dict-Entpacken."""
    out = {}
    for k, v in kw.items():
        if isinstance(v, dict):
            out.update(v)
        else:
            out[k] = v
    return out


def stand(*parts: dict, **kw) -> dict:
    base = {"root": (0.0, 0.93, 0.0), "body": (0.0, 0.0, 0.0), "turn": 0.0, "spine": (0.0, 0.0, 0.0), "neck": (0.0, 0.0, 0.0),
            "footL": (0.12, ANKLE, -0.01), "footR": (-0.12, ANKLE, -0.01),
            "soleL": (1.0, 6.0, 0.0), "soleR": (1.0, -6.0, 0.0),
            "kneeL": (0.15, 0.0, 1.0), "kneeR": (-0.15, 0.0, 1.0),
            "handL": (0.24, -0.47, 0.05), "handR": (-0.24, -0.47, 0.05),
            "elbowL": (0.4, -0.2, -1.0), "elbowR": (-0.4, -0.2, -1.0),
            "palmL": (0.0, 0.0), "palmR": (0.0, 0.0), "gripL": 0.15, "gripR": 0.15,
            "clavL": (0.0, 0.0), "clavR": (0.0, 0.0), "ankleL": 0.0, "ankleR": 0.0, "toesL": 0.0, "toesR": 0.0,
            "wristL": (0.0, 0.0), "wristR": (0.0, 0.0)}
    for part in parts:
        base.update(part)
    base.update(P(**kw))
    return base


WORLD_HANDS = {"handL": "world", "handR": "world"}

# =========================================================================== Yoga

# Dreieck (Trikonasana): breiter Stand, vorderer (linker) Fuß nach außen, Oberkörper kippt seitlich über das Bein
_tri = P(root=(0.08, 0.86, 0.0), body=(-8.0, 0.0, 38.0), spine=(0.0, 28.0, -12.0), neck=(-5.0, 0.0, 0.0),
         footL=(0.52, ANKLE, 0.02), footR=(-0.45, ANKLE, -0.02), soleL=(1.0, 88.0, 0.0), soleR=(1.0, 15.0, 0.0),
         kneeL=(1.0, 0.0, 0.2), kneeR=(-0.3, 0.0, 1.0),
         handL=(0.50, 0.32, 0.03), handR=(0.42, 1.78, -0.04), elbowL=(0.0, 0.0, -1.0), elbowR=(0.0, 0.0, -1.0),
         palmL=(0.0, 0.0), gripL=0.05, gripR=0.05)
_tri_stance = P(root=(0.04, 0.88, 0.0), footL=(0.52, ANKLE, 0.02), footR=(-0.45, ANKLE, -0.02),
                soleL=(1.0, 88.0, 0.0), soleR=(1.0, 15.0, 0.0), kneeL=(1.0, 0.0, 0.2), kneeR=(-0.3, 0.0, 1.0),
                handL=(0.80, 1.42, 0.0), handR=(-0.80, 1.42, 0.0), elbowL=(0.0, -0.3, -1.0), elbowR=(0.0, -0.3, -1.0),
                gripL=0.05, gripR=0.05)
clip("triangle", "Yoga: Dreieck", 12.0, [
    (0.0, stand(_tri_stance)),
    (2.0, stand(_tri_stance)),
    (4.5, stand(_tri)),
    (8.5, stand(_tri, spine=(0.0, 31.0, -14.0))),
    (10.5, stand(_tri_stance)),
], space=WORLD_HANDS, yaw=0.15, cam_y=0.85)


# Bausteine für Boden-Haltungen (Hände und Füße in der Welt, Kopf bei +Z)
FLOOR = 0.065  # Handgelenk über dem Boden bei flacher Hand
HANDS_FLAT = {"palmL": (1.0, 0.0), "palmR": (1.0, 0.0), "gripL": 0.05, "gripR": 0.05}


def hands(x, y, z, **kw) -> dict:
    d = {"handL": (x, y, z), "handR": (-x, y, z)}
    d.update(kw)
    return d


def feet(x, y, z, **kw) -> dict:
    d = {"footL": (x, y, z), "footR": (-x, y, z)}
    d.update(kw)
    return d


def flat_feet(heading=6.0) -> dict:
    return {"soleL": (1.0, heading, 0.0), "soleR": (1.0, -heading, 0.0), "ankleL": 0.0, "ankleR": 0.0}


def on_toes(toes=70.0) -> dict:
    return {"soleL": (0.0, 0.0, 0.0), "soleR": (0.0, 0.0, 0.0), "ankleL": -5.0, "ankleR": -5.0,
            "toesL": toes, "toesR": toes}


def foot_tops(ankle=75.0) -> dict:
    """Fußrücken liegt auf (Bauchlage, Kniestand): Füße gestreckt."""
    return {"soleL": (0.0, 0.0, 0.0), "soleR": (0.0, 0.0, 0.0), "ankleL": ankle, "ankleR": ankle,
            "toesL": 0.0, "toesR": 0.0}


KNEES_DOWN = {"kneeL": (0.1, -1.0, 0.0), "kneeR": (-0.1, -1.0, 0.0)}
KNEES_UP = {"kneeL": (0.1, 1.0, 0.0), "kneeR": (-0.1, 1.0, 0.0)}
KNEES_FWD = {"kneeL": (0.15, 0.0, 1.0), "kneeR": (-0.15, 0.0, 1.0)}
ELBOWS_BACK = {"elbowL": (0.3, 0.0, -1.0), "elbowR": (-0.3, 0.0, -1.0)}
ELBOWS_OUT = {"elbowL": (1.0, 0.0, -0.3), "elbowR": (-1.0, 0.0, -0.3)}

MOUNTAIN = stand(hands(0.23, 0.86, 0.05), ELBOWS_BACK)
ARMS_UP = stand(hands(0.16, 2.02, 0.02), {"elbowL": (1.0, 0.0, 0.0), "elbowR": (-1.0, 0.0, 0.0)},
                gripL=0.05, gripR=0.05)
FOLD = stand(hands(0.17, FLOOR, 0.30, **HANDS_FLAT), ELBOWS_BACK, root=(0.0, 0.91, -0.16),
             body=(0.0, 92.0, 0.0), spine=(48.0, 0.0, 0.0), neck=(15.0, 0.0, 0.0),
             kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0))
HALF_LIFT = stand(hands(0.16, 0.45, 0.30), ELBOWS_BACK, root=(0.0, 0.89, -0.08), body=(0.0, 75.0, 0.0),
                  spine=(-8.0, 0.0, 0.0), neck=(-20.0, 0.0, 0.0), gripL=0.05, gripR=0.05)
PLANK = stand(hands(0.20, FLOOR, 0.42, **HANDS_FLAT), {"elbowL": (0.3, 0.0, -1.0), "elbowR": (-0.3, 0.0, -1.0)},
              feet(0.10, 0.17, -1.02), on_toes(), KNEES_DOWN, root=(0.0, 0.50, -0.12), body=(0.0, 73.0, 0.0),
              neck=(-10.0, 0.0, 0.0))
CHATURANGA = stand(PLANK, feet(0.10, 0.16, -1.06), root=(0.0, 0.29, -0.06), body=(0.0, 84.0, 0.0),
                   elbowL=(0.15, 0.3, -1.0), elbowR=(-0.15, 0.3, -1.0), neck=(-15.0, 0.0, 0.0))
UP_DOG = stand(PLANK, feet(0.10, 0.05, -0.92), foot_tops(), hands(0.20, FLOOR, 0.40, **HANDS_FLAT),
               root=(0.0, 0.30, -0.14), body=(0.0, 50.0, 0.0), spine=(-30.0, 0.0, 0.0), neck=(-25.0, 0.0, 0.0))
DOWN_DOG = stand(hands(0.22, FLOOR, 0.52, **HANDS_FLAT), {"elbowL": (1.0, 0.3, 0.0), "elbowR": (-1.0, 0.3, 0.0)},
                 feet(0.12, ANKLE, -0.58), flat_feet(0.0), KNEES_FWD, root=(0.0, 0.84, -0.18),
                 body=(0.0, 128.0, 0.0), spine=(-8.0, 0.0, 0.0), neck=(5.0, 0.0, 0.0))

SUN_SPACE = WORLD_HANDS
# Übergänge, damit Knie und Füße beim Überrollen nicht durch den Boden gehen
CHAT_TO_UP = stand(UP_DOG, feet(0.10, 0.21, -1.0), foot_tops(35.0), root=(0.0, 0.30, -0.18), body=(0.0, 68.0, 0.0),
                   spine=(-15.0, 0.0, 0.0), neck=(-20.0, 0.0, 0.0))
UP_ROLL = stand(UP_DOG, feet(0.10, 0.21, -0.95), foot_tops(35.0), root=(0.0, 0.40, -0.18), body=(0.0, 70.0, 0.0),
                spine=(-10.0, 0.0, 0.0))
UP_TO_DOWN = stand(PLANK, feet(0.10, 0.15, -0.88), hands(0.21, FLOOR, 0.46, **HANDS_FLAT),
                   root=(0.0, 0.62, -0.20), body=(0.0, 95.0, 0.0))
clip("sunA", "Yoga: Sonnengruß A", 18.0, [
    (0.0, MOUNTAIN), (1.5, ARMS_UP), (3.2, FOLD), (4.4, HALF_LIFT), (5.4, FOLD),
    (6.2, stand(FOLD, footR=(-0.10, 0.17, -0.70), soleR=(0.0, 0.0, 0.0), toesR=70.0, kneeR=(-0.1, -1.0, 0.3),
                root=(0.0, 0.70, -0.25), body=(0.0, 75.0, 0.0))),
    (7.0, PLANK), (8.0, CHATURANGA), (8.5, CHAT_TO_UP), (9.0, UP_DOG), (9.4, UP_ROLL), (9.8, UP_TO_DOWN), (10.4, DOWN_DOG),
    (12.6, DOWN_DOG),
    (13.6, stand(DOWN_DOG, footL=(0.12, 0.25, 0.10), soleL=(0.0, 0.0, 0.0), kneeL=(0.1, 0.2, 1.0),
                 root=(0.0, 0.80, -0.20), body=(0.0, 105.0, 0.0))),
    (14.3, FOLD), (15.2, HALF_LIFT), (16.0, FOLD), (17.2, ARMS_UP),
], space=SUN_SPACE, yaw=1.25, cam_y=0.7)

CHAIR_ARMS = stand(hands(0.16, 1.75, 0.45), {"elbowL": (1.0, 0.0, 0.0), "elbowR": (-1.0, 0.0, 0.0)},
                   root=(0.0, 0.68, -0.18), body=(0.0, 25.0, 0.0), spine=(10.0, 0.0, 0.0), gripL=0.05, gripR=0.05,
                   kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0))
WARRIOR1_L = stand(hands(0.15, 2.0, -0.05), {"elbowL": (1.0, 0.0, 0.0), "elbowR": (-1.0, 0.0, 0.0)},
                   footL=(0.12, ANKLE, 0.45), footR=(-0.14, ANKLE, -0.62), soleL=(1.0, 0.0, 0.0),
                   soleR=(1.0, -45.0, 0.0), kneeL=(0.1, 0.0, 1.0), kneeR=(-0.4, 0.0, 1.0),
                   root=(0.0, 0.70, -0.05), body=(8.0, 0.0, 0.0), spine=(-10.0, 0.0, 0.0), neck=(-10.0, 0.0, 0.0),
                   gripL=0.05, gripR=0.05)
WARRIOR1_R = stand(WARRIOR1_L, footL=(0.14, ANKLE, -0.62), footR=(-0.12, ANKLE, 0.45), soleL=(1.0, 45.0, 0.0),
                   soleR=(1.0, 0.0, 0.0), kneeL=(0.4, 0.0, 1.0), kneeR=(-0.1, 0.0, 1.0), body=(-8.0, 0.0, 0.0))
clip("sunB", "Yoga: Sonnengruß B", 24.0, [
    (0.0, MOUNTAIN), (1.6, CHAIR_ARMS), (3.4, FOLD), (4.4, HALF_LIFT), (5.4, FOLD), (6.4, PLANK), (7.4, CHATURANGA),
    (7.8, CHAT_TO_UP), (8.3, UP_DOG), (8.7, UP_ROLL), (9.1, UP_TO_DOWN), (9.6, DOWN_DOG),
    (11.0, stand(DOWN_DOG, footL=(0.12, 0.30, 0.05), soleL=(0.0, 0.0, 0.0), kneeL=(0.1, 0.2, 1.0),
                 root=(0.0, 0.78, -0.25), body=(0.0, 100.0, 0.0))),
    (12.4, WARRIOR1_L), (14.4, WARRIOR1_L),
    (15.8, stand(FOLD, footL=(0.12, 0.17, -0.30), soleL=(0.0, 0.0, 0.0), toesL=70.0, kneeL=(0.1, -1.0, 0.3),
                 footR=(-0.14, ANKLE, -0.62), root=(0.0, 0.62, -0.25), body=(0.0, 80.0, 0.0))),
    (16.4, PLANK), (17.2, CHATURANGA), (17.6, CHAT_TO_UP), (18.0, UP_DOG), (18.4, UP_ROLL), (18.8, UP_TO_DOWN),
    (19.4, DOWN_DOG), (20.6, DOWN_DOG), (21.4, FOLD), (22.6, CHAIR_ARMS),
], space=SUN_SPACE, yaw=1.25, cam_y=0.7)

# Krieger III: Stand auf links, Oberkörper und rechtes Bein waagerecht, Arme nach vorn
W3 = stand(root=(0.02, 0.90, 0.05), body=(0.0, 84.0, 0.0), spine=(0.0, 0.0, 0.0), neck=(-12.0, 0.0, 0.0),
           footL=(0.07, ANKLE, 0.06), footR=(-0.10, 0.93, -0.88), soleR=(0.0, 0.0, 0.0), ankleR=10.0,
           kneeL=(0.1, 0.0, 1.0), kneeR=(-0.1, -1.0, 0.0),
           handL=(0.13, 0.62, 0.06), handR=(-0.13, 0.62, 0.06), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0),
           gripL=0.05, gripR=0.05)
clip("warrior3", "Yoga: Krieger III", 12.0, [
    (0.0, stand(hands(0.13, 0.62, 0.06), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0), gripL=0.05, gripR=0.05)),
    (1.5, stand(hands(0.13, 0.62, 0.06), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0), gripL=0.05, gripR=0.05,
                footL=(0.07, ANKLE, 0.06), footR=(-0.10, ANKLE, -0.45), soleR=(1.0, 0.0, 25.0))),
    (4.0, W3), (8.5, stand(W3, footR=(-0.10, 0.97, -0.88))),
    (10.5, stand(hands(0.13, 0.62, 0.06), elbowL=(1.0, 0.0, 0.0), elbowR=(-1.0, 0.0, 0.0), gripL=0.05, gripR=0.05,
                 footL=(0.07, ANKLE, 0.06), footR=(-0.10, ANKLE, -0.45), soleR=(1.0, 0.0, 25.0))),
], yaw=1.3, cam_y=0.9)

# Halber Mond: Stand auf links, Oberkörper seitlich waagerecht, linke Hand am Boden, rechtes Bein und Arm oben
HALF_MOON = stand(root=(0.10, 0.92, 0.0), body=(-5.0, 0.0, 82.0), spine=(0.0, 14.0, -25.0), neck=(-5.0, 0.0, 0.0),
                  footL=(0.20, ANKLE, 0.0), soleL=(1.0, 80.0, 0.0), kneeL=(1.0, 0.0, 0.3),
                  footR=(-0.78, 0.98, -0.02), soleR=(0.0, 0.0, 0.0), ankleR=-5.0, kneeR=(0.0, 0.0, 1.0),
                  handL=(0.62, FLOOR + 0.05, 0.22), handR=(0.62, 1.72, -0.05), palmL=(1.0, 90.0),
                  elbowL=(0.0, 0.0, -1.0), elbowR=(0.0, 0.0, -1.0), gripL=0.05, gripR=0.05)
TRI_START = stand(_tri_stance)
clip("halfMoon", "Yoga: Halber Mond", 13.0, [
    (0.0, TRI_START), (1.5, stand(_tri)), (3.5, stand(_tri, root=(0.12, 0.80, 0.0), kneeL=(1.0, 0.0, 0.3))),
    (5.5, HALF_MOON), (9.5, stand(HALF_MOON, footR=(-0.80, 1.02, -0.02))), (11.2, stand(_tri)),
], space=WORLD_HANDS, yaw=0.12, cam_y=0.85)


# =========================================================================== Grundlagen am Boden

# Rückenlage: Kopf bei -Z, Gesicht nach oben
SUPINE = stand(hands(0.27, 0.05, 0.02, **HANDS_FLAT), {"elbowL": (1.0, 0.3, 0.0), "elbowR": (-1.0, 0.3, 0.0)},
               feet(0.11, 0.07, 0.84), KNEES_UP, root=(0.0, 0.11, 0.0), body=(0.0, -90.0, 0.0),
               soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=25.0, ankleR=25.0)
# Rückenlage mit aufgestellten Füßen
HOOK = stand(SUPINE, feet(0.13, ANKLE, 0.42), flat_feet(0.0), {"kneeL": (0.2, 1.0, 0.3), "kneeR": (-0.2, 1.0, 0.3)})
# Bauchlage: Kopf bei +Z, Stirn auf dem Boden
PRONE = stand(hands(0.30, 0.05, -0.02, **HANDS_FLAT), {"elbowL": (1.0, 0.3, 0.0), "elbowR": (-1.0, 0.3, 0.0)},
              feet(0.11, 0.10, -0.84), foot_tops(70.0), KNEES_DOWN, root=(0.0, 0.20, 0.0), body=(0.0, 90.0, 0.0),
              neck=(-10.0, 0.0, 0.0))
# Vierfüßlerstand: Hände unter den Schultern, Knie unter den Hüften
QUAD = stand(hands(0.19, FLOOR, 0.30, **HANDS_FLAT), ELBOWS_BACK, feet(0.11, 0.06, -0.62), foot_tops(70.0),
             KNEES_DOWN, root=(0.0, 0.54, -0.22), body=(0.0, 88.0, 0.0), neck=(-15.0, 0.0, 0.0))
# Langsitz: Beine gestreckt nach vorn
SEATED = stand(hands(0.27, FLOOR, -0.08, **HANDS_FLAT), ELBOWS_BACK, feet(0.12, 0.07, 0.86), KNEES_UP,
               soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleL=15.0, ankleR=15.0,
               root=(0.0, 0.13, 0.0), body=(0.0, -5.0, 0.0))
# Kniestand aufrecht
KNEEL = stand(hands(0.24, 0.40, 0.04), ELBOWS_BACK, feet(0.11, 0.06, -0.48), foot_tops(70.0), KNEES_DOWN,
              root=(0.0, 0.52, 0.0), body=(0.0, 0.0, 0.0))

FLOOR_SPACE = WORLD_HANDS

# =========================================================================== Yoga (weiter)

# Taube: linkes Schienbein quer vorn, rechtes Bein lang nach hinten; aufrecht, dann nach vorn ablegen
PIGEON_UP = stand(hands(0.27, FLOOR, 0.12, **HANDS_FLAT), ELBOWS_BACK,
                  footL=(-0.12, 0.07, 0.24), kneeL=(1.0, -0.3, 0.6), soleL=(0.0, 0.0, 0.0), ankleL=20.0,
                  footR=(-0.16, 0.06, -0.78), kneeR=(-0.1, -1.0, 0.0), soleR=(0.0, 0.0, 0.0), ankleR=75.0,
                  root=(0.0, 0.24, 0.0), body=(0.0, 8.0, 0.0), spine=(-8.0, 0.0, 0.0), neck=(-5.0, 0.0, 0.0))
PIGEON_FOLD = stand(PIGEON_UP, hands(0.20, FLOOR, 0.78, **HANDS_FLAT), {"elbowL": (1.0, 0.5, 0.0), "elbowR": (-1.0, 0.5, 0.0)},
                    body=(0.0, 38.0, 0.0), spine=(40.0, 0.0, 0.0), neck=(15.0, 0.0, 0.0))
clip("pigeon", "Yoga: Taube", 14.0, [
    (0.0, PIGEON_UP), (2.0, PIGEON_UP), (5.0, PIGEON_FOLD), (10.0, stand(PIGEON_FOLD, spine=(44.0, 0.0, 0.0))),
    (12.5, PIGEON_UP),
], space=FLOOR_SPACE, yaw=0.9, cam_y=0.35)

# Pflug: aus der Rückenlage Beine über den Kopf, Zehen hinter dem Kopf auf dem Boden
LEGS_UP = stand(SUPINE, feet(0.10, 0.88, 0.05), {"kneeL": (0.1, 0.0, -1.0), "kneeR": (-0.1, 0.0, -1.0)},
                ankleL=10.0, ankleR=10.0)
PLOW = stand(SUPINE, hands(0.15, 0.05, 0.20, **HANDS_FLAT), feet(0.11, 0.13, -1.12),
             {"kneeL": (0.1, 1.0, 0.0), "kneeR": (-0.1, 1.0, 0.0)}, soleL=(0.0, 0.0, 0.0), soleR=(0.0, 0.0, 0.0),
             ankleL=-10.0, ankleR=-10.0, toesL=40.0, toesR=40.0,
             root=(0.0, 0.70, -0.45), body=(0.0, -172.0, 0.0), spine=(15.0, 0.0, 0.0), neck=(70.0, 0.0, 0.0))
PLOW_ROLL = stand(LEGS_UP, feet(0.10, 0.75, -0.60), root=(0.0, 0.45, -0.30), body=(0.0, -135.0, 0.0),
                  spine=(8.0, 0.0, 0.0), neck=(35.0, 0.0, 0.0))
clip("plow", "Yoga: Pflug", 14.0, [
    (0.0, SUPINE), (1.5, SUPINE), (3.5, LEGS_UP), (5.0, PLOW_ROLL), (6.5, PLOW), (10.0, PLOW), (11.5, PLOW_ROLL),
    (12.8, LEGS_UP),
], space=FLOOR_SPACE, yaw=1.35, cam_y=0.4)


# =========================================================================== Seitenwechsel

_VEC = ("hand", "foot", "elbow", "knee")


def mirror(p: dict) -> dict:
    """Spiegelbild einer Haltung (links ↔ rechts), damit jede einseitige Übung nur einmal beschrieben wird."""
    out = {}
    for k, v in p.items():
        side = k[-1] if k[-1] in "LR" and k[:-1] in ("hand", "foot", "elbow", "knee", "clav", "palm", "wrist", "grip",
                                                     "sole", "ankle", "toes") else None
        name = k[:-1] if side else k
        dst = (name + ("R" if side == "L" else "L")) if side else k
        if name in _VEC:
            v = (-v[0], v[1], v[2])
        elif name == "root":
            v = (-v[0], v[1], v[2])
        elif name == "body":
            v = (-v[0], v[1], -v[2])
        elif name == "turn":
            v = -v
        elif name in ("spine", "neck"):
            v = (v[0], -v[1], -v[2])
        elif name == "palm":
            v = (v[0], -v[1])
        elif name == "wrist":
            v = (v[0], -v[1])
        elif name == "sole":
            v = (v[0], -v[1], v[2])
        out[dst] = v
    return out


def mirror_space(space: dict) -> dict:
    return {(k[:-1] + ("R" if k[-1] == "L" else "L")) if k[-1] in "LR" else k: v for k, v in space.items()}


def sides(base: dict, left: dict, half: float = 8.0, move: float = 0.28, hold: float = 0.50,
          extra: list | None = None, via: dict | None = None, back: dict | None = None) -> list:
    """Schlüssel für eine Halteübung auf der linken Seite (für Clip(mirror_half=True), rechts entsteht gespiegelt):
    Grundhaltung → (via) → Seite → halten → zurück. Zeiten als Anteile von half (halbe Periode).
    extra: zusätzliche (Anteil der Haltezeit, Haltung) während des Haltens.
    """
    a = 0.06 * half
    t_in, t_hold = move * half, hold * half
    keys = [(0.0, base), (a, base)]
    if via is not None:
        keys.append((a + 0.5 * t_in, via))
    keys.append((a + t_in, left))
    for frac, p in (extra or []):
        keys.append((a + t_in + frac * t_hold, p))
    keys.append((a + t_in + t_hold, left))
    if back is not None:
        keys.append(((a + t_in + t_hold + half) / 2, back))
    return keys


def reps(base: dict, peak: dict, period: float, n: int = 2, rest: float = 0.15, up: float = 0.35) -> list:
    """n gleichmäßige Wiederholungen base → peak → base innerhalb der Periode."""
    keys = []
    T = period / n
    for k in range(n):
        t0 = k * T
        keys += [(t0, base), (t0 + rest * T, base), (t0 + (rest + up) * T, peak),
                 (t0 + (rest + up + 0.1) * T, peak)]
    return keys
from . import lib_oben  # noqa: E402,F401
from . import lib_boden  # noqa: E402,F401
from . import lib_beine  # noqa: E402,F401
from . import lib_rolle  # noqa: E402,F401
from . import lib_aktiv  # noqa: E402,F401
