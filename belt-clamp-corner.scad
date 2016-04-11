//----------------------------------------------------------------------------

epsilon = 0.1;
$fn = 36;

width = 40;
diameter = 50;
belt_width = 25;
roundover_offset = 6;
roundover_radius = 20;
bolt_diameter = 5;

pin_diameter = 5;
pin_length = width / 8;

//----------------------------------------------------------------------------

half_corner_with_pins();

//----------------------------------------------------------------------------

module half_corner_with_pins() {
  difference() {
    half_corner();

    translate([diameter / 6, -diameter / 6, 0])
    translate([0, 0, width / 2 - pin_length])
    cylinder(d = pin_diameter, h = pin_length + epsilon);
  }

  translate([-diameter / 6, diameter / 6, 0])
  translate([0, 0, width / 2])
  cylinder(d = pin_diameter * .95, h = pin_length);
}

//----------------------------------------------------------------------------

module half_corner() {
  difference() {
    corner();

    translate([-diameter / 2 - epsilon, -diameter / 2 - epsilon, width / 2])
    cube([diameter + 2 * epsilon, diameter + 2 * epsilon, width / 2 + epsilon]);
  }
}

//----------------------------------------------------------------------------

module corner() {
  difference() {
    body();
    corner_cutoff();
    bolt_cutoff();
  }
}

//----------------------------------------------------------------------------

module body() {
  base_height = (width - belt_width) / 2;

  cylinder(d = diameter, h = base_height);

  translate([0, 0, width - base_height])
  cylinder(d = diameter, h = base_height);

  translate([0, 0, base_height])
  intersection() {
    translate([roundover_offset, roundover_offset, 0])
    cylinder(r = roundover_radius, h = belt_width);

    cylinder(d = diameter, h = belt_width);
  }
}

module corner_cutoff() {
  translate([0, 0, -epsilon])
  cube([diameter, diameter, width + 2 * epsilon]);
}

module bolt_cutoff() {
  x = sqrt(2) * roundover_offset;
  y = roundover_radius - x;
  q = diameter / 2 - y;
  bolt_offset = (y + q / 2) / sqrt(2);

  translate([-bolt_offset, -bolt_offset, 0])
  translate([0, 0, -epsilon])
  cylinder(d = bolt_diameter, h = width + 2 * epsilon);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
