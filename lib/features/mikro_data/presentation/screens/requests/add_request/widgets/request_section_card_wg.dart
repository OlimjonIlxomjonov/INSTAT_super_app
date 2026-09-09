import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

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
