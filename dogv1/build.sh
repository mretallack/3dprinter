#!/bin/bash
set -e

echo "=== Building Dog Model ==="

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker not installed"
    echo "Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Generate STL using Docker OpenSCAD
echo "Generating STL from OpenSCAD (Docker)..."
docker run --rm -v "$PWD/models:/models" openscad/openscad:latest \
    openscad -o /models/dog-basic.stl /models/dog-basic.scad

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
