bearing_diam = 22;
axle_diam = 10;
bearing_thickness = 7.1;
housing_offset = 10;
housing_width = bearing_diam + 2 * housing_offset;
housing_thickness = bearing_thickness * 2 + 10;

mount_hole_diam = 4;
nut_thickness = 3.4;
nut_diam = 8;
nut_inset = 5;
mount_hole_depth=15;
mounting_inset=7;

layer_height = 0.2;

$fa=1;
$fs=0.5;

module mounting() {
  rotate(-90, [1,0,0]) {
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
}


module main() {
  difference() {
    linear_extrude(height=housing_thickness) {
      difference() {
        union() {
          circle(d=housing_width);
          polygon([
            [-housing_width/2, 0],
            [+housing_width/2, 0],
            [+housing_width/2, -bearing_diam/2 - housing_offset],
            [-housing_width/2, -bearing_diam/2 - housing_offset]
          ]);
        };
        circle(d=axle_diam);
      }
    }
    linear_extrude(height=bearing_thickness) {
      circle(d=bearing_diam);
    }
    translate([0,0,housing_thickness-bearing_thickness]) {
      linear_extrude(height=bearing_thickness) {
        circle(d=bearing_diam);
      }
    }
    translate([housing_width/2-mounting_inset, -bearing_diam/2-housing_offset, housing_thickness/2]) {
      mounting();
    }
    translate([-housing_width/2+mounting_inset, -bearing_diam/2-housing_offset, housing_thickness/2]) {
      mounting();
    }

  }

}

main();



