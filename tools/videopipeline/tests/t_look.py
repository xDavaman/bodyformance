import sys, os; sys.path.insert(0, '.')
import bpy
from fitanim import director as D
sh = D.Shot("squat", "draft").build(); n=sh.bake()
fps=30; f_bot=int((sh.ex.intro+sh.ex.rep_time*0.47)*fps)+1
sh.render("out/look", frames=[f_bot])
sh.scene.frame_set(f_bot)
sh.cam.animation_data_clear(); sh.cam_tgt.animation_data_clear()
sh.cam.location=(0.6,-1.4,1.55); sh.cam_tgt.location=(0.3,0,1.3); sh.cam.data.lens=50
sh.scene.render.filepath="out/look/hands.png"; bpy.ops.render.render(write_still=True)
