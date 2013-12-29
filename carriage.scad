$fn = 50;
use  <platform.scad>
include <configuration.scad>
include <cogsndogs.scad>

module carriage() {
	a = 6;
	b = 15;
	c = sqrt(a*a+b*b);
	v = atan(b/a);
	echo (c);
	
	difference() {
		union() {
			// Parallell joints
			translate([0,-carriage_offset,-linear_bearing_height/2+platform_thickness/2]) rotate([0,0,90]) parallell_joints();
			
			// Parallell joints middle reinforcement 
			translate([0,-13,-linear_bearing_height/2+platform_thickness/2]) cube([8,10,platform_thickness], center=true);
			
			// Mount plate
			hull() {
				for(i=[-1,1]) {
					translate([i*(smooth_rod_distance+5)/2,-9,0]) cylinder(r=4, h=linear_bearing_height+1, center=true);
				}
			}			
			
			// Bearing mounts
			translate([smooth_rod_distance/2,0,0]) rotate([0,180,0]) linear_bearing_mount();
			translate([-smooth_rod_distance/2,0,0]) linear_bearing_mount();
						
			// Belt mount
			translate([7, 4.5, -15]) rotate([0, 270, 90]) dog_linear(T2, 15, 10, 4);
			
			// Reinforcements linear bearing
			for(i=[-1,1]) {
				translate([i*15,1,0]) rotate([0,0,i*45]) rotate([0,0,45]) {
					difference() {
						cube([15,15,linear_bearing_height+1], center=true);
						translate([7.5,7.5,0]) rotate([0,0,45]) cube([15/cos(45),15/cos(45),linear_bearing_height+1], center=true);
					}
				}
			}			

			// Reinforcements of parallell joints
			translate([-35.9/2,-18,-4])
				for(i=[-1,1]) {

					difference() {
						cube([35.9,a,b]);
						rotate([v,0,0]) translate([-1,0,0]) cube([37,c,c]);
					}
				}
			
		}
		
		for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
			translate([i,0,0]) {
				// Linear bearing
				cylinder(r=linear_bearing_dia/2, h=linear_bearing_height+1, center = true);		
			}
		}
		
		// Taper
		for(i=[-smooth_rod_distance/2,smooth_rod_distance/2]) {
			for(j=[-1,1]) {
				translate([i,0,j*linear_bearing_height/2]) rotate([90-j*90]) cylinder(r1=linear_bearing_dia/2, r2= linear_bearing_dia/2+1, h=2, center=true);	
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

// nophead's polyhole module for better lm8uu-fit
module polyhole(d,h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module linear_bearing_mount() {
	difference() {
		union() {
			cylinder(r=linear_bearing_dia/2+4, h=linear_bearing_height, center=true);
			translate([0,8,0]) cube([linear_bearing_dia,15,linear_bearing_height], center=true);
			
			for(i=[-1,1]) {
				translate([0,12,i*7.5]) {
					// Nut reinforcement
					translate([linear_bearing_dia/2,0,0]) rotate([30,0,0]) rotate([0,-90,0]) cylinder(r=5.1,h=5, $fn=6);//m3_nut(3.8);
					
					//Screw cap head reinforcement
					translate([-linear_bearing_dia/2,0,0]) rotate([0,90,0]) cylinder(r=4.5,h=5);
				}
			}
			
		}
		
		// Linear bearing
		translate([0,0,-(linear_bearing_height+1)/2]) polyhole(linear_bearing_dia, linear_bearing_height+1);
		
		// Cut out
		translate([0,linear_bearing_dia/2,0]) cube([5,linear_bearing_dia+2,linear_bearing_height+1], center=true);
		
		for(i=[-1,1]) {
			translate([0,12,i*7.5]) {
				// Screw hole		
				rotate([0,90,0]) cylinder(r=3.1/2, h=20, center=true);
				// Nut
				translate([linear_bearing_dia/2-3,0,0]) rotate([30,0,0]) rotate([0,90,0]) m3_nut(3.8);
				// Cap head
				translate([-linear_bearing_dia/2-1,0,0]) rotate([0,90,0]) cylinder(r=5.4/2, h=4);
			}
		}
	}
}

linear_bearing_mount();
//carriage
