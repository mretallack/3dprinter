#!/usr/bin/env python3

def svg_header(width, height):
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
<rect width="100%" height="100%" fill="white"/>
<g stroke="black" stroke-width="1.5" fill="none">
'''

def svg_footer():
    return '</g></svg>'

# Generate drawing - Sitting Spaniel-type dog
svg = svg_header(1200, 600)

# Front View - Sitting pose
x, y = 100, 450
svg += f'<text x="{x}" y="50" font-size="16" fill="black">FRONT VIEW - Sitting</text>'
svg += f'<text x="{x}" y="70" font-size="10" fill="black">Width: 45mm, Height: 70mm</text>'
svg += f'<rect x="{x-15}" y="{y-50}" width="30" height="40"/>'  # body
svg += f'<ellipse cx="{x}" cy="{y-65}" rx="12" ry="15"/>'  # head
svg += f'<path d="M {x-12} {y-70} Q {x-18} {y-65} {x-20} {y-50}"/>'  # ear left
svg += f'<path d="M {x+12} {y-70} Q {x+18} {y-65} {x+20} {y-50}"/>'  # ear right
svg += f'<rect x="{x-18}" y="{y-10}" width="10" height="15"/>'  # front leg left
svg += f'<rect x="{x+8}" y="{y-10}" width="10" height="15"/>'  # front leg right
svg += f'<rect x="{x-22}" y="{y}" width="12" height="8"/>'  # back leg left
svg += f'<rect x="{x+10}" y="{y}" width="12" height="8"/>'  # back leg right

# Side View - Sitting pose
x, y = 500, 450
svg += f'<text x="{x}" y="50" font-size="16" fill="black">SIDE VIEW - Sitting</text>'
svg += f'<text x="{x}" y="70" font-size="10" fill="black">Length: 55mm, Height: 70mm</text>'
svg += f'<rect x="{x-20}" y="{y-50}" width="35" height="40"/>'  # body
svg += f'<ellipse cx="{x+20}" cy="{y-60}" rx="15" ry="12"/>'  # head
svg += f'<path d="M {x+18} {y-70} L {x+15} {y-50}"/>'  # ear
svg += f'<ellipse cx="{x+28}" cy="{y-58}" rx="8" ry="5"/>'  # snout
svg += f'<rect x="{x+5}" y="{y-10}" width="8" height="15"/>'  # front leg
svg += f'<path d="M {x-20} {y-10} L {x-20} {y+5} L {x-10} {y+5}"/>'  # back leg sitting

# Top View
x, y = 900, 450
svg += f'<text x="{x}" y="50" font-size="16" fill="black">TOP VIEW</text>'
svg += f'<text x="{x}" y="70" font-size="10" fill="black">Length: 55mm, Width: 45mm</text>'
svg += f'<ellipse cx="{x}" cy="{y-30}" rx="25" ry="18"/>'  # body
svg += f'<ellipse cx="{x+28}" cy="{y-30}" rx="10" ry="8"/>'  # head
svg += f'<ellipse cx="{x+35}" cy="{y-38}" rx="6" ry="10"/>'  # ear left
svg += f'<ellipse cx="{x+35}" cy="{y-22}" rx="6" ry="10"/>'  # ear right
svg += f'<circle cx="{x+10}" cy="{y-42}" r="4"/>'  # front leg
svg += f'<circle cx="{x+10}" cy="{y-18}" r="4"/>'  # front leg
svg += f'<circle cx="{x-15}" cy="{y-38}" r="5"/>'  # back leg
svg += f'<circle cx="{x-15}" cy="{y-22}" r="5"/>'  # back leg

svg += svg_footer()

with open('models/dog-drawing.svg', 'w') as f:
    f.write(svg)

print("✓ CAD drawing generated: models/dog-drawing.svg (Sitting Spaniel-type)")
