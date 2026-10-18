"""Haltungen beschreiben und in lokale Gelenkdrehungen umrechnen (wie FitScans posing.py, für das App-Skelett).

Eine Haltung ist ein dict mit Zahlen oder Zahlentupeln, damit sich zwei Haltungen Kanal für Kanal weich
überblenden lassen. Arme und Beine werden über Ziele gelöst (Zwei-Glied-IK mit Polrichtung), Rumpf, Hals und
Schlüsselbeine über Winkel. So stehen Hände und Füße genau dort, wo sie hinsollen (Boden, Wand, Stange), und
Ellbogen und Knie zeigen natürlich in die gewünschte Richtung.

Kanäle (alle optional, fehlende kommen aus `neutral()` bzw. aus der vorigen Schlüsselhaltung):
    root            (x, y, z)  Hüftgelenk in der Welt (Meter); y wird beim Backen auf den Boden gestellt
    body            (yaw, pitch, roll)  Drehung des Beckens; pitch > 0 kippt nach vorn, yaw > 0 dreht nach links
    turn            Grad Drehung um die Längsachse des Körpers (nach body), > 0 dreht die Brust nach links;
                    im Liegen rollt die Figur damit auf die Seite
    spine           (vor, seitlich links, Drehung links) Grad, verteilt auf drei Wirbel
    neck            (vor, seitlich links, Drehung links) Grad, verteilt auf Hals und Kopf
    clavL / clavR   (hoch, vor) Grad
    handL / handR   (x, y, z)  Ziel für das Handgelenk, im Raum `space[...]` (Standard: Brustkorb)
    elbowL / elbowR (x, y, z)  Richtung, in die der Ellbogen zeigt (im selben Raum)
    palmL / palmR   (Anteil flach, Richtung der Finger in Grad um die Hochachse)  1 = Handfläche flach auf dem Boden
    wristL / wristR (beugen, seitlich) Grad gegenüber dem Unterarm, wenn die Hand nicht flach liegt
    twistL / twistR Grad Drehung der Hand um den Unterarm (> 0 dreht den Daumen nach außen), z. B. damit die
                    Kurzhantel quer liegt
    gripL / gripR   0 … 1  Faust schließen
    footL / footR   (x, y, z)  Ziel für das Sprunggelenk (Standard: Welt)
    kneeL / kneeR   (x, y, z)  Richtung, in die das Knie zeigt
    soleL / soleR   (Anteil flach, Richtung der Zehen in Grad, Ferse hoch in Grad)
    ankleL / ankleR Grad Fuß strecken gegenüber dem Schienbein, wenn der Fuß nicht flach steht
    toesL / toesR   Grad Zehen beugen (z. B. auf den Fußballen im Liegestütz)

Räume: "world", "root" (Becken), "chest" (Brustkorb), "head".
"""

from __future__ import annotations

import math

import numpy as np

from .rig import (Skeleton, axis_angle, frame, from_quat, normalize, rot_x, rot_y, rot_z, skeleton, to_quat,
                  twist_about, two_bone)

SIDES = ("L", "R")
FINGERS = ("idx", "mid", "rng", "pnk")
SPINE_SHARE = {"spine1": 0.30, "spine2": 0.35, "spine3": 0.35}
NECK_SHARE = {"neck1": 0.35, "neck2": 0.35, "head": 0.30}
DEFAULT_SPACE = {"handL": "chest", "handR": "chest", "footL": "world", "footR": "world"}


def sgn(side: str) -> float:
    """+1 für links (+x), -1 für rechts."""
    return 1.0 if side == "L" else -1.0


class Limb:
    """Ruhegeometrie eines Arms oder Beins."""

    def __init__(self, sk: Skeleton, a: str, b: str, c: str, bend_hint):
        self.a, self.b, self.c = sk.i(a), sk.i(b), sk.i(c)
        pa, pb, pc = sk.pos(a), sk.pos(b), sk.pos(c)
        self.u0, self.f0 = pb - pa, pc - pb
        hint = self.f0 if bend_hint is None else np.asarray(bend_hint, float)
        self.F0 = frame(self.u0, hint)
        self.theta0 = math.atan2(self.f0 @ self.F0[:, 1], self.f0 @ self.F0[:, 0])


