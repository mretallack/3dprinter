// Sitting Spaniel Dog - Iteration 22
// Added: Eyebrows, improved belly tuck, better paw definition
// Feature score target: 27/27 (100%)

$fn = 40;

module dog_complete() {
    // Body - fuller chest, tapered hips, tucked belly
    hull() {
        translate([1, 0, 21])
            scale([1.4, 1.3, 1.7])
                sphere(d=14);
        translate([-14, 0, 7])
            scale([0.9, 1.2, 0.6])  // Narrower for belly tuck
                sphere(d=13);
    }
    
    // Neck
    hull() {
        translate([8, 0, 28])
            sphere(d=8);
        translate([12, 0, 32])
            sphere(d=9);
    }
    
    // Head
    hull() {
        translate([13, 0, 34])
            sphere(d=10);
        translate([19, 0, 33])
            sphere(d=7);
    }
    
    // Nose
    translate([21, 0, 33])
        sphere(d=2);
    
    // Eyes
    translate([14, -4, 35])
        sphere(d=1.5);
    translate([14, 4, 35])
        sphere(d=1.5);
    
    // NEW: Eyebrows (slight bulge above eyes)
    translate([14.5, -4, 36])
        sphere(d=1.2);
    translate([14.5, 4, 36])
        sphere(d=1.2);
    
    // Ears - very long, wavy
    hull() {
        translate([13, -7.5, 36])
            sphere(d=5);
        translate([12, -8, 29])
            sphere(d=4.5);
        translate([10, -7.8, 22])
            sphere(d=4);
        translate([8, -7.2, 15])
            sphere(d=3.5);
        translate([7, -6.8, 10])
            sphere(d=3);
        translate([6, -6.2, 7])
            sphere(d=2.5);
    }
    
    hull() {
        translate([13, 7.5, 36])
            sphere(d=5);
        translate([12, 8, 29])
            sphere(d=4.5);
        translate([10, 7.8, 22])
            sphere(d=4);
        translate([8, 7.2, 15])
            sphere(d=3.5);
        translate([7, 6.8, 10])
            sphere(d=3);
        translate([6, 6.2, 7])
            sphere(d=2.5);
    }
    
    // Front legs with better paw definition
    hull() {
        translate([5, -9, 1])
            cylinder(h=19, d=6);
        translate([5, -9, 0])
            sphere(d=7);
    }
    hull() {
        translate([5, 9, 1])
            cylinder(h=19, d=6);
        translate([5, 9, 0])
            sphere(d=7);
    }
    
    // Back legs with paws
    hull() {
        translate([-16, -10, 5])
            sphere(d=7);
        translate([-18, -10, 0.5])
            cylinder(h=0.5, d=6.5);
        translate([-18, -10, 0])
            sphere(d=7.5);
    }
    hull() {
        translate([-16, 10, 5])
            sphere(d=7);
        translate([-18, 10, 0.5])
            cylinder(h=0.5, d=6.5);
        translate([-18, 10, 0])
            sphere(d=7.5);
    }
    
    // Tail
    hull() {
        translate([-18, 0, 9])
            sphere(d=4);
        translate([-21, 0, 11])
            sphere(d=3);
        translate([-22, 0, 12])
            sphere(d=2);
    }
}

dog_complete();