import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class WeekLabelComponent extends StatelessWidget {
  final String text;

  const WeekLabelComponent(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.source.medium(
          fontSize: 14,
          color: AppColors.greyScale.grey600,
        ),
      ),
    );
  }
}
