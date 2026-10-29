import sys, time, os; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C
S.reset(); sc=bpy.context.scene
eng=sys.argv[-1]
S.setup_render(sc, 720, 1280, samples=16 if eng=="CYCLES" else 32, engine=eng)
ob, rig = C.build_character()
ob.data.materials.append(S.mat_porcelain(muscles=["quads"]))
S.build_studio(); S.add_mat(); S.add_rack(); bb=S.add_barbell(); bb.location=(0,0.07,1.5)
cam,tgt=S.add_camera(loc=(0,-4.6,1.3),target=(0,0,1.0),lens=40)
for i in range(3):
    t=time.time(); sc.render.filepath=f"out/speed_{eng}_{i}.png"; bpy.ops.render.render(write_still=True); print(eng,"frame",i,round(time.time()-t,1))
