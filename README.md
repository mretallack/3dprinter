# 3D Printer Models

Parametric 3D models designed for FDM printing, created with OpenSCAD and AI-assisted workflows.

## Projects

### coin/
Trolley coin and keyring holder — parametric OpenSCAD design for a UK £1-sized trolley coin with a teardrop snap-fit holder. Features retention balls, finger-access hole in the base, and decorative patterns.

### dogv1/
Iterative dog model generation using Python scripts with scoring and validation against reference images.

### dogv2/
Dog model generated via [TRELLIS](https://huggingface.co/spaces/trellis-community/TRELLIS) (image-to-3D).

## Tools

- **OpenSCAD** — Parametric CAD (run via Docker: `openscad/openscad:latest`)
- **Python + matplotlib + numpy-stl** — Headless STL rendering
- **Docker** — For reproducible builds without local installs

## Building STL from SCAD

```bash
docker run --rm -v "$(pwd)/coin:/data" openscad/openscad:latest \
  openscad -o /data/output.stl /data/trolley_coin.scad
```

## Rendering Previews (headless)

```bash
python3 -m venv venv && source venv/bin/activate
pip install numpy-stl matplotlib
python3 render_stl.py input.stl output.png
```
