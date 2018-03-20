// power connector
R = 3;          // corner radius
H = 20.2;		// actual height	
W = 28.2;		// actual width

pwr_screw_centers = 40.1;		// mounting screw holes

// connector plug body relative to mounting screw hole
pwr_offset_h = (pwr_screw_centers - W)/2;

// centers of radius columns
pwr_inner_ht = H - 2*R;
pwr_inner_wd = W - 2*R;

screw = 3.5;

// entire panel
panel_ht = 39.7;
panel_wd = 80;      // 76.2;
panel_th = 1.57;
panel_clearance = 2;    // around edges

// bushing
bushing_ht=15;
bushing_wd = 14;


module plate() {
    cube([panel_wd, panel_ht, 1.5]);
}
    

module plug() {

	translate([screw/2, 0, 0]) 
    {
		union() 
		{
			hull() {
				translate([pwr_offset_h, 0, 0]) 
				{
					translate([R, R, 0])
						cylinder(r=R, h=10, $fn=32); 
						
					translate([R, H-R, 0])
						cylinder(r=R, h=10, $fn=32);
						
					translate([W-R, R, 0])
						cylinder(r=R, h=10, $fn=32);
						
					translate([W-R, H-R, 0])
						cylinder(r=R, h=10, $fn=32);
				}
			}
        
			translate([0, H/2, 0])
				cylinder(d=screw, h=10, $fn=32);
         
			translate([2*pwr_offset_h + W , H/2, 0])
				cylinder(d=screw, h=10, $fn=32);
		}
        
    }
	
}

module _plug() {
	
	
    translate([screw/2, 0, 0]) // union() 
    {
        hull() {
            translate([offset_h + R, R, 0])
                cylinder(r=R, h=10, $fn=32); 
                
            translate([offset_h + R, H-R, 0])
                cylinder(r=R, h=10, $fn=32);
                
            translate([offset_h + W-R, R, 0])
                cylinder(r=R, h=10, $fn=32);
                
            translate([offset_h + W-R, H-R, 0])
                cylinder(r=R, h=10, $fn=32);
        }
        
        translate([0, H/2, 0])
            cylinder(d=screw, h=10, $fn=32);
         
        translate([2*offset_h + W , H/2, 0])
            cylinder(d=screw, h=10, $fn=32);

        
    }
}


// FIXME parameterize
module bushing() {
    intersection() {
		//cylinder(d=17, h=15, $fn=32, center=true);
		cube([10, 10, 10], center=true);
    }
}

module _bushing() {
    intersection() {
		cylinder(d=17, h=15, $fn=32, center=true);
		cube([12, 17, 10], center=true);
    }
}



// main begins


// debuggy
*translate([(panel_wd - pwr_screw_centers - screw)/2, 0, 0]) 
{
    plug();

    translate([screw/2, -10, 0])
        color("black") cube([.5,50,10]);
    translate([screw/2, -5, 0])
        color("black") cube([40, .5, 10]);
    translate([screw/2 + 40, -10, 0])
        color("black") cube([.5,50,10]);
}
translate([panel_wd/2-.25, 0, 0])
       color("black") cube([.5,50,10]);
translate([0, panel_ht-H/2-.25-H/2, 0])
       color("black") cube([panel_wd, .5,10]);


// the actual one
difference() {
    plate();
	
    translate([(panel_wd  - pwr_screw_centers - screw)/2 , ((panel_ht-H)/2)*1.0, -1])
        plug();
    
    translate([10, ((panel_ht-7+H+2)/2), -1])
        bushing();
    translate([panel_wd-10, ((panel_ht-7+H+2)/2), -1])
		bushing();

}

*translate([(panel_wd-W -2*pwr_offset_h)/2, ((panel_ht-H)/2)*.5, -1])
    %cube([W+2*pwr_offset_h, H, 5]);
    
translate([ (panel_wd - pwr_screw_centers )/2, (panel_ht-H)/4, -1]) 
// translate([screw/2 + (panel_wd - W)/2 - pwr_offset_h, 0, 0])
{
	{
		color("red") cube([40, .5, 5]);
		color("blue") cube([.5, 40, 5]);
		translate([40, 0, 0])
			color("green") cube([.5, 40, 5]);
		
	}
}
    