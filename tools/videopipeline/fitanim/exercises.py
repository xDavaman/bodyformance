"""Exercise library.

Each exercise is a class with:
    title, subtitle, muscles (highlighted), props, camera preset, rep_time, reps
    pose(ph, rep, ctx)   -> pose dict for the solver (ph = 0..1 phase in the rep)
    intensity(ph)        -> 0..1 muscle highlight
    arrows               -> list of 3D arrow specs (optional)
Coordinates: character faces -Y, x = character's left, z = up, metres.
"""
import math
from mathutils import Vector, Quaternion, Euler

# ------------------------------------------------------------------- helpers
def ss(x):
    x = max(0.0, min(1.0, x))
    return x * x * (3 - 2 * x)


def sine(x):
    x = max(0.0, min(1.0, x))
    return 0.5 - 0.5 * math.cos(math.pi * x)


def seg(ph, a, b):
    return sine((ph - a) / (b - a)) if b > a else float(ph >= a)


def cycle(ph, down=0.42, hold=0.10, up=0.36):
    """0 at top -> 1 at bottom -> 0. Typical tempo of an exercise rep."""
    if ph < down:
        return sine(ph / down)
    if ph < down + hold:
        return 1.0
    if ph < down + hold + up:
        return 1.0 - sine((ph - down - hold) / up)
    return 0.0


def lerp(a, b, t):
    if isinstance(a, (tuple, list)):
        return tuple(x + (y - x) * t for x, y in zip(a, b))
    return a + (b - a) * t


def rotx(deg):
    return Quaternion((1, 0, 0), math.radians(deg))


NECK_UP = (-30, 0, 0)   # straightens MakeHuman's forward head posture
HEAD_UP = (-8, 0, 0)


def foot(x, y, toe_out=0.0, heel=0.0, side="L", lift=0.0):
    """Ankle target for a foot standing on the floor at (x, y). heel = plantar flexion
    (deg) pivoting around the ball of the foot; toe_out = outward yaw (deg)."""
    sgn = 1 if side == "L" else -1
    yaw = toe_out * sgn
    ank = Vector((0, 0, 0.074))
    ball = Vector((0, -0.135, 0.02))
    qy = Quaternion((0, 0, 1), math.radians(yaw))
    qp = Quaternion((1, 0, 0), math.radians(heel))
    pos = Vector((x, y, lift)) + qy @ (ball + qp @ (ank - ball))
    return dict(pos=tuple(pos), rot=(heel, 0, yaw))


def straight_wrist(pz, P, sides=("L", "R"), flex=0.0, keep=0.0):
    """re-aim the hands so the fingers continue the forearm (neutral wrist, no sideways kink); the
    palm keeps facing the requested direction. flex = extra wrist flexion (deg, + towards the palm),
    keep = how much of the original finger direction to keep (0..1)."""
    posed = pz.solve(P)
    for s in sides:
        h = P.get("hand" + s)
        if not h or "aim" not in h:
            continue
        f = (posed[f"wrist.{s}"].translation - posed[f"lowerarm01.{s}"].translation).normalized()
        pn = Vector(h["aim"][1])
        pn = pn - f * pn.dot(f)
        if pn.length < 1e-4:
            continue
        pn.normalize()
        fing = f
        if flex:
            fing = Quaternion(pn.cross(f), math.radians(-flex)) @ f
        if keep:
            fing = fing.lerp(Vector(h["aim"][0]).normalized(), keep).normalized()
        h = dict(h); h["aim"] = (tuple(fing), tuple(pn)); P["hand" + s] = h
    return P


def rigid_pivot(pz, rest_point, world_point, q):
    """hips offset so that a rest-pose point (rigid with the pelvis) lands on world_point
    when the body is rotated by q around the root."""
    root = pz.J["root"]
    return tuple(Vector(world_point) - root - q @ (Vector(rest_point) - root))


def stand(feet_w=0.15, toe=8):
    return dict(neck=NECK_UP, head=HEAD_UP,
                footL=foot(feet_w, -0.01, toe, side="L"), footR=foot(-feet_w, -0.01, toe, side="R"))


def arms_down(P, out=0.24, z=0.86):
    P["handL"] = dict(pos=(out, 0.0, z), pole=(0.2, 1, 0), twist=0)
    P["handR"] = dict(pos=(-out, 0.0, z), pole=(-0.2, 1, 0), twist=0)
    return P


class Exercise:
    key = "base"
    title = "Exercise"
    subtitle = ""
    muscles = []
    props = []            # list of dicts, see director
    camera = "front34"
    rep_time = 3.0
    reps = 2
    intro = 0.8           # seconds of standing before the first rep
    arrows = []

    def pose(self, ph, rep, ctx):
        raise NotImplementedError

    def intensity(self, ph):
        return 0.35 + 0.65 * cycle(ph)

    def start_pose(self, ctx):
        return self.pose(0.0, 0, ctx)


# =================================================================== library
class BackSquat(Exercise):
    key = "squat"
    title = "BARBELL SQUAT"
    subtitle = "Quads · Glutes · Adductors"
    muscles = ["quads", "glutes", "adductors"]
    props = [dict(type="rack"), dict(type="barbell", mode="chest", pos=(0, 0.075, 1.50), plates=2),
             dict(type="mat")]
    camera = "front"
    rep_time = 3.4
    reps = 2
    arrows = [dict(kind="spine_down", color="blue", when=(0.0, 0.42)),
              dict(kind="feet_out", color="red", intro=True)]

    reel = ["front", ((2.4, -2.2, 0.95), (2.0, -1.9, 0.9), (0, 0.05, 0.75), (0, 0.05, 0.72), 40), ((0.0, -2.6, 0.55), (0.0, -2.3, 0.6), (0, 0, 0.75), (0, 0, 0.75), 32)]

    def pose(self, ph, rep, ctx):
        d = cycle(ph, 0.40, 0.12, 0.36)
        P = stand(0.20, 15)
        P["hips"] = (0, 0.20 * d, -0.53 * d)
        P["hips_rot"] = (38 * d, 0, 0)
        P["spine"] = (-8 * d, 0, 0)
        P["neck"] = (NECK_UP[0] - 22 * d, 0, 0)
        P["head"] = (HEAD_UP[0] - 6 * d, 0, 0)
        P["footL"]["knee_out"] = 10; P["footR"]["knee_out"] = 10
        for s, sg in (("L", 1), ("R", -1)):
            P["hand" + s] = dict(palm=(sg * 0.40, 0.075, 1.50), space="chest",
                                 pole=(sg * 0.5, 0.9, -1.0), aim=((0, 0.25, 1.0), (0, -1, 0.25)))
        P["grip"] = 0.95
        return P


