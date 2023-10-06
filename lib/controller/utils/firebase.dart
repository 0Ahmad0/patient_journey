import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:path/path.dart';
import 'package:patient_journey/models/models.dart' as model;

import '../../constants/app_constant.dart';

//import '../../translations/locale_keys.g.dart';

class FirebaseFun{
  static var rest;
  static  FirebaseAuth auth=FirebaseAuth.instance;
  static Duration timeOut =Duration(seconds: 30);
   static signup( {required String email,required String password})  async {
    final result=await auth.createUserWithEmailAndPassword(
      email: email,///"temp@gmail.com",
      password: password,///"123456"
    ).then((onValueSignup))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static checkPhoneOrEmailFound( {required String email,required String phone})  async {
    var result=await FirebaseFirestore.instance.collection(AppConstants.collectionUser)
    .where('email',isEqualTo: email).
    get().then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    if(result['status']&&result["body"].length<1){
      result=await FirebaseFirestore.instance.collection(AppConstants.collectionUser)
          .where('phoneNumber',isEqualTo: phone).
      get().then((onValueFetchUsers))
          .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
      if(result['status']&&result["body"].length<1){
        return true;
      }
    }
    return false;
  }
   static createUser( {required model.User user}) async {
     final result= await FirebaseFirestore.instance.collection(user.typeUser).add(
       user.toJson()
     ).then((value){
       user.id=value.id;
         return {
           'status':true,
           'message':'Account successfully created',
           'body': {
             'id':value.id
           }
      };
     }).catchError(onError);
     if(result['status'] == true){
       final result2=await updateUser(user: user);
       if(result2['status'] == true){
         return{
         'status':true,
         'message':'Account successfully created',
         'body': user.toJson()
         };
       }else{
         return{
           'status':false,
           'message':"Account Unsuccessfully created"
         };
       }
     }else{
       return result;
     }

   }
   static updateUser( {required model.User user}) async {
      final result =await FirebaseFirestore.instance.collection(user.typeUser).doc(user.id).update(
         user.toJson()
     ).then(onValueUpdateUser)
         .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
      if(result['status']){
        print(true);
       // print(user.id);
        print("id : ${user.id}");
        return {
          'status':true,
          'message':'User successfully update',
          'body': user.toJson()
        };
      }
      return result;
   }
   static updateUserEmail( {required model.User user}) async {
      final result =await auth.currentUser?.updateEmail(
         user.email
     ).then(onValueUpdateUser)
         .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
      if(result!['status']){
        return {
          'status':true,
          'message':'User Email successfully update',
          'body': user.toJson()
        };
      }
      return result;
   }
  static login( {required String email,required String password})  async {
    final result=await auth.signInWithEmailAndPassword(
      email: email,///"temp@gmail.com",
      password: password,///"123456"
    ).then((onValuelogin))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static loginWithPhoneNumber( {required String phoneNumber,required String password, required String typeUser })  async {
    final result=await FirebaseFirestore.instance.collection(typeUser).
    where('phoneNumber',isEqualTo: phoneNumber)
        .where('password',isEqualTo:password ).get().
    then((onValueloginWithphoneNumber))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static logout()  async {
    final result=await FirebaseAuth.instance.signOut()
        .then((onValuelogout))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUser( {required String uid,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('uid',isEqualTo: uid)
        .get()
        .then((onValueFetchUser))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUserId( {required String id,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('id',isEqualTo: id)
        .get()
        .then((onValueFetchUserId))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //  print("${id} ${result}");
    return result;
  }

  static fetchUsers()  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionUser)
        .get()
        .then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUsersByTypeUser(String typeUser)  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .get()
        .then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUsersByTypeUserAndFieldOrderBy({required String typeUser,required String field,required var value})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
    .where(field,isEqualTo: value)
    .orderBy('dateTime')
        .get()
        .then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static sendPasswordResetEmail( {required String email})  async {
    final result=await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,///"temp@gmail.com",
    ).then((onValueSendPasswordResetEmail))
        .catchError(onError);
    return result;
  }
  static updatePassword( {required String newPassword})  async {
    final result=await auth.currentUser?.updatePassword(newPassword)
        .then((onValueUpdatePassword))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);

    return result;
  }


  // ///Wallet
  // static addWallet( {required model.Wallet wallet}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionWallet).add(
  //       wallet.toJson()
  //   ).then(onValueAddWallet).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static updateWallet( {required model.Wallet wallet}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionWallet).doc(
  //       wallet.id
  //   ).update(wallet.toJson()).then(onValueUpdateWallet).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static deleteWallet( {required model.Wallet wallet}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionWallet).doc(
  //       wallet.id
  //   ).delete().then(onValueDeleteWallet).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static fetchWalletByIdUser({required String idUser})  async {
  //   final result=await FirebaseFirestore.instance.collection(AppConstants.collectionWallet)
  //   .where('idUser',isEqualTo: idUser)
  //       .get()
  //       .then((onValueFetchWallets))
  //       .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  //
  // ///Report
  // static addReport( {required model.Report report}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionReport).add(
  //       report.toJson()
  //   ).then(onValueAddReport).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static updateReport( {required model.Report report}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionReport).doc(
  //       report.id
  //   ).update(report.toJson()).then(onValueUpdateReport).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static deleteReport( {required model.Report report}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionReport).doc(
  //       report.id
  //   ).delete().then(onValueDeleteReport).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static fetchReports()  async {
  //   final result=await FirebaseFirestore.instance.collection(AppConstants.collectionReport)
  //   .orderBy('dateTime',descending: true)
  //       .get()
  //       .then((onValueFetchReports))
  //       .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }

  // ///DateLawyer
  // static addDateTrainer( {required model.DateTrainer dateTrainer}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionDateTrainer).add(
  //       dateTrainer.toJson()
  //   ).then(onValueAddDateTrainer).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static updateDateTrainer( {required model.DateTrainer dateTrainer}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionDateTrainer).doc(
  //       dateTrainer.id
  //   ).update(dateTrainer.toJson()).then(onValueUpdateDateTrainer).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }
  // static deleteDateTrainer( {required model.DateTrainer dateTrainer}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionDateTrainer).doc(
  //       dateTrainer.id
  //   ).delete().then(onValueDeleteDateTrainer).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //   return result;
  // }




  static Future<Map<String,dynamic>>  onError(error) async {
    print(false);
    print(error);
    return {
      'status':false,
      'message':error,
      //'body':""
    };
  }
  static Future<Map<String,dynamic>>  onTimeOut() async {
    print(false);
    return {
      'status':false,
      'message':'time out',
      //'body':""
    };
  }

  static Future<Map<String,dynamic>>  errorUser(String messageError) async {
    print(false);
    print(messageError);
    return {
      'status':false,
      'message':messageError,
      //'body':""
    };
  }

  static Future<Map<String,dynamic>> onValueSignup(value) async{
    print(true);
    print("uid : ${value.user?.uid}");
    return {
      'status':true,
      'message':'Account successfully created',
      'body':value.user
    };
  }
  static Future<Map<String,dynamic>> onValueUpdateUser(value) async{
    return {
      'status':true,
      'message':'Account successfully update',
    //  'body': user.toJson()
    };
  }
  static Future<Map<String,dynamic>>onValueSendPasswordResetEmail(value) async{
    return {
      'status':true,
      'message':'Email successfully send code ',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValuelogin(value) async{
    //print(true);
   // print(value.user.uid);

    return {
      'status':true,
      'message':'Account successfully logged',
      'body':value.user
    };
  }
  static Future<Map<String,dynamic>> onValueloginWithphoneNumber(value) async{


    if(value.docs.length<1){
      return {
        'status':false,
        'message':'Account not successfully logged',
        'body':{
          'users':value.docs}
      };
    }
    return {
      'status':true,
      'message':'Account successfully logged',
      'body': value.docs[0]}
    ;}
  static Future<Map<String,dynamic>> onValuelogout(value) async{
     print(true);
     print("logout");
    return {
      'status':true,
      'message':'Account successfully logout',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUser(value) async{
   // print(true);
    print('uid ${await (value.docs.length>0)?value.docs[0]['uid']:null}');
    print("user : ${(value.docs.length>0)?model.User.fromJson(value.docs[0]).toJson():null}");
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?model.User.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUserId(value) async{
    //print(true);
    //print(await (value.docs.length>0)?value.docs[0]['uid']:null);
   // print("user : ${(value.docs.length>0)?model.User.fromJson(value.docs[0]).toJson():null}");
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?model.User.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUsers(value) async{
   // print(true);
    print("Users count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Users successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>>onValueUpdatePassword(value) async{
    return {
      'status':true,
      'message':'Password successfully update',
      'body':{}
    };
  }


  static Future<Map<String,dynamic>>onValueAddWallet(value) async{
    return {
      'status':true,
      'message':'Wallet successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateWallet(value) async{
    return {
      'status':true,
      'message':'Wallet successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteWallet(value) async{
    return {
      'status':true,
      'message':'Wallet successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchWallets(value) async{
    // print(true);
    print("Wallets count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Wallets successfully fetch',
      'body':value.docs
    };
  }

  static Future<Map<String,dynamic>>onValueAddReport(value) async{
    return {
      'status':true,
      'message':'Report successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateReport(value) async{
    return {
      'status':true,
      'message':'Report successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteReport(value) async{
    return {
      'status':true,
      'message':'Report successfully delete',
      'body':{}
    };
  }


  static Future<Map<String,dynamic>>onValueAddDateTrainer(value) async{
    return {
      'status':true,
      'message':'DateTrainer successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateDateTrainer(value) async{
    return {
      'status':true,
      'message':'DateTrainer successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteDateTrainer(value) async{
    return {
      'status':true,
      'message':'DateTrainer successfully delete',
      'body':{}
    };
  }

  static Future<Map<String,dynamic>>onValueAddCourse(value) async{
    return {
      'status':true,
      'message':'Course successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateCourse(value) async{
    return {
      'status':true,
      'message':'Course successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteCourse(value) async{
    return {
      'status':true,
      'message':'Course successfully delete',
      'body':{}
    };
  }

  static Future<Map<String,dynamic>> onValueFetchReports(value) async{
    // print(true);
    print("Reports count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Reports successfully fetch',
      'body':value.docs
    };
  }


  static Future<Map<String,dynamic>>onValueAddBookCourse(value) async{
    return {
      'status':true,
      'message':'BookCourse successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateBookCourse(value) async{
    return {
      'status':true,
      'message':'BookCourse successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteBookCourse(value) async{
    return {
      'status':true,
      'message':'BookCourse successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchBookCourses(value) async{
    // print(true);
    print("BookCourses count : ${value.docs.length}");

    return {
      'status':true,
      'message':'BookCourses successfully fetch',
      'body':value.docs
    };
  }

  static Future<Map<String,dynamic>>onValueAddNotification(value) async{
    return {
      'status':true,
      'message':'Notification successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateNotification(value) async{
    return {
      'status':true,
      'message':'Notification successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteNotification(value) async{
    return {
      'status':true,
      'message':'Notification successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchNotifications(value) async{
    // print(true);
    print("Notifications count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Notifications successfully fetch',
      'body':value.docs
    };
  }


  static Future<Map<String,dynamic>>onValueAddChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully add',
      'body':{'id':value.id}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchChats(value) async{
    // print(true);
    //print("Chats count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Chats successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>>onValueAddMessage(value) async{
    return {
      'status':true,
      'message':'Message successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteMessage(value) async{
    return {
      'status':true,
      'message':'Message successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchLastMessage(value) async{
    // print(true);
    //print("Chats count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Last message successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>> onValueFetchCourses(value) async{
    // print(true);
    print("Courses count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Courses successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>> onValueFetchCourse(value) async{
    // print(true);
    // print("Course  : ${value}");
    // print("Course  : ${value.data()}");

    return {
      'status':true,
      'message':'Course successfully fetch',
      'body':value.data()
    };
  }



  static String findTextToast(String text){
     // if(text.contains("Password should be at least 6 characters")){
     //   return tr(LocaleKeys.toast_short_password);
     // }else if(text.contains("The email address is already in use by another account")){
     //   return tr(LocaleKeys.toast_email_already_use);
     // }
     // else if(text.contains("Account Unsuccessfully created")){
     //   return tr(LocaleKeys.toast_Unsuccessfully_created);
     // }
     // else if(text.contains("Account successfully created")){
     //    return tr(LocaleKeys.toast_successfully_created);
     // }
     // else if(text.contains("The password is invalid or the user does not have a password")){
     //    return tr(LocaleKeys.toast_password_invalid);
     // }
     // else if(text.contains("There is no user record corresponding to this identifier")){
     //    return tr(LocaleKeys.toast_email_invalid);
     // }
     // else if(text.contains("The email address is badly formatted")){
     //   return tr(LocaleKeys.toast_email_invalid);
     // }
     // else if(text.contains("Account successfully logged")){
     //     return tr(LocaleKeys.toast_successfully_logged);
     // }
     // else if(text.contains("A network error")){
     //    return tr(LocaleKeys.toast_network_error);
     // }
     // else if(text.contains("An internal error has occurred")){
     //   return tr(LocaleKeys.toast_network_error);
     // }else if(text.contains("field does not exist within the DocumentSnapshotPlatform")){
     //   return tr(LocaleKeys.toast_Bad_data_fetch);
     // }else if(text.contains("Given String is empty or null")){
     //   return tr(LocaleKeys.toast_given_empty);
     // }
     // else if(text.contains("time out")){
     //   return tr(LocaleKeys.toast_time_out);
     // }
     // else if(text.contains("Account successfully logged")){
     //   return tr(LocaleKeys.toast);
     // }
     // else if(text.contains("Account not Active")){
     //   return tr(LocaleKeys.toast_account_not_active);
     // }

     return text;
  }
  static int compareDateWithDateNowToDay({required DateTime dateTime}){
     int year=dateTime.year-DateTime.now().year;
     int month=dateTime.year-DateTime.now().month;
     int day=dateTime.year-DateTime.now().day;
     return (year*365+
            month*30+
            day);
  }

  static Future uploadImage({required XFile image, required String folder}) async {
    try {
      String path = basename(image.path);
      print(image.path);
      File file =File(image.path);

//FirebaseStorage storage = FirebaseStorage.instance.ref().child(path);
      Reference storage = FirebaseStorage.instance.ref().child("${folder}/${path}");
      UploadTask storageUploadTask = storage.putFile(file);
      TaskSnapshot taskSnapshot = await storageUploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (ex) {
      //Const.TOAST( context,textToast:FirebaseFun.findTextToast("Please, upload the image"));
    }
  }
}