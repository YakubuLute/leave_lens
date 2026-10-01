import 'package:flutter/widgets.dart';

/// Animation durations and curves.
abstract final class LeafMotion {
  /// 120 ms — press feedback.
  static const Duration fast = Duration(milliseconds: 120);

  /// 200 ms — state changes.
  static const Duration base = Duration(milliseconds: 200);

  /// 320 ms — page transitions and reveals.
  static const Duration slow = Duration(milliseconds: 320);

  /// Default easing for most motion.
  static const Curve standard = Curves.easeOutCubic;

  /// Slight overshoot, used for the result reveal.
  static const Curve emphasized = Curves.easeOutBack;

  /// Returns [duration], or [Duration.zero] when the user has asked the
  /// platform to reduce motion.
  static Duration resolve(BuildContext context, Duration duration) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return reduceMotion ? Duration.zero : duration;
  }
}
