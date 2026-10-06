import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

enum _Section { immediate, organic, chemical, prevention }

void main() {
  final tabs = [
    for (final section in _Section.values)
      LeafTab(
        value: section,
        label:
            '${section.name[0].toUpperCase()}'
            '${section.name.substring(1)}',
      ),
  ];

  /// Pumps tabs that keep their own selection, like a real screen would.
  Future<List<_Section>> pumpTabs(
    WidgetTester tester, {
    double textScale = 1,
    Brightness brightness = Brightness.light,
  }) async {
    final changes = <_Section>[];
    var selected = _Section.immediate;
    await pumpLeaf(
      tester,
      StatefulBuilder(
        builder: (context, setState) => LeafTabs<_Section>(
          tabs: tabs,
          selected: selected,
          onChanged: (value) {
            changes.add(value);
            setState(() => selected = value);
          },
        ),
      ),
      textScale: textScale,
      brightness: brightness,
    );
    return changes;
  }

  Color? segmentFill(WidgetTester tester, String label) {
    final container = tester.widget<AnimatedContainer>(
      find.ancestor(
        of: find.text(label),
        matching: find.byType(AnimatedContainer),
      ),
    );
    return (container.decoration as BoxDecoration?)?.color;
  }

  testWidgets('shows every tab label', (tester) async {
    await pumpTabs(tester);

    for (final label in ['Immediate', 'Organic', 'Chemical', 'Prevention']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('tapping a tab reports it and moves the selection', (
    tester,
  ) async {
    final changes = await pumpTabs(tester);
    const c = LeafColors.light;
    expect(segmentFill(tester, 'Immediate'), c.surface);

    await tester.tap(find.text('Organic'));
    await tester.pumpAndSettle();

    expect(changes, [_Section.organic]);
    expect(segmentFill(tester, 'Organic'), c.surface);
    expect(segmentFill(tester, 'Immediate'), Colors.transparent);
  });

  testWidgets('tapping the selected tab does nothing', (tester) async {
    final changes = await pumpTabs(tester);

    await tester.tap(find.text('Immediate'));

    expect(changes, isEmpty);
  });

  testWidgets('selected label is primary text, others secondary', (
    tester,
  ) async {
    await pumpTabs(tester, brightness: Brightness.dark);
    const c = LeafColors.dark;

    expect(
      tester.widget<Text>(find.text('Immediate')).style?.color,
      c.textPrimary,
    );
    expect(
      tester.widget<Text>(find.text('Organic')).style?.color,
      c.textSecondary,
    );
  });

  testWidgets('segments are 48 dp targets announced as selectable', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpTabs(tester);

    expect(
      tester
          .getSize(
            find.ancestor(
              of: find.text('Organic'),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .height,
      greaterThanOrEqualTo(LeafSpacing.minTouchTarget),
    );
    expect(
      tester.getSemantics(find.text('Immediate')),
      isSemantics(
        label: 'Immediate',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('Organic')),
      isSemantics(hasSelectedState: true, isSelected: false),
    );
    handle.dispose();
  });

  testWidgets('scrolls instead of overflowing at 200% text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpTabs(tester, textScale: 2);

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  test('selected must be one of the tabs', () {
    expect(
      () => LeafTabs<int>(
        tabs: const [LeafTab(value: 1, label: 'One')],
        selected: 2,
        onChanged: (_) {},
      ),
      throwsAssertionError,
    );
  });
}
