"""Bodyformance motion library: one parametric generator per Bodyformance `motionKey` (73 motions),
each adapting to the equipment of the exercise (barbell, dumbbell, kettlebell, cable, band, machine,
medball, sling, bar, none …). Used by `make_exercise()` to animate any of the 4,294 Bodyformance exercises.

Generator signature:  gen(ph, rep, ctx, eq) -> pose dict   (ph = 0..1 phase of the rep)
"""
import math
from mathutils import Vector

from . import exercises as EX
from .exercises import (ss, sine, seg, cycle, lerp, rotx, foot, rigid_pivot, stand, arms_down, hands_on_hips,
                        osc, NECK_UP, HEAD_UP)

MOTIONS = {}
SIDES = (("L", 1), ("R", -1))

# muscle codes of Bodyformance -> fitanim highlight masks
MUSCLE_MAP = {"chest": "chest", "lats": "lats", "traps": "traps", "delts": "delts", "biceps": "biceps",
              "triceps": "triceps", "forearms": "forearms", "abs": "abs", "lowerback": "lowerback",
              "glutes": "glutes", "quads": "quads", "hamstrings": "hamstrings", "adductors": "adductors",
              "hipflexors": "quads", "calves": "calves", "neck": "traps"}

# camera presets by posture
CAM_STAND = "front34"
CAM_SIDE = "side34"
CAM_FLOOR = ((2.6, -1.9, 1.15), (2.2, -1.5, 1.0), (0, 0.05, 0.3), (0, 0.05, 0.3), 34)
CAM_BENCH = ((2.5, -1.5, 1.55), (2.1, -1.2, 1.4), (0, 0.32, 0.72), (0, 0.32, 0.70), 38)
CAM_HANG = ((2.0, -3.6, 1.75), (1.6, -3.2, 1.7), (0, 0, 1.5), (0, 0, 1.5), 40)


def motion(key, cam=CAM_STAND, rep=3.0, reps=2, anchor=None, extra=(), mat=True, intro=0.8, collide=True):
    """collide: True / False / dict(hands=False, feet=..., body=..., settle=..., legs=...) for the
    automatic contact corrector (fitanim.collide)."""
    def deco(fn):
        MOTIONS[key] = dict(fn=fn, cam=cam, rep=rep, reps=reps, anchor=anchor, extra=list(extra), mat=mat,
                            intro=intro, collide=collide)
        return fn
    return deco


# ============================================================================ shared pieces
LIB = {}


def lib(cls):
    if cls not in LIB:
        LIB[cls] = cls()
    return LIB[cls]


def hold_hands(P, eq, width=0.22, z=0.88, y=0.0, palm_in=True):
    """Arms hanging with the implement in the hands (dumbbells / kettlebells / bar)."""
    for s, sg in SIDES:
        w = width if eq not in ("barbell",) else 0.26
        P["hand" + s] = dict(pos=(sg * w, y, z), pole=(sg * 0.2, 1, 0),
                             aim=((0, 0, -1), (-sg, 0, 0) if palm_in and eq != "barbell" else (0, 1, 0)))
    P["grip"] = 0.95 if eq not in ("none",) else 0.2
    return P


def chest_hold(P, y=-0.2, z=1.3, gap=0.07):
    """Implement held in front of the chest (goblet / medball)."""
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * gap, y, z), space="chest", pole=(sg * 1, 0.4, -1),
                             aim=((0, -0.2, 1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.6
    return P


def supine(pz, theta=-90.0, anchor=(0, 0.45, 0.10), pivot="shoulders"):
    q = rotx(theta)
    if pivot == "shoulders":
        rp = (pz.J["shoulderL"] + pz.J["shoulderR"]) / 2 + Vector((0, 0.03, -0.04))
    else:
        rp = (pz.J["hipL"] + pz.J["hipR"]) / 2 + Vector((0, 0.06, 0))
    return dict(hips_rot=(theta, 0, 0), hips=rigid_pivot(pz, rp, anchor, q),
                neck=(NECK_UP[0] + 14, 0, 0), head=(HEAD_UP[0] + 4, 0, 0))


def prone(pz, theta=90.0, anchor=(0, 0.3, 0.105)):
    q = rotx(theta)
    rp = (pz.J["hipL"] + pz.J["hipR"]) / 2
    return dict(hips_rot=(theta, 0, 0), hips=rigid_pivot(pz, rp, anchor, q), neck=(NECK_UP[0] - 4, 0, 0),
                head=HEAD_UP)


def seated_floor(pz, lean=0.0, hip_y=0.2):
    """Sitting on the floor, legs long in front."""
    q = rotx(lean)
    rp = (pz.J["hipL"] + pz.J["hipR"]) / 2
    P = dict(hips_rot=(lean, 0, 0), hips=rigid_pivot(pz, rp, (0, hip_y, 0.11), q), neck=NECK_UP, head=HEAD_UP)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.11, hip_y - 0.86, 0.07), rot=(-75, 0, sg * 6), pole=(sg * 0.1, 0, 1))
    return P


def seated_box(pz, lean=0.0, seat_z=0.48, hip_y=0.15, feet_y=-0.25):
    q = rotx(lean)
    rp = (pz.J["hipL"] + pz.J["hipR"]) / 2
    P = dict(hips_rot=(lean, 0, 0), hips=rigid_pivot(pz, rp, (0, hip_y, seat_z + 0.07), q), neck=NECK_UP,
             head=HEAD_UP)
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.17, feet_y, 8, side=s)
        P["foot" + s]["pole"] = (sg * 0.2, -1, 0.4)
    return P


def quadruped(pz, theta=81.0, hip=(0, 0.2, 0.51)):
    P, q, off = lib(EX.CatCow).quad_base(pz, theta, hip)
    root = pz.J["root"]
    for k, sg in SIDES:
        shw = root + off + q @ (pz.J["shoulder" + k] - root)
        P["hand" + k] = dict(pos=(sg * 0.24, shw.y - 0.03, 0.04), pole=(sg * 0.2, 1, 0),
                             aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.0
    P["neck"] = (NECK_UP[0] + 6, 0, 0)
    return P


def hand_arc(shoulder, sg, ang_side, ang_fwd, r=0.552):
    """hand point on a sphere around the shoulder. ang_side: abduction, ang_fwd: flexion (deg)."""
    a, b = math.radians(ang_side), math.radians(ang_fwd)
    d = Vector((sg * math.sin(a) * math.cos(b), -math.sin(b), -math.cos(a) * math.cos(b)))
    return tuple(Vector(shoulder) + d.normalized() * r)


SH = lambda sg: Vector((sg * 0.22, -0.02, 1.44))

WRIST_REACH = 0.562      # shoulder -> wrist, arm straight with ~10 deg soft elbow (full: 0.565)
PALM_REACH = 0.637       # shoulder -> palm grip point


def shoulders(ctx, P):
    """world shoulder joints of pose P (arms ignored)."""
    posed = ctx["poser"].solve({k: v for k, v in P.items() if not k.startswith("hand")})
    return {s: posed[f"upperarm01.{s}"].translation.copy() for s in "LR"}


def leg_to(ctx, P, s, direction, frac=0.99):
    """ankle target for a straight leg (soft knee) from the real hip joint of pose P along `direction`."""
    pz = ctx["poser"]
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith(("foot", "hand"))})
    hip = posed[f"upperleg01.{s}"].translation
    l1, l2 = pz.leg_len[s]
    return hip + Vector(direction).normalized() * (l1 + l2) * frac


def clamp_reach(sh, target, reach=WRIST_REACH):
    t = Vector(target)
    d = t - sh
    return tuple(sh + d.normalized() * reach) if d.length > reach else tuple(t)


def grab_on(sh, a, b, prefer=1.0, reach=WRIST_REACH):
    """point on segment a->b (e.g. along a shin) closest to fraction `prefer` that the hand can reach."""
    a, b = Vector(a), Vector(b)
    best = None
    for i in range(41):
        f = i / 40
        p = a.lerp(b, f)
        if (p - sh).length <= reach and (best is None or abs(f - prefer) < abs(best[0] - prefer)):
            best = (f, p)
    if best is None:
        f = min(range(41), key=lambda i: (a.lerp(b, i / 40) - sh).length) / 40
        return clamp_reach(sh, a.lerp(b, f), reach)
    return tuple(best[1])


def breathe(ph, amp=1.0):
    return amp * math.sin(2 * math.pi * ph)


# ============================================================================ legs
@motion("squat", rep=3.2)
def m_squat(ph, rep, ctx, eq):
    if eq in ("barbell", "machine"):
        return lib(EX.BackSquat).pose(ph, rep, ctx)
    d = cycle(ph, 0.40, 0.12, 0.36)
    P = stand(0.21, 16)
    P["hips"] = (0, 0.17 * d, -0.50 * d)
    P["hips_rot"] = (30 * d, 0, 0)
    P["spine"] = (-8 * d, 0, 0)
    P["neck"] = (NECK_UP[0] - 18 * d, 0, 0)
    P["footL"]["knee_out"] = 10; P["footR"]["knee_out"] = 10
    if eq in ("dumbbell", "kettlebell", "medball", "cable"):
        chest_hold(P)
    elif eq == "band":
        for s, sg in SIDES:
            P["hand" + s] = dict(pos=(sg * 0.2, -0.12, 1.45), space="chest", pole=(sg * 1, 0.6, -1),
                                 aim=((0, -0.3, 1), (0, -1, 0)))
        P["grip"] = 0.9
    else:
        for s, sg in SIDES:
            P["hand" + s] = dict(pos=(sg * 0.16, -0.5, 1.38), space="chest", pole=(sg * 0.6, 1, -0.4),
                                 aim=((0, -1, 0), (0, 0, -1)))
        P["grip"] = 0.2
    return P


@motion("deepSquat", rep=4.0)
def m_deepsquat(ph, rep, ctx, eq):
    P = stand(0.24, 25)
    b = breathe(ph, 0.02)
    P["hips"] = (0, 0.10, -0.64 + b)
    P["hips_rot"] = (28, 0, 0); P["spine"] = (4, 0, 0); P["neck"] = (NECK_UP[0] - 14, 0, 0)
    P["footL"]["knee_out"] = 25; P["footR"]["knee_out"] = 25
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.035, -0.30, 1.22), space="chest", pole=(sg * 1, 0.3, -0.6),
                             aim=((0, -0.1, 1), (-sg, 0, 0)))
    P["grip"] = 0.1
    return P


