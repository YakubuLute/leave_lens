import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_typography.dart';

/// Shortcuts for reading design tokens from the current theme.
extension LeafThemeContext on BuildContext {
  /// The active [LeafColors] (light or dark).
  LeafColors get leafColors =>
      Theme.of(this).extension<LeafColors>() ?? _missing('LeafColors');

  /// The active [LeafTypography].
  LeafTypography get leafText =>
      Theme.of(this).extension<LeafTypography>() ?? _missing('LeafTypography');
}

Never _missing(String name) {
  throw FlutterError(
    '$name not found in the current theme.\n'
    'Wrap the app in a MaterialApp using LeafTheme.light() / LeafTheme.dark().',
  );
}
