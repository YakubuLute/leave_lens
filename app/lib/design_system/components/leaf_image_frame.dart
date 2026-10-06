import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_motion.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';

/// A rounded frame for a leaf photo.
///
/// Shows a warm placeholder while there's no image, while it loads, and if it
/// fails to load. Give it a [semanticLabel] when the photo carries meaning;
/// without one it's treated as decorative.
class LeafImageFrame extends StatelessWidget {
  /// Creates an image frame.
  const LeafImageFrame({
    required this.image,
    this.aspectRatio = 1,
    this.semanticLabel,
    super.key,
  });

  /// Size of the placeholder icon.
  static const double placeholderIconSize = 40;

  /// The photo, or `null` to show the placeholder.
  final ImageProvider? image;

  /// Width divided by height. Square by default.
  final double aspectRatio;

  /// Describes the photo for screen readers, e.g. "Photo of the scanned leaf".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final image = this.image;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: LeafRadii.xl,
          border: Border.all(color: colors.border),
        ),
        child: ClipRRect(
          borderRadius: LeafRadii.xl,
          child: ColoredBox(
            color: colors.surfaceSunken,
            child: image == null
                ? const _Placeholder(icon: LeafIcons.leaf)
                : Image(
                    image: image,
                    fit: BoxFit.cover,
                    semanticLabel: semanticLabel,
                    excludeFromSemantics: semanticLabel == null,
                    frameBuilder: (context, child, frame, wasSyncLoaded) {
                      if (wasSyncLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: LeafMotion.resolve(context, LeafMotion.base),
                        curve: LeafMotion.standard,
                        child: child,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const _Placeholder(icon: LeafIcons.info),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: LeafImageFrame.placeholderIconSize,
        color: context.leafColors.textMuted,
      ),
    );
  }
}