@motion("lunge", cam=CAM_SIDE, rep=3.0)
def m_lunge(ph, rep, ctx, eq):
    P = lib(EX.Lunge).pose(ph, rep, ctx)
    if eq in ("dumbbell", "kettlebell"):
        for s, sg in SIDES:
            P["hand" + s] = dict(hang=0.995, offset=(sg * 0.02, 0, 0), pole=(sg * 0.2, 1, 0),
                                 aim=((0, 0, -1), (-sg, 0, 0)))
        P["grip"] = 0.95
    elif eq in ("barbell", "machine"):
        for s, sg in SIDES:
            P["hand" + s] = dict(palm=(sg * 0.40, 0.075, 1.50), space="chest", pole=(sg * 0.5, 0.9, -1.0),
                                 aim=((0, 0.1, 1.0), (0, -1, 0.1)))
        P["grip"] = 0.95
    elif eq in ("medball", "cable"):
        chest_hold(P)
    else:
        hands_on_hips(P)
    return P


@motion("cossack", rep=4.0)
def m_cossack(ph, rep, ctx, eq):
    s_ = osc(ph)                       # -1 .. 1  (shift left / right)
    d = abs(s_) ** 0.8
    P = stand(0.42, 20)
    P["hips"] = (0.26 * s_, 0.08 * d, -0.48 * d)
    P["hips_rot"] = (22 * d, 0, -6 * s_)
    P["spine"] = (-4 * d, 0, 0)
    for s, sg in SIDES:
        bent = (sg * s_) > 0
        f = foot(sg * 0.42, -0.01, 20 if bent else 35, side=s, heel=0)
        if not bent:
            f["rot"] = (-35 * d, 0, sg * 35)
        f["knee_out"] = 15
        P["foot" + s] = f
    chest_hold(P) if eq != "none" else [P.__setitem__("hand" + s, dict(pos=(sg * 0.12, -0.45, 1.3), space="chest",
                                         pole=(sg, 1, -0.4))) for s, sg in SIDES]
    return P


@motion("calf", rep=2.2, reps=3)
def m_calf(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.15, 0.4)
    P = stand(0.13, 6)
    h = 32 * d
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.13, -0.01, 6, heel=h, side=s)
    lift = 0.135 * math.sin(math.radians(h))
    P["hips"] = (0, -0.01 * d, lift)
    if eq in ("dumbbell", "kettlebell"):
        for s, sg in SIDES:
            P["hand" + s] = dict(hang=0.995, offset=(sg * 0.03, 0, 0), pole=(sg * 0.2, 1, 0),
                                 aim=((0, 0, -1), (-sg, 0, 0)))
        P["grip"] = 0.95
    elif eq in ("barbell", "machine"):
        for s, sg in SIDES:
            P["hand" + s] = dict(palm=(sg * 0.40, 0.075, 1.50), space="chest", pole=(sg * 0.5, 0.9, -1.0),
                                 aim=((0, 0.1, 1.0), (0, -1, 0.1)))
        P["grip"] = 0.95
    else:
        hands_on_hips(P)
    return P


@motion("rdl", cam=CAM_SIDE, rep=3.6)
def m_rdl(ph, rep, ctx, eq):
    P = lib(EX.RomanianDeadlift).pose(ph, rep, ctx)
    if eq == "none":
        for s, sg in SIDES:
            P["hand" + s] = dict(pos=(sg * 0.2, -0.03, 1.02), space="root", pole=(sg, 0.4, 0),
                                 aim=((0, -1, -0.35), (-sg, 0, 0)))
    elif eq in ("dumbbell", "kettlebell"):
        for s, sg in SIDES:
            P["hand" + s]["aim"] = ((0, 0, -1), (-sg * 0.3, 1, 0))
            P["hand" + s]["offset"] = (sg * 0.02, -0.02, 0)
    return P


@motion("swing", cam=CAM_SIDE, rep=1.6, reps=4, collide=dict(hands=False))
def m_swing(ph, rep, ctx, eq):
    a = math.sin(2 * math.pi * ph)            # -1 back swing, +1 top
    d = max(0.0, -a)                          # hinge depth
    up = max(0.0, a)
    P = stand(0.24, 18)
    P["hips"] = (0, 0.16 * d, -0.10 * d)
    P["hips_rot"] = (55 * d - 3 * up, 0, 0)
    P["spine"] = (4 * d, 0, 0)
    ang = lerp(-28, 88, (a + 1) / 2)           # arm angle from straight down (chest frame)
    r = math.radians(ang)
    for s, sg in SIDES:
        # straight arms on a sphere around each shoulder, both hands meeting on the handle
        shc = Vector((sg * 0.21, -0.02, 1.47))
        tgt = Vector((sg * 0.035, -0.55 * math.sin(r), 1.47 - 0.55 * math.cos(r)))
        wr = shc + (tgt - shc).normalized() * 0.545
        P["hand" + s] = dict(pos=tuple(wr), space="chest", pole=(sg * 0.3, 1, -0.2),
                             aim=((0, -math.sin(r), -math.cos(r)), (-sg, 0, 0)), shrug=0)
    P["grip"] = 1.0
    return P


@motion("legSwing", cam=CAM_SIDE, rep=2.2, reps=3)
def m_legswing(ph, rep, ctx, eq):
    if eq in ("machine", "cable", "band"):         # hip abduction side to side
        a = 32 * max(0.0, osc(ph))
        P = stand(0.10, 6)
        P["hips"] = (0.05, 0, 0)
        P["spine"] = (0, 4 * a / 32, 0)
        hip = Vector((-0.06, 0.006, 0.97)); r = math.radians(a)
        ank = hip + Vector((-math.sin(r), 0, -math.cos(r))) * 0.86 + Vector((0, 0, 0.03))
        P["footR"] = dict(pos=tuple(ank), rot=(0, -a, -4), pole=(0, -1, 0))
        hands_on_hips(P)
        return P
    return lib(EX.LegSwings).pose(ph, rep, ctx)


@motion("bridge", cam=CAM_FLOOR, rep=3.0)
def m_bridge(ph, rep, ctx, eq):
    gb = lib(EX.GluteBridge)
    P = gb.pose(ph, rep, ctx)
    if eq in ("barbell", "dumbbell", "kettlebell", "medball"):
        q = gb.q                                    # body rotation of this frame
        w = 0.30 if eq == "barbell" else 0.075
        for s, sg in SIDES:
            # palms on the hip crease holding the implement (rest coords -> rotated with the pelvis)
            P["hand" + s] = dict(palm=(sg * w, -0.19, 0.95), space="root", pole=tuple(q @ Vector((sg, 0.2, -1))),
                                 aim=(tuple(q @ Vector((0, -0.25, -1))), tuple(q @ Vector((0, 1, -0.25)))), shrug=0)
        P["grip"] = 0.9
    return P


# ============================================================================ push
@motion("benchPress", cam=CAM_BENCH, rep=3.0, extra=[dict(type="bench", loc=(0, 0.28, 0), length=1.3)], mat=False)
def m_bench(ph, rep, ctx, eq):
    P = lib(EX.BenchPress).pose(ph, rep, ctx)
    if eq in ("dumbbell", "kettlebell"):
        # dumbbell bench press: lockout straight over the shoulders, lowered to the sides of the chest with the
        # forearms vertical and the elbows ~45-60 deg off the torso (elbow ~90-100 deg at the bottom)
        d = cycle(ph, 0.42, 0.10, 0.38)
        posed = ctx["poser"].solve({k: v for k, v in P.items() if not k.startswith("hand")})
        for s, sg in SIDES:
            shj = posed[f"upperarm01.{s}"].translation
            la, lb = ctx["poser"].arm_len[s]
            top = shj + Vector((-sg * 0.03, -0.02, 1)).normalized() * (la + lb) * 0.998
            a = math.radians(65)                     # upper arm 65 deg off the torso, elbow ~15 deg below the bench
            udir = Vector((sg * math.sin(a), -math.cos(a), -0.27)).normalized()
            bottom = shj + udir * la + Vector((0, 0, lb * 0.995))
            pos = top.lerp(bottom, d)
            P["hand" + s] = dict(pos=tuple(pos), pole=(sg * 1, -0.3, -0.6), aim=((0, 0.6, 0.8), (0, -0.8, 0.6)), shrug=0)
    return P


@motion("pushup", cam=EX.PushUp.cam, rep=2.6, reps=3)
def m_pushup(ph, rep, ctx, eq):
    return lib(EX.PushUp).pose(ph, rep, ctx)


def medball_slam(ph):
    """ball from the chest up over the head, slammed down in an arc in front of the feet (deep hinge),
    picked up and back to the chest. Hand targets live in chest space so the hinge carries them."""
    C = Vector((0, -0.02, 1.47))                   # shoulder centre (chest space)
    arc = lambda deg: C + Vector((0, -math.sin(math.radians(deg)), -math.cos(math.radians(deg)))) * 0.55
    chest = Vector((0, -0.30, 1.30))
    if ph < 0.32:
        u = ss(ph / 0.32); ball = chest.lerp(arc(168), u); low = 0.0
    elif ph < 0.42:
        ball = arc(168); low = 0.0
    elif ph < 0.58:
        u = ss((ph - 0.42) / 0.16); ball = arc(lerp(168, 62, u)); low = u
    elif ph < 0.74:
        ball = arc(62); low = 1.0
    else:
        u = ss((ph - 0.74) / 0.26); ball = arc(62).lerp(chest, u); low = 1.0 - u
    P = stand(0.22, 14)
    P["hips"] = (0, 0.14 * low, -0.36 * low)
    P["hips_rot"] = (48 * low, 0, 0)
    P["spine"] = (6 * low, 0, 0)
    P["neck"] = (NECK_UP[0] - 22 * low, 0, 0)
    P["footL"]["knee_out"] = 10; P["footR"]["knee_out"] = 10
    d = ball - C
    for s, sg in SIDES:
        palm = ball + Vector((sg * 0.115, 0, 0))
        P["hand" + s] = dict(palm=tuple(palm), space="chest", pole=(sg * 0.8, 0.5, -0.6),
                             aim=(tuple(d.normalized()), (-sg, 0, 0)), shrug=8 * max(0.0, d.z / 0.55))
    P["grip"] = 0.55
    return P


@motion("overhead", cam="front", rep=2.8)
def m_overhead(ph, rep, ctx, eq):
    if eq == "medball":
        return medball_slam(ph)
    P = lib(EX.ShoulderPress).pose(ph, rep, ctx)
    if eq in ("barbell", "machine"):
        d = cycle(ph, 0.36, 0.12, 0.42)
        for s, sg in SIDES:
            # front rack (bar on the front delts, elbows forward-down) -> lockout over the head
            pos = lerp((sg * 0.26, -0.17, 1.52), (sg * 0.24, -0.04, 1.97), d)
            P["hand" + s] = dict(palm=pos, pole=tuple(lerp((sg * 0.35, -1.0, -1.1), (sg * 1, -0.3, -0.5), d)),
                                 aim=((0, 0.1, 1), (0, -1, 0.1)), shrug=lerp(1, 9, d))
        # lockout from the real (shrugged) shoulder joints: arms fully straight, bar over the mid-foot
        posed = ctx["poser"].solve(P)
        for s, sg in SIDES:
            shj = posed[f"upperarm01.{s}"].translation
            tgt = Vector((sg * 0.24, -0.03, shj.z))
            dxy = (tgt - shj).length
            top = Vector((sg * 0.24, -0.03, shj.z + math.sqrt(max(0.0, (PALM_REACH + 0.003) ** 2 - dxy ** 2))))
            P["hand" + s]["palm"] = tuple(Vector(P["hand" + s]["palm"]).lerp(top, d * d))
    return P


