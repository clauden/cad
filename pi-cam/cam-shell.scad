
module shape() {
	union() 
	{
	cube([50,d,50], center=true);

	d = sqrt(2*50*50);
	echo(d);

	translate([25,-d/2, -25])
		rotate([0,0,45])
			cube([50, 50, 50], center=false);
	}
}

shell_th = [0.7, 0.8, 0.8];

difference()
{
	difference()
	{
		shape();
		scale(shell_th)
			shape();
	}
	translate([-75, 0, 0])
	rotate([0, 90, 0])
		cylinder(d=25, h=100);
}