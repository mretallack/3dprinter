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
    
    width, height = 1200, 900
    img = Image.new('RGB', (width, height), (240, 240, 240))
    draw = ImageDraw.Draw(img)
    
    model_size = max(max_x - min_x, max_y - min_y, max_z - min_z)
    scale = min(500 / model_size, 12)
    
    # Light direction
    light = [0.5, 0.5, 1.0]
    light_mag = math.sqrt(sum(l*l for l in light))
    light = [l/light_mag for l in light]
    
    def project(x, y, z):
        x -= center_x
        y -= center_y
        z -= center_z
        
        # Rotate around X
        cos_x = math.cos(math.radians(angle_x))
        sin_x = math.sin(math.radians(angle_x))
        y2 = y * cos_x - z * sin_x
        z2 = y * sin_x + z * cos_x
        
        # Rotate around Z
        cos_z = math.cos(math.radians(angle_z))
        sin_z = math.sin(math.radians(angle_z))
        x3 = x * cos_z - y2 * sin_z
        y3 = x * sin_z + y2 * cos_z
        
        # Isometric
        angle = math.radians(30)
        ix = (x3 - y3) * math.cos(angle) * scale
        iy = (x3 + y3) * math.sin(angle) * scale - z2 * scale
        return (width/2 + ix, height/2 - iy)
    
    # Calculate normals and lighting
    tri_data = []
    for tri in triangles:
        # Normal
        v1 = [tri[1][i] - tri[0][i] for i in range(3)]
        v2 = [tri[2][i] - tri[0][i] for i in range(3)]
        normal = [
            v1[1]*v2[2] - v1[2]*v2[1],
            v1[2]*v2[0] - v1[0]*v2[2],
            v1[0]*v2[1] - v1[1]*v2[0]
        ]
        
        # Normalize
        mag = math.sqrt(sum(n*n for n in normal))
        if mag > 0:
            normal = [n/mag for n in normal]
        
        # Lighting (dot product with light direction)
        brightness = max(0, sum(normal[i] * light[i] for i in range(3)))
        
        # Depth
        avg_depth = sum(v[0] + v[1] - v[2]*2 for v in tri) / 3
        
        # Backface culling
        view_dir = [0, 0, 1]
        facing = sum(normal[i] * view_dir[i] for i in range(3))
        
        tri_data.append((avg_depth, tri, facing > 0, brightness))
    
    # Sort back to front
    tri_data.sort(reverse=True)
    
    # Draw with lighting
    for depth, tri, is_front, brightness in tri_data:
        if is_front:
            pts = [project(*v) for v in tri]
            # Apply lighting to color
            base_color = 100
            lit_color = int(base_color + brightness * 155)
            color = (lit_color, lit_color, min(255, lit_color + 50))
            draw.polygon(pts, fill=color, outline=None)
    
    # Add label with shadow
    draw.text((11, 11), f"{view_name}", fill='black')
    draw.text((10, 10), f"{view_name}", fill='white')
    draw.text((11, 31), f"Pattern: 0.3mm", fill='black')
    draw.text((10, 30), f"Pattern: 0.3mm", fill='white')
    
    img.save(output_file, 'JPEG', quality=95)
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
