import 'package:flutter/material.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_colors.dart';

import '../constants/app_assets.dart';
import 'notification_screen.dart';

class MedicalReviewsScreen extends StatefulWidget {
  const MedicalReviewsScreen({super.key});

  @override
  State<MedicalReviewsScreen> createState() => _MedicalReviewsScreenState();
}

class _MedicalReviewsScreenState extends State<MedicalReviewsScreen> {
  final searchController = TextEditingController();

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
                    onPressed: () {},
                  )),
            ),
            // ---------
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _medicals.length,
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
                          _medicals[index],
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
                              'Name / Type $index',
                              style: TextStyle(
                                fontSize: 12.0,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.record_voice_over,color: AppColors.white,),
                              onPressed: (){},
                            ),
                          ),
                        ))
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
