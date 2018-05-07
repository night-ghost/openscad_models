$fn=40;

module tube(d,l,w){
        difference(){
            cylinder(r=d/2+w,h=l,center=true);
            cylinder(r=d/2,h=l+0.1,center=true);
        }
}

module clip(d1,l1,d2,l2,w){
        rr = l1/2;
        shf=2;
        difference(){
            union(){
                translate([0,0,l2/2]) tube(d2,l2,w);
                difference(){
                    translate([0,0,l2/2]) cube([l1,2,l2],center=true);
                    translate([-(d2/2+w+rr),0,d1/2+w+rr-shf]) rotate ([90,0,0]) cylinder(r=rr,h=w*2, center=true);
                    translate([(d2/2+w+rr),0,d1/2+w+rr-shf]) rotate ([90,0,0]) cylinder(r=rr,h=w*2, center=true);
                }
                rotate([0,90,0]) tube(d1,l1,w);
                scale([1,1,(d1+2*w)/(d2+2*w)]) sphere(r=d2/2+w);
            }

            rotate([0,90,0]) cylinder(r=d1/2+0.1,h=l1+0.1, center=true);
            translate([0,0,l2/2]) cylinder(r=d2/2,h=l2+0.1, center=true);
        }
        
}

clip(8,30,10,20,2);