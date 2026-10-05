import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

void main() {
  final notice = find.byType(LeafNotice);

  group('tones use their own roles', () {
    for (final brightness in Brightness.values) {
      final c = brightness == Brightness.light
          ? LeafColors.light
          : LeafColors.dark;
      final expectations = {
        LeafNoticeTone.info: (c.primaryContainer, c.onPrimaryContainer),
        LeafNoticeTone.warning: (c.accentContainer, c.onAccentContainer),
        LeafNoticeTone.offline: (c.surfaceSunken, c.textSecondary),
        LeafNoticeTone.error: (c.dangerContainer, c.onDangerContainer),
      };

      for (final MapEntry(key: tone, value: (background, foreground))
          in expectations.entries) {
        testWidgets('${tone.name} in ${brightness.name} mode', (tester) async {
          await pumpLeaf(
            tester,
            LeafNotice(tone: tone, message: 'Message'),
            brightness: brightness,
          );

          final fill = decorationUnder(tester, notice).color;
          expect(fill, background);
          expect(
            tester.widget<Text>(find.text('Message')).style?.color,
            foreground,
          );
          expect(tester.widget<Icon>(find.byType(Icon)).color, foreground);
        });
      }
    }
  });

  testWidgets('shows a title above the message', (tester) async {
    await pumpLeaf(
      tester,
      const LeafNotice(
        tone: LeafNoticeTone.info,
        title: 'Low confidence',
        message: 'Try another photo in daylight.',
      ),
    );

    final title = tester.getTopLeft(find.text('Low confidence'));
    final message = tester.getTopLeft(
      find.text('Try another photo in daylight.'),
    );
    expect(title.dy, lessThan(message.dy));
  });

  testWidgets('runs its action', (tester) async {
    var retries = 0;
    await pumpLeaf(
      tester,
      LeafNotice(
        tone: LeafNoticeTone.offline,
        message: "You're offline.",
        action: LeafNoticeAction('Retry', onPressed: () => retries++),
      ),
    );

    await tester.tap(find.text('Retry'));

    expect(retries, 1);
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Retry'),
                  matching: find.byType(ConstrainedBox),
                )
                .first,
          )
          .height,
      greaterThanOrEqualTo(LeafSpacing.minTouchTarget),
    );
  });

  testWidgets('shows a dismiss button only when onDismiss is set', (
    tester,
  ) async {
    await pumpLeaf(
      tester,
      const LeafNotice(tone: LeafNoticeTone.info, message: 'Message'),
    );
    expect(find.byIcon(LeafIcons.close), findsNothing);

    var dismissed = 0;
    await pumpLeaf(
      tester,
      LeafNotice(
        tone: LeafNoticeTone.info,
        message: 'Message',
        onDismiss: () => dismissed++,
      ),
    );
    await tester.tap(find.byIcon(LeafIcons.close));

    expect(dismissed, 1);
  });

  testWidgets('is announced when it appears', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(
      tester,
      const LeafNotice(tone: LeafNoticeTone.error, message: 'Upload failed'),
    );

    expect(tester.getSemantics(notice), isSemantics(isLiveRegion: true));
    handle.dispose();
  });
}
