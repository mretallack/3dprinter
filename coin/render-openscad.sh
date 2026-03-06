#!/bin/bash
# Generate high-quality renders using OpenSCAD's native PNG export

echo "Generating renders with OpenSCAD..."

# Top view
docker run --rm -v "$PWD:/work:z" -w /work openscad/openscad:latest \
  openscad -o top-view.png --render --imgsize=1200,900 \
  --colorscheme=BeforeDawn --projection=ortho \
  --camera=0,0,50,0,0,0,300 \
  --viewall trolley_coin.scad
echo "✓ top-view.png"

# Side view
docker run --rm -v "$PWD:/work:z" -w /work openscad/openscad:latest \
  openscad -o side-view.png --render --imgsize=1200,900 \
  --colorscheme=BeforeDawn --projection=ortho \
  --camera=50,0,0,0,0,0,300 \
  --viewall trolley_coin.scad
echo "✓ side-view.png"

# Front view
docker run --rm -v "$PWD:/work:z" -w /work openscad/openscad:latest \
  openscad -o front-view.png --render --imgsize=1200,900 \
  --colorscheme=BeforeDawn --projection=ortho \
  --camera=0,50,0,0,0,0,300 \
  --viewall trolley_coin.scad
echo "✓ front-view.png"

# Isometric view
docker run --rm -v "$PWD:/work:z" -w /work openscad/openscad:latest \
  openscad -o iso-view.png --render --imgsize=1200,900 \
  --colorscheme=BeforeDawn --projection=perspective \
  --camera=40,30,30,0,0,0,200 \
  --viewall trolley_coin.scad
echo "✓ iso-view.png"

echo ""
echo "✓ All renders complete (high quality PNG)"
