import 'package:flutter/material.dart';

/// Playful, welcoming color tokens used across the app.
class AppColors {
  AppColors._();

  // ─── Background Hierarchy ────────────────────────────────────────────
  static const backgroundPrimary = Color(0xFFFFF5FD);
  static const backgroundSurface = Color(0xFFFFFFFF);
  static const backgroundElevated = Color(0xFFF7EBFF);
  static const surfaceHighest = Color(0xFFFFE2F5);
  static const surfaceBright = Color(0xFFFFD9F1);
  static const surfaceContainerLow = Color(0xFFFFEEFA);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceDim = Color(0xFFFBE9F8);

  // ─── Accent: Bubblegum Pink ──────────────────────────────────────────
  static const accentPrimary = Color(0xFFFF4D8D);
  static const accentPrimaryLight = Color(0xFFFF8FB9);
  static const accentPrimaryFixed = Color(0xFFFFD6E7);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF4A0A25);

  // ─── Accent: Aqua Mint ───────────────────────────────────────────────
  static const accentSecondary = Color(0xFF00AFA2);
  static const secondaryContainer = Color(0xFFC9FFF8);
  static const onSecondary = Color(0xFF003833);
  static const onSecondaryContainer = Color(0xFF00524A);

  // ─── Accent: Sunny Yellow ────────────────────────────────────────────
  static const tertiary = Color(0xFFFFB703);
  static const tertiaryContainer = Color(0xFFFFE8A8);

  // ─── Text ────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF2B2140);
  static const textSecondary = Color(0xFF5A4C74);
  static const textMuted = Color(0xFF8F82A5);

  // ─── Outline & Borders ───────────────────────────────────────────────
  static const outline = Color(0xFFCDBCE0);
  static const outlineVariant = Color(0xFFE7DDF1);
  static const divider = Color(0xFFEDE4F6);

  // ─── Semantic ────────────────────────────────────────────────────────
  static const destructive = Color(0xFFD7263D);
  static const destructiveContainer = Color(0xFFFFD9DF);
  static const onDestructive = Color(0xFF5A0010);
  static const success = Color(0xFF20BF6B);
  static const successContainer = Color(0xFFD9FBE8);

  // ─── Inverse (for snackbars, toasts) ─────────────────────────────────
  static const inverseSurface = Color(0xFF2B2140);
  static const inverseOnSurface = Color(0xFFFFFFFF);
  static const inversePrimary = Color(0xFFFF79A8);

  // ─── Surface Tint ────────────────────────────────────────────────────
  static const surfaceTint = Color(0xFFFF8FB9);

  // ─── Gradients ───────────────────────────────────────────────────────
  static const ctaGradient = LinearGradient(
    colors: [
      Color(0xFFFF4D8D),
      Color(0xFFFF8A3D),
      Color(0xFFFFD93D),
      Color(0xFF14C7B7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const playfulGlow = RadialGradient(
    colors: [Color(0x40FF4D8D), Color(0x00FF4D8D)],
    radius: 0.8,
  );
}
