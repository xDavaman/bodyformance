"""Exercise-specific animations for Bodyformance families whose app `motionKey` is only a rough
stand-in (e.g. "Beinpresse" -> squat, "Radfahren" -> knee raise, "Handstand" -> plank).

Every motion here is registered in bf_motions.MOTIONS with its own key and props; FAMILY maps a
Bodyformance family (by index, checked against its name) to (motion key, equipment).
The output file name of a family clip keeps the app's motion key, so nothing changes for the app.
"""
import math
from mathutils import Vector, Euler

from . import exercises as EX
from . import bf_motions as BF
from .exercises import ss, cycle, lerp, rotx, foot, rigid_pivot, stand, hands_on_hips, osc, NECK_UP, HEAD_UP
from .bf_motions import (motion, SIDES, lib, hold_hands, chest_hold, supine, prone, seated_floor, seated_box,
                         quadruped, shoulders, clamp_reach, grab_on, CAM_SIDE, CAM_FLOOR, CAM_BENCH, CAM_HANG,
                         CAM_KNEEL, WALL, gait, sling_curl)

CAM_SEAT = ((2.6, -2.2, 1.35), (2.3, -1.9, 1.25), (0, 0.0, 0.75), (0, 0.0, 0.72), 38)
CAM_LOW = ((2.4, -2.4, 0.95), (2.1, -2.1, 0.9), (0, -0.2, 0.45), (0, -0.2, 0.42), 34)
CAM_WIDE = ((2.8, -3.6, 1.45), (2.4, -3.2, 1.35), (0, -0.2, 0.85), (0, -0.2, 0.8), 38)
CAM_FRONT_LOW = ((0.9, -3.4, 0.9), (0.7, -3.0, 0.85), (0, 0, 0.5), (0, 0, 0.5), 34)

PAD = lambda loc, size, rot=(0, 0, 0): dict(type="box", loc=loc, size=size, rot=rot)


def qeul(x=0.0, y=0.0, z=0.0):
    return Euler((math.radians(x), math.radians(y), math.radians(z)), "XYZ").to_quaternion()


def J(pz, *names):
    return sum((pz.J[n] for n in names), Vector()) / len(names)


def place(pz, P, rest_pt, world_pt, rot):
    """rigid body placement: rotate the whole figure by `rot` (deg XYZ) so that rest point lands on world point."""
    P["hips_rot"] = tuple(rot)
    P["hips"] = rigid_pivot(pz, rest_pt, world_pt, qeul(*rot))
    return P


def world_of(pz, P, rest_pt):
    q = qeul(*P.get("hips_rot", (0, 0, 0)))
    return pz.J["root"] + Vector(P.get("hips", (0, 0, 0))) + q @ (Vector(rest_pt) - pz.J["root"])


def keys(ph, frames):
    """piecewise smooth interpolation through [(phase, value), ...] (values: float or tuple)."""
    for (p0, v0), (p1, v1) in zip(frames, frames[1:]):
        if ph <= p1:
            u = ss((ph - p0) / max(1e-6, p1 - p0))
            return lerp(v0, v1, u)
    return frames[-1][1]


def palms_on(P, s, sg, pos, fdir, pnorm, pole, shrug=0, space=None):
    h = dict(palm=tuple(pos), aim=(tuple(fdir), tuple(pnorm)), pole=tuple(pole), shrug=shrug)
    if space:
        h["space"] = space
    P["hand" + s] = h


# ============================================================================ machines (seated / lying)
SEAT = [PAD((0, 0.12, 0.25), (0.46, 0.46, 0.50)), PAD((0, 0.40, 0.86), (0.46, 0.08, 0.72), (-8, 0, 0))]


@motion("legExtension", cam=CAM_SEAT, rep=2.8, extra=SEAT + [
    dict(type="box", size=(0.40, 0.09, 0.09), follow=("footL", "footR"), offset=(0, -0.07, 0.04))], mat=False)
