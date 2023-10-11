import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_journey/common_widgets/app_button.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final nameMedication = TextEditingController();
  final descriptionMedication = TextEditingController();
  final photoMedication = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        title: Text('Add Medication'),
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
                return AppTextFormFiled(
                  readOnly: true,
                  onTap: () async {
                    FilePickerResult? photoMedicationFile = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if(photoMedicationFile != null ){
                      photoMedication.text = photoMedicationFile.files.first.name;
                      fileSetState((){});
                    }
                  },
                  controller: photoMedication,
                  iconData: Icons.photo,
                  hintText: 'Click to Add Photo',
                );
              }),
              const SizedBox(
                height: 20.0,
              ),
              AppButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  text: 'Add Medication')
            ],
          ),
        ),
      ),
    );
  }
}
