@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

/// Visual regression for the key components (plan decision 5).
///
/// Regenerate on macOS after an intentional visual change:
/// `flutter test --tags golden --update-goldens`
void main() {
  Future<void> pumpSheet(
    WidgetTester tester,
    Brightness brightness,
    Widget content,
  ) async {
    tester.view.physicalSize = const Size(400, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: brightness == Brightness.light
            ? LeafTheme.light()
            : LeafTheme.dark(),
        home: Scaffold(
          body: RepaintBoundary(
            key: const Key('sheet'),
            // Paint the page colour inside the boundary so the golden shows
            // components on the real background, not transparent white.
            child: Builder(
              builder: (context) => ColoredBox(
                color: context.leafColors.background,
                child: Padding(
                  padding: const EdgeInsets.all(LeafSpacing.lg),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Advance indeterminate animations (the loading spinner) past frame 0.
    await tester.pump(const Duration(milliseconds: 400));
  }

  for (final brightness in Brightness.values) {
    testWidgets('LeafButton variants and states, ${brightness.name}', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        brightness,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final variant in LeafButtonVariant.values) ...[
              LeafButton(
                label: 'Take photo',
                icon: LeafIcons.camera,
                variant: variant,
                onPressed: () {},
              ),
              const LeafGap.sm(),
            ],
            const LeafButton(label: 'Disabled', onPressed: null),
            const LeafGap.sm(),
            LeafButton(label: 'Saving', isLoading: true, onPressed: () {}),
            const LeafGap.sm(),
            LeafButton(
              label: 'Scan a leaf',
              size: LeafButtonSize.lg,
              isExpanded: true,
              onPressed: () {},
            ),
          ],
        ),
      );

      await expectLater(
        find.byKey(const Key('sheet')),
        matchesGoldenFile('goldens/leaf_button_${brightness.name}.png'),
      );
    });

    testWidgets('LeafCard variants, ${brightness.name}', (tester) async {
      await pumpSheet(
        tester,
        brightness,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final variant in LeafCardVariant.values) ...[
              LeafCard(
                variant: variant,
                child: Builder(
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tomato', style: context.leafText.title),
                      const LeafGap.xxs(),
                      Text(
                        '${variant.name} card',
                        style: context.leafText.bodySmall.copyWith(
                          color: context.leafColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const LeafGap.md(),
            ],
          ],
        ),
      );

      await expectLater(
        find.byKey(const Key('sheet')),
        matchesGoldenFile('goldens/leaf_card_${brightness.name}.png'),
      );
    });
  }
}
