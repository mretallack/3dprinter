# CLIPGEAR - Infinite Modular Snap-Together Gear System

An infinitely expandable, snap-together gear system for endless mechanical creations and satisfying fidgets by **Abílio Costa**.

## Summary & Features
- Modular snap-together bases and pin system.
- Supports 1:2 and 2:1 gear ratios (16, 24, and 32 teeth).
- Special accessories including hand crank, two-part crank body, and spinning fan.

---

## What We Did & How We Did It

1. **Model Inspection & Documentation Review:**
   - Examined the downloaded ZIP archive and PDF documentation.
   - Identified recommended print settings: 0.20 mm layer height, no supports, low infill (15-20%), and PLA/PETG material (PETG recommended for bases to ease snap connections).

2. **Base Plate Print (4x Bases):**
   - Calculated build plate capacity for the **Weedo Tina2 Basic** printer (100×100×100 mm build volume).
   - Arranged a **2×2 grid** of tighter-pin bases (`clipgear-base-tighter-gear-pin.stl`).
   - Sliced using **CuraEngine 5.13.0** with Tina2 overrides (raft adhesion, 0.20 mm layer height, 15% infill).
   - Uploaded and successfully printed via the **OctoPrint API**.

3. **Starter Gear Set Optimization & Collision Verification:**
   - Curated a starter plate containing:
     - 16-tooth gear (`clipgear-gear-16.stl`)
     - 32-tooth gear (`clipgear-gear-32.stl`)
     - 16-32 compound gear (`clipgear-gear-16-32.stl`)
     - Hand crank handle (`clipgear-crank-handle.stl`)
     - Two-part crank body (`clipgear-special-16-24-crank-body.stl`)
     - Spinning fan attachment (`clipgear-special-16-24-fan.stl`)
   - **Collision Detection & Spacing:** Used **Python-FCL (Flexible Collision Library)** to programmatically test and verify zero overlap and proper minimum clearance between all parts.
   - **Bed Fit Optimization:** Asymmetrically tuned grid spacing to fit within the 100×100 mm bed footprint while respecting raft margins.
   - **Rendering:** Generated professional isometric and top-down preview renders using `.kiro/skills/render-openscad/render_stl.py`.

---

## Directory Structure

```text
clipgear/
├── Bases/                               # Original base STLs (tighter & looser pins)
├── Gears/                               # Gear STLs (16, 24, 32 teeth & compound variants)
├── Special gears/                       # Crank and fan accessory STLs
├── four_bases.stl                       # 2x2 grid multi-base print file
├── four_bases_render.png                # Render preview of 4x bases
├── starter_gears_perfect_fit.stl        # FCL collision-verified starter gear plate
├── starter_gears_perfect_fit_render.png # Isometric render preview of starter gears
└── starter_gears_topdown.png            # Top-down render preview of starter gears
```

---

## License

This work is licensed under a **Creative Commons (4.0 International License) Attribution**.

- **✖** | Sharing without ATTRIBUTION  
- **✔** | Remix Culture allowed  
- **✔** | Commercial Use  
- **✔** | Free Cultural Works  
- **✔** | Meets Open Definition

---

## Troubleshooting & Strength Improvements (Snap-Fit Clips)

If the snap-fit clips on the base parts break during assembly:
- **Root Cause:** Low infill (e.g., 15%) leaves the internal structure of thin snap clips hollow or sparsely supported, causing shear or snapping under bending stress.
- **Material Choice:** While PLA works, the designer recommends **PETG** for bases because of its elasticity and high interlayer adhesion, allowing clips to flex repeatedly without breaking.
- **Reinforced Print Profile:** We created a reinforced slice (`four_bases_reinforced.gcode`) featuring:
  - **Infill:** Increased to **40%** (grid/gyroid).
  - **Walls / Perimeters:** Increased to **4 walls** (since snap-fit strength relies primarily on perimeter shells).

---

## Starter Gears & Accessories Plate

- **STL File:** `starter_gears_perfect_fit.stl` (FCL collision-verified, optimized aspect ratio spacing with zero overlap and safe 100x100mm bed edge clearance).
- **Reinforced GCode:** `starter_gears_reinforced.gcode`
- **Print Parameters:**
  - **Layer Height:** 0.20 mm
  - **Infill Density:** **30%** (for high mechanical gear torque resistance)
  - **Wall Line Count:** **3 walls** (for robust gear teeth and handle strength)
  - **Adhesion:** Raft
- **Estimated Print Time:** ~3 hours 35 minutes
- **Filament Length:** ~9.87 meters

---

## Model Z-Axis Alignment Note (Special Wheel / Fly Disk)
- **Issue:** The original STL file for `clipgear-special-24-24-wheel.stl` had a native offset where its bottom face sat at $Z = 9.0\text{ mm}$ instead of $Z = 0.0\text{ mm}$, causing it to slice and attempt printing floating in mid-air.
- **Fix:** Pre-processed the mesh using Trimesh to align its lowest point flat to $Z = 0.0\text{ mm}$ (`wheel_fixed_z.stl`) before slicing. Always verify model Z-bounds before slicing parts with non-zero native origins.
