import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient_journey/constants/app_constant.dart';
import 'package:patient_journey/models/models.dart';
import '../../common_widgets/constans.dart';
import '/controller/provider/profile_provider.dart';

import 'package:provider/provider.dart';


import '../utils/firebase.dart';

class MailProvider with ChangeNotifier{
  Mail mail=Mail.init();
  Mails mails=Mails.init();


 fetchAllMails(BuildContext context) async {
   var result;
     result= await FirebaseFun.fetchAllMail();
     if(result['status']){
         mails=Mails.fromJson(result['body']);
     }
   return result;

 }

  addMail(BuildContext context,{required Mail mail,required List<File> files}) async {
   var result;
   for(File file in files){

     var url=await FirebaseFun.uploadFile2(file: file, folder: AppConstants.collectionMail);
     if(url!=null)
       mail.files.add(url);
     if(mail.files.length!=files.length)
       return FirebaseFun.errorUser("Fiald in upload files");
   }
   result=await FirebaseFun.addMail(mail: mail);
   return result;
 }
updateMail(BuildContext context,{required Mail mail,required List<File> files}) async {
   var result;
   for(File file in files){
     var url=await FirebaseFun.uploadFile2(file: file, folder: AppConstants.collectionMail);
     if(url!=null)
       mail.files.add(url);
     if(mail.files.length!=files.length)
       return FirebaseFun.errorUser("Fiald in upload files");
   }
     result=await FirebaseFun.updateMail(mail: mail);
   return result;

 }
  deleteMail(context,{ required Mail mail}) async {
    var result;
    result =await FirebaseFun.deleteMail(mail: mail);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
}