def m_legext(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.38, 0.12, 0.42)
    P = seated_box(pz, lean=-4, seat_z=0.50, hip_y=0.12)
    a = math.radians(lerp(6, 86, d))                    # shin angle from hanging (90 = straight leg)
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith(("foot", "hand"))})
    for s, sg in SIDES:
        hip = posed[f"upperleg01.{s}"].translation
        l1, l2 = pz.leg_len[s]
        knee = hip + Vector((0, -1, -0.06)).normalized() * l1     # thigh along the seat
        ank = knee + Vector((0, -math.sin(a), -math.cos(a))) * l2 * 0.995
        P["foot" + s] = dict(pos=tuple(ank), rot=(-math.degrees(a) * 0.9, 0, sg * 4), pole=(sg * 0.1, -1, 0.3))
        P["hand" + s] = dict(pos=(sg * 0.27, 0.10, 0.56), pole=(sg, 0.3, 0), aim=((0, -0.3, -1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.9
    return P


LEGPRESS_U = Vector((0, -math.cos(math.radians(35)), math.sin(math.radians(35))))


@motion("legPress", cam=CAM_SEAT, rep=3.0, extra=[
    PAD((0, 0.25, 0.22), (0.5, 0.55, 0.44)), PAD((0, 0.52, 0.78), (0.5, 0.08, 0.80), (-42, 0, 0)),
    dict(type="box", size=(0.62, 0.06, 0.48), follow=("footL", "footR"), offset=tuple(LEGPRESS_U * 0.10),
         rot=(145, 0, 0)),
    PAD((0.40, -0.26, 0.78), (0.05, 1.3, 0.05), (-35, 0, 0)), PAD((-0.40, -0.26, 0.78), (0.05, 1.3, 0.05), (-35, 0, 0))],
    mat=False)
def m_legpress(ph, rep, ctx, eq):
    """45-degree leg press: reclined, feet on the sled platform, knees to ~90 deg and back."""
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    calf = eq == "calf"
    P = dict(neck=(NECK_UP[0] + 12, 0, 0), head=HEAD_UP)
    H = Vector((0, 0.28, 0.52))
    place(pz, P, J(pz, "hipL", "hipR"), H, (-46, 0, 0))
    l1, l2 = pz.leg_len["L"]
    top = (l1 + l2) * 0.99                       # knees almost locked (soft, ~15 deg)
    L = top if calf else lerp(top, 0.62, d)      # bottom: knees ~95 deg
    for s, sg in SIDES:
        ank = H + Vector((sg * 0.16, 0, 0)) + LEGPRESS_U * L
        pitch = -125 + (28 * d if calf else 0)
        P["foot" + s] = dict(pos=tuple(ank), rot=(pitch, 0, sg * 8), pole=(sg * 0.25, -0.3, 1))
        P["hand" + s] = dict(pos=(sg * 0.30, 0.26, 0.48), pole=(sg, 0.4, 0), aim=((0, -0.3, -1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.9
    return P


@motion("legCurlProne", cam=CAM_BENCH, rep=2.8, extra=[
    dict(type="bench", loc=(0, -0.30, 0), length=1.3),
    dict(type="box", size=(0.40, 0.09, 0.09), follow=("footL", "footR"), offset=(0, 0.05, 0.06))], mat=False)
def m_legcurl(ph, rep, ctx, eq):
    """lying leg curl: prone on the bench, knees at the end, heels pull the pad to the glutes."""
    pz = ctx["poser"]
    d = cycle(ph, 0.38, 0.12, 0.42)
    P = prone(pz, anchor=(0, 0.20, 0.585))
    a = math.radians(lerp(4, 115, d))
    for s, sg in SIDES:
        knee = Vector((sg * 0.11, 0.20 + 0.45, 0.53))
        ank = knee + Vector((0, math.cos(a), math.sin(a))) * 0.47
        P["foot" + s] = dict(pos=tuple(ank), rot=(112 + math.degrees(a), 0, 0), pole=(0, 0, -1))
        P["hand" + s] = dict(pos=(sg * 0.20, -0.62, 0.50), pole=(sg, 0, -0.4), aim=((0, -1, -0.3), (0, 0, -1)), shrug=4)
    P["neck"] = (NECK_UP[0] - 12, 0, 0)
    P["grip"] = 0.9
    return P


@motion("hyperext", cam=CAM_SIDE, rep=3.2, extra=[
    PAD((0, -0.07, 0.89), (0.46, 0.26, 0.12), (42, 0, 0)), PAD((0, -0.02, 0.42), (0.10, 0.10, 0.80)),
    PAD((0, 0.64, 0.20), (0.44, 0.12, 0.10)), PAD((0, 0.30, 0.10), (0.10, 0.80, 0.08))], mat=False)
def m_hyperext(ph, rep, ctx, eq):
    """45-degree back extension: hips on the pad, heels hooked; trunk lowers and rises to a straight line."""
    pz = ctx["poser"]
    d = cycle(ph, 0.42, 0.10, 0.38)
    P = dict(neck=(NECK_UP[0] - 6 * (1 - d), 0, 0), head=HEAD_UP)
    H = Vector((0, 0.02, 0.97))
    place(pz, P, J(pz, "hipL", "hipR"), H, (lerp(44, 112, d), 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.11, 0.62, 0.30), rot=(40, 0, 0), pole=(sg * 0.1, -0.6, -1))
        P["hand" + s] = dict(palm=(sg * 0.12, -0.02, 1.72), space="chest", pole=(sg * 1, -0.2, 0.1),
                             aim=((0, 0.35, 1), (-sg, 0, 0)), shrug=4)
    P["grip"] = 0.3
    return P


@motion("reverseHyper", cam=CAM_SIDE, rep=3.0, extra=[PAD((0, -0.25, 0.425), (0.5, 0.95, 0.85))], mat=False)
def m_revhyper(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = prone(pz, anchor=(0, 0.26, 0.96))
    a = math.radians(lerp(-80, 2, 1 - d))               # leg angle: hanging down -> horizontal behind
    a = math.radians(lerp(-82, 0, d))
    for s, sg in SIDES:
        hip = Vector((sg * 0.11, 0.26, 0.96))
        ank = hip + Vector((0, math.cos(a), math.sin(a))) * 0.92
        P["foot" + s] = dict(pos=tuple(ank), rot=(90 + math.degrees(a), 0, 0), pole=(0, 0, -1))
        P["hand" + s] = dict(pos=(sg * 0.24, -0.62, 0.88), pole=(sg, 0, -0.4), aim=((0, -0.2, -1), (0, 1, 0)), shrug=6)
    P["grip"] = 0.95
    return P


@motion("nordic", cam=CAM_KNEEL, rep=4.0, extra=[PAD((0, 0.50, 0.17), (0.50, 0.10, 0.10)),
                                               PAD((0, 0.62, 0.10), (0.5, 0.15, 0.2))])
def m_nordic(ph, rep, ctx, eq):
    """nordic hamstring curl: kneeling, heels anchored, the straight body lowers forward from the knees."""
    pz = ctx["poser"]
    d = cycle(ph, 0.55, 0.05, 0.40)
    th = lerp(4, 62, d)
    P = dict(neck=NECK_UP, head=HEAD_UP)
    K = Vector((0, -0.02, 0.10))
    place(pz, P, J(pz, "kneeL", "kneeR"), K, (th, 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.12, 0.44, 0.07), rot=(172, 0, 0), pole=(0, -1, -0.3))
        fwd = ss(max(0.0, (d - 0.6) / 0.4))
        P["hand" + s] = dict(pos=tuple(Vector((sg * 0.18, -0.20, 1.30)).lerp(Vector((sg * 0.22, -0.42, 1.08)), fwd)),
                             space="chest", pole=(sg, 0.6, -0.8), aim=((0, -1, 0.3), (-sg * 0.2, 0, -1)), shrug=0)
    P["grip"] = 0.2
    return P


@motion("seatedCrunch", cam=CAM_SEAT, rep=2.8, extra=SEAT, mat=False, collide=dict(hands=False))
def m_abmachine(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.12, 0.40)
    P = seated_box(pz, lean=-6 + 22 * d, seat_z=0.50, hip_y=0.12)
    P["spine"] = (30 * d, 0, 0)
    P["neck"] = (NECK_UP[0] + 14 * d, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.17, -0.12, 1.70), space="chest", pole=(sg * 0.2, -1, -0.6),
                             aim=((0, -0.2, 1), (-sg, 0, 0)), shrug=6)
    P["grip"] = 0.9
    return P


@motion("abductor", cam="front", rep=2.8, extra=SEAT, mat=False)
def m_abductor(ph, rep, ctx, eq):
    """hip abductor / adductor machine (eq 'add' = adduction): seated, knees open and close."""
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    if eq == "add":
        d = 1 - d
    P = seated_box(pz, lean=-6, seat_z=0.50, hip_y=0.12, feet_y=-0.30)
    for s, sg in SIDES:
        out = lerp(0.14, 0.42, d)
        P["foot" + s] = dict(pos=(sg * out, -0.30, 0.18), rot=(-20, 0, sg * 10 * d), pole=(sg * (0.2 + 1.2 * d), -1, 0.4))
        P["hand" + s] = dict(pos=(sg * 0.27, 0.10, 0.56), pole=(sg, 0.3, 0), aim=((0, -0.3, -1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.9
    return P


@motion("chestPressMachine", cam=CAM_SEAT, rep=2.6, extra=SEAT + [dict(type="barbell", mode="hands", plates=0,
                                                                          length=0.62)], mat=False)
def m_chestpress(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.38, 0.10, 0.42)                     # 0 = arms extended
    P = seated_box(pz, lean=-6, seat_z=0.50, hip_y=0.14)
    for s, sg in SIDES:
        pos = lerp((sg * 0.24, -0.44, 1.20), (sg * 0.28, -0.12, 1.22), d)
        P["hand" + s] = dict(palm=pos, pole=(sg * 1, 0.3, -0.7), aim=((0, 0, 1), (0, 1, 0)), shrug=0)
    P["grip"] = 1.0
    return P


# ============================================================================ legs (bodyweight)
@motion("wallSit", cam=CAM_SIDE, rep=4.0, extra=[dict(WALL, loc=(0, 0.47, 1.1))])
def m_wallsit(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = dict(neck=NECK_UP, head=HEAD_UP)
    H = Vector((0, 0.23, 0.53 + 0.005 * math.sin(2 * math.pi * ph)))
    place(pz, P, J(pz, "hipL", "hipR"), H, (-2, 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.16, -0.24, 8, side=s); P["foot" + s]["pole"] = (sg * 0.15, -1, 0.2)
        P["hand" + s] = dict(pos=(sg * 0.17, -0.25, 0.60), pole=(sg, 0.3, 0), aim=((0, -1, -0.2), (0, 0, -1)), shrug=0)
    P["grip"] = 0.1
    return P


@motion("pistol", cam=CAM_SIDE, rep=4.0)
def m_pistol(ph, rep, ctx, eq):
    d = cycle(ph, 0.45, 0.10, 0.40)
    P = stand(0.10, 6)
    P["hips"] = (-0.07, 0.20 * d, -0.58 * d)
    P["hips_rot"] = (40 * d, 0, 0)
    P["spine"] = (10 * d, 0, 0)
    P["footR"] = foot(-0.10, -0.01, 6, side="R"); P["footR"]["knee_out"] = 6
    a = math.radians(lerp(8, 82, d))                   # free leg raised forward
    hip = Vector((0.05, 0.20 * d, 1.01 - 0.58 * d))
    ank = hip + Vector((0.03, -math.sin(a), -math.cos(a))) * 0.90
    P["footL"] = dict(pos=tuple(ank), rot=(-math.degrees(a) * 0.6, 0, 4), pole=(0.1, -1, 0.5))
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.16, lerp(-0.25, -0.55, d), lerp(1.05, 1.32, d)), space="root",
                             pole=(sg * 0.4, 1, -0.4), aim=((0, -1, 0.2), (0, 0, -1)), shrug=4)
    P["grip"] = 0.2
    return P


@motion("sissy", cam=CAM_SIDE, rep=3.4, extra=[PAD((0.42, -0.05, 0.60), (0.05, 0.05, 1.2))])
def m_sissy(ph, rep, ctx, eq):
    d = cycle(ph, 0.45, 0.10, 0.40)
    P = stand(0.14, 8)
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.14, -0.01, 8, heel=lerp(10, 38, d), side=s)
        P["foot" + s]["pole"] = (sg * 0.1, -1, 0)
    P["hips"] = (0, 0.14 * d, -0.38 * d)
    P["hips_rot"] = (-30 * d, 0, 0)
    P["spine"] = (6 * d, 0, 0)
    P["neck"] = (NECK_UP[0] + 12 * d, 0, 0)
    P["handL"] = dict(pos=(0.42, -0.08, lerp(1.05, 0.95, d)), pole=(1, 0.4, -0.2), aim=((0, 0, -1), (-1, 0, 0)), shrug=0)
    P["handR"] = dict(pos=(-0.15, -0.22, 1.30), space="chest", pole=(-1, 0.4, -0.6), aim=((0, -0.3, 1), (1, 0, 0)))
    P["grip"] = 0.9
    return P


@motion("bulgarian", cam=CAM_SIDE, rep=3.2, extra=[PAD((0, 0.62, 0.23), (0.45, 0.35, 0.46))])
def m_bulgarian(ph, rep, ctx, eq):
    d = cycle(ph, 0.42, 0.10, 0.40)
    P = dict(neck=NECK_UP, head=HEAD_UP)
    P["hips"] = (0.0, 0.10 + 0.02 * d, -0.10 - 0.36 * d)
    P["hips_rot"] = (10 + 8 * d, 0, 0)
    P["footL"] = foot(0.12, -0.34, 6, side="L"); P["footL"]["pole"] = (0.1, -1, 0)
    P["footR"] = dict(pos=(-0.11, 0.66, 0.53), rot=(150, 0, 0), pole=(0, -0.2, -1))
    for s, sg in SIDES:
        P["hand" + s] = dict(hang=0.995, offset=(sg * 0.02, 0, 0), pole=(sg * 0.2, 1, 0), aim=((0, 0, -1), (-sg, 0, 0)))
    P["grip"] = 0.95
    return P


@motion("stepUp", cam=CAM_SIDE, rep=3.0, extra=[PAD((0, -0.40, 0.20), (0.6, 0.45, 0.40))])
def m_stepup(ph, rep, ctx, eq):
    up = keys(ph, [(0, 0.0), (0.15, 0.0), (0.45, 1.0), (0.6, 1.0), (0.9, 0.0), (1.0, 0.0)])
    stepL = keys(ph, [(0, 0.0), (0.15, 1.0), (0.9, 1.0), (1.0, 0.0)])
    P = stand(0.14, 6)
    P["hips"] = (0, -0.22 * up - 0.04 * stepL, 0.40 * up - 0.05 * stepL * (1 - up))
    P["hips_rot"] = (12 * stepL * (1 - up) + 4, 0, 0)
    lift = math.sin(math.pi * min(1.0, stepL * 1.0)) if stepL < 1 else 0.0
    P["footL"] = foot(0.13, lerp(-0.01, -0.42, stepL), 6, side="L", lift=0.40 * stepL + 0.12 * lift * (1 - stepL))
    rz = 0.40 * up + 0.10 * math.sin(math.pi * up)
    P["footR"] = foot(-0.13, lerp(-0.01, -0.38, up), 6, side="R", lift=rz)
    for s, sg in SIDES:
        P["foot" + s]["pole"] = (sg * 0.1, -1, 0)
        if eq in ("dumbbell", "kettlebell"):
            P["hand" + s] = dict(hang=0.995, offset=(sg * 0.02, 0, 0), pole=(sg * 0.2, 1, 0), aim=((0, 0, -1), (-sg, 0, 0)))
        else:
            a = 2 * math.pi * ph + (math.pi if s == "L" else 0)
            P["hand" + s] = dict(pos=(sg * 0.22, -0.12 - 0.12 * math.sin(a), 1.02), space="root", pole=(sg * 0.3, 1, -0.2),
                                 aim=((0, -0.6, 0.8), (-sg, 0, 0)))
    P["grip"] = 0.95 if eq in ("dumbbell", "kettlebell") else 0.5
    return P


@motion("jumpSquat", cam=CAM_SIDE, rep=1.6, reps=4)
def m_jumpsquat(ph, rep, ctx, eq):
    d = keys(ph, [(0, 0.0), (0.35, 1.0), (0.48, 0.0), (1.0, 0.0)])
    air = keys(ph, [(0, 0.0), (0.42, 0.0), (0.58, 1.0), (0.74, 0.0), (1.0, 0.0)])
    land = keys(ph, [(0, 0.0), (0.74, 0.0), (0.84, 0.45), (1.0, 0.0)])
    dd = max(d, land)
    P = stand(0.20, 14)
    P["hips"] = (0, 0.16 * dd, -0.46 * dd + 0.26 * air)
    P["hips_rot"] = (32 * dd, 0, 0)
    P["spine"] = (-6 * dd, 0, 0)
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.20, -0.01, 14, heel=45 * air, side=s, lift=0.24 * air)
        P["foot" + s]["knee_out"] = 10
        sw = keys(ph, [(0, 0.0), (0.35, -1.0), (0.55, 1.0), (0.8, 0.2), (1.0, 0.0)])
        P["hand" + s] = dict(pos=(sg * 0.24, -0.15 - 0.30 * max(0, sw) + 0.25 * max(0, -sw), 1.0 + 0.45 * max(0, sw)),
                             space="root", pole=(sg * 0.3, 1, -0.2), aim=((0, -0.5, 0.8), (-sg, 0, 0)))
    P["grip"] = 0.4
    return P


@motion("tibRaise", cam=CAM_SIDE, rep=2.2)
def m_tib(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.15, 0.40)
    P = stand(0.14, 6)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.14, 0.035 - 0.02 * d, 0.074 + 0.012 * d), rot=(-24 * d, 0, sg * 6))
    hands_on_hips(P)
    return P


# ============================================================================ upper body (bodyweight)
def _inverted(pz, P, sh_z, hand_w=0.26, sway=0.0):
    """handstand: figure upside down, shoulders at height sh_z over the hands."""
    rot = (180, sway, 0)
    place(pz, P, J(pz, "shoulderL", "shoulderR"), Vector((0, 0.0, sh_z)), rot)
    for s, sg in SIDES:
        a = world_of(pz, P, pz.J["ankle" + s])
        P["foot" + s] = dict(pos=(a.x * 0.6, a.y, a.z), rot=(180 + 30, 0, 0), pole=(0, -1, 0))
        P["hand" + s] = dict(pos=(sg * hand_w, -0.06, 0.04), pole=(sg * 0.3, 1, 0), aim=((0, -1, 0), (0, 0, -1)), shrug=-8)
    P["neck"] = (NECK_UP[0] - 22, 0, 0)
    P["grip"] = 0.0
    return P


@motion("handstand", cam="front34", rep=3.0)
def m_handstand(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = dict(head=HEAD_UP)
    return _inverted(pz, P, 0.64, sway=1.5 * math.sin(2 * math.pi * ph))


@motion("hspu", cam=((2.7, 2.2, 1.2), (2.4, 1.9, 1.1), (0, 0, 0.75), (0, 0, 0.72), 38), rep=3.0, extra=[dict(WALL, loc=(0, -0.42, 1.1))])
def m_hspu(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.45, 0.08, 0.40)
    P = dict(head=HEAD_UP)
    _inverted(pz, P, lerp(0.64, 0.36, d), hand_w=0.30)
    for s, sg in SIDES:
        P["hand" + s]["pole"] = (sg * 0.9, 0.6, 0.3)
    return P


@motion("pikePushup", cam=CAM_SIDE, rep=2.8)
def m_pike(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.42, 0.08, 0.40)
    P = dict(neck=(NECK_UP[0] - 6, 0, 0), head=HEAD_UP)
    H = Vector((0, 0.10, lerp(0.95, 0.80, d)))
    place(pz, P, J(pz, "hipL", "hipR"), H, (lerp(126, 136, d), 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.13, 0.46, 6, heel=35, side=s); P["foot" + s]["pole"] = (sg * 0.1, -1, 0)
    if not hasattr(m_pike, "_hands"):
        P0 = dict(P); place(pz, P0, J(pz, "hipL", "hipR"), Vector((0, 0.10, 0.95)), (126, 0, 0))
        m_pike._hands = {k: Vector((v.x * 1.25, v.y - 0.14, 0.045)) for k, v in shoulders(ctx, P0).items()}
    for s, sg in SIDES:
        hp = m_pike._hands[s]
        P["hand" + s] = dict(pos=(hp.x, hp.y, 0.045), pole=(sg * 0.8, 0.6, 0.4), aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.0
    return P


@motion("sidePlank", cam=CAM_FRONT_LOW, rep=3.0, collide=dict(legs=False))
def m_sideplank(ph, rep, ctx, eq):
    """side plank on the right forearm, body in a straight line, feet stacked; left hand on the hip."""
    pz = ctx["poser"]
    P = dict(neck=NECK_UP, head=HEAD_UP)
    b = 0.012 * math.sin(2 * math.pi * ph)
    place(pz, P, pz.J["ankleR"], Vector((0.62, 0.0, 0.075)), (0, -80 + 0.5 * math.sin(2 * math.pi * ph), 0))
    P["hips"] = (P["hips"][0], P["hips"][1], P["hips"][2] + b)
    aL = world_of(pz, P, pz.J["ankleL"]); aR = world_of(pz, P, pz.J["ankleR"])
    P["footR"] = dict(pos=tuple(BF.leg_to(ctx, P, "R", aR - world_of(pz, P, pz.J["hipR"]), 0.99)), rot=(0, -80, 0), pole=(0, -1, 0))
    aL2 = BF.leg_to(ctx, P, "L", Vector((aL.x - 0.03, aL.y, aL.z - 0.02)) - world_of(pz, P, pz.J["hipL"]), 0.99)
    P["footL"] = dict(pos=tuple(aL2), rot=(0, -80, 0), pole=(0, -1, 0))   # stacked on the lower foot, straight
    shR = world_of(pz, P, pz.J["shoulderR"])
    P["handR"] = dict(pos=(shR.x + 0.02, shR.y - 0.27, 0.045), pole=(0, 0.4, -1), aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    P["handL"] = dict(pos=(0.20, -0.02, 1.02), space="root", pole=(1, 0.4, 0), aim=((0, -1, -0.35), (-1, 0, 0)), shrug=0)
    P["grip"] = 0.1
    return P


@motion("humanFlag", cam="front", rep=3.0, extra=[PAD((-0.98, 0.0, 1.25), (0.06, 0.06, 2.5))], mat=False)
def m_flag(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = dict(neck=NECK_UP, head=HEAD_UP)
    place(pz, P, J(pz, "shoulderL", "shoulderR"), Vector((-0.50, 0.0, 1.30 + 0.01 * math.sin(2 * math.pi * ph))),
          (0, -86, 0))
    for s in "LR":
        a = world_of(pz, P, pz.J["ankle" + s])
        P["foot" + s] = dict(pos=tuple(a), rot=(0, -86, 0), pole=(0, -1, 0))
    P["handL"] = dict(palm=(-0.95, 0.0, 1.80), pole=(0, 0.6, 1), aim=((0, 0, 1), (1, 0, 0)), shrug=10)
    P["handR"] = dict(palm=(-0.95, 0.0, 0.88), pole=(0, 0.6, -1), aim=((0, 0, 1), (1, 0, 0)), shrug=0)
    P["grip"] = 1.0
    return P


@motion("frontLever", cam=CAM_HANG, rep=3.0, extra=[dict(type="rack"), dict(type="pullbar", z=2.32)], mat=False)
def m_frontlever(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = dict(neck=(NECK_UP[0] + 10, 0, 0), head=HEAD_UP)
    place(pz, P, J(pz, "shoulderL", "shoulderR"), Vector((0, 0.06, 2.32 - 0.625 + 0.01 * math.sin(2 * math.pi * ph))),
          (-90, 0, 0))
    for s in "LR":
        a = world_of(pz, P, pz.J["ankle" + s])
        P["foot" + s] = dict(pos=(a.x * 0.6, a.y, a.z), rot=(-90 + 30, 0, 0), pole=(0, 0, 1))
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.40, -0.05, 2.32), pole=(sg * 0.6, 0, -1), aim=((0, -0.2, 1), (0, -1, -0.2)),
                             shrug=-6)
    P["grip"] = 1.0
    return P


@motion("lSit", cam=CAM_FLOOR, rep=3.0, collide=dict(hands=False))
def m_lsit(ph, rep, ctx, eq):
    pz = ctx["poser"]
    """L-sit: body pressed up on straight arms (hands beside the hips), straight legs held horizontal."""
    P = seated_floor(pz, lean=-6, hip_y=0.15)
    base = Vector(P["hips"])
    lift = 0.07
    for s, sg in SIDES:
        P["hand" + s] = dict(pos=(sg * 0.27, 0.17, 0.045), pole=(sg * 0.2, 1, 0), aim=((0, -1, 0), (0, 0, -1)), shrug=-10)
    for _ in range(4):           # lift the hips until the arms are straight
        P["hips"] = tuple(base + Vector((0, 0, lift)))
        posed = pz.solve({k: v for k, v in P.items() if not k.startswith("foot")})
        la, lb = pz.arm_len["L"]
        dist = (posed["upperarm01.L"].translation - Vector((0.27, 0.17, 0.045))).length
        lift += ((la + lb) * 0.995 - dist) * 0.9
    P["hips"] = tuple(base + Vector((0, 0, lift + 0.005 * math.sin(2 * math.pi * ph))))
    posed = pz.solve({k: v for k, v in P.items() if not k.startswith("foot")})
    for s, sg in SIDES:
        hip = posed[f"upperleg01.{s}"].translation
        l1, l2 = pz.leg_len[s]
        ank = hip + Vector((-sg * 0.04, -1, 0.02)).normalized() * (l1 + l2) * 0.99
        P["foot" + s] = dict(pos=tuple(ank), rot=(-60, 0, 0), pole=(0, 0, 1))
    P["grip"] = 0.0
    return P


@motion("dragonFlag", cam=CAM_BENCH, rep=4.0, extra=[dict(type="bench", loc=(0, 0.28, 0), length=1.3)], mat=False)
def m_dragon(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.50, 0.10, 0.35)
    P = dict(spine=(0, 0, 0), neck=(NECK_UP[0] + 20, 0, 0), head=HEAD_UP)
    scap = J(pz, "shoulderL", "shoulderR") + Vector((0, 0.10, -0.12))
    place(pz, P, scap, Vector((0, 0.60, 0.50)), (-90 - lerp(48, 6, d), 0, 0))
    for s in "LR":
        a = world_of(pz, P, pz.J["ankle" + s])
        P["foot" + s] = dict(pos=(a.x * 0.5, a.y, a.z), rot=(P["hips_rot"][0] + 60, 0, 0), pole=(0, 0, 1))
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.14, 0.92, 0.50), pole=(sg * 0.6, 0, 1), aim=((0, 0, -1), (0, 1, 0)), shrug=6)
    P["grip"] = 1.0
    return P


@motion("benchDips", cam=CAM_SIDE, rep=2.8, extra=[PAD((0, 0.36, 0.235), (0.9, 0.35, 0.47))])
def m_benchdips(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.42, 0.08, 0.40)
    P = dict(neck=NECK_UP, head=HEAD_UP, spine=(4, 0, 0))
    H = Vector((0, 0.04, lerp(0.57, 0.31, d)))
    place(pz, P, J(pz, "hipL", "hipR"), H, (-2 + 6 * d, 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.13, -0.76, 0.08), rot=(-60, 0, sg * 6), pole=(sg * 0.1, -0.2, 1))
        P["hand" + s] = dict(palm=(sg * 0.21, 0.22, 0.49), pole=(0, 1, 0.1), aim=((0, -1, 0), (0, 0, -1)), shrug=-4)
    P["grip"] = 0.6
    return P


@motion("floorTriExt", cam=EX.PushUp.cam, rep=2.8)
def m_floortri(ph, rep, ctx, eq):
    """bodyweight triceps extension on the floor: high plank, forearms down to the mat and press back up."""
    pz = ctx["poser"]
    d = cycle(ph, 0.42, 0.08, 0.40)
    P = dict(neck=(NECK_UP[0] - 22, 0, 0), head=(-12, 0, 0), spine=(-3, 0, 0))
    ank = J(pz, "ankleL", "ankleR")
    A = Vector((0, 0.35, foot(0, 0, heel=70)["pos"][2]))
    th = lerp(71.5, 81.0, d)
    place(pz, P, ank, A, (th, 0, 0))
    for s, sg in SIDES:
        a = A + rotx(th) @ (pz.J["ankle" + s] - ank) * 0.62
        P["foot" + s] = dict(pos=tuple(a), rot=(th - 8, 0, 0), pole=(0, 0, -1))
        P["hand" + s] = dict(pos=(sg * 0.17, -0.88, 0.045), pole=(sg * 0.2, 0.3, -1), aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.0
    return P


@motion("plyoPushup", cam=EX.PushUp.cam, rep=1.8, reps=4)
def m_plyo(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = lib(EX.PushUp).pose(min(0.999, ph * 1.0), rep, ctx)
    air = keys(ph, [(0, 0.0), (0.55, 0.0), (0.68, 1.0), (0.8, 0.0), (1.0, 0.0)])
    th0 = P["hips_rot"][0]
    th = th0 - 6 * air
    ank = J(pz, "ankleL", "ankleR")
    place(pz, P, ank, Vector((0, 0.35, foot(0, 0, heel=70)["pos"][2])), (th, 0, 0))
    for s in "LR":
        h = dict(P["hand" + s]); pos = list(h["pos"]); pos[2] += 0.10 * air; h["pos"] = tuple(pos)
        P["hand" + s] = h
    return P


@motion("bearCrawl", cam=CAM_FLOOR, rep=1.6, reps=4)
def m_bear(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = quadruped(pz, theta=78, hip=(0, 0.20, 0.58))
    for s, sg in SIDES:
        st = math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        lf = max(0.0, st) * 0.06
        P["foot" + s] = foot(sg * 0.13, 0.48 - 0.08 * st, 4, heel=60, side=s, lift=lf)
        P["foot" + s]["pole"] = (sg * 0.1, -1, -0.2)
        h = dict(P["hand" + ("R" if s == "L" else "L")])
        pos = list(h["pos"]); pos[1] += -0.08 * st; pos[2] += max(0.0, st) * 0.05; h["pos"] = tuple(pos)
        P["hand" + ("R" if s == "L" else "L")] = h
    return P


@motion("birdDog", cam=CAM_FLOOR, rep=3.2)
def m_birddog(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = quadruped(pz)
    left = (rep % 2 == 0)
    d = cycle(ph, 0.40, 0.20, 0.36)
    arm = "L" if left else "R"; leg = "R" if left else "L"
    sa = 1 if arm == "L" else -1; sl = 1 if leg == "L" else -1
    sh = shoulders(ctx, P)[arm]
    h0 = Vector(P["hand" + arm]["pos"])
    h1 = sh + Vector((sa * 0.05, -0.55, 0.02))
    P["hand" + arm] = dict(pos=tuple(h0.lerp(h1, d)), pole=(sa * 0.2, 0.3, 1),
                           aim=(tuple(Vector((0, -1, 0)).lerp(Vector((0, -1, 0.1)), d)), (sa * 0.0, 0, -1)), shrug=4 * d)
    f0 = Vector(P["foot" + leg]["pos"])
    f1 = Vector(BF.leg_to(ctx, P, leg, (0, 1, 0.03), 0.992))      # leg reaches straight back at hip height
    P["foot" + leg] = dict(pos=tuple(f0.lerp(f1, d)), rot=(lerp(172, 100, d), 0, 0), pole=(0, lerp(-0.6, 0, d), -1))
    return P


@motion("superman", cam=CAM_FLOOR, rep=3.0)
def m_superman(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.35, 0.25, 0.35)
    P = prone(pz)
    P["spine"] = (-16 * d, 0, 0); P["neck"] = (NECK_UP[0] - 8 * d, 0, 0)
    for s, sg in SIDES:
        ank = BF.leg_to(ctx, P, s, (sg * 0.03, 1, 0.02 + 0.22 * d), 0.99)     # straight legs lift off the floor
        P["foot" + s] = dict(pos=tuple(Vector((ank.x, ank.y, max(0.10, ank.z)))), rot=(170, 0, 0), pole=(0, 0, -1))
        P["hand" + s] = dict(pos=(sg * 0.24, -0.30, 2.04), space="chest", pole=(sg, 0, -0.3),
                             aim=((0, 0, 1), (0, 1, 0)), shrug=6)
    P["grip"] = 0.0
    return P


@motion("plankSwim", cam=EX.PushUp.cam, rep=2.0, reps=3)
def m_plankswim(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = lib(EX.PushUp).pose(0.0, 0, ctx)
    s = "L" if ph < 0.5 else "R"
    sg = 1 if s == "L" else -1
    u = math.sin(math.pi * ((ph * 2) % 1.0))
    sh = shoulders(ctx, P)[s]
    h0 = Vector(P["hand" + s]["pos"])
    h1 = sh + Vector((sg * 0.06, -0.55, 0.0))
    P["hand" + s] = dict(pos=tuple(h0.lerp(h1, u)), pole=(sg * 0.2, 0.3, 1), aim=((0, -1, 0), (0, 0, -1)), shrug=4 * u)
    return P


# ============================================================================ core
@motion("russianTwist", cam=CAM_FLOOR, rep=2.0, reps=3)
def m_russian(ph, rep, ctx, eq):
    pz = ctx["poser"]
    tw = 40 * math.sin(2 * math.pi * ph)
    P = seated_floor(pz, lean=-38, hip_y=0.15)
    P["spine"] = (14, 0, tw)
    P["neck"] = (NECK_UP[0] + 6, tw * 0.3, 0)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.10, -0.40, 0.20), rot=(-30, 0, 0), pole=(sg * 0.2, -0.4, 1))
        P["hand" + s] = dict(palm=(sg * 0.035, -0.36, 1.12), space="chest", pole=(sg * 1, 0.3, -0.8),
                             aim=((0, -0.9, 0.3), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.5
    return P


@motion("toeTouchLying", cam=CAM_FLOOR, rep=2.4, reps=3)
def m_toetouch(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = supine(pz, anchor=(0, 0.1, 0.11), pivot="hips")
    P["spine"] = (36 * d, 0, 0); P["neck"] = (P["neck"][0] + 14 * d, 0, 0)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.08, 0.06, 0.96), rot=(-170, 0, 0), pole=(0, -1, 0))
        P["hand" + s] = dict(pos=(sg * 0.10, lerp(-0.30, -0.62, d), lerp(1.70, 1.62, d)), space="chest",
                             pole=(sg, 0.2, -0.3), aim=((0, -0.4, 1), (-sg * 0.3, 0, 0)))
    P["grip"] = 0.2
    return P


@motion("woodChop", cam="front34", rep=2.8, extra=[dict(type="cable_tower", loc=(-1.05, 0.25, 0)),
                                                   dict(type="line", color="cable", hand="L", anchor=(-0.98, 0.12, 2.05))])
def m_woodchop(ph, rep, ctx, eq):
    d = cycle(ph, 0.42, 0.06, 0.45)
    P = stand(0.24, 14)
    P["hips_rot"] = (6 * d, 0, lerp(-28, 22, d))
    P["hips"] = (0, 0, -0.06 * d)
    P["spine"] = (8 * d, 0, lerp(-30, 32, d))
    P["footL"]["pole"] = (0.2, -1, 0); P["footR"]["pole"] = (-0.2, -1, 0)
    P["footR"] = foot(-0.24, -0.01, 14, heel=18 * (1 - d), side="R")
    P["footL"] = foot(0.24, -0.01, 14, heel=18 * d, side="L")
    A_, B_ = Vector((-0.44, -0.30, 1.72)), Vector((0.34, -0.38, 0.86))
    hand = A_.lerp(B_, d)
    dirv = (B_ - A_).normalized()
    for s, sg in SIDES:
        palm = hand + Vector((sg * 0.04, 0, sg * 0.05))
        P["hand" + s] = dict(palm=tuple(palm), pole=(sg * 0.5, 1, -0.4), aim=(tuple(dirv), (-sg * 0.7, 0.7, 0)), shrug=4)
    P["grip"] = 1.0
    return P


@motion("pallof", cam="front34", rep=3.0, extra=[dict(type="cable_tower", loc=(-1.10, 0.05, 0)),
                                                 dict(type="line", color="cable", hand="L", anchor=(-1.02, -0.08, 1.22))])
def m_pallof(ph, rep, ctx, eq):
    d = cycle(ph, 0.40, 0.25, 0.30)
    P = stand(0.24, 10)
    P["hips"] = (0, 0, -0.08)
    for s, sg in SIDES:
        P["foot" + s]["pole"] = (sg * 0.2, -1, 0)
        palm = Vector((sg * 0.03, lerp(-0.18, -0.55, d), 1.24))
        P["hand" + s] = dict(palm=tuple(palm), pole=(sg * 0.6, 1, -0.6), aim=((0, -0.2, 1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 1.0
    return P


@motion("abRollout", cam=CAM_FLOOR, rep=3.2, extra=[dict(type="dumbbell", hand="M")])
def m_rollout(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.45, 0.10, 0.40)
    P = dict(neck=(NECK_UP[0] - 6, 0, 0), head=HEAD_UP, spine=(lerp(18, 0, d), 0, 0))
    K = Vector((0, 0.30, 0.09))
    alpha = math.radians(lerp(18, 58, d))               # thigh from vertical
    H = K + Vector((0, -math.sin(alpha), math.cos(alpha))) * 0.45
    place(pz, P, J(pz, "hipL", "hipR"), H, (lerp(52, 76, d), 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.12, 0.74, 0.07), rot=(172, 0, 0), pole=(0, -1, -0.3))
    sh = shoulders(ctx, P)
    mid = (sh["L"] + sh["R"]) / 2
    reach = 0.60
    yy = mid.y - math.sqrt(max(0.0, reach ** 2 - (mid.z - 0.10) ** 2))
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.09, yy, 0.10), pole=(sg * 0.6, 1, 0), aim=((0, -0.2, -1), (0, 1, -0.2)),
                             shrug=0)
    P["grip"] = 1.0
    return P


@motion("sideBendDB", cam="front", rep=3.0, extra=[dict(type="dumbbell", hand="L")])
def m_sidebend_db(ph, rep, ctx, eq):
    d = math.sin(2 * math.pi * ph)
    P = stand(0.17, 8)
    P["spine"] = (0, 24 * d, 0)
    P["hips"] = (-0.03 * d, 0, 0)
    P["handL"] = dict(hang=0.995, pole=(0.2, 1, 0), aim=((0, 0, -1), (-1, 0, 0)))
    P["handR"] = dict(palm=(-0.12, -0.01, 1.72), space="chest", pole=(-1, -0.2, 0.1), aim=((0, 0.35, 1), (1, 0, 0)), shrug=4)
    P["grip"] = 0.95
    return P


# ============================================================================ pull / arms
@motion("shrug", cam="front34", rep=2.4)
def m_shrug(ph, rep, ctx, eq):
    d = cycle(ph, 0.35, 0.20, 0.40)
    P = stand(0.15, 8)
    hold_hands(P, eq if eq != "none" else "dumbbell", width=0.25, z=0.86 + 0.07 * d)
    for s in "LR":
        P["hand" + s]["shrug"] = lerp(-2, 26, d)
    return P


@motion("oneArmRow", cam=CAM_SIDE, rep=2.8, extra=[dict(type="bench", loc=(0.17, -0.10, 0), length=1.2),
                                                    dict(type="dumbbell", hand="R")], mat=False)
def m_onearmrow(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.38, 0.12, 0.42)
    P = dict(neck=(NECK_UP[0] - 14, 0, 0), head=HEAD_UP, spine=(-4, 0, -6 * d))
    H = Vector((0.0, 0.22, 0.95))
    place(pz, P, J(pz, "hipL", "hipR"), H, (80, 0, 4))
    P["footL"] = dict(pos=(0.15, 0.58, 0.56), rot=(172, 0, 0), pole=(0, -1, -0.3))
    P["footR"] = foot(-0.30, 0.30, 10, side="R"); P["footR"]["pole"] = (-0.2, -1, 0)
    P["handL"] = dict(pos=(0.17, -0.36, 0.52), pole=(0.3, 1, 0), aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    sh = shoulders(ctx, P)["R"]
    low = sh + Vector((0.02, -0.04, -0.55))
    high = Vector((-0.22, 0.20, sh.z - 0.05))
    P["handR"] = dict(pos=tuple(low.lerp(high, d)), pole=(-0.3, 0.6, 1), aim=((0, 0, -1), (1, 0, 0)), shrug=lerp(-6, 4, d))
    P["grip"] = 0.95
    return P


def _bent_raise(ph, eq, abd_top=90.0, fwd_top=0.0):
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = stand(0.17, 8)
    P["hips"] = (0, 0.15, -0.12); P["hips_rot"] = (55, 0, 0); P["neck"] = (NECK_UP[0] - 10, 0, 0)
    P["footL"]["pole"] = (0.1, -1, 0); P["footR"]["pole"] = (-0.1, -1, 0)
    for s, sg in SIDES:
        ab = math.radians(lerp(6, abd_top, d)); fw = math.radians(lerp(0, fwd_top, d))
        arm = Vector((sg * math.sin(ab) * math.cos(fw), -math.sin(fw), -math.cos(ab) * math.cos(fw))).normalized()
        shc = Vector((sg * 0.21, -0.02, 1.47))
        P["hand" + s] = dict(pos=tuple(shc + arm * 0.552), space="chest", pole=(sg * 0.2, 1, 0.3),
                             aim=(tuple(arm), (0, 1, 0) if True else (-sg, 0, 0)), shrug=-2 + 6 * d)
    P["grip"] = 0.95
    return P


@motion("reverseFly", cam="front34", rep=2.6)
def m_reversefly(ph, rep, ctx, eq):
    return _bent_raise(ph, eq, 86, 0)


@motion("yRaise", cam="front34", rep=2.6)
def m_yraise(ph, rep, ctx, eq):
    return _bent_raise(ph, eq, 60, 75)


@motion("rotation", cam="front34", rep=2.6)
def m_rotation(ph, rep, ctx, eq):
    """shoulder external rotation (eq 'internal' = internal rotation): elbow pinned at the ribs."""
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = stand(0.17, 8)
    for s, sg in SIDES:
        a = math.radians(lerp(-5, 70, d) if eq != "internal" else lerp(60, -20, d))
        elbow = Vector((sg * 0.22, 0.02, 1.22))
        fdir = Vector((sg * math.sin(a), -math.cos(a), 0))
        P["hand" + s] = dict(pos=tuple(elbow + fdir * 0.27), space="root", pole=(sg * 0.2, 1, -0.3),
                             aim=(tuple(fdir), (0, 0, 1) if False else (-sg * math.cos(a) * 0, 0, 1)), shrug=0)
        P["hand" + s]["aim"] = (tuple(fdir), (0, 0, -1))
    P["grip"] = 0.95
    return P


@motion("concCurl", cam=CAM_SIDE, rep=2.6, extra=[PAD((0, 0.20, 0.23), (0.40, 0.40, 0.46)), dict(type="dumbbell", hand="R")])
def m_conccurl(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = seated_box(pz, lean=34, seat_z=0.46, hip_y=0.20, feet_y=-0.30)
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.30, -0.30, 18, side=s); P["foot" + s]["pole"] = (sg * 0.6, -1, 0.3)
    P["spine"] = (14, 0, 0)
    sh = shoulders(ctx, P)["R"]
    elbow = Vector((-0.17, -0.14, 0.62))
    a = math.radians(lerp(10, 118, d))
    up = (sh - elbow).normalized()
    side = Vector((1, 0, 0))
    fdir = (Vector((0, 0, -1)) * math.cos(a) + (up - up.project(Vector((0, 0, -1)))).normalized() * math.sin(a))
    fdir = Vector((0.15 * math.sin(a), -0.35 * math.sin(a), -math.cos(a))).normalized() if fdir.length < 1e-3 else \
        Vector((0.1 * math.sin(a), -math.sin(a) * 0.4, -math.cos(a) + math.sin(a) * 0.6)).normalized()
    P["handR"] = dict(pos=tuple(elbow + fdir * 0.28), pole=(0.1, 0.2, -1), aim=(tuple(fdir), (0.6, -0.6, 0.3)), shrug=0)
    P["handL"] = dict(pos=(0.24, -0.38, 0.64), pole=(1, 0.3, 0), aim=((0, -0.4, -1), (0, 0, -1)), shrug=0)
    P["grip"] = 0.95
    return P


@motion("cableCurlHigh", cam="front", rep=2.6, anchor="high_wide")
def m_cablecurlhigh(ph, rep, ctx, eq):
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = stand(0.20, 10)
    for s, sg in SIDES:
        shc = Vector((sg * 0.21, -0.02, 1.47))
        elbow = shc + Vector((sg * 0.27, 0.0, 0.03))
        a = math.radians(lerp(10, 125, d))
        fdir = Vector((sg * math.cos(a), 0.0, math.sin(a) * 0.95 - 0.02)).normalized()
        P["hand" + s] = dict(pos=tuple(elbow + fdir * 0.27), space="chest", pole=(0, 0.3, -1),
                             aim=(tuple(fdir), (0, -1, 0) if False else (0, 0, -1)), shrug=6)
        P["hand" + s]["aim"] = (tuple(fdir), (-sg * math.sin(a), 0, math.cos(a)))
    P["grip"] = 0.95
    return P


@motion("wristCurl", cam=CAM_SIDE, rep=2.0, reps=3, extra=[PAD((0, 0.20, 0.23), (0.40, 0.40, 0.46))])
def m_wristcurl(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = math.sin(2 * math.pi * ph)
    P = seated_box(pz, lean=30, seat_z=0.46, hip_y=0.20, feet_y=-0.30)
    for s, sg in SIDES:
        P["foot" + s] = foot(sg * 0.17, -0.30, 8, side=s); P["foot" + s]["pole"] = (sg * 0.2, -1, 0.3)
        P["hand" + s] = dict(pos=(sg * 0.13, -0.42, 0.62), pole=(sg * 0.3, 0.4, -1), aim=((0, -1, 0.5 * d), (0, -0.4 * d, 1)),
                             shrug=0)
    P["grip"] = 0.95
    return P


@motion("forearmRoller", cam="front34", rep=1.6, reps=4, extra=[dict(type="barbell", mode="hands", plates=0, length=0.5)])
def m_roller(ph, rep, ctx, eq):
    P = stand(0.15, 8)
    for s, sg in SIDES:
        fl = 35 * math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        P["hand" + s] = dict(palm=(sg * 0.12, -0.52, 1.36), pole=(sg * 0.6, 0.3, -1), aim=((0, -0.1, -1), (0, 1, 0)),
                             shrug=4, flex=fl)
    P["grip"] = 1.0
    return P


@motion("neckIso", cam="front34_close", rep=3.0)
def m_neckiso(ph, rep, ctx, eq):
    d = cycle(ph, 0.3, 0.4, 0.3)
    P = stand(0.16, 8)
    P["neck"] = (NECK_UP[0] - 6 * d, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.05, -0.18, 1.80), space="chest", pole=(sg, 0.2, -0.8),
                             aim=((sg * -0.2, 0, 1), (0, 1, 0)), shrug=4)
    P["grip"] = 0.1
    return P


@motion("chestSqueeze", cam="front34", rep=3.0)
def m_squeeze(ph, rep, ctx, eq):
    d = cycle(ph, 0.3, 0.4, 0.3)
    P = stand(0.17, 8)
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.012, lerp(-0.28, -0.34, d), 1.30), space="chest", pole=(sg, 0.2, -0.9),
                             aim=((0, -0.2, 1), (-sg, 0, 0)), shrug=0)
    P["grip"] = 0.0
    return P


@motion("preacher", cam=CAM_SIDE, rep=2.6, extra=[PAD((0, 0.15, 0.27), (0.42, 0.40, 0.54)),
                                                  PAD((0, -0.26, 0.86), (0.46, 0.08, 0.40), (52, 0, 0)),
                                                  PAD((0, -0.20, 0.45), (0.06, 0.06, 0.80)),
                                                  dict(type="barbell", mode="hands", plates=1, length=1.3)], mat=False)
def m_preacher(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = seated_box(pz, lean=16, seat_z=0.54, hip_y=0.15, feet_y=-0.15)
    for s, sg in SIDES:
        elbow = Vector((sg * 0.17, -0.30, 0.92))
        a = math.radians(lerp(15, 128, d))               # forearm from down-forward on the pad to up
        fdir = Vector((0, -math.cos(a - math.radians(40)) * 0.9, -math.sin(math.radians(40) - a)))
        fdir = Vector((0, -math.cos(a) * 0.55 - 0.45 * math.sin(a) * 0 - 0.3, math.sin(a) - 0.8 * math.cos(a))).normalized()
        P["hand" + s] = dict(palm=tuple(elbow + fdir * 0.32), pole=(sg * 0.1, -0.8, -1),
                             aim=(tuple(fdir), (0, -fdir.z, fdir.y)), shrug=0)
    P["grip"] = 1.0
    return P


# ============================================================================ hips / glutes
@motion("hipThrust", cam=CAM_FLOOR, rep=3.0, extra=[PAD((0, 0.58, 0.235), (1.2, 0.40, 0.47)),
                                                    dict(type="barbell", mode="hands", plates=2, length=1.9)])
def m_hipthrust(ph, rep, ctx, eq):
    pz = ctx["poser"]
    d = cycle(ph, 0.38, 0.15, 0.40)                     # 1 = hips up
    d = 1 - d
    th = lerp(-52, -94, d)
    q = rotx(th)
    scap = J(pz, "shoulderL", "shoulderR") + Vector((0, 0.10, -0.12))
    P = dict(spine=(-2 * d, 0, 0), neck=(-10 + 26 * (1 - d), 0, 0), head=HEAD_UP)
    place(pz, P, scap, Vector((0, 0.40, 0.49)), (th, 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.19, -0.42, 0.085), rot=(0, 0, sg * 8), pole=(sg * 0.2, -0.3, 1))
        P["hand" + s] = dict(palm=(sg * 0.30, -0.19, 0.95), space="root", pole=tuple(q @ Vector((sg, 0.2, -1))),
                             aim=(tuple(q @ Vector((0, -0.25, -1))), tuple(q @ Vector((0, 1, -0.25)))), shrug=0)
    P["grip"] = 0.95
    return P


@motion("frogPump", cam=CAM_FLOOR, rep=2.2, reps=3)
def m_frog(ph, rep, ctx, eq):
    gb = lib(EX.GluteBridge)
    P = gb.pose(ph, rep, ctx)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.07, -0.42, 0.10), rot=(0, sg * 45, sg * 25), pole=(sg * 1.2, -0.2, 0.6))
    return P


@motion("cableKickback", cam=CAM_SIDE, rep=2.6, extra=[dict(type="cable_tower", loc=(0, -0.82, 0)),
                                                       dict(type="line", color="cable", hand="L", anchor=(0, -0.72, 0.12),
                                                            **{"from": "footR"})])
def m_cablekick(ph, rep, ctx, eq):
    d = cycle(ph, 0.40, 0.10, 0.40)
    P = stand(0.12, 6)
    P["hips_rot"] = (22, 0, 0); P["hips"] = (0.03, 0.06, -0.02)
    P["footL"]["pole"] = (0.1, -1, 0)
    a = math.radians(lerp(4, 42, d))
    hip = Vector((-0.11, 0.06, 0.97))
    ank = hip + Vector((0, math.sin(a), -math.cos(a))) * 0.90
    P["footR"] = dict(pos=tuple(ank), rot=(math.degrees(a) * 0.4, 0, 0), pole=(0, -1, -0.1))
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.18, -0.66, 1.22), pole=(sg * 0.4, 1, -0.4), aim=((0, 0, 1), (0, 1, 0)), shrug=4)
    P["grip"] = 1.0
    return P


# ============================================================================ olympic / strongman
def _bar_hands(P, bar, w=0.27, aim=((0, 0, -1), (0, 1, 0)), pole_y=1.0):
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * w, bar[1], bar[2]), pole=(sg * 0.5, pole_y, -0.2), aim=aim, shrug=0)


@motion("deadlift", cam=CAM_SIDE, rep=3.4)
def m_deadlift(ph, rep, ctx, eq):
    """conventional deadlift: bar over the mid-foot, arms straight (they only hang), start with the hips
    above the knees (knee ~70 deg, trunk ~45 deg), stand up to full hip extension."""
    d = cycle(ph, 0.45, 0.08, 0.40)                     # 1 = bar on the floor
    pz = ctx["poser"]
    P = stand(0.15, 10)
    P["hips_rot"] = (72 * d, 0, 0)
    P["spine"] = (-4 * d, 0, 0)
    P["neck"] = (NECK_UP[0] - 22 * d, 0, 0)
    for s, sg in SIDES:
        P["foot" + s]["pole"] = (sg * 0.15, -1, 0)
        P["hand" + s] = dict(hang=0.997, offset=(sg * 0.045, -0.02, 0), pole=(sg * 0.5, 1.0, -0.2),
                             aim=((0, 0, -1), (0, 1, 0)), shrug=0)
    # hip height so the straight arms bring the bar (palm) exactly down to the floor position
    bar_z = lerp(0.86, 0.235, d)
    hz, hy = 0.0, 0.27 * d
    if d > 1e-3:
        for _ in range(4):
            P["hips"] = (0, hy, hz)
            posed = pz.solve(P)
            pz_ = (posed["_palmL"].z + posed["_palmR"].z) / 2
            hz += (bar_z - pz_) * 0.95
    P["hips"] = (0, hy, hz)
    P["grip"] = 1.0
    return P


@motion("goodMorning", cam=CAM_SIDE, rep=3.4)
def m_goodmorning(ph, rep, ctx, eq):
    P = lib(EX.BackSquat).pose(0.0, 0, ctx)
    d = cycle(ph, 0.42, 0.10, 0.38)
    P["hips"] = (0, 0.18 * d, -0.035 * d)     # hinge with soft knees (~15-20 deg), bar stays on the traps
    P["hips_rot"] = (64 * d, 0, 0)
    P["neck"] = (NECK_UP[0] - 18 * d, 0, 0)
    return P


def _olympic(ph, kind):
    """clean / snatch / jerk keyframes: bar from the floor (or rack) to the front rack / overhead."""
    rack = ((0, -0.17, 1.52), (0.35, -1.0, -1.1), (0, 0.1, 1), (0, -1, 0.1))
    over = ((0, -0.04, 1.98), (1.0, -0.3, -0.5), (0, 0.1, 1), (0, -1, 0.1))
    if kind == "clean":
        fr = [(0, 0.0), (0.28, 1.0), (0.38, 2.0), (0.58, 3.0), (0.76, 3.0), (1.0, 0.0)]
    elif kind == "snatch":
        fr = [(0, 0.0), (0.28, 1.0), (0.38, 2.0), (0.60, 4.0), (0.76, 4.0), (1.0, 0.0)]
    else:
        fr = [(0, 3.0), (0.25, 3.5), (0.40, 4.5), (0.70, 4.5), (1.0, 3.0)]
    st = keys(ph, fr)
    # stage -> (hinge depth, bar position, catch squat)
    stages = {0.0: (1.0, (0, -0.06, 0.235), 0.0), 1.0: (0.45, (0, -0.03, 0.62), 0.0), 2.0: (0.0, (0, -0.02, 1.02), 0.0),
              3.0: (0.0, rack[0], 0.30), 3.5: (0.0, rack[0], 0.45), 4.0: (0.0, over[0], 0.35), 4.5: (0.0, over[0], 0.2)}
    ks = sorted(stages)
    for a, b in zip(ks, ks[1:]):
        if st <= b:
            u = (st - a) / (b - a)
            hinge = lerp(stages[a][0], stages[b][0], u); bar = Vector(lerp(stages[a][1], stages[b][1], u))
            catch = lerp(stages[a][2], stages[b][2], u)
            break
    else:
        hinge, bar, catch = stages[ks[-1]][0], Vector(stages[ks[-1]][1]), stages[ks[-1]][2]
    P = stand(0.17 + 0.05 * (st >= 3), 12)
    P["hips"] = (0, 0.20 * hinge + 0.04 * catch, -0.36 * hinge - 0.30 * catch)
    P["hips_rot"] = (52 * hinge + 12 * catch, 0, 0)
    P["neck"] = (NECK_UP[0] - 22 * hinge, 0, 0)
    for s, sg in SIDES:
        P["foot" + s]["pole"] = (sg * 0.2, -1, 0); P["foot" + s]["knee_out"] = 8
    w_rack = ss((bar.z - 1.05) / 0.40)
    w_over = ss((bar.z - 1.56) / 0.30)
    if kind == "jerk":
        sp = ss((st - 3.55) / 0.4)
        P["footL"] = foot(0.15, -0.01 - 0.33 * sp, 6 + 6 * (1 - sp), side="L")
        P["footR"] = foot(-0.15, -0.01 + 0.37 * sp, 6 + 6 * (1 - sp), heel=25 * sp, side="R")
    w = 0.40 if kind == "snatch" else 0.26
    for s, sg in SIDES:
        low_p, mid_p = Vector((sg * 0.5, 1.0, -0.2)), Vector((sg * 1.0, 0.2, 0.3))
        rack_p, over_p = Vector((sg * 0.35, -1.0, -1.1)), Vector((sg * 1, -0.3, -0.5))
        w_mid = ss((bar.z - 0.75) / 0.40)
        w_rk = ss((bar.z - 1.30) / 0.22) if kind != "snatch" else 0.0
        pole = low_p.lerp(mid_p, w_mid).lerp(rack_p, w_rk).lerp(over_p, w_over)
        th = math.pi * ss((bar.z - 0.95) / 0.45)        # bar rolls in the hands: fingers down -> up
        aim = ((0, -math.sin(th), -math.cos(th)), (0, math.cos(th), -math.sin(th)))
        overhead = w_over > 0.5
        P["hand" + s] = dict(palm=(sg * w, bar.y, bar.z), pole=tuple(pole), aim=aim, shrug=8 * w_over)
    P["grip"] = 1.0
    return P


@motion("clean", cam=CAM_SIDE, rep=3.4)
def m_clean(ph, rep, ctx, eq):
    return _olympic(ph, "clean")


@motion("snatch", cam=CAM_SIDE, rep=3.4)
def m_snatch(ph, rep, ctx, eq):
    return _olympic(ph, "snatch")


@motion("jerk", cam=CAM_SIDE, rep=3.0)
def m_jerk(ph, rep, ctx, eq):
    return _olympic(ph, "jerk")


@motion("landmine", cam=CAM_SIDE, rep=2.8, extra=[dict(type="line", color="bar", radius=0.022, hand="R",
                                                       anchor=(0, -1.75, 0.04)), PAD((0, -1.75, 0.04), (0.14, 0.14, 0.08))])
def m_landmine(ph, rep, ctx, eq):
    d = cycle(ph, 0.36, 0.10, 0.44)                     # 0 = arm extended
    P = stand(0.15, 8)
    P["footL"] = foot(0.15, -0.22, 6, side="L"); P["footR"] = foot(-0.15, 0.22, 6, heel=12, side="R")
    P["hips_rot"] = (10, 0, 0)
    anchor = Vector((0, -1.75, 0.04))
    shoulder = Vector((-0.10, -0.25, 1.40))
    end = (Vector((-0.06, -0.72, 1.72)) - anchor).normalized() * 1.95 + anchor
    start = (shoulder - anchor).normalized() * 1.95 + anchor
    tip = end.lerp(start, d)
    P["handR"] = dict(palm=tuple(tip), pole=(-0.6, 0.4, -1), aim=((0, -0.4, 1), (0.8, 0, 0)), shrug=4)
    P["handL"] = dict(palm=tuple(tip + Vector((0.05, 0.03, -0.06))), pole=(0.8, 0.4, -1), aim=((0, -0.4, 1), (-0.8, 0, 0)))
    P["grip"] = 1.0
    return P


@motion("sledPush", cam=CAM_WIDE, rep=1.0, reps=5, extra=[PAD((0, -0.93, 0.20), (0.62, 0.62, 0.32)),
                                                           PAD((0.22, -0.70, 0.60), (0.05, 0.05, 0.62)),
                                                           PAD((-0.22, -0.70, 0.60), (0.05, 0.05, 0.62))])
def m_sled(ph, rep, ctx, eq):
    P = gait(ph, stride=0.32, lift=0.12, bounce=0.02, arm=0.0, lean=45)
    P["hips"] = (0, 0.18, -0.16)
    P["neck"] = (NECK_UP[0] - 25, 0, 0)
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=(sg * 0.22, -0.68, 0.90), pole=(sg * 0.5, 0.6, -1), aim=((0, 0, 1), (0, 1, 0)), shrug=0)
    P["grip"] = 1.0
    return P


@motion("battleRope", cam="front34", rep=0.8, reps=6, extra=[
    dict(type="line", color="rope", radius=0.02, hand="L", anchor=(0.10, -3.2, 0.08)),
    dict(type="line", color="rope", radius=0.02, hand="R", anchor=(-0.10, -3.2, 0.08))])
def m_battlerope(ph, rep, ctx, eq):
    P = stand(0.26, 16)
    P["hips"] = (0, 0.10, -0.20); P["hips_rot"] = (22, 0, 0)
    for s, sg in SIDES:
        P["foot" + s]["knee_out"] = 10
        w = math.sin(2 * math.pi * ph + (0 if s == "L" else math.pi))
        P["hand" + s] = dict(palm=(sg * 0.24, -0.48, 0.98 + 0.22 * w), pole=(sg * 0.6, 0.6, -0.8),
                             aim=((0, -1, 0), (-sg, 0, 0)), shrug=4 * max(0, w))
    P["grip"] = 1.0
    return P


@motion("foamRoll", cam=CAM_FLOOR, rep=3.0, extra=[dict(type="foam", follow=("thighL", "thighR"), offset=(0, 0, -0.105),
                                                        rot=(0, 90, 0))])
def m_foam(ph, rep, ctx, eq):
    pz = ctx["poser"]
    r = math.sin(2 * math.pi * ph)
    P = seated_floor(pz, lean=-28, hip_y=0.20 + 0.14 * r)
    P["hips"] = (P["hips"][0], P["hips"][1], P["hips"][2] + 0.10)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.11, 0.20 + 0.14 * r - 0.86, 0.12), rot=(-70, 0, sg * 6), pole=(sg * 0.1, 0, 1))
        P["hand" + s] = dict(pos=(sg * 0.24, 0.20 + 0.14 * r + 0.30, 0.04), pole=(sg * 0.3, -1, 0.2),
                             aim=((sg * 0.2, 1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.0
    return P


@motion("boxing", cam="front34", rep=1.4, reps=5)
def m_boxing(ph, rep, ctx, eq):
    """shadow boxing: orthodox stance, guard at the chin, jab (left) then cross (right) with hip turn.
    eq 'bag' adds a heavy bag, eq 'dodge' = bob & weave instead of punches."""
    P = dict(neck=(NECK_UP[0] - 8, 0, 0), head=HEAD_UP)
    P["footL"] = foot(0.12, -0.18, 18, side="L"); P["footR"] = foot(-0.14, 0.22, 28, heel=18, side="R")
    for s, sg in SIDES:
        P["foot" + s]["pole"] = (sg * 0.2, -1, 0)
    jab = keys(ph, [(0, 0.0), (0.12, 1.0), (0.26, 0.0), (1.0, 0.0)])
    cross = keys(ph, [(0, 0.0), (0.38, 0.0), (0.52, 1.0), (0.68, 0.0), (1.0, 0.0)])
    bob = 0.0
    if eq == "dodge":
        jab = cross = 0.0
        bob = math.sin(2 * math.pi * ph)
    turn = -24 * cross + 10 * jab + 18 * bob
    P["hips"] = (0.02 * bob, 0.02, -0.10 - 0.16 * abs(bob) + 0.012 * math.sin(4 * math.pi * ph))
    P["hips_rot"] = (8, 0, 18 + turn * 0.5)
    P["spine"] = (6 + 10 * abs(bob), 12 * bob, turn * 0.6)
    reach = 0.34 if eq != "bag" else 0.30
    for s, sg in SIDES:
        guard = Vector((sg * 0.10, -0.24, 1.66))
        punch = Vector((sg * 0.03, -0.20 - reach, 1.58))
        u = jab if s == "L" else cross
        P["hand" + s] = dict(pos=tuple(guard.lerp(punch, u)), space="chest", pole=(sg * 1, 0.3, -0.6),
                             aim=((0, -1, 0.1), tuple(Vector((-sg, 0, 0)).lerp(Vector((0, 0, -1)), ss(u)).normalized())),
                             shrug=6, flex=-10)
    P["grip"] = 1.0
    return P


@motion("bike", cam=CAM_SIDE, rep=0.9, reps=6, extra=[
    PAD((0, 0.22, 0.93), (0.16, 0.26, 0.05)), PAD((0, 0.14, 0.55), (0.05, 0.05, 0.75), (-12, 0, 0)),
    PAD((0, -0.50, 1.05), (0.50, 0.04, 0.04)), PAD((0, -0.40, 0.70), (0.05, 0.05, 0.75), (14, 0, 0)),
    PAD((0, -0.10, 0.36), (0.04, 0.46, 0.46)), PAD((0, -0.05, 0.03), (0.50, 0.90, 0.05))], mat=False)
def m_bike(ph, rep, ctx, eq):
    pz = ctx["poser"]
    P = dict(neck=(NECK_UP[0] - 20, 0, 0), head=HEAD_UP, spine=(10, 0, 0))
    place(pz, P, J(pz, "hipL", "hipR"), Vector((0, 0.20, 1.01)), (34, 0, 0))
    crank = Vector((0, -0.12, 0.36))
    for s, sg in SIDES:
        a = 2 * math.pi * ph + (0 if s == "L" else math.pi)
        pedal = crank + Vector((sg * 0.15, -0.17 * math.sin(a), 0.17 * math.cos(a)))
        P["foot" + s] = dict(pos=tuple(pedal + Vector((0, 0.03, 0.075))), rot=(10 * math.sin(a), 0, sg * 4),
                             pole=(sg * 0.15, -1, 0.3))
        P["hand" + s] = dict(palm=(sg * 0.22, -0.50, 1.07), pole=(sg * 0.6, 0.6, -1), aim=((0, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 1.0
    return P


@motion("rower", cam=CAM_SIDE, rep=2.4, reps=3, extra=[
    PAD((0, 0.05, 0.12), (0.12, 2.0, 0.08)), dict(type="box", size=(0.30, 0.30, 0.06), follow=("pelvis",),
                                                   offset=(0, 0.03, -0.17)),
    PAD((0, -0.72, 0.24), (0.40, 0.06, 0.26), (30, 0, 0)), PAD((0, -1.02, 0.40), (0.08, 0.40, 0.40)),
    dict(type="barbell", mode="hands", plates=0, length=0.5), dict(type="line", color="cable", hand="L", anchor=(0, -0.98, 0.48))],
    mat=False)
def m_rower(ph, rep, ctx, eq):
    pz = ctx["poser"]
    drive = keys(ph, [(0, 0.0), (0.38, 1.0), (0.48, 1.0), (1.0, 0.0)])
    arms = keys(ph, [(0, 0.0), (0.22, 0.0), (0.42, 1.0), (0.55, 1.0), (0.8, 0.0), (1.0, 0.0)])
    lean = lerp(24, -22, keys(ph, [(0, 0.0), (0.12, 0.0), (0.40, 1.0), (0.55, 1.0), (0.85, 0.0), (1.0, 0.0)]))
    hip_y = lerp(-0.22, 0.24, drive)
    P = dict(neck=NECK_UP, head=HEAD_UP)
    place(pz, P, J(pz, "hipL", "hipR"), Vector((0, hip_y, 0.37)), (lean, 0, 0))
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.12, -0.66, 0.26), rot=(-30, 0, sg * 6), pole=(sg * 0.25, -0.4, 1))
    sh = shoulders(ctx, P)
    for s, sg in SIDES:
        far = Vector((sg * 0.22, -0.62, 0.52))
        if (far - sh[s]).length > 0.62:
            far = Vector(clamp_reach(sh[s], far, 0.62))
        near = Vector((sg * 0.22, hip_y - 0.18, 0.88))
        P["hand" + s] = dict(palm=tuple(far.lerp(near, arms)), pole=(sg * 0.4, 0.8, -1), aim=((0, -1, 0), (0, 0, -1)),
                             shrug=0)
    P["grip"] = 1.0
    return P


@motion("kayak", cam=CAM_FLOOR, rep=1.8, reps=4, extra=[dict(type="barbell", mode="hands", plates=0, length=2.0)])
def m_kayak(ph, rep, ctx, eq):
    pz = ctx["poser"]
    w = math.sin(2 * math.pi * ph)
    P = seated_floor(pz, lean=4, hip_y=0.15)
    P["spine"] = (8, 0, 28 * w)
    for s, sg in SIDES:
        P["foot" + s] = dict(pos=(sg * 0.14, -0.62, 0.12), rot=(-60, 0, sg * 8), pole=(sg * 0.6, 0, 1))
    c = Vector((0, -0.42, 0.62))
    ax = Vector((math.cos(math.radians(28 * w)), math.sin(math.radians(28 * w)) * 0.6, -0.45 * w)).normalized()
    for s, sg in SIDES:
        P["hand" + s] = dict(palm=tuple(c + ax * sg * 0.32), pole=(sg * 0.6, 0.6, -1), aim=((0, -0.2, -1), (0, 1, -0.2)),
                             shrug=0)
    P["grip"] = 1.0
    return P


@motion("waiterWalk", cam=CAM_SIDE, rep=1.2, reps=5, extra=[dict(type="kettlebell", hand="R")])
def m_waiter(ph, rep, ctx, eq):
    P = gait(ph, stride=0.22, lift=0.07, bounce=0.012, arm=0.6, lean=2)
    P["handR"] = dict(palm=(-0.24, -0.02, 2.04), space="chest", pole=(-1, -0.3, -0.5), aim=((0, 0.1, 1), (0, -1, 0)), shrug=10)
    P["grip"] = 0.95
    return P


@motion("suitcase", cam=CAM_SIDE, rep=1.2, reps=5, extra=[dict(type="dumbbell", hand="R")])
def m_suitcase(ph, rep, ctx, eq):
    P = gait(ph, stride=0.22, lift=0.07, bounce=0.012, arm=0.6, lean=2)
    P["spine"] = (0, 4, P["spine"][2])
    P["handR"] = dict(hang=0.995, pole=(-0.2, 1, 0), aim=((0, 0, -1), (1, 0, 0)))
    P["grip"] = 0.95
    return P


@motion("getUp", cam=CAM_FLOOR, rep=6.0, reps=1, intro=0.6, extra=[dict(type="kettlebell", hand="R")])
def m_getup(ph, rep, ctx, eq):
    """Turkish get-up (first half): lying with the bell pressed up -> elbow -> hand -> tall sit, and back."""
    pz = ctx["poser"]
    st = keys(ph, [(0, 0.0), (0.25, 1.0), (0.45, 2.0), (0.6, 2.0), (0.8, 1.0), (1.0, 0.0)])
    lean = keys(st / 2.0, [(0, -90.0), (0.5, -48.0), (1.0, -10.0)])
    P = seated_floor(pz, lean=0, hip_y=0.20) if False else dict()
    rp = J(pz, "hipL", "hipR")
    place(pz, P, rp, Vector((0, 0.20, 0.11)), (lean, 0, 14 * min(1, st)))
    P["neck"] = (NECK_UP[0] + 10, -10, 0); P["head"] = HEAD_UP
    P["footL"] = dict(pos=(0.16, -0.66, 0.07), rot=(-75, 0, 8), pole=(0.1, 0, 1))
    P["footR"] = dict(pos=(-0.16, -0.25, 0.085), rot=(0, 0, -6), pole=(-0.3, -0.4, 1))
    sh = shoulders(ctx, P)
    P["handR"] = dict(pos=tuple(sh["R"] + Vector((0.02, 0.0, 0.56))), pole=(-0.6, 0.6, 0), aim=((0, 0, 1), (0, -1, 0)), shrug=8)
    tgt = sh["L"] + Vector((0.22, 0.12, 0.0)); tgt.z = 0.04
    hL = Vector(clamp_reach(sh["L"], tgt, 0.55)); hL.z = 0.04
    P["handL"] = dict(pos=tuple(hL), pole=(1, 0.4, 0.2), aim=((0.3, -1, 0), (0, 0, -1)), shrug=0)
    P["grip"] = 0.95
    return P


@motion("stairs", cam=CAM_SIDE, rep=1.6, reps=4, extra=[PAD((0, -0.30, 0.10), (0.9, 0.30, 0.20)),
                                                        PAD((0, -0.60, 0.20), (0.9, 0.30, 0.40))])
def m_stairs(ph, rep, ctx, eq):
    """stair climbing on the spot: alternating steps up onto the first step."""
    P = gait(ph, stride=0.16, lift=0.24, bounce=0.03, arm=0.7, lean=6)
    return P


# ============================================================================ family -> motion
# family index: (motion key, equipment, name fragment for a sanity check)
FAMILY = {
    1: ("chestPressMachine", "machine", "Brustpresse"),
    7: ("benchDips", "none", "Bank-Dips"),
    9: ("landmine", "barbell", "Landmine"),
    11: ("chestSqueeze", "none", "Brust-Squeeze"),
    16: ("oneArmRow", "dumbbell", "Gestütztes Rudern"),
    17: ("oneArmRow", "dumbbell", "auf der Bank"),
    21: ("deadlift", "barbell", "Kreuzheben (Langhantel)"),
    23: ("goodMorning", "barbell", "Good Morning"),
    24: ("hyperext", "machine", "Hyperextension"),
    25: ("reverseHyper", "machine", "Reverse Hyper"),
    27: ("yRaise", "dumbbell", "Y-Heben"),
    28: ("reverseFly", "dumbbell", "T-Heben"),
    29: ("shrug", "dumbbell", "Shrugs"),
    31: ("superman", "none", "Superman"),
    36: ("reverseFly", "dumbbell", "Reverse Fly"),
    37: ("rotation", "dumbbell", "Außenrotation"),
    38: ("rotation", "internal", "Innenrotation"),
    39: ("pikePushup", "none", "Pike"),
    40: ("hspu", "none", "Handstand-Liegest"),
    41: ("handstand", "none", "Handstand (K"),
    42: ("bearCrawl", "none", "Bear Walk"),
    44: ("concCurl", "dumbbell", "Konzentrations"),
    45: ("preacher", "barbell", "Preacher"),
    48: ("cableCurlHigh", "cable", "über Kopf"),
    56: ("skull", "barbell", "JM Press"),
    59: ("floorTriExt", "none", "Trizeps-Extension am Boden"),
    60: ("wristCurl", "dumbbell", "Handgelenk-Curl"),
    63: ("forearmRoller", "none", "Fingerhantel"),
    64: ("idle", "dumbbell", "Plate Pinch"),
    65: ("forearmRoller", "none", "Unterarm-Rollen"),
    66: ("neckIso", "none", "Nackenstärkung"),
    71: ("pistol", "none", "Pistol"),
    72: ("bulgarian", "dumbbell", "Bulgarian"),
    74: ("stepUp", "dumbbell", "Step-ups"),
    75: ("legPress", "machine", "Beinpresse"),
    76: ("squat", "barbell", "Hackenschmidt"),
    77: ("legExtension", "machine", "Beinstrecker"),
    78: ("sissy", "none", "Sissy"),
    79: ("wallSit", "none", "Wall Sit"),
    80: ("legCurlProne", "machine", "Beinbeuger (Maschine)"),
    81: ("nordic", "none", "Nordic"),
    82: ("hipThrust", "barbell", "Hip Thrust"),
    84: ("cableKickback", "cable", "Kickback (Kabelzug)"),
    85: ("abductor", "machine", "Abduktion"),
    86: ("abductor", "add", "Adduktion"),
    87: ("frogPump", "none", "Frosch"),
    90: ("legPress", "calf", "an der Beinpresse"),
    91: ("tibRaise", "none", "Schienbein"),
    98: ("russianTwist", "none", "Russian Twist"),
    99: ("woodChop", "cable", "Holzhacker"),
    100: ("pallof", "cable", "Pallof"),
    101: ("abRollout", "machine", "Ab Rollout"),
    102: ("sideBendDB", "dumbbell", "Seitbeugen"),
    103: ("sidePlank", "none", "Seitstütz"),
    105: ("toeTouchLying", "none", "Toe Touch"),
    106: ("boat", "none", "V-Sit"),
    107: ("lSit", "none", "L-Sit"),
    108: ("dragonFlag", "none", "Dragon Flag"),
    109: ("frontLever", "bar", "Front Lever"),
    110: ("humanFlag", "bar", "Human Flag"),
    111: ("seatedCrunch", "machine", "Bauchmaschine"),
    112: ("hyperext", "machine", "Rückenstrecker"),
    113: ("birdDog", "none", "Bird Dog"),
    114: ("plankSwim", "none", "Plank Swim"),
    115: ("suitcase", "dumbbell", "Suitcase"),
    116: ("waiterWalk", "kettlebell", "Waiter"),
    119: ("bike", "bike", "Radfahren"),
    120: ("rower", "cardio", "Rudern (Cardio"),
    121: ("swimming", "none", "Schwimmen"),
    128: ("jumpSquat", "none", "Sprung"),
    129: ("plyoPushup", "none", "Plyo"),
    5: ("plyoPushup", "none", "explosiv"),
    131: ("snatch", "barbell", "Reißen"),
    132: ("clean", "barbell", "Umsetzen"),
    133: ("jerk", "barbell", "Stoßen"),
    135: ("getUp", "kettlebell", "Turkish"),
    138: ("sledPush", "none", "Schlitten"),
    139: ("battleRope", "none", "Battle Rope"),
    142: ("squat", "medball", "Sandsack-Training"),
    145: ("boxing", "none", "Schattenboxen"),
    146: ("boxing", "bag", "Sandsack-Schlagen"),
    148: ("boxing", "dodge", "Ausweichen"),
    149: ("bearCrawl", "none", "Bärengang"),
    153: ("stepUp", "none", "Treppen"),
    157: ("kayak", "none", "Kajak"),
    171: ("foamRoll", "foam", "Faszienrolle"),
}

OWN_PROPS = {"chestPressMachine", "benchDips", "landmine", "oneArmRow", "hyperext", "reverseHyper", "legPress",
             "legExtension", "legCurlProne", "nordic", "hipThrust", "cableKickback", "abductor", "seatedCrunch",
             "woodChop", "pallof", "abRollout", "sideBendDB", "frontLever", "humanFlag", "bike", "rower", "kayak",
             "waiterWalk", "suitcase", "getUp", "sledPush", "battleRope", "foamRoll", "preacher", "concCurl",
             "wallSit", "sissy", "bulgarian", "stepUp", "dragonFlag", "forearmRoller", "stairs", "boxing"}


def family_motion(fi, name, motion_key, eq):
    """(generator key, equipment) to animate family `fi` with."""
    e = FAMILY.get(fi)
    if not e:
        return motion_key, eq
    key, eqx, frag = e
    if frag not in name:
        return motion_key, eq          # family list changed: keep the app's motion
    return key, eqx


def extra_props(key, eq):
    """equipment-dependent props of the family motions."""
    out = []
    if key == "boxing" and eq == "bag":
        out.append(PAD((0.0, -0.80, 1.25), (0.36, 0.36, 1.0)))
        out.append(PAD((0.0, -0.80, 2.2), (0.03, 0.03, 0.9)))
    if key == "stepUp" and eq in ("dumbbell", "kettlebell"):
        out += [dict(type=eq, hand="L"), dict(type=eq, hand="R")]
    if key in ("deadlift", "clean", "snatch", "jerk"):
        out.append(dict(type="barbell", mode="hands", plates=2, length=2.2))
    if key == "goodMorning":
        out.append(dict(type="barbell", mode="chest", pos=(0, 0.075, 1.50), plates=2))
    if key == "rotation" and eq == "internal":
        out += [dict(type="cable_tower", loc=(1.0, 0.0, 0)),
                dict(type="line", color="cable", hand="L", anchor=(0.92, -0.25, 1.05))]
    return out
