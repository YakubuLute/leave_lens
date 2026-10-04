import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

import '../support/contrast.dart';

/// Guards plan §3.1: a palette change must not silently break accessibility.
void main() {
  const modes = {'light': LeafColors.light, 'dark': LeafColors.dark};

  for (final MapEntry(key: mode, value: c) in modes.entries) {
    group('$mode mode', () {
      final pages = {
        'background': c.background,
        'surface': c.surface,
        'surfaceSunken': c.surfaceSunken,
      };

      final textPairs = <String, (Color, Color)>{
        for (final page in pages.entries) ...{
          'textPrimary on ${page.key}': (c.textPrimary, page.value),
          'textSecondary on ${page.key}': (c.textSecondary, page.value),
        },
        'textMuted on background': (c.textMuted, c.background),
        'textMuted on surface': (c.textMuted, c.surface),
        'primary on background': (c.primary, c.background),
        'primary on surface': (c.primary, c.surface),
        'onPrimary on primary': (c.onPrimary, c.primary),
        'onPrimaryContainer on primaryContainer': (
          c.onPrimaryContainer,
          c.primaryContainer,
        ),
        'accent on background': (c.accent, c.background),
        'onAccent on accent': (c.onAccent, c.accent),
        'onAccentContainer on accentContainer': (
          c.onAccentContainer,
          c.accentContainer,
        ),
        for (final status in LeafStatus.values) ...{
          '${status.name}.fg on bg': (
            c.forStatus(status).fg,
            c.forStatus(status).bg,
          ),
          '${status.name}.solid on background': (
            c.forStatus(status).solid,
            c.background,
          ),
          '${status.name}.solid on surface': (
            c.forStatus(status).solid,
            c.surface,
          ),
          '${status.name}.onSolid on solid': (
            c.forStatus(status).onSolid,
            c.forStatus(status).solid,
          ),
        },
      };

      for (final MapEntry(key: name, value: (fg, bg)) in textPairs.entries) {
        test('$name meets AA for text', () {
          expect(contrastRatio(fg, bg), greaterThanOrEqualTo(wcagAaText));
        });
      }

      for (final page in pages.entries) {
        test('borderStrong on ${page.key} meets AA for UI boundaries', () {
          expect(
            contrastRatio(c.borderStrong, page.value),
            greaterThanOrEqualTo(wcagAaNonText),
          );
        });
      }
    });
  }
}
