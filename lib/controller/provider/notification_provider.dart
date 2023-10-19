
import 'package:flutter/cupertino.dart';


import '../../common_widgets/constans.dart';
import '../../models/models.dart' as model;

import '../../models/models.dart';
import '../utils/firebase.dart';


class NotificationProvider extends ChangeNotifier{

  model.Notification notification= model.Notification.init();
  Notifications notifications=Notifications(listNotification: []);

  addNotification(context,{ required model.Notification notification}) async {
    var result;
    result =await FirebaseFun.addNotification(notification: notification);
    //print(result);
    //   Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
       return result;
  }
  updateNotification(context,{ required model.Notification notification}) async {
    var result;
    result =await FirebaseFun.updateNotification(notification: notification);
    //print(result);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  deleteNotification(context,{ required model.Notification notification}) async {
    var result;
    result =await FirebaseFun.deleteNotification(notification: notification);
    //print(result);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  // fetchMeals () async {
  //   var result= await FirebaseFun.fetchMeals();
  //   if(result['status']){
  //     listMeals=Meals.fromJson(result['body']);
  //   }
  //   return result;
  // }


}