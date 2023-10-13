import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';

import 'package:provider/provider.dart';


import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';
import '../../models/models.dart';
import '../utils/firebase.dart';

class ChatProvider with ChangeNotifier{
  Chats chats=Chats(listChat: []);
  Chat chat=Chat.init();
  Chat chatSend=Chat.init();
  User user=User.init();
  createChat({required List<String> listIdUser}) async {
    var result=await fetchChatsByListIdUser(listIdUser: listIdUser);
    if(result['status']){
      if(result['body'].length<=0){
        result=await FirebaseFun.addChat(chat:
        Chat(messages: [], listIdUser: listIdUser, date: DateTime.now()));
        if(result['status'])
          await FirebaseFun.addMessage(message: Message.init(),idChat:result['body']['id'] );
      }

      else
        result=FirebaseFun.errorUser("Chat already found");
    }
    return result;
  }
  deleteChat(context,{required String idChat}) async{
    var result =await FirebaseFun
        .deleteChat(idChat: idChat);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  fetchUserById({required String id}) async {
    user=User.init();
    var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionPatient);
    if(result['status']&&result['body']!=null){
      user =User.fromJson(result['body']);
    }else{
      var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionDoctor);
      if(result['status']&&result['body']!=null){
        user =User.fromJson(result['body']);
      }else{
        var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionAdmin);
        if(result['status']&&result['body']!=null){
          user =User.fromJson(result['body']);
        }
      }
    }
    return result;
  }
  fetchChatByListIdUser({required List<String> listIdUser}) async {
    var result=await createChat( listIdUser: listIdUser);
     result=await FirebaseFun.fetchChatsByListIdUser(listIdUser: listIdUser);
     if(result['status']){
       Chats chats=Chats.fromJson(result['body']);
       List<Chat> listTemp=[];
       for(var element in chats.listChat){
         bool check=true;
         for(String id in listIdUser){
           if(!element.listIdUser.contains(id))
             check=false;
         }
         for(String id in element.listIdUser){
           if(!listIdUser.contains(id))
             check=false;
         }
         if(check)
           listTemp.add(element);
       }
       chats.listChat=listTemp;
       result['body']=chats.toJson()['listChat'];
       if(chats.listChat.length>0)
       chat=chats.listChat.first;
       if(chatSend.id!=chat.id){
         chatSend=chat;
         chatSend.messages.clear();
       }
     }

    return result;
  }
  fetchChatsByListIdUser({required List listIdUser}) async {
    var result=await FirebaseFun.fetchChatsByListIdUser(listIdUser: listIdUser);
    Chats chats=Chats.fromJson(result['body']);
    List<Chat> listTemp=[];
    for(var element in chats.listChat){
      bool check=true;
      // print('---------------------------');
      // print(element.listIdUser);
      // print(listIdUser);

      for(String id in listIdUser){
        // print(id);
        if(!element.listIdUser.contains(id))
          check=false;
      }
      // print(check);

      if(check)
        listTemp.add(element);
    }
    chats.listChat=listTemp;
    // print(chats.toJson());
    // print('---------------------------');
    result['body']=chats.toJson()['listChat'];
    return result;
  }
  fetchLastMessage(context,{required String idChat}) async{
    final result=await FirebaseFun.fetchLastMessage(idChat: idChat);
    Message message=Message.init();
    if(result['status']){
      message=Message.fromJson(result['body'][0]);
    }
    return message.toJson();
  }
  widgetLastMessage(context,{required String idChat}){
    return FutureBuilder(
      future: fetchLastMessage(
          context,
          idChat: idChat),
      builder: (
          context,
          snapshot,
          ) {
        print(snapshot
            .error);
        if (snapshot
            .connectionState ==
            ConnectionState
                .waiting) {
          return  Text('loading ...');
          // return  Text(tr(LocaleKeys.loading));
          //Const.CIRCLE(context);
        } else if (snapshot
            .connectionState ==
            ConnectionState
                .done) {
          if (snapshot
              .hasError) {
            return const Text(
                'Error');
          } else if (snapshot
              .hasData) {

            Message message =Message.fromJson(snapshot.data);
            // Map<String,dynamic> data=snapshot.data as Map<String,dynamic>;
            //homeProvider.sessions=Sessions.fromJson(data['body']);
            return Text(
                '${message.textMessage}'
            );
          } else {
            return const Text(
                'Empty data');
          }
        } else {
          return Text(
              'State: ${snapshot.connectionState}');
        }
      },
    );
  }
  fetchChatStream({required String idChat}) {
    final result= FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage)
        .orderBy("sendingTime")
        .snapshots();
    return result;

  }
  fetchChatsStream(String idUser) {
    final result= FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .where('listIdUser',arrayContains: idUser)
    //    .orderBy("date")
        .snapshots();
    return result;

  }
  addMessage(context,{required String idChat,required Message message}) async{
    message.sendingTime=DateTime.now();
    var result =await FirebaseFun
        .addMessage(idChat: idChat,
        message:message);
    //print(result);
    result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  deleteMessage(context,{required String idChat,required Message message}) async{
    var result =await FirebaseFun
        .deleteMessage(idChat: idChat,
        message:message);
    result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  sendMessage(context,{required String idChat,required Message message}) async{
    var result;
    if(message.typeMessage.contains(TypeMessage.text.name)){
      await FirebaseFun
          .addMessage(idChat: idChat,
          message:message);
    }else{
      // Message tempMessage=message;
      // chatSend.messages.add(tempMessage);
      //notifyListeners();
      if(message.typeMessage.contains(TypeMessage.image.name)){
        var  url=await uploadFile(filePath: message.localUrl, typePathStorage: 'Chat/Image');
        if(url!=null){
          message.url=url.toString();
          File file=File(message.localUrl);
          message.sizeFile=await file.length();
        }
        else result=onError('fail upload image');
      }
      if(result==null){
        result =await FirebaseFun
            .addMessage(idChat: idChat,
            message:message);
      }
      // print(result);
      // print('object ${ chatSend.messages.length}');
      // print(tempMessage.toJson());
      // chatSend.messages.remove(tempMessage);
      // print('object ${ chatSend.messages.length}');
      // if(!result['status']){
      //   message.statSend=-1;
      //   chatSend.messages.add(message);
      // }
      // notifyListeners();
    }



    //print(result);
 //   result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  Future uploadFile({required String filePath,required String typePathStorage}) async {
    try {
      String path = basename(filePath);
      print(path);
      File file =File(filePath);

//FirebaseStorage storage = FirebaseStorage.instance.ref().child(path);
      Reference storage = FirebaseStorage.instance.ref().child("${typePathStorage}${path}");
      UploadTask storageUploadTask = storage.putFile(file);
      TaskSnapshot taskSnapshot = await storageUploadTask;
      //Const.LOADIG(context);
      String url = await taskSnapshot.ref.getDownloadURL();
      //Navigator.of(context).pop();
      print('url $url');
      return url;
    } catch (ex) {
      //Const.TOAST( context,textToast:FirebaseFun.findTextToast("Please, upload the image"));
    }
  }
  getIdUserOtherFromList(context,List<String> idUsers){
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context,listen: false);
    for(String id in idUsers)
      if(id!=profileProvider.user.id)
        return id;
  }
  onError(error){
    print(false);
    print(error);
    return {
      'status':false,
      'message':error,
      //'body':""
    };
  }
}
