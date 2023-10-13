
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:patient_journey/controller/provider/mail_provider.dart';
import 'package:patient_journey/models/models.dart';
import '../common_widgets/constans.dart';

import '/controller/provider/profile_provider.dart';
import '/controller/utils/firebase.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart';


class MailController{
  late MailProvider mailProvider;
  var context;
  MailController({required this.context}){
    mailProvider= Provider.of<MailProvider>(context,listen: false);
  }

  addMail(context,String message,List<File> files) async {
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
    Const.loading(context);
    var result;
       result=await mailProvider.addMail(context, mail: Mail(
           idUser: profileProvider.user.id,
           nameUser: '${profileProvider.user.firstName}'+' '+'${profileProvider.user.lastName}',
           typeUser: profileProvider.user.typeUser,
           files: [], message:message, dateTime: DateTime.now() ),
       files: files);
       if(result['status']){
         Get.back();
       }
       Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }

  updateMail(context,{ required Mail mail,required List<File> files}) async {
    Const.loading(context);
    var result=await mailProvider.updateMail(context,mail: mail,files:files);
    Get.back();
    if(result['status']){
      // Get.back();
      // Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  deleteMail(context,{ required Mail mail}) async {
    Const.loading(context);
    await mailProvider.deleteMail(context,mail: mail);
    Get.back();
  }


}