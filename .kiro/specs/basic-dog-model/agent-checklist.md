# LLM Agent OpenSCAD Validation Checklist

## Pre-Generation Planning

- [ ] Understand the target object requirements
- [ ] Identify printer constraints (build volume, nozzle size, material)
- [ ] Plan model orientation for optimal printing
- [ ] Consider support requirements

## Code Generation

- [ ] Generate syntactically valid OpenSCAD code
- [ ] Use parametric design for easy adjustments
- [ ] Include comments explaining key dimensions
- [ ] Use proper module structure for reusability

## Visual Verification (Self-Verification Loop)

### Step 1: Render Model
- [ ] Generate STL from OpenSCAD code
- [ ] Create isometric render image
- [ ] Create multiple view angles (front, side, top)

### Step 2: Visual Inspection
- [ ] Model matches intended shape
- [ ] Proportions look correct
- [ ] No obvious geometric artifacts
- [ ] All features are present (ears, legs, tail, etc.)
- [ ] Model is centered and properly oriented

### Step 3: Critical Visual Checks
⚠️ **Warning**: Visual inspection alone is insufficient!
- [ ] Check for floating geometry
- [ ] Look for holes or gaps in surfaces
- [ ] Verify wall thickness appears adequate
- [ ] Check for inverted/inside-out surfaces
- [ ] Identify potential overhang issues

## Geometric Validation (Automated)

### Manifold Check
- [ ] Run STL analysis tool
- [ ] Verify model is watertight (no holes)
- [ ] Confirm all edges are connected properly
- [ ] Check for non-manifold edges (edges shared by >2 faces)

### Dimensional Validation
- [ ] Measure bounding box dimensions
- [ ] Verify fits within printer build volume
- [ ] Check minimum feature size ≥ 0.4mm
- [ ] Confirm wall thickness ≥ 1.2mm (use mesh analysis)

### Printability Analysis
- [ ] Calculate overhang angles (should be ≤ 45°)
- [ ] Identify bridging requirements
- [ ] Check base contact area for bed adhesion
- [ ] Verify no trapped internal volumes

## Iteration Decision

If any checks fail:
- [ ] Identify specific geometric issue
- [ ] Modify OpenSCAD code with targeted fix
- [ ] Re-render and re-validate
- [ ] Document what was changed and why

If all checks pass:
- [ ] Proceed to slicing

## Slicing Validation

- [ ] Import STL into slicer without errors
- [ ] Review layer preview for issues
- [ ] Check estimated print time is reasonable
- [ ] Verify material usage is expected
- [ ] Inspect first layer for adequate adhesion
- [ ] Check for support generation (if needed)

## Final Pre-Print Checks

- [ ] G-code generated successfully
- [ ] No slicer warnings or errors
- [ ] Print time < 3 hours (for test prints)
- [ ] Material usage reasonable (~15g for this model)
- [ ] First layer has good bed coverage

## Post-Print Evaluation

- [ ] Print completed without failures
- [ ] Model matches visual expectations
- [ ] Dimensions are accurate
- [ ] Surface quality is acceptable
- [ ] Functional requirements met (if applicable)

## Common Failure Modes to Watch For

### Visual Verification Failures
- **Abstract geometry**: Model looks nothing like intended object
- **Missing features**: Ears, legs, or other parts not present
- **Distorted proportions**: Head too large, legs too thin, etc.
- **Floating parts**: Disconnected geometry

### Geometric Validation Failures
- **Non-manifold**: Holes, gaps, or invalid edge connections
- **Inverted normals**: Inside-out surfaces
- **Self-intersections**: Overlapping geometry
- **Zero-thickness walls**: Surfaces without volume

### Printability Failures
- **Excessive overhangs**: >45° angles without support
- **Too thin walls**: <1.2mm thickness will fail
- **Too small features**: <0.4mm won't print
- **Unstable base**: Model tips over or poor bed adhesion
- **Trapped volumes**: Sealed cavities that can't be cleaned

## Agent Self-Improvement

After each iteration:
- [ ] Document what worked
- [ ] Note what failed and why
- [ ] Record successful parameter ranges
- [ ] Build knowledge base of printable geometries
