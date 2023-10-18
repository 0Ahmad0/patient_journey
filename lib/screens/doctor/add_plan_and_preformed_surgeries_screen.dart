import 'package:flutter/material.dart';
import 'package:patient_journey/models/models.dart';
import 'package:patient_journey/screens/doctor/add_preformed_surgeries_screen.dart';
import 'package:patient_journey/screens/doctor/add_treatment_plan_screen.dart';

class AddPlanAndPreformedSurgeriesScreen extends StatelessWidget {
   AddPlanAndPreformedSurgeriesScreen({super.key, this.patientDiagnosis});
  PatientDiagnosis? patientDiagnosis;
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Plan & Preformed Surgeries'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Add Treatment Plan',
                icon: Icon(Icons.next_plan),
              ),
              Tab(
                text: 'Add Preformed Surgeries',
                icon: Icon(Icons.medication),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          AddTreatmentPlanScreen(patientDiagnosis:patientDiagnosis),
          AddPreformedSurgeriesScreen(patientDiagnosis:patientDiagnosis),
        ]),
      ),
    );
  }
}
