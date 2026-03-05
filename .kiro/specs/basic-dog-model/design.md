# Basic Dog Model - Design

## Technical Architecture

### Modeling Approach
We will use **OpenSCAD** via Docker (`openscad/openscad`) for parametric 3D modeling, allowing easy adjustments and reproducible builds.

**Rationale**: 
- Code-based modeling enables version control
- Parametric design allows easy size adjustments
- Generates clean, manifold STL files
- Free and open-source
- Docker ensures consistent environment without local installation

### Model Design Strategy

#### Simplified Geometric Dog
The dog will be composed of basic geometric primitives:

1. **Body**: Elongated ellipsoid (stretched sphere)
2. **Head**: Sphere with slight forward taper
3. **Legs**: Four cylinders with rounded ends
4. **Tail**: Tapered cylinder or cone
5. **Ears**: Two small triangular prisms or cones

#### Design Principles
- **Minimalist**: Focus on recognizable silhouette over detail
- **Print-friendly**: All parts designed for FDM printing
- **Stable base**: Wide leg stance for stability
- **No supports**: Geometry designed to print without supports

### Dimensional Specifications

```
Total Dimensions (target):
- Length: 80mm (body + head)
- Width: 40mm (leg stance)
- Height: 60mm (top of head to ground)

Component Dimensions:
Body:
- Length: 50mm
- Width: 30mm
- Height: 35mm

Head:
- Diameter: 25mm
- Position: Front of body, slightly elevated

Legs (4x):
- Diameter: 8mm
- Length: 30mm
- Spacing: 35mm front-to-back, 25mm side-to-side

Tail:
- Base diameter: 6mm
- Tip diameter: 2mm
- Length: 25mm
- Angle: 30° upward

Ears (2x):
- Width: 8mm
- Height: 12mm
- Thickness: 3mm
```

### Print Orientation
- **Orientation**: Standing upright on all four legs
- **Base contact**: All four leg bottoms touch build plate
- **Rationale**: Natural orientation, no supports needed

### Wall Thickness & Strength
- **Minimum wall thickness**: 2mm (exceeds 1.2mm requirement)
- **Infill recommendation**: 15-20%
- **Shell layers**: 3 perimeters minimum

### Overhang Analysis

```
Component          | Max Overhang | Support Needed
-------------------|--------------|---------------
Body               | 0°           | No
Head-body joint    | ~30°         | No
Legs               | 0°           | No
Tail               | 30°          | No
Ears               | 45°          | No
Belly curve        | ~40°         | No
```

All overhangs are within the 45° printability threshold.

### File Structure

```
models/
├── dog-basic.scad          # OpenSCAD source file
├── dog-basic.stl           # Exported STL for printing
└── README.md               # Print settings and instructions
```

## Implementation Considerations

### OpenSCAD Modules
The design will use modular functions:

```
module dog_body() { ... }
module dog_head() { ... }
module dog_leg() { ... }
module dog_tail() { ... }
module dog_ear() { ... }
module dog_complete() { ... }  // Assembles all parts
```

### Parameters
Key parameters will be configurable:
- `scale_factor`: Overall size multiplier
- `leg_diameter`: Thickness of legs
- `body_length`: Length of body
- `head_size`: Size of head

### Manifold Geometry
- All unions will use proper overlap (0.1mm minimum)
- No floating geometry
- All surfaces closed
- Normals facing outward

### Export Settings
- **Resolution**: $fn=50 (smooth curves without excessive polygons)
- **Format**: Binary STL (smaller file size)
- **Units**: Millimeters

## Print Settings Recommendations

### Slicer Settings (for Tina2 Basic)
```
Material: PLA
Nozzle Temperature: 200°C
Bed Temperature: 60°C
Layer Height: 0.2mm
Print Speed: 50mm/s (slightly below max for quality)
Infill: 15%
Supports: None
Brim: Optional (5mm for bed adhesion)
```

