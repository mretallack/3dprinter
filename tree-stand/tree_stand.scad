// Christmas Tree Stand
// A tapered cork/plant-pot shaped stand with a slot to hold a tree trunk.
//
// Parameters (all in mm)

// Base diameter (bottom, smaller end)
base_diameter = 30;

// Top diameter (larger end)
top_diameter = 40;

// Overall height
height = 50;

// Slot width (gap for tree trunk)
slot_width = 5;

// Slot depth (how far down from the top)
slot_depth = 8;

// Resolution
$fn = 100;

// Main body: tapered cylinder (truncated cone)
difference() {
    cylinder(h = height, d1 = base_diameter, d2 = top_diameter);
    
    // Slot cut from the top
    translate([-(top_diameter / 2 + 1), -(slot_width / 2), height - slot_depth])
        cube([top_diameter + 2, slot_width, slot_depth + 1]);
}
