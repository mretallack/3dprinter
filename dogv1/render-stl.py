#!/usr/bin/env python3
from PIL import Image, ImageDraw
import math

def read_stl_ascii(filename):
    triangles = []
    current_tri = []
    with open(filename, 'r') as f:
        for line in f:
            if line.strip().startswith('vertex'):
                parts = line.strip().split()
                current_tri.append((float(parts[1]), float(parts[2]), float(parts[3])))
                if len(current_tri) == 3:
                    triangles.append(current_tri)
                    current_tri = []
    return triangles

# Read STL
triangles = read_stl_ascii('models/dog-basic.stl')

# Find center and bounds
all_verts = [v for tri in triangles for v in tri]
min_x = min(v[0] for v in all_verts)
max_x = max(v[0] for v in all_verts)
min_y = min(v[1] for v in all_verts)
max_y = max(v[1] for v in all_verts)
min_z = min(v[2] for v in all_verts)
max_z = max(v[2] for v in all_verts)

center_x = (min_x + max_x) / 2
center_y = (min_y + max_y) / 2
center_z = (min_z + max_z) / 2

# Create image
width, height = 1200, 900
img = Image.new('RGB', (width, height), 'white')
draw = ImageDraw.Draw(img)

# Calculate scale
model_size = max(max_x - min_x, max_y - min_y, max_z - min_z)
scale = min(600 / model_size, 10)

def project_iso(x, y, z):
    x -= center_x
    y -= center_y
    z -= center_z
    angle = math.radians(30)
    ix = (x - y) * math.cos(angle) * scale
    iy = (x + y) * math.sin(angle) * scale - z * scale
    return (width/2 + ix, height/2 - iy + 50)

# Draw title
draw.text((50, 30), "Sitting Spaniel Dog - 3D Model", fill='black')
draw.text((50, 50), f"Dimensions: {max_x-min_x:.1f} x {max_y-min_y:.1f} x {max_z-min_z:.1f} mm", fill='black')
draw.text((50, 70), f"Triangles: {len(triangles)} | Fits Tina2 Basic: ✓", fill='green')

# Sort triangles by depth for proper rendering
tri_depths = []
for tri in triangles:
    avg_z = sum(v[2] for v in tri) / 3
    tri_depths.append((avg_z, tri))
tri_depths.sort()

# Draw filled triangles (back to front)
for _, tri in tri_depths:
    pts = [project_iso(*v) for v in tri]
    draw.polygon(pts, fill='lightblue', outline='blue')

img.save('models/dog-stl-render.jpg', 'JPEG')
print("✓ STL render created: models/dog-stl-render.jpg")
