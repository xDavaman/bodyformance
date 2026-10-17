"""Anatomie der Muskelkarte: welcher Muskel liegt wo, wie verlaufen die Fasern, wo sitzen die Sehnen.

Alles in der Ruhepose von FitScan_Skin.usdz (Meter, Y oben, Figur schaut nach +Z, linke Körperseite +X).
Die Grobzuordnung entspricht `MuscleSegmenter.label` in FitScan/MuscleSegmentation.swift (dort der Rückfall, wenn
die Muskelkarte fehlt). Hier kommen dazu: weiche Ränder, Muskelbäuche, Sehnen, Trennlinien zwischen Muskelköpfen
und der Faserverlauf. Alle Funktionen arbeiten auf vielen Punkten zugleich (numpy, Form (n, 3)).
"""

from __future__ import annotations

import numpy as np

# Reihenfolge wie `Muscle.allCases` in FitScan/Exercise.swift; Index + 1 = Kennung in der Karte, 0 = Haut
MUSKELN = ["chest", "lats", "traps", "shoulders", "biceps", "triceps", "forearms", "abs", "lowerBack",
           "glutes", "quads", "hamstrings", "adductors", "hipFlexors", "calves", "neck"]
ID = {m: i + 1 for i, m in enumerate(MUSKELN)}

# Gelenke der linken Seite (rechts gespiegelt), wie in MuscleSegmentation.swift
GELENK = {
    "ua": (0.20, 1.40, 0.00), "fa": (0.41, 1.21, 0.06), "ha": (0.53, 1.09, 0.27), "mid": (0.596, 0.992, 0.356),
    "th": (0.10, 0.90, 0.02), "sh": (0.16, 0.48, 0.00), "ft": (0.20, 0.08, -0.01), "toe": (0.205, 0.03, 0.10),
}
KOPF = np.array([0.0, 1.63, 0.03])


def _seite(p: np.ndarray) -> np.ndarray:
    """+1 für die linke Körperseite (x ≥ 0), sonst -1, als Spalte für Spiegelungen."""
    return np.where(p[:, 0] >= 0, 1.0, -1.0)[:, None]


def _j(name: str, s: np.ndarray) -> np.ndarray:
    return np.asarray(GELENK[name], float)[None, :] * np.concatenate([s, np.ones_like(s), np.ones_like(s)], 1)


def _pt(xyz, s: np.ndarray) -> np.ndarray:
    """Punkt der linken Seite, je Punkt auf dessen Körperseite gespiegelt."""
    return np.asarray(xyz, float)[None, :] * np.concatenate([s, np.ones_like(s), np.ones_like(s)], 1)


def _dot(a, b):
    return np.einsum("ij,ij->i", a, b)


def _norm(v):
    return v / (np.linalg.norm(v, axis=1, keepdims=True) + 1e-12)


def _kapsel(p, a, b, r):
    ab = b - a
    t = np.clip(_dot(p - a, ab) / np.maximum(_dot(ab, ab), 1e-9), 0, 1)
    return np.linalg.norm(p - (a + ab * t[:, None]), axis=1) - r


def _entlang(p, a, b):
    ab = b - a
    return _dot(p - a, ab) / np.maximum(_dot(ab, ab), 1e-9)


def knochen(p, a, b, s):
    """Lage um eine Knochenachse: t entlang, f nach vorn, o nach außen, m zur Mitte, w Winkel (0 = vorn, + = außen)."""
    axis = _norm(b - a)
    ln = np.linalg.norm(b - a, axis=1)
    t = _dot(p - a, axis) / ln
    rad = p - a - axis * (t * ln)[:, None]
    r = _norm(rad)
    fwd = _norm(np.array([0, 0, 1.0])[None, :] - axis * axis[:, 2:3])
    outv = np.concatenate([s, np.zeros_like(s), np.zeros_like(s)], 1)
    out = _norm(outv - axis * _dot(axis, outv)[:, None])
    f, o = _dot(r, fwd), _dot(r, out)
    return t, f, o, -o, np.arctan2(o, f)


# --------------------------------------------------------------------------- Körperteile


