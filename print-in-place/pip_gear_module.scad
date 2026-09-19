// Planetary Gear Module with Clean Trapezoidal Gear Teeth

gear_thickness = 6;
pip_gap = 0.2;
wall_t = 1.6;

r_sun = 5.0;
r_planet = 5.0;
center_dist = r_sun + r_planet + pip_gap;

frame_size = 38; 
total_height = wall_t + gear_thickness + pip_gap + 4.0;

// Clean gear module with true trapezoidal teeth blending into the core
module proper_gear(teeth, r_pitch) {
    union() {
        // Main gear body (slightly smaller so teeth form the pitch profile)
        cylinder(h=gear_thickness, r=r_pitch - 0.6, $fn=60);
        
        // Trapezoidal teeth
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, i * (360 / teeth)])
                translate([r_pitch - 0.5, 0, 0])
                    linear_extrude(height=gear_thickness)
                        polygon(points=[
                            [0, -0.8],
                            [1.2, -0.4],
                            [1.2, 0.4],
                            [0, 0.8]
                        ]);
        }
    }
}

module pip_compact_assembly() {
    difference() {
        union() {
            translate([-frame_size/2, -frame_size/2, 0])
                cube([frame_size, frame_size, total_height]);
            
            translate([frame_size/2, -4, 0])
                cube([2.5, 8, total_height]);
            translate([-frame_size/2 - 2.5, -4, 0])
                cube([2.5, 8, total_height]);
        }
        
        translate([0, 0, wall_t])
            cylinder(h=gear_thickness + pip_gap, r=16.0, $fn=60);
            
        translate([0, 0, wall_t + gear_thickness + pip_gap])
            cylinder(h=12.0, r1=16.0, r2=3.0, $fn=60);
            
        translate([0, 0, total_height - 3])
            cylinder(h=5.0, r=6.0, $fn=40);
            
        translate([0, 0, -1])
            cylinder(h=wall_t + 2, r=3.5, $fn=30);
    }

    // Central Sun Gear
    translate([0, 0, wall_t + pip_gap/2]) {
        cylinder(h=gear_thickness, r=2.0, $fn=30);
        difference() {
            proper_gear(10, r_sun);
            cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
        }
    }

    // Planet Gears
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120])
            translate([center_dist, 0, wall_t + pip_gap/2]) {
                cylinder(h=gear_thickness, r=2.0, $fn=30);
                rotate([0, 0, i * 36])
                difference() {
                    proper_gear(10, r_planet);
                    cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
                }
            }
    }
}

pip_compact_assembly();
