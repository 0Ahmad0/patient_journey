import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/app_button.dart';
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../constants/app_constant.dart';
import '../controller/patient_diagnosis_controller.dart';
import '../controller/provider/process_provider.dart';
import '../controller/provider/profile_provider.dart';
import '../models/models.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  var getPatientDiagnosis;
  late PatientDiagnosisController patientDiagnosisController;
  DateTime selectDate=DateTime.now();
  getPatientDiagnosisFun()  {
    getPatientDiagnosis = FirebaseFirestore.instance.collection(AppConstants.collectionPatientDiagnosis)
        .where('idPatient',isEqualTo: context.read<ProfileProvider>().user.id)
        .where('treatmentPlan',isNotEqualTo: null).snapshots();
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
            title: Text('Appointments'),
            bottom: TabBar(tabs: [
              Tab(
                text: 'Today',
              ),
              Tab(
                text: 'Next',
              ),
            ]),
          ),
          body: Column(
            children: [
               Expanded(
                child:

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
                          patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis.clear();
                          if (snapshot.data!.docs!.length > 0) {
                            patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses = PatientDiagnoses.fromJson(snapshot.data!.docs!);

                            for(PatientDiagnosis patientDiagnosis in patientDiagnosisController.patientDiagnosisProvider.patientDiagnoses.listPatientDiagnosis)
                              context.read<ProcessProvider>().fetchUser(context, idUser: patientDiagnosis.idDoctor);
                          }
                          return

                            TabBarView(
                              children: [
                                CurrentAppointments(
                                  selectDate:selectDate,
                                  patientDiagnoses: patientDiagnosisController.patientDiagnosisProvider?.patientDiagnoses?.listPatientDiagnosis
                                      ??[],),
                                NextAppointments(selectDate:selectDate,patientDiagnoses: patientDiagnosisController.patientDiagnosisProvider?.patientDiagnoses?.listPatientDiagnosis??[]),
                              ],
                            );
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return Text('State: ${snapshot.connectionState}');
                      }
                    }),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: AppButton(onPressed: () async {
              //     final picker =await showDatePicker(
              //         context: context,
              //         initialDate: selectDate,
              //         firstDate: DateTime(1990),
              //         lastDate: DateTime(2100));
              //     selectDate=picker??selectDate;
              //     setState(() {
              //     });
              //   }, text: 'Select Appointment'),
              // )
            ],
          ),
        ));
  }
}

class CurrentAppointments extends StatelessWidget {
   CurrentAppointments({super.key,required this.patientDiagnoses,required this.selectDate});
   List<PatientDiagnosis> patientDiagnoses;
   DateTime selectDate;
  @override
  Widget build(BuildContext context) {
    List<PatientDiagnosis> temp=[];

    for(PatientDiagnosis patientDiagnosis in patientDiagnoses)
       if(patientDiagnosis.treatmentPlan!=null&&patientDiagnosis.treatmentPlan!.appointments.contains(DateFormat.yMd().parse(DateFormat.yMd().format(selectDate))))
         temp.add(patientDiagnosis);
    patientDiagnoses=temp;
    return
      patientDiagnoses.isEmpty?
      Const.emptyWidget(context,text: "Not Appointments Yet"):
      ListView.builder(
        itemCount: patientDiagnoses.length,
      itemBuilder: (_, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),

        child:
        ChangeNotifierProvider<ProcessProvider>.value(
        value: Provider.of<ProcessProvider>(context),
        child: Consumer<ProcessProvider>(
        builder: (context, value, child)=>
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text( '${
              value.fetchLocalUser(idUser: patientDiagnoses[index].idDoctor)?.firstName??''
          } ${
              value.fetchLocalUser(idUser: patientDiagnoses[index].idDoctor)?.lastName??''
          }'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
            //    DateFormat.yMd().add_jms().format(DateTime.now())
                getShortDates(patientDiagnoses[index].treatmentPlan!.appointments!)
            ),
          ),
        ))),
      ),
    );
  }
   getShortDates(List<DateTime> dates){
     String shortDates='';
     shortDates=DateFormat.yMd().format(dates.first);
     if(dates.length>1)
       shortDates+=' .... '+DateFormat.yMd().format(dates.last);
     return shortDates;
   }
}

class NextAppointments extends StatelessWidget {
   NextAppointments({super.key,required this.patientDiagnoses,required this.selectDate});
  List<PatientDiagnosis> patientDiagnoses;
   DateTime selectDate;
  @override
  Widget build(BuildContext context) {
    List<PatientDiagnosis> temp=[];
    for(PatientDiagnosis patientDiagnosis in patientDiagnoses)
      for(DateTime dateTime in patientDiagnosis.treatmentPlan?.appointments??[])
        if(dateTime.compareTo(DateFormat.yMd().parse(DateFormat.yMd().format(selectDate)))==1){
          temp.add(patientDiagnosis);
          break;
        }
    patientDiagnoses=temp;
    return
      patientDiagnoses.isEmpty?
      Const.emptyWidget(context,text: "Not Patients Yet"):
      ListView.builder(
        itemCount: patientDiagnoses.length,
      itemBuilder: (_, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
        child:

        ChangeNotifierProvider<ProcessProvider>.value(
        value: Provider.of<ProcessProvider>(context),
        child: Consumer<ProcessProvider>(
        builder: (context, value, child)=>ListTile(
          leading: const Icon(Icons.date_range),
          title: Text('${
              value.fetchLocalUser(idUser: patientDiagnoses[index].idDoctor)?.firstName??''
          } ${
              value.fetchLocalUser(idUser: patientDiagnoses[index].idDoctor)?.lastName??''
          }'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
                //DateFormat.yMd().add_jms().format(DateTime.now())
                getShortDates(patientDiagnoses[index].treatmentPlan!.appointments!)
            ),
          ),
        ),
      ),
    )));
  }
  getShortDates(List<DateTime> dates){
    String shortDates='';
    shortDates=DateFormat.yMd().format(dates.first);
    if(dates.length>1)
      shortDates+=' .... '+DateFormat.yMd().format(dates.last);
    return shortDates;
  }
}
