import 'package:flutter/material.dart';

double appH(double number) => AppResponsiveness.heigh(number);

double appW(double number) => AppResponsiveness.width(number);

class AppResponsiveness {
  static late double screenHeight;
  static late double screenWidth;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
  }

  static double heigh(double number) => (number / 852) * screenHeight;

  static double width(double number) => (number / 393) * screenWidth;
}
