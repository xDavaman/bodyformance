"""Einzelteile, die in mehreren Geräten vorkommen: Scheiben, Hanteln, Kettlebell, Bank, Rolle, Griffe, Rohre."""
import math

import numpy as np

from .mesh import (Model, Rx, Ry, Rz, T, S, bar, chain, cylinder, lathe, quad, rbox, sphere, superpad, sweep, torus,
                   tube, tube_ring, rrect, fillet)

# MARK: Rohre und Gestell

# Eckenradius der Rahmenprofile: stark verrundete Rechteckrohre wie bei gym80, nicht scharfkantig
PROFIL_R = 0.016


def post(m, x, z, y0, y1, w=0.075, d=None, mat="rahmen", r=PROFIL_R):
    """Senkrechtes Vierkantrohr (Breite w in x, Tiefe d in z)"""
    d = w if d is None else d
    m.add(mat, bar([(x, y0, z), (x, y1, z)], w, d, r, up=(0, 0, 1)))


def beam_x(m, x0, x1, y, z, w=0.075, h=None, mat="rahmen", r=PROFIL_R):
    """Waagrechtes Vierkantrohr entlang x (Tiefe w in z, Höhe h)"""
    h = w if h is None else h
    m.add(mat, bar([(x0, y, z), (x1, y, z)], w, h, r))


def beam_z(m, z0, z1, y, x, w=0.075, h=None, mat="rahmen", r=PROFIL_R):
    h = w if h is None else h
    m.add(mat, bar([(x, y, z0), (x, y, z1)], w, h, r))


def holes(m, x, z, y0, y1, face, step=0.05, size=(0.022, 0.022), mat="loch", r=0.004):
    """Lochreihe auf einer Fläche eines senkrechten Rohrs. face: Punkt auf der Fläche (dx, dz) und Normale"""
    (fx, fz), (nx, nz) = face
    y = y0
    while y <= y1 + 1e-6:
        c = (x + fx + nx * 0.0006, y, z + fz + nz * 0.0006)
        sx = size[0] if abs(nz) > 0.5 else 0.002
        sz = size[0] if abs(nx) > 0.5 else 0.002
        m.add(mat, rbox((sx, size[1], sz), min(r, size[1] / 2 - 1e-4), 2, center=c))
        y += step


def foot_cap(m, x, y, z, w=0.08, h=0.06, d=0.05, axis="x"):
    """Gummikappe am Rohrende"""
    size = (d, h, w) if axis == "x" else (w, h, d)
    m.add("gummi", rbox(size, 0.012, 3, center=(x, y, z)))


def leveler(m, x, z, y=0.0):
    """Stellfuß mit Gummiteller"""
    m.add("gummi", cylinder(0.012, 0.03, 24, bevel=0.004, center=(x, y + 0.006, z)))
    m.add("stahl", cylinder(0.03, 0.008, 12, center=(x, y + 0.025, z)))


def plate_bolt(m, x, y, z, normal="z"):
    """Schraubenkopf (Inbus) auf einer Fläche"""
    rot = {"z": Rx(math.pi / 2), "-z": Rx(-math.pi / 2), "x": Rz(-math.pi / 2), "-x": Rz(math.pi / 2), "y": np.eye(4)}[normal]
    m.add("stahl", cylinder(0.006, 0.008, 12, bevel=0.0015), chain(T(x, y, z), rot))


# MARK: Hantelscheiben


def bumper(color="bumper_schwarz", R=0.225, t=0.06):
    """Bumper-Scheibe (Gummi mit Stahlkern), Achse = y, Mitte im Ursprung"""
    m = Model()
    m.add("stahl", tube_ring(t + 0.002, 0.052, 0.0255, 48))
    b = 0.007
    prof = [(0.052, -t / 2), (R - b, -t / 2), (R, -t / 2 + b), (R, t / 2 - b), (R - b, t / 2), (0.052, t / 2),
            (0.052, -t / 2)]
    m.add(color, lathe(prof, 64, crease=30))
    # Rille auf der Fläche (wie bei echten Bumpern)
    for s in (-1, 1):
        m.add("gummi", torus(R * 0.62, 0.0025, 64, 6), T(0, s * t / 2, 0))
    return m


