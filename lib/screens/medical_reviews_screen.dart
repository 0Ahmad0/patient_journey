import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/provider/medical_provider.dart';
import 'package:patient_journey/models/models.dart';
import 'package:patient_journey/show_add_review_screen.dart';
import 'package:provider/provider.dart';

import '../common_widgets/constans.dart';
import '../constants/app_assets.dart';
import '../constants/app_constant.dart';
import '../data/dummy/medical.dart';
import 'notification_screen.dart';

class MedicalReviewsScreen extends StatefulWidget {
  const MedicalReviewsScreen({super.key});

  @override
  State<MedicalReviewsScreen> createState() => _MedicalReviewsScreenState();
}

class _MedicalReviewsScreenState extends State<MedicalReviewsScreen> {
  final searchController = TextEditingController();
  var getMedical;
  late MedicalProvider medicalProvider;
  getMedicalFun()  {
    getMedical = FirebaseFirestore.instance.collection(AppConstants.collectionMedical)
        .snapshots();
    return getMedical;
  }
  @override
  void initState() {
    getMedicalFun();
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<String> _medicals = [
    'https://th.bing.com/th/id/OIP.Dk0yfPR-8gcrURCmy2OEgwHaFL?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.Dk0yfPR-8gcrURCmy2OEgwHaFL?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.JG_elcKOlDIBj8KvfAke9wHaFj?pid=ImgDet&w=203&h=152&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.eE5JDpKhmouBTHbTqEzNjgHaGe?pid=ImgDet&w=203&h=177&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.YL7a-Jwk-GYJkBmM3VX-KQHaFi?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.K2oslYg3N28gEY3Kt2byUgAAAA?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.eE5JDpKhmouBTHbTqEzNjgHaGe?pid=ImgDet&w=203&h=177&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.YL7a-Jwk-GYJkBmM3VX-KQHaFi?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.eE5JDpKhmouBTHbTqEzNjgHaGe?pid=ImgDet&w=203&h=177&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.YL7a-Jwk-GYJkBmM3VX-KQHaFi?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.K2oslYg3N28gEY3Kt2byUgAAAA?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.K2oslYg3N28gEY3Kt2byUgAAAA?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.eE5JDpKhmouBTHbTqEzNjgHaGe?pid=ImgDet&w=203&h=177&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.YL7a-Jwk-GYJkBmM3VX-KQHaFi?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.K2oslYg3N28gEY3Kt2byUgAAAA?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.eE5JDpKhmouBTHbTqEzNjgHaGe?pid=ImgDet&w=203&h=177&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.YL7a-Jwk-GYJkBmM3VX-KQHaFi?pid=ImgDet&rs=1',
    'https://th.bing.com/th/id/OIP.B6MgN5b2qiwfV16JvIWJiQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3',
    'https://th.bing.com/th/id/OIP.K2oslYg3N28gEY3Kt2byUgAAAA?pid=ImgDet&rs=1',
  ];

  @override
  Widget build(BuildContext context) {

    medicalProvider= Provider.of<MedicalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reviews'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NotificationScreen()));
          }, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  fillColor: AppColors.white,
                  filled: true,
                  hintText: 'Search Here',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                      });
                    },
                  )),
            ),
            // ---------
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                        medicalProvider.medicals.listMedical.clear();
                        if(snapshot.data!.docs!.length>0){

                          medicalProvider.medicals=Medicals.fromJson(snapshot.data!.docs!);
                          medicalProvider.medicals.listMedical=medicalProvider
                              .searchMedicalsByName(searchController.text, medicalProvider.medicals.listMedical);
                        }

                        return
                           BuildMedicals(medicals:medicalProvider.medicals.listMedical ,);
                        /// }));
                      } else {
                        return const Text('Empty data');
                      }
                    }
                    else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

}
class BuildMedicals extends StatelessWidget {
   BuildMedicals({super.key,required this.medicals});
  List<Medical> medicals;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: medicals.length,
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 2,
                  child: Image.network(
                    medicals[index].image,
                    width: 100,
                    height: 100,
                  )),
              Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12.0))),
                    child: ListTile(
                      title: Text(
                        medicals[index].name+' / '+ medicals[index].type,
                      //  'Name / Type $index',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.record_voice_over,color: AppColors.white,),
                        onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ShowAndAddReviewScreen(medical: medicals[index],)));
                        },
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}
