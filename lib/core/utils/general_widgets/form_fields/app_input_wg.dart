import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class AppInputWg extends StatelessWidget {
  const AppInputWg({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.minLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final isMultiline = minLines > 1;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: isMultiline ? minLines + 3 : 1,
      keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
      style: AppTextStyles.source.regular(fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey400,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyScale.grey300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
        ),
      ),
    );
  }
}
