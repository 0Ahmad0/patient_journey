
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:patient_journey/controller/provider/medical_provider.dart';
import 'package:patient_journey/models/models.dart';
import '../common_widgets/constans.dart';

import '/controller/provider/profile_provider.dart';
import '/controller/utils/firebase.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart';


class MedicalController{
  late MedicalProvider medicalProvider;
  var context;
  MedicalController({required this.context}){
    medicalProvider= Provider.of<MedicalProvider>(context,listen: false);
  }
  // fetchMedicalsBookCourses(BuildContext context) async {
  //   ProfileProvider profileProvider=Provider.of<ProfileProvider>(context,listen: false);
  //   var result;
  //   if(AppConstants.collectionTrainer.contains(profileProvider.user.typeUser)){
  //     result= await FirebaseFun.fetchBookCourseByFieldOrderBy(field: 'idTrainer', value: profileProvider.user.id);
  //   }else{
  //     result= await FirebaseFun.fetchBookCourseByFieldOrderBy(field: 'idUser', value: profileProvider.user.id);
  //   }
  //
  //   if(result['status']){
  //     bookCourseProvider.bookCourses=BookCourses.fromJson(result['body']);
  //     bookCourseProvider.bookCourses.listBookCourse=await processCourse(bookCourseProvider.bookCourses.listBookCourse);
  //   }else{
  //     Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
  //   }
  //   return result;
  // }

  addMedical(context,String name,String type,PlatformFile? platformFile) async {
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
    Const.loading(context);
    var result;
       result=await medicalProvider.addMedical(context, medical: Medical(
           idUser: profileProvider.user.id,
           name: name,
           type: type,
           listMedicalReview: []),
       platformFile: platformFile);
       if(result['status']){
         Get.back();
       }
       Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }
  addMedicalReview(BuildContext context,{required Medical? medical,required String review})  async {
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
    //Const.loading(context);
    if(medical==null) return;
    var result;
       result=await medicalProvider.addMedicalReview(context, medical: medical,medicalReview:
         MedicalReview(idUser: profileProvider.user.id,nameUser: '${profileProvider.user.firstName}'+' '+'${profileProvider.user.lastName}',typeUser:profileProvider.user.typeUser , text: review, dateTime: DateTime.now()));
       if(result['status']){
        // Get.back();
       }
    //Get.back();
    return result;
  }
  updateMedical(context,{ required Medical medical,PlatformFile? platformFile}) async {
    Const.loading(context);
    var result=await medicalProvider.updateMedical(context,medical: medical,platformFile:platformFile);
    Get.back();
    if(result['status']){
      Get.back();
      // Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  deleteMedical(context,{ required Medical medical}) async {
    Const.loading(context);
    await medicalProvider.deleteMedical(context,medical: medical);
    Get.back();
  }
  deleteMedicalReview(context,{required Medical medical ,required MedicalReview medicalReview}) async {
    //Const.loading(context);
    await medicalProvider.deleteMedicalReview(context,medical: medical,medicalReview: medicalReview);
    //Get.back();
  }
  checkReviewForMe(BuildContext context,MedicalReview medicalReview){
    return context.read<ProfileProvider>().user.id==medicalReview.idUser;
  }

}