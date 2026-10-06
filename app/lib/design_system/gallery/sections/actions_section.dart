import 'dart:async';

import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_section.dart';

/// Gallery: buttons, icon buttons and the scan button.
class ActionsSection extends StatelessWidget {
  /// Creates the section.
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    void tapped() => showLeafToast(context, 'Tapped');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GallerySection(
          title: 'LeafButton',
          description: 'One primary button per screen.',
          children: [
            for (final variant in LeafButtonVariant.values)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: LeafButton(
                  label: variant.name,
                  icon: LeafIcons.camera,
                  variant: variant,
                  onPressed: tapped,
                ),
              ),
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: LeafButton(label: 'Disabled', onPressed: null),
            ),
            const _LoadingButtonDemo(),
            LeafButton(
              label: 'Large, expanded',
              size: LeafButtonSize.lg,
              isExpanded: true,
              onPressed: tapped,
            ),
          ],
        ),
        GallerySection(
          title: 'LeafIconButton',
          description: 'Icon-only actions. Always named for screen readers.',
          children: [
            Wrap(
              spacing: LeafSpacing.sm,
              children: [
                for (final variant in LeafIconButtonVariant.values)
                  LeafIconButton(
                    icon: LeafIcons.more,
                    semanticLabel: '${variant.name} icon button',
                    variant: variant,
                    onPressed: tapped,
                  ),
                const LeafIconButton(
                  icon: LeafIcons.delete,
                  semanticLabel: 'Disabled icon button',
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
        const GallerySection(
          title: 'ScanButton',
          description: 'Tap to see the busy state for two seconds.',
          children: [
            Wrap(
              spacing: LeafSpacing.xl,
              runSpacing: LeafSpacing.xl,
              children: [_ScanButtonDemo(), ScanButton(onPressed: null)],
            ),
          ],
        ),
      ],
    );
  }
}

/// A button that shows its loading state for two seconds when tapped.
class _LoadingButtonDemo extends StatefulWidget {
  const _LoadingButtonDemo();

  @override
  State<_LoadingButtonDemo> createState() => _LoadingButtonDemoState();
}

class _LoadingButtonDemoState extends State<_LoadingButtonDemo> {
  bool _isLoading = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() => _isLoading = true);
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: LeafButton(
        label: 'Tap to load',
        variant: LeafButtonVariant.secondary,
        isLoading: _isLoading,
        onPressed: _start,
      ),
    );
  }
}

/// A scan button that stays busy for two seconds when tapped.
class _ScanButtonDemo extends StatefulWidget {
  const _ScanButtonDemo();

  @override
  State<_ScanButtonDemo> createState() => _ScanButtonDemoState();
}

class _ScanButtonDemoState extends State<_ScanButtonDemo> {
  bool _isBusy = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scan() {
    setState(() => _isBusy = true);
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isBusy = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScanButton(onPressed: _scan, isBusy: _isBusy);
  }
}
