base_inner = 30.4;
base_outer= 40;

base_plus = 5;

angle = 15;
angle_gw = 20; // do not change or you'll need to re-print the bottom

$fa = 1; // or 6
$fs = 0.25;

d_tube = 9;

module hole() {
    translate([0,0,-1]) cylinder(h=31+2, d=base_inner);
}


module base() {
    difference() {
        //cylinder(h=31, d=base_outer);
        linear_extrude(31,scale=[2,base_outer/(base_inner+base_plus)],twist=0,slices=20) square([base_inner+base_plus,base_inner+base_plus], center=true);
        hole();
    }
}
module top_translation() {
    translate([0,0,31]) children();
}

module top() {
    top_translation() {
        // löcher muttern
        difference(){
           // schräge
           difference() {
                color([1,0,0]) { 
                    //cylinder(h=23, d=base_outer);
                    translate([-(base_inner+base_plus),-base_outer/2,0]) cube([(base_inner+base_plus) * 2,base_outer,25]);
                }
                rotate([angle, 0, 0]) translate([0,5,39.4]) cube([90,50,50], center=true);
            }
            top_muttern();
        }
        color([0,1,0]) {
             top_tube_translations() tube(70);
        }
        color([0,0,1]) {
            top_to_bottom();
            mirror(v=[1,0,0]) top_to_bottom();
        }

        //top_tube_translations() gewindestange();
    }
}

module top_tube_translations() {
    rotate([0,90,0]) translate([-13, (base_outer/2)-6, 0]) {
        children();
    }
}

module top_to_bottom_translations() {
    translate([20,0,9.25])  rotate([90+angle,0,0]) rotate([0,angle_gw,0]) {
        children();
    }
}

module top_to_bottom() {
    top_to_bottom_translations() {
       translate([0,0,19.5]) tube(10);
    }
}

module tube(h=36) {
    translate([0,0,-h/2]) /*difference()*/ { 
        cylinder(h=h, d=d_tube);
        //translate([0,0,-1]) cylinder(h+2, d=5.05);
    }
}

module top_muttern() {
    w=8.63 + 0.4;
    
    top_to_bottom_translations() {
        translate([0,0,-8]) {
            //#translate([0, 3.3, thickness/2]) cube([4,8.4,12]);
            translate([-w/2,0,0]) cube([w,8,4]);
            m5_mutter();
        }
    }
    mirror(v=[1,0,0]) top_to_bottom_translations() {
        translate([0,0,-8]) {
            translate([-w/2,0,0]) cube([w,8,4]);
            m5_mutter();
        }
    }
}

module m5_mutter(h=4) {
    translate([-8.63/2,-4,0]) linear_extrude(h) offset(r=0.2) import("./m5.svg");
}

module gewindestange(length=250, d=5) {
     translate([0,0,-length/2]) cylinder(h=length, d=d, $fn=100);
}

module gewindestangen_top_to_bottom() {
    top_translation() top_to_bottom_translations() {
        translate([0,0,15]) #gewindestange(length=40);
    }
    mirror(v=[1,0,0]) top_translation() top_to_bottom_translations() {
        translate([0,0,15]) #gewindestange(length=40);
    }
}

module final_base_assembly() {
    // loehcer unten
    difference() {
        // loch oben
        difference() {
            top();
            top_translation() top_tube_translations() {
                gewindestange();
            }
        }
        gewindestangen_top_to_bottom();
    }
    base();
}

module corner() {
    thickness = 15;
    difference() {
        difference() {
            union() {
                difference() {
                    color([1,0,1]) translate([thickness,0,0]) cube([20,thickness,thickness]);
                    translate([thickness+16,0,0]) union() {
                        translate([0, thickness/2,thickness/2]) rotate([90,90,90]) m5_mutter(5);
                    }
                }
                difference() {
                    cube([thickness,20,thickness]);
                    translate([thickness/2,5,thickness/2]) rotate([90,0,0]) m5_mutter(6);
                    translate([thickness/2,21,thickness/2]) rotate([90,0,0]) #m5_mutter(6);
                }
            }
            translate([40,thickness/2,thickness/2]) rotate([0,90,0]) gewindestange(length=50);
        }
        translate([thickness/2,25,thickness/2]) rotate([0,90,90]) gewindestange(length=50);
    }
    translate([2.85,0,0]) linear_extrude(thickness) polygon(points=[[0,0],[-15,-15], [-15,-5], [0,10] ]);
    translate([-12.6,-9.9]) cylinder(h=thickness, r=5);
}

module bottom_holder_tube_translations() {
    rotate([angle_gw,90,0]) translate([-3.23,5,0]) children();
}

module bottom_from_top_translations() {
    translate([7,14,3.23]) rotate([90,0,90]) children();
}

module imported_holder() {
    /*translate([-120,-120,0])*/ import("./notebook_stand_T14.stl");
    bottom_holder_tube_translations() translate([0,0,20]) tube(45);
    bottom_across_translations() tube(31);
    color([1,0,0]) bottom_from_top_translations() tube(70);
}

module bottom_holder_mutter() {
    w=8.63 + 0.4;
    bottom_holder_tube_translations() translate([0,0,-3]) {
        translate([0,-4,0]) cube([w,8,4]);
        m5_mutter();
    }
}

module bottom_across_translations() {
    //translate([-18.1,0,2.4]) rotate([0,90,90]) children();
    translate([-32,0,23]) rotate([0,90,90]) children();
}

module bottom_holder() {
    difference() {
        difference() {
            difference() {
                imported_holder();
                bottom_holder_tube_translations() {
                        translate([0,0,23]) gewindestange(length=46);
                }
            }
            bottom_holder_mutter();
        }
        /*bottom_across_translations() {
            translate([0,0,11]) m5_mutter(5);
            translate([0,0,-16]) m5_mutter(5);
        }*/
        bottom_across_translations() gewindestange();
        bottom_from_top_translations() gewindestange();
        bottom_from_top_translations() translate([0,0,-32]) #tube(10);
    }
}

//corner();
//final_base_assembly();
mirror(v=[1,0,0]) bottom_holder();