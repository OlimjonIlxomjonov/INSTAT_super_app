import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class AppFormFieldWg extends StatelessWidget {
  const AppFormFieldWg({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
    this.helperText,
  });

  final String label;
  final Widget child;
  final bool isRequired;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(child: Text(label, style: CustomTextStyles.h3half)),
              if (isRequired)
                Text(
                  ' *',
                  style: CustomTextStyles.h3half.copyWith(
                    color: AppColors.redFailedTaskCard,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          child,
          if (helperText != null) ...[
            const SizedBox(height: 6),
            Text(
              helperText!,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
