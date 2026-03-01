#!/bin/bash
set -e

if ! command -v openscad &> /dev/null; then
    echo "ERROR: OpenSCAD not installed"
    echo "Install with: sudo dnf install openscad"
    exit 1
fi

echo "Generating 2D CAD drawing..."
openscad -o models/dog-drawing.svg models/dog-drawing.scad
openscad -o models/dog-drawing.png --imgsize=1200,600 models/dog-drawing.scad

echo "✓ CAD drawing generated:"
echo "  - models/dog-drawing.svg (vector)"
echo "  - models/dog-drawing.png (raster)"
