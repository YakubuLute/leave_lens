import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  Widget pressable({VoidCallback? onPressed, String? label}) => LeafPressable(
    onPressed: onPressed,
    borderRadius: LeafRadii.md,
    semanticLabel: label,
    child: const SizedBox(width: 100, height: 48, child: Text('Press')),
  );

  double scaleOf(WidgetTester tester) =>
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

  testWidgets('calls onPressed on tap', (tester) async {
    var taps = 0;
    await pumpLeaf(tester, pressable(onPressed: () => taps++));

    await tester.tap(find.text('Press'));

    expect(taps, 1);
  });

  testWidgets('shrinks while pressed and springs back on release', (
    tester,
  ) async {
    await pumpLeaf(tester, pressable(onPressed: () {}));

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Press')),
    );
    await tester.pump();
    expect(scaleOf(tester), LeafPressable.defaultPressedScale);

    await gesture.up();
    await tester.pump();
    expect(scaleOf(tester), 1);
  });

  testWidgets('does not shrink or fire when disabled', (tester) async {
    await pumpLeaf(tester, pressable());

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Press')),
    );
    await tester.pump();
    expect(scaleOf(tester), 1);
    await gesture.up();
  });

  testWidgets('press animation is instant with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await pumpLeaf(tester, pressable(onPressed: () {}));

    final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
    expect(scale.duration, Duration.zero);
  });

  testWidgets('keyboard focus shows a ring and Enter activates', (
    tester,
  ) async {
    var taps = 0;
    await pumpLeaf(tester, pressable(onPressed: () => taps++));
    final target = find.byType(LeafPressable);
    expect(focusRingUnder(tester, target), isNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusRingUnder(tester, target), isNotNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
  });

  testWidgets('exposes button semantics with enabled state', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(tester, pressable(onPressed: () {}, label: 'Scan leaf'));

    expect(
      tester.getSemantics(find.byType(LeafPressable)),
      isSemantics(
        label: 'Scan leaf',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    expect(find.bySemanticsLabel('Press'), findsNothing);

    await pumpLeaf(tester, pressable(label: 'Scan leaf'));
    expect(
      tester.getSemantics(find.byType(LeafPressable)),
      isSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
    handle.dispose();
  });
}