@motion("triceps", cam=CAM_SIDE, rep=2.8)
def m_triceps(ph, rep, ctx, eq):
    d = cycle(ph, 0.4, 0.1, 0.4)
    if eq in ("bar", "machine", "sling", "none"):       # dips (parallel bars)
        pz = ctx["poser"]
        P = dict(neck=NECK_UP, head=HEAD_UP, spine=(4 + 8 * d, 0, 0))
        P["hips"] = (0, 0.02, 0.255 - 0.25 * d)
        P["hips_rot"] = (8 + 14 * d, 0, 0)
        for s, sg in SIDES:
            a = pz.J["ankle" + s]
            P["foot" + s] = dict(pos=(sg * 0.07, a.y + 0.28, a.z + 0.255 - 0.25 * d + 0.25), rot=(12, 0, 0),
                                 pole=(sg * 0.1, -1, 0))
            P["hand" + s] = dict(palm=(sg * 0.27, 0.02, 1.145), pole=(0, 1, 0.2), aim=((0, -1, 0), (0, 0, -1)),
                                 shrug=lerp(-4, 8, d))
        P["grip"] = 0.9
        return P
    # overhead extension (dumbbell / barbell / cable / band / kettlebell)
    P = stand(0.15, 8)
    for s, sg in SIDES:
        ang = math.radians(lerp(170, 60, d))
        elbow = Vector((sg * 0.12, -0.05, 1.84))
        hand = elbow + Vector((sg * 0.02, 0.27 * math.cos(ang - math.pi / 2) * -0.2, 0.27 * math.sin(ang) * -1 + 0.0))
        hand = elbow + Vector((0, 0.27 * math.sin(math.radians(lerp(0, 120, d))), 0.27 * math.cos(math.radians(lerp(0, 120, d)))))
        P["hand" + s] = dict(pos=(sg * 0.07, hand.y, hand.z), pole=(sg * 0.2, -1, 1), aim=((0, 0.3, 1), (-sg, 0, 0)),
                             shrug=10)
    P["grip"] = 0.95
    return P


@motion("pushdown", cam=CAM_SIDE, rep=2.4, anchor=(0, -0.55, 2.0))
def m_pushdown(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.1, 0.45)
    P = stand(0.17, 8)
    P["hips_rot"] = (12, 0, 0)
    for s, sg in SIDES:
        a = math.radians(lerp(100, 20, d))           # forearm angle from vertical-down (hands end in front of the thighs)
        elbow = Vector((sg * 0.19, 0.0, 1.225))     # elbows pinned at the ribs (root space)
        hand = elbow + Vector((0, -0.27 * math.sin(a), -0.27 * math.cos(a)))
        P["hand" + s] = dict(pos=(sg * 0.07, hand.y, hand.z), space="root", pole=(sg * 0.2, 1, 0),
                             aim=((0, -math.sin(a), -math.cos(a)), (0, 0, -1) if True else (0, 0, 1)))
    P["grip"] = 0.9
    return P


@motion("skull", cam=CAM_BENCH, rep=2.8, extra=[dict(type="bench", loc=(0, 0.28, 0), length=1.3)], mat=False)
def m_skull(ph, rep, ctx, eq):
    P = lib(EX.BenchPress).pose(0.0, 0, ctx)
    d = cycle(ph, 0.4, 0.1, 0.4)
    pz = ctx["poser"]
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
    for s, sg in SIDES:
        # upper arms stay put (vertical, tilted ~10 deg towards the head), only the elbows bend:
        # bar from over the chin down to just above the forehead (elbow ~110 deg)
        shj = posed[f"upperarm01.{s}"].translation
        la, lb = pz.arm_len[s]
        up = Vector((-sg * 0.12, math.sin(math.radians(10)), math.cos(math.radians(10)))).normalized()
        elbow = shj + up * la
        a = math.radians(lerp(4, 112, d))
        fdir = Vector((0, math.sin(math.radians(10) + a), math.cos(math.radians(10) + a)))
        hand = elbow + fdir * lb * 0.995
        P["hand" + s] = dict(pos=tuple(hand), pole=(0, -0.2, 1),
                             aim=(tuple(fdir), (0, -fdir.z, fdir.y)), shrug=0)
    return P


@motion("kickback", cam=CAM_SIDE, rep=2.4)
def m_kickback(ph, rep, ctx, eq):
    """bent-over triceps kickback: torso hinged ~55 deg, upper arm pinned parallel to the torso,
    forearm swings from hanging straight down to in line with the upper arm (neutral grip)."""
    d = cycle(ph, 0.35, 0.15, 0.4)
    P = stand(0.17, 8)
    P["hips"] = (0, 0.17, -0.13); P["hips_rot"] = (66, 0, 0); P["neck"] = (NECK_UP[0] - 14, 0, 0)
    P["footL"]["pole"] = (0.1, -1, 0); P["footR"]["pole"] = (-0.1, -1, 0)
    pz = ctx["poser"]
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
    Rc = posed["spine01"].to_3x3() @ pz.rest["spine01"].to_3x3().inverted()
    down_c = Rc.inverted() @ Vector((0, 0, -1))            # world-down in chest coordinates
    b0 = math.degrees(math.atan2(-down_c.y, -down_c.z))     # hanging forearm angle (chest frame)
    for s, sg in SIDES:
        b = math.radians(lerp(b0 - 4, -6, d))
        la, lb = pz.arm_len[s]
        shc = pz.J["shoulder" + s]                            # rest coords == chest space
        elbow = shc + Vector((0, math.sin(math.radians(22)), -math.cos(math.radians(22)))) * la * 0.995
        fdir = Vector((0, -math.sin(b), -math.cos(b)))
        hand = elbow + fdir * lb * 0.995
        fd_w = (Rc @ fdir).normalized()
        P["hand" + s] = dict(pos=tuple(hand), space="chest", pole=tuple(Rc @ Vector((sg * 0.1, 1, 0.1))),
                             aim=(tuple(fd_w), tuple(Rc @ Vector((-sg, 0, 0)))), shrug=2)
    P["grip"] = 0.95
    return P


@motion("fly", cam=CAM_BENCH, rep=3.0, extra=[dict(type="bench", loc=(0, 0.28, 0), length=1.3)], mat=False)
def m_fly(ph, rep, ctx, eq):
    P = lib(EX.BenchPress).pose(0.0, 0, ctx)
    d = cycle(ph, 0.42, 0.1, 0.38)
    for s, sg in SIDES:
        a = math.radians(lerp(8, 78, d))
        sh = Vector((sg * 0.20, 0.62, 0.605))
        hand = sh + Vector((sg * math.sin(a), -0.05, math.cos(a))) * 0.585      # arms softly bent (~25-30 deg)
        P["hand" + s] = dict(palm=tuple(hand), pole=(0, -0.4, -1) if False else (0, -0.3, -1),
                             aim=((0, 0.5, 0.86), (-sg * math.cos(a), 0, math.sin(a) * 0.3)), shrug=0)
    return P


@motion("flyCable", rep=3.0, anchor="high_wide")
def m_flycable(ph, rep, ctx, eq):
    d = cycle(ph, 0.38, 0.12, 0.40)
    P = stand(0.17, 8)
    P["footL"] = foot(0.15, -0.20, 8, side="L"); P["footR"] = foot(-0.15, 0.15, 8, heel=20, side="R")
    P["hips_rot"] = (14, 0, 0)
    for s, sg in SIDES:
        a = math.radians(lerp(80, 10, d))
        hand = Vector((sg * (0.05 + 0.55 * math.sin(a)), -0.42 * math.cos(a) - 0.12, 1.22 + 0.10 * math.sin(a)))
        shc = Vector((sg * 0.20, -0.01, 1.44))
        hand = shc + (hand - shc).normalized() * 0.535          # arms softly bent (~25-30 deg) like a dumbbell fly
        P["hand" + s] = dict(pos=tuple(hand), space="chest", pole=(sg * 0.3, 0.6, -1), aim=((0, -0.7, -0.7), (-sg, 0, 0)))
    P["grip"] = 0.9
    return P


@motion("pullover", cam=CAM_BENCH, rep=3.2, extra=[dict(type="bench", loc=(0, 0.28, 0), length=1.3)], mat=False)
def m_pullover(ph, rep, ctx, eq):
    P = lib(EX.BenchPress).pose(0.0, 0, ctx)
    d = cycle(ph, 0.42, 0.1, 0.38)
    for s, sg in SIDES:
        a = math.radians(lerp(5, 105, d))
        sh = Vector((sg * 0.18, 0.62, 0.605))
        hand = sh + Vector((-sg * 0.22, math.sin(a), math.cos(a))) * 0.50     # both hands on one dumbbell
        P["hand" + s] = dict(palm=tuple(hand), pole=(sg * 1, 0, -0.3), aim=((0, math.sin(a), math.cos(a)), (-sg, 0, 0)),
                             shrug=lerp(0, 15, d))
    P["grip"] = 0.9
    return P


@motion("frontRaise", rep=2.6)
def m_frontraise(ph, rep, ctx, eq):
    d = cycle(ph, 0.4, 0.1, 0.4)
    P = stand(0.15, 8)
    for s, sg in SIDES:
        f = lerp(8, 88, d)
        hand = hand_arc(SH(sg), sg, 8, f)
        r = math.radians(f)
        # overhand grip: palms face the thighs at the bottom and the floor at the top
        P["hand" + s] = dict(pos=hand, pole=(sg * 1, 0.4, 0.1), aim=((0, -math.sin(r), -math.cos(r)), (0, math.cos(r), -math.sin(r))),
                             shrug=3 * d)
    P["grip"] = 0.95
    return P


@motion("lateral", cam="front", rep=2.8)
def m_lateral(ph, rep, ctx, eq):
    return lib(EX.LateralRaise).pose(ph, rep, ctx)


@motion("uprightRow", cam="front", rep=2.6)
def m_uprightrow(ph, rep, ctx, eq):
    d = cycle(ph, 0.38, 0.12, 0.4)
    P = stand(0.15, 8)
    for s, sg in SIDES:
        z = lerp(0.92, 1.40, d)          # top: hands at the collarbones, elbows lead to shoulder height
        P["hand" + s] = dict(pos=(sg * lerp(0.14, 0.13, d), -0.12 - 0.03 * d, z), pole=(sg * 1, 0.2, lerp(-0.3, 0.9, d)),
                             aim=((0, 0, -1), (0, 1, 0)), shrug=lerp(2, 14, d))
    P["grip"] = 0.95
    return P


