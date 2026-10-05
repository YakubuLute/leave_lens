import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_button.dart';
import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

enum _LeafStateKind { loading, empty, error }

/// A full-area loading, empty or error state for screens and sections.
///
/// Every async screen must handle these states (app/CLAUDE.md §3). The error
/// state always offers a way to recover, so [LeafStateView.error] requires
/// `onRetry`.
class LeafStateView extends StatelessWidget {
  /// A spinner with an optional message, e.g. "Checking your leaf".
  const LeafStateView.loading({this.message, super.key})
    : _kind = _LeafStateKind.loading,
      title = null,
      icon = null,
      actionLabel = null,
      onAction = null;

  /// An invitation to start, e.g. "No scans yet" with a "Scan a leaf" action.
  const LeafStateView.empty({
    required String this.title,
    this.message,
    this.icon = LeafIcons.leaf,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : _kind = _LeafStateKind.empty;

  /// What went wrong, with a retry action.
  const LeafStateView.error({
    required String this.title,
    required VoidCallback onRetry,
    this.message,
    String retryLabel = 'Try again',
    super.key,
  }) : _kind = _LeafStateKind.error,
       icon = LeafIcons.error,
       actionLabel = retryLabel,
       onAction = onRetry;

  /// Size of the icon in its circle.
  static const double iconSize = 32;

  /// Diameter of the icon circle.
  static const double iconCircleSize = 72;

  final _LeafStateKind _kind;

  /// Headline. Not shown in the loading state.
  final String? title;

  /// Supporting text.
  final String? message;

  /// Icon above the title. Not shown in the loading state.
  final IconData? icon;

  /// Label of the action button.
  final String? actionLabel;

  /// Called by the action button.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final text = context.leafText;
    final title = this.title;
    final message = this.message;
    final icon = this.icon;
    final actionLabel = this.actionLabel;

    return Semantics(
      container: true,
      liveRegion: _kind != _LeafStateKind.empty,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LeafSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_kind == _LeafStateKind.loading)
                CircularProgressIndicator(color: colors.primary)
              else if (icon != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: iconCircleSize,
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: _kind == _LeafStateKind.error
                          ? colors.danger
                          : colors.textSecondary,
                    ),
                  ),
                ),
              if (title != null) ...[
                const LeafGap.lg(),
                Text(title, style: text.title, textAlign: TextAlign.center),
              ],
              if (message != null) ...[
                const LeafGap.xs(),
                Text(
                  message,
                  style: text.body.copyWith(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const LeafGap.xl(),
                LeafButton(
                  label: actionLabel,
                  variant: _kind == _LeafStateKind.error
                      ? LeafButtonVariant.secondary
                      : LeafButtonVariant.primary,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
