import 'package:flutter/material.dart';

/// Border radius tokens matching the Stitch design mockups.
/// Roundness setting: ROUND_EIGHT (8px base).
class AppRadius {
  AppRadius._();

  /// 4px — Subtle rounding for small internal elements
  static const double xs = 4.0;

  /// 8px — Standard rounding for chips, small cards
  static const double sm = 8.0;

  /// 12px — Main card and button rounding
  static const double md = 12.0;

  /// 16px — Prominent card rounding
  static const double lg = 16.0;

  /// 24px — Large card and bottom sheet rounding
  static const double xl = 24.0;

  /// 32px — Extra large rounding
  static const double xxl = 32.0;

  /// 100px — Pill shape for buttons and chips
  static const double pill = 100.0;

  // ─── BorderRadius Helpers ───────────────────────────────────────────

  static final borderRadiusXs = BorderRadius.circular(xs);
  static final borderRadiusSm = BorderRadius.circular(sm);
  static final borderRadiusMd = BorderRadius.circular(md);
  static final borderRadiusLg = BorderRadius.circular(lg);
  static final borderRadiusXl = BorderRadius.circular(xl);
  static final borderRadiusXxl = BorderRadius.circular(xxl);
  static final borderRadiusPill = BorderRadius.circular(pill);

  /// Bottom sheet top corners (24px top-left, 24px top-right)
  static final bottomSheet = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
}
