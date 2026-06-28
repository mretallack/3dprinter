# Carousel

Miniature fairground carousel driven by a steam engine via a band-and-spindle mechanism. Crown-and-spur gears convert horizontal drive rotation into vertical carousel spin.

## Design

- **Drive**: Band from engine flywheel → V-groove pulley on horizontal input spindle
- **Gears**: Crown-and-spur pair (1:1 ratio, 12 trapezoidal teeth, ~15mm pitch diameter)
- **Output**: Vertical centre pole rotates platform, vehicles, and canopy together
- **Size**: ~81mm tall × ~56mm wide (assembled)
- **Supports**: None required — all pieces designed for support-free FDM printing

## Pieces (10 total)

| Piece | File | Print Orientation | Time Est. |
|-------|------|-------------------|-----------|
| Housing tray | `print_housing_tray.scad` | Flat on bed | ~30m |
| Housing lid | `print_housing_lid.scad` | Flat on bed | ~10m |
| Input spindle | `print_spindle.scad` | On its side | ~15m |
| Spur + Crown gears | `print_gears.scad` | Flat on bed | ~20m |
| Centre pole | `print_pole.scad` | Standing up | ~15m |
| Platform | `print_platform.scad` | Flat on bed | ~20m |
| Canopy | `print_canopy.scad` | Upside-down (point on bed) | ~25m |
| Vehicles ×4 | `print_vehicles.scad` | Flat on bed | ~15m |

## Assembly Order

1. Place crown gear nub into housing tray floor bore
2. Thread input spindle through housing tray walls
3. Slide spur gear onto spindle D-flat (against inner wall)
4. Close lid onto tray (traps gears, crown stub passes through lid bore)
5. Slide centre pole D-hole onto crown gear stub
6. Slide platform down pole (rests on collar)
7. Press-fit canopy onto pole top
8. Slot vehicles onto platform pegs

## Building

```bash
# Generate STL for any piece
docker run --rm -v "$(pwd)/carousel:/data" openscad/openscad:latest \
  openscad -o /data/PIECE.stl /data/print_PIECE.scad

# Slice for Tina2 (no supports)
docker run --rm -v "$(pwd)/carousel:/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  markretallackhome/curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/PIECE.gcode \
  -s roofing_layer_count=0 -s flooring_layer_count=0 \
  -s layer_height=0.2 -s infill_sparse_density=20 \
  -s material_print_temperature=200 -s material_print_temperature_layer_0=210 \
  -s speed_print=25 -s speed_wall_0=20 -s speed_travel=65 \
  -s machine_width=100 -s machine_depth=100 -s center_object=true \
  -s raft_margin=8 -s raft_base_margin=8 -s raft_interface_margin=8 -s raft_surface_margin=8 \
  -s raft_airgap=0.25 \
  -l /data/PIECE.stl
```

## Parameters

Key parameters in `carousel.scad`:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `gear_teeth` | 12 | Teeth per gear |
| `gear_module` | 1.2 | Tooth size factor |
| `gear_backlash` | 0.2 | Mesh clearance |
| `pole_radius` | 4 | Centre pole radius (mm) |
| `pole_length` | 25 | Visible pole height |
| `platform_radius` | 20 | Platform disc radius |
| `canopy_height` | 20 | Cone height |
| `clearance_tight` | 0.15 | Press-fit joints |
| `clearance_loose` | 0.2 | Sliding joints |

## File Structure

```
carousel/
├── carousel.scad          # Main parametric source (all modules)
├── print_housing_tray.scad
├── print_housing_lid.scad
├── print_spindle.scad
├── print_gears.scad
├── print_pole.scad
├── print_platform.scad
├── print_canopy.scad
├── print_vehicles.scad
└── README.md
```

## Joints & Clearances

- **Press-fit (0.15mm)**: gear-to-shaft, lid-to-tray, canopy-to-pole
- **Sliding (0.2mm)**: platform on pole, vehicles on pegs
- **Gear backlash (0.2mm)**: between meshing teeth

All validated against Tina2 at 0.4mm nozzle / 0.2mm layer height.
