import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart';


class ProfileController{
  late ProfileProvider profileProvider;
  var context;
  ProfileController({required this.context}){
    profileProvider= Provider.of<ProfileProvider>(context);
  }
  Future uploadImage({required File image}) async {
    try {
      String path = basename(image!.path);
      print(image!.path);
      File file =File(image!.path);
      //FirebaseStorage storage = FirebaseStorage.instance.ref().child(path);
      Reference storage = FirebaseStorage.instance.ref().child("profileImage/${path}");
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
  // selectLocation(BuildContext context) async {
  //   GeoPoint? p = await showSimplePickerLocation(
  //     context: context,
  //     isDismissible: true,
  //     title: AppStringsManager.select_your_location,
  //     textConfirmPicker:
  //     AppStringsManager.select_location,
  //     initCurrentUserPosition: true,
  //   );
  //
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(
  //       p!.latitude, p.longitude);
  //   print(placemarks.first.street);
  //   String location =
  //       '${placemarks.first.country}'
  //       ' ${placemarks.first.name}';
  //   profileProvider.user.location =
  //       location;
  //   profileProvider.user.latitude = p.latitude;
  //   profileProvider.user.longitude = p.longitude;
  //   Const.LOADIG(context);
  //   await profileProvider.editUser(context);
  //   Get.back();
  //   profileProvider.notifyListeners();
  // }

}