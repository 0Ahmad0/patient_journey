import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:patient_journey/screens/home_screen.dart';

import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../constants/app_constant.dart';
import '../models/models.dart';
import 'provider/auth_provider.dart';

class AuthController {
  late AuthProvider authProvider;
  var context;

  AuthController({required this.context}) {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  visitor() async {
    await authProvider.visitor(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
      ),
    );
    //Get.off(()=>NavbarView());
  }

  login(
    BuildContext context, {
    String? filed,
    String? phone,
    String? email,
    required String password,
  }) async {
    Const.loading(context);
    authProvider.user.email = email ?? '';
    authProvider.user.phoneNumber = phone ?? '';
    authProvider.user.cardId = filed ?? '';
    authProvider.user.password = password;
    final result = await authProvider.login(context);

    Navigator.of(context).pop();
    if (result['status']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
      );
      // Get.off(() => NavbarView(), transition: Transition.circularReveal);
    }
  }

  signUp(BuildContext context,
      {required String firstName,
      required String lastName,
      required String gender,
      required DateTime dateBirth,
      required String email,
      required String password,
      required String phoneNumber,
      required String photoUrl,
      required String typeUser}) async {
    authProvider.user = User(
        id: '',
        uid: '',
        name: '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        typeUser: typeUser,
        photoUrl: photoUrl,
        gender: gender,
        dateBirth: dateBirth);

    final result = await signUpByUser(context);
    return result;
  }

  signUpByUser(BuildContext context) async {
    Const.loading(context);
    final result = await authProvider.signup(context);
    Navigator.of(context).pop();
    if (result['status']) {
      //  authProvider.user=User.init();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
      );
    }
    return result;
  }

  sendPasswordResetEmail(BuildContext context, {required String email}) async {
    Const.loading(context);
    final result =
        await authProvider.sendPasswordResetEmail(context, resetEmail: email);
    Navigator.of(context).pop();
    if (result['status']) {
      Navigator.of(context).pop();
    }
  }
}