def teil(p):
    """Grober Körperteil je Punkt: torso, ua (Oberarm), fa, ha, th (Oberschenkel), sh, ft, head."""
    s = _seite(p)
    caps = [
        ("ua", _j("ua", s), _j("fa", s), 0.055), ("fa", _j("fa", s), _j("ha", s), 0.04),
        ("ha", _j("ha", s), _j("mid", s), 0.03), ("th", _j("th", s), _j("sh", s), 0.085),
        ("sh", _j("sh", s), _j("ft", s), 0.055), ("ft", _j("ft", s), _j("toe", s), 0.04),
        ("torso", np.array([[0, 0.95, 0.0]]), np.array([[0, 1.45, -0.02]]), 0.15),
        ("head", KOPF[None, :], KOPF[None, :] + [0, 0.12, 0], 0.09),
    ]
    d = np.stack([_kapsel(p, a, b, r) for _, a, b, r in caps], 1)
    base = np.array([c[0] for c in caps])[np.argmin(d, 1)]
    return np.where((base == "head") & (p[:, 1] < 1.6), "torso", base)


# --------------------------------------------------------------------------- Formen


def _spline(punkte, k=10):
    """Geschlossene Catmull-Rom-Kurve durch die Punkte, als dichtes Polygon."""
    P = np.asarray(punkte, float)
    out = []
    for i in range(len(P)):
        p0, p1, p2, p3 = P[i - 1], P[i], P[(i + 1) % len(P)], P[(i + 2) % len(P)]
        for t in np.linspace(0, 1, k, endpoint=False):
            t2, t3 = t * t, t * t * t
            out.append(0.5 * ((2 * p1) + (-p0 + p2) * t + (2 * p0 - 5 * p1 + 4 * p2 - p3) * t2
                              + (-p0 + 3 * p1 - 3 * p2 + p3) * t3))
    return np.array(out)


def _abstand_innen(xy, poly):
    """Vorzeichenbehafteter Abstand zum Polygonrand (positiv = innen), in Metern."""
    a, b = poly, np.roll(poly, -1, 0)
    ab = b - a
    ap = xy[:, None, :] - a[None]
    t = np.clip(np.einsum("kmi,mi->km", ap, ab) / np.maximum((ab * ab).sum(1), 1e-12), 0, 1)
    d = np.linalg.norm(ap - t[..., None] * ab[None], axis=2).min(1)
    y = xy[:, 1:2]
    kreuzt = ((a[None, :, 1] > y) != (b[None, :, 1] > y))
    xk = a[None, :, 0] + (y - a[None, :, 1]) * ab[None, :, 0] / np.where(np.abs(ab[None, :, 1]) < 1e-12, 1e-12, ab[None, :, 1])
    innen = (kreuzt & (xy[:, 0:1] < xk)).sum(1) % 2 == 1
    return np.where(innen, d, -d)


class Flaeche:
    """Muskel als Umriss in der Vorder- oder Rückansicht (x = Abstand zur Mitte, y = Höhe)."""

    def __init__(self, punkte, seite, teile=("torso",), weich=0.006):
        self.poly = _spline(punkte)
        self.seite, self.teile, self.weich = seite, teile, weich

    def __call__(self, p, n, tl):
        xy = np.stack([np.abs(p[:, 0]), p[:, 1]], 1)
        d = _abstand_innen(xy, self.poly)
        if self.seite == "vorn":
            blick = glatt(-0.15, 0.35, n[:, 2])
        elif self.seite == "hinten":
            blick = glatt(0.15, -0.35, n[:, 2])
        elif self.seite == "vornseitlich":
            blick = glatt(-0.55, -0.2, n[:, 2])
        else:
            blick = glatt(0.55, 0.2, n[:, 2])
        ok = np.isin(tl, self.teile) if self.teile else np.ones(len(p), bool)
        return glatt(-self.weich, self.weich, d) * blick * ok, glatt(0, 0.035, d)


def _gelenkwinkel(p, s, a, b):
    t, f, o, mi, w = knochen(p, _j(a, s), _j(b, s), s)
    return t, w


