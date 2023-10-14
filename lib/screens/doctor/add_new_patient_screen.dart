import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';

class AddNewPatientScreen extends StatelessWidget {
  const AddNewPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Patient'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemBuilder: (_, index) => Card(
          child: ListTile(
            leading: CircleAvatar(),
            title: Text('Name'),
            subtitle: Text('email'),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
