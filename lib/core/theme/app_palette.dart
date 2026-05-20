import 'package:flutter/material.dart';

/// Semantic colors for light / dark themes (via [ThemeExtension]).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentLight,
    required this.accentMuted,
    required this.progressTrack,
    required this.overBudget,
    required this.warning,
    required this.cardShadow,
    required this.budgetGradient,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentLight;
  final Color accentMuted;
  final Color progressTrack;
  final Color overBudget;
  final Color warning;
  final Color cardShadow;
  final LinearGradient budgetGradient;

  static const light = AppPalette(
    background: Color(0xFFFAF8F5),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3F0EB),
    textPrimary: Color(0xFF2D3436),
    textSecondary: Color(0xFF636E72),
    textTertiary: Color(0xFF95A5A6),
    accent: Color(0xFF7A9E7E),
    accentLight: Color(0xFFB8D4BA),
    accentMuted: Color(0xFFE8F0E9),
    progressTrack: Color(0xFFE8E4DE),
    overBudget: Color(0xFFE17055),
    warning: Color(0xFFFDCB6E),
    cardShadow: Color(0x1A2D3436),
    budgetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8FB392), Color(0xFF6B8F6E)],
    ),
  );

  static const dark = AppPalette(
    background: Color(0xFF121514),
    surface: Color(0xFF1E2220),
    surfaceMuted: Color(0xFF2A2F2D),
    textPrimary: Color(0xFFE8ECE9),
    textSecondary: Color(0xFFA8B0AC),
    textTertiary: Color(0xFF6B7570),
    accent: Color(0xFF8FB392),
    accentLight: Color(0xFF5A7A5E),
    accentMuted: Color(0xFF2A3D2C),
    progressTrack: Color(0xFF3A403E),
    overBudget: Color(0xFFE88B73),
    warning: Color(0xFFFDCB6E),
    cardShadow: Color(0x40000000),
    budgetGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF5A7F5E), Color(0xFF3D5C41)],
    ),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentLight,
    Color? accentMuted,
    Color? progressTrack,
    Color? overBudget,
    Color? warning,
    Color? cardShadow,
    LinearGradient? budgetGradient,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentMuted: accentMuted ?? this.accentMuted,
      progressTrack: progressTrack ?? this.progressTrack,
      overBudget: overBudget ?? this.overBudget,
      warning: warning ?? this.warning,
      cardShadow: cardShadow ?? this.cardShadow,
      budgetGradient: budgetGradient ?? this.budgetGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      overBudget: Color.lerp(overBudget, other.overBudget, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      budgetGradient: LinearGradient.lerp(budgetGradient, other.budgetGradient, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
