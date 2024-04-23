import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poc_intl/app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>("settings");
  await Hive.openBox<Map<String, dynamic>>("pt");
  runApp(const MyApp());
}
