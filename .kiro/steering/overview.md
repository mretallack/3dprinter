# 3D Printer Project

## Overview

This repo contains parametric 3D models designed for FDM 3D printing. Models are created using OpenSCAD (parametric CAD) and AI-assisted generation tools.

## Project Structure

- `coin/` — Trolley coin and keyring holder (OpenSCAD, parametric)
- `dogv1/` — Iterative dog model with scoring/validation pipeline
- `dogv2/` — Dog model via TRELLIS image-to-3D

## Tools & Workflow

- **OpenSCAD** via Docker (`openscad/openscad:latest`) for SCAD → STL
- **Python (numpy-stl + matplotlib)** for headless STL → PNG rendering
- STL files are gitignored; regenerate from SCAD source
- PNG renders are force-added when needed for documentation

## Conventions

- SCAD files are the source of truth; STL is a build artifact
- Version STL files with suffixes (V1, V2, etc.) during iteration
- Use Docker for OpenSCAD to avoid local install dependencies
- Render previews headlessly using the `render-openscad` skill

## Building

```bash
# SCAD to STL
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/trolley_coin.scad

# STL to PNG (headless)
python3 .kiro/skills/render-openscad/render_stl.py <input.stl> <output.png>
```
