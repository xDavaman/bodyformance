"""Die Geräte des Studios. Jede Funktion liefert ein Modell im lokalen Koordinatensystem der Station, das die App
(GymScene.swift / GymExplore.swift) erwartet. Name in MODELLE = Dateiname FitScan/Gym_<Name>.usdz."""
import math

import numpy as np

from .mesh import fillet, rrect, sweep
from .teile import (Model, Rx, Ry, Rz, T, S, bar, barbell, beam_x, beam_z, bench_back, bench_frame, bumper, chain,
                    cylinder, dumbbell, foot_cap, handle, holes, iron_plate, kettlebell, lathe, leveler, post, pulley,
                    quad, rbox, sphere, stack_shroud, PROFIL_R, superpad, torus, tube, tube_ring, weight_stack)


def _upright_holes(m, x, z, y0, y1, faces=("-z",), w=0.075, step=0.05):
    """Lochreihen auf einem Vierkant-Pfosten (faces: -z, +z, -x, +x)"""
    h = w / 2
    for fc in faces:
        nx, nz = {"-z": (0, -1), "+z": (0, 1), "-x": (-1, 0), "+x": (1, 0)}[fc]
        holes(m, x, z, y0, y1, ((nx * h, nz * h), (nx, nz)), step=step, size=(0.02, 0.026))


def _j_hook(m, x, y, z, dirz=1, w=0.06):
    """J-Haken an einem Pfosten, Öffnung zeigt nach +z (dirz = 1) oder −z"""
    pts = [(x, y + 0.05, z), (x, y, z), (x, y, z + dirz * 0.10), (x, y + 0.045, z + dirz * 0.12)]
    m.add("rahmen", sweep(fillet(pts, 0.018, 6), rrect(w, 0.010, 0.003), up=(1, 0, 0)))
    m.add("kunststoff", rbox((w - 0.008, 0.008, 0.07), 0.003, 2, center=(x, y + 0.009, z + dirz * 0.05)))
    m.add("rahmen", rbox((w + 0.02, 0.08, 0.02), 0.004, 2, center=(x, y + 0.03, z - dirz * 0.005)))
    m.add("stahl", cylinder(0.03, 0.006, 12), chain(T(x, y + 0.05, z - dirz * 0.02), Rx(math.pi / 2)))


def _plate_horn(m, x, y, z, dirx, plates):
    """Scheibenhorn (seitlich, Richtung dirx) mit Scheiben"""
    m.add("chrom", cylinder(0.22, 0.025, 24, bevel=0.003), chain(T(x + dirx * 0.11, y, z), Rz(math.pi / 2)))
    off = 0.02
    for p in plates:
        t = 0.042 if p == "eisen" else 0.062
        pl = iron_plate() if p == "eisen" else bumper(p, t=t)
        m.put(pl, chain(T(x + dirx * (off + t / 2), y, z), Rz(math.pi / 2)))
        off += t + 0.003


# MARK: Kabelturm (Übungsansicht und Studio)