class Spindel:
    """Muskel um eine Knochenachse: Bauch zwischen t0 und t1, Breite als Winkel um die Mitte w0."""

    def __init__(self, knochen_, t0, t1, w0, breite, radius, form=0.5, teile=None, weich=0.006, rmax=None):
        self.k, self.t0, self.t1, self.w0, self.b, self.r = knochen_, t0, t1, w0, breite, radius
        self.form, self.teile, self.weich = form, teile, weich
        self.rmax = rmax if rmax is not None else radius * 2.2

    def __call__(self, p, n, tl):
        s = _seite(p)
        a, b = self.k
        t, w = _gelenkwinkel(p, s, a, b)
        ln = np.linalg.norm(np.asarray(GELENK[b]) - np.asarray(GELENK[a]))
        u = np.clip((t - self.t0) / (self.t1 - self.t0), 0, 1)
        if self.form == "kappe":
            # breit oben, läuft zum Ansatz hin spitz zu (Deltamuskel)
            halb = self.b * np.clip(1 - u ** 2.2, 0, 1) ** 0.6 * glatt(0, 0.12, u)
        else:
            halb = self.b * np.sin(np.pi * u) ** self.form
        dw = np.abs(np.angle(np.exp(1j * (w - self.w0))))
        quer = (halb - dw) * self.r
        laengs = np.minimum(t - self.t0, self.t1 - t) * ln
        d = np.minimum(quer, laengs)
        ok = np.isin(tl, self.teile) if self.teile else np.ones(len(p), bool)
        ja, jb = _j(a, s), _j(b, s)
        ax = (jb - ja) / ln
        rad = np.linalg.norm(p - ja - ax * ((t * ln)[:, None]), axis=1)
        ok = ok & (rad < self.rmax)
        return glatt(-self.weich, self.weich, d) * ok, glatt(0, 0.03, d)


def _band(p, a, b, breite):
    a, b = np.asarray(a, float), np.asarray(b, float)
    xy = np.stack([np.abs(p[:, 0]), p[:, 1]], 1)
    ab = b - a
    t = np.clip(((xy - a) @ ab) / (ab @ ab), 0, 1)
    d = breite * (0.6 + 0.4 * np.sin(np.pi * t)) - np.linalg.norm(xy - (a + t[:, None] * ab), axis=1)
    return d


FORMEN = {
    "chest": [Flaeche([(0.004, 1.462), (0.05, 1.468), (0.10, 1.47), (0.145, 1.452), (0.178, 1.418), (0.197, 1.37),
                       (0.192, 1.335), (0.168, 1.302), (0.13, 1.276), (0.085, 1.262), (0.04, 1.262), (0.004, 1.266)],
                      "vorn", ("torso", "ua"))],
    "abs": [Flaeche([(-0.02, 1.262), (0.035, 1.262), (0.068, 1.25), (0.08, 1.20), (0.077, 1.10), (0.066, 1.00),
                     (0.04, 0.935), (-0.02, 0.915)], "vorn"),
            Flaeche([(0.085, 1.235), (0.125, 1.25), (0.152, 1.22), (0.158, 1.13), (0.15, 1.03), (0.13, 0.975),
                     (0.095, 0.97), (0.082, 1.04), (0.086, 1.15)], "vornseitlich")],
    "hipFlexors": [Flaeche([(0.065, 0.945), (0.105, 0.965), (0.145, 0.945), (0.158, 0.895), (0.14, 0.83),
                            (0.11, 0.79), (0.085, 0.83), (0.07, 0.89)], "vorn", None)],
    "traps": [Flaeche([(-0.02, 1.625), (0.03, 1.615), (0.058, 1.565), (0.115, 1.518), (0.168, 1.497), (0.19, 1.468),
                       (0.15, 1.43), (0.10, 1.37), (0.068, 1.27), (0.03, 1.135), (-0.02, 1.105)], "hinten",
                      ("torso", "ua", "head"))],
    "lats": [Flaeche([(0.045, 1.235), (0.10, 1.30), (0.155, 1.335), (0.20, 1.335), (0.205, 1.28), (0.185, 1.20),
                      (0.158, 1.12), (0.142, 1.045), (0.105, 1.005), (0.055, 0.995), (0.03, 1.04), (0.032, 1.15)],
                     "seitlich", ("torso", "th"))],
    "lowerBack": [Flaeche([(0.014, 1.20), (0.045, 1.20), (0.066, 1.07), (0.064, 0.975), (0.04, 0.925),
                           (0.014, 0.935)], "hinten", None, 0.009)],
    "glutes": [Flaeche([(0.012, 0.975), (0.065, 1.005), (0.125, 0.995), (0.168, 0.945), (0.18, 0.875), (0.158, 0.815),
                        (0.105, 0.782), (0.05, 0.788), (0.014, 0.83)], "hinten", None)],
    "shoulders": [Spindel(("ua", "fa"), -0.30, 0.56, 1.4, 2.5, 0.05, "kappe", rmax=0.10)],
    "biceps": [Spindel(("ua", "fa"), 0.18, 0.99, -0.05, 1.05, 0.045, 0.55, ("ua", "fa"))],
    "triceps": [Spindel(("ua", "fa"), 0.10, 0.96, np.pi, 1.35, 0.045, 0.45, ("ua", "fa", "torso"))],
    "forearms": [Spindel(("fa", "ha"), -0.10, 1.02, 0.3, 3.3, 0.04, 0.25, ("fa", "ua", "ha"))],
    "quads": [Spindel(("th", "sh"), 0.02, 0.95, 0.2, 1.65, 0.075, 0.38, ("th", "torso"))],
    "hamstrings": [Spindel(("th", "sh"), 0.14, 0.97, np.pi, 1.2, 0.075, 0.45, ("th", "sh"))],
    "adductors": [Spindel(("th", "sh"), -0.15, 0.80, -1.6, 1.1, 0.07, 0.6, ("th", "torso"))],
    "calves": [Spindel(("sh", "ft"), 0.0, 0.62, np.pi, 1.55, 0.05, 0.5, ("sh", "th")),
               Spindel(("sh", "ft"), 0.45, 1.0, np.pi, 0.4, 0.05, 0.4, ("sh", "ft"))],
}


