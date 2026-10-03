import 'package:flutter/material.dart';

import 'package:leaf_lense/design_system/tokens/leaf_palette.dart';
import 'package:leaf_lense/design_system/tokens/leaf_status.dart';

/// Colours for one diagnosis status.
@immutable
class LeafStatusColors {
  /// Creates a status colour set.
  const LeafStatusColors({
    required this.fg,
    required this.bg,
    required this.solid,
    required this.onSolid,
  });

  /// Text and icon colour on [bg].
  final Color fg;

  /// Tinted background for badges and notices.
  final Color bg;

  /// Strong colour for meters and filled badges. Readable as text on the page.
  final Color solid;

  /// Text and icon colour on [solid].
  final Color onSolid;

  /// Linearly interpolates between two status colour sets.
  static LeafStatusColors lerp(
    LeafStatusColors a,
    LeafStatusColors b,
    double t,
  ) {
    return LeafStatusColors(
      fg: Color.lerp(a.fg, b.fg, t)!,
      bg: Color.lerp(a.bg, b.bg, t)!,
      solid: Color.lerp(a.solid, b.solid, t)!,
      onSolid: Color.lerp(a.onSolid, b.onSolid, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LeafStatusColors &&
      other.fg == fg &&
      other.bg == bg &&
      other.solid == solid &&
      other.onSolid == onSolid;

  @override
  int get hashCode => Object.hash(fg, bg, solid, onSolid);
}

/// Semantic colour roles for Leaf Lens.
///
/// Read with `context.leafColors` (step 3). Never use raw [Color] values in
/// feature code; add a role here instead.
@immutable
class LeafColors extends ThemeExtension<LeafColors> {
  /// Creates a colour set. Prefer [LeafColors.light] or [LeafColors.dark].
  const LeafColors({
    required this.background,
    required this.surface,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.accent,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
    required this.healthy,
    required this.diseased,
    required this.uncertain,
    required this.shadow,
    required this.scrim,
  });

  /// Light mode: cream canvas, olive primary, terracotta accent.
  static const LeafColors light = LeafColors(
    background: LeafPalette.sand100,
    surface: LeafPalette.sand50,
    surfaceSunken: LeafPalette.sand200,
    border: LeafPalette.sand300,
    borderStrong: LeafPalette.sand500,
    textPrimary: LeafPalette.sand900,
    textSecondary: LeafPalette.sand700,
    textMuted: LeafPalette.sand600,
    primary: LeafPalette.olive600,
    onPrimary: LeafPalette.sand50,
    primaryContainer: LeafPalette.olive100,
    onPrimaryContainer: LeafPalette.olive900,
    accent: LeafPalette.terracotta600,
    onAccent: LeafPalette.sand50,
    accentContainer: LeafPalette.terracotta100,
    onAccentContainer: LeafPalette.terracotta800,
    healthy: LeafStatusColors(
      fg: LeafPalette.jade800,
      bg: LeafPalette.jade100,
      solid: LeafPalette.jade600,
      onSolid: LeafPalette.sand50,
    ),
    diseased: LeafStatusColors(
      fg: LeafPalette.brick800,
      bg: LeafPalette.brick100,
      solid: LeafPalette.brick600,
      onSolid: LeafPalette.sand50,
    ),
    uncertain: LeafStatusColors(
      fg: LeafPalette.ochre800,
      bg: LeafPalette.ochre100,
      solid: LeafPalette.ochre600,
      onSolid: LeafPalette.sand50,
    ),
    shadow: LeafPalette.shadowLight,
    scrim: LeafPalette.scrimLight,
  );

  /// Dark mode: warm charcoal, lightened olive and terracotta.
  static const LeafColors dark = LeafColors(
    background: LeafPalette.bark900,
    surface: LeafPalette.bark800,
    surfaceSunken: LeafPalette.bark950,
    border: LeafPalette.bark700,
    borderStrong: LeafPalette.bark500,
    textPrimary: LeafPalette.bark100,
    textSecondary: LeafPalette.bark300,
    textMuted: LeafPalette.bark400,
    primary: LeafPalette.olive300,
    onPrimary: LeafPalette.olive950,
    primaryContainer: LeafPalette.olive800,
    onPrimaryContainer: LeafPalette.olive150,
    accent: LeafPalette.terracotta300,
    onAccent: LeafPalette.terracotta950,
    accentContainer: LeafPalette.terracotta850,
    onAccentContainer: LeafPalette.terracotta150,
    healthy: LeafStatusColors(
      fg: LeafPalette.jade300,
      bg: LeafPalette.jade900,
      solid: LeafPalette.jade400,
      onSolid: LeafPalette.bark900,
    ),
    diseased: LeafStatusColors(
      fg: LeafPalette.brick300,
      bg: LeafPalette.brick900,
      solid: LeafPalette.brick400,
      onSolid: LeafPalette.bark900,
    ),
    uncertain: LeafStatusColors(
      fg: LeafPalette.ochre300,
      bg: LeafPalette.ochre900,
      solid: LeafPalette.ochre400,
      onSolid: LeafPalette.bark900,
    ),
    shadow: LeafPalette.shadowDark,
    scrim: LeafPalette.scrimDark,
  );

  /// Page canvas.
  final Color background;

  /// Cards and sheets.
  final Color surface;

  /// Input fills and insets.
  final Color surfaceSunken;

  /// Decorative hairlines.
  final Color border;

  /// Control outlines (inputs, chips). At least 3:1 against every surface.
  final Color borderStrong;

  /// Default text.
  final Color textPrimary;

  /// Supporting text.
  final Color textSecondary;

  /// Hints and metadata. Still meets AA on [background].
  final Color textMuted;

  /// Brand olive: primary actions, focus rings, links.
  final Color primary;

  /// Text and icons on [primary].
  final Color onPrimary;

  /// Quiet primary tint, e.g. selected states.
  final Color primaryContainer;

  /// Text and icons on [primaryContainer].
  final Color onPrimaryContainer;

  /// Brand terracotta. Keep away from diagnosis results (see plan §11).
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Quiet accent tint.
  final Color accentContainer;

  /// Text and icons on [accentContainer].
  final Color onAccentContainer;

  /// Reserved for the "healthy" diagnosis status.
  final LeafStatusColors healthy;

  /// Reserved for the "diseased" diagnosis status.
  final LeafStatusColors diseased;

  /// Reserved for the "uncertain" diagnosis status.
  final LeafStatusColors uncertain;

  /// Colour for the single `floating` shadow.
  final Color shadow;

  /// Modal barrier behind sheets and dialogs.
  final Color scrim;

  /// Neutral set for [LeafStatus.notALeaf], built from neutral roles.
  LeafStatusColors get notALeaf => LeafStatusColors(
    fg: textSecondary,
    bg: surfaceSunken,
    solid: textMuted,
    onSolid: surface,
  );

  /// The colour set for [status].
  LeafStatusColors forStatus(LeafStatus status) => switch (status) {
    LeafStatus.healthy => healthy,
    LeafStatus.diseased => diseased,
    LeafStatus.uncertain => uncertain,
    LeafStatus.notALeaf => notALeaf,
  };

  @override
  LeafColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? accent,
    Color? onAccent,
    Color? accentContainer,
    Color? onAccentContainer,
    LeafStatusColors? healthy,
    LeafStatusColors? diseased,
    LeafStatusColors? uncertain,
    Color? shadow,
    Color? scrim,
  }) {
    return LeafColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentContainer: accentContainer ?? this.accentContainer,
      onAccentContainer: onAccentContainer ?? this.onAccentContainer,
      healthy: healthy ?? this.healthy,
      diseased: diseased ?? this.diseased,
      uncertain: uncertain ?? this.uncertain,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  LeafColors lerp(LeafColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return LeafColors(
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      primary: c(primary, other.primary),
      onPrimary: c(onPrimary, other.onPrimary),
      primaryContainer: c(primaryContainer, other.primaryContainer),
      onPrimaryContainer: c(onPrimaryContainer, other.onPrimaryContainer),
      accent: c(accent, other.accent),
      onAccent: c(onAccent, other.onAccent),
      accentContainer: c(accentContainer, other.accentContainer),
      onAccentContainer: c(onAccentContainer, other.onAccentContainer),
      healthy: LeafStatusColors.lerp(healthy, other.healthy, t),
      diseased: LeafStatusColors.lerp(diseased, other.diseased, t),
      uncertain: LeafStatusColors.lerp(uncertain, other.uncertain, t),
      shadow: c(shadow, other.shadow),
      scrim: c(scrim, other.scrim),
    );
  }
}
