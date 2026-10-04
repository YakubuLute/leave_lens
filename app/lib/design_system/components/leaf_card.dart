import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// Surface style of a [LeafCard].
enum LeafCardVariant {
  /// Raised surface with a hairline border — the default card.
  surface,

  /// Recessed fill, no border. For grouped or secondary content.
  sunken,

  /// Border only, no fill. For the quietest grouping.
  outlined,
}

/// A flat, rounded container for grouped content.
///
/// Pass [onTap] to make the whole card pressable; give it a [semanticLabel]
/// when its content alone doesn't say what tapping does.
class LeafCard extends StatelessWidget {
  /// Creates a card.
  const LeafCard({
    required this.child,
    this.variant = LeafCardVariant.surface,
    this.padding = const EdgeInsets.all(LeafSpacing.md),
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  /// Pressed scale for cards: subtler than buttons because cards are larger.
  static const double pressedScale = 0.98;

  /// Card content.
  final Widget child;

  /// Surface style.
  final LeafCardVariant variant;

  /// Inner padding. Use spacing tokens.
  final EdgeInsetsGeometry padding;

  /// Makes the card pressable.
  final VoidCallback? onTap;

  /// Accessible name for a pressable card.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final card = DecoratedBox(
      decoration: _decoration(context.leafColors),
      child: Padding(padding: padding, child: child),
    );

    final onTap = this.onTap;
    if (onTap == null) return card;

    return LeafPressable(
      onPressed: onTap,
      borderRadius: LeafRadii.lg,
      semanticLabel: semanticLabel,
      pressedScale: pressedScale,
      child: card,
    );
  }

  BoxDecoration _decoration(LeafColors c) => switch (variant) {
    LeafCardVariant.surface => BoxDecoration(
      color: c.surface,
      borderRadius: LeafRadii.lg,
      border: Border.all(color: c.border),
    ),
    LeafCardVariant.sunken => BoxDecoration(
      color: c.surfaceSunken,
      borderRadius: LeafRadii.lg,
    ),
    LeafCardVariant.outlined => BoxDecoration(
      borderRadius: LeafRadii.lg,
      border: Border.all(color: c.border),
    ),
  };
}
