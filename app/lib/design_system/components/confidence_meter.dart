import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_gap.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_motion.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_status.dart';

/// How sure the model is, shown three ways: words, a percentage and a bar in
/// the status colour.
///
/// The words come from presentation-only bands ([highBand], [mediumBand]).
/// They are not the hybrid model's fallback threshold, which lives in config.
class ConfidenceMeter extends StatelessWidget {
  /// Creates a meter. [value] must be between 0 and 1.
  const ConfidenceMeter({required this.value, required this.status, super.key})
    : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  /// At or above this, the meter reads "High confidence".
  static const double highBand = 0.85;

  /// At or above this (and below [highBand]), "Medium confidence".
  static const double mediumBand = 0.6;

  /// Height of the bar.
  static const double barHeight = 8;

  /// Confidence from 0 to 1.
  final double value;

  /// Colours the bar to match the diagnosis.
  final LeafStatus status;

  /// The words shown for [value].
  static String describe(double value) => value >= highBand
      ? 'High confidence'
      : value >= mediumBand
      ? 'Medium confidence'
      : 'Low confidence';

  /// [value] as a whole percentage, e.g. "93%".
  static String percent(double value) => '${(value * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final text = context.leafText;
    final description = describe(value);
    final percentage = percent(value);

    return Semantics(
      container: true,
      label: description,
      value: percentage,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  style: text.bodySmall.copyWith(color: colors.textSecondary),
                ),
              ),
              Text(
                percentage,
                style: text.titleSmall.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const LeafGap.xs(),
          ClipRRect(
            borderRadius: LeafRadii.full,
            child: SizedBox(
              height: barHeight,
              // `border` keeps the empty track visible on the page in both
              // modes, so the bar's full length is always readable.
              child: ColoredBox(
                color: colors.border,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value),
                  duration: LeafMotion.resolve(context, LeafMotion.slow),
                  curve: LeafMotion.standard,
                  builder: (context, fill, _) => FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: fill,
                    child: ColoredBox(color: colors.forStatus(status).solid),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
