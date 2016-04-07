//----------------------------------------------------------------------------

epsilon = 0.1;
$fn = 36;
// nut sizes:
//   M5   8mm  4mm thick
//   M6  10mm  5mm thick
//   M8  13mm  6.5mm thick

washer_thickness = 1;
washer_diameter = 16;

fastener_bolt = 8;
fastener_nut_size = 13;
fastener_nut_height = 6.5;

belt_bolt = 5;

belt_wing_thickness = 3; // also: railing

mobile_mount_width = 30; // including 2 * belt_wing_thickness
mobile_mount_height = 20;
mobile_mount_support_thickness = 16;
mobile_mount_wing_length = 24;

square_mount_support_radius = 10;

square_mount_side_thickness = 4;
square_mount_bed_length = 40;
square_mount_wing_length = 24;
square_mount_wing_height = square_mount_support_radius;
square_mount_railing_height = mobile_mount_height / 2 - belt_wing_thickness / 2;

square_mount_belt_side_length = square_mount_support_radius + square_mount_wing_length;

tolerance = 1;

//----------------------------------------------------------------------------

//translate([0, 45, 0])
//rotate([0, 0, 90])
//color("lightgrey") bolt(100, size = fastener_bolt, nut = [fastener_nut_size * 3, fastener_nut_height]);
//
//color("blue") {
//  translate([0, 6.5 - washer_thickness, 0])
//  washer(d = washer_diameter);
//
//  translate([0, -(8 - 6.5 + washer_thickness), 0])
//  rotate([-90, 0, 0])
//  nut_head(13, 8); // self-locking nut
//}

translate([0, 0, 0])
mobile_mount();

translate([0, 30, 0])
square_mount();

//----------------------------------------------------------------------------

module square_mount() {
  width = mobile_mount_width + 2 * belt_wing_thickness + 2 * tolerance;

  fastener_bolt_head_height = mobile_mount_height;
  fastener_bolt_head_width = mobile_mount_width - 2 * belt_wing_thickness;
  fastener_bolt_head_depth = mobile_mount_support_thickness;
  belt_side_length = square_mount_wing_length + square_mount_support_radius;

  translate([-width / 2, 0, -fastener_bolt_head_height / 2]) {
    // bed for mobile mount
    translate([0, 0, -square_mount_side_thickness]) {
      cube([width, square_mount_bed_length, square_mount_side_thickness]);

      cube([belt_wing_thickness, square_mount_bed_length, square_mount_railing_height]);

      translate([width - belt_wing_thickness, 0, 0])
      cube([belt_wing_thickness, square_mount_bed_length, square_mount_railing_height]);
    }

    // side for belt
    translate([0, square_mount_bed_length - square_mount_side_thickness, 0])
    translate([0, -(square_mount_support_radius / 8), -(square_mount_support_radius / 8)])
    rotate([-90, 0, 0]) {
      cube([width, belt_side_length, square_mount_side_thickness]);

      translate([0, 0, square_mount_side_thickness - square_mount_support_radius / 8])
      difference() {
        union() {
          cube([belt_wing_thickness, square_mount_wing_length, square_mount_wing_height]);
          translate([width - belt_wing_thickness, 0, 0])
          cube([belt_wing_thickness, square_mount_wing_length, square_mount_wing_height]);
        }

        translate([0, square_mount_wing_length - 1.5 * belt_bolt, square_mount_wing_height / 2])
        rotate([0, 90, 0])
        translate([0, 0, -epsilon])
        cylinder(d = belt_bolt, h = width + 2 * epsilon);
      }
    }

    difference() {
      union() {
        // support
        translate([0, square_mount_bed_length - square_mount_support_radius / 8, 0])
        rotate([0, 90, 0])
        difference() {
          translate([square_mount_support_radius / 8, -square_mount_support_radius / 8, 0])
          cylinder(r = square_mount_support_radius, h = width);
          translate([0, -square_mount_support_radius * 2, -epsilon])
          cube([square_mount_support_radius * 2, square_mount_support_radius * 2, width + 2 * epsilon]);
        }

        // head for fastener bolt
        translate([(width - fastener_bolt_head_width) / 2,
                   (square_mount_bed_length - fastener_bolt_head_depth / 2),
                   0])
        cube([fastener_bolt_head_width, fastener_bolt_head_depth, fastener_bolt_head_height + tolerance]);
      }

      translate([0, 0, tolerance])
      translate([0, (square_mount_bed_length + fastener_bolt_head_depth / 2), 0])
      translate([width / 2, -fastener_bolt_head_depth / 2, fastener_bolt_head_height / 2])
      rotate([0, 0, 90])
      bolt(fastener_bolt_head_depth + 2 * epsilon, size = fastener_bolt, nut = [fastener_nut_size, fastener_nut_height + epsilon]);
    }
  }
}

module mobile_mount() {
  translate([-mobile_mount_width / 2, 0, -mobile_mount_height / 2])
  difference() {
    union() {
      cube([mobile_mount_width, mobile_mount_support_thickness, mobile_mount_height]);

      translate([0, -mobile_mount_wing_length, 0])
      cube([belt_wing_thickness, mobile_mount_wing_length, mobile_mount_height]);

      translate([mobile_mount_width - belt_wing_thickness, -mobile_mount_wing_length, 0])
      cube([belt_wing_thickness, mobile_mount_wing_length, mobile_mount_height]);
    }

    translate([mobile_mount_width / 2, -epsilon, mobile_mount_height / 2])
    washer(d = washer_diameter + 1, hole = 0, thickness = fastener_nut_height + epsilon);

    translate([mobile_mount_width / 2, -epsilon, mobile_mount_height / 2])
    rotate([-90, 0, 0])
    cylinder(d = fastener_bolt, h = mobile_mount_support_thickness + 2 * epsilon);

    translate([0, -(mobile_mount_wing_length - mobile_mount_height / 2), 0])
    translate([mobile_mount_width / 2, 0, mobile_mount_height / 2])
    bolt(mobile_mount_width + 20, size = belt_bolt);
  }
}

//----------------------------------------------------------------------------

module bolt(length, size = 6, nut = [10, 5]) {
  translate([length / 2, 0, 0])
  rotate([0, -90, 0]) {
    cylinder(d = size, h = length);
    nut_head(width = nut[0], height = nut[1]);
  }
}

module washer(d, hole = 6, thickness = washer_thickness) {
  rotate([-90, 0, 0])
  difference() {
    cylinder(d = d, h = thickness);

    if (hole > 0) {
      translate([0, 0, -epsilon])
      cylinder(d = hole + 0.5, h = thickness + 2 * epsilon);
    }
  }
}

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
