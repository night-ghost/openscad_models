include <3D-PCB/3D-PCB.scad>;

/*
    frame for small quadcopter

*/


r=100;
incr = 10;

open = 90;
roll = open + 0;
yaw = open + 0;
pitch = open + 0;


center_dist = 60;

circuitboard_width = 26;
circuitboard_height = 23;

//* // 0703 motor
motor_diam = 10;
motor_height = 10;
blade_diam = 56.4;
motor_hole_diam = 2.5;
motor_bolt_diam=2;
motor_mount_diam = 6.5;
motor_bolt_num=3;
//*/

/*// 1103 motor
motor_diam = 14;
motor_height = 10;
blade_diam = 25.4 * 3;
motor_hole_diam = 3;
motor_bolt_diam=2;
motor_mount_diam = 9;
motor_bolt_num=4;
//*/

mount_size = 16;

thick=1.2;

prot_hole_dia=2;


ray_length = blade_diam/2 + 3;

module rod(){
    t=thick/2;
    d2 = motor_height/2+2*thick;
    d1 = circuitboard_width/2;
    x = d2 * (1-1/(2*t))+1;
    echo ("x=",x);
    translate([0,0,(circuitboard_width/2+thick)/2]) rotate([90,0,0]) {
        difference(){
            scale([1,0.5,1]) cylinder(h=ray_length, r2=d2,r1= d1+thick); 
 /*
  d2/2 - (d2-t)*x = t
  d2/2 - d2*t + x*t -t =0
  d2/2 - d2*t -t = - x*t
  x = (d2*t - d2/2 + t)/t
  x = d2* (1 - 1/(2*t)) + 1
            
 */           
            scale([1,1/x,1]) cylinder(h=ray_length+ thick, r2=d2-t,r1= d1);
        }
    }
}


module ray(){
    // propeller
    %color("cyan") translate([0,-ray_length-thick,(motor_diam)/4+motor_height+2]) cylinder(r= blade_diam/2, h=1);
    
    th = thick/1.5;
    R = motor_diam/2+2*thick;
    
    difference(){
        union(){
            difference(){
                rod();
                translate([0,-ray_length-thick,0]) cylinder(r=R-th, h=100);
            }
            // motor mount
            translate([0,-ray_length-thick,(motor_height)/4]) {
                difference(){
                    cylinder(r=R, h=th);
                    cylinder(r=motor_hole_diam/2,h=th,$fn=60);
                    step = 360/motor_bolt_num;
                    rotate([0,0,motor_bolt_num==3?0:45])
                        for(i=[0:step:359]){                    
                            rotate([0,0,i]) translate([0,-motor_mount_diam/2,0]) cylinder(r=motor_bolt_diam/2,h=th,$fn=60);
                        
                    }
                }
                translate([0,0,th]) difference(){
                    cylinder(r=R, h=motor_height-th);
                    cylinder(r=R-th, h=motor_height-th);
                }
            }
        }
        // hole for wires
        translate([0,-ray_length/2-3*thick,(motor_height)/2 + 2*th+0.1+th/2]) rotate([90,0,0]) cylinder(r=(motor_height-2*thick)/2, h=ray_length/2);
        
        // hole for protection
        angle=atan((blade_diam/2)/motor_height);
        
        shf = motor_diam / 2;
        rot = 360 / 3;
        translate([0,-ray_length,th]) {
            for(i=[-60,0,60]) {
                rotate([0,0,i]) 
                    translate([0,-shf,(motor_height)/4]) rotate([angle,0,0]) cylinder(r=prot_hole_dia/2, h=20,$fn=20);
            }
        }
        
    }
    
    //prot_one();
}

//ray();

module prot_one(){
    
    sz = circuitboard_width+thick;
    gap=4;
    w=2;
    vert = 4;
    th = 2;
    
    angle=atan((blade_diam/2)/motor_height);
    
    shf = motor_diam / 2;
    dp = prot_hole_dia;
    
    hi = (motor_diam)/4+motor_height+vert;
    
    rot = 360/3;
    union(){
        translate([0,-(ray_length+thick),0]) {        
            for(i=[-60,60]){
                rotate([0,0,i]){
                    translate([0,-shf,(motor_diam)/4]) rotate([angle,0,0]) cylinder(r=dp/2, h=blade_diam / sin(angle)/2+w/2*1.5);
    
                    translate([0,-(blade_diam/2+gap+w/2),(motor_diam)/4+motor_height]) cylinder(r=dp,h=vert);
                }
            }
        }
    
        translate([0,-ray_length-thick,hi]) {
            difference(){
                cylinder(r=blade_diam/2+gap + w,h=th);
                cylinder(r=blade_diam/2+gap    ,h=th*1.1);
            }
        }
    
        translate([blade_diam/2+3.5,8-(ray_length+thick), hi]) rotate([0,0,45]) cube([10, w,th]);
    }
}   


module protect(){
    sz = circuitboard_width+thick;
    hi=(motor_diam)/4+motor_height+4;
    sz2 = circuitboard_width+blade_diam+13;
    