def iron_plate(R=0.225, t=0.034, grip=True):
    """Klassische Gusseisen-Scheibe mit Randwulst, vertiefter Fläche und Nabe; Achse = y"""
    m = Model()
    h = t / 2
    prof = [(0.0255, -h - 0.004), (0.075, -h - 0.004), (0.085, -h + 0.004), (R - 0.03, -h + 0.004),
            (R - 0.022, -h - 0.002), (R - 0.004, -h - 0.002), (R, -h + 0.004), (R, h - 0.004), (R - 0.004, h + 0.002),
            (R - 0.022, h + 0.002), (R - 0.03, h - 0.004), (0.085, h - 0.004), (0.075, h + 0.004), (0.0255, h + 0.004),
            (0.0255, -h - 0.004)]
    m.add("scheibe_eisen", lathe(prof, 72, crease=25))
    if grip:
        # drei Grifflöcher als dunkle Ausschnitte
        for k in range(3):
            a = k * 2 * math.pi / 3 + math.pi / 2
            rr = (0.085 + R - 0.03) / 2
            for s in (-1, 1):
                m.add("loch", rbox((0.06, 0.002, 0.024), 0.0099, 3), chain(T(rr * math.cos(a), s * (h - 0.0035), rr * math.sin(a)),
                                                                        Ry(-a + math.pi / 2)))
    return m


# MARK: Hanteln


def dumbbell():
    """Gummierte Sechskant-Kurzhantel (etwa 15 kg), Achse = y, Griffmitte im Ursprung"""
    m = Model()
    # Griff: verchromt, Rändelung in der Mitte, Bund an den Köpfen
    prof = [(0, -0.07), (0.0165, -0.07), (0.0165, -0.05), (0.0172, -0.048), (0.0172, 0.048), (0.0165, 0.05),
            (0.0165, 0.07), (0, 0.07)]
    m.add("chrom", lathe(prof, 32))
    m.add("raendel", cylinder(0.092, 0.01735, 32))
    for s in (-1, 1):
        y0 = s * 0.066
        # Chromring zwischen Griff und Kopf
        m.add("chrom", cylinder(0.012, 0.026, 32, bevel=0.002, center=(0, y0 + s * 0.006, 0)))
        a, b = s * 0.072, s * 0.128
        lo, hi = min(a, b), max(a, b)
        prof = [(0, lo), (0.05, lo), (0.059, lo + 0.007), (0.059, hi - 0.007), (0.05, hi), (0, hi)]
        m.add("gummi", lathe(prof, 6, crease=20, flat=True, phase=math.pi / 6))
        # Emblem auf der Stirnseite
        m.add("chrom", cylinder(0.003, 0.028, 32, bevel=0.001, center=(0, s * (0.128 + 0.0015), 0)))
    return m


def kettlebell(body="guss", handle="guss"):
    """Kettlebell (Wettkampfform), Boden bei y = 0, Höhe etwa 0,28 m"""
    m = Model()
    R = 0.105
    cy = 0.112
    prof = [(0, 0.0), (0.05, 0.0)]
    for a in np.linspace(-0.93, 1.25, 26):
        prof.append((R * math.cos(a), cy + R * math.sin(a)))
    prof += [(0, cy + R * 0.975)]
    m.add(body, lathe(prof, 56, crease=50))
    pts = [(-0.068, 0.17, 0), (-0.080, 0.235, 0), (-0.062, 0.300, 0), (0.062, 0.300, 0), (0.080, 0.235, 0),
           (0.068, 0.17, 0)]
    m.add(handle, tube(pts, 0.0175, bend=0.045, n=24))
    return m