@motion("wallSlide", cam="front34", rep=3.0, extra=[dict(type="box", loc=(0, 0.25, 1.1), size=(1.3, 0.12, 2.2))])
def m_wallslide(ph, rep, ctx, eq):
    """back, elbows and backs of the hands against the wall, arms slide from 'W' up to 'Y'."""
    d = cycle(ph, 0.4, 0.1, 0.4)
    P = stand(0.15, 8)
    P["hips"] = (0, 0.03, 0)
    for s, sg in SIDES:
        hand = Vector((sg * lerp(0.44, 0.26, d), 0.10, lerp(1.68, 2.02, d)))
        P["hand" + s] = dict(pos=tuple(hand), pole=(sg * 1, 1.0, -0.3), aim=((0, 0, 1), (0, -1, 0)), shrug=lerp(4, 12, d))
    P["grip"] = 0.0
    return P


# ============================================================================ pull
@motion("pullup", cam=CAM_HANG, rep=3.2, extra=[dict(type="rack"), dict(type="pullbar", z=2.32)], mat=False)
def m_pullup(ph, rep, ctx, eq):
    if eq in ("machine", "cable", "band"):          # lat pulldown, seated
        pz = ctx["poser"]
        d = cycle(ph, 0.38, 0.12, 0.40)
        P = seated_box(pz, lean=-8 - 6 * d, seat_z=0.48)
        posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
        for s, sg in SIDES:
            # top: arms straight up on a wide grip (shoulders elevated); bottom: bar to the upper chest,
            # elbows driven down and slightly back (~120 deg)
            shj = posed[f"upperarm01.{s}"].translation
            top = Vector((sg * 0.42, shj.y - 0.02, 0))
            dxy = (Vector((top.x, top.y, shj.z)) - shj).length
            top.z = shj.z + 0.05 + math.sqrt(max(0.0, PALM_REACH ** 2 - dxy ** 2))
            bottom = Vector((sg * 0.34, shj.y - 0.14, shj.z + 0.10))
            pos = top.lerp(bottom, d)
            P["hand" + s] = dict(palm=tuple(pos), pole=(sg * 1, 0.4, -0.6), aim=((0, 0.2, 1), (0, -1, 0.2)), shrug=lerp(18, -4, d))
        P["grip"] = 1.0
        return P
    return lib(EX.PullUp).pose(ph, rep, ctx)


@motion("hang", cam=CAM_HANG, rep=3.0, extra=[dict(type="rack"), dict(type="pullbar", z=2.32)], mat=False)
def m_hang(ph, rep, ctx, eq):
    P = lib(EX.PullUp).pose(0.0, 0, ctx)
    b = 0.5 + 0.5 * math.sin(2 * math.pi * ph)
    for s in "LR":
        P["hand" + s]["shrug"] = lerp(22, 8, b)      # scapular pulls
    return P


@motion("row", cam=CAM_SIDE, rep=2.8, anchor=(0, -1.15, 0.95))
def m_row(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.35, 0.15, 0.40)
    if eq in ("cable", "machine", "band", "cardio", "pool"):     # seated row
        P = seated_floor(pz, lean=lerp(-12, 8, 1 - d), hip_y=0.25)
        for s, sg in SIDES:
            P["foot" + s] = dict(pos=(sg * 0.13, -0.55, 0.16), rot=(-55, 0, 0), pole=(sg * 0.3, -0.4, 1))
        sh = shoulders(ctx, P)
        for s, sg in SIDES:
            far = Vector(clamp_reach(sh[s], (sg * 0.07, -0.66, 0.60), PALM_REACH - 0.01))
            pos = far.lerp(Vector((sg * 0.12, -0.02, 0.60)), d)
            P["hand" + s] = dict(palm=tuple(pos), pole=(sg * 0.35, 0.8, -1), aim=((0, -1, 0), (-sg, 0, 0)),
                                 shrug=lerp(8, -2, d))
        P["grip"] = 1.0
        return P
    if eq in ("bar", "sling"):                                   # inverted row
        # body stays one straight line pivoting around the heels; bottom: hanging on straight arms under
        # the bar, top: chest to the bar (shoulders travel on an arc around the heels)
        sh_mid = (pz.J["shoulderL"] + pz.J["shoulderR"]) / 2
        ank_mid = (pz.J["ankleL"] + pz.J["ankleR"]) / 2
        Lb = (sh_mid - ank_mid).length * 0.985
        z0 = 1.05 - PALM_REACH - 0.055          # anchor is the shoulder-blade point, joints sit ~5 cm higher
        az = 0.085
        ank_y = -math.sqrt(Lb * Lb - (z0 - az) ** 2)              # shoulders right under the bar at the bottom
        z = lerp(z0, 0.80, d)
        inc = math.asin((z - az) / Lb)
        y = ank_y + math.cos(inc) * Lb
        P = supine(pz, theta=-90 + math.degrees(inc), anchor=(0, y, z), pivot="shoulders")
        P["spine"] = (0, 0, 0)
        for s, sg in SIDES:
            body_dir = Vector((0, -math.cos(inc), -math.sin(inc)))
            ank = leg_to(ctx, P, s, body_dir + Vector((sg * 0.02, 0, 0)), 0.99)
            P["foot" + s] = dict(pos=tuple(ank), rot=(-90 + math.degrees(inc) + 25, 0, 0), pole=(0, 0, 1))
            P["hand" + s] = dict(palm=(sg * 0.32, -0.02, 1.05), pole=(sg * 1, 0, -0.3), aim=((0, 0, 1), (0, -1, 0)))   # overhand
        P["grip"] = 1.0
        return P
    # bent-over row (barbell / dumbbell / kettlebell / outdoor)
    P = stand(0.17, 10)
    P["hips"] = (0, 0.18, -0.16); P["hips_rot"] = (48, 0, 0); P["spine"] = (-4, 0, 0)
    P["neck"] = (NECK_UP[0] - 10, 0, 0)
    P["footL"]["pole"] = (0.15, -1, 0); P["footR"]["pole"] = (-0.15, -1, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(hang=lerp(0.97, 0.55, d), offset=(sg * 0.02, 0.10 * d, 0), pole=(sg * 0.3, 1, 0.3),
                             aim=((0, 0.2 * d, -1), (0, 1, 0) if eq == "barbell" else (-sg, 0, 0)), shrug=lerp(-2, 6, d))
    P["grip"] = 0.95
    return P


@motion("facePull", cam=CAM_SIDE, rep=2.8, anchor=(0, -1.0, 1.70))
def m_facepull(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.15, 0.40)
    P = stand(0.18, 8)
    P["hips_rot"] = (-4, 0, 0)
    for s, sg in SIDES:
        # end position: elbows out at shoulder height, hands beside the ears (upper arm ~90 deg abducted)
        pos = lerp((sg * 0.05, -0.62, 1.56), (sg * 0.27, -0.10, 1.64), d)
        P["hand" + s] = dict(pos=pos, space="chest", pole=(sg * 1, 0.25, lerp(0.0, 0.15, d)), aim=((0, -1, 0), (-sg, 0, 0)), shrug=4)
    P["grip"] = 1.0
    return P


def sling_curl(ph, ctx):
    """suspension-trainer curl: body leans back from the ankles, arms point at the anchor,
    curling pulls the body up (lean decreases) while the hands travel to the forehead."""
    pz = ctx["poser"]
    d = cycle(ph, 0.4, 0.1, 0.42)
    lean = lerp(-27, -12, d)
    q = rotx(lean)
    ank = (pz.J["ankleL"] + pz.J["ankleR"]) / 2
    P = stand(0.15, 6)
    P["hips_rot"] = (lean, 0, 0)
    P["hips"] = rigid_pivot(pz, ank, Vector((0, -0.01, 0.075)), q)
    la, lb = pz.arm_len["L"]
    a = math.radians(lerp(8, 118, d))
    for s, sg in SIDES:
        sh = Vector((sg * 0.20, -0.02, 1.47))
        up = Vector((sg * 0.05, -0.97, 0.22)).normalized()
        elbow = sh + up * la
        fdir = Vector((0, -math.cos(a), math.sin(a)))
        n = Vector((0, math.sin(a), math.cos(a)))
        P["hand" + s] = dict(pos=tuple(elbow + fdir * lb), space="chest", pole=(sg * 0.6, 0.2, -1),
                             aim=(tuple(q @ fdir), tuple(q @ n)), shrug=4)
    P["grip"] = 0.95
    return P


class _BarCurl(EX.BicepCurl):
    top = 122            # a straight bar stops at the chest (wrists can't supinate further)


@motion("curl", cam="front34_close", rep=2.6, reps=3, anchor="feet")
def m_curl(ph, rep, ctx, eq):
    if eq == "sling":
        return sling_curl(ph, ctx)
    P = lib(_BarCurl if eq in ("barbell", "machine") else EX.BicepCurl).pose(ph, rep, ctx)
    if eq in ("barbell", "machine"):
        for s, sg in SIDES:
            P["hand" + s]["pos"] = (sg * 0.2, P["hand" + s]["pos"][1], P["hand" + s]["pos"][2])
    return P


@motion("farmer", cam=CAM_SIDE, rep=1.2, reps=5)
def m_farmer(ph, rep, ctx, eq):
    P = gait(ph, stride=0.22, lift=0.07, bounce=0.012, arm=0)
    hold_hands(P, eq if eq != "barbell" else "dumbbell", width=0.26, z=0.86)
    return P


@motion("idle", rep=3.0)
def m_idle(ph, rep, ctx, eq):
    P = stand(0.15, 8)
    P["hips"] = (0, 0, breathe(ph, 0.006))
    hold_hands(P, eq, width=0.25, z=0.87)
    return P


# ============================================================================ core
@motion("crunch", cam=CAM_FLOOR, rep=2.4, reps=3, collide=dict(hands=False))
def m_crunch(ph, rep, ctx, eq):
    P = lib(EX.Crunch).pose(ph, rep, ctx)
    if eq in ("medball", "dumbbell", "kettlebell"):
        for s, sg in SIDES:
            P["hand" + s] = dict(pos=(sg * 0.07, -0.20, 1.32), space="chest", pole=(sg * 1, 0.2, -0.6),
                                 aim=((0, -0.2, 1), (-sg, 0, 0)))
        P["grip"] = 0.6
    return P


@motion("plank", cam=EX.PushUp.cam, rep=3.0)
def m_plank(ph, rep, ctx, eq):
    pz = ctx["poser"]
    theta = 80.0
    q = rotx(theta)
    ank = (pz.J["ankleL"] + pz.J["ankleR"]) / 2
    anchor = Vector((0, 0.45, foot(0, 0, heel=72)["pos"][2] + breathe(ph, 0.006)))
    P = dict(hips_rot=(theta, 0, 0), hips=rigid_pivot(pz, ank, anchor, q), neck=(NECK_UP[0] - 22, 0, 0),
             head=(-12, 0, 0), spine=(-2, 0, 0))
    root = pz.J["root"]
    for s, sg in SIDES:
        a = anchor + q @ (pz.J["ankle" + s] - ank) * 0.62
        P["foot" + s] = dict(pos=tuple(a), rot=(theta - 8, 0, 0), pole=(0, 0, -1))
        shw = root + Vector(P["hips"]) + q @ (pz.J["shoulder" + s] - root)
        P["hand" + s] = dict(pos=(sg * 0.13, shw.y - 0.27, 0.06), pole=(sg * 0.2, 0.2, -1),
                             aim=((sg * 0.2, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.4
    return P


@motion("hollowHold", cam=CAM_FLOOR, rep=2.4, reps=3)
def m_hollow(ph, rep, ctx, eq):
    pz = ctx["poser"]
    r = 0.5 + 0.5 * math.sin(2 * math.pi * ph)
    P = supine(pz, theta=-90 + 4 * r, anchor=(0, 0.1, 0.11), pivot="hips")
    P["spine"] = (24, 0, 0); P["neck"] = (NECK_UP[0] + 24, 0, 0)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.07, -0.70, 0.36 + 0.03 * r), rot=(-70, 0, 0), pole=(0, 0, 1))
        # arms reach overhead beside the ears (~165 deg flexion - not behind the head), palms facing each other
        P["hand" + s] = dict(pos=(sg * 0.15, -0.10, 2.0), space="chest", pole=(sg * 0.3, 1, 0), aim=((0, 0, 1), (-sg, 0, 0)))
    P["grip"] = 0.1
    EX.straight_wrist(pz, P)
    return P


@motion("deadBug", cam=CAM_FLOOR, rep=3.0, reps=2)
def m_deadbug(ph, rep, ctx, eq):
    pz = ctx["poser"]
    side = 1 if (rep % 2 == 0) else -1
    d = cycle(ph, 0.4, 0.15, 0.35)
    P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
    for s, sg in SIDES:
        ext = d if sg == side else 0.0                 # extend this leg
        P["foot" + s] = dict(pos=(sg * 0.13, lerp(-0.32, -0.80, ext), lerp(0.52, 0.14, ext)),
                             rot=(lerp(-10, -70, ext), 0, 0), pole=(sg * 0.1, 0, 1))
        arm_ext = d if sg == -side else 0.0           # opposite arm reaches overhead
        P["hand" + s] = dict(pos=(sg * 0.2, lerp(-0.45, 0.20, arm_ext), lerp(1.40, 2.0, arm_ext)), space="chest",
                             pole=(sg, 0.2, 0), aim=((0, 0, 1), (-sg, 0, 0)))
    P["grip"] = 0.2
    return P


@motion("legRaise", cam=CAM_HANG, rep=3.0, extra=[dict(type="rack", height=2.55), dict(type="pullbar", z=2.46)], mat=False)
def m_legraise(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.4, 0.12, 0.38)
    if eq in ("none", "machine"):                      # lying leg raise
        P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
        for s, sg in SIDES:
            a = math.radians(lerp(5, 88, d))
            hip = Vector((sg * 0.1, 0.1, 0.11))
            ank = hip + Vector((0, -math.cos(a), math.sin(a))) * 0.86
            P["foot" + s] = dict(pos=(sg * 0.08, ank.y, max(0.07, ank.z)), rot=(-90 + lerp(10, 85, d), 0, 0), pole=(0, -1, 0))
            P["hand" + s] = dict(pos=(sg * 0.25, 0.0, 0.05), pole=(sg, 0, 0.3), aim=((0, -1, 0), (0, 0, -1)))
        return P
    P = lib(EX.PullUp).pose(0.0, 0, ctx)
    # hang 14 cm higher (bar at 2.46) so the straight legs swing freely above the floor
    P["hips"] = (P["hips"][0], P["hips"][1], P["hips"][2] + 0.14)
    for s in "LR":
        h = dict(P["hand" + s])
        for k in ("pos", "palm"):
            if k in h:
                h[k] = (h[k][0], h[k][1], h[k][2] + 0.14)
        P["hand" + s] = h
    a = math.radians(lerp(0, 88, d))
    for s, sg in SIDES:
        hipw = Vector((sg * 0.1, 0.05, 0.97 + P["hips"][2]))
        ank = hipw + Vector((0, -math.sin(a), -math.cos(a))) * 0.86
        P["foot" + s] = dict(pos=tuple(ank), rot=(-math.degrees(a) - 10, 0, 0), pole=(0, -1, 0))
    P["hips_rot"] = (-8 - 10 * d, 0, 0)
    return P


@motion("kneeRaise", cam=EX.PushUp.cam, rep=1.0, reps=5)
def m_kneeraise(ph, rep, ctx, eq):
    if eq in ("bike", "cardio", "pool", "outdoor"):
        return gait(ph, stride=0.3, lift=0.25, bounce=0.03, arm=1.0, lean=6)
    P = lib(EX.PushUp).pose(0.0, 0, ctx)              # mountain climber from a high plank
    pz = ctx["poser"]
    for s, sg in SIDES:
        drive = max(0.0, math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi)))
        f = P["foot" + s]
        x, y, z = f["pos"]
        f["pos"] = (x, y - 0.60 * drive, z + 0.03 * drive)
        f["rot"] = (f["rot"][0] - 30 * drive, 0, 0)
        f["pole"] = (0, -1, -0.5)
    # hips lift a little with every knee drive (otherwise the driving thigh would scrape the floor)
    lift = max(math.sin(2 * math.pi * ph), math.sin(2 * math.pi * ph + math.pi), 0.0)
    # pivot around the hands: pitch the body a few degrees (hips up, shoulders stay over the hands)
    pz_ = ctx["poser"]
    th = P["hips_rot"][0] + 7.0 * lift
    q = rotx(th)
    shm = (pz_.J["shoulderL"] + pz_.J["shoulderR"]) / 2
    q0 = rotx(P["hips_rot"][0])
    root = pz_.J["root"]
    sh_world = root + Vector(P["hips"]) + q0 @ (shm - root)
    P["hips_rot"] = (th, 0, 0)
    P["hips"] = rigid_pivot(pz_, shm, sh_world, q)
    return P


