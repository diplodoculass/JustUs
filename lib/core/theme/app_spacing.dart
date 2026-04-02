import 'package:flutter/material.dart';

/// 8-point grid spacing scale used consistently throughout the app.
/// Matches the Stitch design system spacing rules.
class AppSpacing {
  AppSpacing._();

  /// 2px — Micro spacing for tight elements
  static const double xxs = 2.0;

  /// 4px — Minimal spacing
  static const double xs = 4.0;

  /// 8px — Small spacing between related elements
  static const double sm = 8.0;

  /// 12px — Between small and medium
  static const double smd = 12.0;

  /// 16px — Standard spacing between elements
  static const double md = 16.0;

  /// 20px — Comfortable spacing
  static const double lg = 20.0;

  /// 24px — Section spacing within a group
  static const double xl = 24.0;

  /// 32px — Between content groups
  static const double xxl = 32.0;

  /// 40px — Major section separation
  static const double xxxl = 40.0;

  /// 48px — Prominent section gaps
  static const double huge = 48.0;

  /// 64px — Hero-level breathing room
  static const double massive = 64.0;

  /// 80px — Maximum editorial spacing
  static const double editorial = 80.0;

  // ─── EdgeInsets Helpers ──────────────────────────────────────────────

  /// Standard horizontal screen padding (24px each side)
  static const screenHorizontal = EdgeInsets.symmetric(horizontal: xl);

  /// Standard screen padding (horizontal 24px, vertical 16px)
  static const screenPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  /// Card internal padding (16px all around)
  static const cardPadding = EdgeInsets.all(md);

  /// Comfortable card padding (20px all around)
  static const cardPaddingLarge = EdgeInsets.all(lg);

  /// Section bottom margin
  static const sectionBottom = EdgeInsets.only(bottom: xxl);
}
