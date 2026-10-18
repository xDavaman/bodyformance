"""Baukasten für Geräte-Modelle: Grundformen als Dreiecksnetze mit Normalen.

Alle Maße in Metern, y zeigt nach oben. Ein Netz ist ein Tupel (v, n, f): Punkte (N, 3), Normalen (N, 3) und
Dreiecke (M, 3). `Model` sammelt Netze je Material und kann Teile verschieben, drehen und spiegeln.
"""
import math

import numpy as np

# MARK: Transformationen


def T(x=0.0, y=0.0, z=0.0):
    m = np.eye(4)
    m[:3, 3] = (x, y, z)
    return m


def S(x, y=None, z=None):
    m = np.eye(4)
    m[0, 0], m[1, 1], m[2, 2] = x, x if y is None else y, x if z is None else z
    return m


def _rot(axis, a):
    c, s = math.cos(a), math.sin(a)
    m = np.eye(4)
    i, j = {"x": (1, 2), "y": (2, 0), "z": (0, 1)}[axis]
    m[i, i], m[i, j], m[j, i], m[j, j] = c, -s, s, c
    return m


def Rx(a):
    return _rot("x", a)


def Ry(a):
    return _rot("y", a)


def Rz(a):
    return _rot("z", a)


def chain(*ms):
    """Produkt der Matrizen; die letzte wirkt zuerst (wie M1 @ M2 @ …)."""
    out = np.eye(4)
    for m in ms:
        out = out @ m
    return out


def apply(m, part):
    v, n, f = part
    v2 = v @ m[:3, :3].T + m[:3, 3]
    nm = np.linalg.inv(m[:3, :3]).T
    n2 = n @ nm.T
    n2 /= np.maximum(np.linalg.norm(n2, axis=1, keepdims=True), 1e-12)
    f2 = f.copy()
    if np.linalg.det(m[:3, :3]) < 0:
        f2 = f2[:, ::-1]
    return v2, n2, f2


def orient(part):
    """Dreht jedes Dreieck so, dass seine Vorderseite zur Normalen der Punkte zeigt."""
    v, n, f = part
    if len(f) == 0:
        return part
    a, b, c = v[f[:, 0]], v[f[:, 1]], v[f[:, 2]]
    fn = np.cross(b - a, c - a)
    avg = n[f[:, 0]] + n[f[:, 1]] + n[f[:, 2]]
    flip = np.einsum("ij,ij->i", fn, avg) < 0
    f = f.copy()
    f[flip] = f[flip][:, ::-1]
    return v, n, f


def merge(parts):
    vs, ns, fs, off = [], [], [], 0
    for v, n, f in parts:
        vs.append(v)
        ns.append(n)
        fs.append(f + off)
        off += len(v)
    if not vs:
        return np.zeros((0, 3)), np.zeros((0, 3)), np.zeros((0, 3), int)
    return np.concatenate(vs), np.concatenate(ns), np.concatenate(fs)


class Model:
    """Netze je Material"""

    def __init__(self):
        self.parts = {}

    def add(self, mat, part, m=None):
        if m is not None:
            part = apply(m, part)
        self.parts.setdefault(mat, []).append(orient(part))
        return self

    def put(self, other, m=None):
        """Fügt ein anderes Modell ein (optional verschoben/gedreht)"""
        for mat, lst in other.parts.items():
            for p in lst:
                self.add(mat, p, m)
        return self

    def merged(self):
        return {mat: merge(lst) for mat, lst in self.parts.items()}

    def bounds(self):
        allv = np.concatenate([p[0] for lst in self.parts.values() for p in lst])
        return allv.min(axis=0), allv.max(axis=0)

    def triangles(self):
        return sum(len(p[2]) for lst in self.parts.values() for p in lst)


# MARK: Grundformen


