"""Procedural anatomy 'sculpt': adds muscle bellies and separation grooves on top of the
MakeHuman body so the mannequin reads like a defined, lean athlete (six-pack, pec line,
delt / biceps / triceps separation, quad teardrop, calves, back details).

Everything is expressed relative to the rest-pose joint positions J, so it adapts to
other body shapes. Displacement is applied along vertex normals."""
import numpy as np


def _ss(e0, e1, x):
    t = np.clip((x - e0) / (e1 - e0), 0, 1)
    return t * t * (3 - 2 * t)


def _gauss(d, w):
    return np.exp(-(d / w) ** 2)


def _seg_dist2d(P, pts):
    """min distance from points P (n,2) to a polyline pts (k,2)."""
    best = np.full(len(P), 1e9)
    for a, b in zip(pts[:-1], pts[1:]):
        ab = b - a
        t = np.clip(((P - a) @ ab) / (ab @ ab), 0, 1)
        d = np.linalg.norm(P - (a + t[:, None] * ab), axis=1)
        best = np.minimum(best, d)
    return best


class Limb:
    """Cylindrical coordinates around a limb segment A->B.
    t: 0..1 along the limb, ang: angle around it (0 = front, +90 = lateral/outside)."""

    def __init__(self, P, A, B, lateral_sign):
        ab = B - A
        self.L = np.linalg.norm(ab); u = ab / self.L
        self.t = ((P - A) @ u) / self.L
        r = P - (A + np.outer(self.t, ab))
        self.rad = np.linalg.norm(r, axis=1)
        front = np.array([0, -1.0, 0]); front = front - u * (front @ u); front /= np.linalg.norm(front)
        side = np.cross(u, front)
        # make 'side' point to the outside of the body
        if np.sign(side[0]) != lateral_sign:
            side = -side
        self.ang = np.degrees(np.arctan2(r @ side, r @ front))

    def feature(self, t0, t1, a0, aw, tsoft=0.08):
        along = _ss(t0 - tsoft, t0 + tsoft, self.t) * (1 - _ss(t1 - tsoft, t1 + tsoft, self.t))
        da = (self.ang - a0 + 180) % 360 - 180
        return along * _gauss(da, aw)

    def line(self, t0, t1, a_of_t, w_deg, tsoft=0.05):
        """groove along the limb following angle a_of_t(t)."""
        along = _ss(t0 - tsoft, t0 + tsoft, self.t) * (1 - _ss(t1 - tsoft, t1 + tsoft, self.t))
        da = (self.ang - a_of_t(self.t) + 180) % 360 - 180
        return along * _gauss(da, w_deg)

    def ring(self, tc, w_t, a0, aw):
        da = (self.ang - a0 + 180) % 360 - 180
        return _gauss(self.t - tc, w_t) * _gauss(da, aw)


