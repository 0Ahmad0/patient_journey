import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/appointments_screen.dart';
import 'package:patient_journey/screens/communication_screen.dart';
import 'package:patient_journey/screens/doctor/patient_screen.dart';
import 'package:patient_journey/screens/medical_files_screen.dart';
import 'package:patient_journey/screens/medical_reviews_screen.dart';
import 'package:patient_journey/screens/notification_screen.dart';
import 'package:patient_journey/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../constants/app_constant.dart';
import '../controller/provider/profile_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NotificationScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProfileScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SafeArea(child: SizedBox.shrink()),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(AppAssets.doctorsIMG),
          )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ///1
                    Visibility(
                       visible: [AppConstants.collectionPatient].contains(context.read<ProfileProvider>().user.typeUser),
                      child: HomeItem(
                        text: 'Appointments',
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: AppColors.white,
                          child: Icon(
                            Icons.date_range,
                            size: 40.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AppointmentsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: [AppConstants.collectionDoctor].contains(context.read<ProfileProvider>().user.typeUser),
                      child: HomeItem(
                        text: 'Patients',
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: AppColors.white,
                          child: Icon(
                            Icons.date_range,
                            size: 40.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => PatientScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    ///2
                    HomeItem(
                      text: 'Medical Reviews',
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.medical_services,
                          size: 40.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => MedicalReviewsScreen(),
                          ),
                        );
                      },
                    ),
                    ///3
                    HomeItem(
                      text: 'Communication',
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: AppColors.white,
                        child: SvgPicture.asset(
                          AppAssets.chatIMG,
                          width: 40.0,
                          height: 40.0,
                          color: AppColors.primary,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CommunicationScreen()));
                      },
                    ),
                    ///4
                    Visibility(
    visible: [AppConstants.collectionPatient].contains(context.read<ProfileProvider>().user.typeUser),
                      child: HomeItem(
                        text: 'Mediacal file',
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: AppColors.white,
                          child: SvgPicture.asset(
                            AppAssets.medicalIMG,
                            width: 40.0,
                            height: 40.0,
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MedicalFilesScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class HomeItem extends StatelessWidget {
  const HomeItem({
    super.key,
    required this.text,
    required this.child,
    required this.onTap,
  });

  final String text;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: AppColors.primary,
          ),
          child: Row(
            children: [
              Expanded(child: child),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    text,
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.sizeOf(context).width * 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
