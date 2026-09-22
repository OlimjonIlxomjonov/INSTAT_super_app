import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';

class VacancyFilterButtonWg extends StatelessWidget {
  final String? activeLabel;
  final VoidCallback onTap;

  const VacancyFilterButtonWg({
    super.key,
    required this.activeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isActive = activeLabel != null;
    final color = isActive
        ? AppColors.primaryColor
        : AppColors.greyScale.grey600;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isActive
              ? AppColors.primaryColor.withValues(alpha: 0.08)
              : null,
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor
                : AppColors.greyScale.grey200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(IconlyLight.filter, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              activeLabel ?? l.filter,
              style: AppTextStyles.source.medium(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
