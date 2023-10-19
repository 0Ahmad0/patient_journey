import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/my_test_and_xrays.dart';
import 'package:patient_journey/screens/performed_surgeries_details.dart';
import 'package:patient_journey/screens/plan_details_screen.dart';
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_constant.dart';
import '../controller/patient_diagnosis_controller.dart';
import '../controller/provider/process_provider.dart';
import '../controller/provider/profile_provider.dart';
import '../models/models.dart';
import '../models/treatment_plan_model.dart';
import 'my_reports_screen.dart';

class MedicalFilesScreen extends StatefulWidget {
  const MedicalFilesScreen({super.key});

  @override
  State<MedicalFilesScreen> createState() => _MedicalFilesScreenState();
}

class _MedicalFilesScreenState extends State<MedicalFilesScreen> {
  // final List<String> _currentDoctors = ['Doctor1', 'Doctor2'];
  final List<TreatmentPlanModel> _treatmentPlans = [
    const TreatmentPlanModel(doctorName: 'Raghad ', location: 'Alreadh'),
    const TreatmentPlanModel(doctorName: 'Ahmad', location: 'Jadah'),
    const TreatmentPlanModel(doctorName: 'Lila', location: 'Alkhobr'),
    const TreatmentPlanModel(doctorName: 'Shoroq', location: 'SAR'),
  ];
  final List<String> _tests = ['Test1', 'Test2'];
  final List<String> _xRays = ['XRAys1', 'XRAys2'];
  final List<String> _performedSurgeries = [
    'performedSurgeries1',
    'performedSurgerie2'
  ];
  final List<String> _myReports = ['Report1', 'Report2'];

