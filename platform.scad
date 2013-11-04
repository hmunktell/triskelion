$fn = 50;
include <configuration.scad>
debug = 1;

h = platform_thickness;

cone_height=3.0;
cone_base_radius = 5;
cone_top_radius = 3.25;

m3_washer_width=0.55;
m3_screw_diameter = 3.1;
m3_nut_h = 3.8;
m3_nut_span = 5.5 ;		//Flat-to_flat distance
screw_length = 25;
screw_head_diameter = 5.4;
screw_head_length = 2.85;

ball_collar_width = 7.0;
ball_collar_diameter = 6;

m3_screw_radius = m3_screw_diameter/2;

module cone() {
	translate([0,0,cone_height/2])
		difference() {
			cylinder(h=cone_height, r1=cone_base_radius, r2=cone_top_radius, center=true, $fn=50);
			cylinder(h=cone_height, r=m3_screw_radius, center=true, $fn=50);
		}
}

module m3_capscrew(screw_length) {
	difference() {
		union() {
			translate([0,0,-screw_length]) cylinder(r=m3_screw_diameter/2, h=screw_length);
			cylinder(r=screw_head_diameter/2, h=screw_head_length);
		}
		
		translate([0,0,screw_head_length-1.7]) cylinder(r=(2.7/2)/cos(180/6), h=2, $fn=6);
	}
}

module m3_nut(length){
	cylinder(r=(m3_nut_span/2)/cos(180/6), h=length, $fn=6);
}

module m3_washer(thickness) {
	translate([0,0,thickness/2])
	difference() {
		cylinder(r=5.7/2, h=thickness, center=true);
		cylinder(r=3.2/2, h=thickness+1, center=true);
	}
}

module ball_collar() {
	difference() {
		union() {
			sphere(ball_collar_diameter/2);
			cylinder(r=2,h=ball_collar_width, center=true);
		}
		cylinder(r=m3_screw_radius, h=ball_collar_width+1, center = true);
	}
}

module parallell_joints() {
	offset = arm_distance/2-ball_collar_width/2-m3_washer_width-cone_height;
	block_length = screw_length - ball_collar_width - m3_washer_width - cone_height;
	nut_offset = arm_distance/2-ball_collar_width/2-m3_washer_width-cone_height-block_length;
	washer_offset = arm_distance/2-ball_collar_width/2-m3_washer_width;
	
	difference() {
		union() {
			for (i = [-1,1]) {
				translate([0,-i*offset,0]) rotate([i*90,0,0]) cone();
				translate([cone_base_radius,i*(offset-block_length/2),0]) cube([10,block_length,h], center = true);
				translate([0,i*offset,0]) rotate([i*90,0,0]) cylinder(r=cone_base_radius, h=block_length);
			}
		}
		
		rotate([90,0,0]) cylinder(r=m3_screw_radius, h=arm_distance, center = true);
		
		for (i = [-1,1]) {
			translate([0, i*(nut_offset-1), 0]) rotate([-i*90,0,0]) m3_nut(m3_nut_h+2);
		}
	
		// Trim top and bot
		translate([0,0,platform_thickness]) cube([50,100,platform_thickness], center = true);
		translate([0,0,-platform_thickness]) cube([50,100,platform_thickness], center = true);
	
	}
	
	// For render
	%color([1,0,0,0.5])
	for(i=[-1,1]) {	
		// Screws
		translate([0,-i*(arm_distance/2+ball_collar_width/2),0]) rotate ([i*90,0,0]) m3_capscrew(screw_length);
		
		// Ball link
		translate([0,i*arm_distance/2,0]) rotate([90,0,0])ball_collar();
		
		// Ball link washer
		translate([0,i*washer_offset,0]) rotate([-i*90,0,0]) m3_washer(m3_washer_width);
		
		// Trapped nut
		translate([0,i*(nut_offset+1),0]) rotate([-i*90,0,0]) m3_nut(m3_nut_h);
		
	}
}

module platform() {
	difference() {
		union() {
			for (i = [0,120,240])
				rotate([0,0,i]) translate([-platform_hinge_offset,0,0]) parallell_joints();

			cylinder(r=30, h = h,center = true);
		}
	
		// Center hole
		cylinder(r = 20, h = h+1, center = true);
		
		
		// Holes and nut trap for hotend plate
		for(i = [0,120,240]) {
			rotate(i) translate([25,0,0]) {
				cylinder(r=m3_screw_diameter/2,h=h+1, center = true);
				translate([0,0,h/2-m3_nut_h+0.5]) rotate([0,0,30]) m3_nut(m3_nut_h);
			}
		}
			
		// Holes for hotend fan mounts
		for(i = [60,180,300])
			rotate(i) translate([25,0,0]) cylinder(r=1.5,h=h+1, center = true);
		
	}
	
}

if (debug == 1) {
	difference() {
		platform();
		cylinder(r=50, h = 10);
	}
}
else {
	platform();
}