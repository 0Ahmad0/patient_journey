import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/constans.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constant.dart';
import '../controller/patient_diagnosis_controller.dart';
import '../controller/provider/profile_provider.dart';
import '../models/models.dart';

class MyTestAndXRaysScreen extends StatefulWidget {
  const MyTestAndXRaysScreen({super.key, required this.title});

  final String title;

  @override
  State<MyTestAndXRaysScreen> createState() => _MyTestAndXRaysScreenState();
}

class _MyTestAndXRaysScreenState extends State<MyTestAndXRaysScreen> {
  var getPatientDiagnosis;

  late PatientDiagnosisController patientDiagnosisController;
  DateTime selectDate=DateTime.now();
  getPatientDiagnosisFun()  {
    getPatientDiagnosis = FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis)
        .where('idPatient',isEqualTo: context.read<ProfileProvider>().user.id)
        .snapshots();
    return getPatientDiagnosis;
  }
  @override
  void initState() {
    patientDiagnosisController= PatientDiagnosisController(context: context);
    getPatientDiagnosisFun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: getPatientDiagnosis,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Const.SHOWLOADINGINDECATOR();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                List<String> treatmentPlans=[];
                List<String> testsXrays=[];
                List<String> nameTreatmentPlans=[];
                List<String> nameTestsXrays=[];
                patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis.clear();
                if (snapshot.data!.docs!.length > 0) {
                  patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses = PatientDiagnoses.fromJson(snapshot.data!.docs!);
                  for(PatientDiagnosis patientDiagnosis in patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis){
                    for(String testFile in patientDiagnosis.treatmentPlan?.testFiles??[]){
                      treatmentPlans.add(testFile);
                      nameTreatmentPlans.add(patientDiagnosis.treatmentPlan!.namePlan);
                    }
                    for(String xRayFile in patientDiagnosis.treatmentPlan?.xRayFiles??[]){
                      testsXrays.add(xRayFile);
                      nameTestsXrays.add(patientDiagnosis.preformedSurgeries!.namePerformed);
                    }
                  }
                }
                return buildReports(context,urls: widget.title=='Tests'?treatmentPlans:testsXrays,
                    names: widget.title=='Tests'?nameTreatmentPlans:nameTestsXrays );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          })
     ,
    );
  }
  Widget buildReports(BuildContext context,{required List<String> urls,
      required List<String> names})=>
      ListView.builder(
        itemCount: urls.length,
          padding: EdgeInsets.all(12.0),
          itemBuilder: (_, index) {
            return Card(
              child: ListTile(
                onTap: () async {
                  final _url = Uri.parse(urls[index]);
                  if (await launchUrl(_url)) {
                  } else {
                    Const.TOAST(context, textToast: 'Error Launch');
                  }
                },
                leading: TextButton.icon(
                  onPressed: null,
                  icon: Text('${index + 1}'),
                  label: SvgPicture.asset(
                    AppAssets.pdfFileIMG,
                    width: 30.0,
                    height: 30.0,
                  ),
                ),
                title: Text(names[index]),
              ),
            );
          });
}
