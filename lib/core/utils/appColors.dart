import 'package:flutter/material.dart';

/// Centralised delivery-themed colour palette focused on vibrant reds.
class AppColors {
  /// Bold primary red used for key interactive elements.
  static const Color primaryRed = Color(0xFFC62828);

  /// Lighter complementary red for highlights and hover states.
  static const Color secondaryRed = Color(0xFFEF5350);

  /// Warm orange accent for chips, badges, or notifications.
  static const Color accentOrange = Color(0xFFFFA040);

  /// Supporting deep crimson for gradients or emphasis.
  static const Color deepRed = Color(0xFF8E0000);

  /// Soft grey-tinted white for cards on white backgrounds.
  static const Color surface = Color(0xFFFFF5F5);

  /// Default scaffold background (remains pure white).
  static const Color background = Color(0xFFFFFFFF);

  /// Neutral greys for icons and inactive states.
  static const Color grey700 = Color(0xFF4A4A4A);
  static const Color grey600 = Color(0xFF6D6D6D);
  static const Color grey500 = Color(0xFF8F8F8F);
  static const Color grey400 = Color(0xFFB0B0B0);
  static const Color grey300 = Color(0xFFDCDCDC);
  static const Color grey200 = Color(0xFFEDEDED);

  /// Status colours.
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color infoBlue = Color(0xFF1E88E5);

  /// Dark text colour for readability.
  static const Color textDark = Color(0xFF1F1F1F);


  // Legacy aliases (will be removed once codebase fully migrates).
  static Color baseShimmer = Colors.grey.shade300;
  static Color highlightShimmer = Colors.grey.shade100;
  
}
