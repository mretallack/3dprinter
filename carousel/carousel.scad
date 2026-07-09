// Carousel - Miniature Fairground Carousel
// Driven by steam engine via band-and-spindle
// Crown-and-spur gear converts horizontal to vertical rotation
// All pieces print without supports on Tina2

// ========================
// === PARAMETERS ===
// ========================

// --- Gear parameters ---
gear_teeth = 12;
gear_module = 1.2;          // tooth size (pitch diameter = teeth * module)
gear_pitch_d = gear_teeth * gear_module;  // 14.4mm
gear_thickness = 4;         // spur gear disc thickness
gear_backlash = 0.2;        // gap between meshing teeth
tooth_height = 2;           // height of each tooth
tooth_top_width = 1.2;      // flat top of trapezoid
tooth_angle = 20;           // side angle of trapezoid

// --- Crown gear extras ---
crown_nub_d = 6;            // nub diameter (below crown gear)
crown_nub_h = 4;            // nub length into housing floor bore
crown_stub_d = 6;           // stub diameter (above crown gear, through lid)
crown_stub_h = 5;           // stub length through lid

// --- Spindle parameters ---
spindle_radius = 2.5;
spindle_length = 40;        // total spindle length
pulley_radius = 8;
pulley_width = 6;
pulley_groove_depth = 1.5;
spindle_collar_width = 2;

// --- Housing parameters ---
housing_inner_w = 22;       // internal width (X)
housing_inner_d = 22;       // internal depth (Y)
housing_inner_h = 18;       // internal height (Z)
housing_wall = 3;           // wall thickness
housing_flange = 5;         // extra flange width for screw holes
screw_hole_r = 1.5;
screw_inset = 4;

// --- Pole parameters ---
pole_radius = 4;            // 8mm diameter
pole_length = 25;           // visible length above housing (shortened)
pole_collar_h = 2;          // collar height
pole_collar_r = 6;          // collar radius

// --- Platform parameters ---
platform_radius = 20;       // 40mm diameter
platform_thickness = 3;
peg_radius = 1;
peg_height = 5;
peg_inset = 14;             // distance from centre to pegs
vehicle_count = 4;

// --- Canopy parameters ---
canopy_radius = 20;         // base radius (matches platform)
canopy_height = 20;         // 45 degree slope

// --- Vehicle parameters ---
vehicle_thickness = 3;
vehicle_hole_r = 1.2;       // slightly larger than peg for fit

// --- Clearances ---
clearance_tight = 0.15;     // press-fit joints
clearance_loose = 0.2;      // sliding/removable joints

// --- Derived ---
housing_outer_w = housing_inner_w + housing_wall * 2;
housing_outer_d = housing_inner_d + housing_wall * 2;
housing_outer_h = housing_inner_h + housing_wall;  // no top wall (lid separate)
spindle_y_pos = housing_inner_h / 2;  // spindle at mid-height of housing

$fn = 30;

// ========================
// === GEAR MODULES ===
// ========================

module tooth_2d() {
    // Trapezoidal tooth profile (2D)
    base_width = (3.14159 * gear_pitch_d / gear_teeth) / 2;
    translate([0, 0])
        polygon([
            [-base_width/2, 0],
            [-tooth_top_width/2, tooth_height],
            [tooth_top_width/2, tooth_height],
            [base_width/2, 0]
        ]);
}

module spur_gear() {
    // Flat disc with trapezoidal teeth on circumference
    gear_r = gear_pitch_d / 2;
    bore_r = spindle_radius + clearance_tight;

    difference() {
        union() {
            // Base disc
            cylinder(h=gear_thickness, r=gear_r, $fn=60);
            // Teeth around circumference
            for (i = [0:gear_teeth-1]) {
                angle = i * (360 / gear_teeth);
                rotate([0, 0, angle])
                    translate([gear_r, 0, 0])
                        rotate([0, 0, 0])
                            linear_extrude(height=gear_thickness)
                                tooth_2d();
            }
        }
        // D-shaped bore
        translate([0, 0, -0.5])
            d_bore(gear_thickness + 1, bore_r);
    }
}

module crown_gear() {
    // Flat disc with short teeth around rim (on face) + nub below + stub above
    gear_r = gear_pitch_d / 2;
    crown_tooth_pitch = 3.14159 * gear_pitch_d / gear_teeth;
    crown_tooth_width = crown_tooth_pitch / 2;

