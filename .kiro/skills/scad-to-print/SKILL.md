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
- **Slicer**: CuraEngine 5.13.0 (same engine as UltiMaker Cura GUI)

## Before Printing — Ask the User

Before slicing, check and ask the user:

### 1. Check STL dimensions
- Verify the model fits within 100×100×100mm
- If STL units look wrong (sub-mm dimensions), it's likely in inches (×25.4) or metres (×1000)
- Report dimensions to the user

### 2. Check orientation
- Render the model and send to user for review
- Ask if it needs rotating (e.g. flip 180° to avoid supports, rotate 45° to fit bed)

### 3. Check bed fit with raft
- Model footprint + 8mm raft margin each side must fit within 100mm
- If too large: rotate 45° on Z axis, scale down, or reduce raft margin

### 4. Ask print settings (defaults in brackets):
1. **Infill density** — how solid? [20%]
2. **Layer height** — 0.2mm standard, 0.12mm fine [0.2mm]
3. **Supports** — does the model need them? [no]
   - Check if model has overhangs beyond the first-layer contact area
   - If the model's upper layers extend well beyond layer 0 footprint, supports ARE needed

### 5. Supports guidance
- Models with small base contact but wide upper body (figurines, animals) need supports
- Use `support_structure=tree` with `support_type=buildplate` (tree supports work on 5.13.0)
- Tree supports with raft will show a support layer between raft and model — this is normal
- The raft only covers the first-layer contact area, NOT the full model footprint

## Step 1: SCAD → STL

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/input.scad
```

## Step 2: STL → GCode (CuraEngine 5.13.0)

```bash
docker run --rm \
  -v "$(pwd):/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  markretallackhome/curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/output.gcode \
  -s roofing_layer_count=0 \
  -s flooring_layer_count=0 \
  -s layer_height=0.2 \
  -s infill_sparse_density=20 \
  -s material_print_temperature=200 \
  -s material_print_temperature_layer_0=200 \
  -s speed_travel=65 \
  -s machine_width=100 \
  -s machine_depth=100 \
  -s center_object=true \
  -s raft_margin=8 \
  -s raft_base_margin=8 \
  -s raft_interface_margin=8 \
  -s raft_surface_margin=8 \
  -s raft_airgap=0.25 \
  -l /data/input.stl
```

### Required Overrides

These must always be passed (the bundled Tina2 definition has incorrect defaults for CLI use):

| Setting | Value | Reason |
|---------|-------|--------|
| `roofing_layer_count` | 0 | Not in definition, engine errors without it |
| `flooring_layer_count` | 0 | Not in definition, engine errors without it |
| `material_print_temperature` | 200 | GUI uses 200°C; definition defaults to 215 |
| `material_print_temperature_layer_0` | 200 | GUI uses 200°C; definition defaults to 215 |
| `speed_travel` | 65 | Definition defaults to 120mm/s, too fast for Tina2 frame |
| `machine_width` | 100 | Definition says 100 but verify centering |
| `machine_depth` | 100 | Definition says 120, actual bed is 100 |
| `center_object` | true | Ensures model is centred on bed |
| `raft_margin` | 8 | CLI doesn't cascade weedo_base default (would use 15mm) |
| `raft_base_margin` | 8 | Per-layer margin, defaults to 15mm without override |
| `raft_interface_margin` | 8 | Per-layer margin, defaults to 15mm without override |
| `raft_surface_margin` | 8 | Per-layer margin, defaults to 15mm without override |
| `raft_airgap` | 0.25 | Definition says 0.19, but raft sticks too much; 0.25 peels cleanly |

### Support Overrides (when supports needed)

| Setting | Value | Reason |
|---------|-------|--------|
| `support_enable` | true | Enable support generation |
| `support_structure` | tree | Tree supports — less material, easier removal |
| `support_type` | buildplate | Only support from buildplate, not everywhere |
| `min_wall_line_width` | 0.34 | Required by 5.13.0, errors without it |
| `support_z_seam_away_from_model` | 0 | Required by 5.13.0, errors without it |

### Optional Overrides

| Setting | Default | Description |
|---------|---------|-------------|
| `layer_height` | 0.2 | Layer height in mm |
| `infill_sparse_density` | 20 | Infill percentage |
| `support_enable` | false | Enable supports |
| `adhesion_type` | raft | raft, brim, skirt, or none |
| `speed_print` | 25 | Print speed in mm/s (lower = better quality for detailed models) |

## Post-Processing GCode

After slicing, fix these known CuraEngine CLI issues:

### 1. Fix unresolved temperature variable
```bash
sed -i 's/M109 S{material_print_temperature_layer_0}/M109 S200/' output.gcode
```

### 2. Verify gcode is valid
Check the file is not empty and has reasonable content:
```bash
wc -l output.gcode  # Should be thousands of lines
grep "^;LAYER:" output.gcode | tail -1  # Should show final layer number
```

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

# 2. Slice with CuraEngine 5.13.0
docker run --rm \
  -v "$(pwd)/coin:/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  markretallackhome/curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/trolley_coin.gcode \
  -s roofing_layer_count=0 -s flooring_layer_count=0 \
  -s layer_height=0.2 -s infill_sparse_density=20 \
  -s material_print_temperature=200 -s material_print_temperature_layer_0=200 \
  -s speed_travel=65 \
  -s machine_width=100 -s machine_depth=100 -s center_object=true \
  -s raft_margin=8 -s raft_base_margin=8 -s raft_interface_margin=8 -s raft_surface_margin=8 \
  -s raft_airgap=0.25 \
  -l /data/trolley_coin.stl

# 3. Post-process
sed -i 's/M109 S{material_print_temperature_layer_0}/M109 S200/' coin/trolley_coin.gcode

# 4. Upload to OctoPrint
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@coin/trolley_coin.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local

# 5. Start print
curl -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "select", "print": true}' \
  http://flower.retallack.org.uk:5000/api/files/local/trolley_coin.gcode
```

