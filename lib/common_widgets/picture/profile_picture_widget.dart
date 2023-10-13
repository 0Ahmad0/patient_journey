import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';


class WidgetProfilePicture extends StatelessWidget {
  Color textColor;
  Color backgroundColor;
  final String name;
  final String? role;
  final double radius;
  final double fontSize;
  WidgetProfilePicture({
    this.textColor = Colors.white,
    this.backgroundColor = AppColors.primary,
     required this.name,
    this.role,
     required this.radius,
      this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        //borderRadius: BorderRadius.circular(radius)
      ),
      
      child:
          Text(
            '${findFirstsCharFromText(name)}',
            style: TextStyle(
              fontSize: fontSize,
              color: textColor
            ),),
    );
  }
  String findFirstsCharFromText(String text){
    String firstsCharFromText="";
    List<String> listFromWord=text.split(" ");
    firstsCharFromText+=listFromWord.first[0].toUpperCase();
    (listFromWord.length>1)?firstsCharFromText+=listFromWord.last[0]:"";
    return firstsCharFromText;
  }
}