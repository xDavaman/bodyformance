"""Anatomical joint angles + range-of-motion (ROM) checks.

measure(pz, posed, P) returns clinically meaningful angles per side (degrees):
  shoulder: flex (+fwd / -ext), abd (+out / -across), elev (total), rot (+external / -internal)
  elbow:    flex, bend_ok (forearm bends towards the biceps side)
  forearm:  sup (+supination / -pronation)
  wrist:    flex (+palmar / -dorsal), dev (radial/ulnar, abs)
  hip:      flex (+fwd / -ext), abd (+out / -across), rot (+external / -internal)
  knee:     flex, bend_ok (shin bends backwards, no hyperextension)
  ankle:    dorsi (+dorsiflexion / -plantarflexion)
plus spine (bend/side/twist), neck (pitch/yaw/tilt) and shoulder shrug from the pose dict.

ROM limits follow common clinical norms (AAOS / Norkin & White), with a small tolerance;
`violations()` lists everything outside of them - "dislocated" looking joints.
"""
import math
from mathutils import Vector, Quaternion

# (min, max) in degrees.  Sources: AAOS joint motion norms, Norkin & White "Measurement of joint motion".
ROM = {
    "shoulder.flex": (-60, 180), "shoulder.abd": (-45, 180), "shoulder.rot": (-75, 100),
    "elbow.flex": (0, 150), "forearm.sup": (-85, 90),
    "wrist.flex": (-90, 80), "wrist.dev": (0, 35),   # extension up to ~90 under body weight (push-up/plank)
    "hip.flex": (-28, 130), "hip.abd": (-30, 50), "hip.rot": (-45, 50),
    "knee.flex": (0, 155), "ankle.dorsi": (-65, 45),   # dorsiflexion ~40-45 when loaded (lunge, squat)
    "spine.bend": (-55, 90), "spine.side": (-40, 40), "spine.twist": (-50, 50),
    "neck.pitch": (-65, 55), "neck.yaw": (-80, 80), "neck.tilt": (-45, 45),
    "shrug": (-15, 28),
    # elevation beyond the plane-dependent reach limit (see SH_LIM / HIP_LIM), must stay <= 0
    "shoulder.over": (-999, 0), "hip.over": (-999, 0),
}
# max. elevation (angle of the limb away from hanging straight down) per plane of elevation.
# plane azimuth: 0 = lateral (abduction), 90 = forward (flexion), 180/-180 = medial, -90 = backwards.
# derived from flexion 180 / abduction 180 / extension 60 / horizontal adduction 130 / horiz. abduction 45
SH_LIM = [(-180, 40), (-150, 30), (-90, 62), (-45, 125), (-25, 180), (150, 180), (180, 40)]
# hip: flexion 125 active / ~145 passive with the knee bent (deep squat incl. pelvic tilt), abduction 45,
# extension 25, adduction 30, flex+abd (frog/sumo) ~115
HIP_LIM = [(-180, 28), (-90, 28), (-30, 40), (0, 50), (45, 118), (90, 145), (135, 112), (180, 28)]
NEUTRAL_ANKLE = 78.4
FOREARM_BIAS = 18.0           # the hand mesh's palm normal is tilted ~18 deg against the true mid position
# planar projections are shown for orientation only; the plane-aware *.over checks replace them
DISPLAY_ONLY = {"shoulder.flex", "shoulder.abd", "hip.flex", "hip.abd"}          # shin->toe angle of the rest pose (deg)


def _lim(tab, az):
    for (a0, l0), (a1, l1) in zip(tab, tab[1:]):
        if a0 <= az <= a1:
            return l0 + (l1 - l0) * (az - a0) / max(a1 - a0, 1e-6)
    return tab[-1][1]


def _elev_plane(v, sg):
    """limb direction v in the trunk frame -> (elevation from straight down, plane azimuth)."""
    elev = math.degrees(Vector((0, 0, -1)).angle(v))
    az = math.degrees(math.atan2(-v.y, sg * v.x))
    return elev, az


def _rot(posed, pz, bone):
    return (posed[bone].to_3x3() @ pz.rest[bone].to_3x3().inverted()).to_quaternion()


def _signed(a, b, axis):
    """signed angle (deg) from a to b around axis (a, b already perpendicular to axis)."""
    if a.length < 1e-6 or b.length < 1e-6:
        return 0.0
    a = a.normalized(); b = b.normalized()
    ang = math.degrees(math.atan2(a.cross(b).dot(axis.normalized()), a.dot(b)))
    return ang


def _perp(v, axis):
    axis = axis.normalized()
    return v - axis * v.dot(axis)


def _swing_ref(d0, d, ref0):
    """reference vector ref0 carried along the minimal rotation d0 -> d."""
    q = d0.rotation_difference(d)
    return q @ ref0


def _twist(q, axis):
    p = Vector((q.x, q.y, q.z)).project(axis)
    t = Quaternion((q.w, p.x, p.y, p.z))
    if t.magnitude < 1e-8:
        return 0.0
    t.normalize()
    a = 2 * math.atan2(Vector((t.x, t.y, t.z)).dot(axis.normalized()), t.w)
    return (a + math.pi) % (2 * math.pi) - math.pi


