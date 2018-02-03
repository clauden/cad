
gear_diam = 40;
gear_thick = 5;
hub_diam = 24;
hub_thick = 6;

/*
 * placeholder flat gear
 */
module gear_dummy(diam=gear_diam, hub_diam=hub_diam, thick=gear_thick, hub_thick=hub_thick, shaft_diam=8, teeth=24) {
	difference() {
		union() {
			cylinder(d=diam, h=thick);
			translate([0, 0, thick])
				cylinder(d=hub_diam, h=hub_thick);

		}
		shaft(shaft_diam);
	}
}


module gear(diam=gear_diam, hub_diam=hub_diam, thick=gear_thick, hub_thick=hub_thick, shaft_diam=8) {
	difference() {
	union() {
			cylinder(d=diam, h=thick);
			translate([0, 0, thick])
				cylinder(d=hub_diam, h=hub_thick);
		}
		shaft(shaft_diam);
	}
}

module toothed(diam=gear_diam, thick=gear_thick, teeth=24) {
	angle = 360/teeth;
	union() {
		children(0);
		for (i = [1:teeth]) {
			rotate([0, 0, angle * i])
				translate([diam*.95/2, 0, thick*.15/2]) 
					cube([3, 3, thick*.85]);
		}
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



/*
 * assume the object being splined is in the z axis
 */
module splined(inner_diam, outer_diam, len, num) {
	angle = 360/num;
	hgt = (outer_diam - inner_diam) / 2;
	wid = hgt * .8;
	
	union() {
		children(0);
		for (i = [1:num]) {
				rotate([0, 0, angle*i])
					translate([inner_diam/2, -wid/2, -len/2])
						cube([hgt, wid, len]);
		}
	}
}



depth = 5;

module splined_shaft(inner=10, outer=15, length=5*mating_hgt, num=6) {
	splined(inner, outer, length, num)
		shaft(inner);
}


mating_hgt = gear_thick + hub_thick*.7;

module mating_part() {
	
	
	translate([0, 0, mating_hgt])	
		rotate([0, 180, 0]) 
			translate([0, 0, -gear_thick])
				difference() {
					translate([0, 0, gear_thick])
						cylinder(d=gear_diam, h=gear_thick + hub_thick*.7);
					dogged(hub_diam*.9, hub_thick, hub_thick*1.25, 2*hub_thick, 6)
						gear();
				}
}


module mating_part_inverted() {
	translate([0, 0, -gear_thick])
		difference() {
			translate([0, 0, gear_thick])
				union() {
					cylinder(d=gear_diam, h=gear_thick + hub_thick*.7, $fn=128);
					cube([30, 2, (gear_thick + hub_thick*.7)/2]);
				}
					dogged(hub_diam*.9, hub_thick, hub_thick*1.25, 2*hub_thick, 6)
				gear();
		}
}




//
// main begins
//

rotate([0, 0, 0]) {
	
	// mating part distance from gear
	offset = 5 - ($t < 0.5 ? $t*50 :  50-$t*50);
	// offset = 5 - ($t < 0.5 ? $t*30 :  30-$t*30);
	echo(offset);

	// shaft & gear rotation angle
	angle = 360 * $t;
	echo (angle);
	
	translate([0, 0, -.5]) {
		rotate([0, 0, offset < -14.? angle /*360-$t*360*/ : 0])
		dogged() 
			toothed() 
				gear();
	}
	
	rotate([0, 0, angle])
		translate([0, 0, 25]) {
		translate([0, 0, offset])
			difference() {
				mating_part_inverted();
				scale([1,1,1])
					splined_shaft();
			}
		
			translate([0, 0, mating_hgt/2])
			scale([.8, .8, .8])
				splined_shaft();
	}
}