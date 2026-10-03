import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lense/design_system/design_system.dart';

void main() {
  Future<void> pushPage(WidgetTester tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: LeafTheme.light().copyWith(platform: TargetPlatform.android),
        home: const Text('Home'),
      ),
    );
    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => const Text('Next')),
      ),
    );
    await tester.pump();
  }

  Iterable<double> opacitiesAbove(WidgetTester tester, String text) => tester
      .widgetList<FadeTransition>(
        find.ancestor(
          of: find.text(text),
          matching: find.byType(FadeTransition),
        ),
      )
      .map((f) => f.opacity.value);

  testWidgets('fades the incoming page in', (tester) async {
    await pushPage(tester);
    await tester.pump(LeafMotion.slow ~/ 2);

    expect(opacitiesAbove(tester, 'Next').any((o) => o > 0 && o < 1), isTrue);
  });

  testWidgets('is fully visible after LeafMotion.slow', (tester) async {
    await pushPage(tester);
    await tester.pump(LeafMotion.slow);

    expect(opacitiesAbove(tester, 'Next').every((o) => o == 1), isTrue);
  });

  testWidgets('returns the page untouched when reduced motion is on', (
    tester,
  ) async {
    const page = Text('Next', textDirection: TextDirection.ltr);
    late Widget built;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            built = const LeafPageTransitionsBuilder().buildTransitions(
              MaterialPageRoute<void>(builder: (_) => page),
              context,
              const AlwaysStoppedAnimation(0),
              const AlwaysStoppedAnimation(0),
              page,
            );
            return built;
          },
        ),
      ),
    );

    expect(built, same(page));
  });
}
