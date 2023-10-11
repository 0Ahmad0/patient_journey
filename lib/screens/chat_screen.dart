import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/constants/app_colors.dart';

import '../common_widgets/app_text_form_filed.dart';
import '../constants/app_assets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.doctorName});

  final String doctorName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  List chatList = [];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 16,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  onTap: () {},
                  child: Text('Delete'),
                )
              ];
            },
          )
        ],
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(),
          title: Text(
            widget.doctorName,
            style: TextStyle(color: AppColors.white),
          ),
          subtitle: const Text(
            'email@gmail.com',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          chatList.isEmpty
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
                          (index) => index.isEven?SenderWidget(chatList: chatList,index: index,)
                              :ReciveWidget(chatList: chatList, index: index)),
                    ),
                  ),
                ),
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
                      chatList.add(messageController.text);

                      //ToDo: Send Review
                      messageController.clear();
                      setState(() {});
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
}

class SenderWidget extends StatefulWidget {
  const SenderWidget({
    super.key,
    required this.chatList, required this.index,
  });

  final List chatList;
  final int index;

  @override
  State<SenderWidget> createState() => _SenderWidgetState();
}

class _SenderWidgetState extends State<SenderWidget> {
  @override
  Widget build(BuildContext context) {
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
                      widget.chatList.removeAt(widget.index);
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
      child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(),
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
                  child: Text(widget.chatList[widget.index]),
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

  final List chatList;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                child: Text(chatList[index]),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const CircleAvatar(),
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
