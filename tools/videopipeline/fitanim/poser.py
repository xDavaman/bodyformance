"""Pose solver for the MakeHuman rig.

A pose is described in *world* terms (what an animator thinks about):
    hips      : position offset (m) + rotation (deg, XYZ euler, world)
    spine     : (forward bend, side bend, twist) in deg, distributed over 5 spine bones
    neck/head : pitch / yaw / roll (deg)
    feet      : ankle target position + foot rotation (deg) + knee pole direction
    hands     : wrist target position + elbow pole + forearm twist / wrist flex
    fingers   : grip 0..1
All of this is solved analytically (2-bone IK for legs and arms) into local bone
rotations and baked as keyframes, so the result is a plain FK action that can be
exported (FBX/GLB) and reused in other projects.
"""
import math
from mathutils import Matrix, Vector, Quaternion, Euler

SPINE = ["spine05", "spine04", "spine03", "spine02", "spine01"]
SPINE_W = [0.12, 0.22, 0.24, 0.24, 0.18]
NECK = ["neck01", "neck02", "neck03"]


def V(*a):
    if len(a) == 1:
        return Vector(a[0])
    return Vector(a)


def euler_q(deg, order="XYZ"):
    return Euler([math.radians(d) for d in deg], order).to_quaternion()


def frame(y, x):
    """Rotation matrix with given Y axis and (approx) X axis."""
    y = y.normalized()
    x = (x - y * x.dot(y)).normalized()
    z = x.cross(y)
    m = Matrix((x, y, z)).transposed()
    return m


