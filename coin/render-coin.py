#!/usr/bin/env python3
from PIL import Image, ImageDraw
import math

def read_stl(filename):
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

def get_bounds(triangles):
    all_verts = [v for tri in triangles for v in tri]
    min_x = min(v[0] for v in all_verts)
    max_x = max(v[0] for v in all_verts)
    min_y = min(v[1] for v in all_verts)
    max_y = max(v[1] for v in all_verts)
    min_z = min(v[2] for v in all_verts)
    max_z = max(v[2] for v in all_verts)
    return (min_x, max_x, min_y, max_y, min_z, max_z)

def render_view(triangles, bounds, angle_x, angle_z, output_file, view_name):
    min_x, max_x, min_y, max_y, min_z, max_z = bounds
    center_x = (min_x + max_x) / 2
    center_y = (min_y + max_y) / 2
    center_z = (min_z + max_z) / 2
    
    width, height = 800, 600
    img = Image.new('RGB', (width, height), 'white')
    draw = ImageDraw.Draw(img)
    
    model_size = max(max_x - min_x, max_y - min_y, max_z - min_z)
    scale = min(400 / model_size, 10)
    
    def project(x, y, z):
        # Center
        x -= center_x
        y -= center_y
        z -= center_z
        
        # Rotate around X axis
        cos_x = math.cos(math.radians(angle_x))
        sin_x = math.sin(math.radians(angle_x))
        y2 = y * cos_x - z * sin_x
        z2 = y * sin_x + z * cos_x
        
        # Rotate around Z axis
        cos_z = math.cos(math.radians(angle_z))
        sin_z = math.sin(math.radians(angle_z))
        x3 = x * cos_z - y2 * sin_z
        y3 = x * sin_z + y2 * cos_z
        
        # Isometric projection
        angle = math.radians(30)
        ix = (x3 - y3) * math.cos(angle) * scale
        iy = (x3 + y3) * math.sin(angle) * scale - z2 * scale
        return (width/2 + ix, height/2 - iy + 50)
    
    # Calculate normals and sort by depth
    tri_data = []
    for tri in triangles:
        # Calculate normal
        v1 = [tri[1][i] - tri[0][i] for i in range(3)]
        v2 = [tri[2][i] - tri[0][i] for i in range(3)]
        normal = [
            v1[1]*v2[2] - v1[2]*v2[1],
            v1[2]*v2[0] - v1[0]*v2[2],
            v1[0]*v2[1] - v1[1]*v2[0]
        ]
        
        # Calculate depth (average z after rotation)
        avg_depth = sum(v[0] + v[1] - v[2] for v in tri) / 3
        
        # Check if facing camera (backface culling)
        view_dir = [0, 0, 1]
        dot = sum(normal[i] * view_dir[i] for i in range(3))
        
        tri_data.append((avg_depth, tri, dot > 0))
    
    # Sort back to front
    tri_data.sort(reverse=True)
    
    # Draw only front-facing triangles
    for depth, tri, is_front in tri_data:
        if is_front:
            pts = [project(*v) for v in tri]
            # Vary color slightly based on depth for 3D effect
            brightness = int(180 + (depth % 50))
            color = (brightness, brightness, 255)
            draw.polygon(pts, fill=color, outline=None)
    
    # Add label
    draw.text((10, 10), f"{view_name}", fill='black')
    draw.text((10, 30), f"Pattern height: 0.3mm", fill='black')
    
    img.save(output_file, 'JPEG')
    print(f"✓ Rendered: {output_file}")

# Read STL
triangles = read_stl('trolley_coin.stl')
bounds = get_bounds(triangles)

# Generate multiple views
views = [
    (0, 0, "top-view.jpg", "Top View"),
    (90, 0, "side-view.jpg", "Side View"),
    (0, 90, "front-view.jpg", "Front View"),
    (30, 45, "iso-view.jpg", "Isometric View"),
]

for angle_x, angle_z, filename, name in views:
    render_view(triangles, bounds, angle_x, angle_z, filename, name)

print("\n✓ All renders complete")
