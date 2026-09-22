import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

/// Dropdown ko'rinishidagi maydon, lekin bosilganda bottom sheet ochadi.
/// `CustomDropDownMenuWg` bilan bir xil ko'rinishda bo'lishi uchun shu
/// uslubda yozilgan.
class AppPickerFieldWg extends StatelessWidget {
  const AppPickerFieldWg({
    super.key,
    this.title,
    required this.hintText,
    this.value,
    this.isRequired = false,
    this.leadingIcon,
    this.trailingIcon = Icons.keyboard_arrow_down,
    this.onTap,
    this.hasError = false,
  });

  final String? title;
  final String hintText;
  final String? value;
  final bool isRequired;
  final IconData? leadingIcon;
  final IconData trailingIcon;
  final VoidCallback? onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              Text(title!, style: CustomTextStyles.h3half),
              if (isRequired)
                Text(
                  ' *',
                  style: CustomTextStyles.h3half.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? AppColors.redFailedTaskCard
                    : AppColors.greyScale.grey300,
                width: hasError ? 1 : 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: 20,
                    color: AppColors.greyScale.grey600,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    hasValue ? value! : hintText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.regular(
                      fontSize: 14,
                      color: hasValue
                          ? AppColors.greyScale.grey900
                          : AppColors.greyScale.grey400,
                    ),
                  ),
                ),
                Icon(trailingIcon, color: AppColors.greyScale.grey600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
