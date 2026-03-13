import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/utils/app_utils.dart';

class SelectedFileContainerWg extends StatelessWidget {
  const SelectedFileContainerWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Row(
        spacing: 12,
        children: [
          SvgPicture.asset(AppVectors.pdfIcon),
          Column(
            spacing: 4,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Tahlil, taqqoslash va prognozlash',
                style: AppTextStyles.source.medium(fontSize: 14),
              ),
              Text(
                '3.4 MB',
                style: AppTextStyles.source.regular(
                  fontSize: 13,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
