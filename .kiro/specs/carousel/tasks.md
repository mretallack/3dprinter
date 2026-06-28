# Carousel — Tasks

## Implementation Plan

### Phase 1: Core Mechanics (gears + housing)

- [ ] **Task 1**: Create `carousel/carousel.scad` with parameters block (all dimensions, clearances, tooth specs)
- [ ] **Task 2**: Implement `spur_gear()` module — flat disc with 12 trapezoidal teeth on circumference
- [ ] **Task 3**: Implement `crown_gear()` module — flat disc with 12 trapezoidal face teeth + nub below + stub above
- [ ] **Task 4**: Implement `housing_tray()` module — open-top box with floor bore, two spindle bores, screw holes, flange
- [ ] **Task 5**: Implement `housing_lid()` module — flat plate with output bore, tab clips to attach to tray
- [ ] **Task 6**: Implement `input_spindle()` module — horizontal shaft with integrated V-groove pulley + D-flat + collar
- [ ] **Task 7**: Render Phase 1 — generate STLs, render from multiple angles, send to user for review
- [ ] **Task 8**: Test print gears — slice and print spur + crown side by side, verify mesh

### Phase 2: Rotating Assembly

- [ ] **Task 9**: Implement `centre_pole()` module — 8mm diameter cylinder, D-hole bottom, collar, D-flat top section
- [ ] **Task 10**: Implement `platform()` module — 40mm disc, centre bore (slides over pole), 4 pegs at 90°
- [ ] **Task 11**: Implement `canopy()` module — plain cone (45° slope), centre hole for pole top press-fit
- [ ] **Task 12**: Render Phase 2 — generate STLs, render from multiple angles, send to user for review
- [ ] **Task 13**: Test print pole + platform + canopy — verify fit, collar positioning, spin

### Phase 3: Vehicles

- [ ] **Task 14**: Implement `vehicle_horse()` — 2D horse profile polygon, extruded 3mm, hole in base
- [ ] **Task 15**: Implement `vehicle_car()` — 2D car profile polygon, extruded 3mm, hole in base
- [ ] **Task 16**: Implement `vehicle_rocket()` — 2D rocket profile polygon, extruded 3mm, hole in base
- [ ] **Task 17**: Implement `vehicle_boat()` — 2D boat profile polygon, extruded 3mm, hole in base
- [ ] **Task 18**: Render Phase 3 — generate STLs, render vehicles, send to user for review
- [ ] **Task 19**: Test print all 4 vehicles, verify peg fit

### Phase 4: Assembly & Print Files

- [ ] **Task 20**: Implement `assembly()` module — full carousel preview with all pieces positioned
- [ ] **Task 21**: Render full assembly — multiple angles, send to user for final review
- [ ] **Task 22**: Create per-piece print `.scad` files (8 files, each `use <carousel.scad>`)
- [ ] **Task 23**: Full test print of all sections, assemble, verify drive function
- [ ] **Task 24**: Update `carousel/README.md` with build/assembly instructions

## Dependencies

```
Task 1 → Tasks 2-6 (parameters needed first)
Tasks 2,3 → Task 7 (test print gears)
Tasks 4,5,6 → Task 7 (housing needed to test mesh)
Task 7 ✓ → Tasks 8-10 (proceed once gears verified)
Tasks 8-10 → Task 11 (test rotating assembly)
Task 11 ✓ → Tasks 12-16 (proceed once platform verified)
Tasks 2-16 → Task 17 (all modules needed for assembly)
Task 17 → Task 18 (assembly validates positions before print files)
```

## Notes

- Phase 1 is the riskiest (gear mesh). Print and test gears before proceeding.
- Each task should produce a renderable/printable output.
- Keep parameters at top of file — if gear test fails, adjust tooth size/count and reprint.
