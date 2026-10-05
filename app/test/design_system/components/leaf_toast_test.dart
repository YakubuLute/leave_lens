import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  Future<void> pumpHost(
    WidgetTester tester,
    void Function(BuildContext context) onPressed,
  ) {
    return tester.pumpWidget(
      MaterialApp(
        theme: LeafTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: LeafButton(
                label: 'Save',
                onPressed: () => onPressed(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the message with an optional icon', (tester) async {
    await pumpHost(
      tester,
      (context) =>
          showLeafToast(context, 'Scan saved', icon: LeafIcons.healthy),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Scan saved'), findsOneWidget);
    expect(find.byIcon(LeafIcons.healthy), findsOneWidget);
  });

  testWidgets('disappears after a few seconds', (tester) async {
    await pumpHost(tester, (context) => showLeafToast(context, 'Scan saved'));

    await tester.tap(find.text('Save'));
    // The display timer starts once the entrance animation has finished.
    await tester.pumpAndSettle();
    expect(find.text('Scan saved'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Scan saved'), findsNothing);
  });

  testWidgets('replaces a toast that is already showing', (tester) async {
    var count = 0;
    await pumpHost(
      tester,
      (context) => showLeafToast(context, 'Saved ${++count}'),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Saved 1'), findsNothing);
    expect(find.text('Saved 2'), findsOneWidget);
  });

  testWidgets('runs its action', (tester) async {
    var undone = 0;
    await pumpHost(
      tester,
      (context) => showLeafToast(
        context,
        'Scan deleted',
        actionLabel: 'Undo',
        onAction: () => undone++,
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));

    expect(undone, 1);
  });

  testWidgets('floats with inverted colours from the theme', (tester) async {
    await pumpHost(tester, (context) => showLeafToast(context, 'Scan saved'));

    await tester.tap(find.text('Save'));
    await tester.pump();

    final theme = LeafTheme.light().snackBarTheme;
    expect(theme.behavior, SnackBarBehavior.floating);
    expect(theme.backgroundColor, LeafColors.light.textPrimary);
  });

  testWidgets('needs a label and action together', (tester) async {
    await pumpHost(
      tester,
      (context) => showLeafToast(context, 'Oops', actionLabel: 'Undo'),
    );

    await tester.tap(find.text('Save'));

    expect(tester.takeException(), isAssertionError);
  });
}
