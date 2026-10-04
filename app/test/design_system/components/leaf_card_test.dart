import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final card = find.byType(LeafCard);

  group('variants use their colour roles', () {
    for (final brightness in Brightness.values) {
      final c = brightness == Brightness.light
          ? LeafColors.light
          : LeafColors.dark;

      final expectations = <LeafCardVariant, (Color?, Color?)>{
        LeafCardVariant.surface: (c.surface, c.border),
        LeafCardVariant.sunken: (c.surfaceSunken, null),
        LeafCardVariant.outlined: (null, c.border),
      };

      for (final MapEntry(key: variant, value: (fill, borderColor))
          in expectations.entries) {
        testWidgets('${variant.name} in ${brightness.name} mode', (
          tester,
        ) async {
          await pumpLeaf(
            tester,
            LeafCard(variant: variant, child: const Text('Content')),
            brightness: brightness,
          );

          final decoration = decorationUnder(tester, card);
          expect(decoration.color, fill);
          expect((decoration.border as Border?)?.top.color, borderColor);
          expect(decoration.borderRadius, LeafRadii.lg);
        });
      }
    }
  });

  testWidgets('pads its content by md by default', (tester) async {
    await pumpLeaf(tester, const LeafCard(child: Text('Content')));

    final cardBox = tester.getRect(card);
    final textBox = tester.getRect(find.text('Content'));
    expect(textBox.left - cardBox.left, LeafSpacing.md);
    expect(textBox.top - cardBox.top, LeafSpacing.md);
  });

  testWidgets('is not a button unless onTap is set', (tester) async {
    await pumpLeaf(tester, const LeafCard(child: Text('Content')));

    expect(find.byType(LeafPressable), findsNothing);
  });

  testWidgets('with onTap: calls it and is labelled for screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLeaf(
      tester,
      LeafCard(
        onTap: () => taps++,
        semanticLabel: 'Open scan from 3 October',
        child: const Text('Tomato · Late blight'),
      ),
    );

    await tester.tap(card);
    expect(taps, 1);
    expect(
      tester.getSemantics(find.byType(LeafPressable)),
      isSemantics(label: 'Open scan from 3 October', isButton: true),
    );
    handle.dispose();
  });
}
