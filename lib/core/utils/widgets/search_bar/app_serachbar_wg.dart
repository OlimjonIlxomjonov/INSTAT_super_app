import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class AppSearchbarWg extends StatelessWidget {
  const AppSearchbarWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: AppColors.greyScale.grey200,
      ),
      child: Row(
        children: [
          Icon(IconlyLight.search),
          SizedBox(width: 8),
          AutoSizeText(
            localization.whatAreYouLookingFor,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey800,
            ),
          ),
        ],
      ),
    );
  }
}