def barbell(plates=("bumper_rot",), axis="x", bar_only=False):
    """Olympia-Langhantel 2,20 m mit Hülsen, Rändelung und optional Scheiben + Federverschluss. Achse x (oder y)"""
    m = Model()
    prof = [(0, -0.655), (0.014, -0.655), (0.014, 0.655), (0, 0.655)]
    m.add("stahl", lathe(prof, 24))
    for x0, x1 in ((-0.63, -0.21), (0.21, 0.63)):
        m.add("raendel", cylinder(x1 - x0, 0.01415, 24, center=(0, (x0 + x1) / 2, 0)))
    m.add("raendel", cylinder(0.16, 0.01415, 24))
    for s in (-1, 1):
        # Bund und Hülse
        m.add("chrom", cylinder(0.03, 0.026, 32, bevel=0.003, center=(0, s * 0.67, 0)))
        m.add("chrom", cylinder(0.415, 0.025, 32, bevel=0.002, center=(0, s * (0.685 + 0.2075), 0)))
        m.add("chrom", cylinder(0.008, 0.0255, 32, center=(0, s * 0.70, 0)))
        if bar_only:
            continue
        y = 0.69
        for p in plates:
            if p == "eisen":
                pl = iron_plate()
                t = 0.042
            else:
                t = 0.062
                pl = bumper(p, t=t)
            m.put(pl, T(0, s * (y + t / 2), 0))
            y += t + 0.002
        # Federverschluss
        m.add("stahl", torus(0.03, 0.004, 24, 8), T(0, s * (y + 0.01), 0))
        m.add("rahmen_rot", cylinder(0.006, 0.006, 8), chain(T(0.04, s * (y + 0.01), 0), Rz(math.pi / 2)))
    out = Model()
    out.put(m, Rz(-math.pi / 2) if axis == "x" else None)
    return out


# MARK: Bank


BENCH_TOP = 0.30
BENCH_PAD = 0.07


def bench_frame():
    """Hantelbank ohne Rückenlehne: Rahmen, Sitzpolster, Füße, Rollen, Griff. Oberkante 0,30 m, Kopfende −z"""
    m = Model()
    top, pad = BENCH_TOP, BENCH_PAD
    # Mittelholm (50 × 80 mm), Kopf- und Fußstütze
    m.add("rahmen", bar([(0, 0.14, -0.70), (0, 0.14, 0.36)], 0.05, 0.08, 0.008))
    m.add("rahmen", bar([(0, 0.05, -0.70), (0, 0.15, -0.70)], 0.05, 0.07, 0.008, up=(0, 0, 1)))
    m.add("rahmen", bar([(0, 0.05, 0.36), (0, 0.15, 0.36)], 0.05, 0.07, 0.008, up=(0, 0, 1)))
    # Querfüße
    for z, w in ((-0.70, 0.50), (0.36, 0.44)):
        m.add("rahmen", bar([(-w / 2, 0.03, z), (w / 2, 0.03, z)], 0.07, 0.05, 0.008))
        for s in (-1, 1):
            foot_cap(m, s * (w / 2 + 0.008), 0.03, z, w=0.075, h=0.056, d=0.02)
    # Transportrollen und Griff am Fußende
    for s in (-1, 1):
        m.add("gummi", cylinder(0.028, 0.038, 32, bevel=0.006), chain(T(s * 0.20, 0.04, 0.41), Rz(math.pi / 2)))
        m.add("stahl", cylinder(0.032, 0.012, 16), chain(T(s * 0.20, 0.04, 0.41), Rz(math.pi / 2)))
        m.add("rahmen", bar([(s * 0.20, 0.03, 0.36), (s * 0.20, 0.04, 0.41)], 0.012, 0.03, 0.003))
    m.add("rahmen", tube([(0, 0.15, 0.38), (0, 0.15, 0.50), (0, 0.10, 0.56)], 0.014, bend=0.04))
    m.add("griff", cylinder(0.1, 0.019, 24, bevel=0.004), chain(T(0, 0.135, 0.52), Rx(-math.pi / 2 + 0.35)))
    # Sitzträger und Sitzpolster (z 0 … 0.42)
    m.add("rahmen", bar([(0, 0.18, 0.21), (0, top - pad - 0.012, 0.21)], 0.05, 0.05, 0.006, up=(0, 0, 1)))
    m.add("rahmen_grau", rbox((0.24, 0.012, 0.38), 0.004, 2, center=(0, top - pad - 0.006, 0.21)))
    m.add("polster", superpad((0.28, pad, 0.41), 0.4, 8, center=(0, top - pad / 2, 0.21)))
    m.add("naht", sweep(fillet(_outline(0.276, 0.406, top - pad + 0.012, 0.21), 0.045, 6), _round_profile(0.0035), caps=False,
                        closed=True))
    # Verstellleiter für die Lehne
    m.add("rahmen", bar([(0, 0.20, -0.58), (0, 0.20, -0.16)], 0.06, 0.03, 0.004))
    for k in range(6):
        m.add("chrom", cylinder(0.08, 0.008, 12), chain(T(0, 0.222, -0.55 + k * 0.07), Rz(math.pi / 2)))
    # Plakette am Holm
    m.add("rahmen_rot", rbox((0.052, 0.03, 0.12), 0.004, 2, center=(0, 0.14, -0.05)))
    return m


