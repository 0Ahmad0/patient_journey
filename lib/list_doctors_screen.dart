import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/constants/app_constant.dart';
import 'package:patient_journey/controller/provider/process_provider.dart';
import 'package:patient_journey/screens/add_chat_screen.dart';
import 'package:patient_journey/screens/chat_screen.dart';
import 'package:provider/provider.dart';

import 'common_widgets/constans.dart';
import 'common_widgets/picture/cach_picture_widget.dart';
import 'controller/provider/chat_provider.dart';
import 'controller/provider/profile_provider.dart';
import 'models/models.dart';

class ListDoctorsScreen extends StatefulWidget {
  const ListDoctorsScreen({super.key});

  @override
  State<ListDoctorsScreen> createState() => _ListDoctorsScreenState();
}

class _ListDoctorsScreenState extends State<ListDoctorsScreen> {
  var getChats;
  late ProfileProvider profileProvider;
  late ChatProvider chatProvider;
  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    getChatsFun();
    super.initState();
  }

  getChatsFun() async {
    getChats = chatProvider.fetchChatsStream(profileProvider.user.id);
    return getChats;
  }
  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: ([AppConstants.collectionPatient].contains(profileProvider.user.typeUser)),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddChatScreen()));
          },
          label: Text('New chat'),
          icon: Icon(Icons.chat),
        ),
      ),
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: getChats,
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
                chatProvider.chats.listChat.clear();
                if(snapshot.data!.docs!.length>0){
                  chatProvider.chats=Chats.fromJson(snapshot.data!.docs!);
                  for(Chat chat in chatProvider.chats.listChat)
                   context.read<ProcessProvider>().fetchUsers(context, idUsers:  chat.listIdUser);
                }


                return
                  chatProvider.chats.listChat.isEmpty?
                  Const.emptyWidget(context,text: "Not Chats Yet"):
                  buildListChat(context,chatProvider.chats.listChat);
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
  Widget buildListChat(BuildContext context,List<Chat> chats){
    final size = MediaQuery.sizeOf(context);
    final recId=context.read<ChatProvider>().getIdUserOtherFromList(context, context.read<ChatProvider>().chat.listIdUser);

    return
      ChangeNotifierProvider<ProcessProvider>.value(
          value: Provider.of<ProcessProvider>(context),
          child: Consumer<ProcessProvider>(
          builder: (context, value, child){

            return ListView.builder(
      itemCount: chats.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (_, index) => Card(
        child: ListTile(
          onTap: () {
            chatProvider.chat=chats[index];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(doctorName: 'Doctor name${index + 1}'),
              ),
            );
          },
          leading:   ClipOval(
              child: CacheNetworkImage(
                photoUrl: '${value.fetchLocalUser(idUser: recId??'')?.photoUrl??''}',
                width: size.width / 8,
                height: size.width / 8,
                boxFit: BoxFit.fill,
                waitWidget: CircleAvatar( ),
                errorWidget: CircleAvatar( ),
              )),
          title: Text('${
              value.fetchLocalUser(idUser: chatProvider.getIdUserOtherFromList(context, chats[index].listIdUser))?.firstName??''
          } ${
              value.fetchLocalUser(idUser: chatProvider.getIdUserOtherFromList(context, chats[index].listIdUser))?.lastName??''
          }'),
          subtitle: fetchLastMessage(context, chats[index].id),
        ),
      ),
    );}));
  }
  fetchLastMessage(BuildContext context,String idChat){
    return ChatProvider().widgetLastMessage(context, idChat: idChat);
  }
}