class Rig:
    def __init__(self, sk: Skeleton | None = None):
        self.sk = sk or skeleton()
        sk = self.sk
        self.arm = {s: Limb(sk, f"ua{s}", f"fa{s}", f"ha{s}", None) for s in SIDES}
        self.leg = {s: Limb(sk, f"th{s}", f"sh{s}", f"ft{s}", (0, 0, -1)) for s in SIDES}
        # Hand: Fingerrichtung, Handflächen-Normale (zeigt zur Seite, zu der sich die Finger schließen)
        self.hand0 = {}
        for s in SIDES:
            h = sk.pos(f"ha{s}")
            fingers = sk.pos(f"mid1{s}") - h
            across = sk.pos(f"idx1{s}") - sk.pos(f"pnk1{s}")
            n = normalize(np.cross(fingers, across))
            thumb = sk.pos(f"thb2{s}") - h
            if n @ thumb < 0:
                n = -n
            self.hand0[s] = (normalize(fingers), n)
        self.foot0 = {s: normalize(sk.pos(f"toe{s}") - sk.pos(f"ft{s}")) for s in SIDES}

    # ------------------------------------------------------------------ Grundhaltung

    def neutral(self) -> dict:
        """Lockerer Stand, Arme hängen, Füße hüftbreit."""
        sk = self.sk
        chest = sk.pos("spine3")
        p = {"root": (0.0, 0.96, 0.0), "body": (0.0, 0.0, 0.0), "turn": 0.0, "spine": (0.0, 0.0, 0.0),
             "neck": (0.0, 0.0, 0.0)}
        for s in SIDES:
            g = sgn(s)
            # Arme hängen locker: Schultern etwas gesenkt, Hände leicht vor den Oberschenkeln, Ellbogen zeigen nach
            # hinten, Handflächen zum Bein, Finger leicht gekrümmt
            p[f"clav{s}"] = (-4.0, 0.0)
            p[f"hand{s}"] = (g * 0.21, 0.93 - 0.08 - chest[1], 0.07 - chest[2])
            p[f"elbow{s}"] = (g * 0.1, 0.0, -1.0)
            p[f"palm{s}"] = (0.0, 0.0)
            p[f"wrist{s}"] = (0.0, 0.0)
            p[f"twist{s}"] = -20.0
            p[f"grip{s}"] = 0.3
            p[f"foot{s}"] = (g * 0.12, 0.08, -0.01)
            p[f"knee{s}"] = (g * 0.15, 0.0, 1.0)
            p[f"sole{s}"] = (1.0, g * 6.0, 0.0)
            p[f"ankle{s}"] = 0.0
            p[f"toes{s}"] = 0.0
        return p

    # ------------------------------------------------------------------ Lösen

    # Wie weit Beine und Arme beim Anpassen des Beckens höchstens gestreckt werden (Anteil der Länge). Fast ganz
    # gestreckt, damit die Knie im Stand nur locker gebeugt sind (bei 0,97 waren es fast 30°, die Figur stand wie
    # in einer leichten Hocke) und die Arme im Stütz oder Hang nicht unnatürlich angewinkelt bleiben.
    LEG_SLACK = 0.998
    ARM_SLACK = 0.99

    def fit_root(self, pose: dict, space: dict | None = None, slack: float | None = None, iters: int = 30) -> dict:
        """Schiebt das Becken so, dass alle Hand- und Fußziele in der Welt erreichbar sind (Beine höchstens zu
        LEG_SLACK, Arme zu ARM_SLACK gestreckt, oder beide zu `slack`). Ziele in Körper-Räumen bewegen sich mit
        und zählen nicht."""
        sk = self.sk
        sp = dict(DEFAULT_SPACE)
        if space:
            sp.update(space)
        # Füße haben Vorrang (sie tragen den Körper); Hände zählen nur, wenn keine Füße in der Welt stehen
        chains = []
        for group in (("foot", self.leg), ("hand", self.arm)):
            for s in SIDES:
                key, limb = f"{group[0]}{s}", group[1][s]
                if sp.get(key, "world") == "world":
                    k = slack if slack is not None else (self.LEG_SLACK if group[0] == "foot" else self.ARM_SLACK)
                    reach = (np.linalg.norm(limb.u0) + np.linalg.norm(limb.f0)) * k
                    chains.append((limb.a, np.asarray(pose[key], float), reach))
            if chains:
                break
        if not chains:
            return pose
        root = np.asarray(pose["root"], float).copy()
        loc = self._torso(pose)
        for _ in range(iters):
            _, wp = sk.world(loc, root)
            push = np.zeros(3)
            count = 0
            for joint, target, reach in chains:
                d = target - wp[joint]
                dist = np.linalg.norm(d)
                if dist > reach:
                    push += d / dist * (dist - reach)
                    count += 1
            if count == 0:
                break
            root += push / count
        out = dict(pose)
        out["root"] = tuple(root)
        return out

    def _torso(self, pose: dict) -> np.ndarray:
        sk = self.sk
        loc = np.repeat(np.eye(3)[None], len(sk), axis=0)
        yaw, pitch, roll = pose["body"]
        loc[sk.i("root")] = rot_y(yaw) @ rot_x(pitch) @ rot_z(-roll) @ rot_y(float(pose.get("turn", 0.0)))
        b, s_, t = pose["spine"]
        for name, w in SPINE_SHARE.items():
            loc[sk.i(name)] = rot_y(t * w) @ rot_x(b * w) @ rot_z(-s_ * w)
        for s in SIDES:
            up, fwd = pose[f"clav{s}"]
            g = sgn(s)
            loc[sk.i(f"clav{s}")] = rot_z(g * up) @ rot_y(-g * fwd)
        return loc

    def solve(self, pose: dict, space: dict | None = None):
        """Lokale Drehungen (J,3,3), Weltdrehungen, Weltpositionen für eine Haltung."""
        sk = self.sk
        sp = dict(DEFAULT_SPACE)
        if space:
            sp.update(space)
        n = len(sk)
        loc = np.repeat(np.eye(3)[None], n, axis=0)

        yaw, pitch, roll = pose["body"]
        loc[sk.i("root")] = rot_y(yaw) @ rot_x(pitch) @ rot_z(-roll) @ rot_y(float(pose.get("turn", 0.0)))
        b, s_, t = pose["spine"]
        for name, w in SPINE_SHARE.items():
            loc[sk.i(name)] = rot_y(t * w) @ rot_x(b * w) @ rot_z(-s_ * w)
        b, s_, t = pose["neck"]
        for name, w in NECK_SHARE.items():
            loc[sk.i(name)] = rot_y(t * w) @ rot_x(b * w) @ rot_z(-s_ * w)
        for s in SIDES:
            up, fwd = pose[f"clav{s}"]
            g = sgn(s)
            loc[sk.i(f"clav{s}")] = rot_z(g * up) @ rot_y(-g * fwd)

        root = np.asarray(pose["root"], float)
        wr, wp = sk.world(loc, root)

        def to_world(key: str, value, direction: bool = False) -> np.ndarray:
            v = np.asarray(value, float)
            name = sp.get(key, "world")
            if name == "world":
                return v
            j = {"root": "root", "chest": "spine3", "head": "head"}[name]
            r = wr[sk.i(j)]
            return r @ v if direction else wp[sk.i(j)] + r @ v

        # Arme: Schulterblatt-Rhythmus (über Schulterhöhe zieht das Schlüsselbein mit), dann IK
        for s in SIDES:
            limb = self.arm[s]
            g = sgn(s)
            target = to_world(f"hand{s}", pose[f"hand{s}"])
            pole = to_world(f"hand{s}", pose[f"elbow{s}"], direction=True)
            shoulder = wp[limb.a]
            chest_r = wr[sk.i("spine3")]
            elev = math.degrees(math.asin(float(np.clip(normalize(chest_r.T @ (target - shoulder))[1], -1, 1))))
            extra = float(np.clip(0.35 * (elev + 10.0), 0.0, 22.0))
            if extra > 0:
                up, fwd = pose[f"clav{s}"]
                ci = sk.i(f"clav{s}")
                loc[ci] = rot_z(g * (up + extra)) @ rot_y(-g * fwd)
                wr, wp = sk.world(loc, root)
            self._limb(loc, wr, wp, limb, target, pole)
            wr, wp = sk.world(loc, root)
            self._hand(loc, wr, s, pose)
            wr, wp = sk.world(loc, root)

        for s in SIDES:
            limb = self.leg[s]
            target = to_world(f"foot{s}", pose[f"foot{s}"])
            pole = to_world(f"foot{s}", pose[f"knee{s}"], direction=True)
            self._limb(loc, wr, wp, limb, target, pole)
            wr, wp = sk.world(loc, root)
            self._foot(loc, wr, s, pose)
            wr, wp = sk.world(loc, root)
        return loc, wr, wp

    def _limb(self, loc, wr, wp, limb: Limb, target, pole) -> None:
        sk = self.sk
        a = wp[limb.a]
        b = a + wr[sk.parent[limb.a]] @ (limb.u0)  # Lage vor dieser Lösung (nur für die Längen)
        c = b + limb.f0
        mid, end = two_bone(a, b, c, target, pole)
        u, f = mid - a, end - mid
        F = frame(u, f)
        theta = math.atan2(f @ F[:, 1], f @ F[:, 0])
        r_upper = F @ limb.F0.T
        parent = wr[sk.parent[limb.a]]
        loc[limb.a] = parent.T @ r_upper
        loc[limb.b] = axis_angle(limb.F0[:, 2], math.degrees(theta - limb.theta0))

    def _hand(self, loc, wr, s: str, pose) -> None:
        sk = self.sk
        fa = wr[sk.i(f"fa{s}")]
        fingers0, palm0 = self.hand0[s]
        flex_axis = normalize(np.cross(fingers0, palm0))
        flex, dev = pose[f"wrist{s}"]
        twist = float(pose.get(f"twist{s}", 0.0)) * sgn(s)
        rel = fa @ axis_angle(self.arm[s].f0, twist) @ axis_angle(flex_axis, flex) @ axis_angle(palm0, dev)
        flat, heading = pose[f"palm{s}"]
        if flat > 1e-3:
            d = rot_y(heading) @ np.array([0.0, 0.0, 1.0])
            F0 = frame(fingers0, palm0)
            Ft = frame(d, (0.0, -1.0, 0.0))
            target = Ft @ F0.T
            h = slerp(rel, target, float(np.clip(flat, 0, 1)))
        else:
            h = rel
        local = fa.T @ h
        loc[sk.i(f"ha{s}")] = local
        # Unterarm-Drehung zur Hälfte auf den Twist-Knochen, damit sich die Haut nicht verdrillt
        f_axis = self.arm[s].f0
        loc[sk.i(f"faTw{s}")] = axis_angle(f_axis, 0.5 * twist_about(local, f_axis))
        # Finger
        grip = float(pose[f"grip{s}"])
        for fn in FINGERS:
            for k, deg in zip((1, 2, 3), (55.0, 75.0, 50.0)):
                loc[sk.i(f"{fn}{k}{s}")] = axis_angle(flex_axis, grip * deg)
        for k, deg in zip((0, 1, 2), (10.0, 25.0, 30.0)):
            loc[sk.i(f"thb{k}{s}")] = axis_angle(flex_axis, grip * deg * 0.6)

    def _foot(self, loc, wr, s: str, pose) -> None:
        sk = self.sk
        shin = wr[sk.i(f"sh{s}")]
        lateral = np.array([1.0, 0.0, 0.0])
        rel = shin @ axis_angle(lateral, pose[f"ankle{s}"])
        flat, heading, heel = pose[f"sole{s}"]
        if flat > 1e-3:
            target = rot_y(heading) @ axis_angle(lateral, heel)
            r = slerp(rel, target, float(np.clip(flat, 0, 1)))
        else:
            r = rel
        loc[sk.i(f"ft{s}")] = shin.T @ r
        toes = pose[f"toes{s}"] + (flat * heel if flat > 1e-3 else 0.0)
        loc[sk.i(f"toe{s}")] = axis_angle(lateral, -toes)


def slerp(a: np.ndarray, b: np.ndarray, t: float) -> np.ndarray:
    qa, qb = to_quat(a), to_quat(b)
    if qa @ qb < 0:
        qb = -qb
    d = float(np.clip(qa @ qb, -1, 1))
    if d > 0.9995:
        q = qa + t * (qb - qa)
    else:
        th = math.acos(d)
        q = (math.sin((1 - t) * th) * qa + math.sin(t * th) * qb) / math.sin(th)
    return from_quat(q)


def merge(base: dict, **over) -> dict:
    p = dict(base)
    p.update(over)
    return p