def _outline(w, d, y, zc):
    """Geschlossener Rechteck-Pfad (für fillet: Start und Ende in der Mitte einer Kante)"""
    return [(0, y, zc - d / 2), (w / 2, y, zc - d / 2), (w / 2, y, zc + d / 2), (-w / 2, y, zc + d / 2),
            (-w / 2, y, zc - d / 2), (-0.001, y, zc - d / 2)]


def _round_profile(r):
    a = np.linspace(0, 2 * math.pi, 8, endpoint=False)
    p = np.stack([np.cos(a) * r, np.sin(a) * r], 1)
    return p, p / r


def bench_back():
    """Rückenlehne; Ursprung im Drehpunkt (Sitzvorderkante), Lehne liegt Richtung −z (z −0.81 … 0)"""
    m = Model()
    pad = BENCH_PAD
    m.add("polster", superpad((0.29, pad, 0.80), 0.4, 8, center=(0, 0, -0.405)))
    m.add("naht", sweep(fillet(_outline(0.286, 0.796, -pad / 2 + 0.012, -0.405), 0.045, 6), _round_profile(0.0035),
                        caps=False, closed=True))
    m.add("rahmen_grau", rbox((0.24, 0.012, 0.76), 0.004, 2, center=(0, -pad / 2 - 0.006, -0.40)))
    m.add("rahmen", bar([(0, -pad / 2 - 0.03, -0.72), (0, -pad / 2 - 0.03, -0.05)], 0.06, 0.035, 0.005))
    m.add("stahl", cylinder(0.08, 0.012, 16), chain(T(0, -pad / 2 - 0.03, -0.02), Rz(math.pi / 2)))
    return m


# MARK: Kabelzug


def pulley():
    """Umlenkrolle: Rad (Achse x) zwischen zwei Wangen, Schlitten dahinter (+z)"""
    m = Model()
    prof = [(0.012, -0.012), (0.06, -0.012), (0.06, -0.006), (0.052, -0.002), (0.052, 0.002), (0.06, 0.006),
            (0.06, 0.012), (0.012, 0.012), (0.012, -0.012)]
    m.add("kunststoff", lathe(prof, 48, crease=30), Rz(math.pi / 2))
    m.add("stahl", cylinder(0.05, 0.008, 16), Rz(math.pi / 2))
    for s in (-1, 1):
        m.add("rahmen", rbox((0.006, 0.15, 0.12), 0.003, 2, center=(s * 0.018, 0, 0.03)))
    m.add("rahmen", rbox((0.07, 0.15, 0.06), 0.008, 3, center=(0, 0, 0.09)))
    # Arretierbolzen mit Knauf
    m.add("rahmen_rot", sphere(0.016, 20, 10, center=(0.055, 0.02, 0.09)))
    m.add("stahl", cylinder(0.02, 0.006, 12), chain(T(0.042, 0.02, 0.09), Rz(math.pi / 2)))
    return m