# ============================================================================ cardio
def gait(ph, stride=0.25, lift=0.12, bounce=0.02, arm=1.0, lean=4):
    """Running / walking on the spot (treadmill style), one cycle per phase."""
    P = dict(neck=NECK_UP, head=HEAD_UP)
    P["hips"] = (0, 0, -0.03 + bounce * abs(math.sin(2 * math.pi * ph)))
    P["hips_rot"] = (lean, 0, 3 * math.sin(2 * math.pi * ph))
    P["spine"] = (0, 0, -8 * math.sin(2 * math.pi * ph) * arm)
    for s, sg in SIDES:
        a = 2 * math.pi * ph + (0 if s == "L" else math.pi)
        y = -stride * math.sin(a)
        z = lift * max(0.0, -math.cos(a)) ** 1.2
        heel = 25 * max(0.0, math.sin(a + 0.5)) if lift > 0.1 else 10 * max(0.0, math.sin(a))
        f = foot(sg * 0.11, y, 6, heel=heel, side=s, lift=z)
        f["pole"] = (sg * 0.1, -1, 0)
        P["foot" + s] = f
        b = -math.sin(a) * arm                       # arms opposite to legs
        P["hand" + s] = dict(pos=(sg * 0.22, -0.12 - 0.22 * b, 1.08 + 0.10 * max(0, b)), space="root",
                             pole=(sg * 0.3, 1, -0.2), aim=((0, -0.6, 0.8), (-sg, 0, 0)))
    P["grip"] = 0.5
    return P


@motion("run", cam=CAM_SIDE, rep=0.72, reps=8, intro=0.3)
def m_run(ph, rep, ctx, eq):
    return gait(ph, stride=0.30, lift=0.22, bounce=0.04, arm=1.0, lean=7)


@motion("walk", cam=CAM_SIDE, rep=1.1, reps=6, intro=0.3)
def m_walk(ph, rep, ctx, eq):
    P = gait(ph, stride=0.24, lift=0.06, bounce=0.012, arm=0.5, lean=2)
    for s, sg in SIDES:
        a = 2 * math.pi * ph + (0 if s == "L" else math.pi)
        b = -math.sin(a) * 0.6
        P["hand" + s] = dict(pos=(sg * 0.24, -0.25 * b, 0.88), space="root", pole=(sg * 0.2, 1, 0))
    P["grip"] = 0.2
    return P


@motion("jumpRope", cam="front", rep=0.55, reps=8, intro=0.3, extra=[dict(type="rope")])
def m_jumprope(ph, rep, ctx, eq):
    air = math.sin(math.pi * ph) ** 2
    P = stand(0.10, 6)
    jump = 0.06 * air
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.10, -0.01, 6, heel=20 + 15 * air, side=s, lift=jump)
        P["hand" + s] = dict(pos=(sg * 0.32, -0.08, 1.02 + jump), pole=(sg * 0.4, 1, -0.2),
                             aim=((sg * 0.5, -0.3, -0.8), (-sg, 0, 0)))
    P["hips"] = (0, 0, jump - 0.02 * (1 - air))
    P["grip"] = 0.9
    P["_rope_phase"] = ph
    return P


# ============================================================================ mobility / stretches
@motion("childPose", cam=EX.CatCow.cam, rep=4.4)
def m_child(ph, rep, ctx, eq):
    return lib(EX.ChildPoseRock).pose(ph, rep, ctx)


@motion("catCow", cam=EX.CatCow.cam, rep=4.0)
def m_catcow(ph, rep, ctx, eq):
    return lib(EX.CatCow).pose(ph, rep, ctx)


@motion("downDog", cam=EX.DownDogPedal.cam, rep=2.4, reps=3)
def m_downdog(ph, rep, ctx, eq):
    return lib(EX.DownDogPedal).pose(ph, rep, ctx)


@motion("forwardFold", cam=CAM_SIDE, rep=4.0)
def m_fold(ph, rep, ctx, eq):
    return lib(EX.ToeTouch).pose(ph, rep, ctx)


@motion("cobra", cam=EX.Cobra.cam, rep=4.0)
def m_cobra(ph, rep, ctx, eq):
    return lib(EX.Cobra).pose(ph, rep, ctx)


@motion("sideBend", cam="front", rep=3.6)
def m_sidebend(ph, rep, ctx, eq):
    return lib(EX.SideBend).pose(ph, rep, ctx)


