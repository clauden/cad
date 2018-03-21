include <panel.scad>

// override
edge_offset = 1.8;

cutout_wd = 71;
cutout_ht = 29;


module front_panel() {
	difference() {
		union() {
			plate(); 
			inner_plate();
		}
		translate([(panel_wd - cutout_wd)/2, (panel_ht - cutout_ht)/2, -20])
			cube([cutout_wd, cutout_ht, 100]);
	}
}