import 'package:flutter/material.dart';

/// Design tokens extracted from Stitch mockups.
/// Creative North Star: "The Quiet Confidant" — Intimate Minimalism
/// Color mode: Deep-Ink dark mode with warm espresso tones.
class AppColors {
  AppColors._();

  // ─── Background Hierarchy ───────────────────────────────────────────
  /// Main app background — deep warm espresso (#131313)
  static const backgroundPrimary = Color(0xFF131313);

  /// Card / container backgrounds (#201F1F)
  static const backgroundSurface = Color(0xFF201F1F);

  /// Elevated elements, input field fills (#2A2A2A)
  static const backgroundElevated = Color(0xFF2A2A2A);

  /// Highest surface tier for prominent elements (#353534)
  static const surfaceHighest = Color(0xFF353534);

  /// Bright surface for interactive hover/active states (#3A3939)
  static const surfaceBright = Color(0xFF3A3939);

  /// Subtle section background — one step below surface (#1C1B1B)
  static const surfaceContainerLow = Color(0xFF1C1B1B);

  /// Deepest background layer (#0E0E0E)
  static const surfaceContainerLowest = Color(0xFF0E0E0E);

  /// Surface dim fallback (#131313)
  static const surfaceDim = Color(0xFF131313);

  // ─── Accent: Terra Cotta ────────────────────────────────────────────
  /// Primary CTA accent — warm Terra Cotta (#E07A5F)
  static const accentPrimary = Color(0xFFE07A5F);

  /// Light accent for text highlights and icons (#FFB4A1)
  static const accentPrimaryLight = Color(0xFFFFB4A1);

  /// Fixed primary dim (#FFDBD2)
  static const accentPrimaryFixed = Color(0xFFFFDBD2);

  /// On-primary text/icon color for dark-on-accent (#5D1805)
  static const onPrimary = Color(0xFF5D1805);

  /// On-primary-container — darkest on accent (#5B1604)
  static const onPrimaryContainer = Color(0xFF5B1604);

  // ─── Accent: Sage Green ─────────────────────────────────────────────
  /// Secondary accent — soft sage green (#9FD1B8)
  static const accentSecondary = Color(0xFF9FD1B8);

  /// Secondary container — deep forest chip fill (#1F4F3C)
  static const secondaryContainer = Color(0xFF1F4F3C);

  /// On-secondary text (#023826)
  static const onSecondary = Color(0xFF023826);

  /// On-secondary-container text (#8EC0A7)
  static const onSecondaryContainer = Color(0xFF8EC0A7);

  // ─── Accent: Teal ───────────────────────────────────────────────────
  /// Tertiary accent — vibrant teal (#5EDBC1)
  static const tertiary = Color(0xFF5EDBC1);

  /// Tertiary container — muted active teal (#19A992)
  static const tertiaryContainer = Color(0xFF19A992);

  // ─── Text ───────────────────────────────────────────────────────────
  /// Primary text — warm off-white (#E5E2E1)
  static const textPrimary = Color(0xFFE5E2E1);

  /// Secondary text — warm muted (#DBC1BA)
  static const textSecondary = Color(0xFFDBC1BA);

  /// Muted / placeholder text (#A38B86)
  static const textMuted = Color(0xFFA38B86);

  // ─── Outline & Borders ──────────────────────────────────────────────
  /// Outline (muted warm) (#A38B86)
  static const outline = Color(0xFFA38B86);

  /// Outline variant for ghost borders (#55423E)
  static const outlineVariant = Color(0xFF55423E);

  /// Divider — subtle separator line (#3A3939)
  static const divider = Color(0xFF3A3939);

  // ─── Semantic ───────────────────────────────────────────────────────
  /// Error / destructive text (#FFB4AB)
  static const destructive = Color(0xFFFFB4AB);

  /// Error container (#93000A)
  static const destructiveContainer = Color(0xFF93000A);

  /// On-error text (#690005)
  static const onDestructive = Color(0xFF690005);

  /// Success — reuses tertiary teal
  static const success = Color(0xFF5EDBC1);

  /// Success container
  static const successContainer = Color(0xFF19A992);

  // ─── Inverse (for snackbars, toasts) ────────────────────────────────
  static const inverseSurface = Color(0xFFE5E2E1);
  static const inverseOnSurface = Color(0xFF313030);
  static const inversePrimary = Color(0xFF9A442D);

  // ─── Surface Tint ───────────────────────────────────────────────────
  static const surfaceTint = Color(0xFFFFB4A1);

  // ─── Gradients ──────────────────────────────────────────────────────
  /// Signature CTA gradient (primary → primary container)
  static const ctaGradient = LinearGradient(
    colors: [Color(0xFFFFB4A1), Color(0xFFE07A5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warm ambient glow gradient
  static const warmGlow = RadialGradient(
    colors: [Color(0x33E07A5F), Color(0x00E07A5F)],
    radius: 0.8,
  );
}
