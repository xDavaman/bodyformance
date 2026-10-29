import sys, os; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C, poser as PZ
S.reset(); sc=bpy.context.scene
S.setup_render(sc, 360, 360, samples=8)
ob, rig = C.build_character(subdiv=1)
ob.data.materials.append(S.mat_porcelain())
S.build_studio()
cam,tgt=S.add_camera(loc=(1.2,-1.6,2.2),target=(0,-0.3,1.3),lens=40)
pz=PZ.Poser(rig)
P=dict(neck=(-14,0,0),head=(-6,0,0),handL=dict(pos=(0.25,-0.5,1.3),pole=(0.3,1,-0.5),aim=((0,-1,0),(0,0,-1))),
       handR=dict(pos=(-0.25,-0.5,1.3),pole=(-0.3,1,-0.5),aim=((0,-1,0),(0,0,1))), grip=0.1)
posed=pz.solve(P); pz.apply(posed)
for s in "LR": print(s, posed["_palm"+s])
sc.render.filepath="out/hand.png"; bpy.ops.render.render(write_still=True)
cam.location=(3,0.3,1.3); tgt.location=(0,-0.1,1.3); sc.render.filepath="out/hand_side.png"; bpy.ops.render.render(write_still=True)
