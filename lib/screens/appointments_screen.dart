import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/app_button.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Appointments'),
            bottom: TabBar(tabs: [
              Tab(
                text: 'Current',
              ),
              Tab(
                text: 'Next',
              ),
            ]),
          ),
          body: Column(
            children: [
              const Expanded(
                child: TabBarView(
                  children: [
                    CurrentAppointments(),
                    NextAppointments(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppButton(onPressed: (){
                  final picker = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2100));
                }, text: 'Select Appointment'),
              )
            ],
          ),
        ));
  }
}

class CurrentAppointments extends StatelessWidget {
  const CurrentAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),

        child: ListTile(
          leading: const Icon(Icons.date_range),
          title: Text('CurrentAppointment : ${index + 1}'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(DateFormat.yMd().add_jms().format(DateTime.now())),
          ),
        ),
      ),
    );
  }
}

class NextAppointments extends StatelessWidget {
  const NextAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
        child: ListTile(
          leading: const Icon(Icons.date_range),
          title: Text('NextAppointment : ${index + 1}'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(DateFormat.yMd().add_jms().format(DateTime.now())),
          ),
        ),
      ),
    );
  }
}
