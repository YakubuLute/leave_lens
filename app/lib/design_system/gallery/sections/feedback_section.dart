import 'dart:async';

import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_section.dart';

/// Gallery: tabs, notices, state views, sheet and toast.
class FeedbackSection extends StatelessWidget {
  /// Creates the section.
  const FeedbackSection({super.key});

  /// Height of each state-view demo.
  static const double stateViewHeight = 320;

  @override
  Widget build(BuildContext context) {
    void tapped() => showLeafToast(context, 'Tapped');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GallerySection(
          title: 'LeafTabs',
          description: 'Segments scroll instead of squeezing at large text.',
          children: [_TabsDemo()],
        ),
        GallerySection(
          title: 'LeafNotice',
          description: 'Use info for low confidence on the result screen.',
          children: [
            LeafNotice(
              tone: LeafNoticeTone.info,
              title: 'Low confidence',
              message: 'Try another photo of a single leaf in daylight.',
              action: LeafNoticeAction('Retake photo', onPressed: tapped),
            ),
            const LeafNotice(
              tone: LeafNoticeTone.warning,
              message: 'Chemical treatments: always follow label directions.',
            ),
            LeafNotice(
              tone: LeafNoticeTone.offline,
              message: "You're offline. Common leaves still work.",
              onDismiss: tapped,
            ),
            LeafNotice(
              tone: LeafNoticeTone.error,
              message: "Couldn't upload the photo.",
              action: LeafNoticeAction('Try again', onPressed: tapped),
            ),
          ],
        ),
        GallerySection(
          title: 'LeafStateView',
          children: [
            const _StateViewBox(
              child: LeafStateView.loading(message: 'Checking your leaf'),
            ),
            _StateViewBox(
              child: LeafStateView.empty(
                title: 'No scans yet',
                message: 'Your scanned leaves will appear here.',
                actionLabel: 'Scan a leaf',
                onAction: tapped,
              ),
            ),
            _StateViewBox(
              child: LeafStateView.error(
                title: "Couldn't check this leaf",
                message: 'Check your connection and try again.',
                onRetry: tapped,
              ),
            ),
          ],
        ),
        GallerySection(
          title: 'Sheet and toast',
          children: [
            Wrap(
              spacing: LeafSpacing.sm,
              runSpacing: LeafSpacing.sm,
              children: [
                LeafButton(
                  label: 'Open sheet',
                  variant: LeafButtonVariant.secondary,
                  onPressed: () => unawaited(_openSheet(context)),
                ),
                LeafButton(
                  label: 'Show toast',
                  variant: LeafButtonVariant.secondary,
                  onPressed: () => showLeafToast(
                    context,
                    'Scan saved',
                    icon: LeafIcons.healthy,
                    actionLabel: 'Undo',
                    onAction: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final choice = await showLeafSheet<String>(
      context: context,
      title: 'Add a photo',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LeafListTile(
            title: 'Take photo',
            leading: const Icon(LeafIcons.camera),
            onTap: () => Navigator.pop(context, 'Take photo'),
          ),
          LeafListTile(
            title: 'Choose from gallery',
            leading: const Icon(LeafIcons.gallery),
            onTap: () => Navigator.pop(context, 'Choose from gallery'),
          ),
        ],
      ),
    );
    if (choice != null && context.mounted) {
      showLeafToast(context, 'Chose: $choice');
    }
  }
}

class _StateViewBox extends StatelessWidget {
  const _StateViewBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LeafCard(
      padding: EdgeInsets.zero,
      child: SizedBox(height: FeedbackSection.stateViewHeight, child: child),
    );
  }
}

enum _Section { immediate, organic, chemical, prevention }

class _TabsDemo extends StatefulWidget {
  const _TabsDemo();

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  _Section _selected = _Section.immediate;

  static const _tabs = [
    LeafTab(value: _Section.immediate, label: 'Immediate'),
    LeafTab(value: _Section.organic, label: 'Organic'),
    LeafTab(value: _Section.chemical, label: 'Chemical'),
    LeafTab(value: _Section.prevention, label: 'Prevention'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LeafTabs<_Section>(
          tabs: _tabs,
          selected: _selected,
          onChanged: (value) => setState(() => _selected = value),
        ),
        const LeafGap.xs(),
        Text(
          'Selected: ${_selected.name}',
          style: context.leafText.bodySmall.copyWith(
            color: context.leafColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
