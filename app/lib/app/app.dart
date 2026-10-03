import 'package:flutter/material.dart';

import 'package:leaf_lens/app/placeholder_home.dart';
import 'package:leaf_lens/design_system/design_system.dart';

/// Root widget: wires the Leaf theme (light + dark, following the system).
class LeafLensApp extends StatelessWidget {
  /// Creates the app.
  const LeafLensApp({super.key});

  /// User-facing product name.
  static const String title = 'Leaf Lens';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: LeafTheme.light(),
      darkTheme: LeafTheme.dark(),
      debugShowCheckedModeBanner: false,
      // Replaced by the router in Phase 1 and the gallery in step 8.
      home: const PlaceholderHome(),
    );
  }
}