@motion("hipStretch", cam=EX.HipFlexorStretch.cam, rep=4.0)
def m_hipstretch(ph, rep, ctx, eq):
    return lib(EX.HipFlexorStretch).pose(ph, rep, ctx)


@motion("neckTilt", cam="front34_close", rep=4.0)
def m_necktilt(ph, rep, ctx, eq):
    P = stand(0.16, 8)
    t = osc(ph)
    P["neck"] = (NECK_UP[0], 0, 28 * t); P["head"] = (HEAD_UP[0], 0, 10 * t)
    side = "R" if t > 0 else "L"
    arms_down(P, 0.26, 0.87)
    return P


@motion("bwsRotate", cam="front", rep=4.0)
def m_windmill(ph, rep, ctx, eq):
    d = cycle(ph, 0.45, 0.15, 0.35)
    P = stand(0.26, 20)
    P["hips"] = (-0.10 * d, 0.10 * d, -0.06 * d)
    P["hips_rot"] = (40 * d, 0, 25 * d)
    P["spine"] = (10 * d, 20 * d, 30 * d)      # (bend, side, twist)
    P["neck"] = (NECK_UP[0] - 20 * d, 30 * d, 0)
    P["handL"] = dict(pos=(0.20, -0.02, 2.05), space="chest", pole=(1, 0.2, -0.2), aim=((0, 0, 1), (0, -1, 0)), shrug=10)
    P["handR"] = dict(hang=lerp(0.97, 0.95, d), pole=(-0.2, 1, 0))
    P["grip"] = 0.9
    return P


@motion("crossBody", cam="front", rep=4.0)
def m_crossbody(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.3, 0.3)
    P = stand(0.16, 8)
    P["handR"] = dict(pos=(lerp(-0.30, 0.18, d), -0.25, 1.38), space="chest", pole=(-0.2, -1, -0.3),
                      aim=((1, -0.2, 0), (0, -1, 0)))
    P["handL"] = dict(pos=(lerp(0.30, 0.03, d), -0.30, 1.20), space="chest", pole=(1, 0.4, -0.4),
                      aim=((-0.3, 0, 1), (0, 1, 0)))
    P["grip"] = 0.3
    return P


@motion("tricepStretch", cam="front", rep=4.0)
def m_tristretch(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.3, 0.3)
    P = stand(0.16, 8)
    P["handR"] = dict(pos=(-0.02, 0.10, lerp(2.0, 1.62, d)), space="chest", pole=(-0.3, -1, 1),
                      aim=((0, 0.2, -1), (1, 0, 0)), shrug=12)
    P["handL"] = dict(pos=(0.02, -0.02, lerp(1.95, 1.85, d)), space="chest", pole=(1, -0.6, 0.6),
                      aim=((-1, 0.2, 0.3), (0, 0, -1)), shrug=10)
    P["grip"] = 0.2
    return P


@motion("chestStretch", cam=CAM_SIDE, rep=4.0)
def m_cheststretch(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.3, 0.3)
    P = stand(0.17, 8)
    P["spine"] = (-6 * d, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * lerp(0.12, 0.06, d), lerp(0.16, 0.34, d), lerp(0.95, 1.05, d)), space="root",
                             pole=(sg * 1, -0.2, -0.3), aim=((0, 0.3, -1), (-sg, 0, 0)), shrug=-4)
    P["grip"] = 0.3
    return P


@motion("quadStretch", cam=CAM_SIDE, rep=4.0)
def m_quadstretch(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.35, 0.25)
    P = stand(0.10, 6)
    P["hips"] = (0.04, 0, 0)
    P["hips_rot"] = (4 * d, 0, 0)
    P["footR"] = dict(pos=(-0.11, lerp(0.0, 0.17, d), lerp(0.074, 0.90, d)), rot=(lerp(0, 165, d), 0, 0),
                      pole=(0, lerp(-1, 0.2, d), lerp(0, -1, d)))
    P["handR"] = dict(pos=(-0.15, lerp(0.02, 0.24, d), lerp(0.86, 0.98, d)), pole=(-0.4, 1, 0),
                      aim=((0, lerp(0, 0.4, d), -1), (1, 0, 0)))
    P["handL"] = dict(pos=(0.24, -0.02, 1.02), space="root", pole=(1, 0.3, 0), aim=((0, -1, -0.3), (-1, 0, 0)))
    P["grip"] = 0.9
    return P


WALL = dict(type="box", loc=(0, -0.80, 1.1), size=(1.1, 0.14, 2.2))      # wall surface at y = -0.73
CAM_WALL = ((3.3, -0.9, 1.35), (3.0, -0.7, 1.25), (0, -0.25, 0.85), (0, -0.25, 0.82), 38)


@motion("calfWall", cam=CAM_WALL, rep=4.0, extra=[WALL])
def m_calfwall(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.35, 0.25)
    P = stand(0.12, 6)
    P["footL"] = foot(0.12, -0.36, 6, side="L"); P["footL"]["pole"] = (0.1, -1, 0)
    P["footR"] = foot(-0.12, 0.24, 6, side="R")
    P["hips"] = (0, -0.06 - 0.10 * d, -0.03 - 0.03 * d)
    P["hips_rot"] = (10 + 8 * d, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.24, -0.715, 1.42 - 0.03 * d), pole=(sg * 0.6, 1, -0.6),
                             aim=((0, 0, 1), (0, -1, 0)))
    P["grip"] = 0.0
    return P


@motion("kneeWall", cam=CAM_WALL, rep=3.0, extra=[dict(WALL, loc=(0, -0.71, 1.1))])
def m_kneewall(ph, rep, ctx, eq):
    """half-kneeling ankle mobilisation: front knee drives towards the wall, hands on the wall."""
    d = cycle(ph, 0.4, 0.15, 0.35)
    P = dict(neck=NECK_UP, head=HEAD_UP)
    P["hips"] = (0.0, -0.05 - 0.08 * d, -0.455)
    P["hips_rot"] = (4 + 3 * d, 0, 0)
    P["footL"] = foot(0.14, -0.44, 6, side="L"); P["footL"]["pole"] = (0.1, -1, 0)
    P["footR"] = dict(pos=(-0.12, 0.38, 0.06), rot=(172, 0, 0), pole=(0, -1, -0.2))
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.22, -0.625, 0.92), pole=(sg * 0.7, 1, -0.4),
                             aim=((0, 0, 1), (0, -1, 0)))
    P["grip"] = 0.0
    return P


@motion("wristRock", cam=CAM_FLOOR, rep=2.6)
def m_wristrock(ph, rep, ctx, eq):
    pz = ctx["poser"]
    r = osc(ph)
    P = quadruped(pz, theta=81 + 5 * r, hip=(0, 0.2 - 0.06 * r, 0.51))
    return P


@motion("sitFold", cam=CAM_FLOOR, rep=4.0)
def m_sitfold(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.4, 0.25, 0.3)
    P = seated_floor(pz, lean=lerp(0, 28, d))
    P["spine"] = (30 * d, 0, 0); P["neck"] = (NECK_UP[0] + 20 * d, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.16, lerp(-0.25, -0.62, d), lerp(0.45, 0.16, d)), pole=(sg, 0.3, 0.3),
                             aim=((0, -1, -0.2), (0, 0, -1)))
    P["grip"] = 0.1
    return P


@motion("supKneeHug", cam=CAM_FLOOR, rep=4.0)
def m_kneehug(ph, rep, ctx, eq):
    """lying on the back, knees pulled to the chest, hands wrapped round the shins below the knees."""
    pz = ctx["poser"]
    d = cycle(ph, 0.35, 0.35, 0.25)
    P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
    P["spine"] = (10 * d, 0, 0)
    P["neck"] = (P["neck"][0] + 10 * d, 0, 0)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.13, lerp(-0.34, -0.02, d), lerp(0.52, 0.30, d)), rot=(lerp(-10, -40, d), 0, 0),
                             pole=(sg * 0.15, 0.6, 1))
    sh = shoulders(ctx, P)
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
    for s, sg in SIDES:
        knee = posed[f"lowerleg01.{s}"].translation; ank = posed[f"foot.{s}"].translation
        g = grab_on(sh[s], knee + Vector((sg * 0.02, 0, 0.06)), ank + Vector((sg * 0.02, 0, 0.06)), prefer=0.25)
        P["hand" + s] = dict(pos=g, pole=(sg, 0.3, 0.6), aim=(tuple((ank - knee).normalized()), (-sg, 0, 0)))
    P["grip"] = 0.85
    return P


@motion("supTwist", cam=CAM_FLOOR, rep=4.0)
def m_suptwist(ph, rep, ctx, eq):
    pz = ctx["poser"]
    t = osc(ph)
    P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
    P["hips_rot"] = (-90, 30 * t, 0)
    P["spine"] = (0, 0, -26 * t)          # pelvis turns with the knees, the chest stays flat on the mat
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.10 + 0.35 * t, -0.42, 0.10 + 0.08 * (1 - abs(t))), rot=(-10, 60 * t, 0),
                             pole=(0.8 * t, -0.3, 1))
        # arms out in a T on the floor, palms up (elbow points into the mat)
        P["hand" + s] = dict(pos=(sg * 0.70, 0.40, 0.05), pole=(0, 0, -1), aim=((sg, 0, 0), (0, 0, 1)))
    P["grip"] = 0.0
    return P


@motion("supineHam", cam=CAM_FLOOR, rep=4.0)
def m_supineham(ph, rep, ctx, eq):
    """lying hamstring stretch: one straight leg raised, hands pull behind the thigh / calf."""
    pz = ctx["poser"]
    d = cycle(ph, 0.35, 0.35, 0.25)
    P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
    P["neck"] = (P["neck"][0] + 8 * d, 0, 0)
    a = math.radians(lerp(50, 82, d))
    hip = Vector((0.1, 0.1, 0.11))
    ank = hip + Vector((0, -math.cos(a), math.sin(a))) * 0.86
    P["footL"] = dict(pos=tuple(ank), rot=(-90 + math.degrees(a), 0, 0), pole=(0, -1, 0))
    P["footR"] = dict(pos=(-0.11, -0.76, 0.07), rot=(-75, 0, 0), pole=(0, 0, 1))
    sh = shoulders(ctx, P)
    for s, sg in SIDES:
        back = Vector((0.1 + sg * 0.065, 0.04, 0.0))        # behind the leg (towards the head)
        g = grab_on(sh[s], hip + back + (ank - hip) * 0.35, hip + back + (ank - hip) * 0.85, prefer=0.5)
        P["hand" + s] = dict(pos=g, pole=(sg, 0, 0.4), aim=((0, -math.cos(a), math.sin(a)), (-sg, 0, 0)))
    P["grip"] = 0.9
    return P


