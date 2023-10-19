
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/provider/notification_provider.dart';
import 'package:patient_journey/models/models.dart' as  models;
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../constants/app_constant.dart';
import '../controller/provider/profile_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var getNotifications;
  late NotificationProvider notificationProvider;
  getNotificationsFun()  {
    getNotifications = FirebaseFirestore.instance.collection(AppConstants.collectionNotification)
        .where('idUser',isEqualTo: context.read<ProfileProvider>().user.id).snapshots();
    return getNotifications;
  }
  @override
  void initState() {
    notificationProvider=  Provider.of<NotificationProvider>(context,listen: false);;
    getNotificationsFun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: getNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Const.SHOWLOADINGINDECATOR();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                notificationProvider.notifications.listNotification.clear();
                if (snapshot.data!.docs!.length > 0) {
                  notificationProvider.notifications = models.Notifications.fromJson(snapshot.data!.docs!);
                }
                return
                  notificationProvider.notifications.listNotification.isEmpty?
                  Const.emptyWidget(context,text: "Not Notification Yet")
                  :ListView.builder(
                    itemCount: notificationProvider.notifications.listNotification.length ,
                    itemBuilder: (_,index)=>NotificationItem(index:index,notification: notificationProvider.notifications.listNotification[index],),
                  );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),

    );
  }
}

class NotificationItem extends StatelessWidget {
   NotificationItem({super.key, required this.index,required this.notification});
  final int index;
   models.Notification notification;
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
            title: Text(notification.title),
            subtitle:  Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(notification.subtitle),
            ),
          ),
          Visibility(
            /// doctor type user
            visible: false,
             // visible: index.isEven,
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

