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

  Widget screen(LeafAppBar appBar) =>
      Scaffold(appBar: appBar, body: const SizedBox.shrink());

  testWidgets('shows the title and no back button on the first screen', (
    tester,
  ) async {
    await pumpApp(tester, screen(const LeafAppBar(title: 'Leaf Lens')));

    expect(find.text('Leaf Lens'), findsOneWidget);
    expect(find.byIcon(LeafIcons.back), findsNothing);
  });

  testWidgets('shows a Leaf back button on a pushed screen that pops', (
    tester,
  ) async {
    final navigator = await pumpApp(tester, const Text('Home'));
    unawaited(
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => screen(const LeafAppBar(title: 'Result')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(LeafIcons.back), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);

    await tester.tap(find.byIcon(LeafIcons.back));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('custom leading replaces the back button', (tester) async {
    final navigator = await pumpApp(tester, const Text('Home'));
    unawaited(
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => screen(
            LeafAppBar(
              leading: LeafIconButton(
                icon: LeafIcons.close,
                semanticLabel: 'Close',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(LeafIcons.close), findsOneWidget);
    expect(find.byIcon(LeafIcons.back), findsNothing);
  });

  testWidgets('shows actions', (tester) async {
    await pumpApp(
      tester,
      screen(
        LeafAppBar(
          title: 'History',
          actions: [
            LeafIconButton(
              icon: LeafIcons.more,
              semanticLabel: 'More',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(LeafIcons.more), findsOneWidget);
  });

  test('has the standard toolbar height', () {
    expect(const LeafAppBar().preferredSize.height, kToolbarHeight);
  });
}
