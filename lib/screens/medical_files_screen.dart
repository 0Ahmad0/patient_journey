import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/screens/my_test_and_xrays.dart';
import 'package:patient_journey/screens/performed_surgeries_details.dart';
import 'package:patient_journey/screens/plan_details_screen.dart';

import '../models/treatment_plan_model.dart';
import 'my_reports_screen.dart';

class MedicalFilesScreen extends StatefulWidget {
  const MedicalFilesScreen({super.key});

  @override
  State<MedicalFilesScreen> createState() => _MedicalFilesScreenState();
}

class _MedicalFilesScreenState extends State<MedicalFilesScreen> {
  // final List<String> _currentDoctors = ['Doctor1', 'Doctor2'];
  final List<TreatmentPlanModel> _treatmentPlans = [
    const TreatmentPlanModel(doctorName: 'Raghad ', location: 'Alreadh'),
    const TreatmentPlanModel(doctorName: 'Ahmad', location: 'Jadah'),
    const TreatmentPlanModel(doctorName: 'Lila', location: 'Alkhobr'),
    const TreatmentPlanModel(doctorName: 'Shoroq', location: 'SAR'),
  ];
  final List<String> _tests = ['Test1', 'Test2'];
  final List<String> _xRays = ['XRAys1', 'XRAys2'];
  final List<String> _performedSurgeries = [
    'performedSurgeries1',
    'performedSurgerie2'
  ];
  final List<String> _myReports = ['Report1', 'Report2'];

  _getDropDownDecoration({required hintText}) {
    return InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: AppColors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: AppColors.primary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Files'),
      ),
      body: Column(
        children: [
          const SafeArea(child: SizedBox.shrink()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(AppAssets.doctorsIMG,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0
            ),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DropdownButtonFormField(
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down_sharp,
                  //     color: AppColors.white,
                  //   ),
                  //   decoration: _getDropDownDecoration(
                  //       hintText: 'My Current Doctor/s'),
                  //   items: _currentDoctors
                  //       .map((e) => DropdownMenuItem(
                  //             child: Text(e.toString()),
                  //             value: e.toString(),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {},
                  // ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),

                  ///
                  /// use package [Drop Down or Dialog]
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: Container(
                      child: PopupMenuButton(
                          child: ListTile(
                            title: Text(
                              'My treatment plans',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                          itemBuilder: (_) {
                            return _treatmentPlans
                                .map((e) => PopupMenuItem(
                                        child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        PlanDetailsScreen()));
                                          },
                                          leading: CircleAvatar(
                                            child: Text(
                                                '${_treatmentPlans.indexOf(e) + 1}'),
                                          ),
                                          title: Text(e.doctorName),
                                          trailing: Text(e.location),
                                        ),
                                        Divider(
                                          color: AppColors.grey,
                                        )
                                      ],
                                    )))
                                .toList();
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: PopupMenuButton(
                        child: ListTile(
                          title: Text(
                            'My Test and X-rays',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                        itemBuilder: (_) {
                          return [
                            PopupMenuItem(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyTestAndXRaysScreen(title: 'Tests')));
                              },
                              child: Text('My Test'),
                            ),
                            PopupMenuItem(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyTestAndXRaysScreen(title: 'X-rays')));
                              },
                              child: Text('My X-rays'),
                            ),
                          ];
                        }),
                  ),

                  ///

                  const SizedBox(
                    height: 20.0,
                  ),
                  ///
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: PopupMenuButton(
                        child: ListTile(
                          title: Text(
                            'preformed surgeries',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                        itemBuilder: (_) {
                          return _performedSurgeries
                              .map((e) => PopupMenuItem(
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  PerformedSurgeriesDetailsScreen()));
                                    },
                                    leading: CircleAvatar(
                                      child: Text(
                                          '${_performedSurgeries.indexOf(e) + 1}'),
                                    ),
                                    title: Text(e),
                                  ),
                                  Divider(
                                    color: AppColors.grey,
                                  )
                                ],
                              )))
                              .toList();
                        }),
                  ),

                  ///
                  const SizedBox(
                    height: 20.0,
                  ),

                  ///
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyReportsScreen()));
                      },
                      title: Text('My Reports',style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),),
                      trailing: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                    ),
                  ),
                  ///
                  const SizedBox(
                    height: 20.0,
                  ),

                  ///
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
