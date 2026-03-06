# Trolley Coin 3D Model

## Files

- `trolley_coin.scad` - OpenSCAD source file
- `trolley_coin.stl` - 3D printable model (ready for slicing)
- `*-view.jpg` - Rendered preview images

## Generating STL from SCAD

Using Docker (no local OpenSCAD installation needed):

```bash
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest openscad -o /data/trolley_coin.stl /data/trolley_coin.scad
```

### Command Breakdown

- `docker run --rm` - Run container and remove after completion
- `-v "$(pwd)/coin:/data"` - Mount coin directory to /data in container
- `openscad/openscad:latest` - Official OpenSCAD Docker image
- `openscad -o /data/trolley_coin.stl /data/trolley_coin.scad` - Generate STL from SCAD

### Rendering Stats

- Time: ~23 seconds
- Vertices: 3,379
- Facets: 2,582
- Volumes: 7

## 3D Printing

The STL file is ready to import into your slicer software (Cura, PrusaSlicer, etc.) for printing.
