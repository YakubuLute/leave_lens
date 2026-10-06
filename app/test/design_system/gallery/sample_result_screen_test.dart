import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/sample_result_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester, {double textScale = 1}) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: LeafTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          // MaterialApp always passes its navigator when `home` is set.
          child: child!,
        ),
        home: const SampleResultScreen(),
      ),
    );
  }

  testWidgets('shows the diagnosis from the contract fixture', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(StatusBadge), findsOneWidget);
    expect(find.text('Late blight'), findsOneWidget);
    expect(find.text('Tomato · Phytophthora infestans'), findsOneWidget);
    expect(find.text('93%'), findsOneWidget);
  });

  testWidgets('switching tabs shows that treatment', (tester) async {
    await pumpScreen(tester);
    final list = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.text('Prevention'),
      200,
      scrollable: list,
    );
    expect(
      find.textContaining('Remove and destroy infected leaves'),
      findsOneWidget,
    );

    await tester.tap(find.text('Prevention'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Rotate crops each season'), findsOneWidget);
    expect(
      find.textContaining('Remove and destroy infected leaves'),
      findsNothing,
    );
  });

  testWidgets('keeps the main action pinned at the bottom', (tester) async {
    await pumpScreen(tester);

    final button = tester.getRect(find.byType(LeafButton));
    expect(button.bottom, greaterThan(700));
  });

  testWidgets('scrolls cleanly at 200% text', (tester) async {
    await pumpScreen(tester, textScale: 2);
    final list = find.byType(Scrollable).first;

    for (var i = 0; i < 20; i++) {
      await tester.drag(list, const Offset(0, -300));
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}
