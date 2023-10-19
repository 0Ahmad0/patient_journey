import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_constant.dart';
import 'package:patient_journey/controller/medical_controller.dart';
import 'package:patient_journey/controller/patient_diagnosis_controller.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';
import 'package:patient_journey/models/models.dart';
import 'package:patient_journey/screens/doctor/add_new_patient_screen.dart';
import 'package:patient_journey/screens/doctor/add_plan_and_preformed_surgeries_screen.dart';
import 'package:patient_journey/screens/doctor/add_treatment_plan_screen.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/constans.dart';
import '../../common_widgets/picture/cach_picture_widget.dart';
import '../../controller/provider/process_provider.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  var getPatientDiagnosis;
  late PatientDiagnosisController patientDiagnosisController;
  getPatientDiagnosisFun()  {
    getPatientDiagnosis = FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis)
        .where('idDoctor',isEqualTo: context.read<ProfileProvider>().user.id).snapshots();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:
              (_) => AddNewPatientScreen()
          ));
        },
        label: Text('New Patient'),
        icon: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('All Patient'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis.clear();
                if (snapshot.data!.docs!.length > 0) {
                  patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses = PatientDiagnoses.fromJson(snapshot.data!.docs!);

                  for(PatientDiagnosis patientDiagnosis in patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis)
                    context.read<ProcessProvider>().fetchUser(context, idUser: patientDiagnosis.idPatient);
                }
                return
                  patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis.isEmpty?
                  Const.emptyWidget(context,text: "Not Patients Yet"):
                  buildPatient(context,patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis);
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
  Widget buildPatient(BuildContext context,List<PatientDiagnosis> patientDiagnoses){

    final size = MediaQuery.sizeOf(context);
    return ListView.builder(
        itemCount: patientDiagnoses.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (_, index) =>
            Card(
              child:
              ChangeNotifierProvider<ProcessProvider>.value(
                  value: Provider.of<ProcessProvider>(context),
                  child: Consumer<ProcessProvider>(
                      builder: (context, value, child)=>
                          ListTile(
                            onTap: (){
                              patientDiagnosisController.patientDiagnosisProvider.patientDiagnosis=patientDiagnoses[index];
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_)=>AddPlanAndPreformedSurgeriesScreen(patientDiagnosis:patientDiagnoses[index])));
                            },
                            leading:  ClipOval(
                                child: CacheNetworkImage(
                                  photoUrl: '${value.fetchLocalUser(idUser: patientDiagnoses[index].idPatient)?.photoUrl??''}',
                                  width: size.width / 8,
                                  height: size.width / 8,
                                  boxFit: BoxFit.fill,
                                  waitWidget: CircleAvatar( ),
                                  errorWidget: CircleAvatar( ),
                                )),
                            title: Text(
                                '${
                                    value.fetchLocalUser(idUser: patientDiagnoses[index].idPatient)?.firstName??''
                                } ${
                                    value.fetchLocalUser(idUser: patientDiagnoses[index].idPatient)?.lastName??''
                                }'
                            ),
                            subtitle: Text('${
                                value.fetchLocalUser(idUser:patientDiagnoses[index].idPatient)?.email??''
                            }'),
                          ))),
            ));
  }
}
