import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';
import 'package:leaf_lens/design_system/tokens/leaf_status.dart';

/// Size of a [StatusBadge].
enum StatusBadgeSize {
  /// Compact, for list rows such as scan history.
  sm,

  /// Default, for the result screen.
  md,
}

/// A diagnosis status shown as icon, label and colour together, never colour
/// alone (app/CLAUDE.md §1 rule 4).
class StatusBadge extends StatelessWidget {
  /// Creates a badge for [status].
  const StatusBadge({
    required this.status,
    this.label,
    this.size = StatusBadgeSize.md,
    super.key,
  });

  /// The status to show.
  final LeafStatus status;

  /// Overrides the default label, e.g. for translations.
  final String? label;

  /// Badge size.
  final StatusBadgeSize size;

  /// Icon size for [StatusBadgeSize.sm].
  static const double smIconSize = 16;

  /// Icon size for [StatusBadgeSize.md].
  static const double mdIconSize = 18;

  /// The label shown when [label] is `null`.
  static String defaultLabel(LeafStatus status) => switch (status) {
    LeafStatus.healthy => 'Healthy',
    LeafStatus.diseased => 'Diseased',
    LeafStatus.uncertain => 'Not sure',
    LeafStatus.notALeaf => 'Not a leaf',
  };

  /// The icon for [status].
  static IconData iconFor(LeafStatus status) => switch (status) {
    LeafStatus.healthy => LeafIcons.healthy,
    LeafStatus.diseased => LeafIcons.diseased,
    LeafStatus.uncertain => LeafIcons.info,
    LeafStatus.notALeaf => LeafIcons.notALeaf,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors.forStatus(status);
    final text = context.leafText;
    final label = this.label ?? defaultLabel(status);
    final (iconSize, style, padding) = switch (size) {
      StatusBadgeSize.sm => (
        smIconSize,
        text.bodySmall.copyWith(fontWeight: FontWeight.w600),
        const EdgeInsets.symmetric(
          horizontal: LeafSpacing.xs,
          vertical: LeafSpacing.xxs,
        ),
      ),
      StatusBadgeSize.md => (
        mdIconSize,
        text.label,
        const EdgeInsets.symmetric(
          horizontal: LeafSpacing.sm,
          vertical: LeafSpacing.xs,
        ),
      ),
    };

    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.bg, borderRadius: LeafRadii.sm),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconFor(status), size: iconSize, color: colors.fg),
              const LeafGap.xxs(),
              Flexible(
                child: Text(label, style: style.copyWith(color: colors.fg)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