def gewichte(p, n):
    """Weiche Zugehörigkeit je Muskel (n, 17) und Wölbung (n, 17): Mitte des Muskelbauchs = 1."""
    tl = teil(p)
    w = np.zeros((len(p), len(MUSKELN) + 1))
    kern = np.zeros_like(w)
    for name, formen in FORMEN.items():
        for f in formen:
            a, c = f(p, n, tl)
            k = ID[name]
            kern[:, k] = np.where(a > w[:, k], c, kern[:, k])
            w[:, k] = np.maximum(w[:, k], a)
    # Kopfwender (Nacken): Band vom Ohr zum Brustbein, dazu der Nacken unter dem Trapez
    d = _band(p, (0.058, 1.60), (0.018, 1.478), 0.017)
    w[:, ID["neck"]] = glatt(-0.008, 0.008, d) * glatt(-0.5, 0.0, n[:, 2]) * np.isin(tl, ("torso", "head"))
    kern[:, ID["neck"]] = glatt(0, 0.012, d)
    # Abdeckung: was obenauf liegt, verdeckt den Muskel darunter
    w[:, ID["lats"]] *= 1 - 0.9 * w[:, ID["traps"]]
    w[:, ID["lats"]] *= 1 - 0.9 * w[:, ID["lowerBack"]]
    w[:, ID["triceps"]] *= 1 - 0.95 * w[:, ID["shoulders"]]
    w[:, ID["biceps"]] *= 1 - 0.95 * w[:, ID["shoulders"]]
    w[:, ID["shoulders"]] *= 1 - 0.9 * w[:, ID["chest"]]
    w[:, ID["shoulders"]] *= 1 - 0.9 * w[:, ID["traps"]]
    w[:, ID["shoulders"]] *= 1 - 0.9 * w[:, ID["lats"]]
    w[:, ID["quads"]] *= 1 - 0.9 * np.maximum(w[:, ID["hipFlexors"]], w[:, ID["adductors"]])
    w[:, ID["quads"]] *= 1 - 0.95 * w[:, ID["glutes"]]
    w[:, ID["hamstrings"]] *= 1 - 0.95 * w[:, ID["glutes"]]
    w[:, ID["adductors"]] *= 1 - 0.9 * np.maximum(w[:, ID["glutes"]], w[:, ID["hamstrings"]])
    w[:, ID["abs"]] *= 1 - 0.9 * w[:, ID["chest"]]
    w[:, ID["lats"]] *= 1 - 0.9 * w[:, ID["chest"]]
    return w, kern


def glatt(a, b, x):
    u = np.clip((x - a) / (b - a), 0, 1)
    return u * u * (3 - 2 * u)


# --------------------------------------------------------------------------- Rauschen

