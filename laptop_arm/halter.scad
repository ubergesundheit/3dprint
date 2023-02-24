dicke = 10;
angle = 17;

base_inner = 30.4;
base_outer= 38.5;

kreuz_width = 200;
kreuz_depth = 25;

arm_len = 200;
arm_width = 20;

angle_gw = 65; // do not change or you'll need to re-print the bottom

module hole() {
    translate([0,0,-1]) cylinder(h=31+2, d=base_inner, $fn=100);
}


module base() {
    difference() {
        cylinder(h=31, d=base_outer);
        hole();
    }
    cylinder(h=31, d=22, $fn=100);

}

module top() {
    color([1,0,0]) translate([0,0,31]) {
        difference() {
            cylinder(h=23, d=base_outer);
            rotate([angle, 0, 0]) translate([0,1,37.4]) cube([50,50,50], center=true);
        }
    }
}


module dish2() {
    base();
    z=34;
    difference () {
        union() {
            top();
            // roehren
            translate([0,0,z]) rotate([angle,0,0]) {
                gewindestangen_oben_platte();
                mirror(v=[1,0,0]) gewindestangen_oben_platte();
            }
        }
        translate([0,0,z]) rotate([angle,0,0]) {
            gewindestangen_oben_platte_loecher();
            mirror(v=[1,0,0]) gewindestangen_oben_platte_loecher();
        }
    }
}


module dish() {
    difference() {
        union() {
            difference() {
                translate([0,0,14]) rotate([angle,0,0]) {
                    //troete
                    cylinder(20, 19.3, 40, $fn=100);
                    translate([0,0,20]) {
                        // platte oben
                        cylinder(dicke, 40, 40, $fn=100);

                        //color([1,0,0]) arm_bottom();
                        //color([0,1,0]) mirror(v=[1,0,0]) arm_bottom();
                        

                        gewindestangen_oben_platte();
                        mirror(v=[1,0,0]) gewindestangen_oben_platte();
                    } 
                }
                hole();
            }
            base();
        }
        gw_loecher_fuer_dish();
}
}

module gw_loecher_fuer_dish() {
    translate([0,0,14]) rotate([angle,0,0]) {
        translate([0,0,20]) {    
            color([0,0,1]) arm_gwstange(d=5);
            mirror(v=[1,0,0]) arm_gwstange(d=5); 
        }
    }
}

module gewindestangen_oben_platte() {
    //difference() {
        translate([16,0,5]) rotate([angle_gw, 90, 0]) {
            translate([0,0,-27]) ;
        }
    // gewindestangen_oben_platte_loecher();
    //}
}

module gewindestangen_oben_platte_loecher() {
    translate([16,0,5]) rotate([angle_gw, 90, 0]) {
        translate([0,0,-30]) cylinder(h=45, d=5, $fn=20);
    }
}

module gewindestange(length=250, d=5) {
     rotate([angle_gw, 90,0]) translate([0,0,-50]) cylinder(h=length, d=d, $fn=100);
}


module arm_gwstange(length=250, d=5) {
   translate([16,0,5]) gewindestange(length=length, d=d);
}

module arm_bottom() {
    len=50;
    difference() {
        translate([87,-200,0]) {
            difference() {
                difference() {
                    cube([45, len, dicke]);
                    // loch 1 gewindestange von oben
                    rotate([0,0,-angle_gw]) translate([-20,25,-1]) cube([5, 10, dicke+2]);
                }
                // loch 2 gewindestange von oben
                rotate([0,0,-angle_gw]) translate([-8,25,-1]) cube([5, 10, dicke+2]);
            }
            difference() {
                translate([0,-7,0]) cube([45,7,dicke+12]);
                // gewindestange rechts-links loch
                rotate([0,0,angle_gw]) translate([0,-8,4]) gewindestange(100);
            }
        }
        arm_gwstange(length=260);
    }
}

//rotate([0,0,30]) cube([20, 200, 10],center=true);


dish2();

//gewindestange();


//!kreuz();

//!rotate([angle,0,0]) arm2();
//mirror(v=[1,0,0]) arm2();




module kreuz() {
    kreuz_dim_x=35;
    kreuz_dim_y=60;
    translate([0,-kreuz_depth/2,0]) {
        translate([-kreuz_width/2,0,0]) cube([kreuz_width,kreuz_depth,dicke]);
        translate([-kreuz_dim_x/2,-(kreuz_dim_y-kreuz_depth)/2,0]) cube([kreuz_dim_x,kreuz_dim_y, dicke]);
    }
}


module arm() {
    rotate([0,0,20]) {
        difference() {
            cube([arm_width, arm_len, dicke]);
            rotate([0,0,-20]) group() {
                translate([-4.18,0,-1]) cube([23,7.1,12]);
            }
        }
        rotate([0,0,-20]) translate([-((arm_width*2))-4.18,7,0]) cube([arm_width*3, 6, dicke+15]);
    }
}

module arm2() {
    translate([-90,-160,0]) {
    linear_extrude(dicke) import("./arm.svg");
    cube([arm_width*3, 8, dicke+15]);
    }
}


module arm_holder() {
    h_len=150;
    
    translate([-30,20,0]) rotate([0,0,-45]) cube([h_len, 20, dicke]);
    mirror(v=[1,0,0]) translate([-30,20,0]) rotate([0,0,-45]) cube([h_len, 20, dicke]);
    
}