class PushUp(Exercise):
    key = "pushup"
    title = "PUSH-UP"
    subtitle = "Chest · Triceps · Front Delts"
    muscles = ["chest", "triceps", "delts"]
    props = [dict(type="mat", size=(1.0, 2.4), loc=(0, -0.6, 0))]
    camera = "side_low"
    cam = ((2.5, -3.0, 1.30), (2.1, -2.6, 1.15), (0, -0.42, 0.32), (0, -0.42, 0.30), 32)
    rep_time = 2.6
    reps = 3
    arrows = [dict(kind="body_down", color="blue", when=(0.0, 0.42))]

    reel = ["side_low", ((0.0, -3.2, 1.6), (0.3, -2.8, 1.4), (0, -0.6, 0.3), (0, -0.6, 0.3), 32), ((3.0, -0.6, 0.45), (2.7, -0.7, 0.45), (0, -0.5, 0.35), (0, -0.5, 0.35), 32)]

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.42, 0.08, 0.38)
        ankle_mid_rest = (pz.J["ankleL"] + pz.J["ankleR"]) / 2
        # on the toes: ankle height so the ball of the foot rests on the floor (foot pitched ~70 deg)
        anchor = Vector((0, 0.35, foot(0, 0, heel=70)["pos"][2]))
        th_top, th_bot = self._range(pz, ankle_mid_rest, anchor)
        theta = lerp(th_top, th_bot, d)
        q = rotx(theta)
        P = dict(neck=(-10 - 14, 0, 0), head=(-12, 0, 0), spine=(-3, 0, 0))
        P["hips_rot"] = (theta, 0, 0)
        P["hips"] = rigid_pivot(pz, ankle_mid_rest, anchor, q)
        root = pz.J["root"]
        for s, sg in (("L", 1), ("R", -1)):
            a = anchor + q @ (pz.J["ankle" + s] - ankle_mid_rest) * 0.62
            P["foot" + s] = dict(pos=tuple(a), rot=(theta - 8, 0, 0), pole=(0, 0, -1))
        # hands under shoulders at top
        qt = rotx(th_top)
        top_off = Vector(rigid_pivot(pz, ankle_mid_rest, anchor, qt))
        for s, sg in (("L", 1), ("R", -1)):
            shw = root + top_off + qt @ (pz.J["shoulder" + s] - root)
            P["hand" + s] = dict(pos=(sg * 0.33, shw.y - 0.02, 0.045), pole=(sg * 0.8, 1.0, 0.6),
                                 aim=((sg * 0.12, -1, 0), (0, 0, -1)), shrug=0)
        P["grip"] = 0.0
        return P


    # elbow flexion at the top (almost locked) / bottom (chest a fist above the floor, ~90-100 deg;
    # push-up kinematics: inner elbow angle ~80-110 deg at the bottom, ~175 at the top)
    FLEX_TOP, FLEX_BOT = 6.0, 98.0

    def _range(self, pz, ankle_mid_rest, anchor):
        key = id(pz)
        cache = PushUp.__dict__.get("_cache", {})
        if key in cache:
            return cache[key]
        root = pz.J["root"]
        la, lb = pz.arm_len["L"]

        def chord(flex):
            return math.sqrt(la * la + lb * lb + 2 * la * lb * math.cos(math.radians(flex)))

        def sh_at(th):
            qq = rotx(th)
            off = Vector(rigid_pivot(pz, ankle_mid_rest, anchor, qq))
            return root + off + qq @ (pz.J["shoulderL"] - root)

        def solve(target, hand_y, lo=60.0, hi=89.5):
            for _ in range(40):
                mid = (lo + hi) / 2
                shw = sh_at(mid)
                dist = (Vector((0.33, hand_y, 0.045)) - shw).length
                if dist > target:
                    lo = mid
                else:
                    hi = mid
            return (lo + hi) / 2
        # top: hands under the shoulders -> iterate (hand y depends on the top angle)
        th = 72.0
        for _ in range(4):
            hy = sh_at(th).y - 0.02
            th = solve(chord(self.FLEX_TOP), hy)
        hy = sh_at(th).y - 0.02
        tb = solve(chord(self.FLEX_BOT), hy)
        cache[key] = (th, tb)
        PushUp._cache = cache
        return th, tb


class Lunge(Exercise):
    key = "lunge"
    title = "FORWARD LUNGE"
    subtitle = "Quads · Glutes"
    muscles = ["quads", "glutes"]
    props = [dict(type="mat", size=(1.4, 2.8), loc=(0, -0.3, 0))]
    camera = "front34"
    rep_time = 3.0
    reps = 2

    reel = ["front34", ((3.6, -0.9, 1.0), (3.3, -1.0, 0.95), (0, -0.35, 0.75), (0, -0.35, 0.72), 38)]

    def pose(self, ph, rep, ctx):
        front = "L" if rep % 2 == 0 else "R"
        back = "R" if front == "L" else "L"
        fs = 1 if front == "L" else -1
        step = seg(ph, 0.0, 0.28) * (1 - seg(ph, 0.72, 1.0))       # front foot travel
        lift = math.sin(math.pi * min(1, ph / 0.28)) * 0.07 if ph < 0.28 else \
            (math.sin(math.pi * (ph - 0.72) / 0.28) * 0.07 if ph > 0.72 else 0)
        d = seg(ph, 0.18, 0.45) * (1 - seg(ph, 0.55, 0.82))           # depth
        P = stand(0.13, 6)
        fy = -0.78 * step
        P["foot" + front] = foot(fs * 0.14, -0.01 + fy, 8, side=front, lift=lift)
        P["foot" + back] = foot(-fs * 0.12, -0.01, 4, heel=48 * max(step, d) * 1.0, side=back)
        P["foot" + front]["pole"] = (fs * 0.1, -1, 0)
        P["foot" + back]["pole"] = (0, -1, -0.4)
        P["hips"] = (fs * 0.0, -0.36 * step, -0.41 * d)      # both knees ~90-100 deg at the bottom
        P["hips_rot"] = (6 * d, 0, 0)
        P["spine"] = (-4 * d, 0, 0)
        P = arms_down(P, 0.26, 0.86)
        P["handL"]["pos"] = (0.27, -0.36 * step, 0.86 - 0.46 * d)
        P["handR"]["pos"] = (-0.27, -0.36 * step, 0.86 - 0.46 * d)
        P["handL"]["space"] = "root"; P["handR"]["space"] = "root"
        P["handL"]["pos"] = (0.27, 0.0, 0.88); P["handR"]["pos"] = (-0.27, 0.0, 0.88)
        return P

    def intensity(self, ph):
        return 0.3 + 0.7 * seg(ph, 0.18, 0.45) * (1 - seg(ph, 0.55, 0.82))


