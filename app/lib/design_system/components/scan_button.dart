import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:leaf_lens/design_system/components/leaf_pressable.dart';
import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/theme/leaf_context.dart';
import 'package:leaf_lens/design_system/tokens/leaf_colors.dart';
import 'package:leaf_lens/design_system/tokens/leaf_radii.dart';
import 'package:leaf_lens/design_system/tokens/leaf_shadows.dart';

/// The app's signature control: a large round button that starts a scan.
///
/// While [isBusy] it shows a spinner and a pulsing ring, ignores taps and is
/// announced as scanning. The pulse is static when the user reduces motion.
/// Pressing it gives a light haptic tap (plan §5).
class ScanButton extends StatefulWidget {
  /// Creates the scan button.
  const ScanButton({
    required this.onPressed,
    this.isBusy = false,
    this.semanticLabel = 'Scan a leaf',
    this.busyLabel = 'Scanning',
    super.key,
  });

  /// Diameter of the button.
  static const double diameter = 88;

  /// Size of the camera icon and the busy spinner.
  static const double iconSize = 36;

  /// How far the pulse ring grows beyond the button, as a scale factor.
  static const double pulseScale = 1.3;

  /// Opacity of the pulse ring at the start of each cycle.
  static const double pulseOpacity = 0.35;

  /// One pulse cycle.
  static const Duration pulsePeriod = Duration(milliseconds: 1400);

  /// Starts a scan. `null` disables the button.
  final VoidCallback? onPressed;

  /// A scan is in progress.
  final bool isBusy;

  /// Accessible name when idle.
  final String semanticLabel;

  /// Accessible name while [isBusy].
  final String busyLabel;

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: ScanButton.pulsePeriod,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(ScanButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.isBusy && !reduceMotion) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _handlePressed() {
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.leafColors;
    final isBusy = widget.isBusy;
    final isDisabled = widget.onPressed == null && !isBusy;

    return LeafPressable(
      onPressed: isBusy || widget.onPressed == null ? null : _handlePressed,
      borderRadius: LeafRadii.full,
      semanticLabel: isBusy ? widget.busyLabel : widget.semanticLabel,
      child: Opacity(
        opacity: isDisabled ? LeafPressable.disabledOpacity : 1,
        child: SizedBox.square(
          dimension: ScanButton.diameter,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (isBusy) _PulseRing(animation: _pulse, color: colors.primary),
              _Disc(colors: colors, isBusy: isBusy),
            ],
          ),
        ),
      ),
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({required this.colors, required this.isBusy});

  final LeafColors colors;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        boxShadow: LeafShadows.floating(colors),
      ),
      child: SizedBox.square(
        dimension: ScanButton.diameter,
        child: Center(
          child: isBusy
              ? SizedBox.square(
                  dimension: ScanButton.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: colors.onPrimary,
                  ),
                )
              : Icon(
                  LeafIcons.camera,
                  size: ScanButton.iconSize,
                  color: colors.onPrimary,
                ),
        ),
      ),
    );
  }
}

/// A ring that grows and fades out once per [animation] cycle. When motion is
/// reduced the animation stays at 0, leaving a faint static halo.
class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.animation, required this.color});

  final Animation<double> animation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Transform.scale(
          scale: 1 + (ScanButton.pulseScale - 1) * t,
          child: Opacity(
            opacity: ScanButton.pulseOpacity * (1 - t),
            child: child,
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const SizedBox.square(dimension: ScanButton.diameter),
      ),
    );
  }
}
