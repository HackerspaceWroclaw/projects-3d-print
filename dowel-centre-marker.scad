//----------------------------------------------------------------------------

translate([-20, 0, 0])
marker(6);

translate([0, 0, 0])
marker(8);

translate([20, 0, 0])
marker(10);

//----------------------------------------------------------------------------

module marker(width, height = 10, pin = 3) {
  rim_width = width + 2 * 2;
  rim_height = 1;

  cylinder(d = width, h = height, $fn = 18);

  translate([0, 0, height])
  cylinder(d = rim_width, h = rim_height, $fn = 18);

  translate([0, 0, height + rim_height])
  cylinder(h = pin, r1 = pin, r2 = 0);
}

//----------------------------------------------------------------------------
// vim:ft=openscad
