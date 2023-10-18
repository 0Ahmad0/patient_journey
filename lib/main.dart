import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_journey/controller/provider/chat_provider.dart';
import 'package:patient_journey/controller/provider/mail_provider.dart';
import 'package:patient_journey/controller/provider/medical_provider.dart';
import 'package:patient_journey/list_doctors_screen.dart';
import 'package:patient_journey/screens/admin/admin_home_screen.dart';
import 'package:patient_journey/screens/doctor/patient_screen.dart';
import 'package:patient_journey/screens/home_screen.dart';
import 'package:patient_journey/screens/splash_screen.dart';
import 'package:patient_journey/screens/verifey_email.dart';
import 'package:patient_journey/show_add_review_screen.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'controller/provider/auth_provider.dart';
import 'controller/provider/patient_diagnosis_provider.dart';
import 'controller/provider/process_provider.dart';
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
    Provider<MedicalProvider>(create: (_)=>MedicalProvider()),
    Provider<MailProvider>(create: (_)=>MailProvider()),
     Provider<ProcessProvider>(create: (_)=>ProcessProvider()),
     Provider<ChatProvider>(create: (_)=>ChatProvider()),
     Provider<PatientDiagnosisProvider>(create: (_)=>PatientDiagnosisProvider()),
    //
    ],
      child:GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.myTheme,
      title: AppString.appName,
        home: SplashScreen(),
       //home: PatientScreen(),
    ));
  }
}


