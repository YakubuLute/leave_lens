import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// A row for lists such as scan history or settings.
///
/// Pass [onTap] to make the whole row pressable. Typical [trailing] widgets
/// are a `StatusBadge` or an `Icon(LeafIcons.chevronRight)`.
class LeafListTile extends StatelessWidget {
  /// Creates a list row.
  const LeafListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// Pressed scale for rows: subtle, like cards.
  static const double pressedScale = 0.98;

  /// Main text.
  final String title;

  /// Supporting text under the title.
  final String? subtitle;

  /// Widget before the text, e.g. an icon or thumbnail.
  final Widget? leading;

  /// Widget after the text, e.g. a status badge or chevron.
  final Widget? trailing;

  /// Makes the row pressable.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final text = context.leafText;
    final subtitle = this.subtitle;
    final leading = this.leading;
    final trailing = this.trailing;

    final row = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: LeafSpacing.minTouchTarget + LeafSpacing.xs,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LeafSpacing.md,
          vertical: LeafSpacing.sm,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(color: colors.textSecondary),
                child: leading,
              ),
              const LeafGap.sm(),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: text.titleSmall),
                  if (subtitle != null) ...[
                    const LeafGap.xxs(),
                    Text(
                      subtitle,
                      style: text.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const LeafGap.sm(),
              IconTheme.merge(
                data: IconThemeData(color: colors.textMuted),
                child: trailing,
              ),
            ],
          ],
        ),
      ),
    );

    final onTap = this.onTap;
    if (onTap == null) return row;

    return LeafPressable(
      onPressed: onTap,
      borderRadius: LeafRadii.md,
      pressedScale: pressedScale,
      child: row,
    );
  }
}