def rbox(size, r=0.0, n=4, center=(0, 0, 0)):
    """Quader mit gerundeten Kanten (Radius r, n Teilungen je Rundung)"""
    h = np.array(size, float) / 2
    r = float(min(r, *h)) if r > 0 else 0.0
    cen = np.array(center, float)

    def axis_vals(hx):
        if r <= 1e-6:
            return np.array([-hx, hx])
        a = np.linspace(-hx, -hx + r, n + 1)
        b = np.linspace(hx - r, hx, n + 1)
        if hx - r > 1e-6:
            return np.concatenate([a, b])
        return np.concatenate([a, b[1:]])

    parts = []
    for ax in range(3):
        for s in (-1, 1):
            u, w = [(1, 2), (2, 0), (0, 1)][ax]
            uu, ww = axis_vals(h[u]), axis_vals(h[w])
            gu, gw = np.meshgrid(uu, ww, indexing="ij")
            p = np.zeros(gu.shape + (3,))
            p[..., ax] = s * h[ax]
            p[..., u] = gu
            p[..., w] = gw
            p = p.reshape(-1, 3)
            inner = np.clip(p, -h + r, h - r)
            d = p - inner
            ln = np.linalg.norm(d, axis=1, keepdims=True)
            fn = np.zeros(3)
            fn[ax] = s
            nn = np.where(ln > 1e-9, d / np.maximum(ln, 1e-12), fn)
            pos = np.where(ln > 1e-9, inner + r * nn, p)
            nu, nw = len(uu), len(ww)
            idx = np.arange(nu * nw).reshape(nu, nw)
            q = np.stack([idx[:-1, :-1], idx[1:, :-1], idx[1:, 1:], idx[:-1, 1:]], -1).reshape(-1, 4)
            f = np.concatenate([q[:, [0, 1, 2]], q[:, [0, 2, 3]]])
            parts.append((pos + cen, nn, f))
    return merge(parts)


def _seg_normals(prof):
    p = np.asarray(prof, float)
    d = p[1:] - p[:-1]
    nrm = np.stack([d[:, 1], -d[:, 0]], 1)
    return nrm / np.maximum(np.linalg.norm(nrm, axis=1, keepdims=True), 1e-12)


def lathe(profile, seg=48, crease=35, flat=False, phase=0.0, arc=None):
    """Drehteil um die y-Achse. `profile`: Liste (r, y) von unten-innen nach oben-innen (Außenseite rechts der
    Laufrichtung). Knicke über `crease` Grad bleiben scharf. `flat`: Seitenflächen eben (z. B. Sechskant)."""
    p = np.asarray(profile, float)
    sn = _seg_normals(p)
    cos_c = math.cos(math.radians(crease))
    rings = []  # (r, y, nr, ny)
    for i in range(len(p) - 1):
        for k, j in ((0, i), (1, i + 1)):
            nrm = sn[i]
            other = i - 1 if k == 0 else i + 1
            if 0 <= other < len(sn) and np.dot(sn[other], sn[i]) > cos_c:
                nrm = sn[i] + sn[other]
                nrm = nrm / np.linalg.norm(nrm)
            rings.append((p[j, 0], p[j, 1], nrm[0], nrm[1]))
    rings = np.array(rings)
    total = arc if arc is not None else 2 * math.pi
    parts = []
    if flat:
        for k in range(seg):
            a0, a1 = phase + total * k / seg, phase + total * (k + 1) / seg
            am = (a0 + a1) / 2
            vs, ns = [], []
            for a in (a0, a1):
                c0, s0 = math.cos(a), math.sin(a)
                vs.append(np.stack([rings[:, 0] * c0, rings[:, 1], rings[:, 0] * s0], 1))
                # Seitenfläche eben: Normale zeigt zur Mitte der Seite
                rr = rings[:, 2] / math.cos(total / seg / 2)
                ns.append(np.stack([rr * math.cos(am), rings[:, 3], rr * math.sin(am)], 1))
            v = np.concatenate(vs)
            nn = np.concatenate(ns)
            nn /= np.maximum(np.linalg.norm(nn, axis=1, keepdims=True), 1e-12)
            m = len(rings)
            f = []
            for i in range(0, m - 1, 2):
                a, b, c, d = i, i + 1, m + i + 1, m + i
                f += [(a, b, c), (a, c, d)]
            parts.append((v, nn, np.array(f)))
        return merge(parts)
    closed = arc is None
    cols = seg if closed else seg + 1
    ang = phase + total * np.arange(cols) / seg
    c, s = np.cos(ang), np.sin(ang)
    m = len(rings)
    v = np.zeros((cols, m, 3))
    nn = np.zeros((cols, m, 3))
    v[..., 0] = c[:, None] * rings[None, :, 0]
    v[..., 1] = rings[None, :, 1]
    v[..., 2] = s[:, None] * rings[None, :, 0]
    nn[..., 0] = c[:, None] * rings[None, :, 2]
    nn[..., 1] = rings[None, :, 3]
    nn[..., 2] = s[:, None] * rings[None, :, 2]
    f = []
    for k in range(seg):
        k2 = (k + 1) % cols
        for i in range(0, m - 1, 2):
            a, b, cc, d = k * m + i, k * m + i + 1, k2 * m + i + 1, k2 * m + i
            f += [(a, b, cc), (a, cc, d)]
    return v.reshape(-1, 3), nn.reshape(-1, 3), np.array(f)