def rauschen(p, f, saat=0):
    """Glattes Wertrauschen 0…1 im Raum, Merkmalsgröße 1/f Meter."""
    q = p * f + saat * 17.31
    i = np.floor(q).astype(np.int64)
    u = q - i
    u = u * u * (3 - 2 * u)

    def h(dx, dy, dz):
        x = (i[:, 0] + dx) * 73856093 ^ (i[:, 1] + dy) * 19349663 ^ (i[:, 2] + dz) * 83492791 ^ saat * 2654435761
        x = (x ^ (x >> 13)) * 1274126177
        return ((x ^ (x >> 16)) & 0xFFFF) / 65535.0

    r = 0
    for dx in (0, 1):
        for dy in (0, 1):
            for dz in (0, 1):
                w = (u[:, 0] if dx else 1 - u[:, 0]) * (u[:, 1] if dy else 1 - u[:, 1]) * (u[:, 2] if dz else 1 - u[:, 2])
                r = r + w * h(dx, dy, dz)
    return r


# --------------------------------------------------------------------------- Fasern, Sehnen, Trennlinien

# Fasern entlang einer Achse (Ursprung → Ansatz), linke Seite
ACHSE = {
    "biceps": ("ua", "fa"), "triceps": ("ua", "fa"), "forearms": ("fa", "ha"), "quads": ("th", "sh"),
    "hamstrings": ("th", "sh"), "hipFlexors": ("th", "sh"), "calves": ("sh", "ft"),
    "adductors": ((0.03, 0.93, 0.03), (0.09, 0.52, 0.0)), "neck": ((0.065, 1.61, -0.01), (0.015, 1.47, 0.07)),
    "shoulders": ((0.17, 1.48, -0.01), (0.25, 1.29, 0.02)),
}
# Fächerförmige Muskeln: Fasern laufen auf einen Ansatzpunkt zu, gesehen entlang der Blickachse
FAECHER = {
    "chest": ((0.18, 1.33, 0.07), (0, 0, 1.0)), "lats": ((0.17, 1.31, -0.03), (0, 0, 1.0)),
    "traps": ((0.18, 1.46, -0.03), (0, 0, 1.0)), "glutes": ((0.17, 0.85, -0.02), (0, 0, 1.0)),
}
STREIFEN = 0.008  # Abstand der Streifung in Metern
QUER, LAENGS = 230.0, 22.0  # Frequenz des Faserrauschens quer und längs zur Faser (je Meter)


def _achse(name, s):
    a, b = ACHSE[name]
    pa = _j(a, s) if isinstance(a, str) else _pt(a, s)
    pb = _j(b, s) if isinstance(b, str) else _pt(b, s)
    return pa, pb


def _winkel_um(p, a, b):
    """Winkel um die Achse a→b (je Punkt) mit festem Bezug, dazu t entlang der Achse."""
    axis = _norm(b - a)
    ref = np.where(np.abs(axis[:, 2:3]) > 0.9, np.array([[1.0, 0, 0]]), np.array([[0, 0, 1.0]]))
    e1 = _norm(np.cross(axis, ref))
    e2 = np.cross(axis, e1)
    r = p - a
    return np.arctan2(_dot(r, e2), _dot(r, e1)), _dot(r, axis) / np.linalg.norm(b - a, axis=1)


def _faser_lage(name, p, s):
    """Lage quer und längs zu den Fasern: Punkte für das Faserrauschen (nahtlos), Streifenwelle, Abschwächung."""
    if name in ACHSE:
        a, b = _achse(name, s)
        w, t = _winkel_um(p, a, b)
        ln = np.linalg.norm(b - a, axis=1)
        k = np.round(2 * np.pi * 0.05 / STREIFEN)
        q = np.stack([np.cos(w) * 0.05 * QUER, np.sin(w) * 0.05 * QUER, t * ln * LAENGS], 1)
        return q, np.cos(k * w + 2.0 * t), np.ones(len(p))
    if name in FAECHER:
        q0, _ = FAECHER[name]
        d = p - _pt(q0, s)
        w = np.arctan2(d[:, 1], d[:, 0] * s[:, 0])
        r = np.linalg.norm(d, axis=1)
        k = np.round(2 * np.pi * 0.13 / STREIFEN)
        q = np.stack([np.cos(w) * 0.13 * QUER, np.sin(w) * 0.13 * QUER, r * LAENGS], 1)
        return q, np.cos(k * w), glatt(0.02, 0.08, r)
    ax, y = np.abs(p[:, 0]), p[:, 1]
    if name == "abs":
        schraeg = ax >= 0.08
        x = np.where(schraeg, (ax - y) / np.sqrt(2), ax)
        lang = np.where(schraeg, (ax + y) / np.sqrt(2), y)
    else:
        x, lang = ax, y
    q = np.stack([x * QUER, lang * LAENGS, np.zeros(len(p))], 1)
    return q, np.cos(2 * np.pi * x / STREIFEN), np.ones(len(p))


