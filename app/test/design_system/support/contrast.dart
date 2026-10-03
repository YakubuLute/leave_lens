import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// WCAG 2.1 contrast ratio between two opaque colours, from 1 to 21.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Minimum ratio for normal-size text (WCAG AA, 1.4.3).
const double wcagAaText = 4.5;

/// Minimum ratio for UI component boundaries (WCAG AA, 1.4.11).
const double wcagAaNonText = 3;
