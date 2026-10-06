import 'dart:async';

import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/gallery_frame.dart';
import 'package:leaf_lens/design_system/gallery/sample_result_screen.dart';
import 'package:leaf_lens/design_system/gallery/sections/actions_section.dart';
import 'package:leaf_lens/design_system/gallery/sections/diagnosis_section.dart';
import 'package:leaf_lens/design_system/gallery/sections/feedback_section.dart';
import 'package:leaf_lens/design_system/gallery/sections/foundations_section.dart';
import 'package:leaf_lens/design_system/gallery/sections/surfaces_section.dart';

/// Debug-only showcase of every design-system component in each variant
/// (app/CLAUDE.md §1 rule 8). Update it whenever a component changes.
///
/// Switches at the top preview light/dark mode and 100–200% text, and apply
/// to pages opened from here too.
class DesignSystemGallery extends StatefulWidget {
  /// Creates the gallery.
  const DesignSystemGallery({super.key});

  @override
  State<DesignSystemGallery> createState() => _DesignSystemGalleryState();
}

class _DesignSystemGalleryState extends State<DesignSystemGallery> {
  GallerySettings _settings = const GallerySettings();

  void _openSampleResult() {
    final settings = _settings;
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => GalleryFrame(
            settings: settings,
            child: const SampleResultScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalleryFrame(
      settings: _settings,
      child: LeafScaffold(
        title: 'Design system',
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: LeafSpacing.md),
          children: [
            _SettingsControls(
              settings: _settings,
              onChanged: (value) => setState(() => _settings = value),
            ),
            const LeafGap.md(),
            LeafButton(
              label: 'Open sample result screen',
              icon: LeafIcons.leaf,
              isExpanded: true,
              onPressed: _openSampleResult,
            ),
            const LeafGap.xxl(),
            const FoundationsSection(),
            const ActionsSection(),
            const DiagnosisSection(),
            const SurfacesSection(),
            const FeedbackSection(),
          ],
        ),
      ),
    );
  }
}

class _SettingsControls extends StatelessWidget {
  const _SettingsControls({required this.settings, required this.onChanged});

  final GallerySettings settings;
  final ValueChanged<GallerySettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LeafTabs<Brightness>(
          tabs: const [
            LeafTab(value: Brightness.light, label: 'Light'),
            LeafTab(value: Brightness.dark, label: 'Dark'),
          ],
          selected: settings.brightness,
          onChanged: (value) => onChanged(settings.copyWith(brightness: value)),
        ),
        const LeafGap.xs(),
        LeafTabs<double>(
          tabs: [
            for (final scale in GallerySettings.textScales)
              LeafTab(value: scale, label: 'Text ${(scale * 100).round()}%'),
          ],
          selected: settings.textScale,
          onChanged: (value) => onChanged(settings.copyWith(textScale: value)),
        ),
      ],
    );
  }
}
