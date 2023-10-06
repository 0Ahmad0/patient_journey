import 'package:flutter/material.dart';
import 'package:patient_journey/common_widgets/app_button.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/sign_up_screen.dart';

import '../common_widgets/app_text_form_filed.dart';
import '../controller/auth_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late  AuthController authController;

  @override
  void initState() {
    authController=AuthController(context: context);
    super.initState();
  }
  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SafeArea(child: SizedBox.shrink()),
              Expanded(
                child: Image.asset(AppAssets.doctorsIMG,
                  width: size.width /1.5,
                  height: size.width /1.5,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.0)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextFormFiled(
                          iconData: Icons.numbers,
                          controller: idController,
                          hintText: 'Enter your ID number',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextFormFiled(
                          iconData: Icons.lock,
                          suffixIcon: true,
                          obscureText: true,
                          controller: passwordController,
                          hintText: 'Enter Password',
                        ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // AppTextFormFiled(
                        //   iconData: Icons.verified,
                        //   controller: verificationCodeController,
                        //   hintText: 'Enter verification code',
                        // ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        AppButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authController.login(context, filed: idController.value.text, password: passwordController.value.text);
                                // Navigator.pushReplacement(context, MaterialPageRoute(
                                //     builder: (ctx)=>HomeScreen()));
                              }
                            },
                            text: 'Log in'),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const SignupScreen(),
                                  fullscreenDialog: true
                                ),
                              );
                            },
                            child: const Text.rich(TextSpan(children: [
                              TextSpan(
                                text: 'You Don\'t have account yet ? ',
                                style: TextStyle(
                                  color: AppColors.grey,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign up ',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: 'Now',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                  )),
                            ])))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0.0,
            child: SafeArea(
              child: Image.asset(AppAssets.logoIMG,
                width: size.width * 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
