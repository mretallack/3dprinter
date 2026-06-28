# Carousel — Design

## Architecture Overview

```
        [Cone Canopy]        ← Press-fits onto pole top
             |
        [Platform]           ← Slides down pole, rests on collar
             |
        [Centre Pole]        ← 8mm diameter, collar, D-flat bottom
             |
     [Crown Gear + stub]     ← Sandwiched in housing (floor bore + lid bore)
        [Spur Gear]          ← On horizontal spindle, against housing wall
             |
  [Housing Tray + Lid]       ← Two-piece enclosed box, screw holes in tray
             |
  ← Band from engine →      ← Input spindle with integrated V-groove pulley
```

## Mechanical Layout

### Drive Train (side view)

```
Engine flywheel                    Carousel
     ○ ←── band ──→ ○─────┐
                   pulley  │ input spindle (horizontal)
                           │
                      ╔════╧════╗
                      ║  crown  ║  housing (tray + lid)
                      ║ & spur  ║
                      ╚════╤════╝
                           │  centre pole (vertical)
                           │
                      ┌────┴────┐
                      │platform │  ← rests on collar
                      └────┬────┘
                           │
                        [cone]   ← press-fit on pole top
```

### Gear System: Crown-and-Spur

- **Spur gear**: standard flat disc with trapezoidal teeth on circumference, mounted on horizontal input spindle
- **Crown gear**: flat disc with trapezoidal teeth on its face (pointing upward), meshing with spur gear at 90°
- **Tooth profile**: trapezoidal (flat top, 20° angled sides) — simple, printable, forgiving
- **Tooth count**: 12 teeth each (1:1 ratio)
- **Pitch diameter**: ~15mm
- **Backlash**: 0.2mm between meshing teeth

### Crown Gear Detail

```
        ┌── stub (D-flat, connects to pole)
        │
   ═════╪═════  ← teeth on top face
   │  crown  │
   ═══╪═══════
       │
       └── nub (sits in housing floor bore)
```

- Nub below: ~4mm long, sits in housing floor bore (bearing point)
- Gear disc: teeth on top face
- Stub above: ~5mm, passes through lid bore (bearing point), D-flat for pole connection

### Input Spindle

- Integrated pulley on exterior end (V-groove for band)
- D-flat section inside housing where spur gear keys on
- Collar on spindle (inboard side of gear) prevents lateral drift
- Gear positioned against inner housing wall (acts as stop on one side)
- Prints on its side (like fan axle)

## Printable Sections

| Section | Description | Orientation | Supports |
|---------|-------------|-------------|----------|
| Housing tray | Open-top box with floor bore, screw holes, spindle bores | Flat on bed | None |
| Housing lid | Flat plate with output bore, clips onto tray | Flat on bed | None |
| Input spindle + pulley | Horizontal shaft with V-groove | On its side | None |
| Spur gear | Flat disc with perimeter teeth | Flat on bed | None |
| Crown gear | Disc with face teeth + stub + nub | Flat (teeth up) | None |
| Centre pole | 8mm cylinder with collar + D-flat | Standing up | None |
| Platform | 40mm disc with centre hole + 4 pegs | Flat on bed | None |
| Cone canopy | Plain cone with centre hole | Upside-down (point on bed, ≤45°) | None |
| Vehicles ×4 | 2D profile cutouts, 3mm thick | Flat on bed | None |

## Joints & Assembly

### Assembly Order

1. Place crown gear nub into housing tray floor bore
2. Thread input spindle through housing tray walls
3. Slide spur gear onto spindle D-flat (against inner wall)
4. Close lid (traps gears, crown stub passes through lid bore)
5. Slide centre pole D-hole onto crown gear stub
6. Slide platform down pole (rests on collar)
7. Press-fit canopy onto pole top
8. Slot vehicles onto platform pegs

### Joint Types

| Joint | Type | Clearance |
|-------|------|-----------|
| Housing tray ↔ lid | Tab/clip | 0.15mm |
| Spindle in housing walls | Bore | 0.15mm |
| Spur gear on spindle | D-flat | 0.15mm |
| Crown gear in housing bores | Cylindrical bore (top & bottom) | 0.15mm |
| Pole onto crown stub | D-hole | 0.15mm |
| Platform on pole | Sliding fit, rests on collar | 0.2mm |
| Canopy on pole top | Press-fit | 0.15mm |
| Vehicles on pegs | Peg/hole | 0.2mm |

## Dimensions Budget

Total assembled height (90mm max):
- Housing tray: 20mm
- Housing lid: 3mm
- Centre pole (visible above lid): ~35mm
- Platform: 3mm
- Canopy: 20mm
- **Total: ~81mm** ✅

Total assembled width (90mm max):
- Housing: 30mm
- Pulley overhang: ~12mm
- **Total: ~42mm from centre = 54mm** ✅

Platform + vehicles:
- Platform: 40mm diameter
- Vehicle overhang: ~8mm each side
- **Total: ~56mm** ✅

## Vehicles (Flat Profile Cutouts)

Each vehicle is a 2D polygon extruded to 3mm thick, ~8×10mm:
- **Horse**: classic carousel horse profile
- **Car**: simple sedan silhouette
- **Rocket**: pointed nose, fins at base
- **Boat**: hull profile with cabin bump

Each has a 2mm hole in its base to slot onto platform pegs.

## Clearances & Tolerances

| Joint | Clearance | Notes |
|-------|-----------|-------|
| Gear teeth mesh | 0.2mm backlash | Prevents binding |
| Shaft in bore | 0.15mm | Tight press-fit (validated on fan) |
| Tab/slot joints | 0.15mm | Snug assembly |
| Peg/hole (vehicles) | 0.2mm | Easy insert/remove |
| Canopy over pole | 0.15mm | Press-fit |
| Platform on pole | 0.2mm | Needs to spin freely with pole |

## OpenSCAD File Structure

Single file `carousel.scad`:

```openscad
// Parameters at top

module housing_tray() { ... }
module housing_lid() { ... }
module input_spindle() { ... }
module spur_gear() { ... }
module crown_gear() { ... }
module centre_pole() { ... }
module platform() { ... }
module canopy() { ... }
module vehicle_horse() { ... }
module vehicle_car() { ... }
module vehicle_rocket() { ... }
module vehicle_boat() { ... }
module assembly() { ... }  // full preview
```

Per-piece print files (each `use <carousel.scad>`):
```
print_housing_tray.scad
print_housing_lid.scad
print_spindle.scad
print_gears.scad        ← spur + crown side by side
print_pole.scad
print_platform.scad
print_canopy.scad
print_vehicles.scad     ← all 4 arranged on bed
```

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Gear teeth don't mesh | 0.2mm backlash, test gears first as standalone print |
| Crown gear binds in housing | Two bearing points (floor + lid), 0.15mm clearance |
| Canopy overhang too steep | 45° max (20mm tall, 20mm radius = exactly 45°) |
| Spindle pulled sideways by band | Two bearing points (both housing walls) |
| Pole wobbles | 8mm diameter (thicker), tight bore fit |
| Vehicles fall off | Friction fit pegs, 0.2mm clearance |
| Platform slides on pole | Collar sets height, canopy traps from above |
