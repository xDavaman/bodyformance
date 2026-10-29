import sys, os; sys.path.insert(0, '.')
import bpy
from fitanim import director as D
args=sys.argv[sys.argv.index("--")+1:]
k=args[0]; cam=args[1] if len(args)>1 and args[1]!="-" else None; nfr=int(args[2]) if len(args)>2 else 6
sh = D.Shot(k, "preview", camera=cam).build(); sh.scene.cycles.samples=4; sh.bake()
fps=30; ex=sh.ex
frames=[int((ex.intro + ex.rep_time*i/nfr)*fps)+1 for i in range(nfr)]
d=f"out/strip/{k}_{cam or 'def'}"; sh.render(d, frames=frames)
