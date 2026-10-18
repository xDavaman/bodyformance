"""python3 -m geraete backen [Name …]   → FitScan/Gym_<Name>.usdz
python3 -m geraete vorschau [Ziel]     → .glb-Dateien für die Browser-Vorschau (Standard: tools/geraete/vorschau)"""
import sys
from pathlib import Path

from .export import glb, usdz
from .modelle import MODELLE

ROOT = Path(__file__).resolve().parents[2]


def main(argv):
    if not argv or argv[0] not in ("backen", "vorschau"):
        print(__doc__)
        return 1
    cmd, rest = argv[0], argv[1:]
    if cmd == "vorschau":
        out = Path(rest[0]) if rest else Path(__file__).parent / "vorschau"
        out.mkdir(parents=True, exist_ok=True)
        for name, f in MODELLE.items():
            glb(f(), out / f"Gym_{name}.glb")
            print(name)
        return 0
    names = rest or list(MODELLE)
    for name in names:
        m = MODELLE[name]()
        path = ROOT / "FitScan" / f"Gym_{name}.usdz"
        usdz(m, f"Gym_{name}", path)
        print(f"{name}: {m.triangles()} Dreiecke, {path.stat().st_size // 1024} KB")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
