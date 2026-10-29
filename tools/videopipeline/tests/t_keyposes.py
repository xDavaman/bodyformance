import sys, os, time; sys.path.insert(0, '.')
import bpy
from fitanim import director as D
keys = sys.argv[sys.argv.index("--")+1:] if "--" in sys.argv else list(D.EX.LIBRARY)
for k in keys:
    t=time.time()
    sh = D.Shot(k, "preview").build()
    sh.scene.cycles.samples = 6
    n = sh.bake()
    fps = sh.scene.render.fps
    ex = sh.ex
    f_top = 1
    f_mid = int((ex.intro + ex.rep_time*0.2)*fps)+1
    f_bot = int((ex.intro + ex.rep_time*0.47)*fps)+1
    sh.render(f"out/kp/{k}", frames=[f_top, f_mid, f_bot])
    print("DONE", k, round(time.time()-t,1))
