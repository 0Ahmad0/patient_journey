import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


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
  static checkPhoneOrEmailFound( {required String email,required String phone,required String cardId})  async {
    var result=await FirebaseFirestore.instance.collection(AppConstants.collectionPatient)
    .where('email',isEqualTo: email).
    get().then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    if(result['status']&&result["body"].length<1){
      result=await FirebaseFirestore.instance.collection(AppConstants.collectionPatient)
          .where('phoneNumber',isEqualTo: phone).
      get().then((onValueFetchUsers))
          .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
      if(result['status']&&result["body"].length<1){
        result=await FirebaseFirestore.instance.collection(AppConstants.collectionPatient)
            .where('cardId',isEqualTo: cardId).
        get().then((onValueFetchUsers))
            .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
        if(result['status']&&result["body"].length<1){
          return true;
        }
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
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut,);
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
  static loginWithFiled( {required String filed,required String value,required String password, required String typeUser })  async {
    final result=await FirebaseFirestore.instance.collection(typeUser).
    where(filed,isEqualTo: value)
       .
    where('password',isEqualTo:password ).
    get().
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
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionPatient)
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


  ///Medical
  static addMedical( {required model.Medical medical}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMedical).add(
        medical.toJson()
    ).then(onValueAddMedical).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static updateMedical( {required model.Medical medical}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMedical).doc(
        medical.id
    ).update(medical.toJson()).then(onValueUpdateMedical).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteMedical( {required model.Medical medical}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMedical).doc(
        medical.id
    ).delete().then(onValueDeleteMedical).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchAllMedical()  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionMedical)
        .get()
        .then((onValueFetchMedicals))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  ///PatientDiagnosis
  static addPatientDiagnosis( {required model.PatientDiagnosis patientDiagnosis}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis).add(
        patientDiagnosis.toJson()
    ).then(onValueAddPatientDiagnosis).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static updatePatientDiagnosis( {required model.PatientDiagnosis patientDiagnosis}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis).doc(
        patientDiagnosis.id
    ).update(patientDiagnosis.toJson()).then(onValueUpdatePatientDiagnosis).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deletePatientDiagnosis( {required model.PatientDiagnosis patientDiagnosis}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis).doc(
        patientDiagnosis.id
    ).delete().then(onValueDeletePatientDiagnosis).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static fetchAllPatientDiagnosis()  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis)
        .get()
        .then((onValueFetchPatientDiagnosis))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }


  ///Mail
  static addMail( {required model.Mail mail}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMail).add(
        mail.toJson()
    ).then(onValueAddMail).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static updateMail( {required model.Mail mail}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMail).doc(
        mail.id
    ).update(mail.toJson()).then(onValueUpdateMail).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteMail( {required model.Mail mail}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionMail).doc(
        mail.id
    ).delete().then(onValueDeleteMail).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchAllMail()  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionMail)
        .get()
        .then((onValueFetchMails))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  ///Chat
  static addChat( {required model.Chat chat}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionChat).add(
        chat.toJson()
    ).then(onValueAddChat).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteChat( {required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
       .delete().then(onValueDeleteChat)
        .catchError(onError);
    return result;
  }
  static updateChat( {required model.Chat chat}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionChat).doc(
        chat.id
    ).update(chat.toJson()).then(onValueUpdateChat).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchChatsByIdUser({required List listIdUser})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionChat)
        .where('listIdUser',arrayContains: listIdUser)
        .get()
        .then((onValueFetchChats))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchChatsByListIdUser({required List listIdUser})  async {
    final database = await FirebaseFirestore.instance.collection(AppConstants.collectionChat);
    Query<Map<String, dynamic>> ref = database;

    listIdUser.forEach( (val) => {
      ref = database.where('listIdUser' ,arrayContains: val)
    });
    final result=
    ref
        .get()
        .then((onValueFetchChats))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static addMessage( {required model.Message message,required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage).add(
        message.toJson()
    ).then(onValueAddMessage)
        .catchError(onError);
    return result;
  }
  static deleteMessage( {required model.Message message,required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage).doc(
        message.id
    ).delete().then(onValueDeleteMessage)
        .catchError(onError);
    return result;
  }
  static fetchLastMessage({required String idChat})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionChat)
        .doc(idChat).collection(AppConstants.collectionMessage).orderBy('sendingTime',descending: true).get()
        .then((onValueFetchLastMessage))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }




  ///Notification
  static addNotification( {required model.Notification notification}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionNotification).add(
        notification.toJson()
    ).then(onValueAddNotification).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static updateNotification( {required model.Notification notification}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionNotification).doc(
        notification.id
    ).update(notification.toJson()).then(onValueUpdateNotification).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteNotification( {required model.Notification notification}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionNotification).doc(
        notification.id
    ).delete().then(onValueDeleteNotification).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchNotificationByFieldOrderBy({required String field,required String value})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionNotification)
        .where(field,isEqualTo: value)
        .get()
        .then((onValueFetchNotifications))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchNotificationByField({required String field,required String value,String orderBy='dateTime'})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionNotification)
        .where(field,isEqualTo: value)
        .orderBy(orderBy)
        .get()
        .then((onValueFetchNotifications))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

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
  //
  // ///DateLawyer
  // static addDateTrainer( {required model.DateTrainer dateTrainer}) async {
  //   final result= await FirebaseFirestore.instance.collection(AppConstants.collectionDoctor).add(
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
  //
  //


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


  static Future<Map<String,dynamic>>onValueAddMedical(value) async{
    return {
      'status':true,
      'message':'Medical successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateMedical(value) async{
    return {
      'status':true,
      'message':'Medical successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteMedical(value) async{
    return {
      'status':true,
      'message':'Medical successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchMedicals(value) async{
    // print(true);
    print("Wallets count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Medicals successfully fetch',
      'body':value.docs
    };
  }


  static Future<Map<String,dynamic>>onValueAddPatientDiagnosis(value) async{
    return {
      'status':true,
      'message':'PatientDiagnosis successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdatePatientDiagnosis(value) async{
    return {
      'status':true,
      'message':'PatientDiagnosis successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeletePatientDiagnosis(value) async{
    return {
      'status':true,
      'message':'PatientDiagnosis successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchPatientDiagnosis(value) async{
    // print(true);
    print("PatientDiagnoses count : ${value.docs.length}");

    return {
      'status':true,
      'message':'PatientDiagnoses successfully fetch',
      'body':value.docs
    };
  }


  static Future<Map<String,dynamic>>onValueAddMail(value) async{
    return {
      'status':true,
      'message':'Mail successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateMail(value) async{
    return {
      'status':true,
      'message':'Mail successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteMail(value) async{
    return {
      'status':true,
      'message':'Mail successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchMails(value) async{
    // print(true);
    print("Mails count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Mails successfully fetch',
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
  static Future<Map<String,dynamic>>onValueDeleteChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully delete',
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
  static Future uploadFile({required PlatformFile platformFile, required String folder}) async {
    try {

      String path = basename(platformFile.path??'');
      print(platformFile.path);
      File file =File(platformFile.path??'');

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
  static Future uploadFile2({required File file, required String folder}) async {
    try {

      String path = basename(file.path??'');
      print(file.path);

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