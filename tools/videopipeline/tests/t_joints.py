import sys, os; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C
S.reset()
ob, rig = C.build_character(subdiv=0)
for k,v in ob["fitanim_joints"].items(): print(k, [round(x,3) for x in v])
import numpy as np
P=np.array([v.co[:] for v in ob.data.vertices])
for z in [0.3,0.5,0.8,1.0,1.2,1.35,1.45]:
    s=P[np.abs(P[:,2]-z)<0.01]; c=s[np.abs(s[:,0])<0.25] if z>0.9 else s
    print('z',z,'xrange',c[:,0].min().round(3),c[:,0].max().round(3),'yrange',c[:,1].min().round(3),c[:,1].max().round(3))
for b in rig.data.bones:
    if b.name in ('upperarm01.L','lowerarm01.L','upperleg01.L','lowerleg01.L','spine01','neck01','head','root','clavicle.L','foot.L','wrist.L'):
        print(b.name, 'head',[round(x,3) for x in b.head_local],'x',[round(x,2) for x in b.x_axis],'y',[round(x,2) for x in b.y_axis],'z',[round(x,2) for x in b.z_axis], 'parent', b.parent.name if b.parent else None)
print('---')
for b in rig.data.bones:
    if b.name in ('upperarm01.L','upperarm02.L','lowerarm01.L','lowerarm02.L','upperleg01.L','upperleg02.L','lowerleg01.L','lowerleg02.L','spine05','spine01','neck01','head','root','pelvis.L','clavicle.L','shoulder01.L','foot.L','toe1-1.L','wrist.L'):
        M=b.matrix_local.to_3x3()
        print(f"{b.name:14s} h {[round(x,3) for x in b.head_local]} t {[round(x,3) for x in b.tail_local]} X {[round(x,2) for x in M.col[0]]} Z {[round(x,2) for x in M.col[2]]} par {b.parent.name if b.parent else None}")
