import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/app/app.dart';
import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  BuildContext homeContext(WidgetTester tester) =>
      tester.element(find.text('Leaf Lens'));

  testWidgets('starts on the placeholder home with the app name', (
    tester,
  ) async {
    await tester.pumpWidget(const LeafLensApp());

    expect(find.text('Leaf Lens'), findsOneWidget);
    expect(find.text('Snap a leaf. Know its health.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses light Leaf tokens when the system is light', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const LeafLensApp());

    expect(homeContext(tester).leafColors, LeafColors.light);
  });

  testWidgets('follows the system into dark mode', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const LeafLensApp());
    await tester.pumpAndSettle();

    expect(homeContext(tester).leafColors, LeafColors.dark);
  });

  testWidgets('hides the debug banner', (tester) async {
    await tester.pumpWidget(const LeafLensApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
    expect(app.title, LeafLensApp.title);
  });

  test('registers the bundled font licences', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerLeafFontLicenses();

    final entries = await LicenseRegistry.licenses.toList();
    String textFor(String package) => entries
        .firstWhere((e) => e.packages.contains(package))
        .paragraphs
        .map((p) => p.text)
        .join('\n');

    expect(textFor('Inter'), contains('SIL Open Font License'));
    expect(textFor('Phosphor Icons'), contains('MIT License'));
  });
}
