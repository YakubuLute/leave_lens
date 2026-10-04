import 'package:flutter/widgets.dart';

import 'package:leaf_lens/app/app.dart';
import 'package:leaf_lens/design_system/design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerLeafFontLicenses();
  runApp(const LeafLensApp());
}
