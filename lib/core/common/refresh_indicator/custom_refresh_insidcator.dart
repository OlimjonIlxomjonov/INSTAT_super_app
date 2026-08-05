import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      backgroundColor: AppColors.white,
      color: AppColors.primaryColor,
      child: child,
    );
  }
}
