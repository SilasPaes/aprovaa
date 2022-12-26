import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth_check.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("pt", "BR")],
      debugShowCheckedModeBanner: false,
      title: 'MKT manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AuthCheck(),
    );
  }
}
