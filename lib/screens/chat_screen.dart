import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../common_widgets/app_text_form_filed.dart';
import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_assets.dart';
import '../controller/provider/chat_provider.dart';
import '../controller/provider/process_provider.dart';
import '../controller/provider/profile_provider.dart';
import '../controller/utils/firebase.dart';
import '../models/models.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.doctorName});

  final String doctorName;


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  List<Message> chatList = [];
  var getChat;
  String? recId;
  late ProfileProvider profileProvider;
  late ChatProvider chatProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    getChatFun();
    super.initState();
  }
  getChatFun() async {
    getChat = chatProvider.fetchChatStream(idChat: chatProvider.chat.id);
    return getChat;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.sizeOf(context);
    recId=chatProvider.getIdUserOtherFromList(context, chatProvider.chat.listIdUser);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 16,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    print(chatProvider.chat.id);
                    Const.loading(context);
                   var result= await chatProvider.deleteChat(context, idChat: chatProvider.chat.id);
                    Get.back();
                    if(result['status'])
                     Get.back();
                  },
                  child: Text('Delete'),
                )
              ];
            },
          )
        ],
        title:
          ChangeNotifierProvider<ProcessProvider>.value(
          value: Provider.of<ProcessProvider>(context),
          child: Consumer<ProcessProvider>(
          builder: (context, value, child)=>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
          ClipOval(
              child: CacheNetworkImage(
                photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
                '${value.fetchLocalUser(idUser: recId??'')?.photoUrl??''}',
                width: size.width / 8.5,
                height: size.width / 8.5,
                boxFit: BoxFit.fill,
                waitWidget: CircleAvatar( ),
                errorWidget: CircleAvatar( ),
              )),

          title: Text(
            '${value.fetchLocalUser(idUser: recId??'ALL Chat')?.firstName??''} ${
                value.fetchLocalUser(idUser: recId??'')?.lastName??''}',
            style: TextStyle(color: AppColors.white),
          ),
          subtitle:  Text(
            '${value.fetchLocalUser(idUser: recId??'')?.email??''}',
            style: TextStyle(color: AppColors.white),
          ),
        ))),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
          //prints the messages to the screen0
          stream: getChat,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Const.SHOWLOADINGINDECATOR();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                chatProvider.chat.messages.clear();
                if (snapshot.data!.docs!.length > 1) {
                  chatProvider.chat.messages = Messages.fromJson(snapshot.data!.docs!).listMessage;
                }
                return
                  chatProvider.chat.messages.isEmpty?
                  Const.emptyWidget(context,text: "Not Messages Yet"):
                  buildChat(context,chatProvider.chat.messages);
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          })
          ,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: AppTextFormFiled(
                  controller: messageController,
                  hintText: 'Type here...',
                )),
                const SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () {
                    if (messageController.text.trim().isNotEmpty) {
                     // chatList.add(messageController.text);

                      //ToDo: Send Review
                       chatProvider.sendMessage(context,
                          idChat: chatProvider.chat.id,
                          message: Message(
                              textMessage: '${messageController.value.text}',
                              typeMessage: TypeMessage.text.name,
                              senderId: profileProvider.user.id,
                              receiveId: recId??'',
                              sendingTime: DateTime.now(),
                              ));
                      messageController.clear();
                      //setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.send),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget buildChat(BuildContext context,List<Message> messages){
    chatList=messages;
    return   chatList.isEmpty
        ? Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppAssets.emptyIMG),
            Text(
              'Not Message Yet!',
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.08,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
              chatList.length,
                  (index) => chatList[index].senderId==profileProvider.user.id
                      ?SenderWidget(chatList: chatList,index: index,)
                  :ReciveWidget(chatList: chatList, index: index)),
        ),
      ),
    );
  }
}

class SenderWidget extends StatefulWidget {
  const SenderWidget({
    super.key,
    required this.chatList, required this.index,
  });

  final List<Message> chatList;
  final int index;

  @override
  State<SenderWidget> createState() => _SenderWidgetState();
}

class _SenderWidgetState extends State<SenderWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final recId=context.read<ChatProvider>().getIdUserOtherFromList(context, context.read<ChatProvider>().chat.listIdUser);

    return InkWell(
      onLongPress: (){
        showAdaptiveDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Remove This Message'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const  Text('Are You Sure?'),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('cancel',style: TextStyle(color: AppColors.error),)),
                    TextButton(onPressed: (){
                      //widget.chatList.removeAt(widget.index);
                      context.read<ChatProvider>().deleteMessage(context, idChat: context.read<ChatProvider>().chat.id
                          , message: widget.chatList[widget.index]);
                      Navigator.pop(context);
                      // setState(() {
                      //
                      // });
                    }, child: const Text('yes',))
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            ClipOval(
            child: CacheNetworkImage(
            photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
            '${context.read<ProcessProvider>().fetchLocalUser(idUser: context.read<ProfileProvider>().user.id??'')?.photoUrl??''}',
        width: size.width / 8.5,
        height: size.width / 8.5,
        boxFit: BoxFit.fill,
        waitWidget: CircleAvatar( ),
        errorWidget: CircleAvatar( ),
      )),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.sizeOf(context).width /
                            1.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)
                    )
                  ),
                  child: Text(widget.chatList[widget.index].textMessage),
                ),
              ],
            ),
          ),
    );
  }
}
class ReciveWidget extends StatelessWidget {
  const ReciveWidget({
    super.key,
    required this.chatList, required this.index,
  });

  final List<Message> chatList;
  final int index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final recId=context.read<ChatProvider>().getIdUserOtherFromList(context, context.read<ChatProvider>().chat.listIdUser);
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.sizeOf(context).width /
                          1.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12)
                  )
                ),
                child: Text(chatList[index].textMessage),
              ),
              const SizedBox(
                width: 10.0,
              ),
              ClipOval(
                  child: CacheNetworkImage(
                    photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
                    '${context.read<ProcessProvider>().fetchLocalUser(idUser: recId??'')?.photoUrl??''}',
                    width: size.width / 8.5,
                    height: size.width / 8.5,
                    boxFit: BoxFit.fill,
                    waitWidget: CircleAvatar( ),
                    errorWidget: CircleAvatar( ),
                  )),
            ],
          ),
        );
  }
}
/*
ListTile(
                  leading: CircleAvatar(),
                  title: Text('Name'),
                  subtitle: Text(chatList[index]),
                  trailing: Visibility(
                    visible: index == 2,
                    child: IconButton(
                      icon: const Icon(Icons.delete,color: AppColors.error,),
                      onPressed: (){
                        //ToDo: Delete Review
                        showAdaptiveDialog(context: context, builder: (_){
                          return AlertDialog(
                            title: const Text('Rwmove This Review'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const  Text('Are You Sure?'),
                                const SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: const Text('cancel',style: TextStyle(color: AppColors.error),)),
                                    TextButton(onPressed: (){
                                      chatList.removeAt(index);
                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                    }, child: const Text('yes',))
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  ),
                )
 */
