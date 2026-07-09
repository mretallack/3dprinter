#!/bin/bash

# Generate preview images from multiple angles

angles=(
  "0,0,0:top"
  "0,0,90:front"
  "0,0,180:bottom"
  "0,0,270:back"
  "90,0,0:side1"
  "90,0,90:side2"
  "45,0,45:angle1"
  "45,0,135:angle2"
  "45,0,225:angle3"
  "45,0,315:angle4"
)

for angle_spec in "${angles[@]}"; do
  IFS=':' read -r rotation name <<< "$angle_spec"
  echo "Generating ${name}-view.png (rotation: $rotation)..."
  
  openscad -o "${name}-view.png" \
    --camera=0,0,0,${rotation},150 \
    --imgsize=800,600 \
    --projection=p \
    trolley_coin.scad
done

echo "Done! Generated ${#angles[@]} preview images."
