import 'package:flutter/material.dart';

/// Centralised corner radii to maintain consistent rounded styles throughout the app.
class AppCorners {
  AppCorners._(); // Prevent instantiation

  static const double small = 15.0;
  static const double medium = 16.0;
  static const double large = 26.0;

  static BorderRadius get smallBorder => BorderRadius.circular(small);
  static BorderRadius get mediumBorder => BorderRadius.circular(medium);
  static BorderRadius get largeBorder => BorderRadius.circular(large);
}
