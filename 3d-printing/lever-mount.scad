include <gears.scad>

bearing_diam = 22;
axle_diam = 10;
bearing_thickness = 7.1;
housing_offset = 10;
pot_length = 40;
housing_width = bearing_diam + 2 * housing_offset;
housing_length = housing_width + pot_length;
housing_thickness = bearing_thickness * 2 + 10;

mount_hole_diam = 4;
nut_thickness = 3.4;
nut_diam = 8;
nut_inset = 5;
mount_hole_depth=15;
mounting_inset=7;

layer_height = 0.2;

nothing = 0.01;

$fa=1;
$fs=0.5;

module mounting_hole() {
    union() {
      linear_extrude(height=5) {
        circle(d=mount_hole_diam);
      }
      
      translate([0,0,nut_inset]) {
        linear_extrude(height=nut_thickness) {
          circle(d=nut_diam, $fn=6);
        
        }
      }
      
      translate([0,0,nut_inset + nut_thickness + layer_height]) {
        linear_extrude(height=mount_hole_depth - nut_inset - nut_thickness) {
          circle(d=mount_hole_diam);
        }
      }
    }
}

module bearing_block() {
    hw2 = housing_width/2;
    difference() {
    linear_extrude(height=housing_thickness) {
      difference() {
        square([housing_length,housing_width]);
        translate([hw2,hw2]) {
          circle(d=axle_diam);
        }
        translate([hw2+lever_gear_radius + pot_gear_radius,hw2]) {
          circle(d=axle_diam);
        }
      }
    }
    translate([hw2,hw2,housing_thickness-bearing_thickness+nothing]) {
      linear_extrude(height=bearing_thickness) {
        circle(d=bearing_diam);
      }
    }
    translate([hw2,hw2,0-nothing]) {
      linear_extrude(height=bearing_thickness) {
        circle(d=pot_thread_diameter);
      }
    }
        
  translate([hw2 + lever_gear_radius + pot_gear_radius, hw2, housing_thickness-5])
  pot_opening();
  }
}

leg_width = 14;
leg_height = 10;

 module bearing_block_leg(cable_hole=false) {
   difference() {
     translate([0,housing_width,0]){
        rotate(90, [1,0,0]) {
          linear_extrude(housing_width) {
          union() {
        square([leg_width, leg_height + housing_thickness-leg_width]);
        translate([0,leg_height + housing_thickness-leg_width,0]) {
            intersection() {
             circle(leg_width);
             square(leg_width);
          }
        } 
      }
    }
    }
    }
    translate([leg_width/2,housing_width/2,-nothing]) {
       mounting_hole();
    }
    if (cable_hole) {
      translate([0,housing_width/4,6])
      rotate([0,90,0])
      cylinder(h=leg_width+2*nothing,d=4);
    }
  }

}

module bearing_mount() {
  
  translate([0,0,leg_height])
  bearing_block();
 
  translate([housing_length,0,0])
  bearing_block_leg(true);
 
  translate([0,housing_width,0])
  rotate(180, [0,0,1])
  bearing_block_leg();

}


module pot_opening() {
  body_diam = 27;
  depth = 100;
  mount_spike_len = 3.5;
  cylinder(h=7, d=pot_thread_diameter);
  linear_extrude(2.5)
  translate([-mount_spike_len/2,-12.5])
  square([mount_spike_len,2]);
  translate([0,0,-depth]) {
    cylinder(h=depth,d=body_diam);
    linear_extrude(depth)
    translate([0,-body_diam/2,0])
    square([23,body_diam]);
  }
}

//mounting_hole();
// bearing_block();
// pot_opening();
// bearing_block_leg();

 bearing_mount();


