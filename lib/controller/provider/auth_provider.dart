import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';

//import '../../model/models.dart' as models;

import 'package:provider/provider.dart';

import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';
import '../../local/storage.dart';
import '../../models/models.dart';
import '../utils/firebase.dart';

class AuthProvider with ChangeNotifier {
  var keyForm = GlobalKey<FormState>();

  //String text = AppStringsManager.login_to_complete_book;
  var name = TextEditingController();
  var email = TextEditingController();
  var phoneNumber = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  String typeUser = AppConstants.collectionUser;
  List<String> listTypeUserWithActive = [AppConstants.collectionDoctor];
  User user = User(
      id: "id",
      uid: "uid",
      name: "name",
      email: "email",
      phoneNumber: "phoneNumber",
      password: "password",
      photoUrl: "photoUrl",
      typeUser: "typeUser",
      dateBirth: DateTime.now(),
      gender: "Male");

  visitor(context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    user = User(
        id: '',
        uid: '',
        name: AppConstants.collectionVisitor,
        email: '',
        phoneNumber: '',
        password: '',
        typeUser: AppConstants.collectionVisitor,
        photoUrl: '',
        gender: '',
        dateBirth: DateTime.now());
    profileProvider.updateUser(user: user);
  }

  signup(context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    bool checkPhoneOrEmailFound = await FirebaseFun.checkPhoneOrEmailFound(
        email: user.email,
        phone: user.phoneNumber ?? '',
        cardId: user.cardId ?? '');
    var result;
    if (checkPhoneOrEmailFound) {
      result = await FirebaseFun.signup(
        email: user.email,
        password: user.password,
      );
      if (result['status']) {
        user.uid = result['body']?.uid;
        result = await FirebaseFun.createUser(user: user);
        if (result['status']) {
          await AppStorage.storageWrite(
              key: AppConstants.isLoginedKEY, value: true);
          await AppStorage.storageWrite(
              key: AppConstants.idKEY, value: user.uid);
          await AppStorage.storageWrite(
              key: AppConstants.uidKEY, value: user.uid);
          await AppStorage.storageWrite(
              key: AppConstants.tokenKEY, value: "resultUser['token']");
          Advance.isLogined = true;
          user = User.fromJson(result['body']);
          profileProvider.updateUser(user: User.fromJson(result['body']));
        }
      }
    } else {
      result =
          await FirebaseFun.errorUser("the email or phoneNumber already uses");
    }
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  signupAD(context) async {
    bool checkPhoneOrEmailFound = await FirebaseFun.checkPhoneOrEmailFound(
        email: user.email,
        phone: user.phoneNumber ?? '',
        cardId: user.cardId ?? '');
    var result;
    if (checkPhoneOrEmailFound) {
      result =
          await FirebaseFun.signup(email: user.email, password: user.password);
      if (result['status']) {
        user.uid = result['body']?.uid;
        result = await FirebaseFun.createUser(user: user);
        if (result['status']) {
          user = User.fromJson(result['body']);
        }
      }
    } else {
      result = FirebaseFun.errorUser("the email or phoneNumber already uses");
    }
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  login(context) async {
    //var result=await loginWithPhoneNumber(context);
    var result = await loginWithPhoneNumber(context);
    if (!result['status']) result = await loginWithEmil(context);
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  loginWithEmil(context) async {
    var resultUser =
        await FirebaseFun.login(email: user.email, password: user.password);
    var result;
    if (resultUser['status']) {
      resultUser = await fetchUser(uid: resultUser['body']?.uid);

      result = await _baseLogin(context, resultUserAfterLog: resultUser);
    } else {
      result = resultUser;
    }
    return result;
  }

  loginWithPhoneNumber(context) async {
    var resultUser = await FirebaseFun.loginWithPhoneNumber(
        phoneNumber: user.phoneNumber ?? user.email,
        password: user.password,
        typeUser: AppConstants.collectionUser);
    if (!resultUser["status"])
      resultUser = await FirebaseFun.loginWithPhoneNumber(
          phoneNumber: user.phoneNumber ?? user.email,
          password: user.password,
          typeUser: AppConstants.collectionDoctor);
    if (!resultUser["status"])
      resultUser = await FirebaseFun.loginWithPhoneNumber(
          phoneNumber: user.phoneNumber ?? user.email,
          password: user.password,
          typeUser: AppConstants.collectionAdmin);
    if (resultUser['status']) {
      user = User.fromJson(resultUser['body']);
      resultUser = await _baseLogin(context, resultUserAfterLog: resultUser);
    }
    //var result;
    // result=await loginWithEmil(context);
    return resultUser;
  }

  loginWithField(context) async {
    var resultUser = await FirebaseFun.loginWithFiled(
        filed: 'cardId',
        value: user.cardId ?? user.email,
        password: user.password,
        typeUser: AppConstants.collectionUser);
    if (!resultUser["status"])
      resultUser = await FirebaseFun.loginWithFiled(
          filed: 'cardId',
          value: user.cardId ?? user.email,
          password: user.password,
          typeUser: AppConstants.collectionDoctor);
    if (!resultUser["status"])
      resultUser = await FirebaseFun.loginWithFiled(
          filed: 'cardId',
          value: user.cardId ?? user.email,
          password: user.password,
          typeUser: AppConstants.collectionAdmin);
    if (resultUser['status']) {
      user = User.fromJson(resultUser['body']);
      resultUser = await _baseLogin(context, resultUserAfterLog: resultUser);
    }
    //var result;
    // result=await loginWithEmil(context);
    return resultUser;
  }

  _baseLogin(context, {required var resultUserAfterLog}) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    var result = resultUserAfterLog;

    if (result['status']) {
      if (listTypeUserWithActive.contains(result['body']['typeUser']) &&
          !result['body']['active'])
        result = FirebaseFun.errorUser("Account not Active");
      else if (listTypeUserWithActive.contains(result['body']['typeUser']) &&
          result['body']['band'])
        result = FirebaseFun.errorUser("Account Banded");
      else {
        await AppStorage.storageWrite(
            key: AppConstants.isLoginedKEY, value: true);
        Advance.isLogined = true;
        user = User.fromJson(result['body']);
        await AppStorage.storageWrite(key: AppConstants.idKEY, value: user.id);
        await AppStorage.storageWrite(
            key: AppConstants.uidKEY, value: user.uid);
        await AppStorage.storageWrite(
            key: AppConstants.isLoginedKEY, value: Advance.isLogined);
        await AppStorage.storageWrite(
            key: AppConstants.tokenKEY, value: "resultUser['token']");
        Advance.token = user.uid;
        Advance.uid = user.uid;
        email.clear();
        password.clear();
        profileProvider.updateUser(user: User.fromJson(result['body']));
      }
    }
    return result;
  }

  loginUid(String uid) async {
    var result = await fetchUser(uid: uid);
    if (result['status']) {
      await AppStorage.storageWrite(
          key: AppConstants.isLoginedKEY, value: true);
      Advance.isLogined = true;
      user = User.fromJson(result['body']);
      await AppStorage.storageWrite(key: AppConstants.idKEY, value: user.uid);
      Advance.token = user.uid;
      email.clear();
      password.clear();
      // print(result);
    }
    print(result);
    //Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
    /*if(result['status']){
    }else{
    }*/
    // user.uid=result['body']['uid'];
  }

  fetchUser({required String uid}) async {
    var result = await FirebaseFun.fetchUser(
        uid: uid, typeUser: AppConstants.collectionUser);
    // print(result);
    if (result['status'] && result['body'] == null) {
      result = await FirebaseFun.fetchUser(
          uid: uid, typeUser: AppConstants.collectionDoctor);
      if (result['status'] && result['body'] == null) {
        result = await FirebaseFun.fetchUser(
            uid: uid, typeUser: AppConstants.collectionAdmin);
        if (result['status'] && result['body'] == null) {
          result = {
            'status': false,
            'message': "account invalid" //LocaleKeys.toast_account_invalid,
          };
        }
      }
    }
    return result;
  }

  sendPasswordResetEmail(context, {required String resetEmail}) async {
    var result = await FirebaseFun.sendPasswordResetEmail(email: resetEmail);
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  recoveryPassword(context, {required User user}) async {
    var result = await FirebaseFun.updatePassword(newPassword: user.password);
    if (result["status"])
      var resultUser = await FirebaseFun.updateUser(user: user);
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  onError(error) {
    print(false);
    print(error);
    return {
      'status': false,
      'message': error,
      //'body':""
    };
  }

  loginByTypeUser(context, {required String typeUser}) async {
    var result =
        await loginWithPhoneNumberByTypeUser(context, typeUser: typeUser);
    if (!result['status'])
      result = await loginWithEmilByTypeUser(context, typeUser: typeUser);
    print(result);
    Const.TOAST(context,
        textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

  loginWithEmilByTypeUser(context, {required String typeUser}) async {
    var resultUser =
        await FirebaseFun.login(email: user.email, password: user.password);
    var result;
    if (resultUser['status']) {
      resultUser = await fetchUserByTypeUser(
          uid: resultUser['body']?.uid, typeUser: typeUser);
      if (listTypeUserWithActive.contains(typeUser) &&
          !resultUser['body']['active'])
        result = FirebaseFun.errorUser("Account not Active");
      else if (listTypeUserWithActive.contains(result['body']['typeUser']) &&
          result['body']['band'])
        result = FirebaseFun.errorUser("Account Banded");
      else
        result = await _baseLogin(context, resultUserAfterLog: resultUser);
    } else {
      result = resultUser;
    }
    return result;
  }

  loginWithPhoneNumberByTypeUser(context, {required String typeUser}) async {
    var resultUser = await FirebaseFun.loginWithPhoneNumber(
        phoneNumber: user.email, password: user.password, typeUser: typeUser);
    if (resultUser['status']) {
      user = User.fromJson(resultUser['body']);
    }
    var result;
    result = await loginWithEmilByTypeUser(context, typeUser: typeUser);
    return result;
  }

  fetchUserByTypeUser({required String uid, required typeUser}) async {
    var result = await FirebaseFun.fetchUser(uid: uid, typeUser: typeUser);
    if (result['status'] && result['body'] == null) {
      result = {
        'status': false,
        'message': "account invalid" //LocaleKeys.toast_account_invalid,
      };
    }
    return result;
  }

  Future uploadImage(context, XFile image,
      {String folder = 'profileImage'}) async {
    //Const.LOADIG(context);
    var url = await FirebaseFun.uploadImage(image: image, folder: folder);
    print('url $url');
    if (url == null)
      Const.TOAST(context,
          textToast: FirebaseFun.findTextToast("Please, upload the image"));
    else {
      user.photoUrl = url;
    }

    //Navigator.of(context).pop();
  }

  Future uploadFile(context, File file, {String folder = 'file'}) async {
    //Const.LOADIG(context);
    var url =
        await FirebaseFun.uploadImage(image: XFile(file.path), folder: folder);
    print('url $url');
    if (url == null) {
      Const.TOAST(context,
          textToast: FirebaseFun.findTextToast("Please, upload the image"));
      return '';
    } else {
      return url;
    }
  }
}
