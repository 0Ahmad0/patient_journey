import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/constans.dart';
import '../constants/app_constant.dart';
import '../controller/patient_diagnosis_controller.dart';
import '../controller/provider/process_provider.dart';
import '../controller/provider/profile_provider.dart';
import '../models/models.dart';
//import 'package:url_launcher/url_launcher.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Reports'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'My Treatment Palns',
                ),
                Tab(
                  text: 'My Tests and X-rays',
                ),
                // Tab(
                //   text: 'My Performed Surgeries',
                // ),
              ],
            ),
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
                    return buildReports(context,treatmentPlans: treatmentPlans,testsXrays: testsXrays,
                    nameTestsXrays: nameTestsXrays,nameTreatmentPlans: nameTreatmentPlans);
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              })
          ,
        ));
  }
}
Widget buildReports(BuildContext context,{required List<String> treatmentPlans,required List<String> testsXrays,
required List<String> nameTreatmentPlans, required List<String> nameTestsXrays}){
  return TabBarView(
    children: [
      ListView.separated(
          padding: EdgeInsets.all(12.0),
          itemCount: treatmentPlans.length,
          separatorBuilder: (_, __) => SizedBox(
            height: 10.0,
          ),
          itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - ${nameTreatmentPlans[index]}.pdf',url: treatmentPlans[index],)),
      ListView.separated(
          padding: EdgeInsets.all(12.0),
          itemCount: testsXrays.length,
          separatorBuilder: (_, __) => SizedBox(
            height: 10.0,
          ),
          itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - ${nameTestsXrays[index]}.pdf',url:testsXrays[index] ,)),
      // ListView.separated(
      //     padding: EdgeInsets.all(12.0),
      //     itemCount: 15,
      //     separatorBuilder: (_, __) => SizedBox(
      //       height: 10.0,
      //     ),
      //     itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - Name.pdf',)),
    ],
  );
}
class CardFileWidget extends StatelessWidget {
  const CardFileWidget({
    super.key, required this.nameFile,
     required this.url,
  });

  final String nameFile;
  final String url;

  launchFile({url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
          child: ListTile(
            onTap: (){
              launchFile(url:url);
            },
            leading: SvgPicture.asset(
              AppAssets.pdfFileIMG,
              width: 40,
              height: 40,
            ),
            title: Text(nameFile),
          ),
        );
  }
}
