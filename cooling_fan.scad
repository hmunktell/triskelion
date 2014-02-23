platform_hole = 2.5;
fan_hole = 2.5;
fan_hole_distance = 20;
fan_angle = 40;
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
				
			}
	}
}

module unit(){
	 difference() {
		union() {
			translate([-fan_width/2,0,0]) 
				cube([fan_width,5,5]);
			rotate([fan_angle,0,0])
				translate([0,2.5,-2.5]) cube([fan_width,5,5], center = true);
		}

		rotate([fan_angle,0,0]) {
			translate([+fan_hole_distance/2,4,-2.5]) rotate([90,0,0]) cylinder(r=fan_hole_radius,h=10, center= true);			
			translate([-fan_hole_distance/2,4,-2.5]) rotate([90,0,0]) cylinder(r=fan_hole_radius,h=10, center= true);			
		}

		translate([0,2.5,5.5])
			mirror([0,0,1]) cylinder(r=platform_hole/2, h=10);
		
	}
}

unit();