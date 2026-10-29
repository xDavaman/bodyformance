import sys, os, time; sys.path.insert(0, '.')
import bpy
from fitanim import director as D
q=sys.argv[-3]; sub=int(sys.argv[-2]); samples=int(sys.argv[-1])
D.QUALITY[q]["subdiv"]=sub
sh = D.Shot("squat", q).build(); sh.bake()
c=sh.scene.cycles; c.samples=samples; c.max_bounces=4; c.diffuse_bounces=1; c.glossy_bounces=2
pass
pass
ts=[]
for f in (40,41,42):
    t=time.time(); sh.render("out/speed2", frames=[f]); ts.append(time.time()-t)
print("RESULT",q,sub,samples,[round(x,1) for x in ts])
