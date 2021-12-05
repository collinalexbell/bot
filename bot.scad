//-------------------------------------------
//
// macros
//
//-------------------------------------------

$fn=60;






//-------------------------------------------
//
// dims (in cm)
//
//-------------------------------------------

// stepper
stepper_height = 4.8;
stepper_width = 4.2;
//     holes
hole_depth = 4.3;
hole_d = .43;
from_edge = (.42-.31)/2 + hole_d/2;
//     spindle
cylinder_h = 1;


//chasis
//     cabin
space_between_steppers = 1;
s = space_between_steppers;
cabin_x = stepper_height+ s +stepper_height;
cabin_y = stepper_width + 5;
cabin_z = stepper_height;

//     hull
hull_thickness = 0.1;
hull_x=cabin_x+hull_thickness*2;
hull_y=cabin_y+hull_thickness*2;
hull_z=cabin_z+hull_thickness;


//assembly
//     steppers
stepper_distance = cabin_x;


// axle_eye
spindle_d = .45;
axle_eye_d = spindle_d + 0.1;


//translations
daxle = [0,-cabin_y/2 + stepper_width/2 + 0.08,0];



//-------------------------------------------
//
// geometry 
//
//-------------------------------------------

module Hole() {
      h = hole_depth/2;
      cylinder(d=hole_d, h=h, center=true);
}

module FourHoles() {
    dxy = stepper_width/2 - from_edge;
    dz = stepper_height/2;
    h = hole_depth * 2;
    translate([dxy, dxy, dz])  Hole();
    translate([-dxy, dxy, dz]) Hole();
    translate([dxy, -dxy, dz]) Hole();
    translate([-dxy, -dxy, dz])Hole();
}

module Stepper() {
  difference() {
    union(){
      cube([stepper_width,stepper_width,stepper_height], center=true);


      // Stepper Spindle
      dz = stepper_height/2 + cylinder_h/2;
      translate([0,0,dz]){
        cylinder(d=spindle_d, center=true);
      }
    }
    FourHoles();
  }
}

module Hull() {
  cube([hull_x, hull_y, hull_z], center=true);
}

module Cabin() {
  translate([0,0, hull_thickness/2+0.1]) cube([cabin_x,cabin_y,cabin_z+0.1], center=true);
}

module AxleEye() {
  translate(daxle) {
    rotate([0,90,0]) {
      cylinder(h=100, d=axle_eye_d, center=true);
    }
  }
}

module Chasis() {
  color([83/255.0,86/255.0,90/255.0]) {
    difference() {
      Hull();
      Cabin();
      AxleEye();
    }
  }
}


module Steppers(){
  union() {
    dx = stepper_distance/2 - stepper_height/2;
    translate([-dx,0,0]){
      rotate([0,-90,0]){
        Stepper();
      }
    }
    translate([dx,0,0]){
      rotate([0,90,0]){
        Stepper();
      }
    }
  }
}

module BotWithoutComponents(){
  difference() {
    Chasis();
    translate(daxle) {
      {
        translate([hull_x/2-stepper_height/2,0,0]) {
          rotate([0,90,0]) FourHoles();
        }
        translate([-hull_x/2-stepper_height/2,0,0]){
          rotate([0,90,0]) FourHoles();
        }
      }
    }
  }
}

module BotWithComponents(){
  BotWithoutComponents();
  translate(daxle) {
    Steppers();
  }
}

BotWithoutComponents();
//BotWithComponents();
