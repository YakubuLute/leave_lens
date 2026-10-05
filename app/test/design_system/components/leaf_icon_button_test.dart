import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final button = find.byType(LeafIconButton);

  testWidgets('is a 48 dp target that calls onPressed', (tester) async {
    var taps = 0;
    await pumpLeaf(
      tester,
      LeafIconButton(
        icon: LeafIcons.close,
        semanticLabel: 'Close',
        onPressed: () => taps++,
      ),
    );

    expect(
      tester.getSize(button),
      const Size.square(LeafSpacing.minTouchTarget),
    );
    await tester.tap(button);
    expect(taps, 1);
  });

  testWidgets('is named for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(
      tester,
      LeafIconButton(
        icon: LeafIcons.close,
        semanticLabel: 'Close',
        onPressed: () {},
      ),
    );

    // The Tooltip wraps the button, so read the pressable's own node.
    final pressable = find.descendant(
      of: button,
      matching: find.byType(LeafPressable),
    );
    expect(
      tester.getSemantics(pressable),
      isSemantics(label: 'Close', isButton: true, isEnabled: true),
    );
    handle.dispose();
  });

  testWidgets('shows its label as a tooltip on long press', (tester) async {
    await pumpLeaf(
      tester,
      LeafIconButton(
        icon: LeafIcons.close,
        semanticLabel: 'Close',
        onPressed: () {},
      ),
    );

    await tester.longPress(button);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('is dimmed and inert when disabled', (tester) async {
    await pumpLeaf(
      tester,
      const LeafIconButton(
        icon: LeafIcons.close,
        semanticLabel: 'Close',
        onPressed: null,
      ),
    );

    final opacity = tester.widget<Opacity>(
      find.descendant(of: button, matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, LeafPressable.disabledOpacity);
  });

  group('variants use their colour roles', () {
    const c = LeafColors.light;
    final expectations = {
      LeafIconButtonVariant.ghost: (Colors.transparent, c.textPrimary),
      LeafIconButtonVariant.tonal: (c.surfaceSunken, c.textPrimary),
      LeafIconButtonVariant.primary: (c.primary, c.onPrimary),
    };

    for (final MapEntry(key: variant, value: (background, foreground))
        in expectations.entries) {
      testWidgets(variant.name, (tester) async {
        await pumpLeaf(
          tester,
          LeafIconButton(
            icon: LeafIcons.close,
            semanticLabel: 'Close',
            variant: variant,
            onPressed: () {},
          ),
        );

        expect(decorationUnder(tester, button).color, background);
        expect(tester.widget<Icon>(find.byType(Icon)).color, foreground);
      });
    }
  });
}
