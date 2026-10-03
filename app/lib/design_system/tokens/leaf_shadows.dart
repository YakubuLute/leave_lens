import 'package:flutter/painting.dart';

import 'package:leaf_lense/design_system/tokens/leaf_colors.dart';

/// Elevation tokens.
///
/// Surfaces are flat by default and separated by `LeafColors.border`. The single
/// [floating] shadow is reserved for the scan button, bottom sheets and toasts.
abstract final class LeafShadows {
  /// Soft, warm-tinted shadow for floating elements.
  static List<BoxShadow> floating(LeafColors colors) => [
    BoxShadow(color: colors.shadow, offset: const Offset(0, 8), blurRadius: 24),
  ];
}
