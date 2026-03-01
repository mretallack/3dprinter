#!/bin/bash
set -e

echo "=== Building Dog Model ==="

# Check for OpenSCAD
if ! command -v openscad &> /dev/null; then
    echo "ERROR: OpenSCAD not installed"
    echo "Install with: sudo dnf install openscad"
    exit 1
fi

# Generate STL
echo "Generating STL from OpenSCAD..."
openscad -o models/dog-basic.stl models/dog-basic.scad

echo "✓ STL generated: models/dog-basic.stl"

# Check for CuraEngine
if ! command -v CuraEngine &> /dev/null; then
    echo "WARNING: CuraEngine not installed"
    echo "Install from: https://github.com/Ultimaker/CuraEngine"
    echo "Skipping slicing step"
    exit 0
fi

# Slice with CuraEngine
echo "Slicing with CuraEngine..."
CuraEngine slice -v -j models/tina2_basic.def.json -l models/dog-basic.stl -o models/dog-basic.gcode

echo "✓ G-code generated: models/dog-basic.gcode"
echo ""
echo "=== Build Complete ==="
echo "Upload models/dog-basic.gcode to OctoPrint"
