# Print-in-Place Interlocking Modular Gear System - Design Specification

## Overview
A modular desktop utility and interactive mechanical assembly that combines print-in-place (PiP) involute gear mechanisms with snap-fitting modular extension points. The entire assembly prints as a single cohesive unit on the build plate without supports, requiring zero post-assembly.

---

## Core Architecture & Features

### 1. Print-in-Place Mechanical Core
- **Zero Assembly:** Primary gear clusters (such as central drive gears and satellite/planet gears) print fully interlocked and functional in a single print job.
- **Precision Clearances ($0.2\text{ mm}$):** Designed with an intentional air gap between moving tooth flanks and rotating shafts, preventing fusion while keeping components trapped.
- **Initial Break-Free Torque:** Microscopic bridging across the $0.2\text{ mm}$ gap yields instantly to a gentle manual twist, liberating the gear train.

### 2. Snap-Fit & Interlocking Extension Points
- **Modular Connectors:** Integration of cantilever snap-clips, mounting pins, and interlocking base sockets.
- **Grid Expansion:** Allows users to snap multiple gear modules together, link adjacent mechanical trains, or attach functional desktop modules (e.g., crank handles, pen holders, storage bins).

### 3. FDM Printability & Orientation
- **Zero Supports:** All overhang angles, gear teeth profiles, and flexure arms adhere strictly to $\ge 45^\circ$ chamfers or self-bridging geometries.
- **Optimized Layer Adhesion:** Structural load-bearing members lay flat on the build bed, aligning print layers parallel to mechanical shear forces.

---

## Recommended Slicing Profile (Weedo Tina2 / CuraEngine)

| Setting | Target Value | Purpose |
|---|---|---|
| **Layer Height** | $0.20\text{ mm}$ | Standard resolution for smooth gear engagement |
| **Infill** | $30\%$ (Gyroid / Grid) | High torsional rigidity for gear teeth |
| **Wall Line Count** | $3 - 4$ walls | Solid perimeters for snap-fit arms |
| **Initial Layer Horizontal Expansion** | $-0.12\text{ mm}$ | Eliminates elephant's foot fusion at gear bases |
| **Slicing Tolerance** | Exclusive | Keeps perimeters inside CAD boundaries to preserve air gaps |
| **Seam Position** | Sharpest Corner / User Specified | Prevents retraction blobs from welding moving parts |
| **Z-Hop on Retraction** | $0.20\text{ mm}$ | Prevents nozzle dragging across internal air gaps |
| **Part Cooling Fan** | $100\%$ | Prevents sagging on overhangs and bridging |
| **Min Layer Time** | $12\text{ seconds}$ | Ensures adequate cooling for small gear teeth layers |