    union() {
        // Nub below (bearing in housing floor)
        translate([0, 0, -crown_nub_h])
            cylinder(h=crown_nub_h, r=crown_nub_d/2, $fn=30);

        // Main disc
        cylinder(h=gear_thickness, r=gear_r, $fn=60);

        // Face teeth - short bumps around the rim only (not full radius)
        for (i = [0:gear_teeth-1]) {
            angle = i * (360 / gear_teeth);
            rotate([0, 0, angle])
                translate([gear_r - tooth_height, -crown_tooth_width/2, gear_thickness])
                    cube([tooth_height, crown_tooth_width, tooth_height]);
        }

        // Stub above (bearing through lid, D-flat for pole)
        translate([0, 0, gear_thickness + tooth_height])
            difference() {
                cylinder(h=crown_stub_h, r=crown_stub_d/2, $fn=30);
                // D-flat on stub
                translate([crown_stub_d/2 + crown_stub_d/2 - 1, 0, 0])
                    cube([crown_stub_d, crown_stub_d, crown_stub_h * 2 + 1], center=true);
            }
    }
}

// ========================
// === HOUSING MODULES ===
// ========================

module housing_tray() {
    // Open-top box with floor bore, spindle bores, screw holes, flange
    outer_w = housing_outer_w;
    outer_d = housing_outer_d;
    outer_h = housing_outer_h;
    floor_h = housing_wall;

    difference() {
        union() {
            // Main box
            translate([-outer_w/2, -outer_d/2, 0])
                cube([outer_w, outer_d, outer_h]);
            // Flange
            translate([-(outer_w/2 + housing_flange), -(outer_d/2 + housing_flange), 0])
                cube([outer_w + housing_flange*2, outer_d + housing_flange*2, floor_h]);
        }
        // Internal cavity
        translate([-housing_inner_w/2, -housing_inner_d/2, floor_h])
            cube([housing_inner_w, housing_inner_d, housing_inner_h + 1]);

        // Floor bore for crown gear nub
        translate([0, 0, -0.5])
            cylinder(h=floor_h + 1, r=crown_nub_d/2 + clearance_tight, $fn=30);

        // Spindle bores (through both Y walls)
        translate([0, -(outer_d/2 + 1), floor_h + spindle_y_pos])
            rotate([-90, 0, 0])
                cylinder(h=outer_d + 2, r=spindle_radius + clearance_tight, $fn=20);

        // Screw holes in flange (4 corners)
        for (x = [-(outer_w/2 + housing_flange) + screw_inset, (outer_w/2 + housing_flange) - screw_inset])
            for (y = [-(outer_d/2 + housing_flange) + screw_inset, (outer_d/2 + housing_flange) - screw_inset])
                translate([x, y, -0.5])
                    cylinder(h=floor_h + 1, r=screw_hole_r, $fn=20);
    }
}

module housing_lid() {
    // Flat plate that clips onto tray top, with output bore
    outer_w = housing_outer_w;
    outer_d = housing_outer_d;
    lid_h = housing_wall;

    difference() {
        union() {
            // Main plate
            translate([-outer_w/2, -outer_d/2, 0])
                cube([outer_w, outer_d, lid_h]);
            // Lip to locate on tray (fits inside tray walls)
            translate([-(housing_inner_w/2 - clearance_tight), -(housing_inner_d/2 - clearance_tight), -2])
                cube([housing_inner_w - clearance_tight*2, housing_inner_d - clearance_tight*2, 2]);
        }
        // Output bore for crown gear stub
        translate([0, 0, -3])
            cylinder(h=lid_h + 4, r=crown_stub_d/2 + clearance_tight, $fn=30);
    }
}

// ========================
// === SPINDLE MODULE ===
// ========================

module input_spindle() {
    // Horizontal shaft with integrated V-groove pulley + D-flat + collar
    total_length = spindle_length;

