import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class AppSearchbarWg extends StatelessWidget {
  final VoidCallback? onTap;

  const AppSearchbarWg({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    Widget bar = Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyScale.grey200,
      ),
      child: Row(
        children: [
          Icon(IconlyLight.search),
          const SizedBox(width: 8),
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

    if (onTap != null) {
      bar = GestureDetector(onTap: onTap, child: bar);
    }

    return Material(color: Colors.transparent, child: bar);
  }
}
