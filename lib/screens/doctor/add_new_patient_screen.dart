import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/patient_diagnosis_controller.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/constans.dart';
import '../../common_widgets/picture/cach_picture_widget.dart';
import '../../constants/app_constant.dart';
import '../../controller/provider/notification_provider.dart';
import '../../controller/provider/process_provider.dart';
import '../../controller/provider/profile_provider.dart';
import '../../models/models.dart' as models;

class AddNewPatientScreen extends StatefulWidget {
  const AddNewPatientScreen({super.key});

  @override
  State<AddNewPatientScreen> createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
  var getPatients;

  late ProfileProvider profileProvider;

  late PatientDiagnosisController patientDiagnosisController;
  models.Users users=models.Users(users: []);
  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    patientDiagnosisController = PatientDiagnosisController(context: context);
    getPatientsFun();
    super.initState();
  }

  getPatientsFun() async {
    getPatients = FirebaseFirestore.instance
        .collection(AppConstants.collectionPatient)
        .snapshots();
    return getPatients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Patient'),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: getPatients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return
                Const.SHOWLOADINGINDECATOR();
            }
            else if (snapshot.connectionState ==
                ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                users.users.clear();
                if(snapshot.data!.docs!.length>0){
                  users=models.Users.fromJson(snapshot.data!.docs!);
                  users.users=patientDiagnosisController.getNewPatient(users: users.users);
                  for(models.User user in users.users)
                    context.read<ProcessProvider>().fetchUser(context, idUser: user.id);
                }
                return
                  users.users.isEmpty?
                  Const.emptyWidget(context,text: "Not Doctors Yet"):
                  buildListPatients(context,users.users);
                /// }));
              } else {
                return const Text('Empty data');
              }
            }
            else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }
  Widget buildListPatients(BuildContext context,List<models.User> users){
    final size = MediaQuery.sizeOf(context);
     return ListView.builder(
    itemCount: users.length,
    padding: EdgeInsets.all(8.0),
    itemBuilder: (_, index) =>
    ChangeNotifierProvider<ProcessProvider>.value(
          value: Provider.of<ProcessProvider>(context),
  child: Consumer<ProcessProvider>(
  builder: (context, value, child)=>Card(
      child: ListTile(
        leading: ClipOval(
            child: CacheNetworkImage(
              photoUrl: '${value.fetchLocalUser(idUser: users[index].id)?.photoUrl??''}',
              width: size.width / 8.5,
              height: size.width / 8.5,
              boxFit: BoxFit.fill,
              waitWidget: CircleAvatar( ),
              errorWidget: CircleAvatar( ),
            )),
        title: Text(users[index].name),
        subtitle: Text(users[index].email),
        trailing: IconButton(
          onPressed: () async {
            var result=await patientDiagnosisController.addPatientDiagnosis(context, idPatient: users[index].id);
            if(result['status'])
              context.read<NotificationProvider>().addNotification(context, notification: models.Notification(idUser: users[index].id,
                  subtitle: AppConstants.notificationTitleNewDoctor+' '+(profileProvider?.user?.firstName??''),
                  dateTime: DateTime.now(), title: AppConstants.notificationSubTitleNewDoctor, message: ''));
          },
          icon: Icon(
            Icons.add_circle,
            color: AppColors.primary,
          ),
        ),
      ),
    ))),
  );}
}
