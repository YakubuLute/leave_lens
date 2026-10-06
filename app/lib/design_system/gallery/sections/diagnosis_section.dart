import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_section.dart';

/// Gallery: status badges and confidence meters.
class DiagnosisSection extends StatelessWidget {
  /// Creates the section.
  const DiagnosisSection({super.key});

  static const _readings = [
    (LeafStatus.healthy, 0.97),
    (LeafStatus.diseased, 0.72),
    (LeafStatus.uncertain, 0.48),
    (LeafStatus.notALeaf, 0.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GallerySection(
          title: 'StatusBadge',
          description: 'Icon, label and colour — never colour alone.',
          children: [
            for (final size in StatusBadgeSize.values)
              Wrap(
                spacing: LeafSpacing.xs,
                runSpacing: LeafSpacing.xs,
                children: [
                  for (final status in LeafStatus.values)
                    StatusBadge(status: status, size: size),
                ],
              ),
          ],
        ),
        GallerySection(
          title: 'ConfidenceMeter',
          description: 'High ≥ 85%, medium ≥ 60%. Presentation only.',
          children: [
            for (final (status, value) in _readings)
              ConfidenceMeter(value: value, status: status),
          ],
        ),
      ],
    );
  }
}
