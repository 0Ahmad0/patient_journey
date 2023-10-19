import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/controller/provider/process_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class PlanDetailsScreen extends StatelessWidget {
   PlanDetailsScreen({super.key,required this.patientDiagnosis});
  PatientDiagnosis patientDiagnosis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('PlanName Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('العيادة'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('الدكتور : ${

    '${
    context.read<ProcessProvider>().fetchLocalUser(idUser: patientDiagnosis.idDoctor)?.firstName??''
    } ${
    context.read<ProcessProvider>().fetchLocalUser(idUser: patientDiagnosis.idDoctor)?.lastName??''
    }'
            } '),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.dangerous),
            title: Text(
                // 'المرض : سعال حاد  '
                 'المرض : ${patientDiagnosis.treatmentPlan?.namePlan??''}  '
            ),
            subtitle: Text(
                patientDiagnosis.treatmentPlan?.diseasePlan??''
               // 'تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل '
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.clean_hands),
            title: Text('العلاج : ${patientDiagnosis.treatmentPlan?.treatmentPlan??''}  '),
          ),
          const Divider(),
          ListTile(
            title: Text('المواعيد : '),
            subtitle: Wrap(
              children: List.generate(
                patientDiagnosis.treatmentPlan?.appointments.length??0,
                (index) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Chip(
                    label: Text('${DateFormat.yMd().format(patientDiagnosis.treatmentPlan!.appointments[index])}'),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('الموعد القادم : ${getNextAppointment(patientDiagnosis.treatmentPlan!.appointments)}  '),
          ),
        ],
      ),
    );
  }
  getNextAppointment(List<DateTime> appointments){
    for(DateTime dateTime in appointments)
      if(dateTime.compareTo(DateFormat.yMd().parse(DateFormat.yMd().format(DateTime.now())))==1)
        return DateFormat.yMd().format(dateTime);
    return 'لا يوجد';
   }
}
