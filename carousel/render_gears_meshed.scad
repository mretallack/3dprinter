use <carousel.scad>

// Crown gear flat, teeth up
crown_gear();

// Spur gear: rotated 90 so its flat face is vertical
gear_r = 12 * 1.2 / 2;  // 7.2mm
tooth_h = 2;
gear_th = 4;

translate([gear_r + gear_r, 0, gear_th + tooth_h + gear_r])
    rotate([0, 90, 0])
        spur_gear();
