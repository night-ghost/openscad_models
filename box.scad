$fn=200;

length = 142;
width= 70;
height = 87;
cornerRadius = 2;
thick=2; // a side

//* // body
translate([10, 10, 0]){
    difference() {
            roundedBox(length, width, height, cornerRadius); 
            translate([thick,thick,thick]) {
                roundedBox(length-thick*2, width-thick*2, height-thick, cornerRadius); 
            }
    }
}
//*/

//* // cover
translate([width*2+thick*6, 10, 0]){
    mirror([thick,0,0]) {
        roundedBox(length, width, thick, cornerRadius);
        difference() {
            translate([thick,thick,0]) {
                roundedBox(length-2*thick,width-2*thick,4,cornerRadius);
            }
            translate([2*thick,2*thick,0]) {
                roundedBox(length-4*thick,width-4*thick,4,cornerRadius);
            }    
        }
    }
}
//*/

//handle
/*
translate([0,length,0]) {
    difference() {
        difference() {
            cylinder(h=2, r=10);
            cylinder(h=2, r=5);

        }
        translate([0,-10,0]) {
            cube(size=[10,10,2]);        
        }
    }
}
*/

module roundedBox(length, width, height, radius)
{
    dRadius = 2*radius;

/*    //cube bottom right
    translate([width-dRadius,-radius,0]) {
        cube(size=[radius,radius,height+0.01]);
    }
//*/
 /*   //cube top left
    translate([-radius,length-dRadius,0]) {
        cube(size=[radius,radius,height+0.01]);
    }
//*/
    
    //base rounded shape
    minkowski() {
        cube(size=[width-dRadius,length-dRadius, height]);
        cylinder(r=radius, h=0.01);
    }
  
    
  
}