import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';

/// Shows a short confirmation at the bottom of the screen, e.g. "Scan saved".
///
/// Stays for Flutter's default 4 seconds and replaces any toast already
/// showing. Styling (floating, inverted colours) comes from `LeafTheme`. Use
/// for brief confirmations only; errors that need action belong in a
/// `LeafNotice` or `LeafStateView`.
void showLeafToast(
  BuildContext context,
  String message, {
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  assert(
    (actionLabel == null) == (onAction == null),
    'actionLabel and onAction must be given together',
  );

  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  final colors = context.leafColors;

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: colors.background),
            const LeafGap.sm(),
          ],
          Expanded(child: Text(message)),
        ],
      ),
      action: actionLabel == null || onAction == null
          ? null
          : SnackBarAction(label: actionLabel, onPressed: onAction),
    ),
  );
}
