import 'package:flutter/material.dart';

import 'package:leaf_lense/design_system/tokens/leaf_colors.dart';

/// The Leaf Lens type scale.
///
/// Read with `context.leafText` (step 3). Styles carry `textPrimary` as their
/// default colour; override with `copyWith(color: …)` using a colour role.
@immutable
class LeafTypography extends ThemeExtension<LeafTypography> {
  /// Creates a type scale. Prefer [LeafTypography.fromColors].
  const LeafTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.titleSmall,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.caption,
  });

  /// Builds the scale from the plan (§3.2), coloured for [colors].
  factory LeafTypography.fromColors(LeafColors colors) {
    final color = colors.textPrimary;
    return LeafTypography(
      display: _style(headingFamily, 32, 40, FontWeight.w700, -0.6, color),
      headline: _style(headingFamily, 24, 32, FontWeight.w700, -0.4, color),
      title: _style(headingFamily, 20, 28, FontWeight.w600, -0.2, color),
      titleSmall: _style(bodyFamily, 17, 24, FontWeight.w600, 0, color),
      body: _style(bodyFamily, 16, 24, FontWeight.w400, 0, color),
      bodySmall: _style(bodyFamily, 14, 20, FontWeight.w400, 0, color),
      label: _style(bodyFamily, 15, 20, FontWeight.w600, 0, color),
      caption: _style(bodyFamily, 12, 16, FontWeight.w500, 0.2, color),
    );
  }

  /// Font family for [display], [headline] and [title]. Change this one line
  /// to bring back a serif for headings.
  static const String headingFamily = 'Inter';

  /// Font family for all other text.
  static const String bodyFamily = 'Inter';

  /// Hero headings, the result's disease name.
  final TextStyle display;

  /// Screen titles.
  final TextStyle headline;

  /// Card titles, sections.
  final TextStyle title;

  /// List titles, emphasis.
  final TextStyle titleSmall;

  /// Default text.
  final TextStyle body;

  /// Secondary text.
  final TextStyle bodySmall;

  /// Buttons, tabs, badges.
  final TextStyle label;

  /// Metadata only — never for essential information.
  final TextStyle caption;

  static TextStyle _style(
    String family,
    double size,
    double lineHeight,
    FontWeight weight,
    double letterSpacing,
    Color color,
  ) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      height: lineHeight / size,
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  @override
  LeafTypography copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? titleSmall,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return LeafTypography(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      titleSmall: titleSmall ?? this.titleSmall,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  @override
  LeafTypography lerp(LeafTypography? other, double t) {
    if (other == null) return this;
    TextStyle s(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return LeafTypography(
      display: s(display, other.display),
      headline: s(headline, other.headline),
      title: s(title, other.title),
      titleSmall: s(titleSmall, other.titleSmall),
      body: s(body, other.body),
      bodySmall: s(bodySmall, other.bodySmall),
      label: s(label, other.label),
      caption: s(caption, other.caption),
    );
  }
}
