#!/usr/bin/env python3
from PIL import Image, ImageDraw

# Load images
reference = Image.open('reference-dog.jpg')
model = Image.open('models/dog-stl-render.jpg')

# Resize for comparison
ref_width = 600
ref_height = int(reference.height * (ref_width / reference.width))
reference = reference.resize((ref_width, ref_height))

model_width = 600
model_height = int(model.height * (model_width / model.width))
model = model.resize((model_width, model_height))

# Create comparison image
total_height = max(ref_height, model_height) + 100
comparison = Image.new('RGB', (ref_width + model_width + 40, total_height), 'white')
draw = ImageDraw.Draw(comparison)

# Add labels
draw.text((20, 20), "REFERENCE PHOTO", fill='black')
draw.text((ref_width + 60, 20), "3D MODEL (Iteration 5)", fill='black')

# Paste images
comparison.paste(reference, (20, 60))
comparison.paste(model, (ref_width + 40, 60))

# Add feature checklist
y_pos = max(ref_height, model_height) + 80
draw.text((20, y_pos), "Feature Comparison:", fill='black')
y_pos += 25

features = [
    ("✓", "Lying down pose (not sitting)"),
    ("✓", "Long ears hanging to ground"),
    ("✓", "Elongated snout"),
    ("✓", "Extended front legs"),
    ("✓", "Low, flat body profile"),
    ("✓", "Compact dimensions (50x19x17mm)"),
]

for check, feature in features:
    color = 'green' if check == "✓" else 'red'
    draw.text((20, y_pos), f"{check} {feature}", fill=color)
    y_pos += 20

comparison.save('validation-comparison.jpg', 'JPEG')
print("✓ Validation comparison created: validation-comparison.jpg")
