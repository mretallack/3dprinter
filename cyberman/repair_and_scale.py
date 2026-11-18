#!/usr/bin/env python3
"""Repair + rescale the CyberMan model.

The raw scan/export has 67 open boundaries, ~480 non-manifold edges, 140+
stray shells and is in metres (0.56 x 0.25 x 1.0 -> 558 x 246 x 1002 mm).

Steps:
  1. merge duplicate verts, drop degenerate/duplicate faces
  2. pymeshfix (MeshFix): fill holes, remove self-intersections, join the
     stray shells back into the body -> watertight, consistent winding
  3. convert metres -> mm
  4. optionally scale to a target height so it fits the printer

usage: repair_and_scale.py [in.stl] [--height MM]
"""
import argparse
import time

import numpy as np
import pymeshfix
import trimesh

ap = argparse.ArgumentParser()
ap.add_argument("src", nargs="?", default="cybermanV1.stl")
ap.add_argument("--height", type=float, default=90.0,
                help="target height in mm (0 = keep original size)")
args = ap.parse_args()

m = trimesh.load(args.src, process=True)
m.merge_vertices()
m.update_faces(m.nondegenerate_faces())
m.update_faces(m.unique_faces())
m.remove_unreferenced_vertices()
print(f"cleaned   : {len(m.faces)} faces, watertight={m.is_watertight}")

mf = pymeshfix.MeshFix(np.asarray(m.vertices, dtype=np.float64),
                       np.asarray(m.faces, dtype=np.int32))
print(f"boundaries: {mf.n_boundaries}")
t = time.time()
mf.repair(joincomp=True, remove_smallest_components=True)
print(f"meshfix   : {time.time() - t:.0f}s, boundaries now {mf.n_boundaries}")

out = trimesh.Trimesh(np.asarray(mf.points), np.asarray(mf.faces), process=True)
out.export("cybermanV1_repaired.stl")
print(f"repaired  : {len(out.faces)} faces, watertight={out.is_watertight}, "
      f"winding={out.is_winding_consistent}")

# metres -> mm
out.apply_scale(1000.0)
print(f"mm scale  : extents {out.extents.round(1).tolist()}")

if args.height > 0:
    f = args.height / out.extents[2]
    out.apply_scale(f)
    out.export(f"cybermanV1_{args.height:.0f}mm.stl")
    print(f"scaled    : x{f:.5f} -> extents {out.extents.round(1).tolist()}, "
          f"volume {out.volume / 1000:.1f} cm3")
