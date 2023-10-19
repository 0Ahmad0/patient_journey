import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/constants/app_constant.dart';
import 'package:patient_journey/controller/provider/auth_provider.dart';
import 'package:patient_journey/controller/provider/profile_provider.dart';
import 'package:patient_journey/list_doctors_screen.dart';
import 'package:provider/provider.dart';

import '../controller/mail_controller.dart';
//import 'package:url_launcher/url_launcher.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final _messageController = TextEditingController();
  List<File> files = [];
  late MailController mailController;

  @override
  void initState() {
    mailController = MailController(context: context);
    super.initState();
  }

  String url(phone, message) {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    ///await launchUrl(Uri.parse(url(phoneNumber, 'message')));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Communication with us!'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Spacer(),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ListDoctorsScreen()));
                  },
                  label: Text(
                    'Chat With ${[
                      AppConstants.collectionPatient
                    ].contains(context.read<ProfileProvider>().user.typeUser) ?
                    '${AppConstants.collectionDoctor}'
                        : '${AppConstants.collectionPatient}'}',
                  ),
                  icon: Icon(Icons.chat_bubble),
                ),
                Expanded(
                  flex: 3,
                  child: Lottie.asset(
                    AppAssets.communicationIMG,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24.0)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextFormFiled(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      controller: _messageController,
                      minLine: 4,
                      hintText: 'Enter your message...',
                      maxLength: 280,
                      maxLine: 8,
                    ),
                    Text(
                      'Attachments',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: AppColors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: StatefulBuilder(builder: (context, setStateFiles) {
                        return Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(allowMultiple: true);

                                if (result != null) {
                                  files = result.paths
                                      .map((path) => File(path!))
                                      .toList();
                                  setStateFiles(() {});
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                              ),
                            ),
                            Expanded(
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                const Icon(Icons.file_present),
                                          ),
                                          Positioned(
                                            left: 5,
                                            top: 12,
                                            child: GestureDetector(
                                                onTap: () {
                                                  files.removeAt(index);

                                                  setStateFiles(() {});
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.error),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: AppColors.white,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (_, __) => const SizedBox(
                                          width: 10.0,
                                        ),
                                    itemCount: files.length))
                          ],
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await _makePhoneCall('+966556422698');
                      },
                      icon: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.green,
                        size: 30.0,
                      ),
                      label: const Text(
                        'Communication with whatsapp',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0))),
                      onPressed: () {
                        if (_messageController.value.text.length > 0) {
                          mailController.addMail(
                              context, _messageController.value.text, files);
                        }
                      },
                      child: const Text('Send Request'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