# ---------------------------------------------------------------- pilates
@motion("hundred", cam=CAM_FLOOR, rep=1.0, reps=5)
def m_hundred(ph, rep, ctx, eq):
    P = m_hollow(0.5, 0, ctx, eq)
    pump = math.sin(2 * math.pi * ph * 2) * 0.05
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.22, -0.30, 1.0 + pump), space="chest", pole=(sg, 0.3, 0), aim=((0, -1, 0), (0, 0, -1)))
    return P


@motion("rollUp", cam=CAM_FLOOR, rep=5.0)
def m_rollup(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.45, 0.1, 0.45)
    P = supine(pz, theta=lerp(-90, -10, d), anchor=(0, 0.1, 0.11), pivot="hips")
    P["spine"] = (lerp(0, 40, math.sin(math.pi * d)), 0, 0)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.10, -0.76, 0.07), rot=(-80, 0, 0), pole=(0, 0, 1))
        P["hand" + s] = dict(pos=(sg * 0.15, lerp(-0.10, -0.45, d), lerp(2.0, 1.40, d)), space="chest",
                             pole=(sg * lerp(0.3, 1, d), lerp(1, 0, d), 0.3), aim=((0, -d, 1 - d), (-sg, 0, 0)))
    P["grip"] = 0.1
    EX.straight_wrist(pz, P)
    return P


@motion("singleLegStretch", cam=CAM_FLOOR, rep=1.6, reps=4)
def m_sls(ph, rep, ctx, eq):
    P = m_hollow(0.5, 0, ctx, eq)
    for s, sg in SIDES:
        k = 0.5 + 0.5 * math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        P["foot" + s] = dict(pos=(sg * 0.10, lerp(-0.85, -0.12, k), lerp(0.30, 0.55, k)), rot=(lerp(-70, -20, k), 0, 0),
                             pole=(sg * 0.1, -0.5, 1))
    # both hands hold the bent leg: outer hand on the ankle, inner hand on the knee (Pilates technique)
    pz = ctx["poser"]
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
    bent = "L" if math.sin(2 * math.pi * ph) > 0 else "R"
    k = 0.5 + 0.5 * abs(math.sin(2 * math.pi * ph))
    sh = shoulders(ctx, P)
    knee = posed[f"lowerleg01.{bent}"].translation
    ank = posed[f"foot.{bent}"].translation
    sb = 1 if bent == "L" else -1
    for s, sg in SIDES:
        rest = Vector(sh[s]) + Vector((sg * 0.06, -0.42, 0.20))
        grab = (ank if s == bent else knee) + Vector((sg * 0.07, 0, 0.03))
        tgt = Vector(clamp_reach(sh[s], rest.lerp(grab, ss(min(1, (k - 0.5) * 2.2))), WRIST_REACH))
        P["hand" + s] = dict(pos=tuple(tgt), pole=(sg, 0.6, -0.2), aim=((0, -1, -0.3), (-sg, 0, 0)), shrug=6)
    return P


@motion("doubleLegStretch", cam=CAM_FLOOR, rep=2.6, reps=3)
def m_dls(ph, rep, ctx, eq):
    P = m_hollow(0.5, 0, ctx, eq)
    d = cycle(ph, 0.35, 0.15, 0.4)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.08, lerp(-0.15, -0.85, d), lerp(0.55, 0.32, d)), rot=(lerp(-20, -70, d), 0, 0),
                             pole=(sg * 0.1, -0.5, 1))
        P["hand" + s] = dict(pos=(sg * 0.15, lerp(-0.38, -0.10, d), lerp(1.10, 2.0, d)), space="chest",
                             pole=(sg * lerp(1, 0.3, d), lerp(0, 1, d), 0.3), aim=((0, 0, 1), (-sg, 0, 0)))
    EX.straight_wrist(ctx["poser"], P)
    return P


@motion("scissors", cam=CAM_FLOOR, rep=1.8, reps=4)
def m_scissors(ph, rep, ctx, eq):
    P = m_hollow(0.5, 0, ctx, eq)
    pz = ctx["poser"]
    for s, sg in SIDES:
        k = 0.5 + 0.5 * math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        a = math.radians(lerp(20, 85, k))
        hip = Vector((sg * 0.1, 0.1, 0.11))
        ank = hip + Vector((0, -math.cos(a), math.sin(a))) * 0.84
        P["foot" + s] = dict(pos=tuple(ank), rot=(-90 + math.degrees(a), 0, 0), pole=(0, -1, 0))
        P["hand" + s] = dict(pos=(sg * 0.12, -0.42, 1.25), space="chest", pole=(sg, 0.2, 0.3), aim=((0, -1, 0.3), (-sg, 0, 0)))
    return P


@motion("teaser", cam=CAM_FLOOR, rep=4.0)
def m_teaser(ph, rep, ctx, eq):
    """Pilates teaser: balance on the sit bones, straight legs and trunk form a V (~90-100 deg hip angle),
    arms reach parallel to the legs."""
    pz = ctx["poser"]
    d = cycle(ph, 0.4, 0.25, 0.35)
    return v_sit(pz, ctx, trunk=lerp(-80, -36, d), legs=lerp(18, 52, d), arms="legs")


def v_sit(pz, ctx, trunk=-36.0, legs=50.0, arms="legs", knee=0.0):
    """seated V balance. trunk = trunk tilt (hips_rot x, -90 = lying), legs = leg angle above the floor
    (deg), knee = knee bend for the half boat."""
    P = supine(pz, theta=trunk, anchor=(0, 0.1, 0.11), pivot="hips")
    P["spine"] = (10, 0, 0)
    P["neck"] = (NECK_UP[0] + 6, 0, 0); P["head"] = (HEAD_UP[0], 0, 0)
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith(("hand", "foot"))})
    a = math.radians(legs)
    u = Vector((0, -math.cos(a), math.sin(a)))
    up = Vector((0, math.sin(a), math.cos(a)))          # anterior side of the raised leg
    for s, sg in SIDES:
        hip = posed[f"upperleg01.{s}"].translation
        l1, l2 = pz.leg_len[s]
        if knee:
            kb = math.radians(knee)
            kn = hip + (u * math.cos(kb * 0.5) + up * math.sin(kb * 0.5)) * l1
            ank = kn + (u * math.cos(kb * 0.5) - up * math.sin(kb * 0.5)) * l2
        else:
            ank = hip + u * (l1 + l2) * 0.985
        ank = ank + Vector((-sg * 0.02, 0, 0))
        P["foot" + s] = dict(pos=tuple(ank), rot=(-(legs + 40 - knee * 0.5), 0, 0), pole=tuple(up))
        if arms == "legs":
            sh = posed[f"upperarm01.{s}"].translation
            tgt = sh + (u * 0.96 + Vector((0, 0, -0.18))).normalized() * WRIST_REACH
            P["hand" + s] = dict(pos=tuple(tgt), pole=(sg, 0.2, -0.3), aim=(tuple(u), (0, 0, -1)), shrug=4)
    P["grip"] = 0.1
    return P


@motion("swimming", cam=CAM_FLOOR, rep=1.2, reps=4)
def m_swimming(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = prone(pz)
    P["spine"] = (-14, 0, 0); P["neck"] = (NECK_UP[0] - 10, 0, 0)
    for s, sg in SIDES:
        k = math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        P["foot" + s] = dict(pos=(sg * 0.12, 1.16, 0.12 + 0.07 * max(0, -k)), rot=(170, 0, 0), pole=(0, 0, -1))
        P["hand" + s] = dict(pos=(sg * 0.22, -0.30, 2.05 + 0.08 * k), space="chest", pole=(sg, 0, -0.3), aim=((0, 0, 1), (0, 1, 0)))
    P["grip"] = 0.0
    return P


# ---------------------------------------------------------------- yoga holds
def _hold_stand(ph):
    P = stand(0.15, 8)
    P["hips"] = (0, 0, breathe(ph, 0.006))
    return P


@motion("warrior1", cam=CAM_SIDE, rep=4.0)
def m_warrior1(ph, rep, ctx, eq):
    P = lib(EX.Lunge).pose(0.47, 0, ctx)
    P["hips"] = (0, P["hips"][1], P["hips"][2] * 0.6)
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.10, -0.02, 2.05), space="chest", pole=(sg, 0.2, -0.3), aim=((0, 0, 1), (-sg, 0, 0)), shrug=12)
    return P


@motion("warrior2", cam="front", rep=4.0)
def m_warrior2(ph, rep, ctx, eq):
    P = stand(0.48, 0)
    b = breathe(ph, 0.01)
    P["footL"] = foot(0.48, -0.01, 85, side="L"); P["footL"]["knee_out"] = 0; P["footL"]["pole"] = (1, -0.2, 0)
    P["footR"] = foot(-0.48, -0.01, 10, side="R")
    P["hips"] = (0.12, 0, -0.26 + b); P["hips_rot"] = (0, 0, 0)
    P["neck"] = (NECK_UP[0], 50, 0)
    sh = shoulders(ctx, P)
    for s, sg in SIDES:
        # arms long at shoulder height, palms down
        P["hand" + s] = dict(pos=tuple(sh[s] + Vector((sg * 0.548, -0.01, 0.0))), pole=(0, 1, -0.2),
                             aim=((sg, 0, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.0
    return P


@motion("tree", cam="front", rep=4.0, collide=dict(legs=False))
def m_tree(ph, rep, ctx, eq):
    P = _hold_stand(ph)
    P["hips"] = (0.05, 0, P["hips"][2])
    P["footR"] = dict(pos=(0.02, 0.0, 0.55), rot=(0, -80, 0), pole=(-1, -0.2, 0))
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.035, -0.25, 1.32), space="chest", pole=(sg, 0.5, -1), aim=((0, 0, 1), (-sg, 0, 0)))
    P["grip"] = 0.0
    return P


@motion("chair", cam=CAM_SIDE, rep=4.0)
def m_chair(ph, rep, ctx, eq):
    P = stand(0.10, 4)
    P["hips"] = (0, 0.15, -0.30 + breathe(ph, 0.008)); P["hips_rot"] = (30, 0, 0); P["spine"] = (-8, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.12, -0.18, 2.0), space="chest", pole=(sg, 0.2, -0.3), aim=((0, -0.2, 1), (-sg, 0, 0)))
    P["grip"] = 0.0
    return P


@motion("boat", cam=CAM_FLOOR, rep=4.0)
def m_boat(ph, rep, ctx, eq):
    """boat pose (navasana): trunk ~55 deg off the floor, straight legs ~50 deg, arms forward parallel to the floor."""
    pz = ctx["poser"]
    P = v_sit(pz, ctx, trunk=-35 + breathe(ph, 1.0), legs=50, arms=None)
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("hand")})
    for s, sg in SIDES:
        sh = posed[f"upperarm01.{s}"].translation
        tgt = sh + Vector((0, -1, -0.05)).normalized() * WRIST_REACH
        P["hand" + s] = dict(pos=tuple(tgt), pole=(sg, 0.2, -0.3), aim=((0, -1, 0), (-sg, 0, 0)), shrug=4)
    return P


