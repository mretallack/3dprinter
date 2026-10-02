# 3D Printing Agent Instructions & Guidelines

> **🚨 MANDATORY PRE-PRINT TEMPERATURE RULE (STOP & READ):** 
> Whenever slicing with `CuraEngine` via CLI, **NEVER** trust the unedited output. You MUST perform one of the two safety gates before sending any GCode to the printer:
> 1. **Option A (Preferred):** Use the inline `machine_start_gcode` parameter with explicit temperature commands (`M109 S210`) so no placeholders exist.
> 2. **Option B (Mandatory Post-Process):** Run the `sed` command immediately after slicing and inspect the first 35 lines to verify `M109 S210` is present:
>    ```bash
>    sed -i 's/M109 S{material_print_temperature_layer_0}/M109 S210/' output.gcode
>    head -n 35 output.gcode
>    ```
> *Failure to do this causes the printer to remain cold at 150°C and fail to extrude.*

## 3D Model Rendering & Preview
When asked to render or provide a visual preview of an STL or 3D model, **do not** use raw quick scripts or unformatted plots. Always use the built-in python rendering script provided in the environment:

```bash
python3 .kiro/skills/render-openscad/render_stl.py <input.stl> <output.png> [--elev DEGREES] [--azim DEGREES] [--title TEXT]
```

### Examples:
- **Isometric view (default):**
  ```bash
  python3 .kiro/skills/render-openscad/render_stl.py path/to/model.stl render.png --title "Model Name"
  ```
- **Bottom view (to inspect underside features / pins / clips):**
  ```bash
  python3 .kiro/skills/render-openscad/render_stl.py path/to/model.stl bottom.png --elev -30 --title "Model Bottom View"
  ```

## File Delivery
When sending files (such as rendered PNG images) to the user via Telegram, always use the `SEND_FILE:<absolute_path>` marker in your response text (as instructed by the `send-file` skill).

## 3D Printing Workflow (`scad-to-print`)
1. **Examine files & Read documentation:** Check dimensions, orientation, and bed fit (Weedo Tina2 Basic has a 100×100mm unheated bed and 0.4mm nozzle).
2. **Check & Plan:** Calculate bounding box, volume, estimated weight, and print time. Always use a raft with `raft_airgap=0.25` for cold bed adhesion.
3. **Render:** Generate visual previews using `render_stl.py`.
4. **Slicing via CuraEngine (Mandatory Overrides):**
   When slicing via CLI, always apply the proven `scad-to-print` parameter overrides (including `raft_airgap=0.25` for reliable cold bed adhesion and conservative speeds):
   ```bash
   docker run --rm \
     -v "$(pwd):/data:z" \
     -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
     markretallackhome/curaengine5 slice \
     -j /definitions/entina_tina2.def.json \
     -o /data/output.gcode \
     -s roofing_layer_count=0 \
     -s flooring_layer_count=0 \
     -s layer_height=0.2 \
     -s infill_sparse_density=20 \
     -s material_print_temperature=200 \
     -s material_print_temperature_layer_0=210 \
     -s speed_travel=65 \
     -s speed_print=25 \
     -s speed_wall_0=20 \
     -s machine_width=100 \
     -s machine_depth=100 \
     -s center_object=true \
     -s raft_margin=8 \
     -s raft_base_margin=8 \
     -s raft_interface_margin=8 \
     -s raft_surface_margin=8 \
     -s raft_airgap=0.25 \
     -l /data/input.stl
   ```
5. **Approval & Execution:** Present details, estimates, and renders to the user for confirmation before sending print jobs or proceeding.

## OctoPrint API Integration
When interacting with the printer via OctoPrint (at `http://flower.retallack.org.uk:5000`), use the API key stored in `.env` (`OCTOPRINT_KEY`).

### Common API Endpoints:
- **Check Printer Status:**
  ```bash
  source .env
  curl -s -H "X-Api-Key: $OCTOPRINT_KEY" http://flower.retallack.org.uk:5000/api/printer
  ```
- **Upload and Start Print:**
  ```bash
  source .env
  curl -s -H "X-Api-Key: $OCTOPRINT_KEY" \
    -F "file=@path/to/file.gcode" \
    -F "select=true" \
    -F "print=true" \
    http://flower.retallack.org.uk:5000/api/files/local
  ```
- **Check Print Progress / Job:**
  ```bash
  source .env
  curl -s -H "X-Api-Key: $OCTOPRINT_KEY" http://flower.retallack.org.uk:5000/api/job
  ```

## 🚨 ZERO FAKE GCODE & SLICING VALIDATION RULE (MANDATORY)
1. **Never create, write, or send manual/mock GCode stub files** (e.g. files without extrusion `E` moves or actual sliced geometry). Slicing must **always** be performed successfully via CuraEngine.
2. **Mandatory GCode Validation Gate:** Before sending any `.gcode` file to OctoPrint or the printer, run a validation script checking:
   - File size is substantial (> 10 KB).
   - Contains valid extrusion (`E`) commands.
   - Contains layer indicators (`;LAYER:`).
3. If CuraEngine fails due to missing settings, fix the command arguments or definition files—**never** fall back to writing a dummy gcode file.
