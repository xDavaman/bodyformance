"""Die neu gebauten Kraft- und Matten-Bewegungen liegen richtig: Füße am Boden oder auf der Bank, Hanteln in der Hand,
nichts im Boden. Braucht numpy (sonst übersprungen)."""

import sys
from pathlib import Path

import pytest

pytest.importorskip("numpy")
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

NEU = ["benchPress", "benchBar", "fly", "pullover", "skull", "pullup", "hang", "legRaise", "row", "rowBar", "rdl",
       "rdlBar", "kickback", "swing", "squatBar", "squatDb", "plank", "pushup", "bridge", "catCow", "wristRock",
       "childPose", "cobra", "downDog", "bwsRotate", "hipStretch", "warrior1", "warrior2", "wgs", "supTwist",
       "deadBug", "rollUp", "doorChest"]


def test_neue_bewegungen_ohne_fehler():
    from motions.pruefen import Koerper, analyse
    from motions.rig import skeleton
    from motions.szene import read_motions

    sk = skeleton()
    kp = Koerper(sk)
    alle = read_motions()
    falsch = {}
    for name in NEU:
        f = [x for x in analyse(sk, kp, alle[name]).fehler if not x.startswith("durch")]
        if f:
            falsch[name] = f
    assert not falsch


def test_gelenke_behalten_ihre_knochenlaenge():
    """Nur die Wurzel bewegt sich: die App setzt die Ortsteile aller Gelenke, wechselnde Ortsteile (früher beim
    Spiegeln einseitiger Übungen) ziehen Arme und Hände zu Bändern."""
    import numpy as np

    from motions.rig import skeleton
    from motions.szene import read_motions

    sk = skeleton()
    root = sk.i("root")
    falsch = {}
    for name, mo in read_motions().items():
        spread = np.linalg.norm(np.ptp(mo.pos, axis=0), axis=1)
        spread[root] = 0
        if spread.max() > 0.05:
            falsch[name] = sk.names[int(spread.argmax())]
    assert not falsch
