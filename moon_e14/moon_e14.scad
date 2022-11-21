d_moon=150;

d_base=67;
d_inner_base=46;
h_base=9;
h_base_rim=1;
d_base_rim=64;

module pipe(d_outer, thickness, height) {
    difference() {
        cylinder(h=height, d=d_outer, $fn=100);
        translate([0,0,-1]) cylinder(h=height+2, d=d_outer-thickness,$fn=100);
    }
}

module obj() {

    translate([0,0,h_base - h_base_rim]) cylinder(d=d_base_rim, h=h_base_rim);

    difference() {
      translate([0,0,d_moon/2]) sphere(d=d_moon,$fn=100);
      translate([0,0,h_base - h_base_rim]) cylinder(h=d_moon-h_base+10, d=d_moon+10);
    }

    difference() {
        translate([0, 0, h_base-4]) pipe(28+5, 5, 41+4);
        translate([6, -16, h_base-5]) cube([12,32,47]);
    }

}

d_holder_outer=28+6;
d_holder_inner=d_holder_outer+5;
h_holder_slot=1.5;

module holder() {
    //pipe(28+5+10, 10, 5);
    //translate([0,0,5]) pipe(28+5+5+5, 5, h_holder_slot);
    //translate([0,0,5+h_holder_slot]) pipe(28+5+10, 10, 3);
    pipe(d_holder_outer+4, 9, 5);
    translate([0,0,5]) pipe(d_holder_inner-1, 2, h_holder_slot);
    translate([0,0,5+h_holder_slot]) pipe(d_holder_outer+4, 9, 3);
}

module hole() {
    cylinder(d=4, h=4, $fn=100);
    cylinder(d=2.15, h=30, $fn=100);
}

module holes() {
    base_rot=45;

    rotate(-base_rot) translate([0,(d_base_rim/2) - 3.2,3]) hole();
    rotate(-base_rot-90) translate([0,(d_base_rim/2) - 3.2,3]) hole();
}

support_rim=0.8;

difference() {
    difference () {
        union() {
            obj();
            translate([0,0,h_base-h_base_rim-support_rim]) pipe(d_outer=68, thickness=4, height=support_rim);
            translate([0,0,45]) holder();
        }
        cylinder(d=17.5, h=h_base+1);
        holes();
        
    }

    translate([-80,-40,-1]) cube([80,80,80]);
}
