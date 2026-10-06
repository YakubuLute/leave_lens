@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/sample_result_screen.dart';

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

    testWidgets('StatusBadge statuses and sizes, ${brightness.name}', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        brightness,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final size in StatusBadgeSize.values) ...[
              for (final status in LeafStatus.values) ...[
                StatusBadge(status: status, size: size),
                const LeafGap.xs(),
              ],
              const LeafGap.md(),
            ],
          ],
        ),
      );

      await expectLater(
        find.byKey(const Key('sheet')),
        matchesGoldenFile('goldens/status_badge_${brightness.name}.png'),
      );
    });

    testWidgets('ConfidenceMeter per status, ${brightness.name}', (
      tester,
    ) async {
      const readings = [
        (LeafStatus.healthy, 0.97),
        (LeafStatus.diseased, 0.72),
        (LeafStatus.uncertain, 0.48),
        (LeafStatus.notALeaf, 0.99),
      ];
      await pumpSheet(
        tester,
        brightness,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (status, value) in readings) ...[
              ConfidenceMeter(value: value, status: status),
              const LeafGap.lg(),
            ],
          ],
        ),
      );
      // Let the bars finish filling.
      await tester.pump(LeafMotion.slow);

      await expectLater(
        find.byKey(const Key('sheet')),
        matchesGoldenFile('goldens/confidence_meter_${brightness.name}.png'),
      );
    });

    testWidgets('ScanButton idle, busy and disabled, ${brightness.name}', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        brightness,
        Column(
          children: [
            ScanButton(onPressed: () {}),
            const LeafGap.xxl(),
            ScanButton(onPressed: () {}, isBusy: true),
            const LeafGap.xxl(),
            const ScanButton(onPressed: null),
          ],
        ),
      );

      await expectLater(
        find.byKey(const Key('sheet')),
        matchesGoldenFile('goldens/scan_button_${brightness.name}.png'),
      );
    });

    testWidgets('Sample result screen, ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(400, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: brightness == Brightness.light
              ? LeafTheme.light()
              : LeafTheme.dark(),
          home: const SampleResultScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SampleResultScreen),
        matchesGoldenFile('goldens/sample_result_${brightness.name}.png'),
      );
    });
  }
}
