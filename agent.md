# 3D Printing Agent Instructions & Guidelines

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

## 3D Printing Workflow
1. **Examine files & Read documentation:** Extract archives, check accompanying PDFs or instructions for recommended print settings (layer height, supports, infill, material).
2. **Check & Plan:** Calculate bounding box, volume, estimated weight, and print time. Provide clear parameter recommendations.
3. **Render:** Generate visual previews (isometric and bottom/detail views) using `render_stl.py`.
4. **Approval & Execution:** Present details, estimates, and renders to the user for confirmation before sending print jobs or proceeding.

### Alternative Slicing Method (Inline `machine_start_gcode`)
When slicing via the CLI with `CuraEngine`, you can avoid the unexpanded `{material_print_temperature_layer_0}` placeholder bug completely by explicitly providing a fully-resolved `machine_start_gcode` string argument, eliminating the need for `sed` post-processing:

```bash
docker run --rm -v "$(pwd):/data:z" \
  -e CURA_ENGINE_SEARCH_PATH=/definitions:/extruders \
  markretallackhome/curaengine5 slice \
  -j /definitions/entina_tina2.def.json \
  -o /data/output.gcode \
  -s machine_start_gcode=";MachineType:ENTINA TINA2\nM203 Z15\nM104 S150\nG28 Z\nG28 X Y\nG1 X55 Y55 F1000\nG29\nM107\nG90\nM82\nM109 S210\nG92 E0\nG1 X90 Y6 Z0.27 F2000\nG1 X20 Y6 Z0.27 E15 F1000\nG92 E0\nM203 Z5" \
  -l /data/model.stl
```
