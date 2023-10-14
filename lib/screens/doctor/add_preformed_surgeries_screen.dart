import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/common_widgets/constans.dart';
import 'package:patient_journey/constants/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPreformedSurgeriesScreen extends StatefulWidget {
  const AddPreformedSurgeriesScreen({super.key});

  @override
  State<AddPreformedSurgeriesScreen> createState() => _AddPreformedSurgeriesScreenState();
}

class _AddPreformedSurgeriesScreenState extends State<AddPreformedSurgeriesScreen> {
  final namePerformedController = TextEditingController();
  final datePerformedController = TextEditingController();
  final locationPerformedController = TextEditingController();
  final clinicPerformedController = TextEditingController();
  final notesPerformedController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namePerformedController.dispose();
    datePerformedController.dispose();
    locationPerformedController.dispose();
    clinicPerformedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {

          }
        },
        label: const Text('Add'),
      ),
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
                controller: namePerformedController,
                hintText: 'Performed Surgeries name',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: locationPerformedController,
                hintText: 'Performed Surgeries Location',
              ),
              const SizedBox(height: 10.0,),
              StatefulBuilder(
                builder: (context,dateSetState) {
                  return AppTextFormFiled(
                    readOnly: true,
                    onTap: ()async{
                      DateTime? picker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050)
                      );

                      if(picker !=null){
                        datePerformedController.text = DateFormat.yMd().format(picker);
                        dateSetState((){});
                      }
                    },
                    controller: datePerformedController,
                    hintText: 'Performed Surgeries Date',
                  );
                }
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: clinicPerformedController,
                hintText: 'Performed Surgeries clinic',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(
                controller: notesPerformedController,
                hintText: 'Performed Surgeries Doctor notes',
                minLine: 1,
                maxLine: 4,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 10.0,),


            ],
          ),
        ),
      ),
    );
  }
}
