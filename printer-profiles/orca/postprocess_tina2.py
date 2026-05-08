#!/usr/bin/env python3
"""Post-process OrcaSlicer gcode for Tina2 Basic.

Removes commands the Tina2 firmware doesn't handle well:
- M190/M140 (no heated bed)
- M201 (acceleration limits)
- M203 before start gcode (max feedrate - conflicts with Tina2's M203 Z usage)
- M204 before start gcode (print/retract acceleration)
- M205 (jerk limits)

These are auto-inserted by OrcaSlicer before the custom start gcode.
The Tina2 should use its own firmware defaults for these values.
"""

import sys
from pathlib import Path

# Lines to strip entirely (before the start gcode marker)
STRIP_PREFIXES_BEFORE_START = ('M201 ', 'M203 ', 'M204 ', 'M205 ')
# Lines to strip everywhere
STRIP_EVERYWHERE = ('M190 ', 'M140 ')


def postprocess(input_path, output_path=None):
    if output_path is None:
        output_path = input_path

    lines = Path(input_path).read_text().splitlines(keepends=True)
    out = []
    seen_start_marker = False

    for line in lines:
        stripped = line.lstrip()

        # Detect our start gcode marker
        if 'start.gcode for tina2' in line:
            seen_start_marker = True

        # Strip bed temp commands everywhere
        if any(stripped.startswith(p) for p in STRIP_EVERYWHERE):
            continue

        # Strip machine limit commands only before start gcode
        if not seen_start_marker:
            if any(stripped.startswith(p) for p in STRIP_PREFIXES_BEFORE_START):
                continue

        out.append(line)

    Path(output_path).write_text(''.join(out))
    print(f"Post-processed: {input_path} -> {output_path}")
    print(f"  Removed M190/M140 (no heated bed)")
    print(f"  Removed M201/M203/M204/M205 before start gcode")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <input.gcode> [output.gcode]")
        sys.exit(1)
    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else input_path
    postprocess(input_path, output_path)
