// ==============================================
// Model of Raspberry Pi Camera v2.1
//
// J.Beale 14-May-2016
// ==============================================

xs = 25.0;  // width of PCB
ys = 23.85;  // height of PCB
zs = 0.95;  // thickness of bare PCB, not including soldermask
smt = 0.05;  // soldermask thickness (on each side)

ID1 = 2.20; // ID of mounting through-holes
OD1 = 4.7;  // silkscreen clearance around hole

mhxc = 21.0;  // X center-to-center separation of mounting holes
mhyc = 12.5; // Y center-to-center separation of mtng. holes
mhox = 2.0;  // X mounting hole corner offset
mhoy = 2.0;  // Y mounting hole corner offset
hh = zs*2; // depth/height of mounting hole (subtractive cylinder)

smx = 8.45;  // camera sensor module, base part
smy = 8.45;
smz = 2.3;
smbod = 7.25;  // OD of lens holder barrel
smbz = 1.7; // z-height of lens holder barrel
smcod = 5.6;  // OD of lens cell 
smcz = 0.6;  // protrusion of cell above holder barrel
smcid = 1.55;  // optical aperture: opening for lens

smfx = 8.9; // flex connector width
smfy = 4.5; // flex connector 
smfz = 1.52; // flex connector
smfox = 9.45; // flex edge X offset
smfoy = 2.6; // flex edge Y offset
smfcx = 7.2; // flex cable width

fcy = 5.8; // 15-way flex connector
fcx = 21.0; // 15-way flex connector
fcz = 3.77-1.15; // 15-way flex connector height  
fcyoff = 0.3; // connector offset from PCB edge

ffx = 16.05;  // 15-way flex cable width
ffy = 30;  // length of flex cable stub
ffz = 0.38;  // thickness of ff cable at stiffener
ffoz = 1.1; // offset of ff cable below PCB

// HDMI connector
hdmicy = 9.9; 
hdmicx = 16.0;
hdmicz = 6.2;  
hdmiyoff = 0.3; 	// connector offset from PCB edge

KOx = 22.15; 	// keepout width- full
KOxa = 15.1; // keepout width- inner block
KOz = 1.35; // bottom side keepout z-height
KOyo = 1.15; // keepout edge offset

// ==============================================

fn=40;  // facets on cylinder
eps=0.03; // small number

// ---------------------------------
// PCB holding camera module v2.1
module pcb() {
difference() {
 union() {
     translate([0,0,0]) color("green") 
        cube([xs,ys,smt]); // soldermask (bottom)
     translate([0,0,smt]) color("yellow") 
        cube([xs,ys,zs]); // natural PCB color
     translate([0,0,zs]) color("green") 
        cube([xs,ys,smt]); // soldermask (top)
 }
 translate([mhox,mhoy,zs-(smt+eps)]) {  // mask clearance: top
     cylinder(d=OD1,h=zs,$fn=fn);
     translate([mhxc,0,0]) cylinder(d=OD1,h=zs,$fn=fn);
     translate([mhxc,mhyc,0]) cylinder(d=OD1,h=zs,$fn=fn);
     translate([0,mhyc,0]) cylinder(d=OD1,h=zs,$fn=fn);
 }
 translate([mhox,mhoy,-eps]) {  // mask clearance: bottom
     cylinder(d=OD1,h=smt,$fn=fn);
     translate([mhxc,0,0]) cylinder(d=OD1,h=smt,$fn=fn);
     translate([mhxc,mhyc,0]) cylinder(d=OD1,h=smt,$fn=fn);
     translate([0,mhyc,0]) cylinder(d=OD1,h=smt,$fn=fn);
 }
 translate([mhox,mhoy,-zs*5]) {  // through holes
  cylinder(d=ID1,h=zs*10,$fn=fn);     
  translate([mhxc,0,0])  cylinder(d=ID1,h=zs*10,$fn=fn);
  translate([mhxc,mhyc,0])  cylinder(d=ID1,h=zs*10,$fn=fn);
  translate([0,mhyc,0])  cylinder(d=ID1,h=zs*10,$fn=fn);
  }
 }
}


module sensor() { // Camera sensor module
 color([.25,.25,.25]) translate([-smx/2, -smy/2, 0]) cube([smx,smy,smz]);
 color([.3,.3,.3]) cylinder(d=smbod, h=smbz + smz, $fn=fn);
 difference() {
  color([.2,.2,.2]) cylinder(d=smcod, h=smbz + smz + smcz, $fn=fn);
  translate([0,0,smcz]) cylinder(d=smcid, h=smbz + smz + smcz, $fn=fn);
 }
}

module flex() { // micro-flex attached to sensor
 color([0.2,0.20,0.18]) cube([smfx,smfy,smfz]); // u-flex connector top
 translate([0,smfy,0]) color([0.33,0.33,0.23]) cube([smfcx,smfy,smfz-.1]);
}

module fcon() {  // micro-flex connector to PCB
    color([0.6,0.20,0.18]) cube([fcx,fcy,fcz]);
}

