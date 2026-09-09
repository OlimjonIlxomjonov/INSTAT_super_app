import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class VacancyScoreRowWg extends StatelessWidget {
  final String name;
  final String minLabel;
  final String? maxLabel;

  const VacancyScoreRowWg({
    super.key,
    required this.name,
    required this.minLabel,
    this.maxLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: AppTextStyles.source.medium(fontSize: 15)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(minLabel, style: AppTextStyles.source.medium(fontSize: 15)),
              if (maxLabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  maxLabel!,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
