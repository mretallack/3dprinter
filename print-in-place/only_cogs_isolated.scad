// Strictly isolated cogs with zero case code

gear_thickness = 6;
pip_gap = 0.2;
r_sun = 5.0;
r_planet = 5.0;
center_dist = r_sun + r_planet + pip_gap;

module proper_gear(teeth, r_pitch) {
    union() {
        cylinder(h=gear_thickness, r=r_pitch - 0.6, $fn=60);
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

// Central Sun Gear
translate([0, 0, 0]) {
    difference() {
        proper_gear(10, r_sun);
        cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
    }
}

// Planet Gears
for (i = [0 : 2]) {
    rotate([0, 0, i * 120])
        translate([center_dist, 0, 0])
            rotate([0, 0, i * 36])
            difference() {
                proper_gear(10, r_planet);
                cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
            }
}
