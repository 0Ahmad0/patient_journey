import 'package:flutter/material.dart';

class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

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
            title: Text('الدكتور : Ahmad '),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.dangerous),
            title: Text('المرض : سعال حاد  '),
            subtitle: Text(
                'تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل تفاصيل '),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.clean_hands),
            title: Text('العلاج : سوائل ساخنة  '),
          ),
          const Divider(),
          ListTile(
            title: Text('المواعيد : '),
            subtitle: Wrap(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Chip(
                    label: Text('${index + 1} : 30'),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('الموعد القادم : 10:30  '),
          ),
        ],
      ),
    );
  }
}