def sehne(name, p, s):
    """0 = Muskelbauch, 1 = Sehne/Sehnenplatte (hell)."""
    ax, y = np.abs(p[:, 0]), p[:, 1]
    z = np.zeros(len(p))
    if name in ("biceps", "triceps", "forearms", "quads", "hamstrings", "calves"):
        a, b = _achse(name, s)
        t = _entlang(p, a, b)
        rng = {"biceps": (0.84, 0.97), "triceps": (0.74, 0.93), "forearms": (0.55, 0.86), "quads": (0.80, 0.91),
               "hamstrings": (0.76, 0.92), "calves": (0.56, 0.70)}[name]
        return glatt(*rng, t)
    if name == "abs":
        alba = 0.5 * (1 - glatt(0.002, 0.006, ax))
        z = np.maximum(z, alba)
        for yl in (1.208, 1.158, 1.104):
            z = np.maximum(z, (1 - glatt(0.002, 0.0055, np.abs(y - yl))) * (ax < 0.078) * 0.5)
        return z
    if name == "traps":
        return 0.55 * (1 - glatt(0.6, 1.1, ax / 0.03 + np.abs(y - 1.46) / 0.05))
    if name == "lats":
        return 0.6 * glatt(0.03, 0.0, ax - 0.06 + (y - 1.04) * 0.6) * (y < 1.12)
    if name == "lowerBack":
        return 0.25 * (1 - glatt(0.005, 0.012, ax))
    return z


def _rinne(x, x0, breite):
    return np.exp(-((x - x0) / breite) ** 2)


def trennlinien(name, p, s):
    """Abdunklung (0…1) entlang der Grenzen zwischen Muskelköpfen."""
    g = np.zeros(len(p))
    if name in ("quads", "hamstrings", "triceps", "biceps", "calves"):
        a, b = _achse(name, s)
        t, f, o, _, w = knochen(p, a, b, s)
        if name == "quads":
            g = np.maximum(_rinne(w, 0.62, 0.05), _rinne(w, -0.42 - 0.6 * glatt(0.5, 0.85, t), 0.05) * (t > 0.25))
        elif name == "hamstrings":
            g = _rinne(np.abs(w), np.pi - 0.05, 0.05) * glatt(0.2, 0.35, t) * (t < 0.85)
        elif name == "triceps":
            g = _rinne(w, 2.35, 0.06) * (t < 0.72)
        elif name == "biceps":
            g = 0.5 * _rinne(w, 0.05, 0.06) * (t < 0.8)
        else:
            g = _rinne(np.abs(w), np.pi, 0.06) * (t < 0.42)
    elif name == "shoulders":
        a, b = _achse(name, s)
        w, t = _winkel_um(p, a, b)
        g = np.maximum(_rinne(w, 0.75, 0.05), _rinne(w, -0.75, 0.05)) * glatt(0.0, 0.25, t)
    elif name == "chest":
        ax, y = np.abs(p[:, 0]), p[:, 1]
        g = 0.6 * _rinne(y - (1.385 - 0.25 * ax), 0, 0.006) * (ax > 0.03)
    return g


def fasern(name, p, s):
    """Helligkeit der Faserstruktur 0…1: längliche Faserbündel, leichte Streifung, unregelmäßige Tönung."""
    q, welle, stark = _faser_lage(name, p, s)
    v = (0.55 + 0.16 * welle * stark + 0.32 * (rauschen(q, 1.0, 7) - 0.5) + 0.16 * (rauschen(q, 2.1, 8) - 0.5)
         + 0.12 * (rauschen(p, 28, 9) - 0.5))
    return np.clip(v, 0, 1)
