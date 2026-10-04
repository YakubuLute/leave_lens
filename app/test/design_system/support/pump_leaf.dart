import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

/// Pumps [child] inside the Leaf theme, centred on a page.
///
/// Use [brightness] to test dark mode and [textScale] to test large system
/// text (e.g. `2.0` for 200%).
Future<void> pumpLeaf(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light
          ? LeafTheme.light()
          : LeafTheme.dark(),
      // `app` is never null here: MaterialApp passes its navigator when
      // `home` is set.
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: app!,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(LeafSpacing.md),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// The background [BoxDecoration] of the component under [finder].
///
/// Skips foreground decorations, such as `LeafPressable`'s focus ring.
BoxDecoration decorationUnder(WidgetTester tester, Finder finder) {
  final box = tester
      .widgetList<DecoratedBox>(
        find.descendant(of: finder, matching: find.byType(DecoratedBox)),
      )
      .firstWhere((b) => b.position == DecorationPosition.background);
  return box.decoration as BoxDecoration;
}

/// The keyboard focus ring decoration under [finder], or `null` when hidden.
BoxBorder? focusRingUnder(WidgetTester tester, Finder finder) {
  final box = tester
      .widgetList<DecoratedBox>(
        find.descendant(of: finder, matching: find.byType(DecoratedBox)),
      )
      .firstWhere((b) => b.position == DecorationPosition.foreground);
  return (box.decoration as BoxDecoration).border;
}
