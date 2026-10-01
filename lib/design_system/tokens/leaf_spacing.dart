/// Spacing scale on a 4 pt grid.
///
/// Use these for every padding, margin and gap. A literal like
/// `EdgeInsets.all(13)` in feature code is a bug (CLAUDE.md §2).
abstract final class LeafSpacing {
  /// 4
  static const double xxs = 4;

  /// 8
  static const double xs = 8;

  /// 12
  static const double sm = 12;

  /// 16 — default gap between cards.
  static const double md = 16;

  /// 20
  static const double lg = 20;

  /// 24
  static const double xl = 24;

  /// 32
  static const double xxl = 32;

  /// 48
  static const double xxxl = 48;

  /// Horizontal screen margin.
  static const double gutter = lg;

  /// Minimum touch target edge, in logical pixels.
  static const double minTouchTarget = 48;
}
