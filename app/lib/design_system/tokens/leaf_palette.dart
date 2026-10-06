import 'package:flutter/painting.dart';

/// Raw colour values for the Leaf Lens palette.
///
/// Internal to the design system: features must use the semantic roles in
/// `LeafColors` instead. This file is intentionally not exported from
/// `design_system.dart`.
///
/// Contrast ratios for every semantic pairing are asserted in
/// `test/design_system/tokens/leaf_colors_contrast_test.dart`.
abstract final class LeafPalette {
  // Warm neutrals — light mode.
  static const Color sand50 = Color(0xFFFFFBF3);
  static const Color sand100 = Color(0xFFF7F1E6);
  static const Color sand200 = Color(0xFFEFE6D4);
  static const Color sand300 = Color(0xFFDCCFB4);
  static const Color sand500 = Color(0xFF8F7B57);
  static const Color sand600 = Color(0xFF786852);
  static const Color sand700 = Color(0xFF6B5B45);
  static const Color sand900 = Color(0xFF3A2E1F);

  // Warm neutrals — dark mode.
  static const Color bark950 = Color(0xFF110E0B);
  static const Color bark900 = Color(0xFF16130F);
  static const Color bark800 = Color(0xFF201C16);
  static const Color bark700 = Color(0xFF3A3328);
  static const Color bark500 = Color(0xFF857760);
  static const Color bark400 = Color(0xFF9A8C75);
  static const Color bark300 = Color(0xFFC2B49C);
  static const Color bark100 = Color(0xFFF1E9DA);

  // Olive — brand primary.
  static const Color olive100 = Color(0xFFE3E8D2);
  static const Color olive150 = Color(0xFFDCE8C6);
  static const Color olive300 = Color(0xFFA9C47F);
  static const Color olive600 = Color(0xFF4F6B2F);
  static const Color olive800 = Color(0xFF34461F);
  static const Color olive900 = Color(0xFF2C3D18);
  static const Color olive950 = Color(0xFF1E2A10);

  // Terracotta — brand accent.
  static const Color terracotta100 = Color(0xFFF6E0D2);
  static const Color terracotta150 = Color(0xFFF6D2BA);
  static const Color terracotta300 = Color(0xFFE39A6B);
  static const Color terracotta600 = Color(0xFFA9531F);
  static const Color terracotta800 = Color(0xFF6E3412);
  static const Color terracotta850 = Color(0xFF4A2A15);
  static const Color terracotta950 = Color(0xFF2A1406);

  // Jade — "healthy" status.
  static const Color jade100 = Color(0xFFDDEFE4);
  static const Color jade300 = Color(0xFF8AD3A9);
  static const Color jade400 = Color(0xFF5FB98A);
  static const Color jade600 = Color(0xFF2A7454);
  static const Color jade800 = Color(0xFF1D5A3F);
  static const Color jade900 = Color(0xFF173A2A);

  // Brick — "diseased" status.
  static const Color brick100 = Color(0xFFF6D9D5);
  static const Color brick300 = Color(0xFFF4A497);
  static const Color brick400 = Color(0xFFE8806E);
  static const Color brick600 = Color(0xFFA1302A);
  static const Color brick800 = Color(0xFF7A1F1A);
  static const Color brick900 = Color(0xFF4A1C17);

  // Ochre — "uncertain" status.
  static const Color ochre100 = Color(0xFFF5E7C8);
  static const Color ochre300 = Color(0xFFEBC67E);
  static const Color ochre400 = Color(0xFFD9A84E);
  static const Color ochre600 = Color(0xFF8A5D0E);
  static const Color ochre800 = Color(0xFF6B4A0C);
  static const Color ochre900 = Color(0xFF3D2D0E);

  // Overlays.
  /// `sand900` at 12% — warm shadow for light mode.
  static const Color shadowLight = Color(0x1F3A2E1F);

  /// Black at 40% — shadows need more weight on dark surfaces.
  static const Color shadowDark = Color(0x66000000);

  /// `sand900` at 40% — modal barrier in light mode.
  static const Color scrimLight = Color(0x663A2E1F);

  /// Black at 60% — modal barrier in dark mode.
  static const Color scrimDark = Color(0x99000000);
}
