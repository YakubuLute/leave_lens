import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Asset path of the Inter licence (SIL Open Font License 1.1).
const String interLicenseAsset = 'assets/fonts/OFL.txt';

/// Asset path of the Phosphor Icons licence (MIT).
const String phosphorLicenseAsset = 'assets/fonts/Phosphor-LICENSE.txt';

/// Registers the bundled font licences so they appear on Flutter's licence
/// page. Both licences require their text to ship with the font.
///
/// Call once from `main()`, before `runApp`.
void registerLeafFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'Inter',
    ], await rootBundle.loadString(interLicenseAsset));
    yield LicenseEntryWithLineBreaks(const [
      'Phosphor Icons',
    ], await rootBundle.loadString(phosphorLicenseAsset));
  });
}
