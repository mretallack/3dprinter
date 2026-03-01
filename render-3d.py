#!/usr/bin/env python3
from PIL import Image, ImageDraw
import math

width, height = 800, 600
img = Image.new('RGB', (width, height), 'white')
draw = ImageDraw.Draw(img)

# Isometric projection helper
def iso(x, y, z):
    angle = math.radians(30)
    ix = (x - y) * math.cos(angle)
    iy = (x + y) * math.sin(angle) - z
    return (400 + ix * 3, 500 - iy * 3)

# Draw sitting dog in isometric view
# Body
body_pts = [iso(-15, -12, 10), iso(15, -12, 10), iso(15, 12, 10), iso(-15, 12, 10)]
draw.polygon(body_pts, outline='black', fill='lightgray')
body_pts_top = [iso(-15, -12, 40), iso(15, -12, 40), iso(15, 12, 40), iso(-15, 12, 40)]
draw.polygon(body_pts_top, outline='black', fill='gray')
for i in range(4):
    draw.line([body_pts[i], body_pts_top[i]], fill='black', width=2)

# Head
head_pts = [iso(18, -9, 30), iso(28, -9, 30), iso(28, 9, 30), iso(18, 9, 30)]
draw.polygon(head_pts, outline='black', fill='lightgray')
head_pts_top = [iso(18, -9, 45), iso(28, -9, 45), iso(28, 9, 45), iso(18, 9, 45)]
draw.polygon(head_pts_top, outline='black', fill='gray')
for i in range(4):
    draw.line([head_pts[i], head_pts_top[i]], fill='black', width=2)

# Ears (left and right)
draw.ellipse([iso(20, -12, 35)[0]-8, iso(20, -12, 35)[1]-15, 
              iso(20, -12, 35)[0]+8, iso(20, -12, 35)[1]+15], 
             outline='black', fill='darkgray')
draw.ellipse([iso(20, 12, 35)[0]-8, iso(20, 12, 35)[1]-15, 
              iso(20, 12, 35)[0]+8, iso(20, 12, 35)[1]+15], 
             outline='black', fill='darkgray')

# Front legs
for y in [-10, 10]:
    leg_b = iso(10, y, 0)
    leg_t = iso(10, y, 15)
    draw.ellipse([leg_b[0]-6, leg_b[1]-6, leg_b[0]+6, leg_b[1]+6], 
                 outline='black', fill='lightgray')
    draw.line([leg_b, leg_t], fill='black', width=8)

# Back legs (sitting)
for y in [-11, 11]:
    draw.ellipse([iso(-8, y, 4)[0]-8, iso(-8, y, 4)[1]-5, 
                  iso(-8, y, 4)[0]+8, iso(-8, y, 4)[1]+5], 
                 outline='black', fill='gray')

# Tail
tail_pts = [iso(-18, 0, 15), iso(-25, 0, 22)]
draw.line(tail_pts, fill='black', width=5)

# Add labels
draw.text((50, 50), "3D Model - Sitting Spaniel Dog", fill='black')
draw.text((50, 70), "Dimensions: 55x45x70mm", fill='black')

img.save('models/dog-3d-render.jpg', 'JPEG')
print("✓ 3D render created: models/dog-3d-render.jpg")
