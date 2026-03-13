import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class CustomDropDownMenuWg extends StatelessWidget {
  final String title, hintText;
  final IconData? leadingIcon;

  const CustomDropDownMenuWg({
    super.key,
    required this.title,
    required this.hintText,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: CustomTextStyles.h3half),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: .all(color: AppColors.greyScale.grey200),
            borderRadius: .circular(12),
          ),
          child: DropdownButtonFormField(
            borderRadius: .circular(12),
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
              hintText: hintText,
            ),
            icon: Icon(
              IconlyLight.arrow_down_2,
              size: 20,
              color: AppColors.greyScale.grey400,
            ),
            dropdownColor: AppColors.greyScale.grey50,
            elevation: 3,
            items: [
              DropdownMenuItem(
                enabled: false,
                value: hintText,
                child: Text(
                  hintText,
                  style: CustomTextStyles.h3half.copyWith(
                    color: AppColors.greyScale.grey400,
                  ),
                ),
              ),
              DropdownMenuItem(value: '1', child: Text('1')),
              DropdownMenuItem(value: '2', child: Text('2')),
            ],
            onChanged: (n) {},
          ),
        ),
      ],
    );
  }
}
