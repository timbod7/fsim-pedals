thickness = 3;
inner_width = 25.1;
inner_height = 10.1;
sleeve_length = inner_width + 2 * thickness;

spacer_thickness = 2;
spacer_diam = 14;

hole_diam = 8;
hole_depth = spacer_thickness * 2 + thickness * 2 + inner_height;

nothing = 0.01;

$fa=1;
$fs=0.5;

module sleeve() {
  linear_extrude(sleeve_length) {
    difference() {
      square([inner_width + 2 * thickness, inner_height + 2 * thickness]);
      translate([thickness, thickness]) {
        square([inner_width, inner_height]);
      }
    }
  }
}

module spacer() {
  rotate(90,[1,0,0]) {
    cylinder(spacer_thickness, 
        d1 = spacer_diam +spacer_thickness, 
        d2 = spacer_diam
    );
  }
}

module main() {
  sleeve_centre = inner_width/2 +  thickness;

  difference() {
    union() {
      sleeve();
      translate([sleeve_centre,0,sleeve_centre]) {
        spacer();
      }
      translate([sleeve_centre,inner_height + 2 * thickness,sleeve_centre]) {
        scale([1,-1,1]) {
          spacer();
        }
      }
    }
    translate([sleeve_centre,-spacer_thickness-nothing,sleeve_centre]) {
      rotate(-90,[1,0,0]) {
        linear_extrude(hole_depth + 2 * nothing) {
          circle(d=hole_diam);
        }
      }
    }
  }
}

main();