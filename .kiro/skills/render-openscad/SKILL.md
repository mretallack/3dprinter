---
name: render-openscad
description: Render an OpenSCAD (.scad) file to a PNG preview image. Use when the user wants to see a visual preview of a 3D model, generate a render, or view an STL.
---

# Render OpenSCAD to Image

Render OpenSCAD source files or STL files to PNG images on a headless server (no display required).

## Workflow

### 1. Generate STL from SCAD (if needed)

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/OUTPUT.stl /data/INPUT.scad
```

### 2. Render STL to PNG

Use the bundled Python script:

```bash
python3 -m venv /tmp/render-venv && source /tmp/render-venv/bin/activate
pip install -q numpy-stl matplotlib
python3 .kiro/skills/render-openscad/render_stl.py INPUT.stl OUTPUT.png
```

## Script: render_stl.py

Located at `.kiro/skills/render-openscad/render_stl.py`

### Usage

```bash
python3 render_stl.py <input.stl> <output.png> [--elev DEGREES] [--azim DEGREES] [--title TEXT]
```

### Arguments

- `input.stl` — Path to STL file to render
- `output.png` — Output image path
- `--elev` — Camera elevation angle in degrees (default: 30)
- `--azim` — Camera azimuth angle in degrees (default: 45)
- `--title` — Title text for the image (default: filename)

### Examples

```bash
# Default isometric view
python3 .kiro/skills/render-openscad/render_stl.py coin/trolley_coinV7.stl coin/render.png

# Bottom view to show underside features
python3 .kiro/skills/render-openscad/render_stl.py coin/trolley_coinV7.stl coin/bottom.png --elev -30

# Custom title
python3 .kiro/skills/render-openscad/render_stl.py model.stl preview.png --title "My Model v2"
```

## Notes

- Requires Docker for SCAD-to-STL conversion
- Python rendering works headless (no X11/display needed)
- Uses matplotlib's Agg backend for server-side rendering
- Output is 150 DPI, 10x8 inch figure
