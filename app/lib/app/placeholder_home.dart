import 'package:flutter/material.dart';

import 'package:leaf_lense/design_system/design_system.dart';

/// Temporary landing screen proving the theme is wired up.
///
/// Uses tokens only. Replaced by `DesignSystemGallery` in design-system step 8,
/// then by the scan flow in Phase 1.
class PlaceholderHome extends StatelessWidget {
  /// Creates the placeholder screen.
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final text = context.leafText;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LeafSpacing.gutter),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leaf Lens', style: text.display),
              const SizedBox(height: LeafSpacing.xs),
              Text(
                'Snap a leaf. Know its health.',
                style: text.body.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
