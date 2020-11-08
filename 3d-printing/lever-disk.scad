use <gears.scad>;

arm_length = 120;
arm_width = 60;
disk_thickness = 6;
spacer_diam = 16;
spacer_thickness = 8;
centre_hole_diam = 8;
screw_diam = 4;
nut_diam = 8.2;
nut_inset = 3;
nothing = 0.01;

$fa=1;
$fs=0.5;

module lever_hole() {
    union() {
      translate([0,0,-nothing]) {
        linear_extrude(height=nut_inset) {
          circle(d=nut_diam, $fn=6);
        }
      }
      linear_extrude(height=disk_thickness+nothing*2) {
         circle(d=screw_diam);
      }
    }
}

module disk() {
  difference() {
    union() {
      linear_extrude(disk_thickness) {
        scale([1,arm_width/arm_length,1]) {
          circle(d=arm_length);
        }
      }
      translate([0,0,-spacer_thickness]) {
        linear_extrude(spacer_thickness) {
          circle(d=spacer_diam);
        }
      }
      rotate([180,0,0])
      lever_gear();
    }
    translate([0,0,-spacer_thickness-nothing]) {
    linear_extrude(disk_thickness+spacer_thickness+2*nothing) {
      circle(d=centre_hole_diam);
    }
    }
    translate([-50,0,0]) {
      lever_hole();
    }
    translate([-40,0,0]) {
      lever_hole();
    }
    translate([50,0,0]) {
      lever_hole();
    }
    translate([40,0,0]) {
      lever_hole();
    }
  }
};


disk();