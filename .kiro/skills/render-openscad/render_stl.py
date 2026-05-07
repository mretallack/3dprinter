#!/usr/bin/env python3
"""Render an STL file to a PNG image (headless, no display required)."""

import argparse
import sys
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d
from stl import mesh


def render(stl_path, output_path, elev=30, azim=45, title=None):
    stl_mesh = mesh.Mesh.from_file(stl_path)

    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')
    ax.add_collection3d(mplot3d.art3d.Poly3DCollection(
        stl_mesh.vectors, alpha=0.7, edgecolor='k', linewidth=0.1, facecolor='goldenrod'
    ))

    scale = stl_mesh.points.flatten()
    ax.auto_scale_xyz(scale, scale, scale)
    ax.view_init(elev=elev, azim=azim)

    if title is None:
        title = Path(stl_path).stem
    plt.title(title)
    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()
    print(f"Saved {output_path}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Render STL to PNG')
    parser.add_argument('input', help='Input STL file')
    parser.add_argument('output', help='Output PNG file')
    parser.add_argument('--elev', type=float, default=30, help='Elevation angle (default: 30)')
    parser.add_argument('--azim', type=float, default=45, help='Azimuth angle (default: 45)')
    parser.add_argument('--title', help='Image title (default: filename)')
    args = parser.parse_args()

    if not Path(args.input).exists():
        print(f"Error: {args.input} not found", file=sys.stderr)
        sys.exit(1)

    render(args.input, args.output, elev=args.elev, azim=args.azim, title=args.title)
