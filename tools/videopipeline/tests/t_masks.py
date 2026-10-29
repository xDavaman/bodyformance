import sys, os, math; sys.path.insert(0, '.')
import bpy
from fitanim import scene as S, character as C, poser as PZ, exercises as EX
S.reset(); sc=bpy.context.scene
S.setup_render(sc, 300, 540, samples=8)
ob, rig = C.build_character(subdiv=1)
S.build_studio()
pz=PZ.Poser(rig); pz.apply(pz.solve(EX.arms_down(EX.stand(0.13,6),0.27,0.87)))
cd=bpy.data.cameras.new("c"); cd.type="ORTHO"; cd.ortho_scale=2.0
cam=bpy.data.objects.new("c",cd); sc.collection.objects.link(cam); sc.camera=cam
groups={"front":["quads","adductors","biceps","delts","chest","abs","obliques","forearms"],
        "back":["hamstrings","glutes","calves","triceps","lats","traps","lowerback"]}
for i,(view,gs) in enumerate(groups.items()):
    ob.data.materials.clear()
    m=S.mat_porcelain(muscles=gs); m.node_tree.nodes["HL"].outputs[0].default_value=1
    ob.data.materials.append(m)
    cam.location=(0,-6 if view=="front" else 6,0.97); cam.rotation_euler=(math.radians(90),0,0 if view=="front" else math.pi)
    sc.render.filepath=f"out/mask_{view}.png"; bpy.ops.render.render(write_still=True)
