# Carousel — Requirements

## Overview

A miniature fairground carousel driven by a steam engine via a band-and-spindle mechanism. The design uses bevel gears to convert horizontal drive rotation into vertical carousel rotation. Fits within a 90mm envelope and prints without supports on a Weedo Tina2 Basic (100×100×100mm bed).

## User Stories

### US-1: Band Drive Input

As a user, I want the carousel driven by a rubber band from the steam engine flywheel, so that it integrates with the existing engine setup.

**Acceptance Criteria:**
- WHEN the band is looped between the engine flywheel and the carousel input spindle THE SYSTEM SHALL transfer rotational motion to the carousel mechanism
- THE carousel input spindle SHALL have a V-groove pulley compatible with the engine drive band
- THE input spindle SHALL rotate on a horizontal axis (matching the engine flywheel orientation)

### US-2: Gear System (Angle Conversion)

As a user, I want bevel gears to convert horizontal rotation to vertical rotation, so that the carousel platform spins on a vertical axis.

**Acceptance Criteria:**
- WHEN the input spindle rotates THE SYSTEM SHALL transfer rotation through a bevel gear pair to a vertical output shaft
- THE bevel gear pair SHALL change the axis of rotation by 90 degrees (horizontal input → vertical output)
- THE gear ratio SHALL reduce speed (input faster than carousel rotation) for a realistic carousel appearance
- THE gears SHALL mesh without binding when assembled from separate printed pieces

### US-3: Carousel Platform

As a user, I want a rotating platform with vehicle mounts, so that miniature vehicles orbit when the carousel spins.

**Acceptance Criteria:**
- WHEN the vertical shaft rotates THE SYSTEM SHALL spin the carousel platform
- THE platform SHALL have attachment points for at least 4 vehicles
- THE platform SHALL be visually recognisable as a fairground carousel (circular, with a canopy/roof)

### US-4: Vehicles

As a user, I want different miniature vehicles on the carousel, so that it looks like a real fairground ride.

**Acceptance Criteria:**
- THE carousel SHALL include at least 3 different vehicle types (e.g., horse, car, rocket, swan)
- THE vehicles SHALL slot onto the platform attachment points
- THE vehicles SHALL be printable without supports (flat base or designed for bed orientation)

### US-5: Size Constraints

As a user, I want the entire assembly to fit within 90mm maximum dimension, so that it prints on the Tina2 and sits alongside the steam engine at scale.

**Acceptance Criteria:**
- THE fully assembled carousel SHALL NOT exceed 90mm in any single dimension (X, Y, or Z)
- WHEN individual sections are separated for printing EACH section SHALL fit within 100×100×100mm build volume
- EACH section SHALL fit within 84mm footprint (allowing 8mm raft margin each side)

### US-6: Multi-Section Printability

As a user, I want the carousel split into sections that print without supports, so that print quality is high and post-processing is minimal.

**Acceptance Criteria:**
- THE design SHALL be a single OpenSCAD file with modules for each printable section
- WHEN a section is selected for printing THE SYSTEM SHALL export only that section's geometry
- EACH section SHALL print without support material (all overhangs ≤ 45° or bridgeable)
- ALL sections SHALL connect via slot/tab/press-fit joints (no glue required for structural assembly)

### US-7: Assembly

As a user, I want all sections to slot together without glue, so that assembly is simple and the carousel can be disassembled if needed.

**Acceptance Criteria:**
- THE base and gear housing SHALL connect via tabs/slots
- THE vertical shaft SHALL press-fit into the gear output
- THE platform SHALL attach to the vertical shaft with a keyed connection (D-flat or similar)
- THE canopy/roof SHALL slot onto the platform
- THE vehicles SHALL slot into platform mounts

### US-8: Tina2 Compatibility

As a user, I want all pieces printable on the Weedo Tina2 Basic without heated bed, so that I can use my existing printer.

**Acceptance Criteria:**
- WHEN sliced for the Tina2 ALL pieces SHALL use a raft for cold bed adhesion
- THE design SHALL account for 0.4mm nozzle and 0.2mm layer height tolerances
- EACH gear tooth SHALL be at least 1mm wide (printable at 0.4mm nozzle)
- Press-fit joints SHALL use 0.15mm clearance (validated on the fan project)

## Constraints

- **Maximum size**: 90mm in any dimension (assembled)
- **Printer**: Weedo Tina2 Basic, 100×100×100mm, no heated bed, PLA
- **Nozzle**: 0.4mm
- **Supports**: None — all pieces designed for support-free printing
- **Source**: Single OpenSCAD file (`carousel.scad`) with per-piece export modules
- **Drive**: Band from steam engine flywheel → input spindle with V-groove pulley
- **Joint method**: Press-fit slots/tabs, 0.15mm clearance, no glue for structure

## Resolved Decisions

1. **Gear ratio**: Keep simple for now — 1:1 or 2:1, optimise later
2. **Vehicle count**: 4 vehicles, evenly spaced at 90°
3. **Vehicle mounting**: Sitting on a flat platform (not suspended/hanging)
4. **Canopy**: Plain cone — no decorative detail, easy to print
