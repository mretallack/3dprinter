---
name: octoprint
description: Query and control the 3D printer via OctoPrint API. Use when the user asks about print status, progress, temperature, wants to start/stop/cancel a print, upload files, or check the printer state.
---

# OctoPrint API

Control the Tina2 Basic printer via OctoPrint at `http://flower.retallack.org.uk:5000`.

API key is in `.env` as `OCTOPRINT_KEY`.

```bash
source .env
```

## Check Print Status

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" http://flower.retallack.org.uk:5000/api/job
```

Returns: state, progress (completion %, time left, time elapsed), file info.

## Check Printer State

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" http://flower.retallack.org.uk:5000/api/printer
```

Returns: temperature, state (Operational, Printing, Offline, etc).

## Check Connection

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" http://flower.retallack.org.uk:5000/api/connection
```

## Connect Printer

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "connect"}' \
  http://flower.retallack.org.uk:5000/api/connection
```

## Upload a File

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" \
  -F "file=@path/to/file.gcode" \
  http://flower.retallack.org.uk:5000/api/files/local
```

## Select and Print a File

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "select", "print": true}' \
  http://flower.retallack.org.uk:5000/api/files/local/FILENAME.gcode
```

## Cancel Print

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "cancel"}' \
  http://flower.retallack.org.uk:5000/api/job
```

## Pause / Resume

```bash
# Pause
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "pause", "action": "pause"}' \
  http://flower.retallack.org.uk:5000/api/job

# Resume
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"command": "pause", "action": "resume"}' \
  http://flower.retallack.org.uk:5000/api/job
```

## List Files on Printer

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" \
  http://flower.retallack.org.uk:5000/api/files/local
```

## Delete a File

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -X DELETE \
  http://flower.retallack.org.uk:5000/api/files/local/FILENAME.gcode
```

## Send Custom GCode Command

```bash
curl -s -H "X-Api-Key: $OCTOPRINT_KEY" -H "Content-Type: application/json" \
  -d '{"commands": ["G28", "M104 S0"]}' \
  http://flower.retallack.org.uk:5000/api/printer/command
```

## Notes

- Printer must be in "Operational" state before selecting/printing files
- If printer shows "Offline after error", use the connect command
- The Tina2 Basic has no heated bed — ignore bed temperature readings
- OctoPrint web UI: http://flower.retallack.org.uk:5000
