import sys, time, os; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C, poser as PZ
S.reset(); sc=bpy.context.scene
S.setup_render(sc, 270, 480, samples=8)
ob, rig = C.build_character(subdiv=1)
ob.data.materials.append(S.mat_porcelain())
S.build_studio()
cam,tgt=S.add_camera(loc=(2.6,-3.6,1.1),target=(0,0,0.9),lens=45)
pz=PZ.Poser(rig)
print({k:round(v[0]+v[1],3) for k,v in pz.arm_len.items()}, pz.J['shoulderL'], pz.J['hipL'])
poses = {
 "neutral": dict(handL=dict(pos=(0.25,0.0,0.86),pole=(0,1,0)), handR=dict(pos=(-0.25,0.0,0.86),pole=(0,1,0))),
 "bend_neckpos": dict(spine=(30,0,0), neck=(30,0,0), head=(20,0,0)),
 "squat": dict(hips=(0,0.12,-0.42), hips_rot=(25,0,0), spine=(-10,0,0), footL=dict(pos=(0.2,-0.016,0.074),knee_out=15), footR=dict(pos=(-0.2,-0.016,0.074),knee_out=15),
               handL=dict(pos=(0.30,0.05,1.08)), handR=dict(pos=(-0.30,0.05,1.08)), grip=1.0),
 "twist_grip": dict(handL=dict(pos=(0.4,-0.3,1.2),twist=90), handR=dict(pos=(-0.4,-0.3,1.2),twist=-90), grip=1.0),
}
for n,P in poses.items():
    posed=pz.solve(P); pz.apply(posed)
    sc.render.filepath=f"out/p_{n}.png"; bpy.ops.render.render(write_still=True)
