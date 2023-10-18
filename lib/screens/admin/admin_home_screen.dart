import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/medical_controller.dart';
import 'package:patient_journey/local/storage.dart';
import 'package:patient_journey/screens/admin/add_medication_screen.dart';
import 'package:patient_journey/screens/login_screen.dart';
import 'package:patient_journey/screens/medical_reviews_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/constans.dart';
import '../../common_widgets/picture/cach_picture_widget.dart';
import '../../constants/app_constant.dart';
import '../../controller/mail_controller.dart';
import '../../controller/provider/process_provider.dart';
import '../../controller/provider/profile_provider.dart';
import '../../models/models.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late MailController mailController;
  var getMails;

  getMailsFun() {
    getMails = FirebaseFirestore.instance
        .collection(AppConstants.collectionMail)
        .snapshots();
    return getMails;
  }

  @override
  void initState() {
    mailController = MailController(context: context);
    getMailsFun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Complaints'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ChangeNotifierProvider<ProfileProvider>.value(
                value: Provider.of<ProfileProvider>(context),
                child: Consumer<ProfileProvider>(
                    builder: (context, value, child) =>
                        UserAccountsDrawerHeader(
                          accountName: Text(
                              '${value.user.firstName} ${value.user.lastName}' //'Admin Admin'
                              ),
                          accountEmail:
                              Text('${value.user.email}' //'admin@gmail.com'
                                  ),
                          currentAccountPicture: CircleAvatar(
                            child: Text('${value.user.firstName?[0]}' //'A'
                                ),
                          ),
                        ))),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMedicationScreen(),
                  ),
                );
              },
              leading: Icon(Icons.add),
              title: Text('Add Medication'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalReviewsScreen(),
                    // builder: (_) => AddMedicationScreen(),
                  ),
                );
              },
              leading: Icon(Icons.medical_information_outlined),
              title: Text('Medical Reviews'),
              // title: Text('Add Medication'),
            ),
            ListTile(
              onTap: () {
                AppStorage.depose();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              leading: Icon(Icons.output),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                //prints the messages to the screen0
                stream: getMails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Const.SHOWLOADINGINDECATOR();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      //Const.SHOWLOADINGINDECATOR();
                      mailController.mailProvider.mails.listMail.clear();
                      if (snapshot.data!.docs!.length > 0) {
                        mailController.mailProvider.mails =
                            Mails.fromJson(snapshot.data!.docs!);
                      }

                      return mailController.mailProvider.mails.listMail.isEmpty
                          ? Const.emptyWidget(context, text: "Not Mails Yet")
                          : buildMails(context,
                              mails:
                                  mailController.mailProvider.mails.listMail);

                      /// }));
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }),
          ),
        ],
      ),
    );
  }

  //ToDo hariri show list from files, but not forget active link for everAll
  Widget buildMails(BuildContext context, {List<Mail> mails = const []}) {
    final size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: mails.length,
      padding: EdgeInsets.all(12.0),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<ProcessProvider>.value(
            value: Provider.of<ProcessProvider>(context),
            child: Consumer<ProcessProvider>(builder: (context, value, child) {

              value.fetchLocalUser(idUser: mails[index].idUser ?? '');
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: ClipOval(
                          child: CacheNetworkImage(
                        photoUrl:
                            '${value.fetchLocalUser(idUser: mails[index].idUser ?? '')?.photoUrl ?? ''}',
                        width: size.width / 8.5,
                        height: size.width / 8.5,
                        boxFit: BoxFit.fill,
                        waitWidget: CircleAvatar(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: CircleAvatar(
                          child: Icon(Icons.error_outline_rounded),
                        ),
                      )),
                      title: Text(
                          '${mails[index].nameUser} - ${mails[index].typeUser}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                                '${value.fetchLocalUser(idUser: mails[index].idUser ?? '')?.email ?? ''}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${mails[index].message}',
                              //'Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints Complaints ',
                              style: TextStyle(color: AppColors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: mails[index].files.isNotEmpty,
                      child: SizedBox(
                        height: 75.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mails[index].files.length,
                          itemBuilder: (_, index) => InkWell(
                            onTap: ()async{
                              final _url = Uri.parse(mails[index].files[index]);
                              if(await launchUrl(_url)) {
                              }else{
                                Const.TOAST(context,textToast: 'Error Launch File');
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(color: AppColors.lightPrimary),
                                  borderRadius: BorderRadius.circular(4.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.12),
                                    ),
                                  ]),
                              child: SvgPicture.asset(
                                AppAssets.pdfFileIMG,
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
      },
    );
  }
}
