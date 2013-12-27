$fn = 50;
use <platform.scad>
include <configuration.scad>
include <cogsndogs.scad>

module carriage() {
	difference() {
		union() {
			// Parallell joints
			translate([0,-carriage_offset,-linear_bearing_height/2+platform_thickness/2]) rotate([0,0,90]) parallell_joints();
			
			// Parallell joints middle reinforcement 
			translate([0,-13,-linear_bearing_height/2+platform_thickness/2]) cube([8,10,platform_thickness], center=true);
			
			// Mount plate
			translate([0,-4-5,0]) cube([smooth_rod_distance+linear_bearing_dia,8,linear_bearing_height+1], center=true);			
			
			// Bearing mounts
			translate([smooth_rod_distance/2,0,0]) rotate([0,180,0]) linear_bearing_mount();
			translate([-smooth_rod_distance/2,0,0]) linear_bearing_mount();
						
			// Belt mount
			translate([6, 4.5, -15]) rotate([0, 270, 90]) dog_linear(T2, 15, 10, 4);
			
			// Reinforcements
			for(i=[-1,1]) {
				translate([-i*16,-5,0]) rotate([0,0,i*20]) rotate([0,0,-30]) cylinder(h=linear_bearing_height+1, r=10, center=true, $fn=3);
			}			
			
		}
		
		for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
			translate([i,0,0]) {
				// Linear bearing
				cylinder(r=linear_bearing_dia/2, h=linear_bearing_height+1, center = true);		
			}
		}
		
		// Screw hole for adjustable top endstop.
		translate([15, -16, 0]) cylinder(r=1.2, h=30, center=true, $fn=12);

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

module linear_bearing_mount() {
	difference() {
		union() {
			cylinder(r=linear_bearing_dia/2+4, h=linear_bearing_height, center=true);
			translate([0,8,0]) cube([linear_bearing_dia,15,linear_bearing_height], center=true);
			
			for(i=[-1,1]) {
				translate([0,12,i*7.5]) {
					// Nut reinforcement
					translate([linear_bearing_dia/2,0,0]) rotate([30,0,0]) rotate([0,-90,0]) cylinder(r=5.2,h=5, $fn=6);//m3_nut(3.8);
					
					//Screw cap head reinforcement
					translate([-linear_bearing_dia/2,0,0]) rotate([0,90,0]) cylinder(r=4.5,h=5);
				}
			}
			
		}
		
		// Linear bearing
		cylinder(r=linear_bearing_dia/2, h=linear_bearing_height+1, center = true);
		
		// Cut out
		translate([0,linear_bearing_dia/2,0]) cube([5,linear_bearing_dia+2,linear_bearing_height+1], center=true);
		
		for(i=[-1,1]) {
			translate([0,12,i*7.5]) {
				// Screw hole		
				rotate([0,90,0]) cylinder(r=1.5, h=20, center=true);
				// Nut
				translate([linear_bearing_dia/2-3,0,0]) rotate([30,0,0]) rotate([0,90,0]) m3_nut(3.8);
				// Cap head
				translate([-linear_bearing_dia/2-1,0,0]) rotate([0,90,0]) cylinder(r=5.4/2, h=4);
			}
		}
	}
}

//linear_bearing_mount();
carriage();