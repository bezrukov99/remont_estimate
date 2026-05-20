import 'package:flutter/material.dart';

/// Light palette constants (e.g. PDF export). Prefer [AppPaletteContext.palette] in UI.
abstract final class AppColors {
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F0EB);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFF95A5A6);
  static const Color accent = Color(0xFF7A9E7E);
  static const Color accentLight = Color(0xFFB8D4BA);
  static const Color accentMuted = Color(0xFFE8F0E9);
  static const Color progressTrack = Color(0xFFE8E4DE);
  static const Color overBudget = Color(0xFFE17055);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color cardShadow = Color(0x1A2D3436);
  static const LinearGradient budgetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8FB392), Color(0xFF6B8F6E)],
  );
}
