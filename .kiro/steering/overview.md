# 3D Printer Project

## Overview

This repo contains parametric 3D models designed for FDM 3D printing. Models are created using OpenSCAD (parametric CAD) and printed on a Weedo Tina2 Basic via OctoPrint.

## Project Structure

- `coin/` — Trolley coin and keyring holder (OpenSCAD, parametric)
- `dogv1/` — Iterative dog model with scoring/validation pipeline
- `dogv2/` — Dog model via TRELLIS image-to-3D
- `tools/curaengine/` — Dockerfile to build CuraEngine 5.14 for headless slicing

## Tools & Workflow

- **OpenSCAD** via Docker (`openscad/openscad:latest`) for SCAD → STL
- **CuraEngine 5.14** via Docker (`markretallackhome/curaengine5`) for STL → GCode
- **OctoPrint** at `http://flower.retallack.org.uk:5000` for printing
- **Python (numpy-stl + matplotlib)** for headless STL → PNG rendering

## Printer

- **Model**: Weedo Tina2 Basic
- **Bed**: 100×100mm, no heated bed
- **Nozzle**: 0.4mm
- **Filament**: PLA 1.75mm, 210°C
- **Adhesion**: Raft (required for cold bed)
- **Slicer profile**: `entina_tina2.def.json` (bundled in CuraEngine Docker image)

## Conventions

- SCAD files are the source of truth; STL is a build artifact
- STL and GCode files are gitignored; regenerate from SCAD source
- PNG renders are force-added when needed for documentation
- Use Docker for all tools to avoid local install dependencies

## Building

```bash
# SCAD to STL
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/trolley_coin.scad

# STL to GCode (CuraEngine 5.14)
docker run --rm -v "$(pwd)/coin:/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  markretallackhome/curaengine5 slice -j /definitions/entina_tina2.def.json \
  -o /data/output.gcode \
  -s roofing_layer_count=0 -s flooring_layer_count=0 \
  -s layer_height=0.2 -s infill_sparse_density=30 \
  -s material_print_temperature=210 -s material_print_temperature_layer_0=210 \
  -s machine_width=100 -s machine_depth=100 -s center_object=true \
  -l /data/trolley_coin.stl

# STL to PNG (headless render)
python3 .kiro/skills/render-openscad/render_stl.py <input.stl> <output.png>
```

## Docker Images

| Image | Purpose | Build |
|-------|---------|-------|
| `openscad/openscad:latest` | SCAD → STL | Pre-built (Docker Hub) |
| `markretallackhome/curaengine5` | STL → GCode | Pre-built (Docker Hub), source: `tools/curaengine/` |
