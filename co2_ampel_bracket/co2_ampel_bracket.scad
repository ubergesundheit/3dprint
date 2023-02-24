cylinder_inner=34.9;
height=7;
claw_inner=50;
thickness=3;

knob_width=3.85;
knob_protusion=1.8;

module ring() {
    difference() {
        // ring
        difference() {
            cylinder(h=height, d=cylinder_inner+thickness, $fn=100);
            translate([0,0,-1]) cylinder(h=height+2, d=cylinder_inner,$fn=100);
        }
        translate([(-cylinder_inner+4)/2, 0, -1]) cube([cylinder_inner-4,cylinder_inner-4,height+2]);
    }
}

module claw() {
    cube([claw_inner,thickness,height]);
    translate([claw_inner,-thickness,0]) cube([thickness,thickness+thickness, height]);
    translate([-thickness,-thickness,0]) cube([thickness,thickness+thickness, height]);
}

module knob() {
    cube([knob_width, knob_protusion, (height/3)]);
    translate([0,-knob_protusion,0]) cube([knob_width, 2, height]);
}

translate([0,17.9,0]) ring();
//translate([-5,0,0]) #cube([10,2,height]);

translate([-claw_inner/2,-thickness,0]) claw();

translate([(claw_inner/2) - 6 - (knob_width), -thickness-knob_protusion, 0]) knob();

translate([-((claw_inner/2) - 6 ), -thickness-knob_protusion, 0]) knob();

//translate([-25, -thickness-knob_protusion, 0]) cube([6,6,6]);