def handle():
    """Einzelgriff (Steigbügel): Gummigriff entlang y, Stahlbügel, Öse"""
    m = Model()
    m.add("griff", cylinder(0.12, 0.016, 24, bevel=0.004))
    m.add("stahl", cylinder(0.14, 0.008, 12))
    pts = [(0, -0.07, 0), (0, -0.07, 0.05), (0, 0, 0.10), (0, 0.07, 0.05), (0, 0.07, 0)]
    m.add("chrom", tube(pts, 0.008, bend=0.04, n=12, up=(1, 0, 0)))
    m.add("chrom", torus(0.014, 0.004, 20, 8), chain(T(0, 0, 0.115), Rx(math.pi / 2)))
    return m


def weight_stack(m, x, z, plates=16, y0=0.10, w=0.30, d=0.16, th=0.045, pin=7, rods=0.085, top=2.18):
    """Gewichtsblock mit Führungsstangen, Wahlstift und Kopfplatte; Vorderseite zeigt nach −z"""
    for s in (-1, 1):
        m.add("chrom", cylinder(top - 0.06, 0.0125, 20, y0=0.06), T(x + s * rods, 0, z))
        m.add("gummi", cylinder(0.04, 0.03, 20, y0=0.06), T(x + s * rods, 0, z))
    for k in range(plates):
        y = y0 + k * (th + 0.002)
        m.add("stapel", rbox((w, th, d), 0.006, 2, center=(x, y + th / 2, z)))
        m.add("aufkleber", quad(0.05, 0.016, center=(x + w * 0.32, y + th / 2, z - d / 2 - 0.0006), normal="-z"))
    yt = y0 + plates * (th + 0.002)
    m.add("stapel", rbox((w, 0.05, d), 0.01, 3, center=(x, yt + 0.025, z)))
    m.add("chrom", cylinder(0.55, 0.011, 16, y0=yt + 0.05), T(x, 0, z))
    # Wahlstift steckt vorne im Block
    py = y0 + pin * (th + 0.002) + th / 2
    m.add("stahl", cylinder(0.12, 0.005, 12), chain(T(x, py, z - d / 2 + 0.02), Rx(math.pi / 2)))
    m.add("rahmen_rot", cylinder(0.03, 0.016, 20, bevel=0.005), chain(T(x, py, z - d / 2 - 0.05), Rx(math.pi / 2)))
    return yt + 0.05


def stack_shroud(m, x, z, w, d, y0, y1, slot=0.05):
    """Gewichtsabdeckung im gym80-Stil: geschlossene Seitenwände, Front aus zwei Blenden mit Schlitz für den
    Wahlstift, darin Lochblech-Streifen; oben ein silbernes Typenschild mit rotem Streifen. Front zeigt nach −z."""
    h, yc = y1 - y0, (y0 + y1) / 2
    zf = z - d / 2 - 0.035
    for s in (-1, 1):
        m.add("blende", rbox((0.008, h, d + 0.07), 0.004, 2, center=(x + s * (w / 2 + 0.035), yc, z)))
        bw = (w + 0.07 - slot) / 2
        m.add("blende", rbox((bw, h, 0.008), 0.004, 2, center=(x + s * (slot / 2 + bw / 2), yc, zf)))
    m.add("lochblech", rbox((slot, h - 0.02, 0.002), 0.001, 1, center=(x, yc, zf + 0.012)))
    m.add("blende_silber", rbox((w + 0.03, 0.10, 0.006), 0.003, 2, center=(x, y1 - 0.09, zf - 0.006)))
    m.add("rahmen_rot", rbox((w + 0.03, 0.012, 0.007), 0.002, 1, center=(x, y1 - 0.15, zf - 0.006)))


__all__ = ["stack_shroud", "PROFIL_R", "post", "beam_x", "beam_z", "holes", "foot_cap", "leveler", "plate_bolt", "bumper", "iron_plate", "dumbbell",
           "kettlebell", "barbell", "bench_frame", "bench_back", "pulley", "handle", "weight_stack", "S", "rrect", "bar",
           "tube", "sweep", "quad", "rbox", "cylinder", "lathe", "sphere", "torus", "chain", "T", "Rx", "Ry", "Rz",
           "Model", "superpad", "tube_ring"]
