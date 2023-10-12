import 'package:flutter/material.dart';
import 'package:patient_journey/common_widgets/app_text_form_filed.dart';
import 'package:patient_journey/constants/app_colors.dart';

class AddTreatmentPlanScreen extends StatefulWidget {
  const AddTreatmentPlanScreen({super.key});

  @override
  State<AddTreatmentPlanScreen> createState() => _AddTreatmentPlanScreenState();
}

class _AddTreatmentPlanScreenState extends State<AddTreatmentPlanScreen> {
  final namePlanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namePlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          if(_formKey.currentState!.validate()){

          }
        },
        label: const Text('Add'),
      ),
      appBar: AppBar(
        title: Text('Add Treatment plan'),
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
                controller: namePlanController,
                hintText: 'Plan name',
              ),
              const SizedBox(height: 10.0,),
              AppTextFormFiled(),
            ],
          ),
        ),
      ),
    );
  }
}
