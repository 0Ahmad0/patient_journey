import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/provider/notification_provider.dart';
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_constant.dart';
import '../controller/provider/chat_provider.dart';
import '../controller/provider/process_provider.dart';
import '../controller/provider/profile_provider.dart';
import '../models/models.dart' as models;
import '../models/models.dart';
import 'chat_screen.dart';



class AddChatScreen extends StatefulWidget {
   AddChatScreen({super.key});

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  var getDoctors;

  late ProfileProvider profileProvider;

  late ChatProvider chatProvider;
  Users users=Users(users: []);
  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    getDoctorsFun();
    super.initState();
  }

  getDoctorsFun() async {
    getDoctors = FirebaseFirestore.instance
        .collection(AppConstants.collectionDoctor)
        .snapshots();
    return getDoctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Chat'),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: getDoctors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return
                Const.SHOWLOADINGINDECATOR();

            }
            else if (snapshot.connectionState ==
                ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                if(snapshot.data!.docs!.length>0){
                  users=Users.fromJson(snapshot.data!.docs!);
                }

                return
                  users.users.isEmpty?
                  Const.emptyWidget(context,text: "Not Doctors Yet"):
                  buildListDoctors(context,users.users);
                /// }));
              } else {
                return const Text('Empty data');
              }
            }
            else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),

    );
  }
  Widget buildListDoctors(BuildContext context,List<User> users){
    final size = MediaQuery.sizeOf(context);
    return  ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemBuilder: (ctx,index)=>Card(
          child: ListTile(
            leading:   ClipOval(
                child: CacheNetworkImage(
                  photoUrl:  '${users[index].photoUrl??''}',
                  width: size.width / 8.5,
                  height: size.width / 8.5,
                  boxFit: BoxFit.fill,
                  waitWidget: CircleAvatar( ),
                  errorWidget: CircleAvatar( ),
                )),
            title: Text('${users[index].firstName} ${users[index].lastName}'),
            subtitle: Text(users[index].email),
            trailing: Visibility(
              child: IconButton(
                onPressed: () async {
                  Const.loading(context);
                  var result=await chatProvider.createChat(listIdUser: [profileProvider.user.id,users[index].id]);
                  if(result['status'])
                    context.read<NotificationProvider>().addNotification(context, notification: models.Notification(idUser: users[index].id, subtitle: AppConstants.notificationSubTitleNewChat+' '+(profileProvider?.user?.firstName??''), dateTime: DateTime.now(), title: AppConstants.notificationTitleNewChat, message: ''));
                  await chatProvider.fetchChatByListIdUser(listIdUser: [profileProvider.user.id,users[index].id]);
                  Get.back();
                  Get.back();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(doctorName: ''),
                    ),
                  );

                },
                icon: Icon(Icons.chat,color: AppColors.primary,),
              ),
            ),
          ),
        ),
        itemCount: users.length
    );
  }
}
