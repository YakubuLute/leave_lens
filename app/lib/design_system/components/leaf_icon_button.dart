import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// Visual weight of a [LeafIconButton].
enum LeafIconButtonVariant {
  /// No background. For app bars and inline actions.
  ghost,

  /// Quiet sunken background. For actions over content, e.g. on an image.
  tonal,

  /// Solid olive. For a primary icon-only action.
  primary,
}

/// A round, 48 dp icon-only button.
///
/// [semanticLabel] is required: icon-only controls must be named for screen
/// readers. It is also shown as a tooltip on long press or hover.
class LeafIconButton extends StatelessWidget {
  /// Creates an icon button.
  const LeafIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.variant = LeafIconButtonVariant.ghost,
    super.key,
  });

  /// Icon size inside the 48 dp target.
  static const double iconSize = 24;

  /// Icon from `LeafIcons`.
  final IconData icon;

  /// Accessible name, e.g. "Back". Also used as the tooltip.
  final String semanticLabel;

  /// Tap handler. `null` disables the button.
  final VoidCallback? onPressed;

  /// Visual weight.
  final LeafIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colors(context.leafColors);

    return Tooltip(
      message: semanticLabel,
      excludeFromSemantics: true,
      child: LeafPressable(
        onPressed: onPressed,
        borderRadius: LeafRadii.full,
        semanticLabel: semanticLabel,
        child: Opacity(
          opacity: onPressed == null ? LeafPressable.disabledOpacity : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: LeafSpacing.minTouchTarget,
              child: Icon(icon, size: iconSize, color: foreground),
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _colors(LeafColors c) => switch (variant) {
    LeafIconButtonVariant.ghost => (Colors.transparent, c.textPrimary),
    LeafIconButtonVariant.tonal => (c.surfaceSunken, c.textPrimary),
    LeafIconButtonVariant.primary => (c.primary, c.onPrimary),
  };
}
