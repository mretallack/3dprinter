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

## Step 1: SCAD → STL

```bash
docker run --rm -v "$(pwd):/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/input.scad
```

## Step 2: STL → GCode (OrcaSlicer)

Uses OrcaSlicer 2.3.2 via the LinuxServer Docker image with Tina2 profiles at `printer-profiles/orca/`.

```bash
docker run --rm \
  -v "$(pwd):/stl:z" \
  -v "$(pwd)/printer-profiles/orca:/profiles:z" \
  --entrypoint /opt/orcaslicer/bin/orca-slicer \
  ghcr.io/linuxserver/orcaslicer \
  --slice 1 \
  --load-settings "/profiles/machine.json;/profiles/process.json" \
  --load-filaments "/profiles/filament.json" \
  --export-3mf /stl/output.gcode.3mf \
  /stl/input.stl
```

## Step 3: Extract GCode from 3MF

OrcaSlicer outputs a `.gcode.3mf` archive. Extract the gcode:

```bash
unzip -o output.gcode.3mf "Metadata/plate_1.gcode" -d /tmp/orca_out
```

## Step 4: Post-process for Tina2

**Critical step.** OrcaSlicer auto-inserts M190/M140 (bed temp) and M201/M203/M204/M205 (acceleration/jerk limits) that the Tina2 Basic firmware cannot handle. The post-processor strips these.

```bash
python3 printer-profiles/orca/postprocess_tina2.py /tmp/orca_out/Metadata/plate_1.gcode output.gcode
```

## Step 5: Upload to OctoPrint

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

### Check printer status

```bash
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  http://flower.retallack.org.uk:5000/api/printer
```

## Full Pipeline Example

```bash
source .env

# 1. Generate STL from SCAD
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/trolley_coin.stl /data/trolley_coin.scad

# 2. Slice with OrcaSlicer
docker run --rm \
  -v "$(pwd)/coin:/stl:z" \
  -v "$(pwd)/printer-profiles/orca:/profiles:z" \
  --entrypoint /opt/orcaslicer/bin/orca-slicer \
  ghcr.io/linuxserver/orcaslicer \
  --slice 1 \
  --load-settings "/profiles/machine.json;/profiles/process.json" \
  --load-filaments "/profiles/filament.json" \
  --export-3mf /stl/trolley_coin.gcode.3mf \
  /stl/trolley_coin.stl

# 3. Extract gcode
unzip -o coin/trolley_coin.gcode.3mf "Metadata/plate_1.gcode" -d /tmp/orca_out

# 4. Post-process (strip commands Tina2 can't handle)
python3 printer-profiles/orca/postprocess_tina2.py /tmp/orca_out/Metadata/plate_1.gcode coin/trolley_coin.gcode

# 5. Upload to OctoPrint
curl -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@coin/trolley_coin.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local
```

## Tina2 Profile Settings

Profiles are at `printer-profiles/orca/`:

| Setting | Value | File |
|---------|-------|------|
| Bed size | 100×100mm | machine.json |
| Height | 100mm | machine.json |
| Nozzle | 0.4mm | machine.json |
| Heated bed | No | machine.json |
| Retraction | 3mm at 40mm/s | machine.json |
| Layer height | 0.2mm | process.json |
| First layer height | 0.35mm | process.json |
| Outer wall speed | 35mm/s | process.json |
| Inner wall speed | 40mm/s | process.json |
| Infill speed | 50mm/s | process.json |
| Travel speed | 50mm/s | process.json |
| First layer speed | 20mm/s | process.json |
| Infill density | 20% | process.json |
| Filament | PLA 1.75mm | filament.json |
| Nozzle temp | 210°C | filament.json |
| Bed temp | 0 (no heated bed) | filament.json |

## Post-processor Details

`printer-profiles/orca/postprocess_tina2.py` removes:

- **M190/M140** — bed temperature commands (Tina2 Basic has no heated bed, these block forever)
- **M201** — acceleration limits (before start gcode only)
- **M203** — max feedrate (before start gcode only — preserved inside start gcode where M203 Z15/Z5 controls Tina2 Z speed)
- **M204** — print/retract acceleration
- **M205** — jerk limits

These are auto-inserted by OrcaSlicer and the Tina2 firmware either ignores them or behaves erratically with them.

## Docker Images Required

- `openscad/openscad:latest` — SCAD to STL
- `ghcr.io/linuxserver/orcaslicer:latest` — STL to GCode (OrcaSlicer 2.3.2)

## Notes

- OpenGL errors during slicing are normal (thumbnail generation fails headlessly) — slicing still works
- The Tina2 start gcode includes G29 (auto bed levelling) which is critical
- GCode flavour: Marlin
- OrcaSlicer outputs `.gcode.3mf` not raw `.gcode` — must extract from archive
