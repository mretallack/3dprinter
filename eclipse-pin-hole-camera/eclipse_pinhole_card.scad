// Multi-Pinhole Eclipse Projection Card
// Flat FDM-optimized card with pinhole array for solar eclipse projection.
// Prints flat with zero supports in ~20 minutes at 0.2mm layer height.

// ─── Parameters ───────────────────────────────────────────────────────────────

// Card body
card_length    = 55;    // mm - main card length (excluding handle)
card_width     = 50;    // mm - card width
card_thickness = 1.6;   // mm - total thickness (8 layers at 0.2mm)
corner_radius  = 4;     // mm - rounded corner radius

// Handle
handle_length  = 28;    // mm - paddle handle extension
handle_width   = 20;    // mm - handle width
lanyard_hole   = 5;     // mm - lanyard hole diameter
lanyard_offset = 10;    // mm - distance from end of handle to hole center

// Pinhole array
hole_dia       = 1.8;   // mm - pinhole diameter
hole_pitch     = 5;     // mm - center-to-center spacing
grid_cols      = 8;     // number of columns
grid_rows      = 7;     // number of rows

// Resolution
$fn = 40;

// ─── Derived values ───────────────────────────────────────────────────────────

total_length = card_length + handle_length;

// Grid centered on card body (not including handle)
grid_width  = (grid_cols - 1) * hole_pitch;
grid_height = (grid_rows - 1) * hole_pitch;
grid_offset_x = handle_length + (card_length - grid_width) / 2;
grid_offset_y = (card_width - grid_height) / 2;

// ─── Modules ──────────────────────────────────────────────────────────────────

module rounded_rect(length, width, height, radius) {
    linear_extrude(height)
        offset(r = radius)
            offset(delta = -radius)
                square([length, width]);
}

module card_body() {
    // Main card with handle as one continuous shape
    hull() {
        // Card body corners
        translate([handle_length, 0, 0])
            rounded_rect(card_length, card_width, card_thickness, corner_radius);
    }
    // Handle
    translate([0, (card_width - handle_width) / 2, 0])
        rounded_rect(handle_length + corner_radius, handle_width, card_thickness, corner_radius);
}

module pinhole_array() {
    for (col = [0 : grid_cols - 1]) {
        for (row = [0 : grid_rows - 1]) {
            translate([
                grid_offset_x + col * hole_pitch,
                grid_offset_y + row * hole_pitch,
                -0.1
            ])
                cylinder(h = card_thickness + 0.2, d = hole_dia);
        }
    }
}

module lanyard_hole() {
    translate([
        lanyard_offset,
        card_width / 2,
        -0.1
    ])
        cylinder(h = card_thickness + 0.2, d = lanyard_hole);
}

// ─── Final Model ──────────────────────────────────────────────────────────────

difference() {
    card_body();
    pinhole_array();
    lanyard_hole();
}
