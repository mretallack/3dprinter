#!/usr/bin/env python3
import os
import shutil
import subprocess
import sys

def get_next_iteration():
    """Find the highest iteration number and return next"""
    iterations = []
    for f in os.listdir('iterations'):
        if f.startswith('dog-iter-') and f.endswith('.scad'):
            num = int(f.split('-')[2].split('.')[0])
            iterations.append(num)
    return max(iterations) + 1 if iterations else 21

def create_iteration(iteration_num, description=""):
    """Create new iteration from previous"""
    prev_num = iteration_num - 1
    
    # Create iterations directory if needed
    os.makedirs('iterations', exist_ok=True)
    
    # Copy previous iteration or base model
    if prev_num >= 21:
        prev_file = f'iterations/dog-iter-{prev_num:03d}.scad'
        if os.path.exists(prev_file):
            new_file = f'iterations/dog-iter-{iteration_num:03d}.scad'
            shutil.copy(prev_file, new_file)
            print(f"✓ Copied iteration {prev_num} → {iteration_num}")
            return new_file
    
    # First iteration - copy from current model
    new_file = f'iterations/dog-iter-{iteration_num:03d}.scad'
    shutil.copy('models/dog-basic.scad', new_file)
    print(f"✓ Created iteration {iteration_num} from base model")
    return new_file

def generate_stl(scad_file, iteration_num):
    """Generate STL from SCAD file"""
    stl_file = f'iterations/dog-iter-{iteration_num:03d}.stl'
    cmd = [
        'docker', 'run', '--rm',
        '-v', f'{os.getcwd()}/iterations:/work:z',
        '-w', '/work',
        'openscad/openscad:latest',
        'openscad', '-o', os.path.basename(stl_file), os.path.basename(scad_file)
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"✓ Generated STL: {stl_file}")
        return stl_file
    else:
        print(f"✗ STL generation failed: {result.stderr}")
        return None

def generate_render(stl_file, iteration_num):
    """Generate render from STL"""
    jpg_file = f'iterations/dog-iter-{iteration_num:03d}.jpg'
    # Use existing render script but point to iteration STL
    render_script = f"""
import sys
sys.path.insert(0, '.')
from render_stl import render_stl
render_stl('{stl_file}', '{jpg_file}')
"""
    with open('/tmp/render_iter.py', 'w') as f:
        f.write(render_script)
    
    result = subprocess.run(['python3', '/tmp/render_iter.py'], capture_output=True, text=True)
    if os.path.exists(jpg_file):
        print(f"✓ Generated render: {jpg_file}")
        return jpg_file
    else:
        print(f"✗ Render generation failed")
        return None

def score_features(iteration_num):
    """Score iteration against feature checklist"""
    print(f"\n=== Feature Scoring for Iteration {iteration_num} ===")
    print("Review the render and score features manually")
    print("(Automated scoring would require computer vision)")
    return None

if __name__ == "__main__":
    if len(sys.argv) > 1:
        iter_num = int(sys.argv[1])
    else:
        iter_num = get_next_iteration()
    
    print(f"\n=== Creating Iteration {iter_num} ===")
    scad_file = create_iteration(iter_num)
    print(f"\nEdit {scad_file} to make improvements")
    print(f"Then run: python3 iterate.py {iter_num} generate")
