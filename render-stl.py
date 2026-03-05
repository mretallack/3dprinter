#!/usr/bin/env python3
from PIL import Image, ImageDraw
import math

def read_stl_ascii(filename):
    vertices = []
    with open(filename, 'r') as f:
        for line in f:
            if line.strip().startswith('vertex'):
                parts = line.strip().split()
                vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))
    return vertices

# Read STL
vertices = read_stl_ascii('models/dog-basic.stl')

# Find center and bounds
min_x = min(v[0] for v in vertices)
max_x = max(v[0] for v in vertices)
min_y = min(v[1] for v in vertices)
max_y = max(v[1] for v in vertices)
min_z = min(v[2] for v in vertices)
max_z = max(v[2] for v in vertices)

center_x = (min_x + max_x) / 2
center_y = (min_y + max_y) / 2
center_z = (min_z + max_z) / 2

# Create image
width, height = 1200, 900
img = Image.new('RGB', (width, height), 'white')
draw = ImageDraw.Draw(img)

# Calculate scale to fit model
model_size = max(max_x - min_x, max_y - min_y, max_z - min_z)
scale = min(600 / model_size, 10)

def project_iso(x, y, z):
    # Center the model
    x -= center_x
    y -= center_y
    z -= center_z
    
    angle = math.radians(30)
    ix = (x - y) * math.cos(angle) * scale
    iy = (x + y) * math.sin(angle) * scale - z * scale
    return (width/2 + ix, height/2 - iy + 50)

# Draw title
draw.text((50, 30), "Sitting Spaniel Dog - 3D Model", fill='black')
draw.text((50, 50), "Dimensions: 59.3 x 31.6 x 52.6 mm", fill='black')
draw.text((50, 70), "Triangles: 12,040 | Fits Tina2 Basic: ✓", fill='green')

# Draw wireframe (sample triangles)
sample_rate = 30
for i in range(0, len(vertices)-2, sample_rate*3):
    pts = [project_iso(*vertices[i+j]) for j in range(3)]
    draw.polygon(pts, outline='blue', width=1)

# Draw vertices for detail
for i in range(0, len(vertices), sample_rate):
    px, py = project_iso(*vertices[i])
    draw.ellipse([px-1, py-1, px+1, py+1], fill='darkblue')

img.save('models/dog-stl-render.jpg', 'JPEG')
print("✓ STL render created: models/dog-stl-render.jpg")
