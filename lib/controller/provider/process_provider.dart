

import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';
import 'package:patient_journey/models/models.dart' as models;


import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';

import '../utils/firebase.dart';

class ProcessProvider with ChangeNotifier{
  Map<String,dynamic> cacheNameUser=Map<String,dynamic>();
  Map<String,dynamic> cacheUser=Map<String,dynamic>();

  fetchLocalNameUser({required String idUser}) {
    //  print(cacheUser[idUser]);
    if(cacheNameUser.containsKey(idUser)) return cacheNameUser[idUser];
    return "......";
  }

  fetchNameUser(context,{required String idUser}) async{
  //  print(cacheUser[idUser]);
    if(cacheNameUser.containsKey(idUser)) return cacheNameUser[idUser];
    var result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionPatient);
    if(result['status']&&result['body']==null){
      result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionDoctor);
      if(result['status']&&result['body']==null){
        result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionAdmin);
      }
    }
    cacheNameUser[idUser]=(result['status'])?models.User.fromJson(result['body']).name:"user";
    notifyListeners();
    return cacheNameUser[idUser];
  }
 models.User? fetchLocalUser({required String idUser}) {
    if(cacheUser.containsKey(idUser)) return cacheUser[idUser];
    return null;
  }
  fetchUser(context,{required String idUser}) async{
    if(cacheUser.containsKey(idUser)&&cacheUser[idUser]!=null) return cacheUser[idUser];
    var result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionPatient);
    if(result['status']&&result['body']==null){
      result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionDoctor);
      if(result['status']&&result['body']==null){
        result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionAdmin);
      }
    }
    cacheUser[idUser]=(result['status'])?models.User.fromJson(result['body']):null;
    notifyListeners();
    return cacheUser[idUser];
  }
  fetchUsers(context,{required List<String> idUsers}) async{
    for(String idUser in idUsers)
       fetchUser(context, idUser: idUser);
   // notifyListeners();
  }
  widgetNameUser(context,{required String idUser}){

    return FutureBuilder(
      future: fetchNameUser(
          context,
          idUser: idUser),
      builder: (
          context,
          snapshot,
          ) {
        print(snapshot
            .error);
        if (snapshot
            .connectionState ==
            ConnectionState
                .waiting) {
          return Const
                  .SHOWLOADINGINDECATOR();
          //Const.CIRCLE(context);
        } else if (snapshot
            .connectionState ==
            ConnectionState
                .done) {
          if (snapshot
              .hasError) {
            return const Text(
                'Error');
          } else if (snapshot
              .hasData) {
            // Map<String,dynamic> data=snapshot.data as Map<String,dynamic>;
            //homeProvider.sessions=Sessions.fromJson(data['body']);
            return Text(
        '${cacheNameUser[idUser]}'
        );
          } else {
            return const Text(
                'Empty data');
          }
        } else {
          return Text(
              'State: ${snapshot.connectionState}');
        }
      },
    );
  }




}