def measure(pz, posed, P=None):
    out = {}
    T = _rot(posed, pz, "spine01")            # thorax orientation (rest -> posed)
    Pv = _rot(posed, pz, "root")              # pelvis orientation
    Ti, Pi = T.inverted(), Pv.inverted()
    tr = lambda b: posed[b].translation
    for s, sg in (("L", 1), ("R", -1)):
        o = {}
        sh, el, wr = tr(f"upperarm01.{s}"), tr(f"lowerarm01.{s}"), tr(f"wrist.{s}")
        h = Ti @ (el - sh).normalized()
        f = Ti @ (wr - el).normalized()
        o["shoulder.flex"] = math.degrees(math.atan2(-h.y, -h.z))
        o["shoulder.abd"] = math.degrees(math.atan2(sg * h.x, -h.z))
        o["shoulder.elev"], o["shoulder.plane"] = _elev_plane(h, sg)
        if 20 < o["shoulder.elev"] < 155:
            o["shoulder.over"] = o["shoulder.elev"] - _lim(SH_LIM, o["shoulder.plane"])
        elif o["shoulder.elev"] >= 155:
            o["shoulder.over"] = -1.0     # overhead (also slightly behind the head) is reachable from flexion
        # pure flex/abd only meaningful near their own plane
        if abs(h.x) > 0.5:
            o.pop("shoulder.flex")
        if abs(h.y) > 0.5:
            o.pop("shoulder.abd")
        flex_el = math.degrees(h.angle(f))
        o["elbow.flex"] = flex_el
        # humeral rotation (needs a bent elbow and an arm that is not straight up)
        if flex_el > 25 and o["shoulder.elev"] < 155:
            f0 = _perp(_swing_ref(Vector((0, 0, -1)), h, Vector((0, -1, 0))), h)
            o["shoulder.rot"] = -sg * _signed(f0, _perp(f, h), h)
        # elbow must bend towards the biceps (anterior surface of the upper arm)
        ua = _rot(posed, pz, f"upperarm02.{s}")
        ant = Ti @ (ua @ Vector((0, -1, 0)))
        if flex_el > 15:
            o["elbow.bend_ok"] = _perp(f, h).dot(_perp(ant, h)) > -0.2
        # forearm rotation + wrist: hand orientation relative to the untwisted forearm (lowerarm01).
        # rest pose (arms out, palms down, thumbs forward) = mid position / straight wrist.
        q2 = _rot(posed, pz, f"lowerarm01.{s}")
        wq = _rot(posed, pz, f"wrist.{s}")
        fw = (wr - el).normalized()
        sup, wfl, wdv, _ = pz.wrist_angles(s, wq, q2, fw)
        o["forearm.sup"] = sup
        o["wrist.flex"] = wfl
        o["wrist.dev"] = abs(wdv)
        # hip
        hp, kn, an = tr(f"upperleg01.{s}"), tr(f"lowerleg01.{s}"), tr(f"foot.{s}")
        g = Pi @ (kn - hp).normalized()
        sn = Pi @ (an - kn).normalized()
        o["hip.flex"] = math.degrees(math.atan2(-g.y, -g.z))
        o["hip.abd"] = math.degrees(math.atan2(sg * g.x, -g.z))
        o["hip.elev"], o["hip.plane"] = _elev_plane(g, sg)
        if o["hip.elev"] > 15:
            o["hip.over"] = o["hip.elev"] - _lim(HIP_LIM, o["hip.plane"])
        if abs(g.x) > 0.5:
            o.pop("hip.flex")
        if abs(g.y) > 0.5:
            o.pop("hip.abd")
        kf = math.degrees(g.angle(sn))
        o["knee.flex"] = kf
        if kf > 25 and math.degrees(Vector((0, 0, -1)).angle(g)) < 155:
            s0 = _perp(_swing_ref(Vector((0, 0, -1)), g, Vector((0, 1, 0))), g)
            # external rotation turns the knee outwards -> the (backward pointing) shin swings medially
            o["hip.rot"] = sg * _signed(s0, _perp(sn, g), g)
        th = _rot(posed, pz, f"upperleg02.{s}")
        post = Pi @ (th @ Vector((0, 1, 0)))
        if kf > 15:
            o["knee.bend_ok"] = _perp(sn, g).dot(_perp(post, g)) > -0.2
        toe = posed.get(f"toe1-1.{s}")
        if toe is not None:
            fd = (toe.translation - an).normalized()
            o["ankle.dorsi"] = math.degrees((an - kn).normalized().angle(fd)) - NEUTRAL_ANKLE
        out[s] = o
    if P is not None:
        b, sd, tw = P.get("spine", (0, 0, 0))
        out["spine.bend"], out["spine.side"], out["spine.twist"] = b, sd, tw
        n = P.get("neck", (0, 0, 0)); hdr = P.get("head", (0, 0, 0))
        out["neck.pitch"] = n[0] + hdr[0] + 30          # NECK_UP (-30) is the visual neutral
        out["neck.yaw"] = n[1] + hdr[1]
        out["neck.tilt"] = n[2] + hdr[2]
        for s in "LR":
            hnd = P.get("hand" + s, {})
            if "shrug" in hnd:
                out[s]["shrug"] = hnd["shrug"]
    return out


def violations(m, tol=1.0):
    """[(joint, side, value, (lo, hi))] outside ROM (+tol deg); booleans *_ok False are reported too."""
    v = []
    for s in ("L", "R"):
        for k, val in m.get(s, {}).items():
            if k.endswith("_ok"):
                if val is False:
                    v.append((k, s, 0.0, None))
                continue
            if k in ROM and k not in DISPLAY_ONLY:
                lo, hi = ROM[k]
                if val < lo - tol or val > hi + tol:
                    v.append((k, s, val, (lo, hi)))
    for k in ("spine.bend", "spine.side", "spine.twist", "neck.pitch", "neck.yaw", "neck.tilt"):
        if k in m:
            lo, hi = ROM[k]
            if m[k] < lo - tol or m[k] > hi + tol:
                v.append((k, "", m[k], (lo, hi)))
    return v


def excess(val, rng):
    lo, hi = rng
    return max(lo - val, val - hi, 0.0)
