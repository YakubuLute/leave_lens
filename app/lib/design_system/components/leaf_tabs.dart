import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_motion.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// One option in [LeafTabs].
@immutable
class LeafTab<T> {
  /// Creates a tab for [value].
  const LeafTab({required this.value, required this.label});

  /// The value reported to `onChanged` when this tab is chosen.
  final T value;

  /// Short label, e.g. "Organic".
  final String label;
}

/// A segmented control for switching between sections, such as the treatment
/// tabs on the result screen.
///
/// It only renders the tab bar; the caller shows the content for [selected].
/// Segments scroll sideways if they don't fit, so labels are never squeezed at
/// large text sizes.
class LeafTabs<T> extends StatelessWidget {
  /// Creates a tab bar. [selected] must match one of the [tabs].
  LeafTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    super.key,
  }) : assert(
         tabs.any((tab) => tab.value == selected),
         'selected must be one of the tabs',
       );

  /// The options, in order.
  final List<LeafTab<T>> tabs;

  /// The currently selected value.
  final T selected;

  /// Called with the new value when the user picks a different tab.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.leafColors.surfaceSunken,
        borderRadius: LeafRadii.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(LeafSpacing.xxs),
        child: Row(
          children: [
            for (final tab in tabs)
              _Segment(
                label: tab.label,
                isSelected: tab.value == selected,
                onPressed: () {
                  if (tab.value != selected) onChanged(tab.value);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;

    return LeafPressable(
      onPressed: onPressed,
      borderRadius: LeafRadii.sm,
      isSelected: isSelected,
      child: AnimatedContainer(
        duration: LeafMotion.resolve(context, LeafMotion.base),
        curve: LeafMotion.standard,
        constraints: const BoxConstraints(
          minHeight: LeafSpacing.minTouchTarget,
          minWidth: LeafSpacing.minTouchTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: LeafSpacing.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: LeafRadii.sm,
          border: Border.all(
            color: isSelected ? colors.border : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: context.leafText.label.copyWith(
            color: isSelected ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