class BicepCurl(Exercise):
    key = "curl"
    title = "DUMBBELL CURL"
    subtitle = "Biceps · Forearms"
    muscles = ["biceps", "forearms"]
    props = [dict(type="dumbbell", hand="L"), dict(type="dumbbell", hand="R"), dict(type="mat", size=(1.2, 1.4))]
    camera = "front34_close"
    rep_time = 2.6
    reps = 3

    reel = ["front34_close", ((-1.6, -2.2, 1.35), (-1.2, -1.8, 1.35), (0, 0, 1.15), (0, 0, 1.15), 45), ((0.0, -1.7, 1.35), (0.0, -1.5, 1.35), (0, 0, 1.2), (0, 0, 1.2), 40)]

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.4, 0.1, 0.42)
        P = stand(0.15, 8)
        ang = math.radians(lerp(6, getattr(self, "top", 140), d))
        la, lb = pz.arm_len["L"]
        for s, sg in (("L", 1), ("R", -1)):
            sh = pz.J["shoulder" + s]
            elbow = Vector((sh.x * 0.93 + sg * 0.005, sh.y + 0.045, sh.z - la * 0.985))
            fdir = Vector((sg * 0.06 * math.sin(ang), -math.sin(ang), -math.cos(ang))).normalized()
            hand = elbow + fdir * lb
            # supinated grip: palm faces forward at the bottom, up / towards the shoulder at the top
            palm = Vector((-sg * 0.25 * (1 - d), -math.cos(ang), math.sin(ang))).normalized()
            fing = (fdir + palm * (-0.15 * d)).normalized()          # slight wrist curl at the top
            P["hand" + s] = dict(pos=tuple(hand), space="chest", pole=(sg * 0.15, 1, 0),
                                 aim=(tuple(fing), tuple(palm)))
        P["grip"] = 0.9
        P["spine"] = (-2 * d, 0, 0)
        return P


class ShoulderPress(Exercise):
    key = "press"
    title = "DUMBBELL SHOULDER PRESS"
    subtitle = "Delts · Triceps"
    muscles = ["delts", "triceps"]
    props = [dict(type="dumbbell", hand="L", axis="across"), dict(type="dumbbell", hand="R", axis="across"),
             dict(type="mat", size=(1.2, 1.4))]
    camera = "front"
    rep_time = 2.8
    reps = 2
    arrows = [dict(kind="up_both", color="blue", when=(0.0, 0.36))]

    def pose(self, ph, rep, ctx):
        # 0 = start (dumbbells beside the ears, elbows out ~90°, forearms vertical), 1 = arms extended
        # technique: start with the dumbbells just above the shoulders, upper arms slightly below horizontal
        # in the scapular plane (~30 deg forward), forearms vertical (wrists stacked over the elbows);
        # press up and slightly in until the elbows are (almost) locked over the shoulders.
        d = cycle(ph, 0.36, 0.12, 0.42)
        P = stand(0.17, 8)
        pz = ctx["poser"]
        posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
        for s, sg in (("L", 1), ("R", -1)):
            la, lb = pz.arm_len[s]
            shw = posed[f"upperarm01.{s}"].translation + Vector((0, 0, 0.035 * d))   # shrug at the top
            a, b = math.radians(30), math.radians(-12)
            up_dir = Vector((sg * math.cos(b) * math.cos(a), -math.cos(b) * math.sin(a), math.sin(b)))
            bottom = shw + up_dir * la + Vector((0, 0, lb * 0.97))
            top = shw + Vector((sg * 0.06, -0.03, 1)).normalized() * (la + lb) * 0.965
            pos = bottom.lerp(top, d)
            P["hand" + s] = dict(pos=tuple(pos), pole=(sg * 1.0, -0.35, -0.45),
                                 aim=((sg * 0.05, 0, 1), (0, -1, 0)), shrug=lerp(1, 9, d))
        # second pass: the shrug lifts the shoulder joint -> re-target the lockout from the real joint
        posed = pz.solve(P)
        for s, sg in (("L", 1), ("R", -1)):
            la, lb = pz.arm_len[s]
            shw = posed[f"upperarm01.{s}"].translation
            top = shw + Vector((sg * 0.06, -0.03, 1)).normalized() * (la + lb) * 1.0
            cur = Vector(P["hand" + s]["pos"])
            P["hand" + s]["pos"] = tuple(cur.lerp(top, d * d))
        P["grip"] = 0.9
        P["spine"] = (-3, 0, 0)
        straight_wrist(ctx["poser"], P)
        return P


class RomanianDeadlift(Exercise):
    key = "rdl"
    title = "ROMANIAN DEADLIFT"
    subtitle = "Hamstrings · Glutes · Lower Back"
    muscles = ["hamstrings", "glutes", "lowerback"]
    props = [dict(type="barbell", mode="hands", plates=2), dict(type="mat")]
    camera = "side34"
    rep_time = 3.6
    reps = 2

    reel = ["side34", ((3.4, 0.4, 1.0), (3.2, 0.2, 0.95), (0, 0.05, 0.8), (0, 0.05, 0.8), 40)]

    def pose(self, ph, rep, ctx):
        d = cycle(ph, 0.42, 0.1, 0.38)
        P = stand(0.14, 6)
        P["hips"] = (0, 0.21 * d, -0.045 * d)    # RDL: hips travel back, knees only soften (~15-25 deg)
        P["hips_rot"] = (68 * d, 0, 0)
        P["spine"] = (4 * d, 0, 0)
        P["neck"] = (NECK_UP[0] - 6 * d, 0, 0)
        P["footL"]["pole"] = (0.1, -1, 0); P["footR"]["pole"] = (-0.1, -1, 0)
        for s, sg in (("L", 1), ("R", -1)):
            P["hand" + s] = dict(hang=0.995, offset=(sg * -0.03, -0.03 - 0.04 * d, 0), pole=(sg * 0.2, 1, 0),
                                 aim=((0, -0.15 * d, -1), (0, 1, 0)), shrug=-2)
        P["grip"] = 0.95
        return P


