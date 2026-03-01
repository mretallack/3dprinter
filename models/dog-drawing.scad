// 2D CAD Drawing - Dog Model
// Dimensions in mm

module dimensions() {
    // Front view dimensions
    translate([10, 150, 0]) {
        text("FRONT VIEW", size=5);
        translate([0, -10, 0]) text("Width: 40mm", size=3);
        translate([0, -15, 0]) text("Height: 60mm", size=3);
    }
    
    // Side view dimensions
    translate([110, 150, 0]) {
        text("SIDE VIEW", size=5);
        translate([0, -10, 0]) text("Length: 80mm", size=3);
        translate([0, -15, 0]) text("Height: 60mm", size=3);
    }
    
    // Top view dimensions
    translate([210, 150, 0]) {
        text("TOP VIEW", size=5);
        translate([0, -10, 0]) text("Length: 80mm", size=3);
        translate([0, -15, 0]) text("Width: 40mm", size=3);
    }
}

// Front view
module front_view() {
    translate([10, 10, 0]) {
        // Body outline
        square([30, 35], center=true);
        // Head
        translate([0, 20, 0]) circle(d=25);
        // Ears
        translate([-8, 32, 0]) polygon([[0,0], [-3,12], [3,12]]);
        translate([8, 32, 0]) polygon([[0,0], [-3,12], [3,12]]);
        // Legs (4 visible as 2 pairs)
        translate([-12, -30, 0]) square([8, 30]);
        translate([4, -30, 0]) square([8, 30]);
    }
}

// Side view
module side_view() {
    translate([110, 10, 0]) {
        // Body
        square([50, 35], center=true);
        // Head
        translate([30, 5, 0]) circle(d=25);
        // Tail
        translate([-30, 5, 0]) 
            polygon([[0,0], [-20,8], [-18,6]]);
        // Legs (2 visible)
        translate([-10, -30, 0]) square([8, 30]);
        translate([15, -30, 0]) square([8, 30]);
    }
}

// Top view
module top_view() {
    translate([210, 10, 0]) {
        // Body
        square([50, 30], center=true);
        // Head
        translate([30, 0, 0]) circle(d=25);
        // Tail
        translate([-30, 0, 0]) circle(d=6);
        // Legs (all 4 visible)
        translate([15, 12, 0]) circle(d=8);
        translate([15, -12, 0]) circle(d=8);
        translate([-15, 12, 0]) circle(d=8);
        translate([-15, -12, 0]) circle(d=8);
        // Ears
        translate([35, 8, 0]) circle(d=4);
        translate([35, -8, 0]) circle(d=4);
    }
}

// Assemble drawing
projection() {
    front_view();
    side_view();
    top_view();
    dimensions();
}
