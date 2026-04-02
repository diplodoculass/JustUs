import 'package:flutter/services.dart';

/// Haptic feedback utilities for the app.
/// Used primarily in Thumb Kiss and interaction feedback.
class HapticUtils {
  HapticUtils._();

  /// Light tap feedback — card press, minor interactions
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact — button presses, thumb kiss press
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact — thumb kiss connected, major events
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click — toggle, chip selection
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate pattern — used for rhythmic thumb kiss connection
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }
}
