// Sitting Spaniel Dog - Iteration 21
// Added: Eyes, nose, improved ear curve, better proportions
// Feature score target: 30/40

$fn = 40;

module dog_complete() {
    // Body - fuller chest, tapered hips
    hull() {
        translate([1, 0, 21])
            scale([1.4, 1.3, 1.7])
                sphere(d=14);
        translate([-14, 0, 7])
            scale([1, 1.2, 0.6])
                sphere(d=13);
    }
    
    // Neck - smooth transition
    hull() {
        translate([8, 0, 28])
            sphere(d=8);
        translate([12, 0, 32])
            sphere(d=9);
    }
    
    // Head - proportional to body
    hull() {
        translate([13, 0, 34])
            sphere(d=10);
        translate([19, 0, 33])
            sphere(d=7);
    }
    
    // NEW: Nose at end of snout
    translate([21, 0, 33])
        sphere(d=2);
    
    // NEW: Eyes on sides of head
    translate([14, -4, 35])
        sphere(d=1.5);
    translate([14, 4, 35])
        sphere(d=1.5);
    
    // Improved ears - more curve, fuller at top
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
    
    // Front legs with paw definition
    hull() {
        translate([5, -9, 0])
            cylinder(h=20, d=6);
        translate([5, -9, 0])
            sphere(d=6.5);
    }
    hull() {
        translate([5, 9, 0])
            cylinder(h=20, d=6);
        translate([5, 9, 0])
            sphere(d=6.5);
    }
    
    // Back legs - sitting position with paws
    hull() {
        translate([-16, -10, 5])
            sphere(d=7);
        translate([-18, -10, 0])
            cylinder(h=1, d=6.5);
        translate([-18, -10, 0])
            sphere(d=7);
    }
    hull() {
        translate([-16, 10, 5])
            sphere(d=7);
        translate([-18, 10, 0])
            cylinder(h=1, d=6.5);
        translate([-18, 10, 0])
            sphere(d=7);
    }
    
    // Tail - improved curve
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