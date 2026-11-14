import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Adds the bundled artwork and font to the in-app licence page.
///
/// Packages register themselves; assets copied into `assets/` do not.
void registerAssetLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['Twemoji artwork'],
      'Card, routine icon and sticker pictures are unmodified Twemoji '
      'graphics.\n\n'
      'Copyright 2019 Twitter, Inc and other contributors.\n'
      'Graphics licensed under CC-BY 4.0: '
      'https://creativecommons.org/licenses/by/4.0/',
    );
    yield LicenseEntryWithLineBreaks([
      'Nunito font',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
}
