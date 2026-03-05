// Lying Down Spaniel Dog - Iteration 5
// Based on reference photo - sphinx/lying pose with very long ears
// Target size: 60x30x25mm (lying down is longer and lower)

$fn = 30;

module dog_complete() {
    // Body - elongated and lower (lying down)
    hull() {
        // Front of body (chest)
        translate([10, 0, 8])
            scale([1, 1, 0.8])
                sphere(d=16);
        
        // Back of body (hips)
        translate([-10, 0, 8])
            scale([1, 1, 0.8])
                sphere(d=14);
    }
    
    // Head - elongated forward
    hull() {
        translate([20, 0, 10])
            sphere(d=12);
        
        // Elongated snout
        translate([28, 0, 9])
            sphere(d=6);
    }
    
    // Very long floppy ears - hanging down to ground
    hull() {
        translate([20, -6, 12])
            sphere(d=3);
        translate([18, -7, 2])
            sphere(d=2.5);
        translate([16, -6, 0])
            sphere(d=2);
    }
    
    hull() {
        translate([20, 6, 12])
            sphere(d=3);
        translate([18, 7, 2])
            sphere(d=2.5);
        translate([16, 6, 0])
            sphere(d=2);
    }
    
    // Front legs - extended forward (lying down)
    hull() {
        translate([12, -6, 6])
            sphere(d=4);
        translate([18, -6, 0])
            cylinder(h=1, d=4);
    }
    
    hull() {
        translate([12, 6, 6])
            sphere(d=4);
        translate([18, 6, 0])
            cylinder(h=1, d=4);
    }
    
    // Back legs - tucked under body
    hull() {
        translate([-8, -7, 6])
            sphere(d=4.5);
        translate([-10, -7, 0])
            cylinder(h=1, d=4);
    }
    
    hull() {
        translate([-8, 7, 6])
            sphere(d=4.5);
        translate([-10, 7, 0])
            cylinder(h=1, d=4);
    }
    
    // Small tail
    hull() {
        translate([-14, 0, 8])
            sphere(d=2.5);
        translate([-18, 0, 10])
            sphere(d=1.5);
    }
}

dog_complete();
