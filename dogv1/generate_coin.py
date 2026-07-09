import numpy as np
import struct

def write_stl(filename, vertices, faces):
    with open(filename, 'wb') as f:
        f.write(b'\0' * 80)  # Header
        f.write(struct.pack('<I', len(faces)))
        
        for face in faces:
            v0, v1, v2 = vertices[face[0]], vertices[face[1]], vertices[face[2]]
            normal = np.cross(v1 - v0, v2 - v0)
            normal = normal / np.linalg.norm(normal)
            
            f.write(struct.pack('<3f', *normal))
            f.write(struct.pack('<3f', *v0))
            f.write(struct.pack('<3f', *v1))
            f.write(struct.pack('<3f', *v2))
            f.write(b'\0\0')

# Coin parameters
radius = 12.5
height = 3
segments = 100

vertices = []
faces = []

# Generate cylinder vertices
for i in range(segments):
    angle = 2 * np.pi * i / segments
    x, y = radius * np.cos(angle), radius * np.sin(angle)
    vertices.append([x, y, -height/2])
    vertices.append([x, y, height/2])

# Top and bottom centers
center_bottom = len(vertices)
vertices.append([0, 0, -height/2])
center_top = len(vertices)
vertices.append([0, 0, height/2])

vertices = np.array(vertices)

# Side faces
for i in range(segments):
    next_i = (i + 1) % segments
    faces.append([i*2, next_i*2, i*2+1])
    faces.append([next_i*2, next_i*2+1, i*2+1])

# Bottom faces
for i in range(segments):
    next_i = (i + 1) % segments
    faces.append([center_bottom, next_i*2, i*2])

# Top faces
for i in range(segments):
    next_i = (i + 1) % segments
    faces.append([center_top, i*2+1, next_i*2+1])

write_stl('coin.stl', vertices, faces)
print("coin.stl generated successfully")
