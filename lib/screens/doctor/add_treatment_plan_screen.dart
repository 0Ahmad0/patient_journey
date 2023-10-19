import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/common_widgets/constans.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:patient_journey/controller/patient_diagnosis_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/models.dart';

class AddTreatmentPlanScreen extends StatefulWidget {
   AddTreatmentPlanScreen({super.key, this.patientDiagnosis});
  PatientDiagnosis? patientDiagnosis;

  @override
  State<AddTreatmentPlanScreen> createState() => _AddTreatmentPlanScreenState();
}

class _AddTreatmentPlanScreenState extends State<AddTreatmentPlanScreen> {
  final namePlanController = TextEditingController();
  final clinicPlanController = TextEditingController();
  final diseasePlanController = TextEditingController();
  final treatmentPlanController = TextEditingController();
  bool addOrEdit=true;
@override
  void initState() {
  addOrEdit=widget.patientDiagnosis?.treatmentPlan==null;
    namePlanController.text=widget.patientDiagnosis?.treatmentPlan?.namePlan??'';
    clinicPlanController.text=widget.patientDiagnosis?.treatmentPlan?.clinicPlan??'';
    diseasePlanController.text=widget.patientDiagnosis?.treatmentPlan?.diseasePlan??'';
    treatmentPlanController.text=widget.patientDiagnosis?.treatmentPlan?.treatmentPlan??'';
    appointments=widget.patientDiagnosis?.treatmentPlan?.appointments??[];
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();


  List<File> myTestFiles = [];
  List<File> myXRayFiles = [];
  List<DateTime> appointments = [];

  @override
  void dispose() {
    namePlanController.dispose();
    clinicPlanController.dispose();
    diseasePlanController.dispose();
    treatmentPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
      StatefulBuilder(
        builder: (context,buttonSetState) =>
      FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addOrEdit?
            PatientDiagnosisController(context: context).addTreatmentPlan(context, patientDiagnosis: widget.patientDiagnosis!
                , namePlan: namePlanController.value.text, clinicPlan: clinicPlanController.value.text
                , treatmentPlan: treatmentPlanController.value.text, diseasePlan: diseasePlanController.value.text
                , testFiles: myTestFiles, xRayFiles: myXRayFiles, appointments: appointments)
            :{
              widget.patientDiagnosis!.treatmentPlan?.namePlan=namePlanController.value.text,
              widget.patientDiagnosis!.treatmentPlan?.clinicPlan=clinicPlanController.value.text,
              widget.patientDiagnosis!.treatmentPlan?.treatmentPlan=treatmentPlanController.value.text,
              widget.patientDiagnosis!.treatmentPlan?.diseasePlan=diseasePlanController.value.text,
              PatientDiagnosisController(context: context).updateTreatmentPlan(context, patientDiagnosis: widget.patientDiagnosis!,
                testFiles: myTestFiles, xRayFiles: myXRayFiles, appointments: appointments)
            };
            buttonSetState(() {
              addOrEdit=widget.patientDiagnosis?.preformedSurgeries==null;
            });
          }
        },
        label:  Text(addOrEdit?'Add':'Edit'),
      )),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              AppTextFormFiled(
                controller: namePlanController,
                hintText: 'Plan name',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: clinicPlanController,
                hintText: 'Clinic name',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: diseasePlanController,
                hintText: 'Disease name',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: treatmentPlanController,
                hintText: 'Treatment name',
                minLine: 1,
                maxLine: 4,
              ),
              const SizedBox(height: 10.0,),
              StatefulBuilder(
                  builder: (context, AppointmentsSetState) {
                    return InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (_)
                        =>Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SfDateRangePicker(
                                  initialSelectedDates: appointments,
                                  onSelectionChanged: (value){
                                    appointments = value.value;
                                  },
                                  selectionMode: DateRangePickerSelectionMode.multiple,
                                  maxDate: DateTime(2050),
                                  minDate: DateTime.now(),
                                  showNavigationArrow: true,
                                  showTodayButton: true,
                                  cancelText: 'cancel',
                                  confirmText: 'Select',
                                  showActionButtons: true,
                                  onCancel: (){
                                    Navigator.pop(context);
                                  },
                                  onSubmit: (value){
                                    if(value != null){
                                      AppointmentsSetState((){
                                      });
                                      Navigator.pop(context);
                                    }else{
                                      Const.TOAST(context,textToast: 'Please Select Dates');
                                    }

                                  },

                                ),
                              ),
                            ),
                               ],
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(appointments.isNotEmpty?8.0:16.0),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(appointments.isNotEmpty?12.0:100.0)
                        ),
                        child: appointments.isEmpty?Text('Appointments', style: TextStyle(
                            color: AppColors.grey[600],
                            fontSize: 16
                        ),):Wrap(
                          children: 
                            List.generate(appointments.length, (index) => Chip(
                              label: Text('${DateFormat.yMd().format(appointments[index])}'),
                            ))
                          ,
                        ),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 10.0,),
              Text('My Test Files :', style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10.0,),
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
                            myTestFiles = result.paths
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
                                            myTestFiles.removeAt(index);

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
                              separatorBuilder: (_, __) =>
                              const SizedBox(
                                width: 10.0,
                              ),
                              itemCount: myTestFiles.length))
                    ],
                  );
                }),
              ),
              const SizedBox(height: 10.0,),
              Text('My X-Rays Files :', style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10.0,),
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
                            myXRayFiles = result.paths
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
                                            myTestFiles.removeAt(index);

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
                              separatorBuilder: (_, __) =>
                              const SizedBox(
                                width: 10.0,
                              ),
                              itemCount: myTestFiles.length))
                    ],
                  );
                }),
              ),

              const SizedBox(height: 10.0,),


            ],
          ),
        ),
      ),
    );
  }
}
