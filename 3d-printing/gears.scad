use <MCAD/involute_gears.scad>

cp = 220;
teeth1 = 45;
teeth2 = 15;
bore_diameter = 4.1;
pot_thread_diameter = 9.5;

$fa=1;
$fs=0.5;

module mygear(teeth) {
    gear (
            number_of_teeth = teeth,
            circular_pitch=cp,
            gear_thickness = 6,
            rim_thickness = 6,
            rim_width = 5,
            hub_thickness = 8,
            hub_diameter=10,
            bore_diameter=bore_diameter
    );
}

function mygear_radius(teeth) = cp / 360 * teeth;

module lever_gear() {
  mygear (teeth1);
}

lever_gear_radius = mygear_radius(teeth1);

module pot_gear() {
  difference() {
    mygear (teeth2);
    pot_shaft();
  }
}

pot_gear_radius = mygear_radius(teeth2);

module pot_shaft() {
  linear_extrude(100) {
    difference() {
    circle(d=6.5);
    translate([-10,5.5-6.5/2])
    square([20,20]);
    }
  }
}

module test_mount() {
  width = 25;
  extra_length = 20;
  
  linear_extrude(4) {
    difference() {
      translate([-(lever_gear_radius + extra_length), 0])
      square([lever_gear_radius + pot_gear_radius + extra_length * 2,width]);
      translate([-lever_gear_radius,width/2]) {
        circle(d=bore_diameter);
      }
      translate([pot_gear_radius,width/2]) {
        circle(d=pot_thread_diameter);
      }
    }
  }
}

module test_gears ()
{
  echo("pradius", lever_gear_radius, pradius2);

  translate ([-lever_gear_radius-10,0,0])
  lever_gear();

  translate ([pot_gear_radius+10,0,0])
  pot_gear();

  translate([0,40])
  test_mount();
}

// test_gears();


