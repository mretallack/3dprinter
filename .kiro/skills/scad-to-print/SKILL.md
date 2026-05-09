---
name: scad-to-print
description: Full pipeline from OpenSCAD source to 3D printing. Use when the user wants to slice a model, generate gcode, send to OctoPrint, or run the full SCAD → STL → GCode → Print workflow.
---

# SCAD to Print Pipeline

Complete headless workflow: OpenSCAD → STL → GCode → OctoPrint.

All steps run via Docker with no local installs required.

## Printer

- **Printer**: Weedo Tina2 Basic (100×100×100mm build volume, no heated bed)
- **OctoPrint**: http://flower.retallack.org.uk:5000
- **API key**: stored in `.env` as `OCTOPRINT_KEY`
- **Slicer**: CuraEngine 5.14 (same engine as UltiMaker Cura GUI)

## Before Printing — Ask the User

Before slicing, ask the user for these settings (defaults in brackets):

1. **Infill density** — how solid the print should be [30%]
2. **Layer height** — print quality vs speed [0.2mm standard, 0.12mm fine]
3. **Support enabled** — does the model need supports? [no]

Pass these as `-s` overrides to CuraEngine.

## Step 1: SCAD → STL

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/input.scad
```

## Step 2: STL → GCode (CuraEngine 5.14)

```bash
docker run --rm \
  -v "$(pwd):/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/output.gcode \
  -s roofing_layer_count=0 \
  -s flooring_layer_count=0 \
  -s layer_height=0.2 \
  -s infill_sparse_density=30 \
  -s material_print_temperature=210 \
  -s material_print_temperature_layer_0=210 \
  -s machine_width=100 \
  -s machine_depth=100 \
  -s center_object=true \
  -s raft_margin=8 \
  -s raft_base_margin=8 \
  -s raft_interface_margin=8 \
  -s raft_surface_margin=8 \
  -l /data/input.stl
```

### Required Overrides

These must always be passed (the bundled Tina2 definition has incorrect defaults for CLI use):

| Setting | Value | Reason |
|---------|-------|--------|
| `roofing_layer_count` | 0 | Not in definition, engine errors without it |
| `flooring_layer_count` | 0 | Not in definition, engine errors without it |
| `material_print_temperature` | 210 | Definition defaults to 215 |
| `material_print_temperature_layer_0` | 210 | Definition defaults to 215 |
| `machine_width` | 100 | Definition says 100 but verify centering |
| `machine_depth` | 100 | Definition says 120, actual bed is 100 |
| `center_object` | true | Ensures model is centred on bed |
| `raft_margin` | 8 | CLI doesn't cascade weedo_base default (would use 15mm) |
| `raft_base_margin` | 8 | Per-layer margin, defaults to 15mm without override |
| `raft_interface_margin` | 8 | Per-layer margin, defaults to 15mm without override |
| `raft_surface_margin` | 8 | Per-layer margin, defaults to 15mm without override |

**Raft margin note**: The `weedo_base.def.json` sets `raft_margin=8` via `default_value`, but CuraEngine 5.14 CLI does not cascade this to the per-layer margins (`raft_base_margin`, `raft_interface_margin`, `raft_surface_margin`), which default to 15mm from `fdmprinter.def.json`. The UltiMaker GUI resolves this correctly. Without these overrides, the raft is ~15mm larger on each side, adding ~14 minutes to print time.

### Optional Overrides

| Setting | Default | Description |
|---------|---------|-------------|
| `layer_height` | 0.2 | Layer height in mm |
| `infill_sparse_density` | 30 | Infill percentage |
| `support_enable` | false | Enable supports |
| `adhesion_type` | raft | raft, brim, skirt, or none |

## Step 3: Upload to OctoPrint

```bash
source .env
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@output.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local
```

### Start printing immediately

```bash
curl -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "select", "print": true}' \
  http://flower.retallack.org.uk:5000/api/files/local/output.gcode
```

## Full Pipeline Example

```bash
source .env

# 1. Generate STL from SCAD
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/trolley_coin.stl /data/trolley_coin.scad

# 2. Slice with CuraEngine 5.14
docker run --rm \
  -v "$(pwd)/coin:/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/trolley_coin.gcode \
  -s roofing_layer_count=0 -s flooring_layer_count=0 \
  -s layer_height=0.2 -s infill_sparse_density=30 \
  -s material_print_temperature=210 -s material_print_temperature_layer_0=210 \
  -s machine_width=100 -s machine_depth=100 -s center_object=true \
  -s raft_margin=8 -s raft_base_margin=8 -s raft_interface_margin=8 -s raft_surface_margin=8 \
  -l /data/trolley_coin.stl

# 3. Upload to OctoPrint
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@coin/trolley_coin.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local

# 4. Start print
curl -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "select", "print": true}' \
  http://flower.retallack.org.uk:5000/api/files/local/trolley_coin.gcode
```

## Docker Images Required

- `openscad/openscad:latest` — SCAD to STL
- `curaengine5` — STL to GCode (CuraEngine 5.14, built from `tools/curaengine/Dockerfile`)

### Building CuraEngine Docker Image

```bash
docker build -t curaengine5 tools/curaengine/
```

Build takes ~7 minutes. Only needs to be done once.

## Notes

- CuraEngine 5.14 uses the same engine as UltiMaker Cura GUI
- The `entina_tina2.def.json` printer definition is bundled (from Cura repo)
- Raft is enabled by default in the Tina2 definition (required for cold bed adhesion)
- Raft air gap is 0.19mm (built into definition) — model peels off cleanly
- No post-processing needed (unlike OrcaSlicer which required stripping M190/M201 etc)
- GCode output matches UltiMaker Cura GUI when raft margins are set correctly
- Expected print time for trolley coin: ~35 minutes (with correct raft margins)
