import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_journey/screens/home_screen.dart';
import 'package:patient_journey/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'controller/provider/auth_provider.dart';
import 'controller/provider/profile_provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(providers: [
    // Provider<HomeProvider>(create: (_)=>HomeProvider()),
    Provider<AuthProvider>(create: (_) => AuthProvider()),
    Provider<ProfileProvider>(create: (_)=>ProfileProvider()),
    // Provider<ProcessProvider>(create: (_)=>ProcessProvider()),
    //
    ],
      child:GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.myTheme,
      title: AppString.appName,
      home: SplashScreen(),
    ));
  }
}


