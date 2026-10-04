import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';
import 'package:leaf_lens/design_system/tokens/leaf_typography.dart';

/// Material component themes built from Leaf tokens (plan §4).
///
/// Features use `Leaf*` components; these themes exist so Material widgets
/// shown by packages (pickers, dialogs, selection handles) still match.
abstract final class LeafComponentThemes {
  /// Opacity applied to disabled controls (plan §5).
  static const double disabledOpacity = 0.5;

  /// Opacity of the pressed overlay on Material buttons.
  static const double pressedOverlayOpacity = 0.08;

  static const Size _buttonMinSize = Size(
    LeafSpacing.minTouchTarget,
    LeafSpacing.minTouchTarget,
  );

  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: LeafSpacing.xl,
    vertical: LeafSpacing.sm,
  );

  static const RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: LeafRadii.md,
  );

  static Color _disabled(Color color) =>
      color.withValues(alpha: color.a * disabledOpacity);

  static WidgetStateProperty<Color> _byState(Color color, {Color? disabled}) =>
      WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? disabled ?? _disabled(color)
            : color,
      );

  static WidgetStateProperty<Color?> _pressedOverlay(Color color) =>
      WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.pressed)
            ? color.withValues(alpha: pressedOverlayOpacity)
            : null,
      );

  /// Solid primary button, shared by [FilledButton] and [ElevatedButton].
  static ButtonStyle filledButton(LeafColors c, LeafTypography t) =>
      ButtonStyle(
        backgroundColor: _byState(c.primary),
        foregroundColor: _byState(c.onPrimary),
        overlayColor: _pressedOverlay(c.onPrimary),
        textStyle: WidgetStatePropertyAll(t.label),
        minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
        padding: const WidgetStatePropertyAll(_buttonPadding),
        shape: const WidgetStatePropertyAll(_buttonShape),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      );

  /// Outlined secondary button.
  static ButtonStyle outlinedButton(LeafColors c, LeafTypography t) =>
      ButtonStyle(
        foregroundColor: _byState(c.primary),
        overlayColor: _pressedOverlay(c.primary),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.disabled)
                ? _disabled(c.borderStrong)
                : c.borderStrong,
          ),
        ),
        textStyle: WidgetStatePropertyAll(t.label),
        minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
        padding: const WidgetStatePropertyAll(_buttonPadding),
        shape: const WidgetStatePropertyAll(_buttonShape),
      );

  /// Text-only ghost button.
  static ButtonStyle textButton(LeafColors c, LeafTypography t) => ButtonStyle(
    foregroundColor: _byState(c.primary),
    overlayColor: _pressedOverlay(c.primary),
    textStyle: WidgetStatePropertyAll(t.label),
    minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: LeafSpacing.md),
    ),
    shape: const WidgetStatePropertyAll(_buttonShape),
  );

  /// Icon buttons with a 48 dp target.
  static ButtonStyle iconButton(LeafColors c) => ButtonStyle(
    foregroundColor: _byState(c.textPrimary),
    overlayColor: _pressedOverlay(c.textPrimary),
    minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
  );

  /// App bar: page-coloured, flat, left-aligned title.
  static AppBarTheme appBar(LeafColors c, LeafTypography t) => AppBarTheme(
    backgroundColor: c.background,
    foregroundColor: c.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: t.title,
    iconTheme: IconThemeData(color: c.textPrimary),
  );

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: LeafRadii.md,
        borderSide: BorderSide(color: color, width: width),
      );

  /// Text fields: sunken fill, strong outline, 2 px focus border.
  static InputDecorationThemeData input(LeafColors c, LeafTypography t) =>
      InputDecorationThemeData(
        filled: true,
        fillColor: c.surfaceSunken,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LeafSpacing.md,
          vertical: LeafSpacing.sm,
        ),
        hintStyle: t.body.copyWith(color: c.textMuted),
        labelStyle: t.body.copyWith(color: c.textSecondary),
        helperStyle: t.bodySmall.copyWith(color: c.textSecondary),
        errorStyle: t.bodySmall.copyWith(color: c.danger),
        border: _inputBorder(c.borderStrong),
        enabledBorder: _inputBorder(c.borderStrong),
        disabledBorder: _inputBorder(_disabled(c.borderStrong)),
        focusedBorder: _inputBorder(c.primary, width: 2),
        errorBorder: _inputBorder(c.danger),
        focusedErrorBorder: _inputBorder(c.danger, width: 2),
      );

  static RoundedRectangleBorder _outlined(LeafColors c, BorderRadius radius) =>
      RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.border),
      );

  /// Cards: flat surface with a hairline border.
  static CardThemeData card(LeafColors c) => CardThemeData(
    color: c.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    shape: _outlined(c, LeafRadii.lg),
  );

  /// Dialogs: flat surface, large radius.
  static DialogThemeData dialog(LeafColors c, LeafTypography t) =>
      DialogThemeData(
        backgroundColor: c.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.scrim,
        shape: _outlined(c, LeafRadii.xl),
        titleTextStyle: t.title,
        contentTextStyle: t.body.copyWith(color: c.textSecondary),
      );

  /// Bottom sheets: flat surface rounded on top, with a drag handle.
  static BottomSheetThemeData bottomSheet(LeafColors c) => BottomSheetThemeData(
    backgroundColor: c.surface,
    modalBackgroundColor: c.surface,
    elevation: 0,
    modalElevation: 0,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    modalBarrierColor: c.scrim,
    showDragHandle: true,
    dragHandleColor: c.borderStrong,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: LeafRadii.xlRadius),
    ),
  );

  /// Popup menus: flat surface with a hairline border.
  static PopupMenuThemeData popupMenu(LeafColors c, LeafTypography t) =>
      PopupMenuThemeData(
        color: c.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: _outlined(c, LeafRadii.md),
        textStyle: t.body,
      );

  /// Date pickers shown by packages.
  static DatePickerThemeData datePicker(LeafColors c) => DatePickerThemeData(
    backgroundColor: c.surface,
    elevation: 0,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    headerBackgroundColor: c.background,
    headerForegroundColor: c.textPrimary,
    shape: _outlined(c, LeafRadii.xl),
  );

  /// Snack bars: floating, inverted colours.
  static SnackBarThemeData snackBar(LeafColors c, LeafTypography t) =>
      SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.textPrimary,
        contentTextStyle: t.body.copyWith(color: c.background),
        actionTextColor: c.primaryContainer,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: LeafRadii.md),
      );

  /// List tiles.
  static ListTileThemeData listTile(LeafColors c, LeafTypography t) =>
      ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
        titleTextStyle: t.titleSmall,
        subtitleTextStyle: t.bodySmall.copyWith(color: c.textSecondary),
        selectedColor: c.onPrimaryContainer,
        selectedTileColor: c.primaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: LeafRadii.md),
        contentPadding: const EdgeInsets.symmetric(horizontal: LeafSpacing.md),
        minVerticalPadding: LeafSpacing.xs,
      );

  /// Chips.
  static ChipThemeData chip(LeafColors c, LeafTypography t) => ChipThemeData(
    backgroundColor: c.surface,
    selectedColor: c.primaryContainer,
    disabledColor: _disabled(c.surfaceSunken),
    side: BorderSide(color: c.borderStrong),
    shape: const RoundedRectangleBorder(borderRadius: LeafRadii.sm),
    labelStyle: t.label.copyWith(color: c.textPrimary),
    padding: const EdgeInsets.symmetric(horizontal: LeafSpacing.xs),
    elevation: 0,
    pressElevation: 0,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    checkmarkColor: c.onPrimaryContainer,
  );

  /// Linear and circular progress indicators.
  static ProgressIndicatorThemeData progress(LeafColors c) =>
      ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: Colors.transparent,
      );

  /// Switches.
  static SwitchThemeData switchTheme(LeafColors c) => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? c.onPrimary : c.borderStrong,
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? c.primary : c.surfaceSunken,
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? Colors.transparent
          : c.borderStrong,
    ),
  );

  /// Checkboxes.
  static CheckboxThemeData checkbox(LeafColors c) => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? c.primary
          : Colors.transparent,
    ),
    checkColor: WidgetStatePropertyAll(c.onPrimary),
    side: BorderSide(color: c.borderStrong, width: 1.5),
  );

  /// Radio buttons.
  static RadioThemeData radio(LeafColors c) => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? c.primary : c.borderStrong,
    ),
  );

  /// Dividers: hairline [LeafColors.border].
  static DividerThemeData divider(LeafColors c) =>
      DividerThemeData(color: c.border, thickness: 1, space: 1);

  /// Tooltips: inverted, small radius.
  static TooltipThemeData tooltip(LeafColors c, LeafTypography t) =>
      TooltipThemeData(
        decoration: BoxDecoration(
          color: c.textPrimary,
          borderRadius: LeafRadii.sm,
        ),
        textStyle: t.caption.copyWith(color: c.background),
      );

  /// Text cursor and selection.
  static TextSelectionThemeData textSelection(LeafColors c) =>
      TextSelectionThemeData(
        cursorColor: c.primary,
        selectionColor: c.primaryContainer,
        selectionHandleColor: c.primary,
      );
}
