import sys, time, os; sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import bpy, math
from fitanim import scene as S, character as C
t=time.time()
S.reset(); sc=bpy.context.scene
S.setup_render(sc, 360, 640, samples=16)
ob, rig = C.build_character()
print("char built", time.time()-t, "height", max(v.co.z for v in ob.data.vertices))
ob.data.materials.append(S.mat_porcelain(muscles=["quads","glutes"]))
ob.active_material.node_tree.nodes["HL"].outputs[0].default_value=1.0
S.build_studio(); S.add_mat(text="FITANIM")
cam,tgt=S.add_camera(loc=(0,-5.5,1.0), target=(0,0,0.95), lens=55)
for name,loc in [("front",(0,-5.5,1.0)),("side",(5.5,0,1.0)),("back",(0,5.5,1.0)),("head",(0.8,-1.6,1.65))]:
    cam.location=loc
    if name=="head": tgt.location=(0,0,1.62)
    sc.render.filepath=f"out/rest_{name}.png"; t=time.time()
    bpy.ops.render.render(write_still=True); print(name, time.time()-t)
bpy.ops.wm.save_as_mainfile(filepath=os.path.abspath("out/rest.blend"))
