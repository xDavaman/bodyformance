"""Prüft, dass jedes Gerät, das die App lädt (GymModels.make / place), als Gym_<Name>.usdz und in tools/geraete existiert."""

import re
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "FitScan"


def _extern() -> set[str]:
    """Modelle, die ein anderes Werkzeug unter tools/ baut (z. B. Gym_Halle.usdz aus tools/halle).
    Erkannt am Dateinamen Gym_<Name>.usdz in einem Skript außerhalb von tools/geraete."""
    names = set()
    for f in (ROOT / "tools").rglob("*.py"):
        if "geraete" in f.parts:
            continue
        names |= set(re.findall(r"Gym_(\w+)\.usdz", f.read_text(errors="ignore")))
    return names


def _used() -> set[str]:
    names = set()
    for f in APP.glob("*.swift"):
        names |= set(re.findall(r'(?:GymModels\.make|place)\("(\w+)"', f.read_text()))
    return names


def _defined() -> set[str]:
    src = (ROOT / "tools" / "geraete" / "modelle.py").read_text()
    block = src[src.index("MODELLE = {"):]
    return set(re.findall(r'"(\w+)":', block))


def test_app_modelle_vorhanden():
    used = _used()
    assert used, "keine Geräte in der App gefunden"
    missing = sorted(n for n in used if not (APP / f"Gym_{n}.usdz").exists())
    assert not missing, f"fehlende usdz-Dateien: {missing}"
    unknown = sorted(used - _defined() - _extern())
    assert not unknown, f"nicht in tools/geraete/modelle.py: {unknown}"


def test_modelle_bauen():
    pytest.importorskip("numpy")
    import sys
    sys.path.insert(0, str(ROOT / "tools"))
    from geraete.modelle import MODELLE
    for name, f in MODELLE.items():
        m = f()
        assert m.triangles() > 0, name
