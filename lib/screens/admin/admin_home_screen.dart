import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/admin/add_medication_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Complaints'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Admin Admin'),
              accountEmail: Text('admin@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: Text('A'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMedicationScreen(),
                  ),
                );
              },
              leading: Icon(Icons.add),
              title: Text('Add Medication'),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(),
              title: Text('Person Name ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('email@gmail.com'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints ',
                      style: TextStyle(color: AppColors.black),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
