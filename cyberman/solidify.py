#!/usr/bin/env python3
"""Solidify the CyberMan shell into a printable solid.

cybermanV1_repaired.stl is a closed but paper-thin scanned shell (~0.2 mm
walls, 1.4 cm3 of "material" for a 15.8 cm3 outline). FDM can't print that,
so this rebuilds the model as a solid from its own cross-sections:

  1. section the mesh every `--step` mm in Z
  2. union all loops in that section -> the true filled cross-section
     (this merges the coincident front/back walls into one region)
  3. rasterise those sections into a voxel mask
  4. marching cubes -> watertight solid mesh

usage: solidify.py in.stl out.stl [--pitch 0.25]
"""
import argparse
import time

import numpy as np
import scipy.ndimage as ndi
import shapely
import trimesh

ap = argparse.ArgumentParser()
ap.add_argument("src")
ap.add_argument("dst")
ap.add_argument("--pitch", type=float, default=0.25)
ap.add_argument("--height", type=float, default=90.0, help="target height in mm")
args = ap.parse_args()

m = trimesh.load(args.src, process=True)
if m.extents.max() < 10:  # metres -> mm
    m.apply_scale(1000.0)
    print("scaled metres -> mm")
if args.height > 0 and abs(m.extents[2] - args.height) > 0.5:
    m.apply_scale(args.height / m.extents[2])
    print(f"scaled to {args.height:.0f}mm tall")
lo, hi = m.bounds
p = args.pitch

xs = np.arange(lo[0] - p, hi[0] + p, p)
ys = np.arange(lo[1] - p, hi[1] + p, p)
zs = np.arange(lo[2] - p, hi[2] + p, p)
XX, YY = np.meshgrid(xs, ys, indexing="ij")
pts_x, pts_y = XX.ravel(), YY.ravel()

mask = np.zeros((len(xs), len(ys), len(zs)), dtype=bool)
t = time.time()
for k, z in enumerate(zs):
    sec = m.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    if sec is None:
        continue
    polys = [shapely.Polygon(l) for l in sec.discrete]
    polys = [q.buffer(0) for q in polys if q.is_valid or q.buffer(0).is_valid]
    polys = [q for q in polys if not q.is_empty and q.area > 0]
    if not polys:
        continue
    u = shapely.unary_union(polys)
    mask[:, :, k] = shapely.contains_xy(u, pts_x, pts_y).reshape(XX.shape)
    if k % 40 == 0:
        print(f"  z={z:6.1f}  area={u.area:7.1f} mm2  ({k}/{len(zs)})")
print(f"sectioned in {time.time() - t:.0f}s; solid volume "
      f"{mask.sum() * p ** 3 / 1000:.2f} cm3")

mask = ndi.binary_fill_holes(mask)
sm = ndi.gaussian_filter(mask.astype(np.float32), sigma=1.0)
solid = trimesh.voxel.ops.matrix_to_marching_cubes(sm > 0.5, pitch=p)
solid.apply_translation(lo - p)
solid.export(args.dst)
print(f"solid: {len(solid.faces)} faces, watertight={solid.is_watertight}, "
      f"volume {solid.volume / 1000:.2f} cm3, extents {solid.extents.round(1).tolist()}")
