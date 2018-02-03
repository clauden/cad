mountBoard_thickness = 1.7;
mountBoard_spacing = 22;
mountBoard_width = 35;
mountBoard_height = 32;
mountBoard_screwDiameter = 3;
mountBoardHole_vertical = 24;
mountBoardHole_horizontal = 18;

cameraBoard_width = 32;
cameraBoard_height = 32;
cameraBoard_thickness = 1.7;
cameraBoard_spacing = 28;
cameraLens_width = 14;
cameraLens_height = 17;
cameraBoard_screwDiameter = 2;


/*
 * add holes at four corners, offset symmetrically
 */
module add_screwHoles(screw_diameter = 3, 
						offset = 2.5, 
						width, 
						height, 
						screw_color = "", 
						screw_length = 10) {
	difference() {
		children(0);
		translate([width/2 - offset, height/2 - offset, -10])
			cylinder(r = screw_diameter/2, h = 100, $fn=16);
		translate([-(width/2 - offset), height/2 - offset, -10])
			cylinder(r = screw_diameter/2, h = 100, $fn=16);
		translate([width/2 - offset, -(height/2 - offset), -10])
			cylinder(r = screw_diameter/2, h = 100, $fn=16);
		translate([-(width/2 - offset), -(height/2 - offset), -10])
			cylinder(r = screw_diameter/2, h = 100, $fn=16);
	}

	if (len(screw_color) != 0) {
      color(screw_color) {
      translate([width/2 - offset, height/2 - offset, -10])
        cylinder(r = 0.75*screw_diameter/2, h = 15, $fn=16);
      translate([-(width/2 - offset), height/2 - offset, -10])
        cylinder(r = 0.75*screw_diameter/2, h = 15, $fn=16);
      translate([width/2 - offset, -(height/2 - offset), -10])
        cylinder(r = 0.75*screw_diameter/2, h = 15, $fn=16);
      translate([-(width/2 - offset), -(height/2 - offset), -10])
        cylinder(r = 0.75*screw_diameter/2, h = 15, $fn=16);
    }
  }
	pt = [width/2 - offset, height/2 - offset];
	v = concat(v, pt);
  
	echo("center at ", width/2 - offset, height/2 - offset);
}


module mountBoard(width = 35, height = 32) {
	add_screwHoles(mountBoard_screwDiameter, 2.5, width, height, "blue")
		__mountBoard(width, height);
}

module __mountBoard(width = 35, height = 32) {
    yscale = mountBoardHole_horizontal / mountBoardHole_vertical;
    xscale = 1.0 / yscale;

	color("grey") {
        difference() {
            translate([-width/2, -height/2, 0])
                cube([width, height, mountBoard_thickness]);
                translate([0, 0, -mountBoard_thickness*2])
					scale([xscale, yscale, 1])
						cylinder(r = mountBoardHole_vertical/2, h = mountBoard_thickness*4);
            }    
		}
}

module cameraBoard(width = cameraBoard_width, height = cameraBoard_height) {
	add_screwHoles(cameraBoard_screwDiameter, 2.5, width, height, "orange")
		__cameraBoard(width, height);
}

module __cameraBoard(width = 28, height = 28) {
    color("cyan") {
		translate([-width/2, -height/2, 0])
			cube([width, height, cameraBoard_thickness]);
		cylinder(r = cameraLens_width/2, h = cameraLens_height);
	}
}





module __spacer() {
	w = mountBoard_width + 5;
	h = mountBoard_height + 5;
	
	translate([0, 0, 6]) {
		difference() {
			cube([w, h, 4], true);
			translate([0, 0, -5])
				cylinder(r = cameraLens_width/2 + 4, h = 20);
		}
	}

}

module _spacer() {
	add_screwHoles(cameraBoard_screwDiameter, 2.5, cameraBoard_width, cameraBoard_height)
		__spacer();
}


module spacer() {
	add_screwHoles(mountBoard_screwDiameter, 2.5, mountBoard_width, mountBoard_height)
		_spacer();
}
//
// main begins
//

rotate([0, 0, 0]) {
	translate([0, 0, 10])
		mountBoard(mountBoard_width, mountBoard_height);
    translate([0, 0, -10])
		cameraBoard();
	spacer();
}

echo(v);