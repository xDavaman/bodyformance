import sys, time, os; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C
t=time.time(); S.reset(); sc=bpy.context.scene
S.setup_render(sc, 360, 640, samples=16)
ob, rig = C.build_character()
print("built", time.time()-t, len(ob.data.vertices))
ob.data.materials.append(S.mat_porcelain(muscles=[]))
S.build_studio(); S.add_mat()
cam,tgt=S.add_camera(lens=55)
shots=[("front",(0,-3.0,1.25),(0,0,1.2)),("back",(0,3.0,1.25),(0,0,1.2)),("legs",(0.6,-2.6,0.6),(0,0,0.6)),("side",(3.0,-0.6,1.2),(0,0,1.2))]
for name,loc,tg in shots:
    cam.location=loc; tgt.location=tg
    sc.render.filepath=f"out/r2_{name}.png"; bpy.ops.render.render(write_still=True)
