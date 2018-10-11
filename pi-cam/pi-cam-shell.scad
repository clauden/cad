//
// https://www.raspberrypi-spy.co.uk/2013/05/pi-camera-module-mechanical-dimensions/
// http://www.raspiworld.com/images/other/drawings/Raspberry-Pi-Camera-Module.pdf

cam_w = 25;
cam_h = 24;

board_th = 1.6;

hole_diam = 2.15;
hole_offset_side = 2;
hole_offset_bottom = 9.5;
hole_offset_top = 2;
hole_distance = 12.5;

lens_side = 8;
lens_offset_bottom = 5.5;
lens_th = 5.9 - board_th;

connector_th = 2.2;
connector_w = 20.8;
connector_h = lens_offset_bottom;


hdmi_th = 5;
hdmi_w = 14;
hdmi_h = 13;

spacer_th = 4.5; // measured


module cam_board() {
	union() {
		
		color("green")
		difference()
		{
			cube([cam_w, cam_h, board_th]);
			translate([hole_offset_side, cam_h - hole_offset_top, -4*board_th])
				cylinder(d=hole_diam, h=100, $fn=64);
			translate([cam_w - hole_offset_side, cam_h - hole_offset_top, -4*board_th])
				cylinder(d=hole_diam, h=100, $fn=64);
			translate([hole_offset_side, hole_offset_bottom, -4*board_th])
				cylinder(d=hole_diam, h=100, $fn=64);
			translate([cam_w - hole_offset_side, hole_offset_bottom, -4*board_th])
				cylinder(d=hole_diam, h=100, $fn=64);
			}
		
		color("silver")
		translate([(cam_w - connector_w)/2, 0, -connector_th])
			cube([connector_w, connector_h, connector_th]);
		
	}
}


module hdmi_board() {
	translate([0, 0, -(board_th + spacer_th)])
		union() {
			
			// color("green")
			difference()
			{
				cube([cam_w, cam_h, board_th]);
				translate([hole_offset_side, cam_h - hole_offset_top, -4*board_th])
					cylinder(d=hole_diam, h=100, $fn=64);
				translate([cam_w - hole_offset_side, cam_h - hole_offset_top, -4*board_th])
					cylinder(d=hole_diam, h=100, $fn=64);
				translate([hole_offset_side, hole_offset_bottom, -4*board_th])
					cylinder(d=hole_diam, h=100, $fn=64);
				translate([cam_w - hole_offset_side, hole_offset_bottom, -4*board_th])
					cylinder(d=hole_diam, h=100, $fn=64);
				}
	
			// ribbon connector
			color("silver")
			translate([(cam_w - connector_w)/2, cam_h - connector_h - hole_offset_top - hole_diam/2, board_th])
				cube([connector_w, connector_h, connector_th]);

			// hdmi connector
			color("pink")
			translate([(cam_w - hdmi_w)/2, 0, -(hdmi_th)])
				difference() {
					cube([hdmi_w, hdmi_h, hdmi_th]);
					translate([1.5, -10, 1])
						cube([hdmi_w - 3, hdmi_h + 6, hdmi_th-2]);
				}
		}
		
	//spacers
	color("red") 
	{
		translate([hole_offset_side, cam_h - hole_offset_top, -spacer_th])
			cylinder(d=hole_diam, h=spacer_th, $fn=64);
		translate([cam_w - hole_offset_side, cam_h - hole_offset_top, -spacer_th])
			cylinder(d=hole_diam, h=spacer_th, $fn=64);
		translate([hole_offset_side, hole_offset_bottom, -spacer_th])
			cylinder(d=hole_diam, h=spacer_th, $fn=64);
		translate([cam_w - hole_offset_side, hole_offset_bottom, -spacer_th])
			cylinder(d=hole_diam, h=spacer_th, $fn=64);
	}
}


module screw(len=spacer_th+2*board_th+1, diam=2) {
	// head
	head_d = diam*1.8;
	
	translate([0, 0, -diam*.1]) 
	union() {
		difference() 
		{
			// translate([0, 0, -diam*.2])
			sphere(d=head_d, $fn=64);
			translate([-head_d, -head_d, -diam*.9])
				cube([4*diam, 4*diam, diam]);
			
			translate([-0.4, -head_d, head_d/4])
				cube([.8, 10, 10]);
		}

		// body
		translate([0, 0, -len + diam*.1])
			cylinder(d=diam, h=len, $fn=64);
	}
}


module screws() {
	translate([hole_offset_side, cam_h - hole_offset_top, board_th])
		screw();
	translate([cam_w - hole_offset_side, cam_h - hole_offset_top, board_th])
		screw();
	translate([hole_offset_side, hole_offset_bottom, board_th])
		screw();
	translate([cam_w - hole_offset_side, hole_offset_bottom, board_th])
		screw();
}

module lens() {
	// arbitrary: lens extension beyond its box
	barrel_th = 1.5;
	barrel_diam = .85*lens_side;
	
	union() 
	{
		color("grey")
		translate([(cam_w - lens_side)/2, lens_offset_bottom, board_th])
			cube([lens_side, lens_side, lens_th]);
		color("blue")
		translate([cam_w/2, lens_offset_bottom + lens_side/2, board_th+lens_th])
			cylinder(d=barrel_diam, h=barrel_th);
	}
}


// hacking: build a shell out of a split hollowed hull...

// just create a shell around some objects
module wrapper() {
	hull()
	{
		for (i = [0:$children-1]) 
			children(i);
	}
}
	
// like it says
module wrapped_cam() {
	wrapper() 
	{
		hdmi_board();
		cam_board();
		lens();
		screws();
	}
}

// draw...
translate([40, 0, 0])
difference() {
	
	// the hollowed thing
	difference() {
		scale([1.2, 1.2, 1.2])
			wrapped_cam();
		wrapped_cam();
	}
	translate([5, 5, -10])
		cube([100, 100, 10]);
	translate([0, 0, 5])
		cube([100, 100, 10]);
	
}
	
{
hdmi_board();
cam_board();
}
screws();
lens();
	