import 'package:flutter/material.dart';

/// Core colors for the Kinetic Darkroom design system.
///
/// Follows "Tonal Layering" rules where hierarchy is defined by color depth
/// rather than borders or lines.
class AppColors {
  // Brand
  static const Color electricAmber = Color(0xFFFFBF00);
  static const Color kineticCyan = Color(0xFF00FFFF);

  // Backgrounds (Tonal Layering)
  static const Color background = Color(0xFF070707);    // Deepest layer
  static const Color surfaceLow = Color(0xFF0F0F0F);    // Scaffold background
  static const Color surfaceMid = Color(0xFF181818);    // Cards / Bottom Sheets
  static const Color surfaceHigh = Color(0xFF242424);   // Elevated buttons / Modals

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% opacity
  static const Color textTertiary = Color(0x66FFFFFF);  // 40% opacity

  // Utility
  static const Color cardOuterGlow = Color(0x0DFFFFFF); // 5% white for inner glow
}
