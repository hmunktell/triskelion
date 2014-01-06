platform_hole = 2.5;
fan_hole = 2.5;
fan_hole_distance = 20;
fan_angle = 20;
fan_width = 25;
$fn=20;
fan_hole_radius = fan_hole / 2;

module fan_bar() {
	difference() {
		translate([-fan_width/2,0,-5])
			cube([fan_width, 5,5]);		
		rotate([90,0,0])
			for (i = [-fan_hole_distance/2,fan_hole_distance/2]){
				translate([i,-2.5,-4])
					cylinder(r=fan_hole_radius,h=10, center= true);			
				//translate([i, -2.5,-5])
					//cylinder(r=3,h=3, $fn=6);
				
			}
	}
}

module unit(){
	 difference() {
		union() {
			translate([-fan_width/2,0,0]) 
				cube([fan_width,5,5]);
			rotate([fan_angle,0,0])
				fan_bar();
		}
		translate([0,2.5,5.5])
			mirror([0,0,1]) cylinder(r=platform_hole/2, h=8);
		//translate([0,5,-3])
			//cylinder(r=5/2,h=5, $fn=6);
		
	}
}

//fan_bar();
mirror([0,0,1])translate([0,0,-5])unit();

// difference () {
	// union() {
		// translate([-fan_width/2,0,0]) {
			// cube([fan_width,10,5]);
			// rotate([10,0,0])translate([0,0,-10])
				// cube([fan_width,5,10]);
		// }
	// }
	// translate([0,5,0]) {
		// cylinder(r=plattform_hole/2, h=5);
		// cylinder(r=6.2/2, h=3, $fn=6);
	// }
// }