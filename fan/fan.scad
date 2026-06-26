// Steam Engine Fan - Three Piece Design
// Piece 1: Base with U-cradle bearings (prints flat, no supports)
// Piece 2: Axle with pulley only (prints on side, minimal supports)
// Piece 3: Fan disc with D-hole hub (prints flat, no supports)

// === Parameters ===
fan_blades = 6;
fan_radius = 25;
fan_hub_radius = 6;
fan_blade_width = 8;
fan_blade_thickness = 2;
fan_blade_angle = 25;

pulley_radius = 8;
pulley_width = 6;
pulley_groove_depth = 1.5;

axle_radius = 2.5;
axle_length = 65;
d_flat_depth = 1;  // how much to cut for D-shape

base_length = 50;
base_width = 30;
base_height = 3;
base_screw_hole_radius = 1.5;
base_screw_inset = 5;

bearing_height = 35;
bearing_wall = 3;
bearing_width = 8;
clearance = 0.15;  // tight fit for open slot

// === D-shape profiles ===
module d_shaft(length) {
    // Axle with a flat cut on one side
    difference() {
        rotate([0, 90, 0])
            cylinder(h=length, r=axle_radius, center=true, $fn=20);
        // Cut flat
        translate([0, axle_radius - d_flat_depth + axle_radius, 0])
            cube([length + 1, axle_radius * 2, axle_radius * 2], center=true);
    }
}

module d_hole(depth) {
    // Matching D-shaped hole with clearance
    hole_r = axle_radius + 0.2;
    difference() {
        rotate([0, 90, 0])
            cylinder(h=depth + 1, r=hole_r, center=true, $fn=20);
        translate([0, hole_r - d_flat_depth + hole_r, 0])
            cube([depth + 2, hole_r * 2, hole_r * 2], center=true);
    }
}

// === Piece 1: Base with U-Cradle Bearings ===

module base() {
    difference() {
        cube([base_length, base_width, base_height], center=true);
        for (x = [-base_length/2 + base_screw_inset, base_length/2 - base_screw_inset])
            for (y = [-base_width/2 + base_screw_inset, base_width/2 - base_screw_inset])
                translate([x, y, 0])
                    cylinder(h=base_height+1, r=base_screw_hole_radius, center=true, $fn=20);
    }
}

module cradle_bearing() {
    cradle_r_inner = axle_radius + clearance;
    cradle_r_outer = cradle_r_inner + bearing_wall;
    post_width = bearing_width;
    post_depth = cradle_r_outer * 2;
    slot_width = (axle_radius + clearance) * 2;  // width of slot for axle
    slot_depth = bearing_height - 25;  // slot bottom at 25mm above base floor

    // Simple rectangular post with vertical slot from top
    difference() {
        // Solid post
        translate([-post_width/2, -post_depth/2, base_height/2])
            cube([post_width, post_depth, bearing_height - base_height/2]);
        // Vertical slot cut from top
        translate([-post_width/2 - 0.5, -slot_width/2, bearing_height - slot_depth])
            cube([post_width + 1, slot_width, slot_depth + 1]);
    }
}

module piece1_base() {
    translate([0, 0, base_height/2])
        base();
    pulley_bearing_x = -base_length/2 + bearing_width/2 + 2;
    fan_bearing_x = base_length/2 - bearing_width/2 - 2;
    translate([pulley_bearing_x, 0, 0])
        cradle_bearing();
    translate([fan_bearing_x, 0, 0])
        cradle_bearing();
}

// === Piece 2: Axle + Pulley (no fan) ===

module pulley() {
    rotate([0, 90, 0])
        difference() {
            cylinder(h=pulley_width, r=pulley_radius, center=true, $fn=40);
            rotate_extrude($fn=40)
                translate([pulley_radius - pulley_groove_depth/2, 0, 0])
                    circle(r=pulley_groove_depth, $fn=20);
        }
}

module piece2_axle() {
    // Axle with D-flat on fan end
    difference() {
        rotate([0, 90, 0])
            cylinder(h=axle_length, r=axle_radius, center=true, $fn=20);
        // D-flat cut on fan end (last 10mm)
        translate([axle_length/2 - 5, axle_radius, 0])
            cube([10.1, axle_radius * 2, axle_radius * 2], center=true);
    }
    // Pulley near one end
    translate([-axle_length/2 + pulley_width/2 + 2, 0, 0])
        pulley();
    // Retaining collar next to pulley
    translate([-axle_length/2 + pulley_width + 4, 0, 0])
        rotate([0, 90, 0])
            cylinder(h=2, r=axle_radius + 1.5, center=true, $fn=20);
}

// === Piece 3: Fan Disc ===

blade_sweep = 30;  // degrees of curve across blade length

module swept_blade() {
    blade_length = fan_radius - fan_hub_radius + 1;
    steps = 8;
    step_len = blade_length / steps;
    step_angle = blade_sweep / steps;

    for (s = [0:steps-1]) {
        rotate([0, 0, s * step_angle])
            translate([fan_hub_radius - 1 + s * step_len, -fan_blade_thickness/2, 0])
                cube([step_len + 0.1, fan_blade_thickness, fan_blade_width]);
    }
}

module piece3_fan() {
    difference() {
        union() {
            // Hub
            cylinder(h=fan_blade_width, r=fan_hub_radius, $fn=30);
            // Swept blades
            for (i = [0:fan_blades-1]) {
                rotate([0, 0, i * (360/fan_blades)])
                    swept_blade();
            }
        }
        // D-shaped hole through hub (along Z)
        translate([0, 0, -0.5]) {
            hole_r = axle_radius + 0.2;
            difference() {
                cylinder(h=fan_blade_width + 1, r=hole_r, $fn=20);
                translate([0, hole_r - d_flat_depth + hole_r, 0])
                    cube([hole_r * 2 + 1, hole_r * 2, fan_blade_width + 2], center=true);
            }
        }
    }
}

// === Render all pieces for preview ===
piece1_base();

translate([0, 0, bearing_height + 15])
    piece2_axle();

translate([0, 50, fan_radius + 5])
    piece3_fan();
