import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/data/local/storage.dart';
import '../../../core/data/model/models.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/utils/app_constant.dart';
import '../../auth/controller/provider/auth_provider.dart';
import '../../auth/controller/provider/profile_provider.dart';

class SplashController{

  init(BuildContext context) async {

      AuthProvider authProvider= Provider.of<AuthProvider>(context,listen: false);
      ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
      await AppStorage.init(context);
      ///TODO language
        context.locale =(Locale(Advance.language));


      ///end
      if(Advance.isLogined&&Advance.token!=""){
        final result = await authProvider.fetchUser(uid: Advance.uid);
        if(result['status']){

          if(authProvider.listTypeUserWithActive.contains(result['body']['typeUser'])
              &&(!result['body']['active']||result['body']['band'])
          ){
                goRouter.pushReplacementNamed(AppRoute.selectedLanguage.name);
          }
          else{
            profileProvider.updateUser(user:User.fromJson(result['body']));
            if(authProvider.typeUser==AppConstants.collectionEmployee)
                goRouter.pushReplacementNamed(AppRoute.homeEmployee.name);
            else
              goRouter.pushReplacementNamed(AppRoute.home.name);
          }

        }else{
              goRouter.pushReplacementNamed(AppRoute.selectedLanguage.name);

        }

      }else{
        // goRouter.pushReplacementNamed(AppRoute.selectedLanguage.name);
      }
  }
}