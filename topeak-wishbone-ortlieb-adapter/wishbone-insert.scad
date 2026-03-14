// =========================
// Parametric Settings
// =========================
length = 27;        // overall length
width  = 5;        // cuboid width
height = 12.8;        // cuboid height
fillet = 10;         // edge fillet radius
$fn = 100;            // smoothness

// Cylinder radius follows cuboid height
cyl_radius = height/2;
slot_thickness = 3;
bar_width = 60;
bar_d = 27;
bar_thickness = 5;

// Base plate
plate_w      = bar_d;
plate_d      = bar_width;
plate_thick  = bar_thickness;

// Computed centering offsets for the red plate
plate_x_offset = length/2 - (bar_width - width)/2;
plate_y_offset = width/2  - (length - bar_d)/2;


// Mounting holes (M3)
hole_d       = 3.3;
hole_spacing = 29;      // match receiver flange spacing
nut_d        = 6.2;     // M3 hex nut circle diameter
nut_h        = 2.6;

// =========================
// Half Cylinder Module
// =========================
module half_cylinder(len, r){
    intersection(){
        cylinder(h=len, r=r, $fn=$fn);
        translate([-r,0,0])
            cube([2*r,r,len]);
    }
}
// =========================
// Core Shape (before fillets)
// =========================
module base_shape(){

    union(){
        // main cuboid
        cube([length, width, height]);
        // first half-cylinder
        translate([length,0,height/2])
            rotate([180,90,0])
            half_cylinder(length, cyl_radius);
        // opposite half-cylinder
        translate([0,width,height/2])
            rotate([180,90,180])
            half_cylinder(length, cyl_radius);
        // slot
        translate([0,0,-slot_thickness])
            cube([length, width, slot_thickness]);

        // bottom bar 
        translate([(((bar_width - width)) / 2) + plate_x_offset,
                   ((length - bar_d) / 2)       + plate_y_offset,
                   -(slot_thickness+bar_thickness)])
            difference() {
            color("red") hull() {
                for (sx = [-1,1], sy = [-1,1])
                    translate([sx*(plate_w/2-1), sy*(plate_d/2-1), 0])
                        cylinder(r=1, h=plate_thick);
            }
        // ── M3 bolt holes through plate ─────────────────────
        for (sx = [-1,1])
            translate([0, sx * hole_spacing/2, -1])
                cylinder(d=hole_d, h=plate_thick + 2);

        // ── Hex nut traps (from bottom) ──────────────────────
        for (sx = [-1,1])
            translate([0, sx * hole_spacing/2,2])
                cylinder(d=nut_d/cos(30), h=nut_h + 1, $fn=6);
    }

    }
}
base_shape();