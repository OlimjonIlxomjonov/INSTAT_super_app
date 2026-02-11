import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class AppSearchbarWg extends StatelessWidget {
  const AppSearchbarWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: appH(14), horizontal: appW(14)),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: AppColors.greyScale.grey200,
      ),
      child: Row(
        children: [
          Icon(IconlyLight.search),
          SizedBox(width: appW(8)),
          Text(
            'Nimani izlayapsiz?',
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