class Poser:
    def __init__(self, rig_ob):
        self.ob = rig_ob
        self.arm = rig_ob.data
        self.bones = [b.name for b in self.arm.bones]
        self.rest = {b.name: b.matrix_local.copy() for b in self.arm.bones}
        self.parent = {b.name: (b.parent.name if b.parent else None) for b in self.arm.bones}
        self.order = []
        seen = set()

        def visit(name):
            if name in seen:
                return
            p = self.parent[name]
            if p:
                visit(p)
            seen.add(name); self.order.append(name)
        for b in self.bones:
            visit(b)
        self.rel = {}
        for b in self.bones:
            p = self.parent[b]
            self.rel[b] = (self.rest[p].inverted() @ self.rest[b]) if p else self.rest[b].copy()
        self.head = {b.name: b.head_local.copy() for b in self.arm.bones}
        self.tail = {b.name: b.tail_local.copy() for b in self.arm.bones}
        # rest joint positions
        self.J = {}
        for s in ("L", "R"):
            self.J["hip" + s] = self.head[f"upperleg01.{s}"]
            self.J["knee" + s] = self.head[f"lowerleg01.{s}"]
            self.J["ankle" + s] = self.head[f"foot.{s}"]
            self.J["shoulder" + s] = self.head[f"upperarm01.{s}"]
            self.J["elbow" + s] = self.head[f"lowerarm01.{s}"]
            self.J["wrist" + s] = self.head[f"wrist.{s}"]
            self.J["hand" + s] = self.tail[f"finger3-1.{s}"] if f"finger3-1.{s}" in self.tail else self.tail[f"wrist.{s}"]
        self.J["root"] = self.head["root"]
        self.J["neck"] = self.head["neck01"]
        self.J["head"] = self.head["head"]
        # hand frame: finger direction and palm normal (rest, world)
        self._rest_hand_dir, self._rest_palm, self._palm_local = {}, {}, {}
        for s in "LR":
            w = self.rest[f"wrist.{s}"]
            mid = self.head.get(f"finger3-1.{s}", self.tail[f"wrist.{s}"])
            idx = self.head.get(f"finger2-1.{s}", mid); pky = self.head.get(f"finger5-1.{s}", mid)
            fdir = (mid - self.head[f"wrist.{s}"]).normalized()
            across = (idx - pky).normalized()
            # palm normal = direction the fingertips travel when the fist closes (finger bones curl
            # around their local +X, i.e. towards local +Z)
            fz = self.rest[f"finger3-1.{s}"].to_3x3().col[2].normalized()
            pn = fz - fdir * fz.dot(fdir)
            self._rest_hand_dir[s] = fdir
            self._rest_palm[s] = pn.normalized()
            palm_pt = self.head[f"wrist.{s}"] + fdir * 0.082 + pn * 0.022
            self._palm_local[s] = tuple(w.inverted() @ palm_pt)
            self._across_local = getattr(self, "_across_local", {})
            self._across_local[s] = tuple(w.to_3x3().inverted() @ across)
            self._fdir_local = getattr(self, "_fdir_local", {})
            self._fdir_local[s] = tuple(w.to_3x3().inverted() @ fdir)
        self.leg_len = {s: ((self.J["knee" + s] - self.J["hip" + s]).length,
                            (self.J["ankle" + s] - self.J["knee" + s]).length) for s in "LR"}
        self.arm_len = {s: ((self.J["elbow" + s] - self.J["shoulder" + s]).length,
                            (self.J["wrist" + s] - self.J["elbow" + s]).length) for s in "LR"}

    # ------------------------------------------------------------------ util
    def _fk(self, name, posed, basis=None):
        p = self.parent[name]
        m = (posed[p] @ self.rel[name]) if p else self.rel[name].copy()
        if basis is not None:
            m = m @ basis
        posed[name] = m
        return m

    def _set_world_rot(self, name, posed, Q, origin=None):
        """posed rotation = Q @ rest rotation, translation = chain position (or origin)."""
        p = self.parent[name]
        chain = (posed[p] @ self.rel[name]) if p else self.rel[name]
        t = origin if origin is not None else chain.translation
        m = (Q.to_matrix() @ self.rest[name].to_3x3()).to_4x4()
        m.translation = t
        posed[name] = m
        return m

    @staticmethod
    def _two_bone(H, A, l1, l2, pole):
        d = A - H
        dist = max(1e-5, min(d.length, (l1 + l2) * 0.9995))
        dn = d.normalized()
        pp = (pole - dn * pole.dot(dn))
        if pp.length < 1e-6:
            pp = Vector((0, -1, 0)) - dn * dn.y * -1
        pp.normalize()
        cos_a = (l1 * l1 + dist * dist - l2 * l2) / (2 * l1 * dist)
        cos_a = max(-1.0, min(1.0, cos_a))
        a = math.acos(cos_a)
        K = H + (dn * math.cos(a) + pp * math.sin(a)) * l1
        E = H + dn * dist
        return K, E, pp

    def _limb_rot(self, rest_dir, rest_hinge, new_dir, new_hinge):
        Fr = frame(rest_dir, rest_hinge)
        Ft = frame(new_dir, new_hinge)
        return (Ft @ Fr.transposed()).to_quaternion()

    # ------------------------------------------------------------------ solve
    def solve(self, P):
        """P: pose dict (see module doc). Returns dict bone -> posed armature matrix."""
        posed = {}
        hips_q = euler_q(P.get("hips_rot", (0, 0, 0)))
        hips_off = V(P.get("hips", (0, 0, 0)))
        body_q = hips_q  # orientation of the pelvis

        # root
        r = self.rest["root"]
        m = (hips_q.to_matrix() @ r.to_3x3()).to_4x4()
        m.translation = r.translation + hips_off
        posed["root"] = m

        bend, side, twist = P.get("spine", (0, 0, 0))
        neck = P.get("neck", (0, 0, 0))
        headr = P.get("head", (0, 0, 0))
        fing = {"L": P.get("gripL", P.get("grip", 0.15)), "R": P.get("gripR", P.get("grip", 0.15))}

        leg_done = set(); arm_done = set()
        for name in self.order:
            if name in posed:
                continue
            if name in SPINE:
                w = SPINE_W[SPINE.index(name)]
                q = euler_q((bend * w, twist * w, side * w), "YXZ")
                self._fk(name, posed, q.to_matrix().to_4x4())
            elif name in NECK:
                # neck = (pitch +down, yaw +left, tilt) in the *body* frame, split over the 3 neck bones
                # (bone-local axes of the forward-tilted MakeHuman neck would mix turn and tilt)
                chain = posed[self.parent[name]] @ self.rel[name]
                B = (posed["spine01"].to_3x3() @ self.rest["spine01"].to_3x3().inverted()).to_quaternion()
                qb = Quaternion((0, 0, 1), math.radians(neck[1] / 3)) @ \
                    Quaternion((1, 0, 0), math.radians(neck[0] / 3)) @ \
                    Quaternion((0, -1, 0), math.radians(neck[2] / 3))
                qw = B @ qb @ B.inverted()
                cr = chain.to_quaternion()
                self._fk(name, posed, (cr.inverted() @ qw @ cr).to_matrix().to_4x4())
            elif name == "head":
                q = euler_q((headr[0], headr[1], headr[2]), "YXZ")
                self._fk(name, posed, q.to_matrix().to_4x4())
            elif name.startswith("upperleg01."):
                self._solve_leg(name[-1], P, posed, body_q)
            elif name.startswith(("upperleg02.", "lowerleg", "foot.")):
                pass  # done by leg solver
            elif name.startswith("clavicle."):
                self._solve_arm(name[-1], P, posed)
            elif name.startswith(("shoulder01.", "upperarm", "lowerarm", "wrist.")):
                pass
            elif name.startswith("finger") or name.startswith("metacarpal"):
                s = name[-1]
                self._fk(name, posed, self._finger_basis(name, fing[s]))
            else:
                self._fk(name, posed)
        return posed

    def _finger_basis(self, name, g):
        # name like finger2-1.L ; curl around local X
        if name.startswith("metacarpal"):
            return None
        idx = name[6]; seg = int(name[8])
        if idx == "1":  # thumb
            ang = [20, 25, 25][seg - 1] * g
            return Euler((math.radians(ang), 0, 0)).to_matrix().to_4x4()
        ang = [70, 95, 60][seg - 1] * g + [8, 10, 6][seg - 1]
        return Euler((math.radians(ang), 0, 0)).to_matrix().to_4x4()

    # ------------------------------------------------------------------ legs
    KNEE_TOL = 40.0     # tibia/femur rotation the knee hinge may deviate from the foot's own axis (deg)

    def _knee_guard(self, H, A, pole, foot_q):
        """anatomical constraint: the knee hinge stays ~parallel to the foot's lateral axis (the tibia
        only rotates ~30-40 deg against the foot). A pole that would bend the knee sideways or backwards
        (= dislocated look) is rotated back to the nearest allowed direction."""
        ax = A - H
        if ax.length < 1e-4:
            return pole
        ax.normalize()
        fx = foot_q @ Vector((1, 0, 0))
        fx = fx - ax * fx.dot(ax)
        pp = pole - ax * pole.dot(ax)
        if fx.length < 0.35 or pp.length < 1e-4:
            return pole
        want = ax.cross(fx.normalized())             # knee direction that gives hinge == foot axis
        pp.normalize()
        ang = math.degrees(math.atan2(want.cross(pp).dot(ax), want.dot(pp)))
        if abs(ang) <= self.KNEE_TOL:
            return pole
        lim = math.copysign(self.KNEE_TOL, ang)
        return Quaternion(ax, math.radians(lim)) @ want
    def _solve_leg(self, s, P, posed, body_q):
        up1, up2 = f"upperleg01.{s}", f"upperleg02.{s}"
        lo1, lo2, ft = f"lowerleg01.{s}", f"lowerleg02.{s}", f"foot.{s}"
        chain0 = posed[self.parent[up1]] @ self.rel[up1]
        H = chain0.translation.copy()
        rest_hip = self.J["hip" + s]; rest_knee = self.J["knee" + s]; rest_ank = self.J["ankle" + s]
        foot = P.get("foot" + s, {})
        A = V(foot.get("pos", tuple(rest_ank)))
        foot_q = euler_q(foot.get("rot", (0, 0, 0)), "XYZ")
        pole = V(foot.get("pole", (0, -1, 0)))
        if "knee_out" in foot:   # convenience: rotate default pole outward
            ang = math.radians(foot["knee_out"]) * (1 if s == "L" else -1)
            pole = Quaternion(Vector((0, 0, 1)), ang) @ pole
        l1, l2 = self.leg_len[s]
        pole = self._knee_guard(H, A, pole, foot_q)
        K, E, pp = self._two_bone(H, A, l1, l2, pole)
        d1 = (K - H).normalized(); d2 = (E - K).normalized()
        hinge = pp.cross(d1)
        r1 = (rest_knee - rest_hip).normalized(); r2 = (rest_ank - rest_knee).normalized()
        rh = Vector((1, 0, 0))
        q1 = self._limb_rot(r1, rh, d1, hinge)
        q2 = self._limb_rot(r2, rh, d2, hinge)
        self._set_world_rot(up1, posed, q1, H)
        self._set_world_rot(up2, posed, q1)
        # place shin so knee joint matches exactly
        self._set_world_rot(lo1, posed, q2, K)
        self._set_world_rot(lo2, posed, q2)
        ank = posed[lo2] @ Vector((0, (self.tail[lo2] - self.head[lo2]).length, 0))
        if foot.get("relax") is not None:
            # unloaded foot (hanging, legs in the air): orientation follows the shin, pointed by `relax` deg
            foot_q = Quaternion(hinge.normalized(), math.radians(foot["relax"])) @ q2
            if "rot" in foot and foot.get("relax_yaw"):
                foot_q = Quaternion(d2, math.radians(foot["relax_yaw"])) @ foot_q
        self._set_world_rot(ft, posed, foot_q, ank)

    # ------------------------------------------------------------------ arms
    def _solve_arm(self, s, P, posed):
        cl, sh = f"clavicle.{s}", f"shoulder01.{s}"
        u1, u2 = f"upperarm01.{s}", f"upperarm02.{s}"
        l1n, l2n, wr = f"lowerarm01.{s}", f"lowerarm02.{s}", f"wrist.{s}"
        hand = P.get("hand" + s, {})
        sgn = 1 if s == "L" else -1
        # body frame (spine01 orientation relative to rest)
        sp = posed["spine01"]
        body_rot = (sp.to_3x3() @ self.rest["spine01"].to_3x3().inverted()).to_quaternion()
        # clavicle elevation (shrug) — auto from target height unless given
        tgt_default = body_rot @ (self.J["wrist" + s] - self.J["root"]) + posed["root"].translation
        A = V(hand.get("pos", tuple(tgt_default)))
        if hand.get("space") == "chest":
            A = (sp @ self.rest["spine01"].inverted()) @ A
        elif hand.get("space") == "root":
            A = (posed["root"] @ self.rest["root"].inverted()) @ A
        cl_chain = posed[self.parent[cl]] @ self.rel[cl]
        sh_world = posed[self.parent[cl]] @ self.rel[cl] @ (self.rel[sh] @ Vector((0, 0, 0)))
        up = body_rot @ Vector((0, 0, 1))
        to_t = (A - sh_world).normalized()
        elev = math.degrees(math.asin(max(-1, min(1, to_t.dot(up)))))
        shrug = hand.get("shrug", max(0.0, (elev + 10) * 0.18))
        protract = hand.get("protract", 0.0)
        qc = Quaternion(body_rot @ Vector((0, 1, 0)), math.radians(-shrug * sgn)) @ \
             Quaternion(body_rot @ Vector((0, 0, 1)), math.radians(protract * sgn)) @ body_rot
        self._set_world_rot(cl, posed, qc, cl_chain.translation)
        self._set_world_rot(sh, posed, qc)
        Hs = (posed[sh] @ self.rel[u1]).translation.copy()

        pole = V(hand.get("pole", tuple(body_rot @ Vector((sgn * 0.4, 1, -0.3)))))
        if hand.get("pole_space") == "body":
            pole = body_rot @ pole
        la, lb = self.arm_len[s]
        guard = hand.get("guard", P.get("anat", True))
        if "palm" in hand and "aim" in hand:
            # target the palm (grip point) instead of the wrist
            fd, pn = V(hand["aim"][0]).normalized(), V(hand["aim"][1]).normalized()
            q0 = (frame(fd, pn) @ frame(self._rest_hand_dir[s], self._rest_palm[s]).transposed()).to_quaternion()
            off = self.rest[f"wrist.{s}"].to_3x3() @ (V(self._palm_local[s]))
            A = V(hand["palm"])
            if hand.get("space") == "chest":
                A = (sp @ self.rest["spine01"].inverted()) @ A
            elif hand.get("space") == "root":
                A = (posed["root"] @ self.rest["root"].inverted()) @ A
            A = A - q0 @ off
        if "hang" in hand:   # arm hangs straight down from the shoulder (reach fraction)
            A = Hs + Vector((0, 0, -1)) * (la + lb) * hand["hang"] + V(hand.get("offset", (0, 0, 0)))
            dA = A - Hs
            if dA.length < (la + lb) * hand["hang"]:     # offsets (e.g. collision pushes) swing the arm, never bend it
                A = Hs + dA.normalized() * (la + lb) * hand["hang"]
        if guard:
            pole = self._elbow_guard(s, Hs, A, la, lb, pole, body_rot)
        K, E, pp = self._two_bone(Hs, A, la, lb, pole)
        d1 = (K - Hs).normalized(); d2 = (E - K).normalized()
        hinge = pp.cross(d1)
        rs, re, rw = self.J["shoulder" + s], self.J["elbow" + s], self.J["wrist" + s]
        r1 = (re - rs).normalized(); r2 = (rw - re).normalized()
        # rest hinge from the rest elbow bend (pole = opposite of forearm bend)
        bend = (r2 - r1 * r2.dot(r1)).normalized()
        rhinge = (-bend).cross(r1)
        q1 = self._limb_rot(r1, rhinge, d1, hinge)
        q2 = self._limb_rot(r2, rhinge, d2, hinge)
        twist = math.radians(hand.get("twist", 0.0))
        qt_half = Quaternion(d2, twist * 0.5); qt = Quaternion(d2, twist)
        self._set_world_rot(u1, posed, q1, Hs)
        self._set_world_rot(u2, posed, q1)
        self._set_world_rot(l1n, posed, q2, K)
        self._set_world_rot(l2n, posed, qt_half @ q2)
        wpos = posed[l2n] @ Vector((0, (self.tail[l2n] - self.head[l2n]).length, 0))
        flex = hand.get("flex", 0.0); dev = hand.get("dev", 0.0)
        qw = qt @ q2
        if flex or dev:
            # flex around elbow hinge axis (palm side), deviation around palm normal
            qw = Quaternion(hinge, math.radians(flex)) @ Quaternion(hinge.cross(d2), math.radians(dev)) @ qw
        if "rot" in hand:   # absolute world rotation relative to rest
            qw = euler_q(hand["rot"], "XYZ")
        if "aim" in hand:   # (finger direction, palm normal) in world
            fd, pn = V(hand["aim"][0]).normalized(), V(hand["aim"][1]).normalized()
            Fr = frame(self._rest_hand_dir[s], self._rest_palm[s])
            Ft = frame(fd, pn)
            qw = (Ft @ Fr.transposed()).to_quaternion()
            # distribute the forearm twist part to the twist bone
            qrel = qw @ q2.inverted()
            tw = self._twist_angle(qrel, d2)
            self._set_world_rot(l2n, posed, Quaternion(d2, tw * 0.5) @ q2)
            wpos = posed[l2n] @ Vector((0, (self.tail[l2n] - self.head[l2n]).length, 0))
        if guard:
            fax = (wpos - posed[l1n].translation).normalized()     # same forearm axis as fitanim.anat
            qw, tw_c = self._wrist_guard(s, qw, q2, fax)
            if tw_c is not None:
                self._set_world_rot(l2n, posed, Quaternion(d2, math.radians(tw_c) * 0.5) @ q2)
                wpos = posed[l2n] @ Vector((0, (self.tail[l2n] - self.head[l2n]).length, 0))
        self._set_world_rot(wr, posed, qw, wpos)
        posed["_palm" + s] = posed[wr] @ Vector(self._palm_local[s])

    # ------------------------------------------------------------------ anatomical limits (arms)
    # clinical ROM (AAOS / Norkin & White): humeral rotation -75 (int) .. +100 (ext), forearm pronation 85 /
    # supination 90, wrist flexion 80 / extension 90 (loaded), radial/ulnar deviation ~30.
    HUM_ROT = (-70.0, 95.0)
    SUP = (-85.0, 90.0)
    WRIST_FLEX = (-88.0, 78.0)
    WRIST_DEV = 30.0
    FOREARM_BIAS = 18.0

    def _hum_rot(self, s, Hs, K, E, body_rot):
        """humeral rotation (deg, +external) of an elbow at K, same definition as fitanim.anat."""
        sg = 1 if s == "L" else -1
        Ti = body_rot.inverted()
        h = Ti @ (K - Hs).normalized(); f = Ti @ (E - K).normalized()
        flex = math.degrees(h.angle(f))
        elev = math.degrees(Vector((0, 0, -1)).angle(h))
        if flex < 25 or elev > 155:
            return None
        f0 = Vector((0, 0, -1)).rotation_difference(h) @ Vector((0, -1, 0))
        f0 = f0 - h * f0.dot(h); fp = f - h * f.dot(h)
        if f0.length < 1e-6 or fp.length < 1e-6:
            return None
        f0.normalize(); fp.normalize()
        return -sg * math.degrees(math.atan2(f0.cross(fp).dot(h), f0.dot(fp)))

    def _elbow_guard(self, s, Hs, A, la, lb, pole, body_rot):
        """keep the humeral rotation inside its range by turning the elbow around the shoulder->wrist axis.
        continuous: the correction equals the excess (Newton steps) and fades in with the elbow bend, so
        it never snaps between frames."""
        lo, hi = self.HUM_ROT
        K, E, pp = self._two_bone(Hs, A, la, lb, pole)
        r = self._hum_rot(s, Hs, K, E, body_rot)
        if r is None or lo <= r <= hi:
            return pole
        ax = A - Hs
        if ax.length < 1e-4:
            return pole
        ax.normalize()
        f = (E - K).normalized(); h = (K - Hs).normalized()
        flex = math.degrees(h.angle(f))
        w = max(0.0, min(1.0, (flex - 30.0) / 20.0))           # fade in between 30 and 50 deg elbow bend
        if w <= 0:
            return pole
        target = hi if r > hi else lo
        ang = 0.0
        cur = r
        for _ in range(4):
            # numerical derivative d(rot)/d(angle)
            eps = 0.05
            c1 = Quaternion(ax, ang + eps) @ pole
            K1, E1, _ = self._two_bone(Hs, A, la, lb, c1)
            r1 = self._hum_rot(s, Hs, K1, E1, body_rot)
            if r1 is None:
                break
            der = (r1 - cur) / eps
            if abs(der) < 1e-3:
                break
            step = (target - cur) / der
            step = max(-1.2, min(1.2, step))
            ang += step
            c = Quaternion(ax, ang) @ pole
            K2, E2, _ = self._two_bone(Hs, A, la, lb, c)
            cur2 = self._hum_rot(s, Hs, K2, E2, body_rot)
            if cur2 is None:
                break
            cur = cur2
            if abs(cur - target) < 0.5:
                break
        return Quaternion(ax, ang * w) @ pole

    def wrist_angles(self, s, qw, q2, fax):
        """forearm rotation + wrist angles of the world hand rotation qw (rest->posed), relative to the
        untwisted forearm rotation q2 around the forearm axis fax. swing-twist: qrel = swing @ twist(fax),
        the swing (axis perpendicular to the forearm) is split into flexion / deviation components.
        returns sup (+supination), flex (+palmar), dev (signed), plus the pieces to rebuild."""
        sg = 1 if s == "L" else -1
        qrel = qw @ q2.inverted()
        tw = self._twist_angle(qrel, fax)
        qt = Quaternion(fax, tw)
        sw = qrel @ qt.inverted()
        ang = sw.angle
        if ang > math.pi:
            ang -= 2 * math.pi
        ax = Vector(sw.axis) if abs(ang) > 1e-7 else Vector((1, 0, 0))
        rv = ax * ang
        rv = rv - fax * rv.dot(fax)
        nN = qt @ (q2 @ self._rest_palm[s]); dN = qt @ (q2 @ self._rest_hand_dir[s])
        e_f = nN.cross(dN); e_f = (e_f - fax * e_f.dot(fax)).normalized()     # rotating fingers towards palm
        e_f = -e_f
        e_d = fax.cross(e_f).normalized()
        flex = math.degrees(rv.dot(e_f)); dev = math.degrees(rv.dot(e_d))
        sup = -sg * math.degrees(tw) - self.FOREARM_BIAS
        return sup, flex, dev, (qt, e_f, e_d)

    def _wrist_guard(self, s, qw, q2, fax):
        """clamp forearm twist + wrist flexion/deviation to the anatomical range (idempotent)."""
        sg = 1 if s == "L" else -1
        sup, fl, dv, (qt, e_f, e_d) = self.wrist_angles(s, qw, q2, fax)
        sup_c = max(self.SUP[0], min(self.SUP[1], sup))
        fl_c = max(self.WRIST_FLEX[0], min(self.WRIST_FLEX[1], fl))
        dv_c = max(-self.WRIST_DEV, min(self.WRIST_DEV, dv))
        if abs(fl_c - fl) < 0.3 and abs(dv_c - dv) < 0.3 and abs(sup_c - sup) < 0.3:
            return qw, None
        tw_c = math.radians(-sg * (sup_c + self.FOREARM_BIAS))
        qt_c = Quaternion(fax, tw_c)
        rv = e_f * math.radians(fl_c) + e_d * math.radians(dv_c)
        # e_f/e_d were built from the unclamped twist; rotate them with the twist change
        dq = qt_c @ qt.inverted()
        rv = dq @ rv
        sw = Quaternion(rv.normalized(), rv.length) if rv.length > 1e-8 else Quaternion()
        q_new = sw @ qt_c @ q2
        return q_new, (math.degrees(tw_c) if abs(sup_c - sup) >= 0.3 else None)

    @staticmethod
    def _twist_angle(q, axis):
        p = Vector((q.x, q.y, q.z)).project(axis)
        tw = Quaternion((q.w, p.x, p.y, p.z))
        if tw.magnitude < 1e-8:
            return 0.0
        tw.normalize()
        ang = 2 * math.atan2(Vector((tw.x, tw.y, tw.z)).dot(axis), tw.w)
        return (ang + math.pi) % (2 * math.pi) - math.pi

    # ------------------------------------------------------------------ bake
    def basis_from_posed(self, posed):
        out = {}
        for name in self.order:
            p = self.parent[name]
            if p:
                b = (posed[p] @ self.rel[name]).inverted() @ posed[name]
            else:
                b = self.rest[name].inverted() @ posed[name]
            out[name] = b
        return out

    def apply(self, posed, frame=None):
        basis = self.basis_from_posed(posed)
        pb = self.ob.pose.bones
        for name, b in basis.items():
            bone = pb[name]
            bone.rotation_mode = "QUATERNION"
            loc, rot, _ = b.decompose()
            # keep quaternion continuity
            prev = bone.rotation_quaternion
            if prev.dot(rot) < 0:
                rot.negate()
            bone.rotation_quaternion = rot
            bone.location = loc
            if frame is not None:
                bone.keyframe_insert("rotation_quaternion", frame=frame)
                bone.keyframe_insert("location", frame=frame)
        return basis

    def world(self, posed, name, local=(0, 0, 0)):
        return self.ob.matrix_world @ (posed[name] @ Vector(local))
