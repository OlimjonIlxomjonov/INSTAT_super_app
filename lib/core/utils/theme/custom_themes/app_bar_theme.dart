import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBar = AppBarTheme(
    backgroundColor: AppColors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
  );
}
