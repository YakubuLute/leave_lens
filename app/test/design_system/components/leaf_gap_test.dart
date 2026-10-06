import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  Future<Size> gapSize(WidgetTester tester, Widget parent) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: parent),
      ),
    );
    return tester.getSize(find.byType(LeafGap));
  }

  testWidgets('takes space only along a Column main axis', (tester) async {
    final size = await gapSize(
      tester,
      const Column(mainAxisSize: MainAxisSize.min, children: [LeafGap.md()]),
    );
    expect(size, const Size(0, LeafSpacing.md));
  });

  testWidgets('takes space only along a Row main axis', (tester) async {
    final size = await gapSize(
      tester,
      const Row(mainAxisSize: MainAxisSize.min, children: [LeafGap.lg()]),
    );
    expect(size, const Size(LeafSpacing.lg, 0));
  });

  testWidgets('never makes a Row taller than its content', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10, height: 10),
              LeafGap.xxxl(),
              SizedBox(width: 10, height: 10),
            ],
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(Row)).height, 10);
  });

  testWidgets('falls back to a square outside a Row or Column', (tester) async {
    final size = await gapSize(tester, const LeafGap.xs());
    expect(size, const Size.square(LeafSpacing.xs));
  });

  testWidgets('resizes when its size changes', (tester) async {
    await gapSize(
      tester,
      const Column(mainAxisSize: MainAxisSize.min, children: [LeafGap.xs()]),
    );
    final size = await gapSize(
      tester,
      const Column(mainAxisSize: MainAxisSize.min, children: [LeafGap.xl()]),
    );
    expect(size.height, LeafSpacing.xl);
  });

  test('named constructors map to the spacing scale', () {
    const gaps = [
      (LeafGap.xxs(), LeafSpacing.xxs),
      (LeafGap.xs(), LeafSpacing.xs),
      (LeafGap.sm(), LeafSpacing.sm),
      (LeafGap.md(), LeafSpacing.md),
      (LeafGap.lg(), LeafSpacing.lg),
      (LeafGap.xl(), LeafSpacing.xl),
      (LeafGap.xxl(), LeafSpacing.xxl),
      (LeafGap.xxxl(), LeafSpacing.xxxl),
    ];
    for (final (gap, size) in gaps) {
      expect(gap.size, size);
    }
  });
}
