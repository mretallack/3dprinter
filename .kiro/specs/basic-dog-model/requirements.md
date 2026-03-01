# Basic Dog Model - Requirements

## Overview
A simple 3D printable dog model designed for the Tina2 Basic printer as a test print to validate printer capabilities and settings.

## Printer Constraints (Tina2 Basic)

### Build Volume
- **Max Print Size**: 100mm × 120mm × 100mm (W × D × H)
- **Limitation**: Smaller than average build volume

### Printer Capabilities
- **Design**: CoreXY (fixed bed, excellent stability)
- **Max Speed**: 60 mm/s (slower than average)
- **Bed Surface**: Plastic (lightweight, affordable)
- **Auto Leveling**: Yes (consistent first layers)
- **Direct Drive Extruder**: Yes (better quality, supports flexible materials)
- **Pre-Assembled**: Yes (beginner-friendly)

### Material Support
- **Primary**: PLA (nozzle ≥180°C, bed ≥50°C)
- **Also Supports**: PETG, TPU, ABS, Nylon, ASA

## User Stories & Requirements

### US-1: Model Size
**As a** Tina2 Basic user  
**I want** a dog model that fits within the build volume  
**So that** I can print it without scaling issues

WHEN the model is loaded into a slicer  
THE SYSTEM SHALL ensure the model dimensions do not exceed 90mm × 110mm × 90mm (10mm safety margin)

### US-2: Print Simplicity
**As a** beginner 3D printer user  
**I want** a model with minimal overhangs and supports  
**So that** the print succeeds without complex support removal

WHEN the model is sliced  
THE SYSTEM SHALL minimize overhangs beyond 45 degrees  
THE SYSTEM SHALL avoid requiring internal supports

### US-3: Print Time
**As a** user testing printer capabilities  
**I want** a print that completes in reasonable time  
**So that** I can validate settings without waiting hours

WHEN the model is sliced at 60mm/s with 0.2mm layer height  
THE SYSTEM SHALL complete printing in under 3 hours

### US-4: Material Compatibility
**As a** Tina2 Basic user  
**I want** a model optimized for PLA  
**So that** I can use the most beginner-friendly material

WHEN printing with PLA at 200°C nozzle and 60°C bed  
THE SYSTEM SHALL produce a successful print with standard settings

### US-5: Recognizable Design
**As a** user  
**I want** the model to be clearly recognizable as a dog  
**So that** the test print is visually satisfying

WHEN the print completes  
THE SYSTEM SHALL produce a model with identifiable dog features (head, body, legs, tail)

### US-6: Structural Integrity
**As a** user  
**I want** a model that is structurally sound  
**So that** it doesn't break during or after printing

WHEN the model is printed  
THE SYSTEM SHALL have wall thickness of at least 1.2mm  
THE SYSTEM SHALL have stable base for standing without support

### US-7: File Format
**As a** 3D printer user  
**I want** the model in STL format  
**So that** it's compatible with all slicing software

WHEN the model is exported  
THE SYSTEM SHALL provide an STL file with manifold geometry

## Acceptance Criteria

- Model dimensions: ≤ 90mm × 110mm × 90mm
- Overhangs: ≤ 45 degrees where possible
- Wall thickness: ≥ 1.2mm
- Base stability: Model stands upright without tipping
- Print time: < 3 hours at 60mm/s, 0.2mm layers
- File format: STL with no errors
- Recognizable as a dog with basic features
- No internal voids or non-manifold geometry
