import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_section.dart';

/// Bytes that aren't an image, to show the frame's error state.
final MemoryImage _brokenImage = MemoryImage(utf8.encode('not an image'));

/// Gallery: cards, list tiles and image frames.
class SurfacesSection extends StatelessWidget {
  /// Creates the section.
  const SurfacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.leafText;
    final secondary = context.leafColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GallerySection(
          title: 'LeafCard',
          children: [
            for (final variant in LeafCardVariant.values)
              LeafCard(
                variant: variant,
                child: Text('${variant.name} card', style: text.body),
              ),
            LeafCard(
              onTap: () => showLeafToast(context, 'Card tapped'),
              semanticLabel: 'Pressable card',
              child: Text(
                'Pressable card — tap me',
                style: text.body.copyWith(color: secondary),
              ),
            ),
          ],
        ),
        GallerySection(
          title: 'LeafListTile',
          children: [
            LeafCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  LeafListTile(
                    title: 'Tomato',
                    subtitle: 'Today · Late blight',
                    leading: const Icon(LeafIcons.leaf),
                    trailing: const StatusBadge(
                      status: LeafStatus.diseased,
                      size: StatusBadgeSize.sm,
                    ),
                    onTap: () => showLeafToast(context, 'Row tapped'),
                  ),
                  LeafListTile(
                    title: 'Settings',
                    subtitle: 'Language, theme',
                    trailing: const Icon(LeafIcons.chevronRight),
                    onTap: () => showLeafToast(context, 'Row tapped'),
                  ),
                  const LeafListTile(title: 'Not pressable'),
                ],
              ),
            ),
          ],
        ),
        const GallerySection(
          title: 'LeafImageFrame',
          description: 'Placeholder when empty; info icon if loading fails.',
          children: [
            Row(
              children: [
                Expanded(child: LeafImageFrame(image: null)),
                LeafGap.sm(),
                Expanded(child: _BrokenImageFrame()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _BrokenImageFrame extends StatelessWidget {
  const _BrokenImageFrame();

  @override
  Widget build(BuildContext context) => LeafImageFrame(image: _brokenImage);
}
