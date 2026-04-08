import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

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
    return RefreshIndicator.adaptive(
      color: AppColors.primaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
