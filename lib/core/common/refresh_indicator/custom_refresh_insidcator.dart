import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  //! Teskari ro'yxatlar uchun trailingEdge
  final IndicatorTrigger trigger;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.trigger = IndicatorTrigger.leadingEdge,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      trigger: trigger,
      backgroundColor: AppColors.white,
      color: AppColors.primaryColor,
      child: child,
    );
  }
}
