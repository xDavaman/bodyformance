"""Prüft, dass Muskelkarte (FitScan_Muscles.bin) und Texturkoordinaten der Figur zusammenpassen."""

import struct
import zipfile
import zlib
from pathlib import Path

APP = Path(__file__).resolve().parents[1] / "FitScan"
MUSKELN = 16  # Muscle.allCases in FitScan/Exercise.swift


def _karte():
    d = (APP / "FitScan_Muscles.bin").read_bytes()
    assert d[:4] == b"BFMK"
    version, n, laenge = struct.unpack_from("<III", d, 4)
    assert version == 1 and laenge == n * n * 8
    roh = zlib.decompress(d[16:], -15)
    assert len(roh) == laenge
    return n, roh


def test_karte_kennungen():
    _, roh = _karte()
    ids = set(roh[0::8]) | set(roh[4::8])
    assert max(ids) <= MUSKELN
    assert len(ids) == MUSKELN + 1  # alle Muskeln kommen vor, dazu Haut


def test_muscle_enum_passt():
    text = (APP / "Exercise.swift").read_text()
    kopf = text[text.index("enum Muscle"):text.index("var id: String")]
    assert kopf.count("= \"") == MUSKELN


def test_figur_hat_texturkoordinaten():
    usda = zipfile.ZipFile(APP / "FitScan_Skin.usdz").read("FitScan_Skin.usda").decode()
    assert "texCoord2f[] primvars:st = " in usda
    assert "int[] primvars:st:indices = " in usda