def cylinder(h, r, seg=40, bevel=0.0, center=(0, 0, 0), y0=None):
    """Zylinder entlang y (Mitte bei center), optional mit Fase"""
    y0 = -h / 2 if y0 is None else y0
    b = min(bevel, r * 0.5, h * 0.5)
    prof = [(0, y0), (r - b, y0)]
    if b > 0:
        prof += [(r, y0 + b), (r, y0 + h - b), (r - b, y0 + h)]
    else:
        prof += [(r, y0), (r, y0 + h), (r, y0 + h)]
        prof = [(0, y0), (r, y0), (r, y0 + h)]
    prof += [(0, y0 + h)]
    v, n, f = lathe(prof, seg)
    return v + np.array(center, float), n, f


def tube_ring(h, r_out, r_in, seg=40, center=(0, 0, 0)):
    """Hohlzylinder (Rohr, Hülse) entlang y"""
    y0 = -h / 2
    prof = [(r_in, y0), (r_out, y0), (r_out, y0 + h), (r_in, y0 + h), (r_in, y0)]
    v, n, f = lathe(prof, seg)
    return v + np.array(center, float), n, f


def sphere(r, seg=32, rings=16, center=(0, 0, 0)):
    prof = [(r * math.sin(a), -r * math.cos(a)) for a in np.linspace(0, math.pi, rings + 1)]
    v, n, f = lathe(prof, seg, crease=80)
    return v + np.array(center, float), n, f


# MARK: Profile und Pfade


def circle(r, n=20):
    a = np.linspace(0, 2 * math.pi, n, endpoint=False)
    p = np.stack([np.cos(a) * r, np.sin(a) * r], 1)
    return p, p / r


def rrect(w, h, r, n=4):
    """Rechteckrohr-Querschnitt (Breite w quer, Höhe h) mit Eckradius r"""
    r = min(r, w / 2, h / 2)
    pts, nrm = [], []
    for cx, cy, a0 in ((w / 2 - r, h / 2 - r, 0), (-w / 2 + r, h / 2 - r, 90), (-w / 2 + r, -h / 2 + r, 180),
                       (w / 2 - r, -h / 2 + r, 270)):
        for a in np.linspace(math.radians(a0), math.radians(a0 + 90), n + 1):
            d = np.array([math.cos(a), math.sin(a)])
            pts.append((cx + d[0] * r, cy + d[1] * r))
            nrm.append(d)
    return np.array(pts), np.array(nrm)


