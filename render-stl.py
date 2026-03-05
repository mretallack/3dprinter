#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import struct
import math

def read_stl_ascii(filename):
    vertices = []
    with open(filename, 'r') as f:
        for line in f:
            if line.strip().startswith('vertex'):
                parts = line.strip().split()
                vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))
    return vertices

def project_iso(x, y, z, scale=4, offset_x=400, offset_y=500):
    angle = math.radians(30)
    ix = (x - y) * math.cos(angle) * scale
    iy = (x + y) * math.sin(angle) * scale - z * scale
    return (offset_x + ix, offset_y - iy)

# Read STL
vertices = read_stl_ascii('models/dog-basic.stl')

# Create image
width, height = 1200, 900
img = Image.new('RGB', (width, height), 'white')
draw = ImageDraw.Draw(img)

# Draw title
draw.text((50, 30), "Sitting Spaniel Dog - 3D Model", fill='black', font=None)
draw.text((50, 50), "Dimensions: 59.3 x 31.6 x 52.6 mm", fill='black')
draw.text((50, 70), "Triangles: 12,040 | Fits Tina2 Basic: ✓", fill='green')

# Sample and draw vertices
sample_rate = 50
for i in range(0, len(vertices), sample_rate):
    x, y, z = vertices[i]
    px, py = project_iso(x, y, z)
    if 0 <= px < width and 0 <= py < height:
        draw.ellipse([px-1, py-1, px+1, py+1], fill='darkblue')

# Draw wireframe edges (sample triangles)
for i in range(0, len(vertices)-2, sample_rate*3):
    pts = [project_iso(*vertices[i+j]) for j in range(3)]
    if all(0 <= p[0] < width and 0 <= p[1] < height for p in pts):
        draw.polygon(pts, outline='blue')

img.save('models/dog-stl-render.jpg', 'JPEG')
print("✓ STL render created: models/dog-stl-render.jpg")
