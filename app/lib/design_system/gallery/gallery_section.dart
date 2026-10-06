import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// A titled group of demos in the gallery.
class GallerySection extends StatelessWidget {
  /// Creates a section.
  const GallerySection({
    required this.title,
    required this.children,
    this.description,
    super.key,
  });

  /// Section heading, usually the component name.
  final String title;

  /// One line on when to use it.
  final String? description;

  /// The demos, stacked with a small gap.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = context.leafText;
    final description = this.description;

    return Padding(
      padding: const EdgeInsets.only(bottom: LeafSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(title, style: text.headline)),
          if (description != null) ...[
            const LeafGap.xxs(),
            Text(
              description,
              style: text.bodySmall.copyWith(
                color: context.leafColors.textSecondary,
              ),
            ),
          ],
          const LeafGap.md(),
          for (final (index, child) in children.indexed) ...[
            if (index > 0) const LeafGap.sm(),
            child,
          ],
        ],
      ),
    );
  }
}
