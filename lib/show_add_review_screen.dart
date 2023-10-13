import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/medical_controller.dart';
import 'package:patient_journey/models/models.dart';

import 'common_widgets/constans.dart';
import 'constants/app_constant.dart';
import 'controller/provider/medical_provider.dart';

class ShowAndAddReviewScreen extends StatefulWidget {
   ShowAndAddReviewScreen({super.key,required this.medical});
  Medical medical;
  @override
  State<ShowAndAddReviewScreen> createState() => _ShowAndAddReviewScreenState();
}

class _ShowAndAddReviewScreenState extends State<ShowAndAddReviewScreen> {
  List<MedicalReview> reviewsList = [];
  late MedicalController medicalController;
  final messageController = TextEditingController();
  var getMedical;
  getMedicalFun()  {

    getMedical = FirebaseFirestore.instance.collection(AppConstants.collectionMedical).doc(
      widget.medical.id
    ).snapshots();
    return getMedical;
  }
  @override
  void initState() {
    medicalController=MedicalController(context: context);
    getMedicalFun();
    super.initState();
  }
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              //prints the messages to the screen0
                stream: getMedical,
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
                      reviewsList.clear();
                      if(snapshot.data!=null){
                        medicalController.medicalProvider.medical=Medical.fromJson(snapshot.data!.data()!);
                        reviewsList=medicalController.medicalProvider.medical.listMedicalReview;
                      }

                      return  buildMedicalReviews(context);
                      /// }));
                    } else {
                      return const Text('Empty data');
                    }
                  }
                  else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child:  StatefulBuilder(builder: (context, writeSetState) {
                return Row(
                  children: [
                    Expanded(child: AppTextFormFiled(
                      controller: messageController,
                      hintText: 'Type here...',
                    )),
                    const SizedBox(width: 10.0,),
                    InkWell(
                      onTap: () async {
                        if(messageController.text.trim().isNotEmpty){
                          //ToDo: Send Review
                          //ToDo: Replay-Done Send
                        //  reviewsList.add(messageController.text);
                         medicalController.addMedicalReview(context, medical: widget.medical, review: messageController.text);
                        messageController.clear();
                        writeSetState(() {
                        });
                        }
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                );
              }
            ),
          )
        ],
      ),
    );
  }
  Widget buildMedicalReviews(BuildContext context)=>
      reviewsList.isEmpty?
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppAssets.emptyIMG),
            Text('Not Reviews Yet!',style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width * 0.08,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
      ):ListView.separated(
        reverse: true,
        itemCount: reviewsList.length,
        itemBuilder: (_, index) => ListTile(
          leading: CircleAvatar(
          ),
          title: Text('${reviewsList[index].nameUser} - ${reviewsList[index].typeUser}'),
          subtitle: Text(reviewsList[index].text),
          trailing: Visibility(
            visible: medicalController.checkReviewForMe(context, reviewsList[index]),
            child: IconButton(
              icon: const Icon(Icons.delete,color: AppColors.error,),
              onPressed: (){
                //ToDo: Delete Review
                showAdaptiveDialog(context: context, builder: (_){
                  return AlertDialog(
                    title: const Text('Remove This Review'),
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
                            TextButton(onPressed: () async {
                              medicalController.deleteMedicalReview(context, medical: widget.medical, medicalReview:  widget.medical.listMedicalReview[index]);
                             // reviewsList.removeAt(index);
                              Navigator.pop(context);

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
        ), separatorBuilder: (BuildContext context, int index)=>Divider(),
      );
}
