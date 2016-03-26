//----------------------------------------------------------------------------

$fn = 36;

epsilon = 0.1;

beam_length = 120;
beam_width = 20;
beam_height = 25; // drill bit is lead this much

beard_length = 90;

//----------------------------------------------------------------------------

translate([0 * beam_width * 1.5, 0, 0])
beam(10);

translate([1 * beam_width * 1.5, 0, 0])
beam(8);

translate([2 * beam_width * 1.5, 0, 0])
beam(3);

translate([3 * beam_width * 1.5, 0, 0])
rotate([90, 0, 0])
beard(beard_length);

//----------------------------------------------------------------------------

module beard(beard_length) {
  beard_width = beam_width * 1.5;
  beard_depth = beam_length / 3;

  roundover = beam_width / 2;
  thickness = (beard_width - beam_width) / 2;

  beam_holder_height = beam_height + thickness;

  difference() {
    cube([beard_width, beard_depth, beam_holder_height]);

    translate([(beard_width - beam_width) / 2, -epsilon, beam_holder_height - beam_height])
    cube([beam_width, beard_depth + 2 * epsilon, beam_height + epsilon]);

    // M5 thread
    translate([0, beard_depth / 5, beam_holder_height - beam_height / 2])
    beard_screw_hole(d = 5, cut_depth = beard_width);

    translate([0, beard_depth / 5 * 4, beam_holder_height - beam_height / 2])
    beard_screw_hole(d = 5, cut_depth = beard_width);
  }

  translate([0, 0, -(beard_length - beam_holder_height)])
  cube([beard_width, thickness * 2, beard_length - beam_holder_height]);

  translate([0, thickness * 2, 0])
  rotate([0, 90, 0])
  difference() {
    cube([roundover, roundover, beard_width]);
    translate([roundover, roundover, -epsilon])
    cylinder(r = roundover, h = beard_width + 2 * epsilon);
  }
}

module beam(d) {
  difference() {
    cube([beam_width, beam_length, beam_height]);

    translate([beam_width / 2, beam_length / 8, 0])
    drill_lead(d = d, l = beam_height);

    // M5 thread
    translate([0, beam_length / 8 * 2, beam_height / 2])
    beam_screw_hole(d = 5, l = beam_length / 8 * 5, cut_depth = beam_width);
  }
}

//----------------------------------------------------------------------------

module beam_screw_hole(d, l, cut_depth) {
  translate([-epsilon, 0, 0])
  rotate([0, 90, 0])
  cylinder(d = d, h = cut_depth + 2 * epsilon);

  translate([-epsilon, l, 0])
  rotate([0, 90, 0])
  cylinder(d = d, h = cut_depth + 2 * epsilon);

  translate([-epsilon, 0, -d / 2])
  cube([cut_depth + 2 * epsilon, l, d]);
}

module beard_screw_hole(d, cut_depth) {
  translate([-epsilon, 0, 0])
  rotate([0, 90, 0])
  cylinder(d = d, h = cut_depth + 2 * epsilon);
}

module drill_lead(d, l) {
  translate([0, 0, -epsilon])
  cylinder(d = d, h = l + 2 * epsilon);
}

//----------------------------------------------------------------------------

nut_sizes = [
  ["m4",  7, 3  ],
  ["m5",  8, 4  ],
  ["m6", 10, 5  ],
  ["m8", 13, 6.5],
  ["m10",17, 8  ],
];

// distance between flats (wrench size)
function nut_width(size)  = nut_sizes[search([size], nut_sizes)[0]][1];
function nut_height(size) = nut_sizes[search([size], nut_sizes)[0]][2];

module nut_head(width, height) {
  side = width / sqrt(3);

  for (i = [0, 60, 120]) {
    rotate([0, 0, i])
    translate([-side / 2, -width / 2, 0])
    cube([side, width, height]);
  }
}

//----------------------------------------------------------------------------
// vim:ft=openscad
