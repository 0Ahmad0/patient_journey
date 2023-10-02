import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: ListView.builder(
        itemBuilder: (_,index)=>NotificationItem(index:index),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 8,
      horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.primary)
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text('Notification $index'),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text('Text Text Text Text Text Text Text Text Text Text '
                  'Text Text Text Text Text Text Text Text Text '
                  'Text Text Text Text Text Text Text Text Text '),
            ),
          ),
          Visibility(
            /// doctor type user
              visible: index.isEven,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medication_liquid),
                    hintText: 'Doctor Type....'
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

