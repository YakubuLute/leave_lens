import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Colours for one diagnosis status.
@immutable
class LeafStatusColors {
  /// Creates a status colour set.
  const LeafStatusColors({
    required this.fg,
    required this.bg,
    required this.solid,
    required this.onSolid,
  });

  /// Text and icon colour on [bg].
  final Color fg;

  /// Tinted background for badges and notices.
  final Color bg;

  /// Strong colour for meters and filled badges. Readable as text on the page.
  final Color solid;

  /// Text and icon colour on [solid].
  final Color onSolid;

  /// Linearly interpolates between two status colour sets.
  static LeafStatusColors lerp(
    LeafStatusColors a,
    LeafStatusColors b,
    double t,
  ) {
    return LeafStatusColors(
      fg: Color.lerp(a.fg, b.fg, t)!,
      bg: Color.lerp(a.bg, b.bg, t)!,
      solid: Color.lerp(a.solid, b.solid, t)!,
      onSolid: Color.lerp(a.onSolid, b.onSolid, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LeafStatusColors &&
      other.fg == fg &&
      other.bg == bg &&
      other.solid == solid &&
      other.onSolid == onSolid;

  @override
  int get hashCode => Object.hash(fg, bg, solid, onSolid);
}
