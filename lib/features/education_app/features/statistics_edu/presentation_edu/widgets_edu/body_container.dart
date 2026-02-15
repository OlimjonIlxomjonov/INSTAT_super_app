import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

class BodyContainer extends StatelessWidget {
  final String title;
  final Widget body;

  const BodyContainer({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontal20x(),
      width: double.infinity,
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(title, style: AppTextStyles.source.medium(fontSize: 18)),
          body,
        ],
      ),
    );
  }
}
