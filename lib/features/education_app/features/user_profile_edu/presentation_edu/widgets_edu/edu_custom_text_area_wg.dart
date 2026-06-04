import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class EduCustomTextAreaWg extends StatelessWidget {
  final String hintText;
  final String? helperText;
  final int? maxLength;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const EduCustomTextAreaWg({
    super.key,
    required this.hintText,
    this.helperText,
    this.maxLength,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      minLines: 3,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder().copyWith(
          borderRadius: .circular(10),
          borderSide: BorderSide(color: AppColors.greyScale.grey300, width: 1),
        ),
        focusedBorder: OutlineInputBorder().copyWith(
          borderRadius: .circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        hintStyle: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey400,
        ),
        hintText: hintText,
        helper: helperText != null
            ? Row(
                children: [
                  Icon(
                    IconlyBold.danger,
                    size: 20,
                    color: AppColors.greyScale.grey600,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      helperText!,
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
      maxLines: null,
    );
  }
}
