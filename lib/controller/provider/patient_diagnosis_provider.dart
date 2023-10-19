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

class PatientDiagnosisProvider with ChangeNotifier{
  PatientDiagnosis patientDiagnosis=PatientDiagnosis.init();
  PatientDiagnoses patientDiagnoses=PatientDiagnoses.init();
  PatientDiagnoses patientTreatmentPlan=PatientDiagnoses.init();
  PatientDiagnoses patientPreformedSurgeries=PatientDiagnoses.init();

 fetchAllPatientDiagnosis(BuildContext context) async {
   var result;
     result= await FirebaseFun.fetchAllMedical();
     if(result['status']){
         patientDiagnoses=PatientDiagnoses.fromJson(result['body']);
     }
   return result;

 }

  addPatientDiagnosis(BuildContext context,{required PatientDiagnosis patientDiagnosis}) async {
   var result;
   result=await FirebaseFun.addPatientDiagnosis(patientDiagnosis: patientDiagnosis);
   return result;
 }
  updateTreatmentPlan(BuildContext context,{
    required PatientDiagnosis patientDiagnosis
    ,required List<File> testFiles
    ,required List<File> xRayFiles
  }) async {
   var result;
   for(File file in testFiles){
     var url=await FirebaseFun.uploadFile2(file: file, folder: AppConstants.collectionPatient);
     if(url!=null)
        patientDiagnosis.treatmentPlan?.testFiles.add(url);
     else
       return FirebaseFun.errorUser("Field in upload test files");
   }
   for(File file in xRayFiles){
     var url=await FirebaseFun.uploadFile2(file: file, folder: AppConstants.collectionPatient);
     if(url!=null)
       patientDiagnosis.treatmentPlan?.xRayFiles.add(url);
     else
       return FirebaseFun.errorUser("Field in upload xRay files");
   }
     result=await FirebaseFun.updatePatientDiagnosis(patientDiagnosis: patientDiagnosis);
   return result;

 }
 updatePreformedSurgeries(BuildContext context,{
    required PatientDiagnosis patientDiagnosis
  }) async {
   var result;
     result=await FirebaseFun.updatePatientDiagnosis(patientDiagnosis: patientDiagnosis);
   return result;

 }
  deletePatientDiagnosis(context,{ required PatientDiagnosis patientDiagnosis}) async {
    var result;
    result =await FirebaseFun.deletePatientDiagnosis(patientDiagnosis: patientDiagnosis);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
}
