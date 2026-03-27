import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class CustomLinearIndicatorWg extends StatelessWidget {
  final double progressIndicator;

  const CustomLinearIndicatorWg({super.key, required this.progressIndicator});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progressIndicator / 100,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.primaryColor,
      backgroundColor: AppColors.greyScale.grey200,
      minHeight: 6,
    );
  }
}
