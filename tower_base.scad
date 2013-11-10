$fn = 50;
include <configuration.scad>
debug = 0;
vitamins = 1;

extrusion_ox = 30;
extrusion_oy = 20;
extrusion_ix = 28;
extrusion_iy = 18;

smooth_rod_dia = 8;
smooth_rod_offset = 60;

h=100;
extrusion_offset_y = 20;

module extrusion(h) {
	difference() {
		cube (size = [extrusion_ox, extrusion_oy, h], center = true);
		cube (size = [extrusion_ix, extrusion_iy, h+10], center = true);
	}
}

module smooth_rod(h, dia){
	cylinder (h = h, r = dia/2, center = true);
}

module tower_base() {
	cube (size = [1, 1, 1]);
	cylinder (h =50 , r =50 );
}

tower_base(50);

if (vitamins) {
	%color([1,0,0,0.5]) {
		translate ([0, extrusion_offset_y, h/2]) extrusion(100);
		for (i = [-1,1]) {
			translate ([i*smooth_rod_offset/2, 0, 0]) {
				translate ([0, 0, h/2]) smooth_rod(h, smooth_rod_dia);
				translate ([0, 0, 30/2]) rotate (a = [0, 0, i*30]) translate ([0, -h/2-10, 0]) rotate (a = [90, 0, 0]) rotate (a = [0, 0, 90]) extrusion(h);
			}
		}
		
	}
}

