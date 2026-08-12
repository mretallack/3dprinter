# Christmas Tree Stand

A simple tapered stand for holding a small tabletop Christmas tree. The cork/plant-pot shape provides a stable base, and a slot across the top holds the tree trunk.

## Design

- Tapered cylinder (wider at top, narrower at base) — like a plant pot or cork
- Vertical slot cut from the top for the tree trunk to slot into

## Specifications

| Parameter | Value |
|-----------|-------|
| Base diameter | 30 mm |
| Top diameter | 40 mm |
| Height | 50 mm |
| Slot width | 5 mm |
| Slot depth | 8 mm |

## Printing

- **Printer**: Weedo Tina2 Basic
- **Orientation**: Base down, no supports needed
- **Layer height**: 0.2 mm
- **Infill**: 20%
- **Print time**: ~2 hours 15 minutes
- **Filament**: PLA (red looks festive)

## Build

```bash
docker run --rm -v "$(pwd)/tree-stand:/data" openscad/openscad:latest \
  openscad -o /data/tree_stand.stl /data/tree_stand.scad
```

## Files

- `tree_stand.scad` — Parametric OpenSCAD source
- `tree_stand.png` — Rendered preview