    difference() {
        union() {
            // Main shaft
            rotate([90, 0, 0])
                cylinder(h=total_length, r=spindle_radius, center=true, $fn=20);

            // Pulley on one end
            translate([0, -total_length/2 + pulley_width/2, 0])
                rotate([90, 0, 0])
                    difference() {
                        cylinder(h=pulley_width, r=pulley_radius, center=true, $fn=40);
                        rotate_extrude($fn=40)
                            translate([pulley_radius - pulley_groove_depth/2, 0, 0])
                                circle(r=pulley_groove_depth, $fn=20);
                    }

            // Collar (positions spur gear)
            collar_pos = 5;  // distance from centre toward pulley side
            translate([0, -collar_pos, 0])
                rotate([90, 0, 0])
                    cylinder(h=spindle_collar_width, r=spindle_radius + 1.5, center=true, $fn=20);
        }

        // D-flat for spur gear keying (middle section)
        translate([spindle_radius, 0, 0])
            cube([spindle_radius * 2, housing_inner_d, spindle_radius * 2], center=true);
    }
}

// ========================
// === HELPERS ===
// ========================

module d_bore(depth, radius) {
    // D-shaped bore (cylinder with flat)
    difference() {
        cylinder(h=depth, r=radius, $fn=20);
        translate([radius + radius - 1, 0, depth/2])
            cube([radius * 2, radius * 2, depth + 1], center=true);
    }
}

// ========================
// === POLE MODULE ===
// ========================

module centre_pole() {
    // 8mm diameter vertical pole
    // D-hole at bottom (keys onto crown gear stub)
    // Collar part-way up (platform rests on it)
    // Top section for canopy press-fit

    pole_total = pole_length + crown_stub_h;  // total including hidden section in housing

    difference() {
        union() {
            // Main shaft
            cylinder(h=pole_total, r=pole_radius, $fn=30);
            // Collar
            translate([0, 0, crown_stub_h + pole_length * 0.2])
                cylinder(h=pole_collar_h, r=pole_collar_r, $fn=30);
        }
        // D-hole at bottom (to key onto crown gear stub)
        translate([0, 0, -0.5])
            d_bore(crown_stub_h + 1, crown_stub_d/2 + clearance_tight);
    }
}

// ========================
// === PLATFORM MODULE ===
// ========================

module platform() {
    // 40mm disc with centre bore (slides over pole) and 4 vehicle pegs

    difference() {
        // Main disc
        cylinder(h=platform_thickness, r=platform_radius, $fn=60);
        // Centre hole (slides over pole)
        translate([0, 0, -0.5])
            cylinder(h=platform_thickness + 1, r=pole_radius + clearance_loose, $fn=30);
    }

    // 4 pegs at 90 degree intervals
    for (i = [0:vehicle_count-1]) {
        angle = i * (360 / vehicle_count);
        rotate([0, 0, angle])
            translate([peg_inset, 0, platform_thickness])
                cylinder(h=peg_height, r=peg_radius, $fn=20);
    }
}

// ========================
// === CANOPY MODULE ===
// ========================

module canopy() {
    // Plain cone, 45 degree slope, centre hole for pole top press-fit
    // Prints upside-down (point on bed)

    difference() {
        cylinder(h=canopy_height, r1=canopy_radius, r2=0, $fn=60);
        // Centre hole for pole
        translate([0, 0, -0.5])
            cylinder(h=canopy_height * 0.6, r=pole_radius + clearance_tight, $fn=30);
    }
}

// ========================
// === VEHICLE MODULES ===
// ========================

module vehicle_base(profile_points) {
    // Extrude a 2D profile and add peg hole in base
    difference() {
        linear_extrude(height=vehicle_thickness)
            polygon(profile_points);
        // Peg hole centred at bottom
        translate([0, 0, -0.5])
            cylinder(h=vehicle_thickness + 1, r=vehicle_hole_r, $fn=20);
    }
}

module vehicle_horse() {
    // Simplified horse profile ~8x10mm
    points = [
        [0, 0],       // base centre-left
        [-3, 0],      // base left
        [-3, 4],      // body left
        [-2, 6],      // neck start
        [-1.5, 9],    // head bottom
        [-2.5, 10],   // head top
        [-1, 10],     // snout
        [-0.5, 8.5],  // jaw
        [0, 9],       // neck front
        [1, 7],       // chest
        [3, 6],       // body right
        [3, 4],       // rump
        [4, 3],       // tail
        [3, 2],       // tail end
        [3, 0],       // base right
    ];
    vehicle_base(points);
}

