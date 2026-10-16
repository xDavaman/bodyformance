"""Backen: Bewegungen aus der Bibliothek in FitScan_Motions.bin schreiben und BodyMotions.swift erzeugen.

Bestehende Bewegungen in der .bin-Datei bleiben unverändert; gleichnamige werden ersetzt, neue angehängt.
BodyMotions.swift behält alle vorhandenen Einträge und bekommt die neuen dazu.
"""

from __future__ import annotations

import argparse
import re
import struct
import time
from pathlib import Path

import numpy as np

from .clip import bake
from .pose import Rig
from .rig import MOTIONS, ROOT

MAGIC = 0x314D5346
SWIFT = ROOT / "FitScan" / "BodyMotions.swift"
FPS = 20  # Dehnungen und Halteübungen sind langsam; die App interpoliert zwischen den Bildern
PROP_CASE = {"roller": "roller", "ball": "ball", "post": "post", "step": "step"}


def read_bin(path: Path) -> tuple[int, dict[str, bytes]]:
    d = path.read_bytes()
    magic, nb, nm = struct.unpack_from("<III", d, 0)
    if magic != MAGIC:
        raise ValueError("unbekanntes Format")
    o = 12
    out = {}
    for _ in range(nm):
        name = d[o:o + 24].split(b"\0")[0].decode()
        nf, _, npr = struct.unpack_from("<IfI", d, o + 24)
        size = 36 + nf * nb * 14 + nf * npr * 14
        out[name] = d[o:o + size]
        o += size
    return nb, out


def encode(baked, key: str, period: float) -> bytes:
    nf, nb = baked.rot.shape[:2]
    npr = baked.prop_pos.shape[1]
    name = key.encode()
    if len(name) > 23:
        raise ValueError(f"Name zu lang: {key}")
    head = name.ljust(24, b"\0") + struct.pack("<IfI", nf, period, npr)

    def block(pos, rot):
        p = np.clip(np.round(pos * 10000), -32767, 32767).astype("<i2")
        q = np.clip(np.round(rot * 32767), -32767, 32767).astype("<i2")
        return np.concatenate([p, q], axis=-1).tobytes()
    return head + block(baked.pos, baked.rot) + block(baked.prop_pos, baked.prop_rot)


def write_bin(path: Path, nb: int, clips: dict[str, bytes]) -> None:
    out = [struct.pack("<III", MAGIC, nb, len(clips))]
    out += list(clips.values())
    path.write_bytes(b"".join(out))


def motion_line(c) -> str:
    kinds = [p.kind for p in c.props]
    props = PROP_CASE.get(kinds[0], "none") if kinds else c.app_props
    roots = [p["root"][1] for _, p in c.keys if "root" in p]
    standing = bool(roots) and min(roots) > 0.75 and c.ground
    free = c.free and not standing
    wall = "nil" if c.wall_z is None else f"{c.wall_z}"
    return (f"        .{c.key}: Motion(period: {c.period}, lying: {str(c.lying).lower()}, bench: "
            f"{str(c.bench).lower()}, free: {str(free).lower()}, wallZ: {wall}, yaw: {c.yaw}, camY: {c.cam_y}, "
            f"props: .{props}),")


def write_swift(clips) -> None:
    src = SWIFT.read_text()
    cases = re.findall(r"^    case (\w+)$", src, re.M)
    lines = re.findall(r"^        \.(\w+): Motion\(.*\),$", src, re.M)
    lib = dict(zip(lines, re.findall(r"^(        \.\w+: Motion\(.*\),)$", src, re.M)))
    for c in clips:
        if c.key not in cases:
            cases.append(c.key)
        lib[c.key] = motion_line(c)
    body = ["// AUTOMATISCH ERZEUGT (tools/motions, python -m motions backen) – Beschreibung der Übungsbewegungen.",
            "// Die Gelenkdaten stehen in FitScan_Motions.bin.",
            "import simd", "", "enum BodyMotion: String, CaseIterable {"]
    body += [f"    case {k}" for k in cases]
    body += ["}", "", "extension BodyRig {", "    static let library: [BodyMotion: Motion] = ["]
    body += [lib[k] for k in cases if k in lib]
    body += ["    ]", "}", ""]
    SWIFT.write_text("\n".join(body))


def main(argv: list[str]) -> None:
    ap = argparse.ArgumentParser(prog="python -m motions")
    sub = ap.add_subparsers(dest="cmd", required=True)
    pv = sub.add_parser("vorschau", help="Bildreihen zum Prüfen")
    pv.add_argument("namen", nargs="*")
    pv.add_argument("--ziel", default=str(Path(__file__).parent / "vorschau"))
    bk = sub.add_parser("backen", help="in die App schreiben")
    bk.add_argument("namen", nargs="*", help="nur diese Bewegungen (Standard: alle aus der Bibliothek)")
    bk.add_argument("--fps", type=float, default=FPS)
    a = ap.parse_args(argv)

    from . import library
    rig = Rig()
    chosen = [c for c in library.CLIPS if not a.namen or c.key in a.namen]
    if not chosen:
        raise SystemExit("keine passenden Bewegungen")

    if a.cmd == "vorschau":
        from .preview import sheet
        ziel = Path(a.ziel)
        ziel.mkdir(parents=True, exist_ok=True)
        for c in chosen:
            b = bake(rig, c)
            sheet(rig.sk, b, size=200, yaws=(25.0, 100.0), at_keys=True).save(ziel / f"{c.key}.png")
            print(f"{c.key}: Bodenkorrektur {b.lift.min():+.3f} … {b.lift.max():+.3f} m")
        return

    nb, existing = read_bin(MOTIONS)
    if nb != len(rig.sk):
        raise SystemExit(f"Gelenkzahl {nb} passt nicht zum Skelett ({len(rig.sk)})")
    for c in chosen:
        t = time.time()
        b = bake(rig, c, fps=a.fps)
        existing[c.key] = encode(b, c.key, c.period)
        print(f"{c.key:16s} {len(b.rot):4d} Bilder  {time.time() - t:4.1f} s")
    write_bin(MOTIONS, nb, existing)
    write_swift(chosen)
    print(f"{len(existing)} Bewegungen in {MOTIONS.name}, {SWIFT.name} aktualisiert")
