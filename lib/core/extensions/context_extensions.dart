import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Convenience extensions on BuildContext for theme access.
extension ContextExtensions on BuildContext {
  // ─── Theme ────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // ─── Screen Dimensions ────────────────────────────────────────────
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get bottomPadding => padding.bottom;
  double get topPadding => padding.top;

  // ─── Responsive Breakpoints ───────────────────────────────────────
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // ─── Snackbar / Toast ─────────────────────────────────────────────
  void showAppToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: isError
                ? AppColors.destructive
                : AppColors.inverseOnSurface,
          ),
        ),
        backgroundColor: isError
            ? AppColors.destructiveContainer
            : AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: AppSpacing.lg,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  /// Show a success toast
  void showSuccessToast(String message) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.inverseOnSurface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: AppSpacing.lg,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
