import 'package:flutter/material.dart';
import 'package:patient_journey/screens/doctor/add_new_patient_screen.dart';
import 'package:patient_journey/screens/doctor/add_plan_and_preformed_surgeries_screen.dart';
import 'package:patient_journey/screens/doctor/add_treatment_plan_screen.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

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
      body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemBuilder: (_, index) =>
              Card(
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>AddPlanAndPreformedSurgeriesScreen()));
                  },
                  leading: CircleAvatar(),
                  title: Text('Patient name'),
                  subtitle: Text('Patient email'),
                ),
              )),
    );
  }
}