## Docker Images Required

- `openscad/openscad:latest` — SCAD to STL
- `markretallackhome/curaengine5` — STL to GCode (CuraEngine 5.13.0, built from `tools/curaengine/Dockerfile`)

### Building CuraEngine Docker Image

Pre-built on Docker Hub: `docker pull markretallackhome/curaengine5`

To rebuild locally:
```bash
docker build -t markretallackhome/curaengine5 tools/curaengine/
```

Build takes ~7 minutes. Only needs to be done once.

## STL Preparation Notes

### Unit conversion
- If STL dimensions are sub-millimetre, likely in inches (multiply by 25.4) or metres (×1000)
- Always check and report dimensions before slicing

### Orientation
- Render and show user before printing
- Flat base down = no supports needed for simple models
- Figurines/animals often need rotating to stand upright
- Caps/cups: open end UP to avoid supports

### Rotation for bed fit
- If model is too long for bed (>84mm in one axis, accounting for 8mm raft margin each side)
- Rotate 45° around Z axis to fit diagonally
- 100mm model rotates to ~71mm diagonal footprint

### Scaling
- Use numpy-stl to scale/rotate/center STL files before slicing
- Always set Z min to 0 after transformations

## Troubleshooting

### Raft too small / model printing off raft edge
- The raft only covers the **first-layer contact area** + margin
- If model overhangs beyond layer 0 footprint, those parts print in mid-air
- Solution: enable supports (tree, buildplate)

### Print failing / nozzle moving too fast
- Check travel speed is 65mm/s (F3900), not 120mm/s (F7200)
- Compare with a known-good GUI-sliced gcode from OctoPrint

### Raft stuck to model
- `raft_airgap=0.25` should peel cleanly
- If still stuck, try 0.30

### Empty gcode file
- Check for error messages about missing settings
- Common missing: `min_wall_line_width=0.34`, `support_z_seam_away_from_model=0`
- Tree supports require both of these on 5.13.0

### Unresolved variables in gcode
- CuraEngine CLI sometimes outputs `{setting_name}` instead of values in start gcode
- Fix with sed: `sed -i 's/M109 S{material_print_temperature_layer_0}/M109 S200/'`

## Notes

- CuraEngine 5.13.0 is the latest stable release (Docker image pinned to this version)
- The `entina_tina2.def.json` printer definition is bundled (from Cura repo)
- Raft is enabled by default in the Tina2 definition (required for cold bed adhesion)
- Raft air gap is 0.25mm (overridden from definition's 0.19mm for easier raft removal)
- Tree supports with raft will show support layers between raft and model — this is normal behaviour
- GCode may contain temperature ramp-down commands near end of print — these are harmless
- Expected print time for trolley coin: ~35 minutes (with correct raft margins)
