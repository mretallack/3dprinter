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

    # Shift model so lowest point sits on ground (Z=0)
    z_min = stl_mesh.vectors[:, :, 2].min()
    stl_mesh.vectors[:, :, 2] -= z_min

    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')
    ax.add_collection3d(mplot3d.art3d.Poly3DCollection(
        stl_mesh.vectors, alpha=0.7, edgecolor='k', linewidth=0.1, facecolor='goldenrod'
    ))

    # Set axis limits based on actual model bounds
    all_points = stl_mesh.vectors.reshape(-1, 3)
    x_min, x_max = all_points[:, 0].min(), all_points[:, 0].max()
    y_min, y_max = all_points[:, 1].min(), all_points[:, 1].max()
    z_max = all_points[:, 2].max()
    max_range = max(x_max - x_min, y_max - y_min, z_max) / 2
    x_mid, y_mid = (x_max + x_min) / 2, (y_max + y_min) / 2
    ax.set_xlim(x_mid - max_range, x_mid + max_range)
    ax.set_ylim(y_mid - max_range, y_mid + max_range)
    ax.set_zlim(0, max_range * 2)
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
