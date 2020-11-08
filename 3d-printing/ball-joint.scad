//Nimrod - A Rod End Creator
//Credit to Ryan Witschger


//Rod thread size?
Rod_Thread = 5.90; // [.05:.05:20]

 

//Screw thread size (Ball Side)?
Screw_Thread = 4; //   [.05:.05:20]

 

//Total engadement on the rod in mm
Engagement = 25; // [4:55]

 
//Desired Wall Thickness in mm?
Wall_Width = 2; //[0.5:0.05:6]
 

//Desired Gap / Tolerance (Printer Capability)?
Tolerance = 0.1; //  [0.05:0.05:0.4]

 
//Make the connection stronger or more flexible?
Hold_Multiplier = 1.0; // [0.4:0.1:1.7]

Resolution = 72; //[45:"Course", 60:"Low", 72:"Medium", 90:"High"]

Screw_Center = Engagement + (Rod_Thread / 2) +Tolerance + Screw_Thread + (Wall_Width * 2);



 

//Make the rod holder

difference(){

cylinder(h = (Engagement), d = (Rod_Thread + (Wall_Width * 2)), center = false, $fn=Resolution);


cylinder(h = (Engagement*2), d = (Rod_Thread), center = true, $fn=Resolution);

}

 

 

//Add a sphere to connect

translate([0,0,Engagement]) sphere(d = (Rod_Thread + (Wall_Width*2)), $fn=Resolution);

 

//Make the ball holder


difference() {
    translate([0,0,Screw_Center]) rotate([0,90,0]) cylinder(h = (Screw_Thread + Wall_Width) * Hold_Multiplier, r = (Screw_Thread + (Wall_Width * 2) + Tolerance), center=true, $fn = Resolution);

    translate([0,0,Screw_Center]) rotate([0,90,0]) sphere(r = (Screw_Thread + Wall_Width + Tolerance), $fn = Resolution);
}


//Make the ball
difference() {

    union(){

        translate([0,0,Screw_Center]) rotate([0,90,0]) sphere(r = (Screw_Thread + Wall_Width), $fn = Resolution);

        translate([0,0,Screw_Center]) rotate([0,90,0]) cylinder (h = ((Screw_Thread * 2) + (Wall_Width * 2)), d = (Screw_Thread + Wall_Width), center = true, $fn=Resolution);

    }

    translate([0,0,Screw_Center]) rotate([0,90,0]) cylinder (h = (((Screw_Thread * 2) + 1) + (Wall_Width * 2)), d = (Screw_Thread), center = true, $fn=Resolution);

}

 

 

 