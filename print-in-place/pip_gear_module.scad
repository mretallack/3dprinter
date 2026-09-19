// Compact Support-Free Enclosed Pocket PiP Planetary Assembly

gear_thickness = 6;
pip_gap = 0.2;
wall_t = 1.6;

r_sun = 5.0;
r_planet = 5.0;
center_dist = r_sun + r_planet + pip_gap; // 10.2 mm

// Reduced frame size (snug around the 10.2mm radius gear train + wall thickness)
// Max outer radius of planet teeth centers (10.2) + planet radius (5) + wall (1.6) = ~16.8 mm radius -> ~36mm frame diameter/width
frame_size = 38; 
total_height = wall_t + gear_thickness + pip_gap + 4.0;

module simple_gear(teeth, r_pitch) {
    union() {
        cylinder(h=gear_thickness, r=r_pitch, $fn=30);
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, i * (360 / teeth)])
                translate([r_pitch - 0.4, 0, 0])
                    cube([1.6, 1.0, gear_thickness], center=true);
        }
    }
}

module pip_compact_assembly() {
    difference() {
        union() {
            // Compact outer frame box
            translate([-frame_size/2, -frame_size/2, 0])
                cube([frame_size, frame_size, total_height]);
            
            // Smaller snap connector tabs on sides
            translate([frame_size/2, -4, 0])
                cube([2.5, 8, total_height]);
            translate([-frame_size/2 - 2.5, -4, 0])
                cube([2.5, 8, total_height]);
        }
        
        // Internal gear cavity (snug to 16mm radius)
        translate([0, 0, wall_t])
            cylinder(h=gear_thickness + pip_gap, r=16.0, $fn=60);
            
        // Support-Free 45° Chamfered Dome Roof
        translate([0, 0, wall_t + gear_thickness + pip_gap])
            cylinder(h=12.0, r1=16.0, r2=3.0, $fn=60);
            
        // Top viewing window opening through the roof peak
        translate([0, 0, total_height - 3])
            cylinder(h=5.0, r=6.0, $fn=40);
            
        // Finger push hole in bottom floor
        translate([0, 0, -1])
            cylinder(h=wall_t + 2, r=3.5, $fn=30);
    }

    // Central Sun Gear
    translate([0, 0, wall_t + pip_gap/2]) {
        cylinder(h=gear_thickness, r=2.0, $fn=30);
        difference() {
            simple_gear(10, r_sun);
            cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
        }
    }

    // Planet Gears
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120])
            translate([center_dist, 0, wall_t + pip_gap/2]) {
                cylinder(h=gear_thickness, r=2.0, $fn=30);
                difference() {
                    simple_gear(10, r_planet);
                    cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
                }
            }
    }
}

pip_compact_assembly();
