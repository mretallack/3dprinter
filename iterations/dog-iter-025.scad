// Sitting Spaniel Dog - Iteration 25
// Final polish: optimized proportions, all features refined
// Target: Production-ready model

$fn = 45;

module dog_complete() {
    // Body - final proportions
    hull() {
        translate([2, 0, 22])
            scale([1.5, 1.35, 1.8])
                sphere(d=14);
        translate([-4, 0, 16])
            scale([1.2, 1.35, 1.3])
                sphere(d=13);
        translate([-14, 0, 7])
            scale([0.85, 1.25, 0.6])
                sphere(d=12);
    }
    
    // Neck - smooth
    hull() {
        translate([8, 0, 28])
            sphere(d=8.5);
        translate([12, 0, 32])
            sphere(d=9.5);
    }
    
    // Head - refined
    hull() {
        translate([13, 0, 34.5])
            sphere(d=10);
        translate([19, 0, 33.5])
            sphere(d=7);
    }
    
    // Nose - prominent
    translate([21, 0, 33.5])
        sphere(d=2.3);
    
    // Mouth
    hull() {
        translate([20, 0, 32.5])
            sphere(d=0.8);
        translate([18, 0, 32])
            sphere(d=0.6);
    }
    
    // Eyes - positioned well
    translate([14, -4.2, 35.5])
        sphere(d=1.6);
    translate([14, 4.2, 35.5])
        sphere(d=1.6);
    
    // Eyebrows
    translate([14.5, -4.2, 36.5])
        sphere(d=1.3);
    translate([14.5, 4.2, 36.5])
        sphere(d=1.3);
    
    // Ears - signature long, wavy spaniel ears
    hull() {
        translate([13, -7.5, 37])
            sphere(d=5.2);
        translate([12.5, -7.8, 32.5])
            sphere(d=4.8);
        translate([12, -8, 29.5])
            sphere(d=4.6);
        translate([11, -7.9, 25.5])
            sphere(d=4.3);
        translate([10, -7.8, 22.5])
            sphere(d=4.1);
        translate([9, -7.5, 18.5])
            sphere(d=3.8);
        translate([8, -7.2, 15.5])
            sphere(d=3.6);
        translate([7, -6.8, 11.5])
            sphere(d=3.3);
        translate([6.5, -6.5, 9.5])
            sphere(d=3.1);
        translate([6, -6.2, 7.5])
            sphere(d=2.7);
    }
    
    hull() {
        translate([13, 7.5, 37])
            sphere(d=5.2);
        translate([12.5, 7.8, 32.5])
            sphere(d=4.8);
        translate([12, 8, 29.5])
            sphere(d=4.6);
        translate([11, 7.9, 25.5])
            sphere(d=4.3);
        translate([10, 7.8, 22.5])
            sphere(d=4.1);
        translate([9, 7.5, 18.5])
            sphere(d=3.8);
        translate([8, 7.2, 15.5])
            sphere(d=3.6);
        translate([7, 6.8, 11.5])
            sphere(d=3.3);
        translate([6.5, 6.5, 9.5])
            sphere(d=3.1);
        translate([6, 6.2, 7.5])
            sphere(d=2.7);
    }
    
    // Front legs - strong
    hull() {
        translate([5, -9.5, 1])
            cylinder(h=20, d=6.2);
        translate([5, -9.5, 0])
            sphere(d=7.2);
    }
    hull() {
        translate([5, 9.5, 1])
            cylinder(h=20, d=6.2);
        translate([5, 9.5, 0])
            sphere(d=7.2);
    }
    
    // Back legs - sitting
    hull() {
        translate([-16, -10.5, 5])
            sphere(d=7.2);
        translate([-18, -10.5, 0.5])
            cylinder(h=0.5, d=6.8);
        translate([-18, -10.5, 0])
            sphere(d=7.8);
    }
    hull() {
        translate([-16, 10.5, 5])
            sphere(d=7.2);
        translate([-18, 10.5, 0.5])
            cylinder(h=0.5, d=6.8);
        translate([-18, 10.5, 0])
            sphere(d=7.8);
    }
    
    // Tail - curved
    hull() {
        translate([-18, 0, 9.5])
            sphere(d=4.2);
        translate([-21, 0, 11.5])
            sphere(d=3.2);
        translate([-22, 0, 12.5])
            sphere(d=2.2);
    }
}

dog_complete();