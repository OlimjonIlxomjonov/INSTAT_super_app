import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class DetailedOnlineBookHeaderItemsWg extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const DetailedOnlineBookHeaderItemsWg({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: AppTextStyles.source.medium(fontSize: 16)),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: Colors.black),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey500,
          ),
        ),
      ],
    );
  }
}
