---
name: scad-to-print
description: Full pipeline from OpenSCAD source to 3D printing. Use when the user wants to slice a model, generate gcode, send to OctoPrint, or run the full SCAD → STL → GCode → Print workflow.
---

# SCAD to Print Pipeline

Complete headless workflow: OpenSCAD → STL → GCode → OctoPrint.

All steps run via Docker with no local installs required.

## Step 1: SCAD → STL

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/input.scad
```

## Step 2: STL → GCode (CuraEngine)

```bash
docker run --rm \
  -v "$(pwd):/stl" \
  -e CURA_ENGINE_SEARCH_PATH=/printer-settings \
  cura-engine CuraEngine slice \
  -j /printer-settings/fdmprinter.def.json \
  -o /stl/output.gcode \
  -s machine_width=100 \
  -s machine_depth=120 \
  -s machine_height=100 \
  -s layer_height=0.2 \
  -s material_diameter=1.75 \
  -s speed_print=40 \
  -l /stl/input.stl
```

### Common Settings Overrides (Tina2 Basic defaults)

| Setting | Default | Description |
|---------|---------|-------------|
| `layer_height` | 0.2 | Layer height in mm |
| `machine_width` | 100 | Bed width (mm) |
| `machine_depth` | 120 | Bed depth (mm) |
| `machine_height` | 100 | Max print height (mm) |
| `material_diameter` | 1.75 | Filament diameter (mm) |
| `speed_print` | 40 | Print speed (mm/s) |
| `infill_sparse_density` | 20 | Infill percentage |
| `support_enable` | false | Enable supports |
| `adhesion_type` | brim | brim, skirt, raft, or none |
| `material_print_temperature` | 200 | Nozzle temp (°C) |
| `material_bed_temperature` | 60 | Bed temp (°C) |

### Available Printer Profiles

The Docker image includes profiles at `/printer-settings/`. Use with `-j`:

- `fdmprinter.def.json` — Generic FDM (use with `-s` overrides)
- `creality_ender3.def.json` — Creality Ender 3
- `creality_cr10.def.json` — Creality CR-10
- `prusa_i3_mk2.def.json` — Prusa i3 MK2
- `ultimaker3.def.json` — Ultimaker 3
- `anycubic_i3_mega.def.json` — Anycubic i3 Mega

## Step 3: Upload to OctoPrint

OctoPrint URL: `http://flower.retallack.org.uk:5000`

Load API key from `.env`:
```bash
source .env
```

```bash
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@output.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local
```

### Upload and start printing immediately

```bash
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@output.gcode" \
  -F "print=true" \
  http://flower.retallack.org.uk:5000/api/files/local
```

### Check printer status

```bash
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  http://flower.retallack.org.uk:5000/api/printer
```

## Full Pipeline Example

```bash
# Load API key
source .env

# 1. Generate STL from SCAD
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/trolley_coin.stl /data/trolley_coin.scad

# 2. Slice to GCode (Tina2 Basic: 100x120x100mm bed)
docker run --rm -v "$(pwd)/coin:/stl" \
  -e CURA_ENGINE_SEARCH_PATH=/printer-settings \
  cura-engine CuraEngine slice \
  -j /printer-settings/fdmprinter.def.json \
  -o /stl/trolley_coin.gcode \
  -s machine_width=100 -s machine_depth=120 -s machine_height=100 \
  -s layer_height=0.2 -s material_diameter=1.75 -s speed_print=40 \
  -l /stl/trolley_coin.stl

# 3. Upload to OctoPrint
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@coin/trolley_coin.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local
```

## Docker Image Setup

The `cura-engine` image must be built once:

```bash
git clone https://github.com/Printerverse/CuraEngine-Docker.git /tmp/CuraEngine-Docker
cd /tmp/CuraEngine-Docker
docker build -t cura-engine .
```

## Notes

- **Printer**: Weedo Tina2 Basic (100×120×100mm build volume, 40mm/s)
- **OctoPrint**: http://flower.retallack.org.uk:5000
- CuraEngine version: 3.6 (older but functional for standard FDM)
- The verbose WARNING output during slicing is normal — it dumps resolved settings
- GCode flavour: Marlin (RepRap)
- OctoPrint API key: stored in `.env` as `OCTOPRINT_KEY` (run `source .env` before use)
