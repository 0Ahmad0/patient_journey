import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:patient_journey/constants/app_colors.dart';

import '../constants/style_manager.dart';

class Const{
  static loading (context){
    Get.dialog(
        Center(
          child: Container(
              alignment: Alignment.center,
              width:  MediaQuery.sizeOf(context).width  * 0.2,
              height: MediaQuery.sizeOf(context).width * 0.2,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              child:
              CircularProgressIndicator(
                color: AppColors.primary,
              )
              // LoadingAnimationWidget.inkDrop(
              //     color: AppColors.primary,
              //     size: MediaQuery.sizeOf(context).width * 0.1)
          ),
        ),
        barrierDismissible: false
    );
  }
  static TOAST(BuildContext context, {String textToast = "This Is Toast"}) {
    showToast(
        textToast,
        context: context,
        animation: StyledToastAnimation.fadeScale,
        textStyle: getRegularStyle(color: AppColors.white)
    );
  }

}