class JumpingJack(Exercise):
    key = "jack"
    title = "JUMPING JACKS"
    subtitle = "Full Body · Calves · Delts"
    muscles = ["calves", "delts", "glutes"]
    props = [dict(type="mat", size=(1.6, 1.6))]
    camera = "front"
    rep_time = 1.1
    reps = 5
    intro = 0.6

    def pose(self, ph, rep, ctx):
        o = sine(min(1, ph / 0.5)) if ph < 0.5 else 1 - sine((ph - 0.5) / 0.5)
        air = abs(math.sin(2 * math.pi * ph))   # two jumps per cycle
        air = air ** 1.5
        jump = 0.09 * air
        fw = lerp(0.12, 0.44, o)
        P = stand(fw, lerp(6, 18, o))
        for s, sg in (("L", 1), ("R", -1)):
            f = foot(sg * fw, -0.01, lerp(6, 18, o), heel=28 * air + 6, side=s, lift=jump)
            f["knee_out"] = 10
            P["foot" + s] = f
            ang = lerp(12, 168, o)
            sh = Vector((sg * 0.22, -0.01, 1.44 + jump - 0.04 * (1 - air)))
            r = math.radians(ang)
            hand = sh + Vector((sg * math.sin(r), -0.06, -math.cos(r))) * 0.53
            P["hand" + s] = dict(pos=tuple(hand), pole=(sg * 0.1, 1, 0.2), twist=sg * lerp(0, 60, o))
        P["hips"] = (0, 0, jump - 0.04 * (1 - air))
        P["grip"] = 0.3
        return P

    def intensity(self, ph):
        return 0.8


class GluteBridge(Exercise):
    key = "bridge"
    title = "GLUTE BRIDGE"
    subtitle = "Glutes · Hamstrings"
    muscles = ["glutes", "hamstrings"]
    props = [dict(type="mat", size=(1.0, 2.4), loc=(0, -0.2, 0))]
    camera = "side_low"
    cam = ((2.7, -1.9, 1.15), (2.3, -1.5, 1.0), (0, 0.08, 0.25), (0, 0.08, 0.25), 34)
    rep_time = 3.0
    reps = 2
    arrows = [dict(kind="hips_up", color="blue", when=(0.0, 0.4))]

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.40, 0.15, 0.38)
        theta = -90 - 34 * d                       # hips lift: trunk tilts ~34 deg around the shoulder blades
        q = rotx(theta)
        sh_mid = (pz.J["shoulderL"] + pz.J["shoulderR"]) / 2
        scap = sh_mid + Vector((0, 0.10, -0.12))   # upper-back contact point (rest coords)
        anchor = Vector((0, 0.40, 0.02))
        # neck flexes as the trunk tilts so the back of the head stays on the mat
        P = dict(spine=(-3 * d, 0, 0), neck=(-2 + 30 * d, 0, 0), head=(-4 + 6 * d, 0, 0))
        P["hips_rot"] = (theta, 0, 0)
        P["hips"] = rigid_pivot(pz, scap, anchor, q)
        self.q = q
        for s, sg in (("L", 1), ("R", -1)):
            P["foot" + s] = dict(pos=(sg * 0.15, -0.50, 0.086), rot=(0, 0, sg * 4), pole=(sg * 0.12, -0.3, 1))
            P["hand" + s] = dict(pos=(sg * 0.30, anchor.y - 0.42, 0.035), pole=(sg * 1, 0, 0.3),
                                 aim=((0, -1, 0), (0, 0, -1)), shrug=0)
        P["grip"] = 0.05
        return P


class PullUp(Exercise):
    key = "pullup"
    title = "PULL-UP"
    subtitle = "Lats · Biceps · Rear Delts"
    muscles = ["lats", "biceps", "traps"]
    props = [dict(type="rack"), dict(type="pullbar", z=2.32)]
    camera = "back34"
    rep_time = 3.2
    reps = 2
    intro = 0.4

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.40, 0.10, 0.42)
        bar_z, bar_y = 2.32, -0.05
        la, lb = pz.arm_len["L"]
        sh_z_top = bar_z - 0.20
        dz_hang = self._hang_dz(pz, bar_y, bar_z)
        dz = lerp(dz_hang, sh_z_top - pz.J["shoulderL"].z, d)
        P = dict(neck=(NECK_UP[0] - 10 * d, 0, 0), head=(HEAD_UP[0] - 8 * d, 0, 0), spine=(-6 * d, 0, 0))
        P["hips"] = (0, 0.04 + 0.06 * d, dz)
        P["hips_rot"] = (-6 - 6 * d, 0, 0)
        for s, sg in (("L", 1), ("R", -1)):
            a = pz.J["ankle" + s]
            P["foot" + s] = dict(pos=(sg * 0.08, a.y + 0.30, a.z + dz + 0.30), rot=(18, 0, 0), relax=28,
                                 pole=(sg * 0.1, -1, 0))
            P["hand" + s] = dict(palm=(sg * 0.42, bar_y, bar_z), pole=(sg * 1, 0.35, -0.6),
                                 aim=((0, 0.2, 1), (0, -1, 0.2)), shrug=lerp(22, -4, d))
        P["grip"] = 1.0
        return P


    def _hang_dz(self, pz, bar_y, bar_z):
        """dead hang: lower the body until the arms are straight (palms on the bar, shoulders elevated)."""
        key = (id(pz), bar_y, bar_z)
        cache = PullUp.__dict__.get("_hcache", {})
        if key in cache:
            return cache[key]
        la, lb = pz.arm_len["L"]
        dz = bar_z - 0.05 - (la + lb) - pz.J["shoulderL"].z
        for _ in range(4):
            P = dict(neck=NECK_UP, hips=(0, 0.04, dz), hips_rot=(-6, 0, 0))
            for s, sg in (("L", 1), ("R", -1)):
                P["hand" + s] = dict(palm=(sg * 0.42, bar_y, bar_z), pole=(sg * 1, 0.35, -0.6),
                                     aim=((0, 0.2, 1), (0, -1, 0.2)), shrug=22)
            posed = pz.solve(P)
            sh = posed["upperarm01.L"].translation
            wr_t = posed["wrist.L"].translation
            el = posed["lowerarm01.L"].translation
            # how far the wrist target is from a straight arm: shorten the gap along the arm line
            short = (la + lb) * 0.998 - (wr_t - sh).length
            if abs(short) < 0.002:
                break
            dz -= short * max(0.5, (wr_t - sh).normalized().z)
        cache[key] = dz
        PullUp._hcache = cache
        return dz


