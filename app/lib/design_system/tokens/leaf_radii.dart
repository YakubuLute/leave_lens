import 'package:flutter/painting.dart';

/// Corner radii.
///
/// The `BorderRadius` constants cover most uses; the `Radius` constants are for
/// shapes rounded on some corners only, such as bottom sheets.
abstract final class LeafRadii {
  /// 8 — badges, small chips.
  static const Radius smRadius = Radius.circular(8);

  /// 12 — buttons, inputs, list tiles.
  static const Radius mdRadius = Radius.circular(12);

  /// 16 — cards.
  static const Radius lgRadius = Radius.circular(16);

  /// 24 — bottom sheets, image frames.
  static const Radius xlRadius = Radius.circular(24);

  /// Fully rounded — pills, avatars, the scan button.
  static const Radius fullRadius = Radius.circular(999);

  /// 8 on all corners.
  static const BorderRadius sm = BorderRadius.all(smRadius);

  /// 12 on all corners.
  static const BorderRadius md = BorderRadius.all(mdRadius);

  /// 16 on all corners.
  static const BorderRadius lg = BorderRadius.all(lgRadius);

  /// 24 on all corners.
  static const BorderRadius xl = BorderRadius.all(xlRadius);

  /// Fully rounded on all corners.
  static const BorderRadius full = BorderRadius.all(fullRadius);
}
