# Steam Engine Fan

Parametric 3-piece fan assembly for a small steam engine. Driven by a band from the flywheel. Designed to print without supports on a Weedo Tina2 Basic.

## Design

Three separate pieces that assemble after printing:

### Piece 1: Base (`piece1_base.scad`)
- Flat base plate (50×30×3mm) with 4 screw holes for mounting
- Two vertical posts (35mm tall) with open slots at the top
- Axle drops into the slots from above — no enclosed bearings, no supports needed
- Slot bottom at 25mm ensures fan blades clear the mounting surface

### Piece 2: Axle + Pulley (`piece2_axle.scad`)
- 65mm axle shaft (5mm diameter)
- V-groove pulley on one end for the drive band
- Retaining collar to prevent lateral drift
- D-flat on the fan end for keying the blade disc
- Prints on its side, no supports needed

### Piece 3: Fan Disc (`piece3_fan.scad`)
- 6 swept blades (30° pinwheel curve) for airflow
- Central hub with D-shaped hole to key onto the axle
- Prints flat on the bed, no supports needed
- Glue/press-fit onto the axle D-flat after printing

## Assembly

1. Place axle into the base slots (tight press-fit, 0.15mm clearance)
2. Slide fan disc onto the D-flat end of the axle
3. Superglue the fan disc in place
4. Loop drive band over the pulley groove

## Parameters

Key parameters in `fan.scad`:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `fan_radius` | 25 | Fan blade radius (mm) |
| `fan_blades` | 6 | Number of blades |
| `blade_sweep` | 30 | Blade curve angle (degrees) |
| `pulley_radius` | 8 | Pulley wheel radius |
| `axle_length` | 65 | Axle shaft length |
| `axle_radius` | 2.5 | Axle shaft radius |
| `bearing_height` | 35 | Height of support posts |
| `clearance` | 0.15 | Slot-to-axle gap (mm) |
| `d_flat_depth` | 1 | D-shape flat depth for keying |
| `base_screw_hole_radius` | 1.5 | Mounting screw hole size |

## Printing

All three pieces print without supports:

```bash
# Build STLs
docker run --rm -v "$(pwd)/fan:/data" openscad/openscad:latest \
  openscad -o /data/piece1_base.stl /data/piece1_base.scad

docker run --rm -v "$(pwd)/fan:/data" openscad/openscad:latest \
  openscad -o /data/piece2_axle.stl /data/piece2_axle.scad

docker run --rm -v "$(pwd)/fan:/data" openscad/openscad:latest \
  openscad -o /data/piece3_fan.stl /data/piece3_fan.scad
```

### Slice (no supports, raft for bed adhesion)

```bash
docker run --rm -v "$(pwd)/fan:/data:z" \
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

### Print Times (estimated)

| Piece | Time | Filament |
|-------|------|----------|
| Base | ~1h 19m | 3.7m |
| Axle | ~23m | 0.9m |
| Fan disc | ~56m | 1.5m |

## File Structure

```
fan/
├── fan.scad           # Main parametric source (all modules)
├── piece1_base.scad   # Base plate + slot posts
├── piece2_axle.scad   # Axle + pulley + collar
├── piece3_fan.scad    # Swept fan disc with D-hole
└── README.md
```

## Design History

Originally a print-in-place single piece with captive bearings. Redesigned to 3 separate pieces to:
- Eliminate all support material (supports fused to fan blades)
- Allow longer axle without base size constraints
- Fan blades print flat for strength (no delamination)
- Swept blade design for better airflow while remaining support-free
