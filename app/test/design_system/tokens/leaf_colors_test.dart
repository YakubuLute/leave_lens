import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  const light = LeafColors.light;
  const dark = LeafColors.dark;

  group('LeafColors.lerp', () {
    test('returns the start set at t = 0 and the end set at t = 1', () {
      expect(_roles(light.lerp(dark, 0)), _roles(light));
      expect(_roles(light.lerp(dark, 1)), _roles(dark));
    });

    test('interpolates status colours', () {
      final mid = light.lerp(dark, 0.5);
      expect(
        mid.healthy.solid,
        Color.lerp(light.healthy.solid, dark.healthy.solid, 0.5),
      );
    });

    test('returns itself when other is null', () {
      expect(light.lerp(null, 0.5), same(light));
    });
  });

  group('LeafColors.copyWith', () {
    test('overrides only the given role', () {
      const replacement = Color(0xFF123456);
      final copy = light.copyWith(primary: replacement);
      expect(copy.primary, replacement);
      expect(copy.background, light.background);
      expect(copy.healthy, light.healthy);
    });
  });

  group('LeafColors.forStatus', () {
    test('maps each status to its reserved set', () {
      expect(light.forStatus(LeafStatus.healthy), light.healthy);
      expect(light.forStatus(LeafStatus.diseased), light.diseased);
      expect(light.forStatus(LeafStatus.uncertain), light.uncertain);
      expect(light.forStatus(LeafStatus.notALeaf), light.notALeaf);
    });

    test('notALeaf uses neutral roles, not status hues', () {
      expect(light.notALeaf.fg, light.textSecondary);
      expect(light.notALeaf.bg, light.surfaceSunken);
    });

    test('status colours are distinct from each other and from primary', () {
      final solids = {
        light.primary,
        light.accent,
        light.healthy.solid,
        light.diseased.solid,
        light.uncertain.solid,
      };
      expect(solids, hasLength(5));
    });
  });
}

/// Every role as a flat list, so whole sets can be compared.
List<Object> _roles(LeafColors c) => [
  c.background,
  c.surface,
  c.surfaceSunken,
  c.border,
  c.borderStrong,
  c.textPrimary,
  c.textSecondary,
  c.textMuted,
  c.primary,
  c.onPrimary,
  c.primaryContainer,
  c.onPrimaryContainer,
  c.accent,
  c.onAccent,
  c.accentContainer,
  c.onAccentContainer,
  c.healthy,
  c.diseased,
  c.uncertain,
  c.shadow,
  c.scrim,
];