module ff15() {  // 15-conductor flat flex cable
    color([.7,.7,.7]) cube([ffx,ffy,ffz]);
}

// 15-conductor flat flex cable curled around
module ff15_bent() {
	
	// from one fcon to the other, assume  (pcb_thickness + 2* soldermask + spacerht) apart
	_fdiam = fcz + 0.1 + spcrht - ffoz; 

	color([.9,.9,.9]) 
	translate([0, 0 /*xs-fcyoff*/, ffoz])
	{
		difference() 
		{
			rotate([0, 90, 0])
				cylinder(d=_fdiam, h=ffx, $fn=72);
			rotate([0, 90, 0])
				translate([0,0,-10])
					cylinder(d=_fdiam-2*ffz, h=ffx+11, $fn=72);
			translate([-10, -_fdiam/2, -10])
				cube([100, _fdiam/2, 20]);
	

		}
	}
}




KOx = 22.3; // keepout width- full
KOxa = 15.1; // keepout width- inner block
KOy = 22.87-fcy;  // keepout height
KOya = 4.7;  // keepout height
KOz = 1.3; // bottom side keepout z-height
KOyo = 1.15; // keepout edge offset
KOxo = 1.54; // keepout 2nd-block X edge offset
KOyoa = 6.5; // keepout 2nd-block Y edge offset

module keepout() {
  translate([(xs-KOxa)/2,ys-(KOy+fcy),-KOz])  cube([KOxa,KOy,KOz]);
  translate([KOxo,KOyoa,-KOz])  cube([KOx,KOya,KOz]);    
}

module hdmi() {
	color("cyan")
	difference() 
	{
		cube([hdmicx, hdmicy, hdmicz]);
		
		// approximate HDMI hole: 14x3 + 10x1.55 stacked
		translate([(hdmicx-14)/2,-10, ((hdmicz-4.55)/2)+.1])
			cube([14, 17, 3.0]);
		translate([(hdmicx-10)/2,-10, 3+(hdmicz-4.55)/2])
			cube([10, 17, 1.55]);
		}
}

spcrht = 5;
spcrscrew = 2.5;
spcrdiam = 4.5;

module spacer() {
	color("grey")
	difference() {
		cylinder(d=spcrdiam, h=spcrht, $fn=72);
		translate([0, 0, -9])
			cylinder(d=spcrscrew, h=spcrht+10, $fn=72);
		}
}

module spacers() {
	// through holes
}


// ---------------------------------------------

module cam_full(show_ff15=true) { // top, bottom & flex cable stub
  translate([xs/2 ,mhyc+mhoy,zs]) sensor();
  pcb();
  translate([smfox,smfoy,zs]) flex(); // micro-flex on sensor

  color([0.7,0.1,0.1])  keepout();  // bottom side circuits
  translate([(xs-fcx)/2,ys-fcy-fcyoff,-fcz]) fcon();  // FF15 flex connector
  if (show_ff15)
	  translate([(xs-ffx)/2,ys-fcyoff,-ffoz]) ff15();  // FF15 flex cable
}

module cam_top() {  // only topside components
  translate([xs/2 ,mhyc+mhoy,zs]) sensor();
  pcb();
  translate([smfox,smfoy,zs]) flex(); // micro-flex on sensor
}

module through_holes() {
	translate([mhox,mhoy,zs + smt]) {     
		children(0);
		translate([mhxc,0,0])
			children(0); 	// cylinder(d=ID1,h=zs*10,$fn=fn);
		translate([mhxc,mhyc,0]) 
			children(0);	// cylinder(d=ID1,h=zs*10,$fn=fn);
		translate([0,mhyc,0]) 
			children(0);		// cylinder(d=ID1,h=zs*10,$fn=fn);
	}
}

translate([0,0,-20])
	through_holes() {
// 		cube([5,5,5], center=true);
		cylinder(h=50, d=2.0, center=true, $fn=72);
	}
	
	
	
// hdmi connector board
module hdmi_board() {
	translate([0, 0, -(zs + spcrht + .1)])
	{
		pcb();
		
		// FF15 flex connector
		translate([(xs-fcx)/2,ys-fcy-fcyoff,-fcz])
			fcon();  

		// FF15 flex cable
		translate([(xs-ffx)/2,ys-fcyoff, ffoz]) 
			ff15_bent();

		translate([(xs-hdmicx)/2, fcyoff, -(hdmicz+0.05)]) 
			hdmi();  

		// borrowed from through holes
		translate([mhox,mhoy,zs + smt]) {     
			spacer();
			translate([mhxc,0,0])
				spacer(); 	// cylinder(d=ID1,h=zs*10,$fn=fn);
			translate([mhxc,mhyc,0]) 
				spacer();	// cylinder(d=ID1,h=zs*10,$fn=fn);
			translate([0,mhyc,0]) 
				spacer();		// cylinder(d=ID1,h=zs*10,$fn=fn);
		}
	}
}

cam_full(false);
hdmi_board();

