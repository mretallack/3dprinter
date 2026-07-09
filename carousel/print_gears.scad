use <carousel.scad>
// Spur gear and crown gear side by side
spur_gear();
// Crown gear: shift up so disc base is at Z=0 (nub sticks up, teeth on top)
translate([25, 0, crown_nub_h])
    crown_gear();
