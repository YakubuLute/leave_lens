import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final button = find.byType(ScanButton);

  /// Records haptic calls sent to the platform.
  List<String> recordHaptics(WidgetTester tester) {
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          calls.add(call.arguments as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    return calls;
  }

  testWidgets('is a large circle with a camera icon', (tester) async {
    await pumpLeaf(tester, ScanButton(onPressed: () {}));

    expect(tester.getSize(button), const Size.square(ScanButton.diameter));
    expect(find.byIcon(LeafIcons.camera), findsOneWidget);
    final disc = decorationUnder(tester, button);
    expect(disc.color, LeafColors.light.primary);
    expect(disc.shape, BoxShape.circle);
    expect(disc.boxShadow, LeafShadows.floating(LeafColors.light));
  });

  testWidgets('calls onPressed with a light haptic tap', (tester) async {
    final haptics = recordHaptics(tester);
    var taps = 0;
    await pumpLeaf(tester, ScanButton(onPressed: () => taps++));

    await tester.tap(button);

    expect(taps, 1);
    expect(haptics, ['HapticFeedbackType.lightImpact']);
  });

  group('busy', () {
    testWidgets('shows a spinner, ignores taps and is announced', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final haptics = recordHaptics(tester);
      var taps = 0;
      await pumpLeaf(tester, ScanButton(onPressed: () => taps++, isBusy: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(LeafIcons.camera), findsNothing);
      await tester.tap(button);
      expect(taps, 0);
      expect(haptics, isEmpty);
      expect(find.bySemanticsLabel('Scanning'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('pulses while busy and settles when done', (tester) async {
      double ringScale() => tester
          .widget<Transform>(
            find.descendant(of: button, matching: find.byType(Transform)).last,
          )
          .transform
          .getMaxScaleOnAxis();

      await pumpLeaf(tester, ScanButton(onPressed: () {}, isBusy: true));
      await tester.pump(ScanButton.pulsePeriod ~/ 2);
      expect(ringScale(), greaterThan(1));

      await pumpLeaf(tester, ScanButton(onPressed: () {}));
      // Would time out if the pulse kept repeating.
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('does not pulse with reduced motion', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await pumpLeaf(tester, ScanButton(onPressed: () {}, isBusy: true));

      final ring = tester.widget<Transform>(
        find.descendant(of: button, matching: find.byType(Transform)).last,
      );
      expect(ring.transform.getMaxScaleOnAxis(), 1);
    });
  });

  testWidgets('is dimmed and inert when disabled', (tester) async {
    await pumpLeaf(tester, const ScanButton(onPressed: null));

    final opacity = tester.widget<Opacity>(
      find.descendant(of: button, matching: find.byType(Opacity)).first,
    );
    expect(opacity.opacity, LeafPressable.disabledOpacity);
  });

  testWidgets('is named for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(tester, ScanButton(onPressed: () {}));

    expect(
      tester.getSemantics(find.byType(LeafPressable)),
      isSemantics(label: 'Scan a leaf', isButton: true, isEnabled: true),
    );
    handle.dispose();
  });
}
