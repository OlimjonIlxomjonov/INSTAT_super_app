import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme lightInputDecoration = InputDecorationTheme(
    border: OutlineInputBorder().copyWith(
      borderRadius: .circular(10),
      borderSide: BorderSide(color: AppColors.greyScale.grey300, width: 1),
    ),
    // enabledBorder: OutlineInputBorder().copyWith(
    //   borderRadius: .circular(10),
    //   borderSide: BorderSide(color: AppColors.greyScale.grey300, width: 1),
    // ),
    // focusedBorder: OutlineInputBorder().copyWith(
    //   borderRadius: .circular(10),
    //   borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
    // ),
    labelStyle: AppTextStyles.source.regular(
      fontSize: 14,
      color: AppColors.greyScale.grey600,
    ),
    hintStyle: AppTextStyles.source.regular(
      fontSize: 14,
      color: AppColors.greyScale.grey600,
    ),
    floatingLabelStyle: AppTextStyles.source.regular(
      fontSize: 16,
      color: AppColors.primaryColor,
    ),
    prefixIconColor: WidgetStateColor.resolveWith(
      (state) => state.contains(WidgetState.focused)
          ? AppColors.primaryColor
          : AppColors.greyScale.grey500,
    ),
    suffixIconColor: WidgetStateColor.resolveWith(
      (state) => state.contains(WidgetState.focused)
          ? AppColors.primaryColor
          : AppColors.greyScale.grey500,
    ),
  );
}
