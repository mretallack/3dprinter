# Print Test Results — Trolley Coin (OrcaSlicer on Tina2 Basic)

## Summary

Attempting to replicate UltiMaker Cura's working output using OrcaSlicer CLI headless pipeline.

UltiMaker gcode prints perfectly every time. OrcaSlicer requires tuning.

## Attempts

### Attempt 1 — CuraEngine 3.6 (abandoned)
- **Slicer**: CuraEngine 3.6 Docker (Printerverse)
- **Result**: Failed. Filament not extruding, head moving too fast.
- **Cause**: Old engine (2018), material_diameter defaulting to 2.85mm in extruder settings, generic profile not resolving correctly.

### Attempt 2 — OrcaSlicer, no raft, brim
- **Settings**: Brim, 0.2mm first layer, M190 S35 still in gcode
- **Result**: Failed. First layer didn't stick, outer circle jumped instead of being curved.
- **Cause**: M190 (bed temp wait) blocking firmware on a printer with no heated bed. Also first layer too thin (0.2mm).

### Attempt 3 — OrcaSlicer, no raft, brim, M190 removed
- **Settings**: Brim, 0.35mm first layer, M190/M140 stripped, M201/M203/M204/M205 stripped
- **Result**: Failed. First layer brim not sticking, dragging filament.
- **Cause**: No raft — brim alone insufficient on cold bed. Possibly travel speed too fast (80mm/s reduced to 50mm/s after this).

### Attempt 4 — OrcaSlicer, raft (4 layers), 0.1mm gap
- **Settings**: 4 raft layers, 90% density, 3mm expansion, 0.1mm contact distance
- **Result**: Printed successfully and level! But model fused to raft — could not separate. Left residue.
- **Cause**: Contact distance too small, raft interface too rough/keyed into model.

### Attempt 5 — OrcaSlicer, raft (4 layers), 0.15mm gap
- **Settings**: 4 raft layers, 90% density, 3mm expansion, 0.15mm contact distance
- **Result**: Failed. Raft lifted off bed mid-print, taking model with it.
- **Cause**: Raft base not gripping bed strongly enough.

### Attempt 6 — OrcaSlicer, raft (5 layers), 0.15mm gap, 100% density, 5mm expansion
- **Settings**: 5 raft layers, 100% first layer density, 5mm expansion, 0.15mm contact distance
- **Result**: Print completed but could not remove model from raft (same as attempt 4).
- **Cause**: OrcaSlicer's raft interface pattern bonds too strongly regardless of gap setting.

## UltiMaker Reference (working)

- 5 raft layers (LAYER:-5 to LAYER:-2)
- Raft base at Z0.35mm
- Air gap: 0.11mm (raft top Z1.64 → model Z1.75)
- Support interface pattern on raft top (smooth, dense)
- No M190/M140 (no heated bed commands)
- Speeds: walls 22-28mm/s, infill 30mm/s, travel 65mm/s
- Model peels cleanly from raft by hand

## Key Differences (OrcaSlicer vs UltiMaker)

| | UltiMaker | OrcaSlicer |
|---|---|---|
| Raft interface | Smooth, dense, concentric-like | Rough zigzag/rectilinear |
| Raft separation | Clean peel by hand | Either fused or lifts off bed |
| Raft settings | Many (density, line width, speed, pattern) | Limited (layers, gap, density, expansion) |
| Bed temp commands | None | Auto-inserted (must strip) |
| Firmware overrides | None | M201/M203/M204/M205 (must strip) |

## Next Steps

- Try **brim** (no raft) — original brim failure was caused by M190 which is now fixed
- If brim works, it avoids the raft separation problem entirely
- Alternative: accept UltiMaker for slicing, automate only SCAD→STL→render
