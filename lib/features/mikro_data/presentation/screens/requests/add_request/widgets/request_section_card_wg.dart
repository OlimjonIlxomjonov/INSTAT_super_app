import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

/// Wizard bo'limi. Ramka faqat fayl bo'limlarida ishlatiladi.
class RequestSectionCardWg extends StatelessWidget {
  const RequestSectionCardWg({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.bordered = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: bordered ? const EdgeInsets.all(16) : EdgeInsets.zero,
      decoration: bordered
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyScale.grey200),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.source.regular(
                fontSize: 13,
                color: AppColors.greyScale.grey600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Yorliq + majburiylik yulduzchasi + maydon + izoh.
class RequestFieldWg extends StatelessWidget {
  const RequestFieldWg({
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
