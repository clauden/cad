
mountBoard_thickness = 3;
mountBoard_spacing = 22;
mountBoardHole_vertical = 19;
mountBoardHole_horizontal = 16;

cameraBoard_thickness = 2.75;
cameraBoard_spacing = 28;
cameraLens_width = 14;
cameraLens_height = 17;


/*
 * add holes at four corners, offset symmetrically
 */
module add_screwHoles(screw_diameter = 3, offset = 2.5, width, height, screw_color = "") {
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
			cylinder(r = 0.75*screw_diameter/2, h = 25, $fn=16);
		translate([-(width/2 - offset), height/2 - offset, -10])
			cylinder(r = 0.75*screw_diameter/2, h = 25, $fn=16);
		translate([width/2 - offset, -(height/2 - offset), -10])
			cylinder(r = 0.75*screw_diameter/2, h = 25, $fn=16);
		translate([-(width/2 - offset), -(height/2 - offset), -10])
			cylinder(r = 0.75*screw_diameter/2, h = 25, $fn=16);
	}
}
}


module mountBoard(width = 35, height = 32) {
	add_screwHoles(3, 2.5, width, height, "blue")
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

module cameraBoard(width = 28, height = 28) {
	add_screwHoles(3, 2.5, width, height, "orange")
		__cameraBoard(width, height);
}

module __cameraBoard(width = 28, height = 28) {
    color("cyan") {
		translate([-width/2, -height/2, 0])
			cube([width, height, cameraBoard_thickness]);
		cylinder(r = cameraLens_width/2, h = cameraLens_height);
	}
}




//
// main begins
//

rotate([0, 90, 0]) {
    translate([0, 0, 10])
		mountBoard();
    cameraBoard();
}