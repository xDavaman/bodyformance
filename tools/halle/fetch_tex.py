"""Lädt die Poly-Haven-Texturen (CC0) der Boxhalle nach zwischen/tex (diff/nor/rough je 2k, HDR 2k)."""
import json, os, sys, urllib.request

T = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tex")
SLUGS = ["red_brick_03", "peeling_painted_wall", "old_wooden_floor_02", "concrete_wall_006", "rusty_painted_metal",
         "fabric_leather_02", "brown_leather", "green_metal_rust", "old_planks_02", "rubber_tiles"]
H = {"User-Agent": "BFC-Gym/1.0"}

def get(url):
    return urllib.request.urlopen(urllib.request.Request(url, headers=H), timeout=60).read()

for s in SLUGS:
    d = os.path.join(T, s); os.makedirs(d, exist_ok=True)
    files = json.loads(get("https://api.polyhaven.com/files/" + s))
    for key, name in (("Diffuse", "diff.jpg"), ("nor_gl", "nor.jpg"), ("Rough", "rough.jpg")):
        p = os.path.join(d, name)
        if os.path.exists(p):
            continue
        try:
            open(p, "wb").write(get(files[key]["2k"]["jpg"]["url"]))
        except KeyError:
            print("fehlt", s, key)
    print("ok", s, flush=True)
hdr = os.path.join(T, "urban_street_01.hdr")
if not os.path.exists(hdr):
    open(hdr, "wb").write(get(json.loads(get("https://api.polyhaven.com/files/urban_street_01"))["hdri"]["2k"]["hdr"]["url"]))
print("FERTIG")