module vehicle_car() {
    // Simplified car profile ~10x6mm
    points = [
        [0, 0],       // base centre
        [-5, 0],      // base left
        [-5, 2],      // body left
        [-4, 2],      // hood start
        [-3, 4],      // windscreen bottom
        [-1, 5],      // roof left
        [2, 5],       // roof right
        [3.5, 4],     // rear windscreen
        [4, 2.5],     // trunk
        [5, 2],       // body right
        [5, 0],       // base right
    ];
    vehicle_base(points);
}

module vehicle_rocket() {
    // Simplified rocket profile ~5x12mm
    points = [
        [0, 0],       // base centre
        [-2, 0],      // fin left
        [-3, 1],      // fin tip left
        [-2, 2],      // fin top left
        [-1.5, 2],    // body left bottom
        [-1.5, 9],    // body left top
        [-0.5, 11],   // nose left
        [0, 12],      // nose tip
        [0.5, 11],    // nose right
        [1.5, 9],     // body right top
        [1.5, 2],     // body right bottom
        [2, 2],       // fin top right
        [3, 1],       // fin tip right
        [2, 0],       // fin right
    ];
    vehicle_base(points);
}

module vehicle_boat() {
    // Simplified boat profile ~10x7mm
    points = [
        [0, 0],       // base centre
        [-4, 0],      // hull left bottom
        [-5, 1],      // bow
        [-4, 2],      // hull left top
        [-3, 2],      // deck left
        [-2, 4],      // cabin left
        [-1, 5],      // cabin roof left
        [1, 5],       // cabin roof right
        [2, 4],       // cabin right
        [3, 2],       // deck right
        [4, 2],       // hull right top
        [4.5, 1],     // stern
        [4, 0],       // hull right bottom
    ];
    vehicle_base(points);
}

// ========================
// === ASSEMBLY ===
// ========================

module assembly() {
    // Full carousel assembled for preview
    floor_h = housing_wall;
    gear_z = floor_h;  // crown gear sits on housing floor

    // Housing tray
    housing_tray();

    // Crown gear (in housing, nub in floor bore)
    translate([0, 0, floor_h + crown_nub_h])
        crown_gear();

    // Spur gear (on spindle, meshing with crown gear)
    crown_top_z = floor_h + crown_nub_h + gear_thickness;
    translate([gear_pitch_d/2 + gear_backlash, 0, floor_h + spindle_y_pos])
        rotate([0, 0, 0])
            rotate([0, 90, 0])
                spur_gear();

    // Input spindle
    translate([0, 0, floor_h + spindle_y_pos])
        input_spindle();

    // Housing lid
    translate([0, 0, housing_outer_h])
        housing_lid();

    // Centre pole (keys onto crown gear stub)
    pole_base_z = crown_top_z + tooth_height + 1;  // above crown teeth + stub start
    translate([0, 0, pole_base_z])
        centre_pole();

    // Platform (on collar)
    platform_z = pole_base_z + crown_stub_h + pole_length * 0.2 + pole_collar_h;
    translate([0, 0, platform_z])
        platform();

    // Vehicles on platform pegs
    vehicle_z = platform_z + platform_thickness;
    for (i = [0:vehicle_count-1]) {
        angle = i * (360 / vehicle_count);
        rotate([0, 0, angle])
            translate([peg_inset, 0, vehicle_z])
                rotate([0, 0, 90])  // face outward (profile visible from outside)
                    rotate([90, 0, 0])  // stand upright
                        translate([0, 0, -vehicle_thickness/2]) {
                            if (i == 0) vehicle_horse();
                            if (i == 1) vehicle_car();
                            if (i == 2) vehicle_rocket();
                            if (i == 3) vehicle_boat();
                        }
    }

    // Canopy (press-fit on pole top)
    canopy_z = pole_base_z + crown_stub_h + pole_length - canopy_height + 22;
    translate([0, 0, canopy_z])
        canopy();
}

// ========================
// === PREVIEW ===
// ========================

// Uncomment to preview individual pieces:
// spur_gear();
// crown_gear();
// housing_tray();
// housing_lid();
// input_spindle();
// centre_pole();
// platform();
// canopy();
// vehicle_horse();
// vehicle_car();
// vehicle_rocket();
// vehicle_boat();
// assembly();
