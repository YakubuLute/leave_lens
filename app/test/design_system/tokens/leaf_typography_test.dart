import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  final type = LeafTypography.fromColors(LeafColors.light);

  // (style, size, line height) from plan §3.2.
  final scale = <String, (TextStyle, double, double)>{
    'display': (type.display, 32, 40),
    'headline': (type.headline, 24, 32),
    'title': (type.title, 20, 28),
    'titleSmall': (type.titleSmall, 17, 24),
    'body': (type.body, 16, 24),
    'bodySmall': (type.bodySmall, 14, 20),
    'label': (type.label, 15, 20),
    'caption': (type.caption, 12, 16),
  };

  for (final MapEntry(key: name, value: (style, size, lineHeight))
      in scale.entries) {
    test('$name is Inter at $size/$lineHeight in textPrimary', () {
      expect(style.fontFamily, 'Inter');
      expect(style.fontSize, size);
      expect(style.fontSize! * style.height!, closeTo(lineHeight, 0.001));
      expect(style.color, LeafColors.light.textPrimary);
    });
  }

  test('body text is at least 16 sp for outdoor readability', () {
    expect(type.body.fontSize, greaterThanOrEqualTo(16));
  });

  test('headings use the heading family token', () {
    for (final style in [type.display, type.headline, type.title]) {
      expect(style.fontFamily, LeafTypography.headingFamily);
    }
  });

  test('dark scale uses dark textPrimary', () {
    final darkType = LeafTypography.fromColors(LeafColors.dark);
    expect(darkType.body.color, LeafColors.dark.textPrimary);
  });

  test('lerp returns the end styles at t = 1', () {
    final darkType = LeafTypography.fromColors(LeafColors.dark);
    expect(type.lerp(darkType, 1).body.color, darkType.body.color);
  });
}
