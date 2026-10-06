import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// Shows a Leaf bottom sheet, e.g. the "Take photo / Choose from gallery"
/// picker, and completes with the value it's closed with.
///
/// Styling (surface, rounded top, drag handle, scrim) comes from `LeafTheme`.
/// Close it with `Navigator.pop(context, value)` from inside [builder].
Future<T?> showLeafSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => LeafSheet(title: title, child: builder(context)),
  );
}

/// The layout inside a Leaf bottom sheet: an optional title and the content,
/// padded to the screen gutters and kept clear of the system bars.
///
/// Usually created by [showLeafSheet].
class LeafSheet extends StatelessWidget {
  /// Creates sheet content.
  const LeafSheet({required this.child, this.title, super.key});

  /// Sheet title.
  final String? title;

  /// Sheet content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = this.title;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          LeafSpacing.gutter,
          0,
          LeafSpacing.gutter,
          LeafSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Semantics(
                header: true,
                child: Text(title, style: context.leafText.title),
              ),
              const LeafGap.md(),
            ],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
