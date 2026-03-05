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
Final Model Dimensions (Iteration 4):
- Length: 44.0mm (body + head + snout)
- Width: 24.9mm (leg stance)
- Height: 32.9mm (top of ears to ground)

Component Dimensions:
Body (hull-based):
- Ellipsoid: 25mm diameter, scaled 1.4x1.0x1.2
- Connected to leg bases via hull

Head:
- Diameter: 13mm sphere
- Snout: 7mm sphere
- Connected via hull for smooth transition

Legs (4x):
- Front legs: 5mm diameter, 10mm height
- Back legs: 5.5mm diameter, 8mm height (sitting)
- Spacing: ~14mm front-to-back, ~16mm side-to-side

Tail:
- Base: 3mm diameter
- Tip: 1.5mm diameter
- Length: ~6mm (hull-based)

Ears (2x):
- Top: 4mm diameter sphere
- Bottom: 3mm diameter sphere
- Height: ~8mm (hull-based)
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

### Systematic Iteration Approach

**Iteration Management System:**

To achieve high-quality results matching reference photos, we use a systematic iteration approach:

1. **Feature Checklist** (`feature-checklist.md`)
   - 27 detailed features across 5 categories
   - Head, Ears, Body, Legs, Other features
   - Scoring system: Critical (must have), Important (should have), Nice-to-have
   - Target: 87.5% (35/40 features minimum)

2. **Iteration Files** (`iterations/dog-iter-XXX.*`)
   - Each iteration has separate `.scad`, `.stl`, `.jpg` files
   - Numbered sequentially (020, 021, 022, etc.)
   - Preserves history for comparison
   - Allows rollback if iteration regresses

3. **Iteration Workflow**
   ```bash
   # Copy previous iteration
   cp iterations/dog-iter-021.scad iterations/dog-iter-022.scad
   
   # Make targeted improvements in .scad file
   # Generate STL
   docker run --rm -v "$PWD/iterations:/work:z" -w /work \
     openscad/openscad:latest openscad -o dog-iter-022.stl dog-iter-022.scad
   
   # Generate render
   python3 render-iteration.py iterations/dog-iter-022.stl iterations/dog-iter-022.jpg
   
   # Score features
   python3 score-iteration.py 22
   
   # Compare with previous iteration
   ```

4. **Feature Scoring**
   - Automated scoring against checklist
   - Visual comparison with reference photo
   - Progress tracking (e.g., 92.6% → 100%)
   - Identifies missing/weak features

5. **Comparison Strategy**
   - Side-by-side render comparison
   - Reference photo overlay
   - Feature-by-feature validation
   - Ensure each iteration improves or maintains quality

**Iteration Progress:**
- Iteration 1-5: Failed (non-manifold geometry)
- Iteration 6-20: Progressive refinement (sitting pose, proportions)
- Iteration 21: 92.6% (added eyes, nose)
- Iteration 22: 100% target (eyebrows, belly tuck)

### OpenSCAD Modules

**Final Approach (Iteration 20+ - Successful):**

The design uses `hull()` operations for guaranteed manifold geometry:

```
module dog_complete() {
    // Main body with legs using hull for smooth connection
    hull() {
        // Body center + leg bases
    }
    
    // Individual legs (cylinders)
    
    // Head and snout with hull
    hull() {
        // Head sphere + snout sphere
    }
    
    // Ears with hull (smooth connections)
    
    // Tail with hull
    
    // NEW in iter 21+: Eyes, nose, eyebrows
}
```

**Key Learnings from Iterations:**

**Iteration 1-3 Failures:**
- ❌ Using `scale()` on spheres created non-manifold edges
- ❌ Simple `union()` of primitives produced floating geometry
- ❌ Complex boolean operations failed to create watertight meshes
- ❌ Visual inspection alone missed severe geometric issues

**Iteration 4-20 Success:**
- ✅ `hull()` operations guarantee manifold geometry
- ✅ Smooth transitions between all components
- ✅ No floating or disconnected triangles
- ✅ Solid, printable mesh topology

**Iteration 21+ Refinement:**
- ✅ Added fine details (eyes, nose, eyebrows)
- ✅ Improved proportions based on feature checklist
- ✅ Systematic comparison with reference photo
- ✅ Feature scoring ensures completeness

**Critical Design Principles:**
1. Use `hull()` for all connections between primitives
2. Avoid complex `scale()` operations on spheres
3. Keep geometry simple - spheres and cylinders only
4. Always validate with both visual AND geometric checks
5. Render with solid surfaces to verify mesh quality
6. Use systematic iteration with feature tracking
7. Compare each iteration against previous and reference
8. Score features to ensure progress toward target

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
- **Resolution**: $fn=30 (balance between smoothness and render time)
- **Format**: Binary STL (smaller file size)
- **Units**: Millimeters
- **Result**: 5,220 triangles, 2.2MB file

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
- **Print time**: ~1-1.5 hours (smaller than original estimate)
- **Material usage**: ~8-10g PLA (compact design)
- **Layer count**: ~165 layers (at 0.2mm layer height)

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
