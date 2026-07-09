#!/usr/bin/env python3
import struct
import sys

def read_stl_binary(filename):
    with open(filename, 'rb') as f:
        header = f.read(80)
        num_triangles = struct.unpack('I', f.read(4))[0]
        
        min_x = min_y = min_z = float('inf')
        max_x = max_y = max_z = float('-inf')
        
        for _ in range(num_triangles):
            f.read(12)  # normal
            for _ in range(3):  # 3 vertices
                x, y, z = struct.unpack('fff', f.read(12))
                min_x, max_x = min(min_x, x), max(max_x, x)
                min_y, max_y = min(min_y, y), max(max_y, y)
                min_z, max_z = min(min_z, z), max(max_z, z)
            f.read(2)  # attribute
        
        return {
            'triangles': num_triangles,
            'min': (min_x, min_y, min_z),
            'max': (max_x, max_y, max_z),
            'size': (max_x - min_x, max_y - min_y, max_z - min_z)
        }

def read_stl_ascii(filename):
    min_x = min_y = min_z = float('inf')
    max_x = max_y = max_z = float('-inf')
    triangles = 0
    
    with open(filename, 'r') as f:
        for line in f:
            if line.strip().startswith('vertex'):
                parts = line.strip().split()
                x, y, z = float(parts[1]), float(parts[2]), float(parts[3])
                min_x, max_x = min(min_x, x), max(max_x, x)
                min_y, max_y = min(min_y, y), max(max_y, y)
                min_z, max_z = min(min_z, z), max(max_z, z)
            elif line.strip().startswith('endfacet'):
                triangles += 1
    
    return {
        'triangles': triangles,
        'min': (min_x, min_y, min_z),
        'max': (max_x, max_y, max_z),
        'size': (max_x - min_x, max_y - min_y, max_z - min_z)
    }

filename = 'models/dog-basic.stl'
try:
    info = read_stl_binary(filename)
except:
    info = read_stl_ascii(filename)

print(f"STL Analysis: {filename}")
print(f"Triangles: {info['triangles']}")
print(f"Bounding Box:")
print(f"  Min: ({info['min'][0]:.2f}, {info['min'][1]:.2f}, {info['min'][2]:.2f})")
print(f"  Max: ({info['max'][0]:.2f}, {info['max'][1]:.2f}, {info['max'][2]:.2f})")
print(f"Dimensions (mm):")
print(f"  X (Length): {info['size'][0]:.2f}")
print(f"  Y (Width):  {info['size'][1]:.2f}")
print(f"  Z (Height): {info['size'][2]:.2f}")
print(f"\nFits in Tina2 Basic (100x120x100mm): ", end="")
if info['size'][0] <= 100 and info['size'][1] <= 120 and info['size'][2] <= 100:
    print("✓ YES")
else:
    print("✗ NO")
