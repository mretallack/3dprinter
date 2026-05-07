# Trolley Coin & Holder

A parametric OpenSCAD design for a 3D-printable trolley coin (UK £1 size) with a teardrop-shaped keyring holder.

## Features

- **Coin**: 22.5mm diameter, 2.8mm thick, finger grip recess, decorative concentric pattern
- **Holder**: Teardrop shape with 8 retention balls, open front for removal, 14mm finger hole in base to push coin out, keyring loop

## Files

- `trolley_coin.scad` — Parametric source (all dimensions configurable)
- `v7-render-bottom.png` — Current render showing finger hole in base

## Building

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/trolley_coinV7.stl /data/trolley_coin.scad
```

## Rendering Preview

```bash
python3 ../.kiro/skills/render-openscad/render_stl.py trolley_coinV7.stl render.png
```

## Printing

Import the STL into your slicer (Cura, PrusaSlicer, etc.). No supports needed — prints flat.