class LateralRaise(Exercise):
    key = "lateral"
    title = "LATERAL RAISE"
    subtitle = "Side Delts"
    muscles = ["delts", "traps"]
    props = [dict(type="dumbbell", hand="L"), dict(type="dumbbell", hand="R"), dict(type="mat", size=(1.2, 1.4))]
    camera = "front"
    rep_time = 2.8
    reps = 2

    def pose(self, ph, rep, ctx):
        d = cycle(ph, 0.40, 0.10, 0.42)
        P = stand(0.15, 8)
        for s, sg in (("L", 1), ("R", -1)):
            ang = math.radians(lerp(14, 86, d))
            sh = Vector((sg * 0.22, -0.02, 1.44))
            hand = sh + Vector((sg * math.sin(ang), -0.12, -math.cos(ang))) * 0.552     # soft elbows (~25 deg)
            P["hand" + s] = dict(pos=tuple(hand), pole=(0, 0.6, 1), twist=sg * 10, shrug=2 + 4 * d,
                                 aim=((sg * math.sin(ang), -0.1, -math.cos(ang)), (-sg * math.cos(ang), 0, -math.sin(ang))))
        P["grip"] = 0.9
        return P


class Crunch(Exercise):
    key = "crunch"
    title = "CRUNCH"
    subtitle = "Abs"
    muscles = ["abs"]
    props = [dict(type="mat", size=(1.0, 2.2), loc=(0, -0.1, 0))]
    camera = "side_low"
    cam = ((2.6, -1.9, 1.15), (2.2, -1.5, 1.0), (0, 0.1, 0.3), (0, 0.1, 0.3), 34)
    rep_time = 2.4
    reps = 3

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.4, 0.12, 0.4)
        q = rotx(-92)
        hip_mid = (pz.J["hipL"] + pz.J["hipR"]) / 2 + Vector((0, 0.06, 0))
        anchor = Vector((0, 0.0, 0.11))
        P = dict(spine=(34 * d, 0, 0), neck=(10 + 14 * d, 0, 0), head=(4, 0, 0))
        P["hips_rot"] = (-92, 0, 0)
        P["hips"] = rigid_pivot(pz, hip_mid, anchor, q)
        for s, sg in (("L", 1), ("R", -1)):
            P["foot" + s] = dict(pos=(sg * 0.15, anchor.y - 0.52, 0.074), rot=(0, 0, sg * 4), pole=(sg * 0.1, 0, 1))
        posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
        Rc = posed["spine01"].to_3x3() @ pz.rest["spine01"].to_3x3().inverted()
        for s, sg in (("L", 1), ("R", -1)):
            # fingertips at the temples (fingers towards the crown, palms facing the head), elbows wide
            P["hand" + s] = dict(palm=(sg * 0.125, -0.01, 1.72), space="chest", pole=(sg * 1, -0.2, 0.1),
                                 aim=(tuple(Rc @ Vector((0, 0.15, 1))), tuple(Rc @ Vector((-sg, 0, 0)))), shrug=4)
        orig = {s: P["hand" + s]["aim"] for s in "LR"}
        for _ in range(2):                  # 2nd pass: palm target moved with the new hand orientation
            for s in "LR":
                P["hand" + s]["aim"] = orig[s]
            straight_wrist(pz, P, flex=8, keep=0.5)
        P["grip"] = 0.45
        return P


LIBRARY = {cls.key: cls for cls in
           [BackSquat, PushUp, Lunge, BicepCurl, ShoulderPress, RomanianDeadlift, JumpingJack,
            GluteBridge, PullUp, LateralRaise, Crunch]}


# =================================================================== bench + mobility
def hands_on_hips(P):
    for s, sg in (("L", 1), ("R", -1)):
        P["hand" + s] = dict(pos=(sg * 0.20, -0.02, 1.02), space="root", pole=(sg * 1, 0.4, 0),
                             aim=((0, -1, -0.35), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.15
    return P


def osc(ph, cycles=1.0):
    return math.sin(2 * math.pi * ph * cycles)


class BenchPress(Exercise):
    key = "bench"
    title = "BENCH PRESS"
    subtitle = "Chest · Triceps · Front Delts"
    muscles = ["chest", "triceps", "delts"]
    props = [dict(type="bench", loc=(0, 0.28, 0), length=1.3),
             dict(type="barbell", mode="hands", plates=2), dict(type="mat", size=(1.7, 2.6), loc=(0, 0.2, 0))]
    camera = "side34"
    cam = ((2.5, -1.5, 1.55), (2.1, -1.2, 1.4), (0, 0.32, 0.72), (0, 0.32, 0.70), 38)
    reel = ["side34", ((0.0, -1.9, 1.25), (0.0, -1.6, 1.15), (0, 0.4, 0.75), (0, 0.4, 0.75), 36),
            ((2.4, 0.5, 0.75), (2.2, 0.5, 0.75), (0, 0.42, 0.8), (0, 0.42, 0.8), 38)]
    rep_time = 3.0
    reps = 2
    arrows = [dict(kind="bench_up", color="blue", when=(0.52, 0.9))]

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.42, 0.10, 0.38)          # 0 = arms extended, 1 = bar on the chest
        q = rotx(-90)
        sh_mid = (pz.J["shoulderL"] + pz.J["shoulderR"]) / 2
        anchor = Vector((0, 0.66, 0.60))
        P = dict(spine=(-8, 0, 0), neck=(NECK_UP[0] + 4, 0, 0), head=(HEAD_UP[0], 0, 0))
        P["hips_rot"] = (-90, 0, 0)
        P["hips"] = rigid_pivot(pz, sh_mid, anchor, q)
        for s, sg in (("L", 1), ("R", -1)):
            P["foot" + s] = dict(pos=(sg * 0.31, -0.24, 0.074), rot=(0, 0, sg * 10), pole=(sg * 0.25, -0.5, 1))
            bar = lerp((0, 0.63, 1.11), (0, 0.48, 0.78), d)
            P["hand" + s] = dict(palm=(sg * 0.42, bar[1], bar[2]), pole=(sg * 1, -0.45, -0.55),
                                 aim=((0, 0.9, 0.42), (0, -0.42, 0.9)), shrug=0, protract=lerp(6, -4, d))
        P["grip"] = 1.0
        return P


class CatCow(Exercise):
    key = "catcow"
    title = "CAT-COW"
    subtitle = "Spine · Lower Back · Abs"
    muscles = ["lowerback", "abs"]
    props = [dict(type="mat", size=(1.0, 2.0), loc=(0, 0.0, 0))]
    camera = "side_low"
    cam = ((2.6, -1.3, 1.05), (2.3, -1.0, 0.95), (0, -0.02, 0.38), (0, -0.02, 0.36), 36)
    rep_time = 4.0
    reps = 2

    def quad_base(self, pz, theta=81.0, hip=(0, 0.2, 0.51)):
        q = rotx(theta)
        hip_mid = (pz.J["hipL"] + pz.J["hipR"]) / 2
        P = dict(hips_rot=(theta, 0, 0), hips=rigid_pivot(pz, hip_mid, hip, q))
        root = pz.J["root"]
        off = Vector(P["hips"])
        for s, sg in (("L", 1), ("R", -1)):
            P["foot" + s] = dict(pos=(sg * 0.12, hip[1] + 0.43, 0.06), rot=(172, 0, 0), pole=(0, -0.6, -1))
        return P, q, off

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        s = osc(ph)                                   # + cat (round), - cow (arch)
        P, q, off = self.quad_base(pz)
        P["spine"] = (30 * s, 0, 0)
        P["hips_rot"] = (81 - 7 * s, 0, 0)
        P["neck"] = (NECK_UP[0] + 4 + 22 * s, 0, 0)
        P["head"] = (HEAD_UP[0] + 8 * s, 0, 0)
        root = pz.J["root"]
        q0 = rotx(81)
        for k, sg in (("L", 1), ("R", -1)):
            shw = root + Vector(self.quad_base(pz)[2]) + q0 @ (pz.J["shoulder" + k] - root)
            P["hand" + k] = dict(pos=(sg * 0.24, shw.y - 0.03, 0.04), pole=(sg * 0.2, 1, 0),
                                 aim=((0, -1, 0), (0, 0, -1)), shrug=0)
        P["grip"] = 0.0
        return P

    def intensity(self, ph):
        return 0.45 + 0.45 * abs(osc(ph))


class ChildPoseRock(CatCow):
    key = "child"
    title = "CHILD'S POSE ROCK"
    subtitle = "Lats · Lower Back · Hips"
    muscles = ["lats", "lowerback", "glutes"]
    rep_time = 4.4

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.4, 0.2, 0.36)
        theta = lerp(81, 98, d)
        hip = lerp((0, 0.2, 0.51), (0, 0.50, 0.37), d)
        P, q, off = self.quad_base(pz, theta, hip)
        for s, sg in (("L", 1), ("R", -1)):
            P["foot" + s]["pos"] = (sg * 0.12, 0.64, 0.06)
        P["spine"] = (lerp(0, 10, d), 0, 0)
        P["neck"] = (NECK_UP[0] + lerp(6, 4, d), 0, 0)
        for k, sg in (("L", 1), ("R", -1)):
            P["hand" + k] = dict(pos=(sg * 0.24, lerp(-0.40, -0.48, d), 0.04), pole=(sg * 0.3, 1, 0.3),
                                 aim=((0, -1, 0), (0, 0, -1)), shrug=lerp(0, 18, d))
        P["grip"] = 0.0
        return P

    def intensity(self, ph):
        return 0.35 + 0.65 * cycle(ph, 0.4, 0.2, 0.36)


