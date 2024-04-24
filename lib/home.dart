import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.helloWorld("Vinicius", 23),
        ),
      ),
    );
  }
}
