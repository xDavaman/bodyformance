import sys, os; sys.path.insert(0, '.')
import bpy
from fitanim import director as D
sh = D.Shot("press", "preview").build(); sh.scene.cycles.samples=6; sh.bake()
sh.cam.animation_data_clear(); sh.cam_tgt.animation_data_clear()
fps=30; ex=sh.ex
fr=[int((ex.intro+ex.rep_time*t)*fps)+1 for t in (0.0,0.18,0.42)]
for view,loc in (("f",(0,-2.6,1.6)),("q",(1.8,-1.9,1.7))):
    sh.cam.location=loc; sh.cam_tgt.location=(0,0,1.45); sh.cam.data.lens=45
    for f in fr:
        sh.scene.frame_set(f); sh.scene.render.filepath=f"out/press_fix/{view}_{f:03d}.png"; bpy.ops.render.render(write_still=True)
