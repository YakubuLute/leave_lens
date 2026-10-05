import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final tile = find.byType(LeafListTile);

  testWidgets('shows title, subtitle, leading and trailing', (tester) async {
    await pumpLeaf(
      tester,
      const LeafListTile(
        title: 'Tomato',
        subtitle: '3 October · Late blight',
        leading: Icon(LeafIcons.leaf),
        trailing: StatusBadge(
          status: LeafStatus.diseased,
          size: StatusBadgeSize.sm,
        ),
      ),
    );

    expect(find.text('Tomato'), findsOneWidget);
    expect(find.text('3 October · Late blight'), findsOneWidget);
    expect(find.byIcon(LeafIcons.leaf), findsOneWidget);
    expect(find.byType(StatusBadge), findsOneWidget);
  });

  testWidgets('uses the type scale and secondary colour for the subtitle', (
    tester,
  ) async {
    await pumpLeaf(
      tester,
      const LeafListTile(title: 'Settings', subtitle: 'Language, theme'),
      brightness: Brightness.dark,
    );

    final subtitle = tester.widget<Text>(find.text('Language, theme'));
    expect(subtitle.style?.color, LeafColors.dark.textSecondary);
  });

  testWidgets('is at least 56 dp tall', (tester) async {
    await pumpLeaf(tester, const LeafListTile(title: 'Settings'));

    expect(
      tester.getSize(tile).height,
      greaterThanOrEqualTo(LeafSpacing.minTouchTarget + LeafSpacing.xs),
    );
  });

  testWidgets('is a button only when onTap is set', (tester) async {
    await pumpLeaf(tester, const LeafListTile(title: 'Settings'));
    expect(find.byType(LeafPressable), findsNothing);

    var taps = 0;
    await pumpLeaf(
      tester,
      LeafListTile(
        title: 'Settings',
        trailing: const Icon(LeafIcons.chevronRight),
        onTap: () => taps++,
      ),
    );
    await tester.tap(tile);

    expect(taps, 1);
  });

  testWidgets('wraps long text at 200% without overflowing', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpLeaf(
      tester,
      const LeafListTile(
        title: 'Pepper — bacterial spot, needs another photo',
        subtitle: 'Scanned yesterday at 4:12 pm in the north field',
        leading: Icon(LeafIcons.leaf),
        trailing: Icon(LeafIcons.chevronRight),
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
  });
}
