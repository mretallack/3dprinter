// Sitting Spaniel-type Dog Model for Tina2 Basic Printer
// Based on reference photo - sitting pose with long ears
// Target size: 55x45x70mm

$fn = 50;

// Body - sitting position
module dog_body() {
    translate([0, 0, 15])
        scale([1.2, 1, 1.4])
            sphere(d=30);
}

// Head - elongated with snout
module dog_head() {
    translate([22, 0, 35]) {
        // Main head
        scale([1.3, 1, 1.1])
            sphere(d=18);
        // Snout
        translate([10, 0, -2])
            scale([1.5, 0.8, 0.7])
                sphere(d=10);
    }
}

// Long floppy ears
module dog_ear(side) {
    translate([22, side * 10, 35])
        rotate([0, 15, side * 20])
            scale([0.4, 1, 2])
                sphere(d=12);
}

// Front legs - sitting upright
module front_leg(side) {
    translate([10, side * 10, 7.5])
        cylinder(h=15, d=7);
}

// Back legs - folded sitting position
module back_leg(side) {
    translate([-8, side * 11, 4])
        rotate([0, 90, 0])
            cylinder(h=10, d=8);
}

// Tail - small
module dog_tail() {
    translate([-18, 0, 18])
        rotate([0, 45, 0])
            cylinder(h=12, d1=5, d2=2);
}

// Complete dog assembly
module dog_complete() {
    union() {
        dog_body();
        dog_head();
        dog_ear(1);
        dog_ear(-1);
        front_leg(1);
        front_leg(-1);
        back_leg(1);
        back_leg(-1);
        dog_tail();
    }
}

dog_complete();
