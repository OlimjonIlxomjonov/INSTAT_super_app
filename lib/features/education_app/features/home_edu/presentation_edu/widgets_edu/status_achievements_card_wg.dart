import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class StatusAchievementsCardWg extends StatelessWidget {
  final String descText;

  const StatusAchievementsCardWg({super.key, required this.descText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 24, bottom: 24),
      padding: .symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.champion,
            style: AppTextStyles.source.bold(fontSize: 17),
          ),
          Text(
            descText,
            maxLines: 1,
            overflow: .ellipsis,
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
