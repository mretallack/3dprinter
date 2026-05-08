# CuraEngine 5.x Docker

Builds CuraEngine from source with printer definitions from the Cura repository.

## Build

```bash
docker build -t curaengine5 .
```

Build takes ~20-30 minutes (compiles all dependencies via Conan).

## Usage

```bash
docker run --rm -v "$(pwd):/data" curaengine5 \
  slice -j /definitions/entina_tina2.def.json \
  -o /data/output.gcode \
  -l /data/input.stl
```

## Notes

- CuraEngine requires printer definition JSON files to resolve settings
- Definitions are cloned from https://github.com/Ultimaker/Cura/tree/main/resources/definitions
- This produces identical output to UltiMaker Cura GUI
- Run `docker run --rm curaengine5 help` for CLI usage