@motion("seatTwist", cam=CAM_FLOOR, rep=4.0)
def m_seattwist(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.35, 0.35, 0.25)
    P = seated_floor(pz, lean=-4)
    # left knee up, foot flat next to the right knee; right leg long
    P["footL"] = dict(pos=(0.10, -0.08, 0.074), rot=(0, 0, 8), pole=(0.6, -0.6, 1))
    P["spine"] = (2, 0, 40 * d)
    P["neck"] = (NECK_UP[0], 35 * d, 0)
    sh = shoulders(ctx, P)
    # left palm on the floor behind the hip (as far back as the arm reaches), right elbow/hand at the left knee
    back = Vector((0.24, 0.34, 0.035))
    flo = Vector(clamp_reach(sh["L"], back, 0.60))
    flo.z = 0.035
    P["handL"] = dict(pos=tuple(flo), pole=(1, 0.3, 0.3), aim=((0.2, 1, 0), (0, 0, -1)), shrug=6)
    P["handR"] = dict(pos=clamp_reach(sh["R"], (lerp(-0.05, 0.17, d), lerp(-0.20, -0.10, d), lerp(0.40, 0.50, d))),
                      pole=(-1, 0.5, 0.2), aim=((0.3, -0.2, 1), (1, 0, 0)))
    P["grip"] = 0.2
    return P


CAM_KNEEL = ((2.7, -1.6, 1.05), (2.4, -1.3, 1.0), (0, 0.12, 0.58), (0, 0.12, 0.56), 36)


@motion("camel", cam=CAM_KNEEL, rep=4.0)
def m_camel(ph, rep, ctx, eq):
    """kneeling back bend (Ustrasana): toes tucked, hands start on the sacrum, then reach back onto the
    heels, hips stay over the knees, chest opens to the ceiling."""
    d = cycle(ph, 0.4, 0.3, 0.3)
    P = dict(neck=(NECK_UP[0] - 26 * d, 0, 0), head=(HEAD_UP[0] - 6 * d, 0, 0))
    P["hips"] = (0, -0.03 - 0.07 * d, -0.42 + 0.02 * d)
    P["hips_rot"] = (-30 * d, 0, 0)
    P["spine"] = (-44 * d, 0, 0)
    for s_, sg in SIDES:
        P["foot" + s_] = dict(pos=(sg * 0.13, 0.40, 0.085), rot=(128, 0, 0), pole=(0, -1, -0.2))
    # lean back far enough that the hands can actually reach the heels (no arms hanging in the air)
    heel = {s_: Vector((sg * 0.14, 0.40, 0.20)) for s_, sg in SIDES}
    if d > 0.05:
        for _ in range(8):
            sh = shoulders(ctx, P)
            far = max((sh[s_] - heel[s_]).length for s_ in "LR")
            need = far - PALM_REACH * 0.985
            if need <= 0.005:
                break
            P["hips_rot"] = (P["hips_rot"][0] - 4 * d, 0, 0)
            P["spine"] = (max(-56.0, P["spine"][0] - 2 * d), 0, 0)
    sh = shoulders(ctx, P)
    for s_, sg in SIDES:
        start = Vector((sg * 0.12, 0.13, 0.74))                  # palms on the sacrum, fingers down
        tgt = start.lerp(heel[s_], ss(d))
        tgt = Vector(clamp_reach(sh[s_], tgt, PALM_REACH))
        P["hand" + s_] = dict(palm=tuple(tgt), pole=(sg * 0.6, 1, 0.0),
                              aim=((0, 0.15, -1), (-sg * 0.2, 0.98, 0)), shrug=0)
    P["grip"] = 0.35
    return P


# ============================================================================ build an exercise
GROUPS_EQ_PROPS = ("barbell", "dumbbell", "kettlebell", "medball", "band", "cable", "sling", "machine", "bar", "foam")


def equipment_props(motion_key, eq, meta):
    props = []
    hands_motions_bar = {"curl", "rdl", "row", "overhead", "uprightRow", "frontRaise", "skull", "pullover", "benchPress",
                         "idle", "farmer"}
    if eq == "barbell" and motion_key == "bridge":
        props.append(dict(type="barbell", mode="hands", plates=2, length=1.9))
    if eq == "barbell" and motion_key in hands_motions_bar | {"squat", "lunge", "calf"}:
        if motion_key in ("squat", "lunge", "calf"):
            props.append(dict(type="barbell", mode="chest", pos=(0, 0.075, 1.50), plates=2))
        else:
            props.append(dict(type="barbell", mode="hands", plates=1 if motion_key in ("curl", "skull", "frontRaise", "uprightRow") else 2,
                              length=1.4 if motion_key in ("curl", "skull", "frontRaise", "uprightRow") else 2.2))
        if motion_key == "squat":
            props.insert(0, dict(type="rack"))
    elif (motion_key == "bridge" and eq in ("dumbbell", "kettlebell")) or (motion_key == "pullover" and eq == "dumbbell"):
        props.append(dict(type=eq, hand="M"))
    elif eq in ("dumbbell",) and motion_key not in ("bridge", "crunch", "squat", "cossack"):
        props += [dict(type="dumbbell", hand="L"), dict(type="dumbbell", hand="R")]
    elif eq == "kettlebell" and motion_key not in ("bridge", "crunch", "squat", "cossack", "swing", "bwsRotate"):
        props += [dict(type="kettlebell", hand="L"), dict(type="kettlebell", hand="R")]
    elif eq == "kettlebell" and motion_key == "bwsRotate":
        props.append(dict(type="kettlebell", hand="L"))
    elif eq == "kettlebell" and motion_key == "swing":
        props.append(dict(type="kettlebell", hand="M"))
    if eq in ("medball",) or (eq in ("dumbbell", "kettlebell") and motion_key in ("squat", "cossack", "crunch")):
        props.append(dict(type="medball", offset=0.0 if motion_key == "overhead" else 0.08) if eq == "medball" else
                     dict(type="kettlebell" if eq == "kettlebell" else "dumbbell", hand="L"))
    if eq in ("band", "cable"):
        anchor = meta.get("anchor")
        kind = "band" if eq == "band" else "cable"
        if anchor == "feet" or (anchor is None and motion_key in ("squat", "curl", "lateral", "frontRaise", "overhead",
                                                                    "uprightRow", "rdl", "calf")):
            for s, sg in SIDES:
                props.append(dict(type="line", color=kind, hand=s, anchor=(sg * 0.12, -0.12, 0.02)))
        elif anchor == "high_wide":
            for s, sg in SIDES:
                props.append(dict(type="line", color=kind, hand=s, anchor=(sg * 1.0, 0.2, 2.0)))
                if eq == "cable":
                    props.append(dict(type="cable_tower", loc=(sg * 1.1, 0.3, 0)))
        elif isinstance(anchor, tuple):
            for s, sg in SIDES:
                props.append(dict(type="line", color=kind, hand=s, anchor=(anchor[0] + sg * 0.03, anchor[1], anchor[2])))
            if eq == "cable":
                props.append(dict(type="cable_tower", loc=(0, anchor[1] - 0.12, 0)))
    if eq == "sling" and motion_key in ("row", "pushup", "plank", "triceps", "curl", "pullup"):
        for s, sg in SIDES:
            anc = (sg * 0.12, -1.75, 2.55) if motion_key == "curl" else (sg * 0.15, -0.05, 2.6)
            props.append(dict(type="line", color="sling", hand=s, anchor=anc))
    if motion_key == "row" and eq == "bar":      # australian pull-up: low bar on two posts
        props.append(dict(type="pullbar", z=1.03))
        for sg in (1, -1):
            props.append(dict(type="box", loc=(sg * 0.66, -0.05, 0.515), size=(0.06, 0.06, 1.03)))
    if motion_key == "triceps" and eq in ("bar", "machine", "none", "sling"):
        props.append(dict(type="dipbars"))
    if eq == "foam" or motion_key in ("row",) and eq in ("cable", "machine", "band"):
        if eq == "foam":
            props.append(dict(type="foam"))
    if motion_key == "pullup" and eq in ("machine", "cable", "band"):
        props = [p for p in props if p["type"] not in ("rack", "pullbar", "line")]
        props.append(dict(type="box", loc=(0, 0.15, 0.24), size=(0.45, 0.45, 0.48)))
        props.append(dict(type="barbell", mode="hands", plates=0, length=1.2))
        if eq == "cable":       # lat pulldown: bar hangs on a cable from the machine's top pulley
            props.append(dict(type="cable_tower", loc=(0, 0.42, 0)))
            for s_, sg in SIDES:
                props.append(dict(type="line", color="cable", hand=s_, anchor=(0, 0.30, 2.15)))
    return props


def make_exercise(motion_key, eq="none", title="", subtitle="", muscles=()):
    """Return an Exercise instance animating a Bodyformance exercise."""
    meta = MOTIONS.get(motion_key) or MOTIONS["idle"]
    ex = EX.Exercise()
    ex.key = f"bf_{motion_key}_{eq}"
    ex.title = title or motion_key
    ex.subtitle = subtitle
    ex.muscles = [MUSCLE_MAP.get(m, m) for m in muscles if MUSCLE_MAP.get(m, m)] or ["abs"]
    cam = meta["cam"]
    if isinstance(cam, tuple):
        ex.camera = "custom"
        ex.cam = cam
    else:
        ex.camera = cam
    ex.rep_time, ex.reps, ex.intro = meta["rep"], meta["reps"], meta["intro"]
    ex.collide = meta.get("collide", True)
    props = list(meta["extra"])
    if meta["mat"] and not any(p["type"] in ("mat", "bench", "rack") for p in props):
        props.append(dict(type="mat", size=(1.4, 2.2), loc=(0, 0.0, 0)))
    from . import bf_family as BFF
    if motion_key in BFF.OWN_PROPS:
        props += BFF.extra_props(motion_key, eq)
    else:
        props += equipment_props(motion_key, eq, meta) + BFF.extra_props(motion_key, eq)
    # pullups etc. need the rack only for bar-based variants
    if motion_key in ("pullup", "hang", "legRaise") and eq in ("machine", "cable", "band", "none") and motion_key == "pullup":
        props = [p for p in props if p["type"] not in ("rack", "pullbar")]
    if motion_key == "legRaise" and eq in ("none", "machine"):
        props = [p for p in props if p["type"] not in ("rack", "pullbar")] + [dict(type="mat", size=(1.0, 2.2), loc=(0, -0.3, 0))]
    ex.props = props
    ex.arrows = []
    fn = meta["fn"]
    ex.pose = lambda ph, rep, ctx: fn(ph, rep, ctx, eq)
    ex.intensity = lambda ph: 0.4 + 0.6 * cycle(ph)
    return ex


from . import bf_family  # noqa: E402,F401  (registers the family-specific motions)
