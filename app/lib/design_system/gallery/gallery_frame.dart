import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/theme/leaf_theme.dart';

/// Gallery display settings, applied to the gallery and every page opened
/// from it.
@immutable
class GallerySettings {
  /// Creates settings.
  const GallerySettings({
    this.brightness = Brightness.light,
    this.textScale = 1,
  });

  /// Text scales the gallery can preview.
  static const List<double> textScales = [1, 1.5, 2];

  /// Light or dark theme.
  final Brightness brightness;

  /// System text scale to simulate.
  final double textScale;

  /// A copy with the given fields replaced.
  GallerySettings copyWith({Brightness? brightness, double? textScale}) =>
      GallerySettings(
        brightness: brightness ?? this.brightness,
        textScale: textScale ?? this.textScale,
      );
}

/// Applies [settings] (theme and text scale) to [child].
///
/// Wraps both the gallery and pages pushed from it, because a pushed route
/// builds from the app's theme, not the gallery's local override.
class GalleryFrame extends StatelessWidget {
  /// Creates a frame.
  const GalleryFrame({required this.settings, required this.child, super.key});

  /// What to apply.
  final GallerySettings settings;

  /// The page.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: settings.brightness == Brightness.light
          ? LeafTheme.light()
          : LeafTheme.dark(),
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(settings.textScale)),
        child: child,
      ),
    );
  }
}