  _getDropDownDecoration({required hintText}) {
    return InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: AppColors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: AppColors.primary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)));
  }


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
        title: const Text('Medical Files'),
      ),
      body: Column(
        children: [
          const SafeArea(child: SizedBox.shrink()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(AppAssets.doctorsIMG,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0
            ),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DropdownButtonFormField(
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down_sharp,
                  //     color: AppColors.white,
                  //   ),
                  //   decoration: _getDropDownDecoration(
                  //       hintText: 'My Current Doctor/s'),
                  //   items: _currentDoctors
                  //       .map((e) => DropdownMenuItem(
                  //             child: Text(e.toString()),
                  //             value: e.toString(),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {},
                  // ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),

                  ///
                  /// use package [Drop Down or Dialog]
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: StreamBuilder<QuerySnapshot>(
                      //prints the messages to the screen0
                        stream: getPatientDiagnosis,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Const.LOADING_DROPDOWN(text: 'My treatment plans');
                          } else if (snapshot.connectionState == ConnectionState.active) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (snapshot.hasData) {
                              Const.LOADING_DROPDOWN(text: 'My treatment plans');;
                              patientDiagnosisController.patientDiagnosisProvider.patientTreatmentPlan.listPatientDiagnosis.clear();
                              List<PatientDiagnosis> temp=[];
                              if (snapshot.data!.docs!.length > 0) {
                                patientDiagnosisController.patientDiagnosisProvider.patientTreatmentPlan = PatientDiagnoses.fromJson(snapshot.data!.docs!);
                                for(PatientDiagnosis patientDiagnosis in patientDiagnosisController.patientDiagnosisProvider.patientTreatmentPlan.listPatientDiagnosis)
                                  if(patientDiagnosis.treatmentPlan!=null){
                                    context.read<ProcessProvider>().fetchUser(context, idUser: patientDiagnosis.idDoctor);
                                    temp.add(patientDiagnosis);
                                  }
                                patientDiagnosisController.patientDiagnosisProvider.patientTreatmentPlan.listPatientDiagnosis=temp
                                ;
                              }
                              return
                                buildTreatmentPlans(context,patientDiagnoses: temp);
                            } else {
                              return Const.LOADING_DROPDOWN(text: 'Empty Data',stateStream:StateStream.Empty );;
                            }
                          } else {
                            return
                              Const.LOADING_DROPDOWN(text: 'State: ${snapshot.connectionState}',stateStream:StateStream.Error);

                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: PopupMenuButton(
                        child: ListTile(
                          title: Text(
                            'My Test and X-rays',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                        itemBuilder: (_) {
                          return [
                            PopupMenuItem(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyTestAndXRaysScreen(title: 'Tests')));
                              },
                              child: Text('My Test'),
                            ),
                            PopupMenuItem(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyTestAndXRaysScreen(title: 'X-rays')));
                              },
                              child: Text('My X-rays'),
                            ),
                          ];
                        }),
                  ),

                  ///

                  const SizedBox(
                    height: 20.0,
                  ),
                  ///
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child:StreamBuilder<QuerySnapshot>(
                      //prints the messages to the screen0
                        stream: getPatientDiagnosis,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Const.LOADING_DROPDOWN(text: 'My treatment plans');
                          } else if (snapshot.connectionState == ConnectionState.active) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (snapshot.hasData) {
                              Const.LOADING_DROPDOWN(text: 'My treatment plans');;
                              patientDiagnosisController.patientDiagnosisProvider.patientPreformedSurgeries.listPatientDiagnosis.clear();
                              List<PatientDiagnosis> temp=[];
                              if (snapshot.data!.docs!.length > 0) {
                                patientDiagnosisController.patientDiagnosisProvider.patientPreformedSurgeries = PatientDiagnoses.fromJson(snapshot.data!.docs!);

                                for(PatientDiagnosis patientDiagnosis in patientDiagnosisController.patientDiagnosisProvider.patientPreformedSurgeries.listPatientDiagnosis)
                                  if(patientDiagnosis.preformedSurgeries!=null){
                                    context.read<ProcessProvider>().fetchUser(context, idUser: patientDiagnosis.idDoctor);
                                    temp.add(patientDiagnosis);
                                  }
                                patientDiagnosisController.patientDiagnosisProvider.patientPreformedSurgeries.listPatientDiagnosis=temp;
                              }
                              return
                                buildPreformedSurgeries(context,patientDiagnoses: temp);
                            } else {
                              return Const.LOADING_DROPDOWN(text: 'Empty Data',stateStream:StateStream.Empty );;
                            }
                          } else {
                            return
                              Const.LOADING_DROPDOWN(text: 'State: ${snapshot.connectionState}',stateStream:StateStream.Error);

                          }
                        }),
                  ),

                  ///
                  const SizedBox(
                    height: 20.0,
                  ),

                  ///
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyReportsScreen()));
                      },
                      title: Text('My Reports',style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),),
                      trailing: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                    ),
                  ),
                  ///
                  const SizedBox(
                    height: 20.0,
                  ),

                  ///
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTreatmentPlans(BuildContext context,{required List<PatientDiagnosis> patientDiagnoses}){
    final size = MediaQuery.sizeOf(context);
    return Container(
      child:
      ChangeNotifierProvider<ProcessProvider>.value(
        value: Provider.of<ProcessProvider>(context),
    child: Consumer<ProcessProvider>(
    builder: (context, value, child)=>
      PopupMenuButton(
          child: ListTile(
            title: Text(
              'My treatment plans',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
          itemBuilder: (_) {
            return

              patientDiagnoses
                .map((e) => PopupMenuItem(
                child: Column(
                  children: [

                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    PlanDetailsScreen(patientDiagnosis: e,)));
                      },
                      leading: ClipOval(
                          child: CacheNetworkImage(
                            photoUrl: '${context.read<ProcessProvider>().fetchLocalUser(idUser: e.idDoctor)??''}',
                            width: size.width / 8.5,
                            height: size.width / 8.5,
                            boxFit: BoxFit.fill,
                            waitWidget: CircleAvatar( ),
                            errorWidget: CircleAvatar( ),
                          )),
                      title: Text(
                          '${
                              value.fetchLocalUser(idUser: e.idDoctor)?.firstName??''
                          } ${
                              value.fetchLocalUser(idUser: e.idDoctor)?.lastName??''
                          }'
                      ),
                      trailing: Text(e.treatmentPlan?.treatmentPlan??''),
                    ),
                    Divider(
                      color: AppColors.grey,
                    )
                  ],
                )))
                .toList();
          }),

    )));
  }
  Widget buildPreformedSurgeries(BuildContext context,{required List<PatientDiagnosis> patientDiagnoses}){
    return  PopupMenuButton(
        child: ListTile(
          title: Text(
            'preformed surgeries',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ),
        itemBuilder: (_) {
          return patientDiagnoses
              .map((e) => PopupMenuItem(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  PerformedSurgeriesDetailsScreen(patientDiagnosis:e)));
                    },
                    leading: CircleAvatar(
                      child: Text(
                          '${patientDiagnoses.indexOf(e) + 1}'),
                    ),
                    title: Text(e.preformedSurgeries?.namePerformed??''),
                  ),
                  Divider(
                    color: AppColors.grey,
                  )
                ],
              )))
              .toList();
        });
  }
}
