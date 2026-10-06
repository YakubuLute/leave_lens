import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_app_bar.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// The base layout for every Leaf Lens screen: page background, safe areas,
/// screen gutters, an optional [LeafAppBar] and an optional pinned [bottom]
/// area for the main action.
///
/// The app bar appears when there's a [title], [leading] widget or
/// [actions], or when the route can pop (so the back button is reachable).
class LeafScaffold extends StatelessWidget {
  /// Creates a screen scaffold.
  const LeafScaffold({
    required this.body,
    this.title,
    this.leading,
    this.actions = const [],
    this.bottom,
    this.isPadded = true,
    super.key,
  });

  /// Screen content.
  final Widget body;

  /// App bar title.
  final String? title;

  /// Replaces the automatic back button.
  final Widget? leading;

  /// App bar actions.
  final List<Widget> actions;

  /// Pinned area below the body, e.g. a full-width [LeafButton].
  final Widget? bottom;

  /// Applies the horizontal screen gutter to [body]. Turn off for
  /// edge-to-edge content such as a full-bleed photo.
  final bool isPadded;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final hasAppBar =
        title != null || leading != null || actions.isNotEmpty || canPop;
    final bottom = this.bottom;

    return Scaffold(
      appBar: hasAppBar
          ? LeafAppBar(title: title, leading: leading, actions: actions)
          : null,
      body: SafeArea(
        top: !hasAppBar,
        bottom: bottom == null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPadded ? LeafSpacing.gutter : 0,
          ),
          child: body,
        ),
      ),
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  LeafSpacing.gutter,
                  LeafSpacing.sm,
                  LeafSpacing.gutter,
                  LeafSpacing.md,
                ),
                child: bottom,
              ),
            ),
    );
  }
}
