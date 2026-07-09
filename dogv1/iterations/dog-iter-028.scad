// Sitting Spaniel Dog - Iteration 28 PRINTABLE
// CRITICAL FIX: Model sitting on legs (paws on Z=0)
// Previous iterations had model upside down

$fn = 45;

module dog_complete() {
    // Front legs - paws FLAT on build plate at Z=0
    translate([5, -9, 0])
        cylinder(h=18, d=5.5);
    translate([5, 9, 0])
        cylinder(h=18, d=5.5);
    
    // Front paws (on build plate)
    translate([5, -9, 0])
        sphere(d=6.5);
    translate([5, 9, 0])
        sphere(d=6.5);
    
    // Back legs - sitting position, paws on build plate
    hull() {
        translate([-15, -10, 0])
            sphere(d=7);
        translate([-15, -10, 6])
            sphere(d=6.5);
    }
    hull() {
        translate([-15, 10, 0])
            sphere(d=7);
        translate([-15, 10, 6])
            sphere(d=6.5);
    }
    
    // Body - above legs
    hull() {
        translate([2, 0, 20])
            scale([1.4, 1.3, 1.6])
                sphere(d=14);
        translate([-4, 0, 15])
            scale([1.15, 1.3, 1.2])
                sphere(d=13);
        translate([-14, 0, 8])
            scale([0.85, 1.2, 0.65])
                sphere(d=12);
    }
    
    // Neck
    hull() {
        translate([8, 0, 26])
            sphere(d=7.5);
        translate([11, 0, 30])
            sphere(d=8);
    }
    
    // Head
    hull() {
        translate([12, 0, 32])
            scale([1.2, 0.9, 1])
                sphere(d=9);
        translate([20, 0, 31])
            sphere(d=6);
    }
    
    // Nose
    translate([22, 0, 31])
        sphere(d=2.2);
    
    // Eyes
    translate([13, -3.8, 33])
        sphere(d=1.6);
    translate([13, 3.8, 33])
        sphere(d=1.6);
    
    // Eyebrows
    translate([13.5, -3.8, 34])
        sphere(d=1.2);
    translate([13.5, 3.8, 34])
        sphere(d=1.2);
    
    // Ears - ending at neck level
    hull() {
        translate([12, -7, 34])
            sphere(d=5);
        translate([11, -7.3, 30])
            sphere(d=4.5);
        translate([10, -7.2, 27])
            sphere(d=4);
        translate([9, -7, 24])
            sphere(d=3.5);
        translate([8, -6.7, 21])
            sphere(d=3);
        translate([7.5, -6.5, 19])
            sphere(d=2.5);
    }
    
    hull() {
        translate([12, 7, 34])
            sphere(d=5);
        translate([11, 7.3, 30])
            sphere(d=4.5);
        translate([10, 7.2, 27])
            sphere(d=4);
        translate([9, 7, 24])
            sphere(d=3.5);
        translate([8, 6.7, 21])
            sphere(d=3);
        translate([7.5, 6.5, 19])
            sphere(d=2.5);
    }
    
    // Tail
    hull() {
        translate([-17, 0, 10])
            sphere(d=3.5);
        translate([-20, 0, 11])
            sphere(d=2.8);
        translate([-21, 0, 12])
            sphere(d=2);
    }
}

dog_complete();