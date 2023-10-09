import 'package:flutter/material.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text('Verify Email'),
          )
        ],
      ),
    );
  }
}
