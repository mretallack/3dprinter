# Basic Dog Model

Simple 3D printable dog model for Tina2 Basic printer.

## Files

- `dog-basic.scad` - OpenSCAD source
- `dog-basic.stl` - Exported model (generated)
- `dog-basic.gcode` - Sliced G-code (generated)
- `tina2_basic.def.json` - Cura printer profile

## Build Instructions

### Prerequisites

```bash
# Install OpenSCAD
sudo dnf install openscad

# Install CuraEngine (optional, for slicing)
# Download from: https://github.com/Ultimaker/CuraEngine/releases
```

### Generate STL and G-code

```bash
./build.sh
```

### Manual Steps

#### Generate STL only:
```bash
openscad -o models/dog-basic.stl models/dog-basic.scad
```

#### Slice with CuraEngine:
```bash
CuraEngine slice -v -j models/tina2_basic.def.json -l models/dog-basic.stl -o models/dog-basic.gcode
```

## Print Settings

- **Material**: PLA
- **Nozzle**: 200°C
- **Bed**: 60°C
- **Layer Height**: 0.2mm
- **Speed**: 50mm/s
- **Infill**: 15%
- **Supports**: None
- **Adhesion**: 5mm brim

## Dimensions

- Length: ~80mm
- Width: ~40mm
- Height: ~60mm
- Print time: ~2 hours
- Material: ~15g

## OctoPrint Upload

Upload `dog-basic.gcode` to OctoPrint web interface or use:

```bash
curl -X POST -H "X-Api-Key: YOUR_API_KEY" \
  -F "file=@models/dog-basic.gcode" \
  http://octopi.local/api/files/local
```
