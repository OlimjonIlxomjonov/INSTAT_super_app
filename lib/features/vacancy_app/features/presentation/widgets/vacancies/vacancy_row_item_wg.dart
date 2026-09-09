import 'package:flutter/material.dart';

import '../../../../../../../../core/utils/app_utils.dart';

class VacancyRowItemWg extends StatelessWidget {
  final IconData leadingIcon;
  final String title, trailing;

  const VacancyRowItemWg({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(leadingIcon, size: 18, color: AppColors.greyScale.grey600),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppTextStyles.source.regular(
              fontSize: 12,
              color: AppColors.greyScale.grey600,
            ),
          ),
          const Spacer(),
          Text(
            trailing,
            style: AppTextStyles.source.regular(
              fontSize: 12,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
