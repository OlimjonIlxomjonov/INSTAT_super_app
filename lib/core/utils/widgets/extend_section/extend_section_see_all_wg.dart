import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class ExtendSectionSeeAllWg extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ExtendSectionSeeAllWg({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appH(10)),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(title, style: AppTextStyles.source.bold(fontSize: 16)),
          TextButton(
            onPressed: onTap,
            child: Text(
              'BARCHASI',
              style: AppTextStyles.source.bold(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
