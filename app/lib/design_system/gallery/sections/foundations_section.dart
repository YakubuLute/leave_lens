import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_section.dart';

/// Gallery: type scale and colour roles.
class FoundationsSection extends StatelessWidget {
  /// Creates the section.
  const FoundationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.leafText;
    final c = context.leafColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GallerySection(
          title: 'Typography',
          description: 'Inter. Headings are heavier and tighter.',
          children: [
            Text('Display', style: text.display),
            Text('Headline', style: text.headline),
            Text('Title', style: text.title),
            Text('Title small', style: text.titleSmall),
            Text('Body — the default for running text.', style: text.body),
            Text('Body small — secondary text.', style: text.bodySmall),
            Text('Label — buttons and tabs', style: text.label),
            Text('Caption — metadata only', style: text.caption),
          ],
        ),
        GallerySection(
          title: 'Colour roles',
          description: 'Status colours are reserved for diagnosis results.',
          children: [
            Wrap(
              spacing: LeafSpacing.xs,
              runSpacing: LeafSpacing.xs,
              children: [
                _Swatch('background', c.background, c.textPrimary),
                _Swatch('surface', c.surface, c.textPrimary),
                _Swatch('surfaceSunken', c.surfaceSunken, c.textPrimary),
                _Swatch('primary', c.primary, c.onPrimary),
                _Swatch(
                  'primaryContainer',
                  c.primaryContainer,
                  c.onPrimaryContainer,
                ),
                _Swatch('accent', c.accent, c.onAccent),
                _Swatch(
                  'accentContainer',
                  c.accentContainer,
                  c.onAccentContainer,
                ),
                _Swatch('danger', c.danger, c.onDanger),
                for (final status in LeafStatus.values)
                  _Swatch(
                    status.name,
                    c.forStatus(status).solid,
                    c.forStatus(status).onSolid,
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color, this.onColor);

  final String name;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: LeafRadii.sm,
        border: Border.all(color: context.leafColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(LeafSpacing.sm),
        child: Text(
          name,
          style: context.leafText.bodySmall.copyWith(color: onColor),
        ),
      ),
    );
  }
}
