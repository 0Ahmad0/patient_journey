import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/constants/app_assets.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppAssets.emailVerifyIMG),
          Card(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(MediaQuery.sizeOf(context).width - 20.0,60)
              ),
              onPressed: () {},
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('Verify Email'),
            ),
          )
        ],
      ),
    );
  }
}
