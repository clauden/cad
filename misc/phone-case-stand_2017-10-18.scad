include <ruler.scad>

// measured
thick = 2;
len = 42.5;
wid = 10.26;
pin_len = (12.65 - 10.26) / 2;
tab_len = 42.5 - 37.6;
tab_wid = 2.5;

// derived
diam = thick;
tab_gap = (wid - (3 * tab_wid)) / 2;

module slab(x, y, z) {
	translate([0, -y/2, -z/2])
		cube([x, y, z]);
}

module pin(diam, len) {
	rotate([90, 0, 0])
		cylinder(d=diam, h=len);
}

module hook(diam, hook_thick, offset, offset_thick, width) {
	rotate([90, 0, 0]) {
		difference() {
			union() {
				cylinder(d=diam+hook_thick, h=width);
				translate([0, -offset_thick/2, 0])
					cube([offset+diam, offset_thick, width]); 
			}
			
			cylinder(d=diam, h=100);
			
			translate([-diam*1.33, -diam, -10])
				cube([diam, diam*2, 200]);
		}
	}
	
}

$fn = 128;

difference() {
	union() {
		slab(len, wid, thick);
		translate([len, wid/2 + pin_len, 0])
			pin(diam, 2 * pin_len + wid);
		translate([diam/2, wid/2 + pin_len, 0])
			pin(diam, 2 * pin_len + wid);
	}
	translate([-5, tab_wid/2, -5])
		cube([tab_len + 5, tab_gap, 10]);
	translate([-5, -(tab_wid/2 + tab_gap), -5])
		cube([tab_len + 5, tab_gap, 10]);
}

color("gainsboro")
	translate([-5, -10, -5])
		ruler(20);
/*
 * translate([-8, -5, 0])
 *	hook(3, 2, 5, 2, 3);
 *
 * translate([-8, 5, 0])
 *	hook(3, 2, 5, 2, 3);
 */