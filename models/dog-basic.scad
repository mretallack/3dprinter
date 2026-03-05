// Sitting Spaniel Dog - Iteration 4
// Using hull() for guaranteed manifold geometry
// All parts smoothly connected

$fn = 30;

module dog_complete() {
    // Main body with legs using hull for smooth connection
    hull() {
        // Body center
        translate([0, 0, 18])
            scale([1.4, 1, 1.2])
                sphere(d=25);
        
        // Front left leg base
        translate([6, -8, 8])
            sphere(d=6);
        
        // Front right leg base
        translate([6, 8, 8])
            sphere(d=6);
        
        // Back left leg base
        translate([-8, -9, 8])
            sphere(d=6);
        
        // Back right leg base
        translate([-8, 9, 8])
            sphere(d=6);
    }
    
    // Front left leg
    translate([6, -8, 0])
        cylinder(h=10, d=5);
    
    // Front right leg
    translate([6, 8, 0])
        cylinder(h=10, d=5);
    
    // Back left leg (sitting)
    translate([-8, -9, 0])
        cylinder(h=8, d=5.5);
    
    // Back right leg (sitting)
    translate([-8, 9, 0])
        cylinder(h=8, d=5.5);
    
    // Head and snout with hull
    hull() {
        // Head
        translate([16, 0, 26])
            sphere(d=13);
        
        // Snout
        translate([23, 0, 25])
            sphere(d=7);
    }
    
    // Left ear
    hull() {
        translate([16, -6, 30])
            sphere(d=4);
        translate([16, -7, 22])
            sphere(d=3);
    }
    
    // Right ear
    hull() {
        translate([16, 6, 30])
            sphere(d=4);
        translate([16, 7, 22])
            sphere(d=3);
    }
    
    // Tail
    hull() {
        translate([-12, 0, 20])
            sphere(d=3);
        translate([-16, 0, 24])
            sphere(d=1.5);
    }
}

dog_complete();
