"""Prüft, dass jede Übungsvariante eine Bewegung hat, die in BodyMotions.swift und FitScan_Motions.bin existiert."""

import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "FitScan"


def _cases() -> set[str]:
    return set(re.findall(r"^    case (\w+)$", (APP / "BodyMotions.swift").read_text(), re.M))


def _library() -> set[str]:
    return set(re.findall(r"^        \.(\w+): Motion\(", (APP / "BodyMotions.swift").read_text(), re.M))


def _clips() -> set[str]:
    d = (APP / "FitScan_Motions.bin").read_bytes()
    magic, nb, nm = struct.unpack_from("<III", d, 0)
    assert magic == 0x314D5346
    o, names = 12, set()
    for _ in range(nm):
        names.add(d[o:o + 24].split(b"\0")[0].decode())
        nf, _, npr = struct.unpack_from("<IfI", d, o + 24)
        o += 36 + nf * nb * 14 + nf * npr * 14
    assert o == len(d)
    return names


def _variants() -> set[str]:
    src = (APP / "BodyRig.swift").read_text()
    table = src[src.index("static let variants"):src.index("/// Bewegung passend zum Übungsnamen")]
    return set(re.findall(r'"[^"]*": \.(\w+)', table))


def test_jede_bewegung_hat_daten_und_beschreibung():
    cases = _cases()
    assert cases <= _library()
    assert cases <= _clips()


def test_varianten_zeigen_auf_vorhandene_bewegungen():
    assert _variants() <= _cases()


def test_uebungsfamilien_nutzen_vorhandene_bewegungen():
    db = (APP / "ExerciseDB.swift").read_text()
    fams = db.split('static let families = #"""\n')[1].split('"""#')[0].strip().split("\n")
    motions = {f.split("|")[4] for f in fams}
    assert motions <= _cases()
