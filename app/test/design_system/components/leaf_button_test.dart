import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final button = find.byType(LeafButton);

  double opacityOf(WidgetTester tester) => tester
      .widget<Opacity>(
        find.descendant(of: button, matching: find.byType(Opacity)),
      )
      .opacity;

  testWidgets('shows its label and calls onPressed', (tester) async {
    var taps = 0;
    await pumpLeaf(
      tester,
      LeafButton(label: 'Take photo', onPressed: () => taps++),
    );

    await tester.tap(find.text('Take photo'));

    expect(taps, 1);
  });

  testWidgets('shows a leading icon', (tester) async {
    await pumpLeaf(
      tester,
      LeafButton(label: 'Take photo', icon: LeafIcons.camera, onPressed: () {}),
    );

    expect(find.byIcon(LeafIcons.camera), findsOneWidget);
  });

  group('variants use their colour roles', () {
    for (final brightness in Brightness.values) {
      final c = brightness == Brightness.light
          ? LeafColors.light
          : LeafColors.dark;

      final expectations = {
        LeafButtonVariant.primary: (c.primary, c.onPrimary),
        LeafButtonVariant.secondary: (Colors.transparent, c.primary),
        LeafButtonVariant.ghost: (Colors.transparent, c.primary),
        LeafButtonVariant.danger: (c.danger, c.onDanger),
      };

      for (final MapEntry(key: variant, value: (background, foreground))
          in expectations.entries) {
        testWidgets('${variant.name} in ${brightness.name} mode', (
          tester,
        ) async {
          await pumpLeaf(
            tester,
            LeafButton(label: 'Go', variant: variant, onPressed: () {}),
            brightness: brightness,
          );

          expect(decorationUnder(tester, button).color, background);
          final text = tester.widget<Text>(find.text('Go'));
          expect(text.style?.color, foreground);
        });
      }
    }

    testWidgets('secondary has a strong outline', (tester) async {
      await pumpLeaf(
        tester,
        LeafButton(
          label: 'Go',
          variant: LeafButtonVariant.secondary,
          onPressed: () {},
        ),
      );

      final border = decorationUnder(tester, button).border! as Border;
      expect(border.top.color, LeafColors.light.borderStrong);
    });
  });

  group('disabled', () {
    testWidgets('is dimmed and ignores taps', (tester) async {
      await pumpLeaf(tester, const LeafButton(label: 'Go', onPressed: null));

      expect(opacityOf(tester), LeafPressable.disabledOpacity);
      await tester.tap(find.text('Go'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('is announced as disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLeaf(tester, const LeafButton(label: 'Go', onPressed: null));

      expect(
        tester.getSemantics(button),
        isSemantics(
          label: 'Go',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });
  });

  group('loading', () {
    testWidgets('shows a spinner, blocks taps and is not dimmed', (
      tester,
    ) async {
      var taps = 0;
      await pumpLeaf(
        tester,
        LeafButton(label: 'Save', isLoading: true, onPressed: () => taps++),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(opacityOf(tester), 1);
      await tester.tap(button);
      expect(taps, 0);
    });

    testWidgets('keeps the same size as when idle', (tester) async {
      await pumpLeaf(tester, LeafButton(label: 'Save', onPressed: () {}));
      final idle = tester.getSize(button);

      await pumpLeaf(
        tester,
        LeafButton(label: 'Save', isLoading: true, onPressed: () {}),
      );

      expect(tester.getSize(button), idle);
    });

    testWidgets('is announced as loading', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLeaf(
        tester,
        LeafButton(label: 'Save', isLoading: true, onPressed: () {}),
      );

      expect(find.bySemanticsLabel('Save, loading'), findsOneWidget);
      handle.dispose();
    });
  });

  group('size', () {
    testWidgets('md is at least 48 dp tall', (tester) async {
      await pumpLeaf(tester, LeafButton(label: 'Go', onPressed: () {}));
      expect(
        tester.getSize(button).height,
        greaterThanOrEqualTo(LeafSpacing.minTouchTarget),
      );
    });

    testWidgets('lg is taller than md', (tester) async {
      await pumpLeaf(tester, LeafButton(label: 'Go', onPressed: () {}));
      final md = tester.getSize(button).height;

      await pumpLeaf(
        tester,
        LeafButton(label: 'Go', size: LeafButtonSize.lg, onPressed: () {}),
      );

      expect(tester.getSize(button).height, greaterThan(md));
    });

    testWidgets('isExpanded fills the available width', (tester) async {
      await pumpLeaf(
        tester,
        LeafButton(label: 'Go', isExpanded: true, onPressed: () {}),
      );

      final available =
          tester.view.physicalSize.width / tester.view.devicePixelRatio -
          2 * LeafSpacing.md;
      expect(tester.getSize(button).width, available);
    });
  });

  testWidgets('wraps a long label at 200% text without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpLeaf(
      tester,
      LeafButton(
        label: 'Check another leaf from your gallery',
        icon: LeafIcons.gallery,
        isExpanded: true,
        onPressed: () {},
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(button).height,
      greaterThan(LeafSpacing.minTouchTarget),
    );
  });
}
