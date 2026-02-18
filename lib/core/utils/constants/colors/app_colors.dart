
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const greyScale = _GreyScale();

  /// DESIGN COLORS
  static const Color primaryColor = Color(0xff2B75CC);
  static const Color splashBackgroundColor = Color(0xff203787);
  static const Color eduCategorySelectedBg = Color(0xffF2F8FE);
  static const Color orange500 = Color(0xffFA7319);
  static const Color orange50 = Color(0xffFFF3EB);

  /// TASKS BAR COLOR INDICATOR
  static const Color greyNewCard = Color(0xffD1D1D1);
  static const Color yellowMidTimeCard = Color(0xffF6B51E);
  static const Color greenDoneTaskCard = Color(0xff1FC16B);
  static const Color redFailedTaskCard = Color(0xffFB3748);

  /// TICKETS STATUS BACKGROUND COLOR
  static const Color successStatus = Color(0xffE3F7EC);
  static const Color declinedStatus = Color(0xffFFF3EB);
  static const Color waitingStatus = Color(0xffFFEBEC);

  ///  DEFAULT APP COLORS
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color red = Color(0xFFFF5757);
  static const Color pink = Color(0xFFE91E63);
  static const Color purple = Color(0xFF9775FA);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color indigo = Color(0xFF4267B2);
  static const Color blue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF1DA1F2);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color teal = Color(0xFF009688);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color lime = Color(0xFFCDDC39);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF9800);
  static const Color deepOrange = Color(0xFFEA4335);
  static const Color brown = Color(0xFF795548);
  static const Color blueGrey = Color(0xFF607D8B);
}

class _GreyScale {
  const _GreyScale();

  final Color grey900 = const Color(0xFF212121);
  final Color grey800 = const Color(0xFF424242);
  final Color grey700 = const Color(0xFF616161);
  final Color grey600 = const Color(0xFF757575);
  final Color grey500 = const Color(0xFF9E9E9E);
  final Color grey400 = const Color(0xFFBDBDBD);
  final Color grey300 = const Color(0xFFE0E0E0);
  final Color grey200 = const Color(0xFFEEEEEE);
  final Color grey100 = const Color(0xFFF5F5F5);
  final Color grey50 = const Color(0xFFFAFAFA);
}
