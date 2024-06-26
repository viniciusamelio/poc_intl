import "package:flutter_gen/gen_l10n/app_localizations.dart";import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:hive/hive.dart';
import './api.dart';

import './memory_pt_localization.dart';

AppLocalizations lookupAppLocalizations(Locale locale, Map<String,dynamic> data) {
switch (locale.languageCode) {

case 'pt':
return MemoryPTLocalization(locale.languageCode, data:data);
}

    throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.'
    );
  }

Future<AppLocalizations> lookupOfflineAppLocalizations(Locale locale) async {
switch (locale.languageCode) {

case 'pt':
return AppLocalizationsPt(locale.languageCode);
}

    throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.'
    );
  }

class CustomDelegate extends LocalizationsDelegate<AppLocalizations> {
static const CustomDelegate delegate = CustomDelegate._();

const CustomDelegate._();

@override
bool isSupported(Locale locale) {
return true;
}

@override
Future<AppLocalizations> load(Locale locale) async {
try {
final data = await retrieveTranslations();
final settingsBox = Hive.box<String>("settings");
final box = Hive.box<Map<String, dynamic>>(locale.languageCode);
final version = settingsBox.get("version");

if (version == null || (int.tryParse(version) ?? 0) < data["version"]) {
await settingsBox.put("version", data["version"].toString());
await box.put(locale.languageCode, data[locale.languageCode]);
}

return  lookupAppLocalizations(locale, data[locale.languageCode]);
} catch (e) {
return await lookupOfflineAppLocalizations(locale);
}
}

@override
bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
return true;
}

}
