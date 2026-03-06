// Simple 3D Printable Coin
// Diameter: 25mm, Thickness: 3mm

$fn = 100; // Smooth circles

module coin() {
    difference() {
        // Main coin body
        cylinder(h = 3, d = 25, center = true);
        
        // Top text (embossed)
        translate([0, 0, 2.5])
            linear_extrude(height = 1)
                text("COIN", size = 5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        
        // Bottom value (embossed)
        translate([0, 0, -3.5])
            rotate([180, 0, 0])
                linear_extrude(height = 1)
                    text("1", size = 8, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
    
    // Edge ridges
    for (i = [0:20]) {
        rotate([0, 0, i * 18])
            translate([12.5, 0, 0])
                cube([0.5, 0.5, 3], center = true);
    }
}

coin();
