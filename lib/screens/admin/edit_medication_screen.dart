import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/common_widgets/app_button.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:patient_journey/data/dummy/medical.dart';
import 'package:patient_journey/models/models.dart';

import '../../controller/medical_controller.dart';

class EdigtMedicationScreen extends StatefulWidget {
   EdigtMedicationScreen({super.key,required this.medical});
  Medical medical;
  @override
  State<EdigtMedicationScreen> createState() => _EdigtMedicationScreenState();
}

class _EdigtMedicationScreenState extends State<EdigtMedicationScreen> {
  final nameMedication = TextEditingController();
  final descriptionMedication = TextEditingController();
  final photoMedication = TextEditingController();
  final photoMedicationServer = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? photoMedicationFile;
  late MedicalController medicalController;
  @override
  void initState() {
    medicalController=MedicalController(context: context);
    nameMedication.text=widget.medical.name;
    descriptionMedication.text=widget.medical.type;
    photoMedication.text=widget.medical.image;
    photoMedicationServer.text=widget.medical.image;
    super.initState();
  }
  @override
  void dispose() {
    nameMedication.dispose();
    descriptionMedication.dispose();
    photoMedication.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medication'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(24.0)),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              Lottie.asset(AppAssets.addMedicationIMG),
              AppTextFormFiled(
                controller: nameMedication,
                hintText: 'Name Medication',
                iconData: Icons.medication,
              ),
              const SizedBox(
                height: 10.0,
              ),
              AppTextFormFiled(
                controller: descriptionMedication,
                iconData: Icons.description,
                hintText: 'Description Medication',
                minLine: 1,
                maxLine: 5,
              ),
              const SizedBox(
                height: 10.0,
              ),
              StatefulBuilder(builder: (context, fileSetState) {
                return Stack(
                  children: [

                    AppTextFormFiled(
                      readOnly: true,
                      onTap: () async {
                        photoMedicationFile = await FilePicker
                            .platform
                            .pickFiles(type: FileType.image);
                        
                        if (photoMedicationFile != null) {
                          photoMedication.text =
                              photoMedicationFile!.files.first.name;
                          fileSetState(() {});
                        }
                      },
                      controller: photoMedication,
                      iconData: Icons.photo,
                      hintText: 'Click to Add Photo',
                    ),
                    Visibility(
                      visible: !photoMedication.text.isEmpty,
                      child: Positioned(
                        right: 10,
                        bottom: 10,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              photoMedication.clear();
                              fileSetState((){

                              });
                            },
                            icon: Icon(Icons.close,color: AppColors.white,),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 20.0,
              ),
              AppButton(
                  onPressed: () async {
                    ///to create dummy  medicals
                    // for(Medical medical in MedicalDummy.medicals)
                    //   await medicalController.medicalProvider.addMedical(context, medical: medical);
                    if (_formKey.currentState!.validate()) {
                      widget.medical.name=nameMedication.value.text;
                      widget.medical.type=descriptionMedication.value.text;
                      medicalController.updateMedical(context,medical:widget.medical,platformFile:
                      photoMedicationFile?.files?.first);
                    }
                  },
                  text: 'Add Medication')
            ],
          ),
        ),
      ),
    );
  }
}
