import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'firebase_options.dart';
import 'myapp.dart';

void main() async {
  //initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //PreferenciaTema.setTema();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        //ChangeNotifierProvider(create: (context) => AgenciaHomePage()),
        //ChangeNotifierProvider(create: (context) => AppSettings()),
      ],
      child: const MyApp(),
    ),
  );
}
