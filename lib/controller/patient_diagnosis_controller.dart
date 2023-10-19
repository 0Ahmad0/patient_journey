
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:patient_journey/controller/provider/medical_provider.dart';
import 'package:patient_journey/controller/provider/notification_provider.dart';
import 'package:patient_journey/controller/provider/patient_diagnosis_provider.dart';
import 'package:patient_journey/models/models.dart' ;
import 'package:patient_journey/models/models.dart' as models;
import 'package:patient_journey/screens/doctor/add_plan_and_preformed_surgeries_screen.dart';
import '../common_widgets/constans.dart';

import '../constants/app_constant.dart';
import '/controller/provider/profile_provider.dart';
import '/controller/utils/firebase.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart';


class PatientDiagnosisController{
  late PatientDiagnosisProvider patientDiagnosisProvider;
  var context;
  PatientDiagnosisController({required this.context}){
    patientDiagnosisProvider= Provider.of<PatientDiagnosisProvider>(context,listen: false);
  }

  addPatientDiagnosis(context,{
    required String idPatient
  }) async {
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
    Const.loading(context);
    var result;
       result=await patientDiagnosisProvider.addPatientDiagnosis(context, patientDiagnosis: PatientDiagnosis(idDoctor: profileProvider.user.id, idPatient: idPatient),
     );
       if(result['status']){
         Get.back();
       }
       else Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }

  // updatePatientDiagnosis(context,{ required PatientDiagnosis patientDiagnosis,PlatformFile? platformFile}) async {
  //   Const.loading(context);
  //   var result=await patientDiagnosisProvider.updatePatientDiagnosis(context,patientDiagnosis: patientDiagnosis,platformFile:platformFile);
  //   Get.back();
  //   if(result['status']){
  //     Get.back();
  //     // Get.back();
  //   }
  //   Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
  //   return result;
  // }
  addTreatmentPlan(context,{
    required PatientDiagnosis patientDiagnosis
    ,required String namePlan
    ,required String clinicPlan
    ,required String treatmentPlan
    ,required String diseasePlan
    ,required List<File> testFiles
    ,required List<File> xRayFiles
    ,required List<DateTime> appointments
  }) async {
    Const.loading(context);
    patientDiagnosis.treatmentPlan=TreatmentPlan(namePlan: namePlan, testFiles: [], xRayFiles: [],
        diseasePlan: diseasePlan,clinicPlan: clinicPlan,
        appointments: appointments, treatmentPlan: treatmentPlan, dateTime: DateTime.now());
    var result;
    result=await patientDiagnosisProvider.updateTreatmentPlan(context, patientDiagnosis: patientDiagnosis,
        testFiles: testFiles,xRayFiles:xRayFiles);
    if(result['status']){
       //Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }
  updateTreatmentPlan(context,{
    required PatientDiagnosis patientDiagnosis
    ,required List<File> testFiles
    ,required List<File> xRayFiles
    ,required List<DateTime> appointments
  }) async {
    Const.loading(context);
    !appointments.isEmpty?patientDiagnosis.treatmentPlan?.appointments=appointments:'';
    var result;
    result=await patientDiagnosisProvider.updateTreatmentPlan(context, patientDiagnosis: patientDiagnosis,
        testFiles: testFiles,xRayFiles:xRayFiles);
    if(result['status']){
      // Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }

  updatePreformedSurgeries(context,{
    required PatientDiagnosis patientDiagnosis
  }) async {
    Const.loading(context);
    var result;
    result=await patientDiagnosisProvider.updatePreformedSurgeries(context, patientDiagnosis: patientDiagnosis);
    if(result['status']){
      // Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }
  addPreformedSurgeries(context,{
    required PatientDiagnosis patientDiagnosis
    ,required String namePerformed
    ,required String notesPerformed
    ,required String locationPerformed
    ,required String clinicPerformed
    ,required DateTime datePerformed
  }) async {
    Const.loading(context);
    patientDiagnosis.preformedSurgeries=PreformedSurgeries(locationPerformed:locationPerformed
        ,namePerformed: namePerformed, datePerformed: datePerformed,
        clinicPerformed: clinicPerformed, notesPerformed: notesPerformed,
        dateTime: DateTime.now());
    var result;
    result=await patientDiagnosisProvider.updatePreformedSurgeries(context, patientDiagnosis: patientDiagnosis);
    if(result['status']){
      //Get.back();
    }
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    Get.back();
    return result;
  }
  getNewPatient({required List<User> users}){
    List<User> additionPatient=[];
    List<String> userIds=_getAdditionPatientIds();
    for(User user in users)
      if(!userIds.contains(user.id))
        additionPatient.add(user);
    return additionPatient;
  }
  _getAdditionPatientIds(){
    List<String> userIds=[];
    for(PatientDiagnosis patientDiagnosis in patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis )
      userIds.add(patientDiagnosis.idPatient);
    return userIds;
  }
  deletePatientDiagnosis(context,{ required PatientDiagnosis patientDiagnosis}) async {
    Const.loading(context);
    await patientDiagnosisProvider.deletePatientDiagnosis(context,patientDiagnosis: patientDiagnosis);
    Get.back();
  }

}