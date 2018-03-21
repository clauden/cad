// entire panel
panel_ht =  39.7;
panel_wd =  76.2;
panel_th = 1.57;
panel_clearance = 2;    // around edges

// edge offset of extra thickness
edge_offset = 3;

module plate() {
    cube([panel_wd, panel_ht, panel_th]);
}
    
module inner_plate() {
	translate([edge_offset, edge_offset, panel_th])
		cube([panel_wd-edge_offset*2, panel_ht-edge_offset*2, panel_th/2]);
}