def kabelsaeule():
    """Eine Säule des Kabelturms. Pfosten mit Rollenschiene bei (0,0,0), Gewichtsblock dahinter (+z)"""
    m = Model()
    # Bodenrahmen
    for x in (-0.17, 0.17):
        m.add("rahmen", bar([(x, 0.03, -0.32), (x, 0.03, 0.66)], 0.06, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, -0.33, w=0.065, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, 0.67, w=0.065, h=0.065, d=0.02, axis="z")
    beam_x(m, -0.2, 0.2, 0.03, 0.62, 0.06)
    beam_x(m, -0.2, 0.2, 0.03, -0.06, 0.06)
    # Rollenschiene vorn mit Löchern und Höhenzahlen
    post(m, 0, 0, 0.06, 2.36, 0.09, 0.09)
    _upright_holes(m, 0, 0, 0.25, 2.15, faces=("-z",), w=0.09, step=0.075)
    y = 0.25
    while y <= 2.15:
        m.add("aufkleber", quad(0.016, 0.012, center=(0.03, y, -0.0458), normal="-z"))
        y += 0.075
    # Hintere Pfosten und Kopf
    for x in (-0.17, 0.17):
        post(m, x, 0.58, 0.06, 2.30, 0.06)
    for x in (-0.17, 0.17):
        beam_z(m, -0.04, 0.6, 2.27, x, 0.06)
    # Gewichtsblock zwischen den Führungsstangen
    weight_stack(m, 0, 0.30, plates=16, w=0.28, d=0.15, rods=0.09, top=2.24)
    # Abdeckhaube oben in Markenrot mit Umlenkrollen
    m.add("rahmen_rot", rbox((0.42, 0.13, 0.76), 0.03, 5, center=(0, 2.37, 0.27)))
    m.add("kunststoff", rbox((0.43, 0.02, 0.77), 0.008, 3, center=(0, 2.30, 0.27)))
    m.add("aufkleber", quad(0.22, 0.035, center=(0, 2.39, -0.1102), normal="-z"))
    # Seil vom Block zur oberen Rolle
    m.add("seil", tube([(0, 1.45, 0.30), (0, 2.25, 0.30), (0, 2.25, 0.02), (0, 2.12, -0.06)], 0.0035, bend=0.05, n=8))
    # Gewichtsabdeckung mit Schlitz für den Wahlstift
    stack_shroud(m, 0, 0.30, 0.28, 0.15, 0.10, 1.95)
    for x in (-0.17, 0.17):
        leveler(m, x, -0.30)
        leveler(m, x, 0.64)
    return m


def kabelbruecke():
    """Querträger zwischen den Säulen mit Multigriff-Klimmzugstange. Ursprung auf Höhe der Säulen (z = 0)"""
    m = Model()
    m.add("rahmen", bar([(-0.92, 2.42, 0), (0.92, 2.42, 0)], 0.09, 0.12, 0.008))
    m.add("rahmen_rot", rbox((0.8, 0.06, 0.004), 0.002, 2, center=(0, 2.42, -0.047)))
    m.add("aufkleber", quad(0.42, 0.03, center=(0, 2.42, -0.0495), normal="-z"))
    # Klimmzugstange: hängt nach vorn, mit gewinkelten Griffen
    for s in (-1, 1):
        m.add("rahmen", bar([(s * 0.65, 2.42, -0.04), (s * 0.65, 2.42, -0.20)], 0.05, 0.05, 0.005))
    m.add("chrom", tube([(-0.72, 2.32, -0.20), (-0.65, 2.42, -0.20), (0.65, 2.42, -0.20), (0.72, 2.32, -0.20)], 0.016,
                       bend=0.05, n=16))
    for s in (-1, 1):
        m.add("griff", cylinder(0.15, 0.02, 20, bevel=0.004), chain(T(s * 0.42, 2.42, -0.20), Rz(math.pi / 2)))
        m.add("chrom", tube([(s * 0.30, 2.42, -0.20), (s * 0.30, 2.32, -0.30)], 0.014, n=14))
        m.add("griff", cylinder(0.12, 0.019, 20, bevel=0.004), chain(T(s * 0.30, 2.335, -0.285), Rx(-math.atan2(0.10, 0.10))))
    return m


def kabelmitte():
    """Mittelpfosten für Trizepsdrücken und Face Pulls; Ausleger zum Querträger (+z)"""
    m = Model()
    m.add("rahmen", rbox((0.42, 0.012, 0.42), 0.006, 2, center=(0, 0.006, 0)))
    for x in (-0.17, 0.17):
        for z in (-0.17, 0.17):
            leveler(m, x, z)
            m.add("stahl", cylinder(0.01, 0.009, 12, center=(x * 0.7, 0.016, z * 0.7)))
    post(m, 0, 0, 0.012, 2.36, 0.10, 0.10)
    _upright_holes(m, 0, 0, 0.6, 2.1, faces=("-z",), w=0.10, step=0.075)
    m.add("rahmen", bar([(0, 2.30, 0.0), (0, 2.30, 0.50)], 0.09, 0.10, 0.008))
    m.add("rahmen_rot", rbox((0.105, 0.05, 0.105), 0.006, 2, center=(0, 1.95, 0)))
    for y in (0.35, 1.2):
        m.add("rahmen", rbox((0.16, 0.04, 0.012), 0.004, 2, center=(0, y, -0.056)))
    return m


def rolle():
    return pulley()


def griff():
    return handle()


# MARK: Gestelle der Übungsansicht


def kniebeugenstaender():
    """Kniebeugen-Ständer; Ursprung bei z = −0.95 (Pfosten), Haken zeigen nach +z zum Körper"""
    m = Model()
    for s in (-1, 1):
        x = s * 0.65
        post(m, x, 0, 0.06, 2.30)
        _upright_holes(m, x, 0, 0.45, 2.1, faces=("+z", "-x" if s > 0 else "+x"))
        m.add("rahmen", bar([(x, 0.03, -0.32), (x, 0.03, 0.72)], 0.075, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 0.73, w=0.08, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.33, w=0.08, h=0.065, d=0.02, axis="z")
        _j_hook(m, x, 1.40, 0.0375)
        # Sicherheitsablage vorn
        m.add("rahmen", bar([(x, 0.80, 0.04), (x, 0.80, 0.50)], 0.05, 0.05, 0.005))
        m.add("rahmen_rot", rbox((0.05, 0.004, 0.40), 0.001, 1, center=(x, 0.827, 0.28)))
        # Scheibenhorn hinten mit Scheiben
        _plate_horn(m, x + s * 0.0375, 0.45, -0.20, s, ["eisen", "eisen"])
        m.add("rahmen", bar([(x, 0.45, -0.0375), (x, 0.45, -0.20)], 0.05, 0.05, 0.005))
        leveler(m, x, -0.25)
        leveler(m, x, 0.65)
    beam_x(m, -0.65, 0.65, 2.27, 0, 0.075)
    beam_x(m, -0.65, 0.65, 0.04, -0.30, 0.06)
    m.add("chrom", tube([(-0.65, 2.20, 0.06), (0.65, 2.20, 0.06)], 0.016, n=16))
    for s in (-1, 1):
        m.add("rahmen", bar([(s * 0.60, 2.20, 0.0), (s * 0.60, 2.20, 0.07)], 0.04, 0.05, 0.004))
    m.add("rahmen_rot", rbox((0.5, 0.05, 0.004), 0.002, 2, center=(0, 2.27, 0.0395)))
    return m


def bankablage():
    """Ablage für die Langhantel am Kopfende der Bank; Ursprung bei z = −0.66"""
    m = Model()
    for s in (-1, 1):
        x = s * 0.56
        post(m, x, 0, 0.05, 1.32, 0.06)
        _upright_holes(m, x, 0, 0.6, 1.25, faces=("+z",), w=0.06)
        m.add("rahmen", bar([(x, 0.025, -0.26), (x, 0.025, 0.36)], 0.06, 0.05, PROFIL_R))
        foot_cap(m, x, 0.025, 0.37, w=0.065, h=0.055, d=0.02, axis="z")
        _j_hook(m, x, 1.02, 0.03, w=0.05)
        m.add("rahmen", bar([(x, 0.72, 0.03), (x, 0.72, 0.36)], 0.045, 0.045, 0.004))
        m.add("rahmen_rot", rbox((0.045, 0.004, 0.28), 0.001, 1, center=(x, 0.7445, 0.21)))
        leveler(m, x, -0.22)
    beam_x(m, -0.56, 0.56, 0.03, -0.24, 0.06)
    return m


def klimmzuggestell():
    """Gestell, an dessen Stange (y 2.03, z 0.05, aus BodyRig) die Figur hängt"""
    m = Model()
    for s in (-1, 1):
        x = s * 0.72
        post(m, x, 0.05, 0.06, 2.32, 0.08)
        m.add("rahmen", bar([(x, 0.03, -0.45), (x, 0.03, 0.55)], 0.08, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 0.56, w=0.085, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.46, w=0.085, h=0.065, d=0.02, axis="z")
        m.add("rahmen", bar([(x, 2.28, 0.05), (x, 2.28, -0.38)], 0.07, 0.07, PROFIL_R))
        # Halter für die Stange
        m.add("rahmen", rbox((0.09, 0.10, 0.012), 0.004, 2, center=(x - s * 0.06, 2.03, 0.05)))
        m.add("chrom", cylinder(0.06, 0.022, 20), chain(T(x - s * 0.08, 2.03, 0.05), Rz(math.pi / 2)))
        leveler(m, x, -0.40)
        leveler(m, x, 0.50)
    beam_x(m, -0.72, 0.72, 2.28, -0.38, 0.07)
    m.add("rahmen_rot", rbox((0.6, 0.05, 0.004), 0.002, 2, center=(0, 2.28, -0.3445)))
    return m


# MARK: Studio-Deko an den Wänden


def kurzhantelablage():
    """Zweistöckige Ablage (3 m) mit 10 Paaren, leicht bis schwer; Ursprung in der Mitte, Vorderseite +z"""
    m = Model()
    length = 3.0
    tiers = [(0.80, 0.22), (0.38, 0.12)]
    for x in (-length / 2, 0, length / 2):
        # A-Fuß von der Seite: vorn kürzer, hinten länger
        m.add("rahmen", bar([(x, 0.03, 0.30), (x, 0.03, -0.30)], 0.06, 0.06, PROFIL_R))
        m.add("rahmen", bar([(x, 0.04, 0.18), (x, 0.76, 0.12)], 0.06, 0.06, PROFIL_R, up=(0, 0, 1)))
        m.add("rahmen", bar([(x, 0.04, -0.18), (x, 0.84, -0.14)], 0.06, 0.06, PROFIL_R, up=(0, 0, 1)))
        for z in (0.31, -0.31):
            foot_cap(m, x, 0.03, z, w=0.065, h=0.065, d=0.02, axis="z")
    for y, tilt in tiers:
        for side in (-1, 1):
            # Schienen vorn (tiefer) und hinten (höher)
            z = side * 0.11
            yy = y - side * math.sin(tilt) * 0.11
            m.add("rahmen", bar([(-length / 2 - 0.03, yy, z), (length / 2 + 0.03, yy, z)], 0.05, 0.04, 0.005))
            m.add("gummi", rbox((length, 0.006, 0.05), 0.002, 1, center=(0, yy + 0.023, z)))
    accents = ["rahmen_rot", "chrom", "aufkleber", "rahmen_rot", "chrom"]
    for pair in range(10):
        row = 0 if pair < 5 else 1
        i = pair % 5
        s = 0.70 + pair * 0.08
        y, tilt = tiers[row]
        xb = -length / 2 + 0.32 + i * (length - 0.64) / 4
        for k in (-0.13, 0.13):
            db = dumbbell()
            m.put(db, chain(T(xb + k * (0.8 + 0.2 * s), y + 0.026 + 0.059 * s, 0), Rx(tilt), Rx(math.pi / 2), S(s)))
        m.add(accents[i], quad(0.06, 0.03, center=(xb, y - math.sin(tilt) * 0.11 - 0.005, 0.1356), normal="z"))
    return m


def kettlebells():
    """Sechs Kettlebells am Boden vor der Rückwand (Weltkoordinaten)"""
    m = Model()
    colors = ["kb_rosa", "kb_blau", "kb_gelb", "kb_lila", "kb_gruen", "kb_orange"]
    for i, c in enumerate(colors):
        s = 0.8 + i * 0.08
        m.put(kettlebell(c, "guss"), chain(T(-3.35 + i * 0.30, 0, -3.70), Ry(0.2 * (i % 3 - 1)), S(s)))
    return m


def scheibenbaum():
    """Scheibenbaum mit Bumpern und Eisenscheiben; Vorderseite +z"""
    m = Model()
    # Fuß: Kreuz aus Vierkantrohr
    m.add("rahmen", bar([(-0.30, 0.03, 0), (0.30, 0.03, 0)], 0.06, 0.06, PROFIL_R))
    m.add("rahmen", bar([(0, 0.03, -0.30), (0, 0.03, 0.30)], 0.06, 0.06, PROFIL_R))
    for x, z in ((-0.31, 0), (0.31, 0), (0, -0.31), (0, 0.31)):
        foot_cap(m, x, 0.03, z, w=0.065, h=0.065, d=0.02, axis="x" if z == 0 else "z")
    post(m, 0, 0, 0.06, 1.55, 0.07)
    m.add("rahmen_rot", rbox((0.072, 0.03, 0.072), 0.004, 2, center=(0, 1.555, 0)))
    loads = {0.30: (["bumper_rot", "bumper_blau", "bumper_blau"], ["eisen", "eisen"]),
             0.79: (["bumper_gelb", "bumper_gruen"], ["eisen"]),
             1.28: (["eisen", "eisen"], ["bumper_gruen"])}
    tilt = 0.12
    for y, (front, back) in loads.items():
        for dz, plates in ((1, front), (-1, back)):
            d = np.array([0, math.sin(tilt), dz * math.cos(tilt)])
            rot = Rx(math.atan2(d[2], d[1]))
            start = np.array([0, y, dz * 0.035])
            m.add("chrom", cylinder(0.24, 0.025, 24, bevel=0.003), chain(T(*(start + d * 0.12)), rot))
            off = 0.01
            for p in plates:
                t = 0.042 if p == "eisen" else 0.062
                pl = iron_plate() if p == "eisen" else bumper(p, t=t)
                m.put(pl, chain(T(*(start + d * (off + t / 2))), rot))
                off += t + 0.004
    return m


def powerrack():
    """Power-Rack mit aufgelegter Langhantel; lokal: Front +z (zur Raummitte), Hantel bei z 0.40"""
    m = Model()
    for x in (-0.6, 0.6):
        for z in (-0.45, 0.45):
            post(m, x, z, 0.06, 2.30)
            _upright_holes(m, x, z, 0.4, 2.1, faces=("+z" if z > 0 else "-z", "-x" if x > 0 else "+x"))
        m.add("rahmen", bar([(x, 0.03, -0.62), (x, 0.03, 0.62)], 0.075, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 0.63, w=0.08, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.63, w=0.08, h=0.065, d=0.02, axis="z")
        m.add("rahmen", bar([(x, 2.27, -0.45), (x, 2.27, 0.45)], 0.075, 0.075, PROFIL_R))
        # Sicherheitsablagen innen
        m.add("rahmen", bar([(x - np.sign(x) * 0.07, 0.86, -0.50), (x - np.sign(x) * 0.07, 0.86, 0.52)], 0.05, 0.05, 0.005))
        m.add("rahmen_rot", rbox((0.05, 0.004, 0.9), 0.001, 1, center=(x - np.sign(x) * 0.07, 0.887, 0)))
        _j_hook(m, x, 1.30, 0.4875, w=0.06)
        # Scheibenhörner hinten außen
        _plate_horn(m, x + np.sign(x) * 0.0375, 0.55, -0.45, np.sign(x), ["bumper_schwarz", "eisen"])
        for z in (-0.6, 0.6):
            leveler(m, x, z)
    beam_x(m, -0.6, 0.6, 2.27, -0.45, 0.075)
    beam_x(m, -0.6, 0.6, 0.04, -0.45, 0.06)
    m.add("chrom", tube([(-0.6, 2.18, 0.45), (0.6, 2.18, 0.45)], 0.017, n=16))
    m.add("rahmen_rot", rbox((0.6, 0.05, 0.004), 0.002, 2, center=(0, 2.27, -0.4895)))
    m.add("aufkleber", quad(0.3, 0.025, center=(0, 2.27, -0.4918), normal="-z"))
    m.put(barbell(("bumper_rot", "bumper_gruen")), T(0, 1.36, 0.43))
    return m


def latzug():
    """Latzug mit Sitz und Knierollen; Turm bei z = 0, Sitz bei z 0.8 (Vorderseite +z)"""
    m = Model()
    for x in (-0.24, 0.24):
        m.add("rahmen", bar([(x, 0.03, -0.20), (x, 0.03, 1.05)], 0.07, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 1.06, w=0.075, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.21, w=0.075, h=0.065, d=0.02, axis="z")
        post(m, x, 0, 0.06, 2.20, 0.08)
        leveler(m, x, -0.15)
        leveler(m, x, 1.0)
    beam_x(m, -0.24, 0.24, 0.03, 1.0, 0.06)
    beam_x(m, -0.24, 0.24, 2.18, 0, 0.08)
    weight_stack(m, 0, 0.0, plates=14, w=0.28, d=0.14, rods=0.09, top=2.12)
    # Gewichtsabdeckung mit Schlitz für den Wahlstift, roter Streifen seitlich
    stack_shroud(m, 0, 0.0, 0.28, 0.14, 0.10, 1.95)
    for x in (-0.211, 0.211):
        m.add("rahmen_rot", rbox((0.006, 0.25, 0.20), 0.003, 2, center=(x, 1.75, 0.0)))
    # Ausleger mit Rolle und Seil
    m.add("rahmen", bar([(0, 2.24, -0.05), (0, 2.24, 0.82)], 0.08, 0.10, 0.008))
    m.put(pulley(), chain(T(0, 2.13, 0.80), Ry(math.pi)))
    m.add("seil", tube([(0, 2.07, 0.78), (0, 1.86, 0.78)], 0.0035, n=8))
    m.add("seil", tube([(0, 1.40, 0.0), (0, 2.22, 0.0), (0, 2.22, 0.12)], 0.0035, bend=0.04, n=8))
    # Latzugstange mit abgewinkelten Enden
    pts = [(-0.58, 1.74, 0.78), (-0.40, 1.84, 0.78), (0.40, 1.84, 0.78), (0.58, 1.74, 0.78)]
    m.add("chrom", tube(pts, 0.014, bend=0.06, n=16))
    for s in (-1, 1):
        m.add("griff", cylinder(0.16, 0.019, 20, bevel=0.004), chain(T(s * 0.49, 1.79, 0.78), Rz(s * (math.pi / 2 - 0.5))))
    m.add("chrom", torus(0.02, 0.005, 20, 8), chain(T(0, 1.86, 0.78), Rx(math.pi / 2)))
    # Sitz mit Säule
    m.add("rahmen", bar([(0, 0.06, 0.82), (0, 0.40, 0.82)], 0.07, 0.07, PROFIL_R, up=(0, 0, 1)))
    m.add("polster", superpad((0.40, 0.08, 0.38), 0.4, 8, center=(0, 0.46, 0.82)))
    m.add("rahmen_grau", rbox((0.3, 0.012, 0.3), 0.004, 2, center=(0, 0.414, 0.82)))
    # Knierollen
    m.add("rahmen", bar([(0, 0.06, 0.58), (0, 0.70, 0.58)], 0.06, 0.06, PROFIL_R, up=(0, 0, 1)))
    _upright_holes(m, 0, 0.58, 0.45, 0.66, faces=("+z",), w=0.06)
    m.add("chrom", cylinder(0.12, 0.015, 16), chain(T(0, 0.72, 0.62), Rz(math.pi / 2)))
    for s in (-1, 1):
        m.add("polster", lathe([(0, -0.11), (0.062, -0.11), (0.07, -0.10), (0.07, 0.10), (0.062, 0.11), (0, 0.11)], 36),
              chain(T(s * 0.17, 0.72, 0.62), Rz(math.pi / 2)))
    m.add("rahmen_grau", sphere(0.03, 16, 8, center=(0.0, 0.66, 0.66)))
    return m


def bank():
    return bench_frame()


def banklehne():
    return bench_back()


def hantelstangenhalter():
    """Senkrechter Halter für fünf Langhanteln"""
    m = Model()
    m.add("rahmen", rbox((0.62, 0.10, 0.30), 0.02, 4, center=(0, 0.05, 0)))
    m.add("gummi", rbox((0.58, 0.012, 0.26), 0.004, 2, center=(0, 0.106, 0)))
    for i in range(5):
        x = -0.24 + i * 0.12
        m.add("rahmen", tube_ring(0.12, 0.034, 0.028, 24, center=(x, 0.16, 0)))
        h = [2.2, 2.2, 2.01, 2.2, 1.8][i]
        bb = barbell(bar_only=True, axis="y")
        sc = h / 2.2
        m.put(bb, chain(T(x, 0.11 + h / 2, 0), Rz(0.03 * (i - 2)), S(1, sc, 1)))
    return m


def beinpresse():
    """45°-Beinpresse mit Schlitten und Scheiben; Sitz bei −z, Fußplatte bei +z"""
    m = Model()
    for x in (-0.36, 0.36):
        m.add("rahmen", bar([(x, 0.04, -0.98), (x, 0.04, 1.05)], 0.08, 0.08, PROFIL_R))
        foot_cap(m, x, 0.04, 1.06, w=0.085, h=0.085, d=0.02, axis="z")
        foot_cap(m, x, 0.04, -0.99, w=0.085, h=0.085, d=0.02, axis="z")
    for z in (-0.95, 0.15, 1.0):
        beam_x(m, -0.36, 0.36, 0.04, z, 0.08)
    a = math.radians(45)
    d = np.array([0, math.sin(a), math.cos(a)])
    p0 = np.array([0, 0.30, -0.20])
    p1 = p0 + d * 1.75
    # Schräge Führungsschienen mit Stützen
    for x in (-0.20, 0.20):
        m.add("rahmen", bar([(x, *p0[1:]), (x, *p1[1:])], 0.09, 0.12, 0.008, up=(0, math.cos(a), -math.sin(a))))
        top = p0 + d * 1.6
        m.add("chrom", tube([(x, top[1] - 0.95 * math.sin(a) + 0.075, top[2] - 0.95 * math.cos(a) - 0.05),
                             (x, top[1] + 0.075, top[2] - 0.05)], 0.012, n=12))
    for x in (-0.20, 0.20):
        m.add("rahmen", bar([(x, 0.08, p1[2]), (x, p1[1], p1[2])], 0.09, 0.09, PROFIL_R, up=(0, 0, 1)))
        m.add("rahmen", bar([(x, 0.08, 0.15), (x, p0[1] + d[1] * 0.35, p0[2] + d[2] * 0.35)], 0.08, 0.08, PROFIL_R, up=(0, 0, 1)))
    beam_x(m, -0.2, 0.2, p1[1] - 0.05, p1[2], 0.09)
    # Schlitten mit Fußplatte und Hantelhörnern
    sled_c = p0 + d * 1.10
    rot = Rx(-a)
    sled = Model()
    sled.add("rahmen", rbox((0.62, 0.10, 0.50), 0.02, 4, center=(0, 0.11, 0)))
    sled.add("rahmen_grau", rbox((0.78, 0.60, 0.035), 0.012, 3, center=(0, 0.30, -0.27)))
    for k in range(9):
        sled.add("gummi", rbox((0.70, 0.010, 0.006), 0.002, 1, center=(0, 0.06 + k * 0.06, -0.289)))
    sled.add("rahmen", rbox((0.05, 0.55, 0.04), 0.005, 2, center=(-0.40, 0.30, -0.23)))
    sled.add("rahmen", rbox((0.05, 0.55, 0.04), 0.005, 2, center=(0.40, 0.30, -0.23)))
    for s in (-1, 1):
        sled.add("chrom", cylinder(0.30, 0.025, 24, bevel=0.003), chain(T(s * 0.46, 0.13, 0.05), Rz(math.pi / 2)))
        off = 0.33
        for p in ("bumper_schwarz", "eisen"):
            t = 0.042 if p == "eisen" else 0.062
            pl = iron_plate() if p == "eisen" else bumper(p, t=t)
            sled.put(pl, chain(T(s * (off + t / 2), 0.13, 0.05), Rz(math.pi / 2)))
            off += t + 0.003
        # Sicherheitsgriffe
        sled.add("rahmen_rot", tube([(s * 0.31, 0.13, 0.20), (s * 0.31, 0.13, 0.32), (s * 0.24, 0.13, 0.36)], 0.012, bend=0.03))
    m.put(sled, chain(T(*sled_c), rot))
    # Sitz und Rückenlehne
    m.add("rahmen", bar([(0, 0.08, -0.55), (0, 0.36, -0.50)], 0.08, 0.08, PROFIL_R, up=(0, 0, 1)))
    m.add("rahmen", bar([(0, 0.36, -0.30), (0, 0.42, -0.95)], 0.08, 0.06, PROFIL_R))
    m.add("polster", superpad((0.50, 0.09, 0.42), 0.35, 8), chain(T(0, 0.44, -0.48), Rx(-0.12)))
    m.add("polster", superpad((0.50, 0.09, 0.70), 0.35, 8), chain(T(0, 0.75, -0.80), Rx(1.05)))
    m.add("rahmen", bar([(0, 0.45, -0.85), (0, 0.95, -0.98)], 0.07, 0.05, PROFIL_R, up=(0, 0, 1)))
    for s in (-1, 1):
        m.add("rahmen", tube([(s * 0.30, 0.42, -0.38), (s * 0.30, 0.55, -0.38), (s * 0.30, 0.55, -0.62)], 0.014, bend=0.04))
        m.add("griff", cylinder(0.14, 0.019, 20, bevel=0.004), chain(T(s * 0.30, 0.55, -0.53), Rx(math.pi / 2)))
    return m


def kraftturm():
    """Klimmzug- und Dip-Station (Power Tower) mit Rückenpolster, Armpolstern und Schlingentrainer"""
    m = Model()
    for s in (-1, 1):
        x = s * 0.55
        m.add("rahmen", bar([(x, 0.03, -0.40), (x, 0.03, 0.55)], 0.07, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 0.56, w=0.075, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.41, w=0.075, h=0.065, d=0.02, axis="z")
        m.add("rahmen", bar([(x, 0.06, -0.05), (x * 0.7, 2.32, -0.05)], 0.07, 0.07, PROFIL_R, up=(0, 0, 1)))
        leveler(m, x, -0.35)
        leveler(m, x, 0.50)
        # Dip-Griffe und Armpolster
        xd = s * 0.29
        m.add("rahmen", bar([(x * 0.86, 1.22, -0.05), (xd, 1.22, -0.05), (xd, 1.22, 0.42)], 0.05, 0.05, 0.005, bend=0.06))
        m.add("griff", cylinder(0.16, 0.02, 20, bevel=0.004), chain(T(xd, 1.22, 0.30), Rx(math.pi / 2)))
        m.add("polster", superpad((0.12, 0.06, 0.30), 0.4, 6, center=(xd, 1.28, 0.09)))
    beam_x(m, -0.38, 0.38, 2.30, -0.05, 0.07)
    beam_x(m, -0.52, 0.52, 0.60, -0.05, 0.06)
    m.add("polster", superpad((0.34, 0.06, 0.55), 0.4, 6), chain(T(0, 1.42, -0.01), Rx(-math.pi / 2)))
    m.add("rahmen", bar([(0, 1.12, -0.05), (0, 1.70, -0.05)], 0.12, 0.03, 0.004, up=(0, 0, 1)))
    # Klimmzugstange mit gewinkelten Enden
    pts = [(-0.62, 2.22, 0.22), (-0.45, 2.30, 0.18), (0.45, 2.30, 0.18), (0.62, 2.22, 0.22)]
    m.add("chrom", tube(pts, 0.016, bend=0.06, n=16))
    for s in (-1, 1):
        m.add("rahmen", bar([(s * 0.38, 2.30, -0.05), (s * 0.38, 2.30, 0.18)], 0.05, 0.05, 0.005))
        m.add("griff", cylinder(0.14, 0.02, 20, bevel=0.004), chain(T(s * 0.54, 2.26, 0.20), Rz(s * (math.pi / 2 - 0.45))))
    # Schlingentrainer
    m.add("stahl", torus(0.03, 0.006, 20, 8), chain(T(0, 2.255, 0.18), Rx(math.pi / 2)))
    for x in (-0.07, 0.07):
        m.add("gurt_gelb", sweep([(x * 0.3, 2.23, 0.18), (x, 1.30, 0.18)], rrect(0.035, 0.004, 0.0015), up=(0, 0, 1)))
        m.add("griff", cylinder(0.13, 0.016, 16, bevel=0.003), chain(T(x, 1.24, 0.18), Rz(math.pi / 2)))
        m.add("gurt_gelb", sweep(fillet([(x - 0.06, 1.24, 0.18), (x, 1.32, 0.18), (x + 0.06, 1.24, 0.18)], 0.02, 4),
                                 rrect(0.02, 0.004, 0.0015), up=(0, 0, 1)))
    return m


def brustpresse():
    """Brust- und Schulterpresse (Steckgewicht); Turm bei −z, Sitz bei +z, Benutzer schaut nach +z"""
    m = Model()
    for x in (-0.30, 0.30):
        m.add("rahmen", bar([(x, 0.03, -0.72), (x, 0.03, 0.62)], 0.07, 0.06, PROFIL_R))
        foot_cap(m, x, 0.03, 0.63, w=0.075, h=0.065, d=0.02, axis="z")
        foot_cap(m, x, 0.03, -0.73, w=0.075, h=0.065, d=0.02, axis="z")
        leveler(m, x, -0.68)
        leveler(m, x, 0.58)
    for z in (-0.68, 0.05):
        beam_x(m, -0.3, 0.3, 0.03, z, 0.06)
    for x in (-0.20, 0.20):
        post(m, x, -0.55, 0.06, 2.05, 0.08)
    beam_x(m, -0.2, 0.2, 2.02, -0.55, 0.08)
    weight_stack(m, 0, -0.55, plates=15, w=0.28, d=0.14, rods=0.09, top=1.98)
    stack_shroud(m, 0, -0.55, 0.28, 0.14, 0.10, 1.85)
    m.add("rahmen_rot", rbox((0.46, 0.10, 0.30), 0.03, 4, center=(0, 2.10, -0.55)))
    m.add("aufkleber", quad(0.24, 0.03, center=(0, 2.10, -0.3995), normal="z"))
    # Sitz und Rückenlehne
    m.add("rahmen", bar([(0, 0.06, 0.10), (0, 0.40, 0.10)], 0.08, 0.08, PROFIL_R, up=(0, 0, 1)))
    _upright_holes(m, 0, 0.10, 0.15, 0.38, faces=("+z",), w=0.08)
    m.add("polster", superpad((0.46, 0.09, 0.42), 0.35, 8, center=(0, 0.47, 0.12)))
    m.add("rahmen", bar([(0, 0.40, -0.10), (0, 1.40, -0.20)], 0.08, 0.06, PROFIL_R, up=(0, 0, 1)))
    m.add("rahmen", bar([(0, 0.40, 0.10), (0, 0.40, -0.12)], 0.07, 0.06, PROFIL_R))
    m.add("polster", superpad((0.44, 0.09, 0.72), 0.35, 8), chain(T(0, 0.98, -0.11), Rx(-math.pi / 2 + 0.12)))
    # Pressarme: Drehpunkt oben hinter der Lehne, Griffe vorn
    m.add("rahmen", bar([(0, 1.78, -0.55), (0, 1.78, -0.22)], 0.08, 0.08, PROFIL_R))
    m.add("stahl", cylinder(0.78, 0.022, 20), chain(T(0, 1.78, -0.22), Rz(math.pi / 2)))
    for s in (-1, 1):
        pts = [(s * 0.36, 1.78, -0.22), (s * 0.40, 1.60, -0.05), (s * 0.40, 1.28, 0.25), (s * 0.34, 1.18, 0.42)]
        m.add("rahmen", tube(pts, 0.025, bend=0.12, n=16))
        m.add("griff", cylinder(0.16, 0.02, 20, bevel=0.004), chain(T(s * 0.34, 1.18, 0.45), Ry(0), Rz(0)))
        m.add("griff", cylinder(0.14, 0.02, 20, bevel=0.004), chain(T(s * 0.27, 1.21, 0.42), Rz(math.pi / 2)))
        m.add("rahmen", tube([(s * 0.34, 1.21, 0.42), (s * 0.20, 1.21, 0.42)], 0.014, n=12))
    m.add("rahmen_rot", sphere(0.025, 16, 8, center=(0.0, 0.32, 0.17)))
    return m


def cardio():
    """Laufband (x −0.55) und Indoor-Bike (x 0.75); Konsole/Lenker bei +z"""
    m = Model()
    tx = -0.55
    # Laufband: Rahmen, Band, Seitenleisten, Motorhaube, Holme, Konsole, Handläufe
    m.add("kunststoff", rbox((0.80, 0.14, 1.75), 0.03, 4, center=(tx, 0.11, -0.05)))
    m.add("band", rbox((0.52, 0.012, 1.62), 0.004, 2, center=(tx, 0.186, -0.08)))
    for s in (-1, 1):
        m.add("stahl", rbox((0.12, 0.014, 1.6), 0.005, 2, center=(tx + s * 0.33, 0.188, -0.08)))
        m.add("gummi", rbox((0.10, 0.004, 1.5), 0.001, 1, center=(tx + s * 0.33, 0.197, -0.08)))
        m.add("stahl", cylinder(0.02, 0.05, 24), chain(T(tx + s * 0.405, 0.12, -0.88), Rz(math.pi / 2)))
    m.add("kunststoff", superpad((0.82, 0.20, 0.36), 0.45, 8, center=(tx, 0.15, 0.78)))
    m.add("rahmen_rot", rbox((0.5, 0.006, 0.02), 0.002, 1, center=(tx, 0.248, 0.62)))
    for s in (-1, 1):
        pts = [(tx + s * 0.37, 0.20, 0.80), (tx + s * 0.37, 0.80, 0.86), (tx + s * 0.33, 1.20, 0.80)]
        m.add("rahmen_grau", sweep(fillet(pts, 0.25, 10), rrect(0.07, 0.05, 0.015), up=(0, 0, 1)))
        hr = [(tx + s * 0.32, 1.17, 0.74), (tx + s * 0.34, 1.05, 0.55), (tx + s * 0.34, 1.02, 0.30)]
        m.add("rahmen_grau", tube(hr, 0.018, bend=0.1, n=14))
        m.add("griff", cylinder(0.20, 0.022, 20, bevel=0.005), chain(T(tx + s * 0.34, 1.03, 0.38), Rx(math.pi / 2 - 0.12)))
    con = Model()
    con.add("kunststoff", rbox((0.84, 0.28, 0.08), 0.03, 5))
    con.add("display", quad(0.40, 0.17, center=(0, 0.02, -0.041), normal="-z"))
    for k in range(5):
        con.add("display_licht", quad(0.05, 0.018 + k * 0.012, center=(-0.14 + k * 0.07, -0.02 + k * 0.006, -0.0415),
                                      normal="-z"))
    for s in (-1, 1):
        for k in range(3):
            con.add("kunststoff_hell", cylinder(0.006, 0.012, 16), chain(T(s * 0.29, 0.06 - k * 0.05, -0.04), Rx(math.pi / 2)))
    con.add("rahmen_rot", rbox((0.84, 0.02, 0.082), 0.005, 2, center=(0, -0.13, 0)))
    m.put(con, chain(T(tx, 1.30, 0.80), Rx(0.45)))
    # Indoor-Bike
    bx = 0.75
    for z in (0.42, -0.45):
        m.add("rahmen", tube([(bx - 0.26, 0.04, z), (bx + 0.26, 0.04, z)], 0.03, n=16, up=(0, 0, 1)))
        for s in (-1, 1):
            m.add("gummi", cylinder(0.03, 0.035, 16, bevel=0.006), T(bx + s * 0.26, 0.015, z))
    frame = [(bx, 0.07, 0.40), (bx, 0.32, 0.12), (bx, 0.30, -0.12), (bx, 0.07, -0.42)]
    m.add("rahmen", sweep(fillet(frame, 0.12, 8), rrect(0.06, 0.08, 0.02), up=(1, 0, 0)))
    m.add("rahmen", sweep(fillet([(bx, 0.32, 0.12), (bx, 0.90, 0.30)], 0.05, 4), rrect(0.06, 0.08, 0.02), up=(1, 0, 0)))
    m.add("rahmen", sweep([(bx, 0.32, -0.02), (bx, 0.72, -0.24)], rrect(0.05, 0.07, 0.02), up=(1, 0, 0)))
    m.add("stahl", bar([(bx, 0.70, -0.23), (bx, 0.92, -0.33)], 0.035, 0.035, 0.008, up=(0, 0, 1)))
    # Sattel
    m.add("polster", superpad((0.16, 0.06, 0.26), 0.5, 8), chain(T(bx, 0.95, -0.34), S(1, 1, 1)))
    m.add("polster", superpad((0.07, 0.05, 0.16), 0.5, 6), T(bx, 0.95, -0.22))
    # Lenker
    m.add("stahl", bar([(bx, 0.88, 0.30), (bx, 1.08, 0.36)], 0.035, 0.035, 0.008, up=(0, 0, 1)))
    hb = [(bx - 0.22, 1.18, 0.48), (bx - 0.22, 1.10, 0.36), (bx + 0.22, 1.10, 0.36), (bx + 0.22, 1.18, 0.48)]
    m.add("rahmen", tube(hb, 0.014, bend=0.06, n=14))
    for s in (-1, 1):
        m.add("griff", cylinder(0.14, 0.018, 16, bevel=0.004), chain(T(bx + s * 0.22, 1.13, 0.40), Rx(math.pi / 2 - 0.9)))
    m.add("display", rbox((0.10, 0.06, 0.025), 0.006, 2, center=(bx, 1.14, 0.36)))
    # Schwungrad mit Abdeckung, Kurbel und Pedale
    m.add("stahl", lathe([(0.03, -0.02), (0.20, -0.02), (0.21, -0.012), (0.21, 0.012), (0.20, 0.02), (0.03, 0.02),
                          (0.03, -0.02)], 64), chain(T(bx, 0.36, 0.28), Rz(math.pi / 2)))
    for s in (-1, 1):
        m.add("rahmen_rot", lathe([(0, 0), (0.17, 0), (0.18, 0.006), (0.0, 0.008)], 48),
              chain(T(bx + s * 0.022, 0.36, 0.28), Rz(-s * math.pi / 2)))
    m.add("chrom", cylinder(0.08, 0.035, 24), chain(T(bx, 0.32, 0.0), Rz(math.pi / 2)))
    for s, ang in ((-1, 0.6), (1, 0.6 + math.pi)):
        ex, ey = 0.17 * math.sin(ang), -0.17 * math.cos(ang)
        m.add("stahl", bar([(bx + s * 0.06, 0.32, 0.0), (bx + s * 0.06, 0.32 + ey, ex)], 0.03, 0.012, 0.004, up=(1, 0, 0)))
        m.add("kunststoff", rbox((0.10, 0.025, 0.08), 0.008, 2, center=(bx + s * 0.12, 0.32 + ey, ex)))
    return m


def medizinbaelle():
    """Zweistöckiges Ballregal mit Medizinbällen"""
    m = Model()
    for x in (-0.18, 0.18):
        for z in (-0.42, 0.42):
            post(m, x, z, 0.0, 0.75, 0.04)
    for y in (0.15, 0.55):
        for x in (-0.12, 0.12):
            beam_z(m, -0.44, 0.44, y, x, 0.03, 0.03)
        for z in (-0.42, 0.42):
            beam_x(m, -0.18, 0.18, y, z, 0.04)
    balls = [("ball_orange", 0.12), ("ball_gruen", 0.13), ("ball_lila", 0.115)]
    for k, (mat, r) in enumerate(balls):
        for y, dz in ((0.55, 0.0), (0.15, 0.03)):
            c = (0, y + r * 0.8, -0.28 + k * 0.28 + dz)
            m.add(mat if y > 0.3 else "bumper_schwarz", sphere(r, 32, 16, center=c))
            m.add("gummi", torus(r * 1.002, 0.003, 48, 6), chain(T(*c), Rz(0.6 + k)))
    return m


def baender():
    """Wandleiste mit fünf Widerstandsbändern (lange Schlaufen)"""
    m = Model()
    m.add("rahmen", rbox((0.72, 0.06, 0.03), 0.006, 2, center=(0, 1.60, 0.015)))
    cols = ["gurt_gelb", "bumper_rot", "bumper_gruen", "bumper_blau", "bumper_schwarz"]
    for k, c in enumerate(cols):
        x = -0.24 + k * 0.12
        m.add("chrom", tube([(x, 1.62, 0.03), (x, 1.62, 0.08), (x, 1.66, 0.09)], 0.006, bend=0.01, n=10))
        a = np.linspace(0, 2 * math.pi, 40, endpoint=False)
        loop = np.stack([x + 0.018 * np.sin(a), 1.25 + 0.37 * np.cos(a), 0.075 + 0.004 * np.sin(a)], 1)
        m.add(c, sweep(loop, rrect(0.004, 0.022 + 0.004 * k, 0.0018), up=(0, 0, 1), closed=True))
    return m


def kurzhantel():
    """Kurzhantel für die Figur (Achse y)"""
    return dumbbell()


def langhantel():
    """Langhantel für die Figur, mit roten Bumpern (Achse x)"""
    return barbell(("bumper_rot", "bumper_schwarz"))


MODELLE = {
    "Kabelsaeule": kabelsaeule,
    "KabelBruecke": kabelbruecke,
    "KabelMitte": kabelmitte,
    "Rolle": rolle,
    "Griff": griff,
    "Kniebeugenstaender": kniebeugenstaender,
    "Bankablage": bankablage,
    "Klimmzuggestell": klimmzuggestell,
    "Kurzhantelablage": kurzhantelablage,
    "Kettlebells": kettlebells,
    "Scheibenbaum": scheibenbaum,
    "PowerRack": powerrack,
    "Latzug": latzug,
    "Bank": bank,
    "BankLehne": banklehne,
    "Hantelstangenhalter": hantelstangenhalter,
    "Beinpresse": beinpresse,
    "Kraftturm": kraftturm,
    "Brustpresse": brustpresse,
    "Cardio": cardio,
    "Medizinbaelle": medizinbaelle,
    "Baender": baender,
    "Kurzhantel": kurzhantel,
    "Langhantel": langhantel,
}
