include <pip_gear_module.scad>
translate([0, 0, wall_t + pip_gap/2]) {
    difference() {
        proper_gear(10, r_sun);
        cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
    }
}
for (i = [0 : 2]) {
    rotate([0, 0, i * 120])
        translate([center_dist, 0, wall_t + pip_gap/2])
            rotate([0, 0, i * 36])
            difference() {
                proper_gear(10, r_planet);
                cylinder(h=gear_thickness + 2, r=2.0 + pip_gap, $fn=30);
            }
}
