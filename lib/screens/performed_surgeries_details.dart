import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/provider/process_provider.dart';
import '../models/models.dart';

class PerformedSurgeriesDetailsScreen extends StatelessWidget {
   PerformedSurgeriesDetailsScreen({super.key,required this.patientDiagnosis});
  PatientDiagnosis patientDiagnosis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            patientDiagnosis.preformedSurgeries?.namePerformed??''
            //'Name PerformedSurgeries'
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
          padding: EdgeInsets.all(12.0),
          itemBuilder: (_,index){
            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('${index+1}'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(patientDiagnosis.preformedSurgeries?.namePerformed??''),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.date_range),
                          title: Text('Day : ${DateFormat.EEEE().format(  patientDiagnosis.preformedSurgeries!.datePerformed)}'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.location_pin),
                          title: Text(  patientDiagnosis.preformedSurgeries?.locationPerformed??''),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.person),
                          title: Text('Dr.${
                          context.read<ProcessProvider>().fetchLocalUser(idUser: patientDiagnosis.idDoctor)?.firstName??''
                          } ${
                          context.read<ProcessProvider>().fetchLocalUser(idUser: patientDiagnosis.idDoctor)?.lastName??''
                          }'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.local_hospital),
                          title: Text(patientDiagnosis.preformedSurgeries?.clinicPerformed??''),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText:
                          //'Doctor Notes'
                          patientDiagnosis.preformedSurgeries?.notesPerformed??''
                          ,
                        prefixIcon: Icon(Icons.description)
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