def sculpt(P, N, J, strength=1.0, groups=None):
    """Return displacement (n,) along normals. groups: per-region multipliers
    (chest, abs, obliques, back, glutes, shoulders, arms, forearms, legs, calves)."""
    groups = groups or {}
    G = lambda k: groups.get(k, 1.0)
    n = len(P)
    disp = np.zeros(n)
    x, y, z = P[:, 0], P[:, 1], P[:, 2]
    ax = np.abs(x)
    nf = -N[:, 1]          # facing front
    nb = N[:, 1]           # facing back

    neck, pelvis, sp2 = J["neck"], J["pelvis"], J["spine2"]
    H = neck[2] - pelvis[2]                    # torso height (~0.56)
    zc = lambda f: pelvis[2] + f * H           # 0 = pelvis joint, 1 = neck base

    # torso masks (exclude arms: they hang outside |x| > shoulder width at these heights)
    shoulder_x = abs(J["shoulderL"][0])
    torso = (1 - _ss(shoulder_x * 0.85, shoulder_x * 1.05, ax)) * _ss(zc(-0.15), zc(0.0), z) * \
            (1 - _ss(zc(1.0), zc(1.08), z))
    front = torso * _ss(0.15, 0.55, nf)
    back = torso * _ss(0.15, 0.55, nb)
    XZ = np.stack([ax, z], 1)       # mirrored (x>=0) front-projection coords

    _s0 = disp.copy()
    # ---------------------------------------------------------- chest
    pec_c = np.array([0.085, zc(0.69)])
    q = (XZ - pec_c) / np.array([0.10, 0.075])
    pec = (1 - _ss(0.5, 1.0, np.linalg.norm(q, axis=1)))
    disp += front * pec * 0.007
    pec_line = np.array([[0.0, zc(0.56)], [0.05, zc(0.545)], [0.11, zc(0.56)], [0.16, zc(0.63)],
                         [0.19, zc(0.74)]])
    disp -= front * _gauss(_seg_dist2d(XZ, pec_line), 0.010) * 0.0055
    disp -= front * _gauss(ax, 0.007) * _ss(zc(0.55), zc(0.62), z) * (1 - _ss(zc(0.85), zc(0.92), z)) * 0.004

    disp = _s0 + (disp - _s0) * G("chest")

    _s0 = disp.copy()
    # ------------------------------------------------------------ abs
    abs_top, abs_bot = zc(0.52), zc(0.03)
    absreg = front * (1 - _ss(0.075, 0.1, ax)) * _ss(abs_bot - 0.02, abs_bot + 0.02, z) * \
             (1 - _ss(abs_top - 0.01, abs_top + 0.02, z))
    lines = [zc(0.44), zc(0.32), zc(0.20)]
    rows = [abs_top, *lines, abs_bot]
    for i in range(4):
        zt, zb = rows[i], rows[i + 1]
        if i == 3:
            zb = zc(0.05)
        cz = (zt + zb) / 2; hz = (zt - zb) / 2
        for sx in (0.037,):
            qq = (XZ - np.array([sx, cz])) / np.array([0.036, hz * 1.05])
            blk = 1 - _ss(0.45, 1.0, np.linalg.norm(qq, axis=1))
            disp += absreg * blk * (0.0055 if i < 3 else 0.004)
    for zl in lines:
        curve = np.array([[0.0, zl - 0.004], [0.04, zl], [0.08, zl + 0.008]])
        disp -= absreg * _gauss(_seg_dist2d(XZ, curve), 0.0065) * 0.0045
    disp -= front * _gauss(ax, 0.0055) * _ss(zc(0.02), zc(0.1), z) * (1 - _ss(zc(0.52), zc(0.56), z)) * 0.0045
    semil = np.array([[0.095, zc(0.55)], [0.092, zc(0.35)], [0.078, zc(0.12)], [0.05, zc(-0.05)]])
    disp -= front * _gauss(_seg_dist2d(XZ, semil), 0.008) * 0.004
    # adonis / iliac furrow
    iliac = np.array([[0.14, zc(0.13)], [0.10, zc(0.02)], [0.05, zc(-0.12)]])
    disp -= torso * _ss(0.0, 0.4, nf) * _gauss(_seg_dist2d(XZ, iliac), 0.010) * 0.005
    disp = _s0 + (disp - _s0) * G("abs")

    _s0 = disp.copy()
    # obliques / serratus
    obl = (1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.125, zc(0.25)])) / np.array([0.04, 0.12]), axis=1)))
    disp += torso * _ss(-0.2, 0.5, nf) * obl * 0.004
    for k in range(3):
        sc = np.array([0.135 - k * 0.004, zc(0.52 - k * 0.07)])
        s = 1 - _ss(0.4, 1.0, np.linalg.norm((XZ - sc) / np.array([0.02, 0.016]), axis=1))
        disp += torso * _ss(-0.3, 0.3, nf) * s * 0.0025

    disp = _s0 + (disp - _s0) * G("obliques")

    _s0 = disp.copy()
    # ------------------------------------------------------------- back
    disp -= back * _gauss(ax, 0.009) * _ss(zc(-0.05), zc(0.05), z) * 0.0055
    erect = 1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.035, zc(0.2)])) / np.array([0.03, 0.2]), axis=1))
    disp += back * erect * 0.005
    lat = 1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.12, zc(0.55)])) / np.array([0.07, 0.2]), axis=1))
    disp += back * lat * 0.006
    scap = np.array([[0.05, zc(0.92)], [0.06, zc(0.75)], [0.11, zc(0.62)], [0.16, zc(0.7)]])
    disp -= back * _gauss(_seg_dist2d(XZ, scap), 0.010) * 0.0035
    trap = 1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.0, zc(0.85)])) / np.array([0.12, 0.18]), axis=1))
    disp += back * trap * 0.004

    disp = _s0 + (disp - _s0) * G("back")

    _s0 = disp.copy()
    # ------------------------------------------------------------ glutes
    gl = 1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.085, zc(-0.17)])) / np.array([0.09, 0.11]), axis=1))
    glute_mask = _ss(0.0, 0.5, nb) * (1 - _ss(0.2, 0.24, ax))
    disp += glute_mask * gl * 0.007
    fold = np.array([[0.02, zc(-0.33)], [0.08, zc(-0.36)], [0.15, zc(-0.32)]])
    disp -= glute_mask * _gauss(_seg_dist2d(XZ, fold), 0.012) * 0.005

    disp = _s0 + (disp - _s0) * G("glutes")

    # ------------------------------------------------------------- limbs
    for s, sign in (("L", 1), ("R", -1)):
        side = (np.sign(x) == sign)
        _s0 = disp.copy()
        # shoulder / delts (sphere around shoulder joint)
        sh = J[f"shoulder{s}"]
        d = np.linalg.norm((P - (sh + np.array([sign * 0.025, 0, 0.0]))) / np.array([0.085, 0.085, 0.10]), axis=1)
        disp += side * (1 - _ss(0.5, 1.0, d)) * 0.008

        disp = _s0 + (disp - _s0) * G("shoulders")

        _s0 = disp.copy()
        ua = Limb(P, J[f"shoulder{s}"], J[f"elbow{s}"], sign)
        armmask = side * _ss(-0.05, 0.05, ua.t) * (1 - _ss(1.0, 1.1, ua.t)) * (1 - _ss(0.07, 0.09, ua.rad))
        disp += armmask * ua.feature(0.32, 0.85, 0, 55) * 0.007        # biceps
        disp += armmask * ua.feature(0.2, 0.8, 180, 60) * 0.006        # triceps
        disp += armmask * ua.feature(0.45, 0.75, -150, 25) * 0.003     # long head
        disp -= armmask * ua.line(0.35, 0.95, lambda t: 95 - 10 * t, 14) * 0.004  # bi/tri groove (lateral)
        disp -= armmask * ua.line(0.35, 0.9, lambda t: -95, 14) * 0.003           # medial groove
        disp -= armmask * ua.line(0.3, 0.55, lambda t: 40 + 120 * (t - 0.3), 18) * 0.004   # delt insertion V
        disp -= armmask * ua.ring(0.42, 0.05, 120, 50) * 0.003
        disp = _s0 + (disp - _s0) * G("arms")

        _s0 = disp.copy()
        # deltoid edge to chest
        delt_pec = np.array([[0.2, zc(0.62)], [0.17, zc(0.82)], [0.13, zc(0.95)]])
        disp -= side * _ss(0.2, 0.5, nf) * _gauss(_seg_dist2d(XZ, delt_pec), 0.010) * 0.004

        disp = _s0 + (disp - _s0) * G("shoulders")

        _s0 = disp.copy()
        fa = Limb(P, J[f"elbow{s}"], J[f"wrist{s}"], sign)
        famask = side * (1 - _ss(0.06, 0.075, fa.rad)) * _ss(-0.05, 0.02, fa.t) * (1 - _ss(0.95, 1.0, fa.t))
        disp += famask * fa.feature(0.0, 0.45, 60, 50) * 0.006         # brachioradialis
        disp += famask * fa.feature(0.05, 0.5, -60, 50) * 0.004        # flexors
        disp -= famask * fa.line(0.2, 0.8, lambda t: 140, 18) * 0.002

        disp = _s0 + (disp - _s0) * G("forearms")

        _s0 = disp.copy()
        th = Limb(P, J[f"upleg{s}"], J[f"knee{s}"], sign)
        legmask = side * _ss(0.02, 0.12, th.t) * (1 - _ss(1.02, 1.12, th.t)) * (1 - _ss(0.12, 0.14, th.rad))
        disp += legmask * th.feature(0.15, 0.85, -5, 30) * 0.006       # rectus femoris
        disp += legmask * th.feature(0.25, 0.92, 55, 35) * 0.007       # vastus lateralis
        disp += legmask * th.feature(0.68, 0.95, -55, 28) * 0.009      # vastus medialis teardrop
        disp += legmask * th.feature(0.2, 0.85, 160, 45) * 0.005       # hamstrings
        disp -= legmask * th.line(0.15, 0.9, lambda t: 28 + 5 * t, 9) * 0.0055     # RF / VL
        disp -= legmask * th.line(0.45, 0.92, lambda t: -30 - 25 * (t - 0.45), 9) * 0.005  # RF / VMO
        disp -= legmask * th.line(0.05, 0.95, lambda t: 35 - 110 * t, 10) * 0.0035   # sartorius
        disp -= legmask * th.line(0.2, 0.95, lambda t: 100, 12) * 0.004             # IT band
        disp -= legmask * th.line(0.3, 0.9, lambda t: 180, 12) * 0.0025
        disp = _s0 + (disp - _s0) * G("legs")

        _s0 = disp.copy()
        # knee
        kn = Limb(P, J[f"knee{s}"], J[f"ankle{s}"], sign)
        kmask = side * (1 - _ss(0.09, 0.11, kn.rad))
        disp += kmask * kn.feature(-0.08, 0.04, 0, 30) * 0.003
        disp -= kmask * kn.ring(0.08, 0.035, 0, 60) * 0.003
        # calves
        disp += kmask * kn.feature(0.08, 0.45, 145, 35) * 0.010        # gastroc lateral
        disp += kmask * kn.feature(0.08, 0.55, -150, 35) * 0.012       # gastroc medial
        disp -= kmask * kn.line(0.08, 0.5, lambda t: 180, 8) * 0.004
        disp += kmask * kn.feature(0.1, 0.7, 50, 25) * 0.004           # tibialis
        disp -= kmask * kn.line(0.1, 0.8, lambda t: 20, 10) * 0.003     # shin line
        disp = _s0 + (disp - _s0) * G("calves")

    # ------------------------------------------------------------ joints / bony landmarks
    _s0 = disp.copy()
    # clavicles + sternal notch
    clav = np.array([[0.025, zc(1.0)], [0.09, zc(0.985)], [0.16, zc(1.0)], [0.2, zc(1.02)]])
    cl_mask = _ss(0.1, 0.5, nf) * (1 - _ss(zc(1.12), zc(1.2), z)) * _ss(zc(0.85), zc(0.9), z) * (1 - _ss(0.22, 0.26, ax))
    disp += cl_mask * _gauss(_seg_dist2d(XZ, clav), 0.009) * 0.0035
    disp -= cl_mask * _gauss(_seg_dist2d(XZ, clav - np.array([0, 0.02])), 0.008) * 0.002
    disp -= cl_mask * _gauss(np.linalg.norm(XZ - np.array([0.0, zc(1.0)]), axis=1), 0.014) * 0.004
    # sternocleidomastoid lines on the neck
    nk = neck[2]
    neck_mask = _ss(0.0, 0.4, nf) * _ss(nk - 0.02, nk + 0.01, z) * (1 - _ss(nk + 0.12, nk + 0.16, z)) * (1 - _ss(0.07, 0.09, ax))
    scm = np.array([[0.055, nk + 0.13], [0.035, nk + 0.06], [0.014, nk - 0.005]])
    disp += neck_mask * _gauss(_seg_dist2d(XZ, scm), 0.008) * 0.004
    for s, sign in (("L", 1), ("R", -1)):
        side = (np.sign(x) == sign)
        kn = Limb(P, J[f"knee{s}"], J[f"ankle{s}"], sign)
        kmask = side * (1 - _ss(0.09, 0.11, kn.rad))
        disp += kmask * kn.feature(-0.10, 0.03, 0, 32) * 0.006          # patella
        disp += kmask * kn.feature(0.04, 0.12, 0, 22) * 0.002            # patellar tendon
        an = J[f"ankle{s}"]
        for dx, amp in ((0.032, 0.004), (-0.028, 0.0035)):              # malleoli
            c = an + np.array([sign * dx, 0.005, 0.005])
            disp += side * (1 - _ss(0.008, 0.02, np.linalg.norm(P - c, axis=1))) * amp
        ua = Limb(P, J[f"shoulder{s}"], J[f"elbow{s}"], sign)
        disp += side * (1 - _ss(0.06, 0.08, ua.rad)) * ua.feature(0.93, 1.04, 180, 30) * 0.004   # olecranon
        fa = Limb(P, J[f"elbow{s}"], J[f"wrist{s}"], sign)
        disp += side * (1 - _ss(0.05, 0.065, fa.rad)) * fa.feature(0.9, 1.0, 150, 30) * 0.003    # ulnar head
    disp = _s0 + (disp - _s0) * G("joints")
    # trapezius slope rising onto the neck (visible from the front)
    _s0 = disp.copy()
    tr = 1 - _ss(0.5, 1.0, np.linalg.norm((XZ - np.array([0.085, nk + 0.015])) / np.array([0.075, 0.05]), axis=1))
    disp += tr * _ss(-0.2, 0.4, N[:, 2] + 0.3 * nb) * (1 - _ss(0.18, 0.22, ax)) * 0.012
    disp = _s0 + (disp - _s0) * G("traps")

    return disp * strength
