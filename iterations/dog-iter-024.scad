// Sitting Spaniel Dog - Iteration 24
// Better shoulder definition, more prominent chest
// Refined body curve

$fn = 42;

module dog_complete() {
    // Body with better shoulder definition
    hull() {
        // Chest - more prominent
        translate([2, 0, 22])
            scale([1.5, 1.3, 1.8])
                sphere(d=14);
        // Shoulders
        translate([-4, 0, 16])
            scale([1.2, 1.3, 1.3])
                sphere(d=13);
        // Hips - narrower
        translate([-14, 0, 7])
            scale([0.85, 1.2, 0.6])
                sphere(d=12);
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
        sphere(d=2.2);
    
    // Mouth line
    hull() {
        translate([20, 0, 32])
            sphere(d=0.8);
        translate([18, 0, 31.5])
            sphere(d=0.6);
    }
    
    // Eyes
    translate([14, -4, 35])
        sphere(d=1.5);
    translate([14, 4, 35])
        sphere(d=1.5);
    
    // Eyebrows
    translate([14.5, -4, 36])
        sphere(d=1.2);
    translate([14.5, 4, 36])
        sphere(d=1.2);
    
    // Ears - textured
    hull() {
        translate([13, -7.5, 36])
            sphere(d=5);
        translate([12.5, -7.8, 32])
            sphere(d=4.7);
        translate([12, -8, 29])
            sphere(d=4.5);
        translate([11, -7.9, 25])
            sphere(d=4.2);
        translate([10, -7.8, 22])
            sphere(d=4);
        translate([9, -7.5, 18])
            sphere(d=3.7);
        translate([8, -7.2, 15])
            sphere(d=3.5);
        translate([7, -6.8, 11])
            sphere(d=3.2);
        translate([6.5, -6.5, 9])
            sphere(d=3);
        translate([6, -6.2, 7])
            sphere(d=2.5);
    }
    
    hull() {
        translate([13, 7.5, 36])
            sphere(d=5);
        translate([12.5, 7.8, 32])
            sphere(d=4.7);
        translate([12, 8, 29])
            sphere(d=4.5);
        translate([11, 7.9, 25])
            sphere(d=4.2);
        translate([10, 7.8, 22])
            sphere(d=4);
        translate([9, 7.5, 18])
            sphere(d=3.7);
        translate([8, 7.2, 15])
            sphere(d=3.5);
        translate([7, 6.8, 11])
            sphere(d=3.2);
        translate([6.5, 6.5, 9])
            sphere(d=3);
        translate([6, 6.2, 7])
            sphere(d=2.5);
    }
    
    // Front legs
    hull() {
        translate([5, -9, 1])
            cylinder(h=20, d=6);
        translate([5, -9, 0])
            sphere(d=7);
    }
    hull() {
        translate([5, 9, 1])
            cylinder(h=20, d=6);
        translate([5, 9, 0])
            sphere(d=7);
    }
    
    // Back legs
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