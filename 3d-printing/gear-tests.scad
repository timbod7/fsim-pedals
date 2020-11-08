use <MCAD/involute_gears.scad>

cp = 200;
teeth1 = 46;
teeth2 = 15;
pradius1 = mygear_radius(teeth1, cp);
pradius2 = mygear_radius(teeth2, cp);
bore_diameter = 4.1;
pot_thread_diameter = 9.5;

$fa=1;
$fs=0.5;

module mygear(teeth) {
    gear (
            number_of_teeth = teeth,
            circular_pitch=cp,
            gear_thickness = 6,
            rim_thickness = 8,
            rim_width = 5,
            hub_thickness = 10,
            hub_diameter=10,
            bore_diameter=bore_diameter
    );
}

function mygear_radius(teeth, cp) = cp / 360 * teeth;



module gears ()
{
      echo("pradius", pradius1, pradius2);

      translate ([-pradius1-10,0,0])
      rotate ([0,0,360/teeth1/4])
      mygear (teeth1);

      translate ([pradius2+10,0,0])
      rotate ([0,0,360/teeth2/4])
      difference() {
        mygear (teeth2);
        pot_shaft();
      }
       
}

module mount() {
  width = 25;
  extra_length = 20;

  linear_extrude(4) {
    difference() {
      translate([-(pradius1 + extra_length), 0])
      square([pradius1 + pradius2 + extra_length * 2,width]);
      translate([-pradius1,width/2]) {
        circle(d=bore_diameter);
      }
      translate([pradius2,width/2]) {
        circle(d=pot_thread_diameter);
      }
    }
  }
}

module pot_shaft() {
  linear_extrude(100) {
  difference() {
  circle(d=6.5);
  translate([-10,5.5-6.5/2])
  square([20,20]);
  }
}
}

gears();
translate([0,40])
mount();

