
gear_diam = 40;
gear_thick = 5;
hub_diam = 24;
hub_thick = 6;

/*
 * placeholder flat gear
 */
module gear(diam=gear_diam, hub_diam=hub_diam, thick=gear_thick, hub_thick=hub_thick, shaft_diam=8, teeth=24) {
	difference() {
		union() {
			cylinder(d=diam, h=thick);
			translate([0, 0, thick])
				cylinder(d=hub_diam, h=hub_thick);
		}
		shaft(shaft_diam);
	}
}


/*
 *  wrapper on a gear()
 *  TBD: make dogs circle edged
 */

// working?
module dogged(diam=hub_diam*.9, depth=hub_thick, width=hub_thick, hgt=2*hub_thick, num=6) {
	angle = 360/num;
	
	union() {
		children(0); 	// gear();
		
		for (i = [1:num]) {
			rotate([0, 0, angle*i])
				translate([diam/2, -depth/2, gear_thick]) 
					difference() {
						// dog tooth
						cube([depth, width, depth]);
					
						// bevel plane
						translate([0, 0, depth])
							rotate([0, 15, 0])
								cube([depth*2, width*2, depth]);
					}
		}
	}
}


// attempting bevel
module dogged_beveled(diam=hub_diam, depth=hub_thick, hgt=2*hub_thick, num=6) {
	angle = 360/num;
	
	union() {
		children(0); 	// gear();
		
		for (i = [1:num]) {
			translate([0, 0, -depth])
			rotate([0, 0, angle*i]) {
					translate([diam/2, -depth/2, hgt]) {
						
						// beveling...
						difference() {
							
							// dog tooth
							cube([depth, depth, depth]);
							
							// bevel plane
							translate([0, 0, depth])
								rotate([0, 15, 0])
									cube([depth*2, depth*2, depth]);
						}
					}
			}
			
 		}
	}
}


// funky way to do it?
module dogged_diff(diam=9, depth=3, hgt=4+4, num=6) {
	angle = 360/num;
	
	difference() {
		children(0); 	// gear();
		
		for (i = [1:num]) {
			rotate([0, 0, angle*i]) {
					translate([diam/2, -depth/2, hgt-depth/2]) {
						cube([depth, depth, depth]);
				}
			}
			
 		}
	}
}

module shaft(diam) {
	translate([0, 0, -100])
		cylinder(d=diam, h=200, $fn=64);
}



depth = 5;



// figuring out bevel mechanics
*difference() {

	// dog tooth
	cube([depth, depth, depth]);

	// bevel plane
	translate([-1, -1, depth])
		rotate([0, 15, 0])
			cube([2*depth, 2*depth, depth]);
	
}


// gear with dog teeth
dogged() 
 gear();


/*
 * mating part
 * TBD: parametrize dog negatives wider than the gear version's
 */
ht = gear_thick + hub_thick*.7;

translate([0, 50, 0]) {

translate([0, 0, ht])	
rotate([0, 180, 0]) 
translate([0, 0, -gear_thick])
		difference() {
			translate([0, 0, gear_thick])
				cylinder(d=gear_diam, h=gear_thick + hub_thick*.7);
			dogged(hub_diam*.9, hub_thick, hub_thick*1.25, 2*hub_thick, 6)
				gear();
		}
}