def fillet(points, radius, n=8):
    """Rundet die Ecken eines Linienzugs mit Kreisbögen ab"""
    p = [np.asarray(q, float) for q in points]
    if len(p) < 3 or radius <= 0:
        return np.array(p)
    out = [p[0]]
    for i in range(1, len(p) - 1):
        a, b, c = p[i - 1], p[i], p[i + 1]
        u1, u2 = a - b, c - b
        l1, l2 = np.linalg.norm(u1), np.linalg.norm(u2)
        u1, u2 = u1 / l1, u2 / l2
        cosphi = float(np.clip(np.dot(u1, u2), -1, 1))
        phi = math.acos(cosphi)
        if phi > math.pi - 1e-3:
            out.append(b)
            continue
        d = radius / math.tan(phi / 2)
        lim = min(l1, l2) * 0.49
        rr = radius
        if d > lim:
            d = lim
            rr = d * math.tan(phi / 2)
        p1, p2 = b + u1 * d, b + u2 * d
        bis = u1 + u2
        bis /= np.linalg.norm(bis)
        cen = b + bis * (rr / math.sin(phi / 2))
        v1, v2 = p1 - cen, p2 - cen
        ang = math.acos(float(np.clip(np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2)), -1, 1)))
        for t in np.linspace(0, 1, n + 1):
            # Slerp zwischen v1 und v2
            if ang < 1e-6:
                vv = v1
            else:
                vv = (math.sin((1 - t) * ang) * v1 + math.sin(t * ang) * v2) / math.sin(ang)
            out.append(cen + vv)
    out.append(p[-1])
    return np.array(out)


def sweep(path, profile, up=(0, 1, 0), caps=True, closed=False, twist=0.0):
    """Zieht einen Querschnitt (Punkte, Normalen in 2D) entlang eines Pfads. Querschnitt-x liegt quer zur
    Bewegung und senkrecht zu `up`, Querschnitt-y Richtung `up`."""
    P = np.asarray(path, float)
    prof, pn = profile
    m = len(P)
    if closed:
        tang = np.roll(P, -1, 0) - np.roll(P, 1, 0)
    else:
        tang = np.zeros_like(P)
        tang[1:-1] = P[2:] - P[:-2]
        tang[0] = P[1] - P[0]
        tang[-1] = P[-1] - P[-2]
    tang /= np.maximum(np.linalg.norm(tang, axis=1, keepdims=True), 1e-12)
    upv = np.asarray(up, float)
    u = upv - np.dot(upv, tang[0]) * tang[0]
    if np.linalg.norm(u) < 1e-6:
        u = np.cross(tang[0], [1, 0, 0])
        if np.linalg.norm(u) < 1e-6:
            u = np.cross(tang[0], [0, 0, 1])
    u /= np.linalg.norm(u)
    us = [u]
    for i in range(1, m):
        t0, t1 = tang[i - 1], tang[i]
        ax = np.cross(t0, t1)
        s = np.linalg.norm(ax)
        uu = us[-1]
        if s > 1e-9:
            ax /= s
            ang = math.atan2(s, np.dot(t0, t1))
            uu = uu * math.cos(ang) + np.cross(ax, uu) * math.sin(ang) + ax * np.dot(ax, uu) * (1 - math.cos(ang))
        uu = uu - np.dot(uu, t1) * t1
        us.append(uu / np.linalg.norm(uu))
    us = np.array(us)
    if twist:
        tw = np.linspace(0, twist, m)
        ws = np.cross(tang, us)
        us = us * np.cos(tw)[:, None] + ws * np.sin(tw)[:, None]
    ws = np.cross(us, tang)  # quer (Querschnitt-x)
    k = len(prof)
    v = P[:, None, :] + prof[None, :, 0, None] * ws[:, None, :] + prof[None, :, 1, None] * us[:, None, :]
    nn = pn[None, :, 0, None] * ws[:, None, :] + pn[None, :, 1, None] * us[:, None, :]
    v = v.reshape(-1, 3)
    nn = nn.reshape(-1, 3)
    f = []
    rows = m if closed else m - 1
    for i in range(rows):
        i2 = (i + 1) % m
        for j in range(k):
            j2 = (j + 1) % k
            a, b, c, d = i * k + j, i * k + j2, i2 * k + j2, i2 * k + j
            f += [(a, b, c), (a, c, d)]
    parts = [(v, nn, np.array(f))]
    if caps and not closed:
        for i, sgn in ((0, -1), (m - 1, 1)):
            ring = v[i * k:(i + 1) * k]
            cen = ring.mean(axis=0)
            cv = np.concatenate([ring, cen[None]])
            cn = np.repeat((tang[i] * sgn)[None], k + 1, 0)
            cf = np.array([(j, (j + 1) % k, k) for j in range(k)])
            parts.append((cv, cn, cf))
    return merge(parts)


