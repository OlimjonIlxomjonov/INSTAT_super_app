import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class EduCustomTextAreaWg extends StatelessWidget {
  final String hintText, helperText;

  const EduCustomTextAreaWg({
    super.key,
    required this.hintText,
    required this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 200,
      minLines: 3,
      decoration: InputDecoration(
        hintStyle: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey400,
        ),
        hintText: hintText,
        helper: Row(
          children: [
            Icon(
              IconlyLight.danger,
              size: 20,
              color: AppColors.greyScale.grey600,
            ),
            Text(
              helperText,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey600,
              ),
            ),
          ],
        ),
      ),
      maxLines: null,
    );
  }
}
