diam=20;
top_diam = 25;
height=25;
top_height = 20;
top_sz = 2;

width = 64;
side_r = 64.5;
side_size = 99;

hole_w = 24.2;

bolt_d = 4;

sdh_w = 12;
sdh_h=8;

$fn = 50;

module hole(){
    cylinder(r=diam/2,h=height);
    translate([0,0,height-top_height-top_sz]) cylinder(r=top_diam/2,h=top_height);
}


//hole();

module body() {
    difference(){
        intersection(){
            translate([0,side_size/2,0]) cylinder(r=side_r,h=height);
            translate([0,-side_size/2,0]) cylinder(r=side_r,h=height);
            translate([0,0,height / 2]) cube([width,width,height],center=true);
        }
        translate([0,(side_r-side_size/2),height/2]) cube([sdh_w,sdh_h, height], center=true);
        translate([0,-(side_r-side_size/2),height/2]) cube([sdh_w,sdh_h, height], center=true);
    }   
}


module bolt_hole(head_y){
       
    translate([0,0,height/2]) rotate([90,0,0]) cylinder(r=bolt_d/2,h=side_size, center=true);
    
    translate([0,head_y,height/2]) rotate([-90,0,0]) cylinder(r=bolt_d/2*2,h=bolt_d*1.5);
    translate([0,-head_y,height/2]) rotate([90,0,0]) cylinder(r=bolt_d/2*2,h=bolt_d*3);
}

module main(){
//                  
    bolt_x = width/2 - bolt_d;
    elect_d = 8;
    ele_z = elect_d/2 + (height-top_height-top_sz);
    
    el_hole_x = hole_w/2 + top_diam/2; //+elect_d/2;
    
    difference(){
        body();
        translate([hole_w/2,0,0]) hole();
        translate([-hole_w/2,0,0]) hole();
        
        bolt_hole(10); 
        translate([bolt_x,0,0]) bolt_hole(4);
        translate([-bolt_x,0,0]) bolt_hole(4);        
        
        translate([0,0,height/2-1]) cube([width,1,height-2],center=true);
/*        
        translate([hole_w/2,0,ele_z]) rotate([90,0,0]) cylinder(r=elect_d/2,h=side_size, center=true);
        translate([-hole_w/2,0,ele_z]) rotate([90,0,0]) cylinder(r=elect_d/2,h=side_size, center=true);
*/      
        translate([el_hole_x,0,0]) cylinder(r=elect_d/2, h=height);
        translate([-el_hole_x,0,0]) cylinder(r=elect_d/2, h=height);
    }
}

main();