import 'package:flutter/material.dart';
import 'package:patient_journey/screens/home_screen.dart';
import 'package:patient_journey/screens/splash_screen.dart';

import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/medical_files_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// ...

Future<void> main() async {

  //
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.myTheme,
      title: AppString.appName,
      home: SplashScreen(),
    );
  }
}


