import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient_journey/models/models.dart';
import '../../common_widgets/constans.dart';
import '/controller/provider/profile_provider.dart';

import 'package:provider/provider.dart';


import '../utils/firebase.dart';

class MedicalProvider with ChangeNotifier{
  Medical medical=Medical.init();
  Medicals medicals=Medicals.init();
 MedicalReview medicalReview=MedicalReview.init();
 String idAdmin='KNcPHYfrSUVeF74yeQo2';
 String idWalletAdmin='1kSOo4IHEch4AZY0kfvW';

 fetchAllMedical(BuildContext context) async {
   var result;
     result= await FirebaseFun.fetchAllMedical();
     if(result['status']){
         medicals=Medicals.fromJson(result['body']);
     }
   return result;

 }

  addMedical(BuildContext context,{required Medical medical}) async {
   var result;
     result=await FirebaseFun.addMedical(medical: medical);
   return result;

 }
 addMedicalReview(BuildContext context,{required Medical medical,required MedicalReview medicalReview}) async {
   medical.listMedicalReview.add(medicalReview);
   var result;
     result=await FirebaseFun.updateMedical(medical: medical);
     if(result['status']){
       Const.TOAST(context,textToast:'Done add review');
     }else{
       medical.listMedicalReview.remove(medicalReview);
       Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
     }
     notifyListeners();
   return result;
 }
 updateMedical(BuildContext context,{required Medical medical}) async {
   var result;
     result=await FirebaseFun.updateMedical(medical: medical);
   result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
   return result;

 }
  deleteMedical(context,{ required Medical medical}) async {
    var result;
    result =await FirebaseFun.deleteMedical(medical: medical);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
}
