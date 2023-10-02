import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';

class AppTheme{
  static ThemeData  myTheme = ThemeData(
    primaryColor: AppColors.primary,
    primarySwatch: AppColors.primary,
  ).copyWith(
    scaffoldBackgroundColor: AppColors.lightPrimary,
    appBarTheme: AppBarTheme(
      centerTitle: true
    )
  );
}