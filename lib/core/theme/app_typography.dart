import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale matching the Stitch design system.
///
/// Editorial Pair:
/// - **Manrope** — Display & Headlines (geometric, premium authority)
/// - **Inter** — Body & UI text (readable, invisible neutrality)
class AppTypography {
  AppTypography._();

  // ─── Display (Manrope) ──────────────────────────────────────────────

  /// Display Large — Celebratory moments, hero greetings
  /// 36px, Bold (700), tracking -0.5
  static TextStyle get displayLarge => GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  /// Display Medium — Meaningful personal moments
  /// 32px, Bold (700), tracking -0.25
  static TextStyle get displayMedium => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// Display Small — Streak numbers, key stats
  /// 28px, SemiBold (600)
  static TextStyle get displaySmall => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // ─── Headline (Manrope) ─────────────────────────────────────────────

  /// Headline Large — Screen titles
  /// 24px, SemiBold (600)
  static TextStyle get headlineLarge => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Headline Medium — Section titles
  /// 20px, SemiBold (600)
  static TextStyle get headlineMedium => GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  /// Headline Small — Sub-section titles
  /// 18px, Medium (500)
  static TextStyle get headlineSmall => GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ─── Title (Inter) ──────────────────────────────────────────────────

  /// Title Large — Card titles, list headers
  /// 18px, SemiBold (600)
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Title Medium — Secondary titles
  /// 16px, SemiBold (600)
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  /// Title Small — Tertiary titles, button labels
  /// 14px, SemiBold (600)
  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ─── Body (Inter) ───────────────────────────────────────────────────

  /// Body Large — Journal entries, personal messages
  /// 16px, Regular (400)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: AppColors.textPrimary,
  );

  /// Body Medium — Standard content text
  /// 14px, Regular (400)
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Body Small — Secondary content
  /// 12px, Regular (400)
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ─── Label (Inter) ──────────────────────────────────────────────────

  /// Label Large — Prominent labels
  /// 14px, Medium (500)
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Label Medium — Standard labels
  /// 12px, Medium (500)
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.3,
    color: AppColors.textSecondary,
  );

  /// Label Small — Metadata, timestamps, architectural feel
  /// 11px, Medium (500), tracking 0.5px
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textMuted,
  );

  // ─── TextTheme Builder ──────────────────────────────────────────────

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
