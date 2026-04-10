import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class TestQuestionWg extends StatelessWidget {
  final String questionTitle;
  final String questionText;

  const TestQuestionWg({
    super.key,
    required this.questionTitle,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionTitle,
          style: AppTextStyles.source.medium(fontSize: 22),
        ),
        SizedBox(height: appH(16)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.greyScale.grey50,
            border: Border.all(color: AppColors.greyScale.grey200),
          ),
          child: Text(
            questionText,
            textAlign: TextAlign.center,
            style: AppTextStyles.source.medium(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
