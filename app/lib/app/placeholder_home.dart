import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';

/// Temporary landing screen for release builds until the scan flow lands in
/// Phase 1. Debug builds open the `DesignSystemGallery` instead.
class PlaceholderHome extends StatelessWidget {
  /// Creates the placeholder screen.
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.leafText;

    return LeafScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Leaf Lens', style: text.display),
          const LeafGap.xs(),
          Text(
            'Snap a leaf. Know its health.',
            style: text.body.copyWith(color: context.leafColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