class DownDogPedal(Exercise):
    key = "downdog"
    title = "DOWNWARD DOG"
    subtitle = "Hamstrings · Calves · Shoulders"
    muscles = ["hamstrings", "calves"]
    props = [dict(type="mat", size=(1.0, 2.2), loc=(0, 0.0, 0))]
    camera = "side_low"
    cam = ((2.9, -1.4, 1.2), (2.6, -1.1, 1.1), (0, 0.0, 0.55), (0, 0.0, 0.55), 36)
    rep_time = 2.4
    reps = 3

    def pose(self, ph, rep, ctx):
        """classic downward dog (Adho Mukha Svanasana): hands shoulder-width, arms straight in line with
        the trunk (~50 deg to the floor), hips high (hip angle ~90-100 deg), legs straight, heels sinking
        towards the floor. A gentle alternating heel press keeps it alive (calf stretch)."""
        pz = ctx["poser"]
        theta = 140.0
        q = rotx(theta)
        u = q @ Vector((0, 0, 1))                    # body 'up' = from the shoulders towards the hands
        hands = Vector((0, -0.66, 0.045))
        la, lb = pz.arm_len["L"]
        shw = hands - u * (la + lb) * 0.985
        sh_mid = (pz.J["shoulderL"] + pz.J["shoulderR"]) / 2
        P = dict(hips_rot=(theta, 0, 0), hips=rigid_pivot(pz, sh_mid, shw, q),
                 spine=(-6, 0, 0), neck=(NECK_UP[0] + 18, 0, 0), head=(HEAD_UP[0], 0, 0))
        # the shrug (arms overhead) lifts the shoulder joints: push the body back until the arms are straight
        for _ in range(2):
            tmp = dict(P)
            for k, sg in (("L", 1), ("R", -1)):
                tmp["hand" + k] = dict(pos=(sg * 0.25, hands.y, hands.z), shrug=22)
            posed = pz.solve(tmp)
            shj = (posed["upperarm01.L"].translation + posed["upperarm01.R"].translation) / 2
            hm = Vector((0, hands.y, hands.z))
            gap = (la + lb) * 0.99 - (shj - hm).length
            P["hips"] = tuple(Vector(P["hips"]) - u * gap)
        posed = pz.solve({k: v for k, v in P.items()})
        s = osc(ph)
        for k, sg in (("L", 1), ("R", -1)):
            hip = posed[f"upperleg01.{k}"].translation
            l1, l2 = pz.leg_len[k]
            press = max(0.0, s * sg)                 # this side bends a little, the other heel sinks
            heel = 18 + 22 * press
            L = (l1 + l2) * (0.998 - 0.012 * press)
            az = 0.074 + 0.03 + 0.06 * press
            ay = hip.y + math.sqrt(max(0.01, L * L - (hip.z - az) ** 2))
            f = foot(sg * 0.11, ay, 0, heel=heel, side=k)
            f["pole"] = (0, -1, 0.3)
            P["foot" + k] = f
            P["hand" + k] = dict(pos=(sg * 0.25, hands.y, hands.z), pole=(sg * 0.6, 1, 0.4),
                                 aim=((sg * 0.1, -1, 0), (0, 0, -1)), shrug=22)
        P["grip"] = 0.0
        return P

    def intensity(self, ph):
        return 0.8


