//----------------------------------------------------------------------------

$fn = 36;

epsilon = 0.1;

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

//----------------------------------------------------------------------------

handle_thickness = 6;

//translate([50, 0, 0])
//knob(30, handle_thickness, "m5", roundover = 5);

translate([0, 0, 0])
knob(30, handle_thickness, "m6", roundover = 5);

translate([50, 0, 0])
knob(40, handle_thickness, "m8", roundover = 5);

//----------------------------------------------------------------------------

module knob(handle_diameter, handle_thickness, nut_size, roundover = 0) {
  nut_width = nut_width(nut_size);
  nut_height = nut_height(nut_size);
  shaft_width = nut_width * 2;
  shaft_height = nut_height;
  nut_socket_depth = nut_height * 0.90;

  mirror([0, 0, 1])
  difference() {
    union() {
      handle(handle_diameter, handle_thickness);

      translate([0, 0, -shaft_height])
      shaft(shaft_width, shaft_height);

      if (roundover > 0) {
        translate([0, 0, -roundover / 2])
        shaft_transition(shaft_width, roundover);
      }
    }

    translate([0, 0, -(shaft_height + epsilon)])
    nut_head(nut_width, nut_socket_depth + epsilon);
  }
}

//----------------------------------------------------------------------------

module shaft_transition(d, r) {
  rotate_extrude()
  difference() {
    translate([d / 2, 0])
    square([r / 2, r / 2]);

    translate([d / 2 + r / 2, 0])
    circle(d = r);
  }
}

//----------------------------------------------------------------------------

module handle(diameter, thickness, shaft_diameter, shaft_length) {
  cylinder(d = diameter, h = thickness);

  for (i = [0:45:360]) {
    rotate([0, 0, i])
    translate([diameter / 2.25, 0, 0])
    cylinder(d = diameter / 4, h = thickness);
  }
}

//----------------------------------------------------------------------------

module shaft(diameter, length) {
  cylinder(d = diameter, h = length);
}

//----------------------------------------------------------------------------

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