### Estimated Print Metrics
- **Print time**: ~2 hours
- **Material usage**: ~15g PLA
- **Layer count**: ~300 layers

## Error Handling

### Common Issues & Solutions

**Issue**: Legs not adhering to bed  
**Solution**: Add 5mm brim in slicer

**Issue**: Tail drooping during print  
**Solution**: Reduce tail angle to 20° or make tail thicker

**Issue**: Model too large for bed  
**Solution**: Adjust `scale_factor` parameter in SCAD file

**Issue**: Rough surface finish  
**Solution**: Reduce print speed to 40mm/s, increase $fn to 60

## Testing Strategy

### LLM Agent Best Practices for OpenSCAD

Based on research from OpenSCAD-Bench and recent LLM 3D modeling work:

**Self-Verification Loop:**
1. Generate OpenSCAD code
2. Render the model to image
3. Use multimodal vision to verify the output matches intent
4. Iterate on code until satisfied
5. Validate printability constraints

**Key Challenges:**
- LLMs can produce syntactically valid but geometrically incorrect models
- Visual verification has limitations ("r's in strawberry" effect) - models may look correct at high level but have mangled geometry
- Need explicit geometric validation, not just visual inspection

**Best Practices:**
- Always render and visually inspect generated models
- Use automated geometry checks (manifold, dimensions, wall thickness)
- Iterate with specific feedback about geometric issues
- Test with simple primitives before complex shapes
- Verify against printability constraints

**See**: `agent-checklist.md` for complete validation workflow

### Printability Validation Checklist

Before printing, verify:

#### Geometry Integrity
- [ ] **Manifold/Watertight**: No holes, gaps, or non-manifold edges
- [ ] **Correct Normals**: All faces oriented outward
- [ ] **No Self-Intersections**: No overlapping geometry
- [ ] **Closed Volume**: Model defines a solid volume

#### Dimensional Constraints
- [ ] **Build Volume**: Fits within printer dimensions (100×120×100mm for Tina2 Basic)
- [ ] **Minimum Feature Size**: All features ≥ 0.4mm (nozzle diameter)
- [ ] **Wall Thickness**: All walls ≥ 1.2mm (minimum), 2mm+ for functional parts
- [ ] **Layer Height Compatible**: Features align with 0.2mm layer height

#### Print Orientation & Supports
- [ ] **Overhang Angle**: All overhangs ≤ 45° (or support structures added)
- [ ] **Bridging Distance**: Unsupported spans ≤ 10mm
- [ ] **Base Stability**: Model has stable base for bed adhesion
- [ ] **Support Accessibility**: Support structures can be removed

#### Material Considerations (PLA)
- [ ] **No Thin Spikes**: Avoid features that will break during removal
- [ ] **Adequate Infill Paths**: Internal geometry allows infill generation
- [ ] **No Trapped Volumes**: No sealed internal cavities (unless intentional)

#### Slicing Validation
- [ ] **No Errors in Slicer**: Model imports without warnings
- [ ] **Reasonable Print Time**: < 3 hours for test prints
- [ ] **Material Usage**: Within expected range (~15g for this model)
- [ ] **First Layer Coverage**: Good bed adhesion area

### Validation Steps
1. **Geometry check**: Import STL into slicer, verify no errors
2. **Dimension check**: Measure bounding box in slicer
3. **Overhang check**: Use slicer's overhang visualization
4. **Slicing test**: Generate G-code and review layer preview
5. **Test print**: Print on Tina2 Basic with recommended settings

### Success Criteria
- ✓ STL imports without errors
- ✓ Dimensions within 90×110×90mm
- ✓ No support structures required
- ✓ Print completes successfully
- ✓ Model stands upright without tipping
- ✓ Recognizable as a dog

## Future Enhancements
- Add parametric breed variations (long ears, short legs, etc.)
- Include optional collar or accessories
- Create sitting/lying pose variants
- Add texture details (fur patterns)
