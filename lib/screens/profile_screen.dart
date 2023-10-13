import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_journey/common_widgets/app_button.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/local/storage.dart';
import 'package:patient_journey/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../common_widgets/picture/profile_picture_widget.dart';
import '../controller/provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController(text: 'Yara Alharthy');
  final emailController = TextEditingController(text: 'yara2@gmail.com');
  final typeController = TextEditingController(text: 'Patient');
  final phoneController = TextEditingController(text: '+96654403456');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    typeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  XFile? userImage;
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChangeNotifierProvider<ProfileProvider>.value(
              value: Provider.of<ProfileProvider>(context),
              child:
                  Consumer<ProfileProvider>(builder: (context, value, child) {
                nameController.text =
                    "${value.user.firstName}" + ' ' + "${value.user.lastName}";
                emailController.text = "${value.user.email}";
                typeController.text = "${value.user.typeUser}";
                phoneController.text = "${value.user.phoneNumber}";
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StatefulBuilder(
                        builder: (context,imageSetState) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircleAvatar(

                                  backgroundColor: AppColors.grey.withOpacity(.75),
                                  radius: size.width / 5,
                                  child: userImage == null
                                      ? ClipRRect( child :
                                  CacheNetworkImage(
                                    photoUrl:   // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
                                    '${value.user.photoUrl}',
                                    width: size.width / 2.5,
                                    height: size.width / 2.5,
                                    boxFit: BoxFit.cover,
                                    waitWidget: WidgetProfilePicture(
                                      name: value.user.name,
                                      radius: size.width / 5,
                                      fontSize: size.width / 5,
                                      backgroundColor: AppColors.grey,
                                      textColor: AppColors.primary,
                                    ),
                                    errorWidget: WidgetProfilePicture(
                                      name: value.user.name,
                                      radius: size.width / 5,
                                      fontSize: size.width / 5,
                                      backgroundColor: AppColors.green,
                                      textColor: AppColors.primary,
                                    ),
                                  )
                                  )
                                      : ClipRRect(
                          borderRadius: BorderRadius.circular(size.width / 2.5),
                                        child: Image.file(
                                            File(userImage!.path),
                                          fit: BoxFit.fill,
                                          width: size.width / 2.5,
                                          height: size.width / 2.5,
                                          ),
                                      )


                          //         Icon(
                          //                 Icons.person,
                          //                 color: AppColors.white,
                          //                 size: size.width / 3,
                          //               )
                          //             : ClipRRect(
                          // borderRadius: BorderRadius.circular(size.width / 2.5),
                          //               child: Image.file(
                          //                   File(userImage!.path),
                          //                 fit: BoxFit.fill,
                          //                 width: size.width / 2.5,
                          //                 height: size.width / 2.5,
                          //                 ),
                          //             ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24),
                                            )),
                                            context: context,
                                            builder: (_) {
                                              return Container(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      onTap: () async {
                                                        final image = await picker.pickImage(source: ImageSource.camera);
                                                        if(image !=null){
                                                          userImage = image;
                                                          imageSetState((){});
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      leading: Icon(Icons.camera_alt),
                                                      title: Text('Pick From Camera'),
                                                    ),
                                                    ListTile(
                                                      onTap: () async {
                                                        final image = await picker.pickImage(source: ImageSource.gallery);
                                                        if(image !=null){
                                                          userImage = image;
                                                          imageSetState((){});
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      leading: Icon(Icons.image),
                                                      title: Text('Pick From Gallery'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.image)),
                                ),
                              )
                            ],
                          );
                        }
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormFiled(
                                    iconData: Icons.person,
                                    controller: value.firstName,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: AppTextFormFiled(
                                    iconData: Icons.person,
                                    controller: value.lastName,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppTextFormFiled(
                              iconData: Icons.email_outlined,
                              controller: value.email,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppTextFormFiled(
                              iconData: Icons.phone_android_outlined,
                              controller: value.phoneNumber,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppTextFormFiled(
                              readOnly: true,
                              iconData: Icons.merge_type,
                              controller: typeController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      AppButton(
                        onPressed: () async {
                          Const.loading(context);
                          if(userImage!=null)
                            await value.uploadImage(context, userImage!);

                          await value.editUser(context);
                          Navigator.of(context).pop();
                        },
                        text: 'Edit Profile',
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      AppButton(
                        onPressed: () {
                          AppStorage.depose();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => LoginScreen()));
                        },
                        text: 'Log out',
                        icon: const Icon(Icons.logout_outlined),
                      ),
                    ],
                  ),
                );
              }))),
    );
  }
}
