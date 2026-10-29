"""Automatic contact / collision correction for poses.

The figure is approximated by a few hundred spheres that ride rigidly on their bones (built once
from the real mesh in rest pose). After the analytic IK solve, `Corrector.solve()` checks

  * feet vs. floor / mat      -> ankle target raised (no toes in the floor), small gaps closed
  * body vs. floor            -> pelvis raised; lying poses settle onto the floor (no hovering)
  * hands/forearms vs. body   -> hand target pushed out of thighs, belly, head, other arm
  * hands vs. floor           -> hand raised onto the floor
  * thigh/shin vs. other leg  -> feet pushed apart

and re-solves (a few iterations). Intended contacts (hands on hips, hugging the knees, palms on
the floor) end up *on* the surface instead of inside it.
"""
import math
import numpy as np
from mathutils import Vector

MAT_TOP = 0.012


def part_of(bone):
    s = bone[-1] if bone[-2:] in (".L", ".R") else ""
    b = bone
    if b.startswith("head"):
        return "head"
    if b.startswith("neck"):
        return "neck"
    if b.startswith(("upperarm", "shoulder01")):
        return "oberarm" + s
    if b.startswith("lowerarm"):
        return "unterarm" + s
    if b.startswith(("wrist", "finger", "metacarpal")):
        return "hand" + s
    if b.startswith("upperleg"):
        return "oberschenkel" + s
    if b.startswith("lowerleg"):
        return "unterschenkel" + s
    if b.startswith(("foot", "toe")):
        return "fuss" + s
    if b.startswith(("pelvis", "root")):
        return "becken"
    return "rumpf"


def _split(pts, max_ratio=1.3, depth=0):
    """recursively split a point cloud along its principal axis until roughly round."""
    c = pts.mean(0)
    if len(pts) < 10 or depth > 5:
        return [pts]
    u, s, vt = np.linalg.svd(pts - c, full_matrices=False)
    sd = s / math.sqrt(len(pts))
    if sd[0] / max(sd[1], 1e-4) < max_ratio:
        return [pts]
    proj = (pts - c) @ vt[0]
    return _split(pts[proj < 0], max_ratio, depth + 1) + _split(pts[proj >= 0], max_ratio, depth + 1)


def build_spheres(body, poser, slice_len=0.045):
    me = body.data
    names = {g.index: g.name for g in body.vertex_groups}
    n = len(me.vertices)
    co = np.empty(n * 3, np.float32); me.vertices.foreach_get("co", co); co = co.reshape(-1, 3)
    dom = []
    for v in me.vertices:
        best, bw = None, -1
        for g in v.groups:
            if g.weight > bw:
                bw, best = g.weight, names[g.group]
        dom.append(best)
    dom = np.array(dom, dtype=object)
    out = []      # (bone, rest point (armature space), radius, part)
    for bone in set(dom):
        if bone is None or bone not in poser.rest:
            continue
        P = co[dom == bone]
        if len(P) < 8:
            continue
        h = np.array(poser.head[bone]); t = np.array(poser.tail[bone])
        ax = t - h; L = np.linalg.norm(ax)
        ax = ax / max(L, 1e-6)
        tt = (P - h) @ ax
        lo, hi = tt.min(), tt.max()
        nb = max(1, int(math.ceil((hi - lo) / slice_len)))
        for k in range(nb):
            sel = P[(tt >= lo + k * (hi - lo) / nb) & (tt <= lo + (k + 1) * (hi - lo) / nb)]
            if len(sel) < 6:
                continue
            for cl in _split(sel):
                c = cl.mean(0)
                d = np.linalg.norm(cl - c, axis=1)
                r = float(np.percentile(d, 60))
                if r > 0.004:
                    out.append((bone, tuple(c), r, part_of(bone)))
    return out


