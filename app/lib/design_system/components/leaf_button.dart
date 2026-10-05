import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// Visual weight of a [LeafButton].
enum LeafButtonVariant {
  /// Solid olive. One per screen, for the main action.
  primary,

  /// Outlined. For secondary actions next to a primary one.
  secondary,

  /// Text only. For low-emphasis actions.
  ghost,

  /// Solid danger colour. For destructive actions such as deleting history.
  danger,
}

/// Height of a [LeafButton].
enum LeafButtonSize {
  /// 48 dp — the default.
  md,

  /// 56 dp — for the main call to action on a screen.
  lg,
}

/// The Leaf Lens button.
///
/// Passing `null` to [onPressed] disables it (dimmed to 50%). While
/// [isLoading] it shows a spinner, ignores taps and keeps its size.
class LeafButton extends StatelessWidget {
  /// Creates a button.
  const LeafButton({
    required this.label,
    required this.onPressed,
    this.variant = LeafButtonVariant.primary,
    this.size = LeafButtonSize.md,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    super.key,
  });

  /// Size of the leading icon and the loading spinner.
  static const double iconSize = 20;

  /// Short, verb-first label, e.g. "Take photo".
  final String label;

  /// Tap handler. `null` disables the button.
  final VoidCallback? onPressed;

  /// Visual weight.
  final LeafButtonVariant variant;

  /// Height.
  final LeafButtonSize size;

  /// Optional leading icon from `LeafIcons`.
  final IconData? icon;

  /// Shows a spinner and blocks taps without dimming.
  final bool isLoading;

  /// Stretches to the full available width.
  final bool isExpanded;

  double get _minHeight => switch (size) {
    LeafButtonSize.md => LeafSpacing.minTouchTarget,
    LeafButtonSize.lg => LeafSpacing.minTouchTarget + LeafSpacing.xs,
  };

  @override
  Widget build(BuildContext context) {
    final style = _LeafButtonStyle.of(variant, context.leafColors);
    final isDisabled = onPressed == null && !isLoading;

    final button = LeafPressable(
      onPressed: isLoading ? null : onPressed,
      borderRadius: LeafRadii.md,
      semanticLabel: isLoading ? '$label, loading' : null,
      child: Opacity(
        opacity: isDisabled ? LeafPressable.disabledOpacity : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: LeafRadii.md,
            border: style.border,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _minHeight,
              minWidth: LeafSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: variant == LeafButtonVariant.ghost
                    ? LeafSpacing.md
                    : LeafSpacing.xl,
                vertical: LeafSpacing.xs,
              ),
              child: _LeafButtonContent(
                label: label,
                icon: icon,
                color: style.foreground,
                isLoading: isLoading,
                isExpanded: isExpanded,
              ),
            ),
          ),
        ),
      ),
    );

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class _LeafButtonContent extends StatelessWidget {
  const _LeafButtonContent({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.isExpanded,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final row = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: LeafButton.iconSize, color: color),
          const LeafGap.xs(),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.leafText.label.copyWith(color: color),
          ),
        ),
      ],
    );

    // The label stays laid out (but hidden) while loading so the button
    // keeps its width.
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility.maintain(visible: !isLoading, child: row),
        if (isLoading)
          SizedBox.square(
            dimension: LeafButton.iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          ),
      ],
    );
  }
}

/// Colours for one [LeafButtonVariant].
class _LeafButtonStyle {
  const _LeafButtonStyle({
    required this.background,
    required this.foreground,
    this.border,
  });

  factory _LeafButtonStyle.of(LeafButtonVariant variant, LeafColors c) =>
      switch (variant) {
        LeafButtonVariant.primary => _LeafButtonStyle(
          background: c.primary,
          foreground: c.onPrimary,
        ),
        LeafButtonVariant.secondary => _LeafButtonStyle(
          background: Colors.transparent,
          foreground: c.primary,
          border: Border.all(color: c.borderStrong),
        ),
        LeafButtonVariant.ghost => _LeafButtonStyle(
          background: Colors.transparent,
          foreground: c.primary,
        ),
        LeafButtonVariant.danger => _LeafButtonStyle(
          background: c.danger,
          foreground: c.onDanger,
        ),
      };

  final Color background;
  final Color foreground;
  final BoxBorder? border;
}
