import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class EmptyStateStaticText extends StatelessWidget {
  final String _message;

  const EmptyStateStaticText({super.key, required String message})
    : _message = message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(horizontal: 20),
      padding: const .symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: AppColors.splashBackgroundColor, width: 6),
        ),
      ),
      child: Text(
        _message,
        style: AppTextStyles.source.medium(
          fontSize: 14,
          color: AppColors.splashBackgroundColor,
        ),
      ),
    );
  }
}
