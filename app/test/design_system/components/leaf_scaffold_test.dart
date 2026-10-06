import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  Future<NavigatorState> pumpApp(WidgetTester tester, Widget home) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: LeafTheme.light(),
        home: home,
      ),
    );
    // The key is attached once MaterialApp has built its Navigator.
    return navigatorKey.currentState!;
  }

  testWidgets('has no app bar on a root screen without a title', (
    tester,
  ) async {
    await pumpApp(tester, const LeafScaffold(body: Text('Body')));

    expect(find.byType(LeafAppBar), findsNothing);
  });

  testWidgets('shows an app bar when given a title', (tester) async {
    await pumpApp(
      tester,
      const LeafScaffold(title: 'History', body: Text('Body')),
    );

    expect(find.byType(LeafAppBar), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets('shows an app bar with back on a pushed screen', (tester) async {
    final navigator = await pumpApp(tester, const Text('Home'));
    unawaited(
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => const LeafScaffold(body: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(LeafIcons.back), findsOneWidget);
  });

  testWidgets('applies the screen gutter to the body', (tester) async {
    await pumpApp(
      tester,
      const LeafScaffold(
        body: Align(alignment: Alignment.topLeft, child: Text('Body')),
      ),
    );

    expect(tester.getTopLeft(find.text('Body')).dx, LeafSpacing.gutter);
  });

  testWidgets('isPadded: false goes edge to edge', (tester) async {
    await pumpApp(
      tester,
      const LeafScaffold(
        isPadded: false,
        body: Align(alignment: Alignment.topLeft, child: Text('Body')),
      ),
    );

    expect(tester.getTopLeft(find.text('Body')).dx, 0);
  });

  testWidgets('pins the bottom area below the body', (tester) async {
    await pumpApp(
      tester,
      LeafScaffold(
        body: const Text('Body'),
        bottom: LeafButton(
          label: 'Take photo',
          isExpanded: true,
          onPressed: () {},
        ),
      ),
    );

    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final buttonBottom = tester.getBottomLeft(find.byType(LeafButton)).dy;
    expect(buttonBottom, screenHeight - LeafSpacing.md);
    expect(tester.getTopLeft(find.byType(LeafButton)).dx, LeafSpacing.gutter);
  });
}
