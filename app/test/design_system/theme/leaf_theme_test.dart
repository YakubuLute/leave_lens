import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  final modes = {
    'light': (LeafTheme.light(), LeafColors.light, Brightness.light),
    'dark': (LeafTheme.dark(), LeafColors.dark, Brightness.dark),
  };

  for (final MapEntry(key: mode, value: (theme, colors, brightness))
      in modes.entries) {
    group('LeafTheme.$mode', () {
      test('carries the matching token extensions', () {
        expect(theme.brightness, brightness);
        expect(theme.extension<LeafColors>(), colors);
        expect(theme.extension<LeafTypography>(), isNotNull);
      });

      test('maps Leaf roles onto the ColorScheme', () {
        final scheme = theme.colorScheme;
        expect(scheme.primary, colors.primary);
        expect(scheme.secondary, colors.accent);
        expect(scheme.surface, colors.surface);
        expect(scheme.onSurface, colors.textPrimary);
        expect(scheme.outline, colors.borderStrong);
        expect(scheme.error, colors.danger);
        expect(scheme.surfaceTint, Colors.transparent);
      });

      test('removes the stock Material look', () {
        expect(theme.splashFactory, NoSplash.splashFactory);
        expect(theme.scaffoldBackgroundColor, colors.background);
        expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
        expect(theme.appBarTheme.scrolledUnderElevation, 0);
        expect(theme.appBarTheme.centerTitle, isFalse);
        expect(theme.cardTheme.elevation, 0);
        expect(theme.bottomSheetTheme.modalElevation, 0);
        expect(theme.dialogTheme.elevation, 0);
      });

      test('uses the Leaf transition everywhere except iOS', () {
        final builders = theme.pageTransitionsTheme.builders;
        expect(
          builders[TargetPlatform.android],
          isA<LeafPageTransitionsBuilder>(),
        );
        expect(
          builders[TargetPlatform.iOS],
          isA<CupertinoPageTransitionsBuilder>(),
        );
      });

      test('dims disabled filled buttons to 50% opacity', () {
        final style = theme.filledButtonTheme.style!;
        final enabled = style.backgroundColor!.resolve({})!;
        final disabled = style.backgroundColor!.resolve({
          WidgetState.disabled,
        })!;
        expect(enabled, colors.primary);
        expect(disabled.a, closeTo(colors.primary.a * 0.5, 0.01));
      });

      test('buttons keep a 48 dp minimum touch target', () {
        final size = theme.filledButtonTheme.style!.minimumSize!.resolve({})!;
        expect(size.height, greaterThanOrEqualTo(LeafSpacing.minTouchTarget));
      });
    });
  }

  group('LeafThemeContext', () {
    Future<(LeafColors, LeafTypography)> readTokens(
      WidgetTester tester,
      ThemeMode mode,
    ) async {
      late LeafColors colors;
      late LeafTypography text;
      await tester.pumpWidget(
        MaterialApp(
          theme: LeafTheme.light(),
          darkTheme: LeafTheme.dark(),
          themeMode: mode,
          home: Builder(
            builder: (context) {
              colors = context.leafColors;
              text = context.leafText;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      return (colors, text);
    }

    testWidgets('reads light tokens', (tester) async {
      final (colors, text) = await readTokens(tester, ThemeMode.light);
      expect(colors, LeafColors.light);
      expect(text.body.color, LeafColors.light.textPrimary);
    });

    testWidgets('reads dark tokens', (tester) async {
      final (colors, _) = await readTokens(tester, ThemeMode.dark);
      expect(colors, LeafColors.dark);
    });

    testWidgets('throws a clear error without LeafTheme', (tester) async {
      Object? error;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                context.leafColors;
              } on FlutterError catch (e) {
                error = e;
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('LeafTheme'));
    });
  });

  testWidgets('Material widgets render with Leaf surfaces', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LeafTheme.light(),
        home: Scaffold(
          body: Column(
            children: [
              const Card(child: Text('Card')),
              FilledButton(onPressed: () {}, child: const Text('Go')),
              const TextField(),
            ],
          ),
        ),
      ),
    );

    final cardMaterial = tester.widget<Material>(
      find.descendant(of: find.byType(Card), matching: find.byType(Material)),
    );
    expect(cardMaterial.color, LeafColors.light.surface);
    expect(cardMaterial.elevation, 0);
    expect(tester.takeException(), isNull);
  });
}
