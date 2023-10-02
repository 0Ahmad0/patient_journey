import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTestAndXRaysScreen extends StatelessWidget {
  const MyTestAndXRaysScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
          itemBuilder: (_,index){
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index+1}'),
                ),
                title: Text('Name '),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject Subject Subject Subject Subject Subject '),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.date_range),
                        title: Text(DateFormat.yMd().add_jm().format(DateTime.now())))
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
