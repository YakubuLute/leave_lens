import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final meter = find.byType(ConfidenceMeter);

  group('describe', () {
    final cases = <double, String>{
      1: 'High confidence',
      ConfidenceMeter.highBand: 'High confidence',
      0.84: 'Medium confidence',
      ConfidenceMeter.mediumBand: 'Medium confidence',
      0.59: 'Low confidence',
      0: 'Low confidence',
    };
    for (final MapEntry(key: value, value: words) in cases.entries) {
      test('$value reads "$words"', () {
        expect(ConfidenceMeter.describe(value), words);
      });
    }
  });

  test('percent rounds to a whole number', () {
    expect(ConfidenceMeter.percent(0.934), '93%');
    expect(ConfidenceMeter.percent(0.935), '94%');
    expect(ConfidenceMeter.percent(0), '0%');
    expect(ConfidenceMeter.percent(1), '100%');
  });

  testWidgets('shows words and percentage', (tester) async {
    await pumpLeaf(
      tester,
      const ConfidenceMeter(value: 0.93, status: LeafStatus.diseased),
    );

    expect(find.text('High confidence'), findsOneWidget);
    expect(find.text('93%'), findsOneWidget);
  });

  testWidgets('fills the bar to the value in the status colour', (
    tester,
  ) async {
    await pumpLeaf(
      tester,
      const SizedBox(
        width: 200,
        child: ConfidenceMeter(value: 0.6, status: LeafStatus.healthy),
      ),
    );
    await tester.pumpAndSettle();

    final fill = tester.widget<FractionallySizedBox>(
      find.byType(FractionallySizedBox),
    );
    expect(fill.widthFactor, closeTo(0.6, 0.0001));
    final fillColor = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(FractionallySizedBox),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(fillColor.color, LeafColors.light.healthy.solid);
  });

  testWidgets('animates the fill from empty', (tester) async {
    await pumpLeaf(
      tester,
      const ConfidenceMeter(value: 0.8, status: LeafStatus.healthy),
    );

    double widthFactor() => tester
        .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
        .widthFactor!;

    expect(widthFactor(), 0);
    await tester.pump(LeafMotion.slow ~/ 2);
    expect(widthFactor(), inExclusiveRange(0, 0.8));
    await tester.pumpAndSettle();
    expect(widthFactor(), closeTo(0.8, 0.0001));
  });

  testWidgets('is full immediately with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await pumpLeaf(
      tester,
      const ConfidenceMeter(value: 0.8, status: LeafStatus.healthy),
    );
    await tester.pump();

    final fill = tester.widget<FractionallySizedBox>(
      find.byType(FractionallySizedBox),
    );
    expect(fill.widthFactor, closeTo(0.8, 0.0001));
  });

  testWidgets('is read as one labelled value', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(
      tester,
      const ConfidenceMeter(value: 0.48, status: LeafStatus.uncertain),
    );

    expect(
      tester.getSemantics(meter),
      isSemantics(label: 'Low confidence', value: '48%'),
    );
    handle.dispose();
  });

  testWidgets('rejects values outside 0–1', (tester) async {
    expect(
      () => ConfidenceMeter(value: 1.2, status: LeafStatus.healthy),
      throwsAssertionError,
    );
  });
}
