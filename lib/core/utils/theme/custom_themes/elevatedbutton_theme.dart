import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      foregroundColor: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: appH(14), horizontal: appW(14)),
      backgroundColor: AppColors.primaryColor,
      // minimumSize: Size(double.infinity, appH(45)),
      textStyle: AppTextStyles.source.medium(fontSize: 14),
    ),
  );
}