class Cobra(Exercise):
    key = "cobra"
    title = "COBRA STRETCH"
    subtitle = "Abs · Hip Flexors · Spine"
    muscles = ["abs", "obliques"]
    props = [dict(type="mat", size=(1.0, 2.3), loc=(0, 0.3, 0))]
    camera = "side_low"
    cam = ((2.6, -1.5, 1.0), (2.3, -1.2, 0.9), (0, 0.15, 0.3), (0, 0.15, 0.3), 36)
    rep_time = 4.0
    reps = 2

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        d = cycle(ph, 0.4, 0.2, 0.36)
        q = rotx(90)
        hip_mid = (pz.J["hipL"] + pz.J["hipR"]) / 2
        anchor = Vector((0, 0.30, 0.105))
        P = dict(hips_rot=(90, 0, 0), hips=rigid_pivot(pz, hip_mid, anchor, q),
                 spine=(-48 * d, 0, 0), neck=(NECK_UP[0] - 2 - 10 * d, 0, 0), head=(HEAD_UP[0] - 6 * d, 0, 0))
        for k, sg in (("L", 1), ("R", -1)):
            P["foot" + k] = dict(pos=(sg * 0.11, 0.30 + 0.86, 0.06), rot=(172, 0, 0), pole=(0, 0, -1))
            P["hand" + k] = dict(pos=(sg * 0.27, -0.06, 0.04), pole=(sg * 0.3, 1, 0.4),
                                 aim=((0, -1, 0), (0, 0, -1)), shrug=0)
        P["grip"] = 0.0
        return P


class HipFlexorStretch(Exercise):
    key = "hipflexor"
    title = "HALF-KNEELING HIP FLEXOR STRETCH"
    subtitle = "Hip Flexors · Quads · Obliques"
    muscles = ["quads", "obliques"]
    props = [dict(type="mat", size=(1.2, 2.0), loc=(0, -0.05, 0))]
    camera = "side34"
    cam = ((2.6, -2.2, 1.2), (2.3, -1.9, 1.1), (0, -0.05, 0.75), (0, -0.05, 0.72), 40)
    rep_time = 4.0
    reps = 2

    def pose(self, ph, rep, ctx):
        d = cycle(ph, 0.4, 0.25, 0.3)
        P = dict(neck=NECK_UP, head=HEAD_UP)
        P["hips"] = (0.0, -0.10 - 0.08 * d, -0.455 - 0.02 * d)
        P["hips_rot"] = (-4 - 6 * d, 0, 0)
        P["spine"] = (-4 * d, 16 * d, 0)
        P["footL"] = foot(0.14, -0.62, 6, side="L"); P["footL"]["pole"] = (0.1, -1, 0)
        P["footR"] = dict(pos=(-0.12, 0.33, 0.06), rot=(172, 0, 0), pole=(0, -1, -0.2))
        P["handR"] = dict(pos=(-0.10, -0.02, 2.02), space="chest", pole=(-1, 0.3, -0.3),
                          aim=((0.2, 0, 1), (1, 0, 0)), shrug=12)
        P["handL"] = dict(pos=(0.17, -0.36, 0.64), pole=(1, 0.4, 0), aim=((0, -0.6, -1), (0, 0, -1)))
        P["grip"] = 0.2
        return P


class DeepSquatRotation(Exercise):
    key = "squatrot"
    title = "DEEP SQUAT T-SPINE ROTATION"
    subtitle = "Hips · Adductors · Upper Back"
    muscles = ["adductors", "obliques"]
    props = [dict(type="mat", size=(1.4, 1.6))]
    camera = "front34"
    rep_time = 3.6
    reps = 2

    def pose(self, ph, rep, ctx):
        side = "L" if rep % 2 == 0 else "R"
        sg = 1 if side == "L" else -1
        r = cycle(ph, 0.4, 0.2, 0.36)
        P = stand(0.24, 25)
        P["hips"] = (0, 0.10, -0.64)
        P["hips_rot"] = (28, 0, 0)
        P["spine"] = (4, 0, 38 * r * sg)
        P["neck"] = (NECK_UP[0] - 14, 25 * r * sg, 0)
        P["head"] = (HEAD_UP[0] - 4, 12 * r * sg, 0)
        P["footL"]["knee_out"] = 25; P["footR"]["knee_out"] = 25
        other = "R" if side == "L" else "L"
        P["hand" + side] = dict(pos=lerp((sg * 0.06, -0.38, 1.05), (sg * 0.30, 0.0, 2.0), r), space="chest",
                                pole=(sg * 1, 0.3, -0.3), aim=((sg * 0.2, -0.3 * (1 - r), 1), (0, -1, 0)))
        P["hand" + other] = dict(pos=(-sg * 0.02, -0.34, 0.07), pole=(-sg * 1, 0.2, 0.2),
                                 aim=((0, -1, 0), (0, 0, -1)))
        P["grip"] = 0.2
        return P


