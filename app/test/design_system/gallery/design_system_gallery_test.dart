import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/design_system_gallery.dart';
import 'package:leaf_lens/design_system/gallery/sample_result_screen.dart';

void main() {
  Future<void> pumpGallery(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: LeafTheme.light(), home: const DesignSystemGallery()),
    );
  }

  /// Scrolls through the whole gallery, so every component is built and laid
  /// out, and fails on any rendering error such as an overflow.
  Future<void> scrollThroughEverything(WidgetTester tester) async {
    final list = find.byType(Scrollable).first;
    for (var i = 0; i < 80; i++) {
      await tester.drag(list, const Offset(0, -300));
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  }

  BuildContext galleryContext(WidgetTester tester) =>
      tester.element(find.text('Typography'));

  testWidgets('renders every section', (tester) async {
    await pumpGallery(tester);

    for (final section in [
      'Typography',
      'Colour roles',
      'LeafButton',
      'LeafIconButton',
      'ScanButton',
      'StatusBadge',
      'ConfidenceMeter',
      'LeafCard',
      'LeafListTile',
      'LeafImageFrame',
      'LeafTabs',
      'LeafNotice',
      'LeafStateView',
      'Sheet and toast',
    ]) {
      await tester.scrollUntilVisible(
        find.text(section),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(section), findsOneWidget, reason: section);
    }
  });

  testWidgets('every component renders cleanly in light mode', (tester) async {
    await pumpGallery(tester);
    await scrollThroughEverything(tester);
  });

  testWidgets('switches to dark mode and renders cleanly', (tester) async {
    await pumpGallery(tester);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(galleryContext(tester).leafColors, LeafColors.dark);
    await scrollThroughEverything(tester);
  });

  testWidgets('renders cleanly at 200% text', (tester) async {
    await pumpGallery(tester);

    await tester.tap(find.text('Text 200%'));
    await tester.pumpAndSettle();

    expect(MediaQuery.textScalerOf(galleryContext(tester)).scale(10), 20);
    await scrollThroughEverything(tester);
  });

  testWidgets('opens the sample result screen with the same settings', (
    tester,
  ) async {
    await pumpGallery(tester);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open sample result screen'));
    await tester.pumpAndSettle();

    expect(find.byType(SampleResultScreen), findsOneWidget);
    expect(
      tester.element(find.text('Late blight')).leafColors,
      LeafColors.dark,
    );
  });
}
