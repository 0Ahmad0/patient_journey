
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';




import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';
import '../../models/models.dart';
import 'firebase.dart';

class CreateEnvironmentProvider with ChangeNotifier{

  List<User> listAdmin=[
    User(id: "",
        uid: "",
        cardId:'0000',
        firstName: "Admin",
        lastName:"",
        email: "admin@gmail.com",
        phoneNumber: "+999999999999",
        password: "12345678",
        typeUser: AppConstants.collectionAdmin,
        photoUrl: "", gender: 'Male', dateBirth: DateTime.now(),active: true, name: 'Admin'),
  ];

  createAdmin(context,{int indexListAdmin=0}) async {
    if(listAdmin.length<1){
      return FirebaseFun.errorUser("a user is empty");
    }
    User user=listAdmin[indexListAdmin];
    var result =await FirebaseFun.signup(email: user.email, password: user.password);
    if(result['status']){
        user.uid= result['body']?.uid;
        result = await FirebaseFun.createUser(user: user);
    }
   // print(result);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  createAdmins(context) async {
    Const.loading(context);
    var result;
    if(listAdmin.length<1){
      return FirebaseFun.errorUser("a list admin is empty");
    }
    for(int i=0;i<listAdmin.length;i++){
      result =await createAdmin(context,indexListAdmin: i);
    }
    Get.back();
    return result;
  }

  onError(error){
    print(false);
    print(error);
    return {
      'status':false,
      'message':error,
      //'body':""
    };
  }
}
