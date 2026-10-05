import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_motion.dart';

/// Shared tap behaviour for Leaf components (plan §5): shrink-on-press instead
/// of a ripple, a 2 px focus ring for keyboard users, keyboard activation and
/// button semantics.
///
/// Internal to the design system — not exported from `design_system.dart`.
/// Disabled styling (dimming) is left to each component, because a loading
/// button blocks taps without looking disabled.
class LeafPressable extends StatefulWidget {
  /// Wraps [child] with Leaf press behaviour.
  const LeafPressable({
    required this.child,
    required this.onPressed,
    required this.borderRadius,
    this.semanticLabel,
    this.isSelected,
    this.pressedScale = defaultPressedScale,
    super.key,
  });

  /// Scale applied while pressed.
  static const double defaultPressedScale = 0.97;

  /// Opacity components apply when disabled (plan §5).
  static const double disabledOpacity = 0.5;

  /// Width of the keyboard focus ring.
  static const double focusRingWidth = 2;

  /// Content to make pressable.
  final Widget child;

  /// Tap handler. `null` disables taps and marks the control disabled for
  /// assistive technology.
  final VoidCallback? onPressed;

  /// Shape of the focus ring; match the component's own corners.
  final BorderRadius borderRadius;

  /// Accessible name. Replaces the child's text for screen readers; when
  /// `null`, the child's text is used.
  final String? semanticLabel;

  /// Selection state for one-of-many controls such as tabs. `null` for
  /// ordinary buttons. When set, the control is announced as selectable and
  /// part of a mutually exclusive group, on the same node as its label.
  final bool? isSelected;

  /// Scale applied while pressed. Larger surfaces use a subtler value.
  final double pressedScale;

  @override
  State<LeafPressable> createState() => _LeafPressableState();
}

class _LeafPressableState extends State<LeafPressable> {
  bool _isPressed = false;
  bool _showFocusRing = false;

  bool get _isEnabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  void didUpdateWidget(LeafPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A control disabled mid-press must not stay shrunk.
    if (!_isEnabled) _isPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.onPressed;

    return Semantics(
      container: true,
      button: true,
      enabled: _isEnabled,
      selected: widget.isSelected,
      inMutuallyExclusiveGroup: widget.isSelected != null ? true : null,
      label: widget.semanticLabel,
      // An explicit label replaces the child's text rather than adding to it.
      excludeSemantics: widget.semanticLabel != null,
      onTap: onPressed,
      child: FocusableActionDetector(
        enabled: _isEnabled,
        mouseCursor: _isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowFocusHighlight: (value) => setState(() => _showFocusRing = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: onPressed,
          onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
          onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
          onTapCancel: _isEnabled ? () => _setPressed(false) : null,
          child: AnimatedScale(
            scale: _isPressed ? widget.pressedScale : 1,
            duration: LeafMotion.resolve(context, LeafMotion.fast),
            curve: LeafMotion.standard,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                border: _showFocusRing
                    ? Border.all(
                        color: context.leafColors.primary,
                        width: LeafPressable.focusRingWidth,
                      )
                    : null,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
