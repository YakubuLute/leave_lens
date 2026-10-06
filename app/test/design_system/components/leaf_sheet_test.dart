import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

enum _Source { camera, gallery }

void main() {
  Future<void> pumpHost(WidgetTester tester, ValueSetter<_Source?> onResult) {
    return tester.pumpWidget(
      MaterialApp(
        theme: LeafTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: LeafButton(
                label: 'Add photo',
                onPressed: () => unawaited(
                  showLeafSheet<_Source>(
                    context: context,
                    title: 'Add a photo',
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LeafListTile(
                          title: 'Take photo',
                          leading: const Icon(LeafIcons.camera),
                          onTap: () => Navigator.pop(context, _Source.camera),
                        ),
                        LeafListTile(
                          title: 'Choose from gallery',
                          leading: const Icon(LeafIcons.gallery),
                          onTap: () => Navigator.pop(context, _Source.gallery),
                        ),
                      ],
                    ),
                  ).then(onResult),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('opens with a title and content', (tester) async {
    await pumpHost(tester, (_) {});

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();

    expect(find.byType(LeafSheet), findsOneWidget);
    expect(find.text('Add a photo'), findsOneWidget);
    expect(find.text('Take photo'), findsOneWidget);
  });

  testWidgets('completes with the chosen value', (tester) async {
    _Source? result;
    await pumpHost(tester, (value) => result = value);

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();

    expect(result, _Source.gallery);
    expect(find.byType(LeafSheet), findsNothing);
  });

  testWidgets('completes with null when dismissed', (tester) async {
    var completed = false;
    _Source? result = _Source.camera;
    await pumpHost(tester, (value) {
      completed = true;
      result = value;
    });

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // the scrim
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(result, isNull);
  });

  testWidgets('title is a header for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpHost(tester, (_) {});

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text('Add a photo')),
      isSemantics(isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('uses the themed sheet surface and drag handle', (tester) async {
    await pumpHost(tester, (_) {});

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();

    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    final theme = LeafTheme.light().bottomSheetTheme;
    expect(theme.modalBackgroundColor, LeafColors.light.surface);
    expect(theme.showDragHandle, isTrue);
    expect(sheet.showDragHandle ?? theme.showDragHandle, isTrue);
  });
}
