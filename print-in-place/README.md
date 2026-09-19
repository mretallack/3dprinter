# Print-in-Place (PiP) Mechanisms & Slicing Guide

A comprehensive guide and reference for printing fully functional, multi-part moving assemblies (such as planetary gears, hinges, and chains) as a single object on the print bed without requiring post-assembly.

## How Print-in-Place Mechanisms Work
Print-in-place designs rely on geometrical air gaps intentionally created in the 3D model between parts that move relative to one another (e.g., between gear teeth, shafts, and hubs).

- **Bridging & Overhang Angles:** Moving components are designed with steep overhang angles (typically $45^\circ$ or steeper relative to the bed) or chamfered/teardrop profiles. This allows upper layers to bridge or overhang cleanly in mid-air over lower layers without sagging onto the adjacent moving part.
- **Trapped Geometries:** Enclosed, interlocking shapes (like a shaft with a flared flange or an internal planetary ring gear) keep the internal components physically trapped in position so they cannot fall out, while the physical gap ensures they can rotate independently once broken free.
- **Initial Break-Free Torque:** When freshly printed, small microscopic bridges or plastic stringing may bridge the gap. Applying a deliberate twist or leverage breaks these micro-fusions along the gap, freeing the gears to rotate.

---

## Essential Slicer Settings to Prevent Fusion
If the clearance gap in the CAD design is around $0.2\text{ mm}$ to $0.3\text{ mm}$, the following slicer configurations ensure the plastic stays cleanly within its intended boundary:

1. **Initial Layer Horizontal Expansion (First Layer Elephant’s Foot)**
   - *Problem:* The first layer is often squished into the build plate for adhesion, causing the molten plastic to spread horizontally and fuse adjacent gear teeth at the base.
   - *Setting:* Set Initial Layer Horizontal Expansion (or Elephant Foot Compensation) to **$-0.1\text{ mm}$ to $-0.15\text{ mm}$**.
   - *Effect:* Pulls back the contour of the first layer slightly to compensate for squish.

2. **Precise Extrusion & Flow Rate (Slicing Tolerances)**
   - *Problem:* Over-extrusion causes plastic to overflow the intended perimeter line, bridging the functional air gap.
   - *Setting:* Calibrate your overall Flow Rate / Extrusion Multiplier (lowering it to **$97\%-98\%$** for PiP parts if your printer over-extrudes slightly).
   - *Slicing Tolerance:* Set Slicing Tolerance (in Cura/OrcaSlicer) to **Exclusive**. This ensures the slicer measures feature boundaries inside the model line rather than straddling or expanding outside it.

3. **Seam Placement & Z-Hop**
   - *Problem:* If the Z-seam (where a perimeter loop starts and ends) is placed inside the tolerance gap, the retraction blob will fuse the gear teeth or shaft.
   - *Setting:* Set Seam Position to **User Specified / Sharpest Corner** or manually paint the seam on the outer exposed surfaces of the model, far away from the internal gaps.
   - *Retraction:* Enable **Z-Hop on Retraction ($0.2\text{ mm}$)** to prevent the nozzle from dragging across or pushing filament blobs into internal gaps during travel moves.

4. **Cooling & Layer Print Time**
   - *Problem:* If freshly extruded plastic remains hot and soft, gravity and radiation heat cause adjacent walls to sag and weld together.
   - *Setting:* Set Part Cooling Fan to **$100\%$** after the first few layers.
   - *Min Layer Time:* Ensure Minimum Layer Time is set to at least **$10-15\text{ seconds}$** so each layer fully solidifies before the nozzle returns to deposit the next layer directly above or adjacent to it.

---

## Verification Test
To verify if your slicer settings are dialed in before committing to a multi-hour print-in-place gear assembly, print a simple 2-part clearance calibration tower/gauge (tests gaps ranging from $0.4\text{ mm}$ down to $0.1\text{ mm}$). If the $0.2\text{ mm}$ gap breaks free with minimal hand force, your print-in-place gears will print cleanly without fusing.