    difference(){
        union(){
            rotate([0,0,0]) translate([0,-(sz+thick)/2,0])  prot_one();
            rotate([0,0,90]) translate([0,-(sz+thick)/2,0])  prot_one();
            rotate([0,0,180]) translate([0,-(sz+thick)/2,0])  prot_one();
            rotate([0,0,270]) translate([0,-(sz+thick)/2,0])  prot_one();
        }
        
        
        translate([0,0,hi/2]) rotate([0,0,45]) cube([sz2,sz2,hi*2], center=true);
    }
}


module body(){
        sz = circuitboard_width+thick;
        h = (circuitboard_width/2+thick);
        difference(){
            translate([-(sz+thick)/2,-(sz+thick)/2,0])cube([(sz+thick),(sz+thick), thick]);
            // holes for wires
            translate([mount_size/2,mount_size/2,0]) cylinder(r=1,h=thick);
            translate([mount_size/2,-mount_size/2,0]) cylinder(r=1,h=thick);
            translate([-mount_size/2,mount_size/2,0]) cylinder(r=1,h=thick);
            translate([-mount_size/2,-mount_size/2,0]) cylinder(r=1,h=thick);
        }
        difference(){
            translate([-(sz+thick)/2,-(sz+thick)/2,thick])cube([sz+thick,sz+thick, h-thick]);
            // holes for mount
            translate([-sz/2,-sz/2,thick])cube([sz,sz, h-thick]);
            for(i=[0:90:359]){
                rotate([0,0,i]) translate([0,-sz/2,h/2]) rotate([90,0,0]) scale([1,0.5,1])cylinder(h=thick*2, r=h/2);
            
            }
         }
 }
 
 module enf(height,min_wall_thickness){
    translate([0,0,height*2])rotate([270,90,0]) difference(){
        cube([height*2,height*2,min_wall_thickness]);
        translate([-(height),0,0]) cylinder(r=2*height, h=min_wall_thickness);
    }    
 }

contact_width = 6.5; // 
contact_pin = 3; 
height = 10;

 
 module contact_holder(){
    translate([0,-contact_width,0]) cube([1,1,height]);
    translate([0,contact_width,0]) cube([1,1,height]);
     
    translate([1,-contact_width,0]) cube([1,3,height]);
    translate([1,contact_width-2,0]) cube([1,3,height]);
}
 
 module battery_holder(length, width) {
	offset=-4; // this moves the battery springs tighter or looser; the more negative the tighter to hold the batteries
    error_tolerance = 1.05; // fit for batteries
    min_wall_thickness = 1.5; // mm buffer on each side

    sides = 7;

    l=length - offset * 2;
     
    
	difference() {
		translate([0,0,height/2]) cube([l, width + min_wall_thickness*2, height], center=true);
		scale(error_tolerance*[1.5,1,1]) translate([0,0,height]) generic_battery(length, width);
        //contact holes
        translate([(l/2-1),0,0]) cube([1, contact_pin, height], center=true);
        translate([-(l/2-1),0,0]) cube([1, contact_pin, height], center=true);
        // hole in middle
        translate([0,0,height/2]) cube([length-2*sides,width,height], center=true);
	}
    
    translate([-(l/2),0,0]) contact_holder();
    translate([(l/2),0,0]) rotate([0,0,180])contact_holder();
    
    translate([l/2+min_wall_thickness/2,0,height]) cube([min_wall_thickness, width + min_wall_thickness*2, height*2], center=true);
    translate([-l/2-min_wall_thickness/2,0,height]) cube([min_wall_thickness, width + min_wall_thickness*2, height*2], center=true);
    
    // enforcing
    translate([-(l/2-height*2)-min_wall_thickness,(width + min_wall_thickness*2)/2-min_wall_thickness,0]) enf(height,min_wall_thickness);
    
    mirror([1,0,0]) translate([-(l/2-height*2)-min_wall_thickness,(width + min_wall_thickness*2)/2-min_wall_thickness,0]) enf(height,min_wall_thickness);

    mirror([0,1,0]) translate([-(l/2-height*2)-min_wall_thickness,(width + min_wall_thickness*2)/2-min_wall_thickness,0]) enf(height,min_wall_thickness);
    
    mirror([0,1,0])
    mirror([1,0,0]) translate([-(l/2-height*2)-min_wall_thickness,(width + min_wall_thickness*2)/2-min_wall_thickness,0]) enf(height,min_wall_thickness);
}

module copter(){
 
    sz = circuitboard_width+thick;
    h = (circuitboard_width/2+thick) / 2;
 
    body();
    rotate([0,0,0]) translate([0,-(sz+thick)/2,0]) ray();
    rotate([0,0,90]) translate([0,-(sz+thick)/2,0]) ray();
    rotate([0,0,180]) translate([0,-(sz+thick)/2,0]) ray();
    rotate([0,0,270]) translate([0,-(sz+thick)/2,0]) ray();
    
    
}

//translate([0,0,thick]) mirror([0,0,1]) battery_holder(65,18);


copter();
//rotate([180,0,0]) protect();
