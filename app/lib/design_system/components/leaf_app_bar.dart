import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/components/leaf_icon_button.dart';
import 'package:leaf_lens/design_system/icons/leaf_icons.dart';
import 'package:leaf_lens/design_system/tokens/leaf_spacing.dart';

/// The Leaf Lens app bar: flat, page-coloured, left-aligned title.
///
/// Shows a Leaf back button automatically when the route can pop, replacing
/// Material's default arrow. Styling comes from `LeafTheme`'s app bar theme.
class LeafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an app bar.
  const LeafAppBar({
    this.title,
    this.leading,
    this.actions = const [],
    super.key,
  });

  /// Screen title.
  final String? title;

  /// Replaces the automatic back button.
  final Widget? leading;

  /// Trailing actions, usually [LeafIconButton]s.
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final leading =
        this.leading ??
        ((ModalRoute.of(context)?.canPop ?? false)
            ? LeafIconButton(
                icon: LeafIcons.back,
                semanticLabel: 'Back',
                onPressed: () => Navigator.maybePop(context),
              )
            : null);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: title == null ? null : Text(title),
      titleSpacing: leading == null ? LeafSpacing.gutter : LeafSpacing.xxs,
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: LeafSpacing.xs),
    );
  }
}
