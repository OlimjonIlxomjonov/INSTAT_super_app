import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class StudyItemWg extends StatelessWidget {
  final String text;

  const StudyItemWg(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle, color: AppColors.primaryColor),
      title: Text(
        text,
        style: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey500,
        ),
      ),
    );
  }
}
