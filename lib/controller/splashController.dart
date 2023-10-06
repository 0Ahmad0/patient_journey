
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/controller/provider/auth_provider.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import '../local/storage.dart';
import '../models/models.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class SplashController{

  init(BuildContext context) async {

      AuthProvider authProvider= Provider.of<AuthProvider>(context,listen: false);
      ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
      await AppStorage.init(context);
      ///TODO language
       // context.locale =(Locale(Advance.language));


      ///end
      if(Advance.isLogined&&Advance.token!=""){
        final result = await authProvider.fetchUser(uid: Advance.uid);
        if(result['status']){

          if(authProvider.listTypeUserWithActive.contains(result['body']['typeUser'])
              &&(!result['body']['active']||result['body']['band'])
          ){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => const LoginScreen(),
              ),
            );
          }
          else{
            profileProvider.updateUser(user:User.fromJson(result['body']));
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (ctx)=>HomeScreen()));
          }

        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => const LoginScreen(),
            ),
          );
        }

      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => const LoginScreen(),
          ),
        );
      }
  }
}