class ToeTouch(Exercise):
    key = "toetouch"
    title = "STANDING FORWARD FOLD"
    subtitle = "Hamstrings · Lower Back · Calves"
    muscles = ["hamstrings", "lowerback"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "side34"
    rep_time = 4.0
    reps = 2

    def pose(self, ph, rep, ctx):
        d = cycle(ph, 0.42, 0.18, 0.36)
        P = stand(0.12, 6)
        P["hips"] = (0, 0.16 * d, -0.05 * d)
        P["hips_rot"] = (78 * d, 0, 0)
        P["spine"] = (38 * d, 0, 0)
        P["neck"] = (NECK_UP[0] + 26 * d, 0, 0)
        for k, sg in (("L", 1), ("R", -1)):
            P["hand" + k] = dict(hang=0.995, offset=(sg * -0.02, -0.08 * d, 0), pole=(sg * 0.2, 1, 0),
                                 aim=((0, -0.2 * d, -1), (-sg * 0.3, 1, 0)))
        P["grip"] = 0.2
        return P


def abduction_aim(arm, ks):
    """(finger dir, palm normal) for an arm moving in the frontal plane: palm towards the thigh when
    down, down at shoulder height, towards the head overhead (humerus rotates out on the way up)."""
    f = Vector((arm.x, 0.0, arm.z)).normalized() if Vector((arm.x, 0, arm.z)).length > 1e-6 else Vector((0, 0, -1))
    n = Vector((ks * f.z, 0.0, -ks * f.x))
    alpha = math.degrees(math.atan2(ks * f.x, -f.z))          # 0 down, 90 sideways, 180 up
    beta = math.radians(180 * min(1.0, max(0.0, (alpha - 90) / 90)))
    n = Quaternion(f, -ks * beta) @ n
    return tuple(f), tuple(n)


class SideBend(Exercise):
    key = "sidebend"
    title = "STANDING SIDE BEND"
    subtitle = "Obliques · Lats"
    muscles = ["obliques", "lats"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "front"
    rep_time = 3.6
    reps = 2

    def pose(self, ph, rep, ctx):
        sg = 1 if rep % 2 == 0 else -1                 # +1: bend to the character's left
        d = cycle(ph, 0.4, 0.2, 0.36)
        P = stand(0.17, 8)
        P["spine"] = (0, 36 * d * sg, 0)
        P["hips"] = (-0.04 * d * sg, 0, 0)
        P["neck"] = (NECK_UP[0], 0, 6 * d * sg)
        # the overhead arm changes side every rep: the old arm lowers while the new one rises
        b = ss(min(1.0, ph / 0.22))
        for k, ks in (("L", 1), ("R", -1)):
            is_up = (ks == -sg)                      # arm opposite to the bend goes overhead
            was_up = rep > 0 and (ks == sg)          # previous rep bent the other way
            u = b if is_up else ((1 - b) if was_up else 0.0)
            # straight arm sweeping sideways on an arc around the shoulder (never through it)
            al = math.radians(lerp(4, 168, ss(u)))
            shc = Vector((ks * 0.21, -0.02, 1.47))
            pos = shc + Vector((ks * math.sin(al), -0.03 * math.sin(al), -math.cos(al))) * 0.545
            P["hand" + k] = dict(pos=tuple(pos), space="chest", pole=(ks * 0.25, 1, -0.4 * (1 - u)),
                                 aim=abduction_aim(pos - Vector((ks * 0.21, -0.02, 1.47)), ks), shrug=10 * u)
        P["grip"] = 0.15
        return P


class TorsoTwist(Exercise):
    key = "twist"
    title = "STANDING TORSO TWIST"
    subtitle = "Obliques · Upper Back"
    muscles = ["obliques"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "front34"
    rep_time = 3.2
    reps = 2

    def pose(self, ph, rep, ctx):
        s = osc(ph)
        P = stand(0.2, 8)
        P["spine"] = (0, 0, 48 * s)
        P["hips_rot"] = (0, 0, 10 * s)
        P["neck"] = (NECK_UP[0], 14 * s, 0)
        for k, sg in (("L", 1), ("R", -1)):
            P["hand" + k] = dict(pos=(sg * 0.17, -0.50, 1.36), space="chest", pole=(sg * 1, 0.4, -0.5),
                                 aim=((0, -1, 0), (0, 0, -1)), shrug=3)
        P["grip"] = 0.1
        return P

    def intensity(self, ph):
        return 0.4 + 0.6 * abs(osc(ph))


class ArmCircles(Exercise):
    key = "armcircles"
    title = "ARM CIRCLES"
    subtitle = "Shoulders · Rotator Cuff"
    muscles = ["delts"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "front34"
    rep_time = 2.4
    reps = 3

    def pose(self, ph, rep, ctx):
        a = 2 * math.pi * ph * 2
        P = stand(0.17, 8)
        for k, sg in (("L", 1), ("R", -1)):
            sh = Vector((sg * 0.22, -0.02, 1.44))
            hand = sh + Vector((sg * 0.50, 0.11 * math.cos(a), 0.11 * math.sin(a) + 0.02))
            P["hand" + k] = dict(pos=tuple(hand), pole=(0, 0.4, 1), aim=((sg, 0, 0), (0, 0, -1)), shrug=6)
        P["grip"] = 0.05
        return P

    def intensity(self, ph):
        return 0.85


class HipCircles(Exercise):
    key = "hipcircles"
    title = "HIP CIRCLES"
    subtitle = "Hips · Glutes · Lower Back"
    muscles = ["glutes", "obliques"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "front34"
    rep_time = 2.8
    reps = 3

    def pose(self, ph, rep, ctx):
        a = 2 * math.pi * ph
        P = stand(0.20, 10)
        P["hips"] = (0.07 * math.cos(a), 0.06 * math.sin(a), -0.03)
        P["hips_rot"] = (6 * math.sin(a), 0, 0)
        P["spine"] = (-6 * math.sin(a), 8 * math.cos(a), 0)
        hands_on_hips(P)
        return P

    def intensity(self, ph):
        return 0.8


class LegSwings(Exercise):
    key = "legswings"
    title = "LEG SWINGS"
    subtitle = "Hip Flexors · Hamstrings · Glutes"
    muscles = ["hamstrings", "quads"]
    props = [dict(type="mat", size=(1.2, 1.8), loc=(0, -0.1, 0))]
    camera = "side34"
    rep_time = 2.2
    reps = 3

    def pose(self, ph, rep, ctx):
        pz = ctx["poser"]
        a = 42 * osc(ph)
        P = stand(0.10, 6)
        P["hips"] = (0.05, 0, 0)
        P["spine"] = (-a * 0.12, 0, 0)
        hip = Vector((-0.11 + 0.05, 0.006, 0.97))
        r = math.radians(a)
        L = 0.86
        ank = hip + Vector((0, -math.sin(r), -math.cos(r))) * L + Vector((0, 0, 0.03 + 0.03 * abs(math.sin(r))))
        P["footR"] = dict(pos=tuple(ank), rot=(-a + 8, 0, -4), pole=(0, -1, 0))
        hands_on_hips(P)
        return P

    def intensity(self, ph):
        return 0.4 + 0.5 * abs(osc(ph))


class NeckRolls(Exercise):
    key = "neckrolls"
    title = "NECK ROLLS"
    subtitle = "Neck · Upper Traps"
    muscles = ["traps"]
    props = [dict(type="mat", size=(1.2, 1.4))]
    camera = "front34_close"
    rep_time = 4.0
    reps = 2

    def pose(self, ph, rep, ctx):
        a = 2 * math.pi * ph
        P = stand(0.16, 8)
        P["neck"] = (NECK_UP[0] + 6 + 22 * math.sin(a), 0, 24 * math.cos(a))
        P["head"] = (HEAD_UP[0] + 8 * math.sin(a), 0, 8 * math.cos(a))
        arms_down(P, 0.26, 0.87)
        return P

    def intensity(self, ph):
        return 0.8


LIBRARY.update({cls.key: cls for cls in
                [BenchPress, CatCow, ChildPoseRock, DownDogPedal, Cobra, HipFlexorStretch, DeepSquatRotation,
                 ToeTouch, SideBend, TorsoTwist, ArmCircles, HipCircles, LegSwings, NeckRolls]})
MOBILITY = ["catcow", "child", "downdog", "cobra", "hipflexor", "squatrot", "toetouch", "sidebend",
            "twist", "armcircles", "hipcircles", "legswings", "neckrolls", "bridge"]
