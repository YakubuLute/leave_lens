import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final badge = find.byType(StatusBadge);

  for (final brightness in Brightness.values) {
    final c = brightness == Brightness.light
        ? LeafColors.light
        : LeafColors.dark;

    for (final status in LeafStatus.values) {
      testWidgets(
        '${status.name} shows icon, label and colour (${brightness.name})',
        (tester) async {
          await pumpLeaf(
            tester,
            StatusBadge(status: status),
            brightness: brightness,
          );
          final colors = c.forStatus(status);

          expect(find.text(StatusBadge.defaultLabel(status)), findsOneWidget);
          final icon = tester.widget<Icon>(find.byType(Icon));
          expect(icon.icon, StatusBadge.iconFor(status));
          expect(icon.color, colors.fg);
          expect(decorationUnder(tester, badge).color, colors.bg);
          final text = tester.widget<Text>(
            find.text(StatusBadge.defaultLabel(status)),
          );
          expect(text.style?.color, colors.fg);
        },
      );
    }
  }

  test('every status has a distinct label and icon', () {
    final labels = LeafStatus.values.map(StatusBadge.defaultLabel).toSet();
    final icons = LeafStatus.values.map(StatusBadge.iconFor).toSet();
    expect(labels, hasLength(LeafStatus.values.length));
    expect(icons, hasLength(LeafStatus.values.length));
  });

  testWidgets('a custom label replaces the default', (tester) async {
    await pumpLeaf(
      tester,
      const StatusBadge(status: LeafStatus.diseased, label: 'Malade'),
    );

    expect(find.text('Malade'), findsOneWidget);
    expect(find.text('Diseased'), findsNothing);
  });

  testWidgets('is read as one label by screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(tester, const StatusBadge(status: LeafStatus.uncertain));

    expect(tester.getSemantics(badge), isSemantics(label: 'Not sure'));
    handle.dispose();
  });

  testWidgets('sm is smaller than md', (tester) async {
    await pumpLeaf(tester, const StatusBadge(status: LeafStatus.healthy));
    final md = tester.getSize(badge);

    await pumpLeaf(
      tester,
      const StatusBadge(status: LeafStatus.healthy, size: StatusBadgeSize.sm),
    );

    expect(tester.getSize(badge).height, lessThan(md.height));
  });

  testWidgets('does not overflow at 200% text in a narrow space', (
    tester,
  ) async {
    await pumpLeaf(
      tester,
      const SizedBox(
        width: 120,
        child: StatusBadge(status: LeafStatus.notALeaf),
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
  });
}
