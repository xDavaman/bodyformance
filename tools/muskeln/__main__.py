"""Aufruf (im Ordner tools): python -m muskeln backen  |  python -m muskeln vorschau [ZIELORDNER]

backen:   UV-Abwicklung in FitScan/FitScan_Skin.usdz und Muskelkarte FitScan/FitScan_Muscles.bin schreiben
vorschau: Bilder einiger Übungen (vorn/hinten) nach tools/muskeln/vorschau/ (oder ZIELORDNER)
Braucht: python3 -m pip install usd-core numpy pillow xatlas
"""
import sys
from pathlib import Path

BEISPIELE = {
    "bizepscurl": (["biceps"], ["forearms", "shoulders"]),
    "kniebeuge": (["quads", "glutes"], ["hamstrings", "adductors", "lowerBack", "calves"]),
    "bankdruecken": (["chest", "triceps"], ["shoulders"]),
    "klimmzug": (["lats", "biceps"], ["traps", "forearms", "abs"]),
    "crunch": (["abs"], ["hipFlexors", "neck"]),
}


def main(args):
    if not args or args[0] not in ("backen", "vorschau"):
        print(__doc__)
        return
    if args[0] == "backen":
        from .karte import backen
        backen()
        return
    from .vorschau import tafel
    ziel = Path(args[1]) if len(args) > 1 else Path(__file__).resolve().parent / "vorschau"
    ziel.mkdir(parents=True, exist_ok=True)
    for name, (a, p) in BEISPIELE.items():
        tafel(a, p, name).save(ziel / f"{name}.jpg", quality=90)
        print("→", ziel / f"{name}.jpg")


main(sys.argv[1:])
