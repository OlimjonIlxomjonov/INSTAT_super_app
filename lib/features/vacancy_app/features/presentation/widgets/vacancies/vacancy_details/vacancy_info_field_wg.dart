import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class VacancyInfoFieldWg extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasizeValue;

  const VacancyInfoFieldWg({
    super.key,
    required this.label,
    required this.value,
    this.emphasizeValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: emphasizeValue
              ? AppTextStyles.source.regular(
                  fontSize: 13,
                  color: AppColors.greyScale.grey600,
                )
              : AppTextStyles.source.medium(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: emphasizeValue
              ? AppTextStyles.source.medium(fontSize: 15)
              : AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey600,
                ),
        ),
      ],
    );
  }
}
