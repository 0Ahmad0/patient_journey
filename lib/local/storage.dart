import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';


import '../constants/app_constant.dart';
import '../models/models.dart';




class AppStorage {
  static GetStorage _storage = GetStorage();


  static init(BuildContext context) async {
    if (!_storage.hasData(AppConstants.isLoginedKEY)) {
      storageWrite(key: AppConstants.isLoginedKEY, value: false);
    } else {
      Advance.isLogined = await storageRead(key: AppConstants.isLoginedKEY);
    }
    if (!_storage.hasData(AppConstants.idKEY)) {
      storageWrite(key: AppConstants.idKEY, value: "");
    } else {
      Advance.token = await storageRead(key: AppConstants.idKEY);
    }
    if (!_storage.hasData(AppConstants.languageKEY)) {
      storageWrite(key: AppConstants.languageKEY, value:'en'// context.locale.languageCode
      );
    } else {
      Advance.language = await storageRead(key: AppConstants.languageKEY);
    }

    if (!_storage.hasData(AppConstants.themeKEY)) {
      storageWrite(key: AppConstants.themeKEY, value: false);
    } else {
      Advance.theme = await storageRead(key: AppConstants.themeKEY);
      //print("a${Advance.theme}");
    }

    if (!_storage.hasData(AppConstants.uidKEY)) {
      storageWrite(key: AppConstants.uidKEY, value: "");
    } else {
      Advance.uid = await storageRead(key: AppConstants.uidKEY);
    }
    if (!_storage.hasData(AppConstants.tokenKEY)) {
      storageWrite(key: AppConstants.tokenKEY, value: "");
    } else {
      Advance.token = await storageRead(key: AppConstants.tokenKEY);
     // print("ffffffffffffffffffff${Advance.token}");
    }

  }

  static Future<void> storageWrite({key, value}) async =>
      await _storage.write(key, value);

  static Future<dynamic> storageRead({key}) async => await _storage.read(key);

  static Future<void> storageDelete({key}) async => await _storage.remove(key).then((value) => print("delete key successful"));
static depose() async {
  await _storage.remove(AppConstants.idKEY);
  await _storage.remove(AppConstants.uidKEY);
  await _storage.remove(AppConstants.tokenKEY);
  //await _storage.remove(AppConstants.phoneNumberKEY);
  await _storage.write(AppConstants.isLoginedKEY, false);
}

}