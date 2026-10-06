import 'package:flutter/widgets.dart';

/// Every icon the app uses, by meaning rather than by shape.
///
/// Features reference `LeafIcons.camera`, never an icon font directly, so the
/// icon set can be swapped in this one file (plan §3.7).
///
/// Icons come from Phosphor Icons (regular weight, MIT), bundled as
/// `assets/fonts/Phosphor-Regular.ttf`. To add one, look up its codepoint in
/// Phosphor's catalogue and add a constant below. Constants must stay `const`
/// so release builds can tree-shake the font down to the icons used.
abstract final class LeafIcons {
  static const String _family = 'Phosphor';

  // Navigation.
  /// Go back one screen. Mirrors in right-to-left layouts.
  static const IconData back = IconData(
    0xe058,
    fontFamily: _family,
    matchTextDirection: true,
  );

  /// Close a sheet, dialog or notice.
  static const IconData close = IconData(0xe4f6, fontFamily: _family);

  /// Overflow menu.
  static const IconData more = IconData(0xe1fe, fontFamily: _family);

  /// Leads to another screen, e.g. a list row. Mirrors in right-to-left
  /// layouts.
  static const IconData chevronRight = IconData(
    0xe13a,
    fontFamily: _family,
    matchTextDirection: true,
  );

  // Scanning.
  /// Take a photo.
  static const IconData camera = IconData(0xe10e, fontFamily: _family);

  /// Pick a photo from the gallery.
  static const IconData gallery = IconData(0xe2ca, fontFamily: _family);

  /// The app's leaf motif.
  static const IconData leaf = IconData(0xe2da, fontFamily: _family);

  // Status and feedback.
  /// Healthy result, success.
  static const IconData healthy = IconData(0xe182, fontFamily: _family);

  /// Diseased result.
  static const IconData diseased = IconData(0xe4e0, fontFamily: _family);

  /// Uncertain result, informational notices.
  static const IconData info = IconData(0xe2ce, fontFamily: _family);

  /// The photo isn't a leaf.
  static const IconData notALeaf = IconData(0xebae, fontFamily: _family);

  /// A caution notice. Same glyph as [diseased], kept as its own name so the
  /// two meanings can diverge.
  static const IconData warning = IconData(0xe4e0, fontFamily: _family);

  /// Something went wrong.
  static const IconData error = IconData(0xe4e2, fontFamily: _family);

  /// No internet connection.
  static const IconData offline = IconData(0xe4f2, fontFamily: _family);

  // Actions.
  /// Delete something.
  static const IconData delete = IconData(0xe4a6, fontFamily: _family);
}
