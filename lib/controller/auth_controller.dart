import 'package:flutter/cupertino.dart';

import 'package:get/get_core/src/get_main.dart';


import 'package:provider/provider.dart';


import '../constants/app_constant.dart';
import '../models/models.dart';
import 'provider/auth_provider.dart';

class AuthController{
  late AuthProvider authProvider;
  var context;
  AuthController({required this.context}){
    authProvider= Provider.of<AuthProvider>(context,listen: false);
  }

  visitor() async {
    await authProvider.visitor(context);
        ()=>goRouter.pushReplacementNamed(AppRoute.home.name);
    //Get.off(()=>NavbarView());
  }
  login(BuildContext context,{required String phone,String? email,required String password,}) async {
    Const.loading(context);
    authProvider.user.email=email??'';
    authProvider.user.phoneNumber=phone;
    authProvider.user.password=password;
    final result=await authProvider.login(context);

    //goRouter.pop();
    if(result['status']){
      if(authProvider.user.typeUser==AppConstants.collectionEmployee)
         goRouter.pushReplacementNamed(AppRoute.homeEmployee.name);
      else
        goRouter.pushReplacementNamed(AppRoute.home.name);
     // Get.off(() => NavbarView(), transition: Transition.circularReveal);
    }

  }

  signUp(BuildContext context,{required String firstName,required String lastName,required String gender,required DateTime dateBirth,required String email,required String password,required String phoneNumber,required String photoUrl,required String typeUser}) async {
    authProvider.user=User(id: '', uid: '',
        name: '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber
        , password: password,
        typeUser: typeUser,
        photoUrl: photoUrl,
        gender: gender,

        dateBirth: dateBirth);
    final result=await signUpByUser(context);
    return result;
  }
  signUpByUser(BuildContext context) async {
    Const.loading(context);
    final result=await authProvider.signup(context);
  // goRouter.pop();
    if(result['status']){
    //  authProvider.user=User.init();
      goRouter.pushReplacementNamed(AppRoute.home.name);
      // Get.off(() => LoginView(),
      //     transition: Transition.circularReveal);
    }
    return result;
  }

  sendPasswordResetEmail(BuildContext context,{required String email}) async {
    Const.loading(context);
    final result =await authProvider.sendPasswordResetEmail(context, resetEmail: email);
    Navigator.of(context).pop();
    if(result['status']){
     goRouter.pop();
    }
  }
}