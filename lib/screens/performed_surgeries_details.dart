import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerformedSurgeriesDetailsScreen extends StatelessWidget {
  const PerformedSurgeriesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name PerformedSurgeries'),
      ),
      body: ListView.builder(
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
                      child: Text('Name PerformedSurgeries'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.date_range),
                          title: Text('Day : ${DateFormat.EEEE().format(DateTime.now())}'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.location_pin),
                          title: Text('Alreadh'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.person),
                          title: Text('Dr.Raghad'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.local_hospital),
                          title: Text('Alsarq'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: 'Doctor Notes',
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
