# CyberMan V1

Source model as received (`cybermanV1.stl` + `CyberManV1.glb`).

## Why it needs work

The raw export is not printable as-is:

| issue | detail |
| --- | --- |
| units | metres, not mm — 0.56 x 0.25 x 1.00 (i.e. 558 x 246 x 1002 mm) |
| not watertight | 67 open boundaries, ~480 non-manifold edges, 142 separate shells |
| paper thin | it is a *shell*: outer + coincident inner surface, ~0.2 mm apart. 1.4 cm3 of material for a 15.8 cm3 outline, so it slices as bare perimeters with no infill |

## Pipeline

```
python3 repair_and_scale.py cybermanV1.stl --height 90   # -> cybermanV1_repaired.stl, cybermanV1_90mm.stl
python3 solidify.py cybermanV1_90mm.stl cybermanV1_solid_90mm.stl --pitch 0.3
```

* `repair_and_scale.py` — merge verts, drop degenerate/duplicate faces, then
  [pymeshfix](https://github.com/pyvista/pymeshfix) (MeshFix) fills the 67 holes,
  removes self-intersections and joins the stray shells. Result: watertight,
  consistent winding. Then metres -> mm and scale to the target height.
* `solidify.py` — sections the shell every 0.3 mm in Z, unions the loops of each
  section into the true filled cross-section (this collapses the coincident
  front/back walls), rasterises those into a voxel mask and runs marching cubes.
  Result: a genuinely solid, watertight mesh — 15.6 cm3, 274 k faces.

## Results (fits the Weedo Tina2 Basic, 100 x 120 x 100 mm)

| file | watertight | volume | CuraEngine (0.2 mm, 15 % infill) |
| --- | --- | --- | --- |
| `cybermanV1.stl` (raw) | no | — | — |
| `cybermanV1_repaired.stl` | yes | 1.4 cm3 shell | walls only, no infill |
| `cybermanV1_90mm.stl` | yes | 1.4 cm3 shell | 42 min, 2.5 cm3 |
| `cybermanV1_solid_90mm.stl` | yes | 15.6 cm3 | 1 h 51 m, 12.2 cm3 |

The derived `.stl` files are gitignored (`*.stl`) — regenerate with the two
commands above, or `git add -f` them if you want them tracked.

## Still to check before printing

* 90 mm tall leaves 10 mm of Z headroom for a raft/brim on the Tina2.
* Arms hang at the sides; the only real overhangs are the chin/face detail and
  the shoulder pads — supports are probably unnecessary at 0.2 mm layers, but
  slice a preview before committing to an hour and fifty minutes.
