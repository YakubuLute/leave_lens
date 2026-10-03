import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Asset path of the Inter licence (SIL Open Font License 1.1).
const String interLicenseAsset = 'assets/fonts/OFL.txt';

/// Registers the bundled font licences so they appear on Flutter's licence
/// page. The OFL requires the licence to ship with the font.
///
/// Call once from `main()`, before `runApp`.
void registerLeafFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString(interLicenseAsset);
    yield LicenseEntryWithLineBreaks(const ['Inter'], text);
  });
}
