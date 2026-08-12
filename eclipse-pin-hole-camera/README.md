# Eclipse Pinhole Projection Card

A 3D-printed multi-pinhole eclipse viewing card — a safe, hands-free way to watch a solar eclipse without looking directly at the sun.

## How It Works

Each pinhole acts as a tiny camera obscura. Hold the card with the sun behind it and a white surface (paper, ground) below. Every pinhole projects a small image of the sun onto that surface. During an eclipse, you'll see a grid of tiny crescent suns — one per hole.

## Usage

1. Hold the card by the paddle handle with the sun at your back
2. Let sunlight pass through the pinhole array
3. Position a white sheet of paper 30–50 cm below the card
4. Observe the array of projected eclipse images on the paper

## Specifications

| Parameter | Value |
|-----------|-------|
| Card size | 55 × 50 mm |
| Handle length | 28 mm |
| Total length | 83 mm |
| Thickness | 1.6 mm |
| Pinhole diameter | 1.8 mm |
| Pinhole spacing | 5 mm pitch |
| Grid | 8 × 7 (56 holes) |
| Lanyard hole | 5 mm |

## Printing

- **Printer**: Weedo Tina2 Basic (fits within 100×100 mm bed)
- **Orientation**: Flat on bed, no supports needed
- **Layer height**: 0.2 mm (8 layers total)
- **Print time**: ~10–15 minutes
- **Filament**: PLA, any colour (darker colours block more stray light)

## Build

```bash
docker run --rm -v "$(pwd)/eclipse-pin-hole-camera:/data" openscad/openscad:latest \
  openscad -o /data/eclipse_pinhole_card.stl /data/eclipse_pinhole_card.scad
```

## Files

- `eclipse_pinhole_card.scad` — Parametric OpenSCAD source
- `eclipse_pinhole_card.png` — Rendered preview
