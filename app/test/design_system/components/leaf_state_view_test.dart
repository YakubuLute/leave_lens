import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final view = find.byType(LeafStateView);

  group('loading', () {
    testWidgets('shows a spinner and message', (tester) async {
      await pumpLeaf(
        tester,
        const LeafStateView.loading(message: 'Checking your leaf'),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Checking your leaf'), findsOneWidget);
      expect(find.byType(LeafButton), findsNothing);
    });
  });

  group('empty', () {
    testWidgets('invites the user with an action', (tester) async {
      var taps = 0;
      await pumpLeaf(
        tester,
        LeafStateView.empty(
          title: 'No scans yet',
          message: 'Your scanned leaves will appear here.',
          actionLabel: 'Scan a leaf',
          onAction: () => taps++,
        ),
      );

      expect(find.byIcon(LeafIcons.leaf), findsOneWidget);
      expect(find.text('No scans yet'), findsOneWidget);
      await tester.tap(find.text('Scan a leaf'));
      expect(taps, 1);
      final button = tester.widget<LeafButton>(find.byType(LeafButton));
      expect(button.variant, LeafButtonVariant.primary);
    });

    testWidgets('can be shown without an action', (tester) async {
      await pumpLeaf(tester, const LeafStateView.empty(title: 'Nothing here'));

      expect(find.byType(LeafButton), findsNothing);
    });
  });

  group('error', () {
    testWidgets('always offers a retry', (tester) async {
      var retries = 0;
      await pumpLeaf(
        tester,
        LeafStateView.error(
          title: "Couldn't check this leaf",
          message: 'Check your connection and try again.',
          onRetry: () => retries++,
        ),
      );

      expect(find.byIcon(LeafIcons.error), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retries, 1);
    });

    testWidgets('uses the danger colour for its icon, not a status colour', (
      tester,
    ) async {
      await pumpLeaf(
        tester,
        LeafStateView.error(title: 'Failed', onRetry: () {}),
        brightness: Brightness.dark,
      );

      expect(
        tester.widget<Icon>(find.byIcon(LeafIcons.error)).color,
        LeafColors.dark.danger,
      );
    });

    testWidgets('accepts a custom retry label', (tester) async {
      await pumpLeaf(
        tester,
        LeafStateView.error(
          title: 'Camera unavailable',
          retryLabel: 'Open settings',
          onRetry: () {},
        ),
      );

      expect(find.text('Open settings'), findsOneWidget);
    });

    testWidgets('is announced when it appears', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLeaf(
        tester,
        LeafStateView.error(title: 'Failed', onRetry: () {}),
      );

      expect(tester.getSemantics(view), isSemantics(isLiveRegion: true));
      handle.dispose();
    });
  });

  testWidgets('scrolls rather than overflowing at 200% text', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpLeaf(
      tester,
      LeafStateView.error(
        title: "We couldn't check this leaf right now",
        message:
            'Check your internet connection, then try again. Your photo is '
            'still saved on this phone.',
        onRetry: () {},
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
  });
}
