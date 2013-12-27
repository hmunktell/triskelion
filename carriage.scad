$fn = 50;
use <platform.scad>
include <configuration.scad>
include <cogsndogs.scad>

module carriage() {
	difference() {
		union() {
			translate([0,-carriage_offset,-linear_bearing_height/2+platform_thickness/2]) rotate([0,0,90]) parallell_joints();
			translate([0,-13,-linear_bearing_height/2+platform_thickness/2]) cube([8,10,platform_thickness], center=true);
			
			translate([0,-4-5,0]) cube([smooth_rod_distance+linear_bearing_dia,8,linear_bearing_height+1], center=true);
			
			//translate([0,-10,-10]) rotate([45,0,0]) cube([40,20,20], center=true);
			//translate([-10,-15,0]) rotate([0,-90,0]) cylinder(r=10,h=15, $fn=3, center=true);
			
			for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
				translate([i,0,0]) {
					cylinder(r=linear_bearing_dia/2+4, h=linear_bearing_height+1, center=true);
					translate([0,7.5,0]) cube([linear_bearing_dia,15,linear_bearing_height+1], center=true);
				}
			}
			
			translate([6, 4.5, -15]) rotate([0, 270, 90]) dog_linear(T2, 15, 10, 4);
		}
		
		for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
			translate([i,0,0]) {
				// Linear bearing
				cylinder(r=linear_bearing_dia/2, h=linear_bearing_height+1, center = true);
				
				// Cut out
				translate([0,linear_bearing_dia/2,0]) cube([5,linear_bearing_dia+1,linear_bearing_height+1], center=true);
			}
		}
		
		// Screw hole for adjustable top endstop.
		translate([15, -16, 0]) cylinder(r=1.5, h=30, center=true, $fn=12);

		// Clip top and bottom
		 for(i=[-1,1]) {			
			  translate([0,0,i*(linear_bearing_height/2+5)]) cube([100,100,10], center=true);
		}
		
	}
	
	// For render
	if (vitamins) {
		%color([1,0,0,0.5])
		for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
			translate([i,0,0]) {
				// Smooth rod
				cylinder(r=smooth_rod_dia/2, h=100, center = true);
				
				// LM8UU
				cylinder(r=linear_bearing_dia/2, h=linear_bearing_height, center=true);
			}
		}
	}
	
}

carriage();