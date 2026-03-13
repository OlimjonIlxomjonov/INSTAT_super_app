import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class CustomTextStyles {
  CustomTextStyles._();

  static final TextStyle h2 = AppTextStyles.source.semiBold(fontSize: 18);
  static final TextStyle h3 = AppTextStyles.source.medium(fontSize: 16);
  static final TextStyle h3half = AppTextStyles.source.medium(fontSize: 14);
  static final TextStyle h4 = AppTextStyles.source.regular(
    fontSize: 12,
    color: AppColors.greyScale.grey600,
  );
}
