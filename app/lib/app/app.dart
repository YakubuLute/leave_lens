import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:leaf_lens/app/placeholder_home.dart';
import 'package:leaf_lens/design_system/design_system.dart';
import 'package:leaf_lens/design_system/gallery/design_system_gallery.dart';

/// Root widget: wires the Leaf theme (light + dark, following the system).
class LeafLensApp extends StatelessWidget {
  /// Creates the app.
  const LeafLensApp({this.showGallery = true, super.key});

  /// In debug builds, open the design-system gallery instead of the
  /// placeholder home. Ignored in release builds, where the gallery is
  /// compiled out.
  final bool showGallery;

  /// User-facing product name.
  static const String title = 'Leaf Lens';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: LeafTheme.light(),
      darkTheme: LeafTheme.dark(),
      debugShowCheckedModeBanner: false,
      // `kDebugMode` is a compile-time constant, so release builds drop the
      // gallery entirely. Phase 1 replaces this with the router and moves the
      // gallery to a debug-only `/_gallery` route.
      home: kDebugMode && showGallery
          ? const DesignSystemGallery()
          : const PlaceholderHome(),
    );
  }
}
