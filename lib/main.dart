import 'package:flutter/widgets.dart';

import 'package:leaf_lense/app/app.dart';
import 'package:leaf_lense/design_system/design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerLeafFontLicenses();
  runApp(const LeafLensApp());
}
