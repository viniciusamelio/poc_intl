import "package:flutter_gen/gen_l10n/app_localizations.dart";
class MemoryPTLocalization extends AppLocalizations {
MemoryPTLocalization(super.locale, {required this.data});

final Map<String, dynamic> data;

@override
String helloWorld (String name, int age) => data['helloWorld']
    .replaceAll('{name}', name.toString())
    .replaceAll('{age}', age.toString())
;
@override
String get appTitle => data['appTitle'];
}
