// Sitting Spaniel Dog - Iteration 16-20 FINAL
// Maximum detail matching reference photo

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
    
    // Extremely long, flowing ears (signature spaniel feature)
    hull() {
        translate([13, -7.5, 36])
            sphere(d=5);
        translate([11, -8, 28])
            sphere(d=4.5);
        translate([9, -7.5, 20])
            sphere(d=4);
        translate([7, -7, 13])
            sphere(d=3.5);
        translate([6, -6.5, 9])
            sphere(d=3);
        translate([5, -6, 7])
            sphere(d=2.5);
    }
    
    hull() {
        translate([13, 7.5, 36])
            sphere(d=5);
        translate([11, 8, 28])
            sphere(d=4.5);
        translate([9, 7.5, 20])
            sphere(d=4);
        translate([7, 7, 13])
            sphere(d=3.5);
        translate([6, 6.5, 9])
            sphere(d=3);
        translate([5, 6, 7])
            sphere(d=2.5);
    }
    
    // Front legs - strong and upright
    translate([5, -9, 0])
        cylinder(h=20, d=6);
    translate([5, 9, 0])
        cylinder(h=20, d=6);
    
    // Back legs - sitting position
    hull() {
        translate([-16, -10, 5])
            sphere(d=7);
        translate([-18, -10, 0])
            cylinder(h=1, d=6.5);
    }
    hull() {
        translate([-16, 10, 5])
            sphere(d=7);
        translate([-18, 10, 0])
            cylinder(h=1, d=6.5);
    }
    
    // Tail - small and curved
    hull() {
        translate([-18, 0, 9])
            sphere(d=4);
        translate([-21, 0, 11])
            sphere(d=3);
    }
}

dog_complete();
