import 'package:flutter/material.dart';

import 'package:leaf_lense/design_system/tokens/leaf_motion.dart';

/// Page transition: fade in while rising 8 px.
///
/// Used on every platform except iOS, which keeps the Cupertino transition so
/// the edge swipe-back gesture still works (see plan §4).
class LeafPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Creates the Leaf page transition.
  const LeafPageTransitionsBuilder();

  /// Distance the incoming page rises, in logical pixels.
  static const double riseDistance = 8;

  @override
  Duration get transitionDuration => LeafMotion.slow;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: LeafMotion.standard,
      reverseCurve: LeafMotion.standard.flipped,
    );
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, riseDistance * (1 - curved.value)),
          child: child,
        ),
        child: child,
      ),
    );
  }
}
