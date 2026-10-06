import 'package:flutter/material.dart';

import 'package:leaf_lens/design_system/design_system.dart';

/// A static result screen built only from the design system (plan §7).
///
/// Its data mirrors `contracts/fixtures/valid/diseased.json`, so the mock
/// matches the real `Diagnosis` shape. Phase 1 builds the real screen.
class SampleResultScreen extends StatefulWidget {
  /// Creates the sample screen.
  const SampleResultScreen({super.key});

  @override
  State<SampleResultScreen> createState() => _SampleResultScreenState();
}

enum _Treatment { immediate, organic, chemical, prevention }

class _SampleResultScreenState extends State<SampleResultScreen> {
  _Treatment _selected = _Treatment.immediate;

  static const _tabs = [
    LeafTab(value: _Treatment.immediate, label: 'Immediate'),
    LeafTab(value: _Treatment.organic, label: 'Organic'),
    LeafTab(value: _Treatment.chemical, label: 'Chemical'),
    LeafTab(value: _Treatment.prevention, label: 'Prevention'),
  ];

  static const _symptoms = [
    'Dark, water-soaked lesions on leaves',
    'White mould on the leaf underside in humid weather',
  ];

  static const _advice = {
    _Treatment.immediate: [
      'Remove and destroy infected leaves; do not compost them',
    ],
    _Treatment.organic: [
      'Apply a copper-based fungicide, following label directions',
    ],
    _Treatment.chemical: [
      'Use a fungicide containing chlorothalonil or mancozeb, following '
          'label directions',
    ],
    _Treatment.prevention: [
      'Water at the base of the plant, not the leaves',
      'Space plants for airflow',
      'Rotate crops each season',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final text = context.leafText;
    final secondary = context.leafColors.textSecondary;

    return LeafScaffold(
      title: 'Result',
      bottom: LeafButton(
        label: 'Scan another leaf',
        icon: LeafIcons.camera,
        size: LeafButtonSize.lg,
        isExpanded: true,
        onPressed: () => Navigator.maybePop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: LeafSpacing.md),
        children: [
          const LeafImageFrame(
            image: null,
            aspectRatio: 4 / 3,
            semanticLabel: 'Photo of the scanned leaf',
          ),
          const LeafGap.lg(),
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: StatusBadge(status: LeafStatus.diseased),
          ),
          const LeafGap.xs(),
          Text('Late blight', style: text.display),
          Text(
            'Tomato · Phytophthora infestans',
            style: text.body.copyWith(color: secondary),
          ),
          const LeafGap.lg(),
          const LeafCard(
            child: ConfidenceMeter(value: 0.93, status: LeafStatus.diseased),
          ),
          const LeafGap.xl(),
          Semantics(header: true, child: Text('Symptoms', style: text.title)),
          const LeafGap.xs(),
          for (final symptom in _symptoms) _Bullet(symptom),
          const LeafGap.xl(),
          Semantics(header: true, child: Text('Treatment', style: text.title)),
          const LeafGap.sm(),
          LeafTabs<_Treatment>(
            tabs: _tabs,
            selected: _selected,
            onChanged: (value) => setState(() => _selected = value),
          ),
          const LeafGap.sm(),
          for (final step in _advice[_selected] ?? const <String>[])
            _Bullet(step),
          const LeafGap.xl(),
          const LeafNotice(
            tone: LeafNoticeTone.info,
            message:
                'Guidance only — confirm with a local agricultural extension '
                'officer before applying any chemical treatment.',
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = context.leafText.body;
    return Padding(
      padding: const EdgeInsets.only(bottom: LeafSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Text('•', style: style)),
          const LeafGap.xs(),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}