class Corrector:
    def __init__(self, poser, spheres):
        self.pz = poser
        self.bones = sorted({s[0] for s in spheres})
        bi = {b: i for i, b in enumerate(self.bones)}
        self.sb = np.array([bi[s[0]] for s in spheres])
        self.sp = np.array([s[1] for s in spheres], np.float64)
        self.sr = np.array([s[2] for s in spheres], np.float64)
        self.part = np.array([s[3] for s in spheres], dtype=object)
        self.rest_inv = [np.array(poser.rest[b].inverted()) for b in self.bones]
        self.mask = {p: self.part == p for p in set(self.part)}
        self.toe = np.array([self.bones[i].startswith("toe") for i in self.sb])
        self.sup_rect = []          # mats: (xmin, xmax, ymin, ymax, top)
        self.two_hand = False
        self.two_hand_fixed = False     # hands hold a fixed object (bar, rack, machine): don't move them
        self.enabled = True
        self.calibrate()
        self.opts = {}
        self.prev = None
        self.log = []

    # ----------------------------------------------------------------- calibration
    def calibrate(self):
        """the conservative sphere model overlaps itself / the floor a little even in a perfect
        standing pose; measure that baseline so only *extra* penetration gets corrected."""
        from .exercises import stand
        self.sup_rect = []
        posed = self.pz.solve(stand(0.15, 8))
        C = self.centers(posed)
        gap = C[:, 2] - self.sr
        self.base_foot = {s: float(gap[self.m("fuss" + s)].min()) if self.m("fuss" + s).any() else 0.0 for s in "LR"}
        self.base_legs = {}
        for a, b in (("oberschenkelL", "oberschenkelR"), ("unterschenkelL", "unterschenkelR")):
            A, B = self.m(a), self.m(b)
            self.base_legs[a] = self.overlap(C[A], self.sr[A], C[B], self.sr[B])[1]
        # hands hang next to the thighs in many poses: baseline of hand vs thigh at the sides
        self.base_hand = 0.0

    # ----------------------------------------------------------------- geometry
    def centers(self, posed):
        M = np.array([np.array(posed[b]) @ ri for b, ri in zip(self.bones, self.rest_inv)])   # (B,4,4)
        Ms = M[self.sb]
        return np.einsum("nij,nj->ni", Ms[:, :3, :3], self.sp) + Ms[:, :3, 3]

    def support(self, C):
        z = np.zeros(len(C))
        for x0, x1, y0, y1, top in self.sup_rect:
            m = (C[:, 0] > x0) & (C[:, 0] < x1) & (C[:, 1] > y0) & (C[:, 1] < y1)
            z[m] = np.maximum(z[m], top)
        return z

    def m(self, *parts):
        out = np.zeros(len(self.part), bool)
        for p in parts:
            if p in self.mask:
                out |= self.mask[p]
        return out

    @staticmethod
    def overlap(CA, RA, CB, RB):
        """max push vector for set A out of set B (sphere vs sphere)."""
        if not len(CA) or not len(CB):
            return np.zeros(3), 0.0
        D = CA[:, None, :] - CB[None, :, :]
        dist = np.linalg.norm(D, axis=2)
        pen = (RA[:, None] + RB[None, :]) - dist
        k = np.unravel_index(np.argmax(pen), pen.shape)
        p = pen[k]
        if p <= 0:
            return np.zeros(3), 0.0
        nrm = D[k] / max(dist[k], 1e-6)
        # average direction of all strongly overlapping pairs (smoother than the single worst)
        sel = pen > p * 0.5
        dirs = (D[sel] / np.maximum(dist[sel], 1e-6)[:, None]) * pen[sel][:, None]
        v = dirs.sum(0)
        if np.linalg.norm(v) > 1e-6:
            nrm = v / np.linalg.norm(v)
        return nrm * p, float(p)

    # ----------------------------------------------------------------- correction
    def solve(self, P0, iters=3, t=None):
        """returns (P, posed). With t (seconds) consecutive frames are smoothed: corrections
        build up immediately but fade out over a few frames, so contacts never snap."""
        pz = self.pz
        posed0 = pz.solve(P0)
        if not self.enabled:
            return P0, posed0
        opts = self.opts
        acc = dict(hL=Vector(), hR=Vector(), dz=0.0, fL=0.0, fR=0.0, sep=0.0)
        P, posed = P0, posed0
        for it in range(iters):
            C = self.centers(posed)
            R = self.sr
            sup = self.support(C)
            gap = C[:, 2] - R - sup
            changed = False
            # 1) feet on the floor
            if opts.get("feet", True):
                for s in "LR":
                    fm = self.m("fuss" + s)
                    # on the toes (plank, push-up, lunge back foot) the toes bend at the ball of the foot,
                    # the rigid toe spheres would dig into the floor -> judge by heel/midfoot only
                    fq = posed[f"foot.{s}"]
                    tdir = (posed[f"toe1-1.{s}"].translation - fq.translation) if f"toe1-1.{s}" in posed else None
                    if tdir is not None and tdir.length > 1e-6 and abs(tdir.normalized().z) > 0.35:
                        fm = fm & ~self.toe
                    if fm.any() and "pos" in P0.get("foot" + s, {}):
                        g = gap[fm].min() - min(0.0, self.base_foot[s])
                        if g < -0.004:
                            acc["f" + s] -= g; changed = True
            # 2) body vs floor (raise), lying poses settle (lower)
            if opts.get("body", True):
                core = self.m("rumpf", "becken", "head", "neck", "oberarmL", "oberarmR")
                gc = gap[core].min() if core.any() else 1
                root = posed["root"].translation
                up = Vector(posed["spine01"].to_3x3() @ pz.rest["spine01"].to_3x3().inverted() @ Vector((0, 0, 1)))
                lying = root.z < 0.42 and abs(up.z) < 0.6 and opts.get("settle", True)
                if lying and all(("_palm" + s_) in posed and posed["_palm" + s_].z < 0.09 for s_ in "LR"):
                    lying = False       # propped up on the hands/forearms (plank etc.): don't sink the body
                # thighs lying on the floor (prone poses) must not sink into it either
                thg = self.m("oberschenkelL", "oberschenkelR")
                gt = gap[thg].min() if thg.any() else 1
                low = min(gc, gt) if (lying or root.z < 0.42) else gc
                if low < -0.006:
                    acc["dz"] -= low; changed = True
                elif lying and 0.006 < gc < 0.12 and it == 0:
                    acc["dz"] -= (gc - 0.002); changed = True
            # 3) hands / forearms vs body + floor
            pushes = {}
            if opts.get("hands", True):
                for s, o in (("L", "R"), ("R", "L")):
                    A = self.m("hand" + s, "unterarm" + s)
                    others = () if self.two_hand else ("hand" + o, "unterarm" + o, "oberarm" + o)
                    B = self.m("rumpf", "becken", "head", "neck", "oberschenkelL", "oberschenkelR", "unterschenkelL",
                               "unterschenkelR", *others)
                    v, p = self.overlap(C[A], R[A], C[B], R[B])
                    hm = self.m("hand" + s)
                    gh = gap[hm].min() if hm.any() else 1
                    if gh < -0.004:
                        v = v + np.array([0, 0, -gh]); p = max(p, -gh)
                    if p > 0.004:
                        pushes[s] = v * 1.05
            if pushes:
                if self.two_hand:
                    # both hands share one implement: never push them apart along the bar; push the
                    # implement off the body (perpendicular to the bar), forward if the push is sideways
                    axis = np.array(posed["_palmL"] - posed["_palmR"])
                    axis = axis / max(np.linalg.norm(axis), 1e-6)
                    fwd = np.array(posed["spine01"].to_3x3() @ pz.rest["spine01"].to_3x3().inverted()
                                   @ Vector((0, -1, 0)))
                    best = None
                    for p in pushes.values():
                        perp = p - axis * p.dot(axis)
                        mag = np.linalg.norm(p)
                        cand = perp if np.linalg.norm(perp) > 0.4 * mag else fwd * mag
                        if best is None or np.linalg.norm(cand) > np.linalg.norm(best):
                            best = cand
                    pushes = {"L": best, "R": best}
                for s, v in pushes.items():
                    acc["h" + s] += Vector(v); changed = True
            # 4) legs apart
            if opts.get("legs", True):
                for a, b in (("oberschenkelL", "oberschenkelR"), ("unterschenkelL", "unterschenkelR")):
                    A, B = self.m(a), self.m(b)
                    v, p = self.overlap(C[A], R[A], C[B], R[B])
                    p -= self.base_legs.get(a, 0.0)
                    if p > 0.008:
                        acc["sep"] += p * 0.6; changed = True
            if not changed:
                break
            P = self._apply(P0, posed0, acc)
            posed = pz.solve(P)
        # temporal smoothing (fast attack, slow release)
        if t is not None:
            prev = self.prev if (self.prev and abs(t - self.prev[0] - 1 / 30) < 1e-3) else None
            if prev:
                pa = prev[1]
                for k in acc:
                    a_, b_ = acc[k], pa[k]
                    if isinstance(a_, Vector):
                        if a_.length < 0.8 * b_.length:
                            acc[k] = b_ * 0.8 + a_ * 0.2
                    elif abs(a_) < 0.8 * abs(b_):
                        acc[k] = b_ * 0.8 + a_ * 0.2
            self.prev = (t, {k: (v.copy() if isinstance(v, Vector) else v) for k, v in acc.items()})
        for s in "LR":
            if acc["h" + s].length > 0.12:
                acc["h" + s] = acc["h" + s].normalized() * 0.12
        if any((v.length if isinstance(v, Vector) else abs(v)) > 1e-6 for v in acc.values()):
            P = self._apply(P0, posed0, acc)
            posed = pz.solve(P)
        else:
            P, posed = P0, posed0
        return P, posed

    def _apply(self, P0, posed0, acc):
        P = dict(P0)
        pz = self.pz
        dz = acc["dz"]
        # standing on a mat/platform: both feet lifted by the same amount -> lift the whole body with
        # them instead of bending the knees (only when upright, legs carry the weight)
        lift = 0.0
        if posed0["root"].translation.z > 0.7:
            # feet standing on the floor/mat (the other one may be lifted, e.g. tree pose, step-up)
            planted = [acc["f" + s] for s in "LR"
                       if acc["f" + s] > 0 or posed0[f"foot.{s}"].translation.z < 0.11]
            if planted and all(f > 0 for f in planted):
                lift = min(planted)
                dz += lift
        if dz:
            h = list(P.get("hips", (0, 0, 0))); h[2] += dz; P["hips"] = tuple(h)
        if lift:
            # the whole person stands higher: world-space hand targets (free weights) move with them
            for s in "LR":
                hd = P.get("hand" + s)
                if hd and hd.get("space") not in ("chest", "root") and not self.two_hand_fixed:
                    hd = dict(hd)
                    for k in ("pos", "palm"):
                        if k in hd:
                            hd[k] = tuple(Vector(hd[k]) + Vector((0, 0, lift)))
                    P["hand" + s] = hd
        side = Vector(posed0["root"].to_3x3() @ pz.rest["root"].to_3x3().inverted() @ Vector((1, 0, 0)))
        for s, sg in (("L", 1), ("R", -1)):
            ft = P.get("foot" + s)
            if ft and "pos" in ft and (acc["f" + s] or acc["sep"]):
                ft = dict(ft)
                ft["pos"] = tuple(Vector(ft["pos"]) + Vector((0, 0, acc["f" + s])) + side * sg * acc["sep"])
                P["foot" + s] = ft
            if acc["h" + s].length > 1e-6:
                self._move_hand(P, posed0, s, acc["h" + s])
        return P

    def _move_hand(self, P, posed, s, v):
        key = "hand" + s
        hd = dict(P.get(key, {}))
        sp = hd.get("space")
        loc = v
        if sp == "chest":
            loc = (posed["spine01"].to_3x3() @ self.pz.rest["spine01"].to_3x3().inverted()).inverted() @ v
        elif sp == "root":
            loc = (posed["root"].to_3x3() @ self.pz.rest["root"].to_3x3().inverted()).inverted() @ v
        if "hang" in hd:
            hd["offset"] = tuple(Vector(hd.get("offset", (0, 0, 0))) + v)
        elif "palm" in hd and "aim" in hd:
            hd["palm"] = tuple(Vector(hd["palm"]) + loc)
        elif "pos" in hd:
            hd["pos"] = tuple(Vector(hd["pos"]) + loc)
        else:
            # implicit hanging arm: give it an explicit target
            hd["pos"] = tuple(posed[f"wrist.{s}"].translation + v)
            hd.pop("space", None)
        P[key] = hd
        return True


_CACHE = {}


def corrector_for(poser, body):
    key = id(poser)
    if key not in _CACHE:
        _CACHE[key] = Corrector(poser, build_spheres(body, poser))
    return _CACHE[key]
