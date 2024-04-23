import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> generateDelegateFile() async {
  final Directory l10nDir = Directory(p.absolute("l10n"));

  final files = await l10nDir.list().toList();

  final arbFiles =
      files.where((element) => element.path.split(".").last == "arb");

  final List<String> generatedFiles = [];
  final List<String> generatedClasses = [];
  final List<String> generatedLocales = [];

  for (var arbFile in arbFiles) {
    final content = await File(arbFile.path).readAsString();
    final jsonFormattedContent = jsonDecode(content);
    final String locale = jsonFormattedContent["@@locale"];
    generatedLocales.add(locale);
    final List<MapEntry<String, dynamic>> entries = [];

    for (var key in jsonFormattedContent.keys) {
      if (key[0] != "@") {
        entries.add(MapEntry(key, jsonFormattedContent[key]));
      }
    }

    final buffer = StringBuffer(
      'import "package:flutter_gen/gen_l10n/app_localizations.dart";',
    );

    buffer.writeln('');
    final className = "Memory${locale.toUpperCase()}Localization";
    generatedClasses.add(className);
    buffer.writeln('class $className extends AppLocalizations {');
    buffer.writeln('$className(super.locale, {required this.data});');
    buffer.writeln('');
    buffer.writeln('final Map<String, dynamic> data;');
    buffer.writeln('');

    for (var entry in entries) {
      buffer.writeln("@override");
      buffer.writeln("String get ${entry.key} => data['${entry.key}'];");
    }

    buffer.writeln('}');
    final path = p.absolute("memory_${locale}_localization.dart");
    generatedFiles.add("./memory_${locale}_localization.dart");
    final localizationFile = await File(path).create();
    await localizationFile.writeAsString(buffer.toString());
  }

  final delegateFile = await File(p.absolute("memory_delegate.dart")).create();

  final buffer = StringBuffer(
    'import "package:flutter_gen/gen_l10n/app_localizations.dart";',
  );
  buffer.writeln("import 'package:flutter/widgets.dart';");
  for (var locale in generatedLocales) {
    buffer.writeln(
      "import 'package:flutter_gen/gen_l10n/app_localizations_$locale.dart';",
    );
  }
  buffer.writeln(
    "import 'package:hive/hive.dart';",
  );
  buffer.writeln(
    "import './api.dart';",
  );
  buffer.writeln('');
  for (var path in generatedFiles) {
    buffer.writeln("import '$path';");
  }
  buffer.writeln('');
  buffer.writeln(
      'AppLocalizations lookupAppLocalizations(Locale locale, Map<String,dynamic> data) {');
  buffer.writeln('switch (locale.languageCode) {');
  buffer.writeln('');
  for (var i = 0; i < generatedLocales.length; i++) {
    final locale = generatedLocales[i];
    buffer.writeln("case '$locale':");
    buffer.writeln(
        "return ${generatedClasses[i]}(locale.languageCode, data:data);");
  }
  buffer.writeln('}');
  buffer.writeln('');
  buffer.write("""
    throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "\$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.'
    );
  """);
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln(
    'Future<AppLocalizations> lookupOfflineAppLocalizations(Locale locale) async {',
  );
  buffer.writeln('switch (locale.languageCode) {');
  buffer.writeln("");
  for (var i = 0; i < generatedLocales.length; i++) {
    final locale = generatedLocales[i];
    buffer.writeln("case '$locale':");
    buffer.writeln(
        "return AppLocalizations${locale.replaceFirst(locale[0], locale[0].toUpperCase())}(locale.languageCode);");
  }
  buffer.writeln('}');
  buffer.writeln('');
  buffer.write("""
    throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "\$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.'
    );
  """);
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln(
    'class CustomDelegate extends LocalizationsDelegate<AppLocalizations> {',
  );
  buffer.writeln('static const CustomDelegate delegate = CustomDelegate._();');
  buffer.writeln('');
  buffer.writeln('const CustomDelegate._();');
  buffer.writeln('');
  buffer.writeln('@override');
  buffer.writeln('bool isSupported(Locale locale) {');
  buffer.writeln('return true;');
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln('@override');
  buffer.writeln('Future<AppLocalizations> load(Locale locale) async {');
  buffer.writeln('try {');
  buffer.writeln('final data = await retrieveTranslations();');
  buffer.writeln('final settingsBox = Hive.box<String>("settings");');
  buffer.writeln(
      'final box = Hive.box<Map<String, dynamic>>(locale.languageCode);');
  buffer.writeln('final version = settingsBox.get("version");');
  buffer.writeln('');
  buffer.writeln(
      'if (version == null || (int.tryParse(version) ?? 0) < data["version"]) {');
  buffer
      .writeln('await settingsBox.put("version", data["version"].toString());');
  buffer.writeln(
      'await box.put(locale.languageCode, data[locale.languageCode]);');
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln(
      'return  lookupAppLocalizations(locale, data[locale.languageCode]);');
  buffer.writeln('} catch (e) {');
  buffer.writeln('return await lookupOfflineAppLocalizations(locale);');
  buffer.writeln('}');
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln('@override');
  buffer.writeln(
      'bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {');
  buffer.writeln('return true;');
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln('}');

  await delegateFile.writeAsString(buffer.toString());
}

void main() async {
  await generateDelegateFile();
}
