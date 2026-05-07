// Trolley Coin and Holder - Parametric Design
// All dimensions in mm

// ===== PARAMETERS =====

// Coin parameters
coin_diameter = 22.5;        // UK £1 coin diameter
coin_thickness = 2.8;        // Uniform thickness (matches UK £1 coin)
finger_grip_diameter = 12.0; // Diameter of finger grip recess
finger_grip_depth = 1.0;     // Depth of finger grip recess
finger_lip_height = 0.3;     // Small overhang lip for finger purchase

// Holder parameters
holder_wall_thickness = 1.2; // Wall thickness (1.5x minimum)
holder_pocket_depth = 4.0;   // Depth to hold coin (increased for ball retention)
holder_total_height = holder_wall_thickness + coin_thickness + holder_wall_thickness; // Full enclosure
holder_pocket_diameter = coin_diameter + 0.4; // 0.4mm clearance for pocket
holder_tab_count = 8;        // Number of retention balls
holder_ball_diameter = 1.3;  // Diameter of retention balls (increased for better grip)
holder_ball_inset = -0.2;     // How much ball overlaps coin edge (interference fit)
keyring_hole_diameter = 6.0; // Keyring hole size
keyring_end_diameter = 10.0; // Diameter of narrow end (must be larger than hole + walls)
keyring_end_height = 4.0;    // Height of narrow end (must be taller than hole diameter)
keyring_end_offset = 2.0;    // Additional distance from holder body
holder_teardrop_length = 35; // Total length of teardrop (extended for keyring space)
holder_teardrop_width = 28;  // Width at widest point (increased to fully cover 22.5mm coin + walls)
finger_hole_diameter = 14.0; // Hole in base to push coin out with finger

// Pattern parameters
pattern_type = "concentric"; // "concentric", "radial", or "hexagonal"
pattern_depth = 0.4;         // Depth of pattern
pattern_height = 0.3;        // Height of raised pattern

// Spacing between objects for printing
print_spacing = 5;

// Preview mode - set to true to see coin inside holder
preview_assembly = false;

// Quality
$fn = 100; // Circle resolution

// ===== MODULES =====

// Coin with finger grip recess
module coin() {
    difference() {
        union() {
            // Simple uniform cylinder
            cylinder(h=coin_thickness, d=coin_diameter);
            
            // Pattern on top face
            translate([0, 0, coin_thickness])
                coin_pattern();
        }
        
        // Finger grip recess (simple depression, no lip)
        translate([0, 0, coin_thickness - finger_grip_depth])
            cylinder(h=finger_grip_depth + 0.01, d=finger_grip_diameter);
    }
}

// Coin pattern (raised)
module coin_pattern() {
    if (pattern_type == "concentric") {
        // Concentric circles
        for (i = [1:4]) {
            difference() {
                cylinder(h=pattern_height, d=coin_diameter * 0.8 - i * 3);
                translate([0, 0, -0.01])
                    cylinder(h=pattern_height + 0.02, d=coin_diameter * 0.8 - i * 3 - 1);
            }
        }
    } else if (pattern_type == "radial") {
        // Radial lines
        for (i = [0:11]) {
            rotate([0, 0, i * 30])
                translate([0, -0.5, 0])
                    cube([coin_diameter * 0.4, 1, pattern_height]);
        }
    } else if (pattern_type == "hexagonal") {
        // Hexagonal grid
        hex_size = 2;
        for (x = [-3:3]) {
            for (y = [-3:3]) {
                translate([x * hex_size * 1.5, y * hex_size * sqrt(3) + (x % 2) * hex_size * sqrt(3)/2, 0])
                    cylinder(h=pattern_height, d=hex_size, $fn=6);
            }
        }
    }
}

// Teardrop holder with keyring hole
module holder() {
    difference() {
        union() {
            // Main teardrop body
            hull() {
                // Wide end (coin area)
                cylinder(h=holder_wall_thickness + holder_pocket_depth, d=holder_teardrop_width);
                
                // Transition point before keyring
                translate([0, holder_teardrop_length/2, 0])
                    cylinder(h=holder_wall_thickness + holder_pocket_depth, d=keyring_end_diameter);
            }
            
            // Keyring end as a separate tube with hole
            translate([0, holder_teardrop_length/2 + keyring_end_offset + keyring_end_diameter/2, 0])
                difference() {
                    cylinder(h=keyring_end_height, d=keyring_end_diameter);
                    translate([0, 0, -0.5])
                        cylinder(h=keyring_end_height + 1, d=keyring_hole_diameter, $fn=50);
                }
        }
        
        // Coin pocket - open at top
        difference() {
            translate([0, 0, holder_wall_thickness])
                cylinder(h=holder_pocket_depth + 1, d=holder_pocket_diameter);
            
            // Retention balls - subtract from pocket to create dimples
            for (i = [0:holder_tab_count-1]) {
                rotate([0, 0, i * 360/holder_tab_count])
                    translate([coin_diameter/2 - holder_ball_inset, 0, holder_wall_thickness + holder_pocket_depth - holder_ball_diameter/2])
                        sphere(d=holder_ball_diameter, $fn=30);
            }
        }
        
        // NEW: Remove front lip for easy coin removal
        // Cylinder cutout at front edge (opposite keyring end)
        translate([0, -holder_teardrop_width/2, holder_wall_thickness])
            cylinder(h=holder_pocket_depth + 1, d=holder_pocket_diameter + 2);
        
        // Finger hole through base to push coin out
        translate([0, 0, -0.01])
            cylinder(h=holder_wall_thickness + 0.02, d=finger_hole_diameter);
    }
}

// Teardrop shell shape
module teardrop_shell() {
    // Main teardrop body
    hull() {
        // Wide end (coin area)
        cylinder(h=holder_wall_thickness + holder_pocket_depth, d=holder_teardrop_width);
        
        // Narrow end (keyring area) - taller and wider to accommodate hole
        translate([0, holder_teardrop_length/2, 0])
            cylinder(h=keyring_end_height, d=keyring_end_diameter);
        
        // Add tabs to the hull to force connection
        for (i = [0:holder_tab_count-1]) {
            rotate([0, 0, i * 360/holder_tab_count])
                translate([holder_pocket_diameter/2 - holder_tab_inset, -holder_tab_width/2, holder_wall_thickness + holder_pocket_depth])
                    cube([0.1, holder_tab_width, holder_tab_height]);
        }
    }
}

// ===== MAIN ASSEMBLY =====

if (preview_assembly) {
    // Preview: coin inside holder
    translate([coin_diameter/2 + holder_teardrop_width/2 + print_spacing, 0, holder_wall_thickness])
        coin();
    translate([coin_diameter/2 + holder_teardrop_width/2 + print_spacing, 0, 0])
        holder();
} else {
    // Print layout: coin and holder side by side
    coin();
    translate([coin_diameter/2 + holder_teardrop_width/2 + print_spacing, 0, 0])
        holder();
}
