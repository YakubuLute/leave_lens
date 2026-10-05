import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// Space between siblings, sized from the spacing scale.
///
/// Inside a [Row] or [Column] it takes space only along the main axis, so a
/// gap in a `Row` never forces the row taller (unlike a square `SizedBox`).
/// Elsewhere it falls back to a square of [size].
///
/// ```dart
/// Column(children: [title, const LeafGap.xs(), subtitle])
/// ```
class LeafGap extends LeafRenderObjectWidget {
  /// A gap of any spacing token, e.g. `LeafGap(LeafSpacing.gutter)`.
  const LeafGap(this.size, {super.key});

  /// 4
  const LeafGap.xxs({super.key}) : size = LeafSpacing.xxs;

  /// 8
  const LeafGap.xs({super.key}) : size = LeafSpacing.xs;

  /// 12
  const LeafGap.sm({super.key}) : size = LeafSpacing.sm;

  /// 16
  const LeafGap.md({super.key}) : size = LeafSpacing.md;

  /// 20
  const LeafGap.lg({super.key}) : size = LeafSpacing.lg;

  /// 24
  const LeafGap.xl({super.key}) : size = LeafSpacing.xl;

  /// 32
  const LeafGap.xxl({super.key}) : size = LeafSpacing.xxl;

  /// 48
  const LeafGap.xxxl({super.key}) : size = LeafSpacing.xxxl;

  /// Extent along the parent's main axis, in logical pixels.
  final double size;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderGap(size);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderGap).extent = size;
  }
}

class _RenderGap extends RenderBox {
  _RenderGap(this._extent);

  double _extent;

  set extent(double value) {
    if (_extent == value) return;
    _extent = value;
    markNeedsLayout();
  }

  Axis? get _parentAxis => switch (parent) {
    final RenderFlex flex => flex.direction,
    _ => null,
  };

  Size get _preferredSize => switch (_parentAxis) {
    Axis.horizontal => Size(_extent, 0),
    Axis.vertical => Size(0, _extent),
    null => Size.square(_extent),
  };

  @override
  void performLayout() => size = constraints.constrain(_preferredSize);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(_preferredSize);

  @override
  double computeMinIntrinsicWidth(double height) => _preferredSize.width;

  @override
  double computeMaxIntrinsicWidth(double height) => _preferredSize.width;

  @override
  double computeMinIntrinsicHeight(double width) => _preferredSize.height;

  @override
  double computeMaxIntrinsicHeight(double width) => _preferredSize.height;
}
