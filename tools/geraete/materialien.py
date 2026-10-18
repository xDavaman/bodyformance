"""Materialien der Geräte. Farben in sRGB (0–1), rau = Rauheit, metall = Metallanteil, lack = Klarlack."""


def linear(c):
    return tuple((x / 12.92) if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in c)


MATERIALIEN = {
    # Rahmen: schwarz pulverbeschichteter Stahl, Akzente in Markenrot
    "rahmen": {"farbe": (0.075, 0.075, 0.08), "rau": 0.42, "metall": 0.15, "lack": 0.3},
    "rahmen_rot": {"farbe": (0.70, 0.09, 0.07), "rau": 0.38, "metall": 0.1, "lack": 0.4},
    "rahmen_grau": {"farbe": (0.30, 0.31, 0.33), "rau": 0.45, "metall": 0.2},
    "chrom": {"farbe": (0.86, 0.86, 0.88), "rau": 0.12, "metall": 1.0},
    "stahl": {"farbe": (0.66, 0.67, 0.69), "rau": 0.32, "metall": 1.0},
    "raendel": {"farbe": (0.52, 0.53, 0.55), "rau": 0.6, "metall": 1.0},
    "gummi": {"farbe": (0.035, 0.035, 0.037), "rau": 0.85},
    "polster": {"farbe": (0.055, 0.055, 0.058), "rau": 0.5, "lack": 0.15},
    "naht": {"farbe": (0.16, 0.16, 0.17), "rau": 0.6},
    "griff": {"farbe": (0.06, 0.06, 0.06), "rau": 0.9},
    "scheibe_eisen": {"farbe": (0.12, 0.12, 0.13), "rau": 0.55, "metall": 0.6},
    "stapel": {"farbe": (0.20, 0.205, 0.215), "rau": 0.4, "metall": 0.55},
    "seil": {"farbe": (0.04, 0.04, 0.045), "rau": 0.4},
    "kunststoff": {"farbe": (0.10, 0.10, 0.11), "rau": 0.35, "lack": 0.2},
    "kunststoff_hell": {"farbe": (0.55, 0.56, 0.58), "rau": 0.35},
    "display": {"farbe": (0.02, 0.025, 0.03), "rau": 0.08, "lack": 1.0},
    "display_licht": {"farbe": (0.35, 0.75, 0.95), "rau": 0.3, "leucht": True},
    "band": {"farbe": (0.08, 0.08, 0.085), "rau": 0.95},
    "guss": {"farbe": (0.09, 0.09, 0.095), "rau": 0.6, "metall": 0.4},
    "bumper_rot": {"farbe": (0.72, 0.10, 0.08), "rau": 0.7},
    "bumper_blau": {"farbe": (0.08, 0.25, 0.62), "rau": 0.7},
    "bumper_gelb": {"farbe": (0.90, 0.68, 0.06), "rau": 0.7},
    "bumper_gruen": {"farbe": (0.10, 0.48, 0.20), "rau": 0.7},
    "bumper_schwarz": {"farbe": (0.06, 0.06, 0.06), "rau": 0.75},
    "kb_rosa": {"farbe": (0.86, 0.36, 0.52), "rau": 0.45, "lack": 0.3},
    "kb_blau": {"farbe": (0.18, 0.40, 0.78), "rau": 0.45, "lack": 0.3},
    "kb_gelb": {"farbe": (0.92, 0.74, 0.12), "rau": 0.45, "lack": 0.3},
    "kb_lila": {"farbe": (0.50, 0.30, 0.66), "rau": 0.45, "lack": 0.3},
    "kb_gruen": {"farbe": (0.22, 0.58, 0.30), "rau": 0.45, "lack": 0.3},
    "kb_orange": {"farbe": (0.90, 0.48, 0.12), "rau": 0.45, "lack": 0.3},
    "kb_rot": {"farbe": (0.80, 0.16, 0.12), "rau": 0.45, "lack": 0.3},
    "gurt_gelb": {"farbe": (0.93, 0.72, 0.10), "rau": 0.8},
    "ball_orange": {"farbe": (0.86, 0.45, 0.14), "rau": 0.8},
    "ball_gruen": {"farbe": (0.25, 0.55, 0.28), "rau": 0.8},
    "ball_lila": {"farbe": (0.42, 0.28, 0.58), "rau": 0.8},
    "loch": {"farbe": (0.012, 0.012, 0.012), "rau": 0.9},
    "aufkleber": {"farbe": (0.85, 0.86, 0.88), "rau": 0.4},
}
