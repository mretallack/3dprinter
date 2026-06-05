# Dog Model (Image-to-3D)

Lying-down dog model generated via image-to-3D, prepared for FDM printing on the Tina2.

## Source

- `dog.glb` — Original GLB from image-to-3D generation
- `reference.jpg` — Reference photo used to generate the model

## Pipeline: GLB → Print

### 1. Convert GLB to STL

The GLB (glTF Binary) was loaded with trimesh and exported as STL for processing.

### 2. Rotate orientation

The model came oriented nose-up (standing on its tail). Applied:
- -90° rotation around X axis to lay it flat
- 180° rotation around Y axis to flip right-side up
- Translated Z to place on bed (z_min = 0)

Result: `dog_original.stl`

### 3. Solidify (fix thin shell)

Image-to-3D models are typically hollow thin shells with holes. Analysis showed:
- Not watertight (gaps in mesh)
- ~24% fill ratio (hollow)

Fixed by voxelizing at 1% resolution of longest axis, filling the interior, then converting back to mesh via marching cubes.

Result: `dog_solid.stl` — watertight, solid interior

### 4. Scale to fit bed

Tina2 bed is 100×100mm. With 8mm raft margin each side + room for tree supports, scaled the longest axis to 76mm.

Final size: 31 × 76 × 30mm

Result: `dog_for_print.stl`

### 5. Slice with tree supports

Overhang analysis showed 31% of the surface is downward-facing (belly, under head, between legs), so tree supports from buildplate were enabled.

Settings:
- Layer height: 0.2mm
- Infill: 20%
- Supports: tree, buildplate only
- Adhesion: raft (8mm margin, 0.25mm air gap)
- Temperature: 200°C

Result: `dog.gcode` — ~2h 21min print time, 6.7m filament

## Build Artifacts (gitignored)

- `dog_original.stl` — Rotated shell mesh
- `dog_solid.stl` — Solidified mesh
- `dog_for_print.stl` — Scaled for printing
- `dog.gcode` — Sliced gcode

## Rebuild

```bash
# Requires: trimesh, numpy, scipy, scikit-image
python3 -c "
import trimesh, numpy as np

mesh = trimesh.load('dog.glb', force='mesh')

# Rotate to lie flat
R1 = trimesh.transformations.rotation_matrix(-np.pi/2, [1,0,0])
R2 = trimesh.transformations.rotation_matrix(np.pi, [0,1,0])
mesh.apply_transform(R1)
mesh.apply_transform(R2)
mesh.vertices[:,2] -= mesh.vertices[:,2].min()

# Solidify
pitch = mesh.extents.max() / 100
solid = mesh.voxelized(pitch).fill().marching_cubes

# Scale to 76mm longest axis
solid.apply_scale(76.0 / max(solid.extents[0], solid.extents[1]))
solid.vertices[:,2] -= solid.vertices[:,2].min()
solid.export('dog_for_print.stl')
"
```
