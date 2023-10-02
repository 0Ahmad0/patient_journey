import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/screens/login_screen.dart';

import '../constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logoIMG),
             SizedBox(height: MediaQuery.sizeOf(context).width * 0.1,),
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  AppString.appName,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.sizeOf(context).width * 0.1
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
