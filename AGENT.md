# 3D Printer Project

## Overview

This repo contains parametric 3D models designed for FDM 3D printing. Models are created using OpenSCAD (parametric CAD) and printed on a Weedo Tina2 Basic via OctoPrint.

## Project Structure

- `coin/` — Trolley coin and keyring holder (OpenSCAD, parametric)
- `dogv1/` — Iterative dog model with scoring/validation pipeline
- `dogv2/` — Dog model via TRELLIS image-to-3D
- `dogv3/` — Dog model variant
- `carousel/` — Parametric mechanical carousel
- `fan/` — Parametric fan assembly
- `tree-stand/` — Parametric Christmas tree stand (`tree_stand.scad`)
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

## Project Skills

This repository includes project skills in `.kiro/skills/` that provide detailed instructions for specific tasks. Review these when deciding which workflow to apply:

1. **`render-openscad`** (`.kiro/skills/render-openscad/`)
   - **When to use**: When the user wants to see a visual preview of a 3D model, generate a render, or view/render an STL file to PNG.
   - **What it does**: Generates STL from SCAD via Docker OpenSCAD, then renders STL to PNG using headless Python (`numpy-stl` + `matplotlib`).

2. **`scad-to-print`** (`.kiro/skills/scad-to-print/`)
   - **When to use**: When the user wants to slice a model, generate G-code, send to OctoPrint, or run the full OpenSCAD → STL → G-Code → Print workflow.
   - **What it does**: Full headless pipeline checking dimensions/orientation, slicing via CuraEngine 5.13.0 Docker image with required overrides, post-processing G-code temperature variables, and uploading to OctoPrint.

3. **`octoprint`** (`.kiro/skills/octoprint/`)
   - **When to use**: When the user asks about print status, progress, temperature, wants to start/stop/cancel a print, upload files, or check the printer state.
   - **What it does**: Directly interacts with the OctoPrint API at `http://flower.retallack.org.uk:5000` to monitor, control, and manage print jobs.

### Skill Usage Instructions for Agents

When handling user requests related to viewing, slicing, rendering, or printing models in this repository:
- **Always consult and follow the detailed workflows** defined in `.kiro/skills/<skill-name>/SKILL.md`.
- **Do not guess parameters or docker commands**; use the exact proven commands, overrides, and post-processing steps documented in the respective skill files (e.g. required CuraEngine CLI overrides, temperature post-processing with `sed`, and OctoPrint API calls).
- **Check dimensions and orientation** as outlined in `scad-to-print` before initiating prints.

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
