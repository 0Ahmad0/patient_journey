import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/chat_screen.dart';

class ListDoctorsScreen extends StatelessWidget {
  const ListDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Select Doctor To Chat with You!',
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, index) => Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(doctorName: 'Doctor name${index+1}'),
                      ),
                    );
                  },
                  leading: const CircleAvatar(),
                  title: Text('Doctor name${index + 1} '),
                  subtitle: const Text('last Message'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
