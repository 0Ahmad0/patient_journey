import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';

class ShowAndAddReviewScreen extends StatefulWidget {
  const ShowAndAddReviewScreen({super.key});

  @override
  State<ShowAndAddReviewScreen> createState() => _ShowAndAddReviewScreenState();
}

class _ShowAndAddReviewScreenState extends State<ShowAndAddReviewScreen> {
  List reviewsList = [];
  final messageController = TextEditingController();
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
          reviewsList.isEmpty?Expanded(
            child: SingleChildScrollView(
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
            ),
          ):Expanded(
            child: ListView.separated(
              reverse: true,
              itemCount: reviewsList.length,
              itemBuilder: (_, index) => ListTile(
                leading: CircleAvatar(),
                title: Text('Name'),
                subtitle: Text(reviewsList[index]),
                trailing: Visibility(
                  visible: index == 2,
                  child: IconButton(
                    icon: const Icon(Icons.delete,color: AppColors.error,),
                    onPressed: (){
                      //ToDo: Delete Review
                      showAdaptiveDialog(context: context, builder: (_){
                        return AlertDialog(
                          title: const Text('Rwmove This Review'),
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
                                  TextButton(onPressed: (){
                                    reviewsList.removeAt(index);
                                    Navigator.pop(context);
                                    setState(() {

                                    });
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: AppTextFormFiled(
                  controller: messageController,
                  hintText: 'Type here...',
                )),
                const SizedBox(width: 10.0,),
                InkWell(
                  onTap: (){
                    if(messageController.text.trim().isNotEmpty){
                      reviewsList.add(messageController.text);

                    //ToDo: Send Review
                      messageController.clear();
                      setState(() {

                      });
                    }
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.send),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