def tube(points, r, bend=0.0, n=20, up=(0, 1, 0), caps=True, closed=False):
    """Rundrohr entlang eines Linienzugs mit Biegeradius `bend`"""
    path = fillet(points, bend, 10) if bend > 0 else np.asarray(points, float)
    return sweep(path, circle(r, n), up=up, caps=caps, closed=closed)


def bar(points, w, h, r=0.006, bend=0.0, up=(0, 1, 0), caps=True):
    """Vierkantrohr (Breite w quer, Höhe h in Richtung `up`) entlang eines Linienzugs"""
    path = fillet(points, bend, 8) if bend > 0 else np.asarray(points, float)
    return sweep(path, rrect(w, h, r), up=up, caps=caps)


def torus(R, r, seg=48, n=16, arc=None):
    """Ring in der xz-Ebene"""
    total = arc if arc is not None else 2 * math.pi
    cnt = seg if arc is None else seg + 1
    a = np.linspace(0, total, cnt, endpoint=arc is not None)
    path = np.stack([np.cos(a) * R, np.zeros_like(a), np.sin(a) * R], 1)
    return sweep(path, circle(r, n), up=(0, 1, 0), closed=arc is None, caps=arc is not None)


def ellipsoid(rx, ry, rz, seg=32, rings=16, center=(0, 0, 0)):
    v, n, f = sphere(1.0, seg, rings)
    m = chain(T(*center), S(rx, ry, rz))
    return apply(m, (v, n, f))


def superpad(size, round_top=0.35, n=10, center=(0, 0, 0)):
    """Gepolstertes Kissen: oben stark gewölbte Kanten, unten flach (Superellipsoid-artig)"""
    w, h, d = size
    r = min(h * 0.9, w * round_top, d * round_top)
    v, nn, f = rbox((w, h * 2, d), r, n)
    v = v.copy()
    nn = nn.copy()
    low = v[:, 1] < 0
    # untere Hälfte flach: alles unter der Mitte auf die Bodenfläche legen
    v[low, 1] = 0
    nn[low] = (0, -1, 0)
    v = v + np.array(center, float) - np.array([0, h / 2, 0])
    return v, nn, f


def quad(w, h, center=(0, 0, 0), normal="z"):
    """Einseitiges Rechteck (Aufkleber, Bildschirm). normal: z, -z, y, x, -x"""
    a = np.array([(-w / 2, -h / 2), (w / 2, -h / 2), (w / 2, h / 2), (-w / 2, h / 2)])
    if normal in ("z", "-z"):
        v = np.stack([a[:, 0], a[:, 1], np.zeros(4)], 1)
        nv = (0, 0, 1 if normal == "z" else -1)
    elif normal == "y":
        v = np.stack([a[:, 0], np.zeros(4), a[:, 1]], 1)
        nv = (0, 1, 0)
    else:
        v = np.stack([np.zeros(4), a[:, 1], a[:, 0]], 1)
        nv = (1 if normal == "x" else -1, 0, 0)
    return v + np.array(center, float), np.repeat(np.array(nv, float)[None], 4, 0), np.array([(0, 1, 2), (0, 2, 3)])
