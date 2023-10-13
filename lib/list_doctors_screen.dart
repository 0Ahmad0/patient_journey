import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/add_chat_screen.dart';
import 'package:patient_journey/screens/chat_screen.dart';

class ListDoctorsScreen extends StatelessWidget {
  const ListDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddChatScreen()));
        },
        label: Text('New chat'),
        icon: Icon(Icons.chat),
      ),
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (_, index) => Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChatScreen(doctorName: 'Doctor name${index + 1}'),
                ),
              );
            },
            leading: const CircleAvatar(),
            title: Text('Doctor name${index + 1} '),
            subtitle: const Text('last Message'),
          ),
        ),
      ),
    );
  }
}
