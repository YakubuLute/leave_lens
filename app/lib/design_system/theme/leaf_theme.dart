import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:leaf_lens/design_system/theme/leaf_component_themes.dart';
import 'package:leaf_lens/design_system/theme/leaf_page_transitions_builder.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_typography.dart';

/// Builds Leaf Lens [ThemeData] from the design tokens.
///
/// The theme replaces Material's default look (ripples, surface tint,
/// elevation, Roboto) so anything Material renders still feels like Leaf Lens.
abstract final class LeafTheme {
  /// Light theme.
  static ThemeData light() => _build(LeafColors.light, Brightness.light);

  /// Dark theme.
  static ThemeData dark() => _build(LeafColors.dark, Brightness.dark);

  static ThemeData _build(LeafColors c, Brightness brightness) {
    final t = LeafTypography.fromColors(c);
    final colorScheme = _colorScheme(c, brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: LeafTypography.bodyFamily,
      textTheme: _textTheme(t),
      extensions: [c, t],

      // Tap feedback is handled by Leaf components (scale + opacity).
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: c.textPrimary.withValues(alpha: 0.04),
      focusColor: c.primary.withValues(alpha: 0.12),

      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      cardColor: c.surface,
      dividerColor: c.border,
      disabledColor: c.textMuted,
      shadowColor: c.shadow,
      iconTheme: IconThemeData(color: c.textPrimary, size: 24),
      primaryIconTheme: IconThemeData(color: c.onPrimary, size: 24),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: LeafPageTransitionsBuilder(),
          TargetPlatform.fuchsia: LeafPageTransitionsBuilder(),
          TargetPlatform.linux: LeafPageTransitionsBuilder(),
          TargetPlatform.windows: LeafPageTransitionsBuilder(),
          TargetPlatform.macOS: LeafPageTransitionsBuilder(),
          // Keeps the native swipe-back gesture.
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      appBarTheme: LeafComponentThemes.appBar(
        c,
        t,
      ).copyWith(systemOverlayStyle: _systemOverlay(c, brightness)),
      filledButtonTheme: FilledButtonThemeData(
        style: LeafComponentThemes.filledButton(c, t),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: LeafComponentThemes.filledButton(c, t),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: LeafComponentThemes.outlinedButton(c, t),
      ),
      textButtonTheme: TextButtonThemeData(
        style: LeafComponentThemes.textButton(c, t),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: LeafComponentThemes.iconButton(c),
      ),
      inputDecorationTheme: LeafComponentThemes.input(c, t),
      cardTheme: LeafComponentThemes.card(c),
      dialogTheme: LeafComponentThemes.dialog(c, t),
      bottomSheetTheme: LeafComponentThemes.bottomSheet(c),
      popupMenuTheme: LeafComponentThemes.popupMenu(c, t),
      datePickerTheme: LeafComponentThemes.datePicker(c),
      snackBarTheme: LeafComponentThemes.snackBar(c, t),
      listTileTheme: LeafComponentThemes.listTile(c, t),
      chipTheme: LeafComponentThemes.chip(c, t),
      progressIndicatorTheme: LeafComponentThemes.progress(c),
      switchTheme: LeafComponentThemes.switchTheme(c),
      checkboxTheme: LeafComponentThemes.checkbox(c),
      radioTheme: LeafComponentThemes.radio(c),
      dividerTheme: LeafComponentThemes.divider(c),
      tooltipTheme: LeafComponentThemes.tooltip(c, t),
      textSelectionTheme: LeafComponentThemes.textSelection(c),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: brightness,
        primaryColor: c.primary,
        scaffoldBackgroundColor: c.background,
        barBackgroundColor: c.background,
      ),
    );
  }

  /// Maps Leaf roles onto every [ColorScheme] slot so unwrapped Material
  /// widgets pick up our palette instead of generated tonal colours.
  static ColorScheme _colorScheme(LeafColors c, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primaryContainer,
      onPrimaryContainer: c.onPrimaryContainer,
      secondary: c.accent,
      onSecondary: c.onAccent,
      secondaryContainer: c.accentContainer,
      onSecondaryContainer: c.onAccentContainer,
      tertiary: c.accent,
      onTertiary: c.onAccent,
      tertiaryContainer: c.accentContainer,
      onTertiaryContainer: c.onAccentContainer,
      error: c.danger,
      onError: c.onDanger,
      errorContainer: c.dangerContainer,
      onErrorContainer: c.onDangerContainer,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceDim: c.surfaceSunken,
      surfaceBright: c.surface,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surface,
      surfaceContainerHighest: c.surfaceSunken,
      outline: c.borderStrong,
      outlineVariant: c.border,
      shadow: c.shadow,
      scrim: c.scrim,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.background,
      inversePrimary: c.primaryContainer,
      surfaceTint: Colors.transparent,
    );
  }

  /// Maps the Leaf type scale onto Material's text roles.
  static TextTheme _textTheme(LeafTypography t) {
    return TextTheme(
      displayLarge: t.display,
      displayMedium: t.display,
      displaySmall: t.display,
      headlineLarge: t.headline,
      headlineMedium: t.headline,
      headlineSmall: t.headline,
      titleLarge: t.title,
      titleMedium: t.titleSmall,
      titleSmall: t.label,
      bodyLarge: t.body,
      bodyMedium: t.body,
      bodySmall: t.bodySmall,
      labelLarge: t.label,
      labelMedium: t.caption,
      labelSmall: t.caption,
    );
  }

  /// Transparent status bar with icons that contrast with the page.
  static SystemUiOverlayStyle _systemOverlay(
    LeafColors c,
    Brightness brightness,
  ) {
    final base = brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    return base.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.background,
    );
  }
}
