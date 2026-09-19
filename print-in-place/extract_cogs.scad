// Isolate just the inner cogs (Sun + 3 Planet gears) from pip_gear_module.scad

gear_thickness = 6;
pip_gap = 0.2;
r_sun = 5.0;
r_planet = 5.0;
center_dist = r_sun + r_planet + pip_gap;

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

module only_cogs() {
    // Central Sun Gear
    difference() {
        simple_gear(10, r_sun);
        cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
    }

    // Planet Gears
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120])
            translate([center_dist, 0, 0])
            difference() {
                simple_gear(10, r_planet);
                cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
            }
    }
}

only_cogs();
