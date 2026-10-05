import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/components/leaf_icon_button.dart';
import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// What kind of message a [LeafNotice] carries.
///
/// None of these use the reserved diagnosis status colours.
enum LeafNoticeTone {
  /// Neutral guidance, in olive. Use this for the low-confidence notice on the
  /// result screen, which keeps the accent away from results (plan §11).
  info,

  /// Caution, in terracotta.
  warning,

  /// No connection, in quiet neutrals.
  offline,

  /// Something failed, in the danger colour.
  error,
}

/// An action shown inside a [LeafNotice].
@immutable
class LeafNoticeAction {
  /// Creates an action, e.g. `LeafNoticeAction('Retry', onPressed: retry)`.
  const LeafNoticeAction(this.label, {required this.onPressed});

  /// Short, verb-first label.
  final String label;

  /// Called when the action is tapped.
  final VoidCallback onPressed;
}

/// An inline message, such as "Low confidence — try another photo" or the
/// offline notice.
///
/// Notices are announced by screen readers when they appear.
class LeafNotice extends StatelessWidget {
  /// Creates a notice.
  const LeafNotice({
    required this.tone,
    required this.message,
    this.title,
    this.action,
    this.onDismiss,
    super.key,
  });

  /// Size of the leading icon.
  static const double iconSize = 20;

  /// Kind of message.
  final LeafNoticeTone tone;

  /// The message itself.
  final String message;

  /// Optional bold first line.
  final String? title;

  /// Optional action, e.g. "Retry".
  final LeafNoticeAction? action;

  /// Shows a close button when set.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = _toneStyle(context.leafColors);
    final text = context.leafText;
    final title = this.title;
    final action = this.action;
    final onDismiss = this.onDismiss;

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: LeafRadii.md,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: LeafSpacing.md,
            top: LeafSpacing.sm,
            bottom: LeafSpacing.sm,
            end: onDismiss == null ? LeafSpacing.md : LeafSpacing.xxs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: iconSize, color: foreground),
              const LeafGap.sm(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: text.titleSmall.copyWith(color: foreground),
                      ),
                    Text(
                      message,
                      style: text.bodySmall.copyWith(color: foreground),
                    ),
                    if (action != null)
                      _NoticeActionButton(action: action, color: foreground),
                  ],
                ),
              ),
              if (onDismiss != null)
                LeafIconButton(
                  icon: LeafIcons.close,
                  semanticLabel: 'Dismiss',
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color, IconData) _toneStyle(LeafColors c) => switch (tone) {
    LeafNoticeTone.info => (
      c.primaryContainer,
      c.onPrimaryContainer,
      LeafIcons.info,
    ),
    LeafNoticeTone.warning => (
      c.accentContainer,
      c.onAccentContainer,
      LeafIcons.warning,
    ),
    LeafNoticeTone.offline => (
      c.surfaceSunken,
      c.textSecondary,
      LeafIcons.offline,
    ),
    LeafNoticeTone.error => (
      c.dangerContainer,
      c.onDangerContainer,
      LeafIcons.error,
    ),
  };
}

/// The action link inside a notice, in the notice's own colour so it reads on
/// every tone.
class _NoticeActionButton extends StatelessWidget {
  const _NoticeActionButton({required this.action, required this.color});

  final LeafNoticeAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LeafPressable(
      onPressed: action.onPressed,
      borderRadius: LeafRadii.sm,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: LeafSpacing.minTouchTarget,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: 1,
          child: Text(
            action.label,
            style: context.leafText.label.copyWith(
              color: color,
              decoration: TextDecoration.underline,
              decorationColor: color,
            ),
          ),
        ),
      ),
    );
  }
}
