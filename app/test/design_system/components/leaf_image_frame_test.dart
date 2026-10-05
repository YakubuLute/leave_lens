import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/pump_leaf.dart';

/// A valid 1×1 transparent PNG.
final _pixel = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
    '60e6kgAAAABJRU5ErkJggg==',
  ),
);

/// Bytes that aren't an image, to trigger the error state.
final _broken = MemoryImage(utf8.encode('not an image'));

void main() {
  final frame = find.byType(LeafImageFrame);

  testWidgets('shows the leaf placeholder without an image', (tester) async {
    await pumpLeaf(
      tester,
      const SizedBox(width: 200, child: LeafImageFrame(image: null)),
    );

    expect(find.byIcon(LeafIcons.leaf), findsOneWidget);
  });

  testWidgets('keeps its aspect ratio', (tester) async {
    await pumpLeaf(
      tester,
      const SizedBox(
        width: 300,
        child: LeafImageFrame(image: null, aspectRatio: 3 / 2),
      ),
    );

    expect(tester.getSize(frame), const Size(300, 200));
  });

  testWidgets('shows the image when it loads', (tester) async {
    await pumpLeaf(
      tester,
      SizedBox(width: 200, child: LeafImageFrame(image: _pixel)),
    );
    await tester.runAsync(() => precacheImage(_pixel, tester.element(frame)));
    await tester.pumpAndSettle();

    expect(find.byType(RawImage), findsOneWidget);
    expect(find.byIcon(LeafIcons.leaf), findsNothing);
  });

  testWidgets('shows an error placeholder when the image fails', (
    tester,
  ) async {
    await pumpLeaf(
      tester,
      SizedBox(width: 200, child: LeafImageFrame(image: _broken)),
    );
    await tester.runAsync(() async {
      await precacheImage(_broken, tester.element(frame), onError: (_, _) {});
    });
    await tester.pumpAndSettle();

    expect(find.byIcon(LeafIcons.info), findsOneWidget);
  });

  testWidgets('is decorative without a label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLeaf(
      tester,
      SizedBox(width: 200, child: LeafImageFrame(image: _pixel)),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.excludeFromSemantics, isTrue);
    handle.dispose();
  });

  testWidgets('passes a label to screen readers', (tester) async {
    await pumpLeaf(
      tester,
      SizedBox(
        width: 200,
        child: LeafImageFrame(
          image: _pixel,
          semanticLabel: 'Photo of the scanned leaf',
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.semanticLabel, 'Photo of the scanned leaf');
    expect(image.excludeFromSemantics, isFalse);
  });

  testWidgets('uses xl corners and a hairline border', (tester) async {
    await pumpLeaf(
      tester,
      const SizedBox(width: 200, child: LeafImageFrame(image: null)),
    );

    final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, LeafRadii.xl);
    expect(focusRingUnder(tester, frame), isNotNull);
  });
}
