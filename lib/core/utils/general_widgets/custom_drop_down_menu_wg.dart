import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class CustomDropDownMenuWg extends StatelessWidget {
  final String title, hintText;
  final IconData? leadingIcon;
  final List<DropDownEntity>? options;
  final int? value;
  final void Function(int?)? onChanged;

  const CustomDropDownMenuWg({
    super.key,
    required this.title,
    required this.hintText,
    this.leadingIcon,
    this.options,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextStyles.h3half),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyScale.grey200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            borderRadius: BorderRadius.circular(12),
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.greyScale.grey300,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
            ),
            hint: Text(
              hintText,
              style: CustomTextStyles.h3half.copyWith(
                color: AppColors.greyScale.grey400,
              ),
            ),
            icon: Icon(
              IconlyLight.arrow_down_2,
              size: 20,
              color: AppColors.greyScale.grey400,
            ),
            dropdownColor: AppColors.greyScale.grey50,
            elevation: 3,
            items: options?.map(
              (e) => DropdownMenuItem<int>(
                value: e.id,
                child: Text(e.name),
              ),
            ).toList(),
            onChanged: onChanged ?? (val) {},
          ),
        ),
      ],
    );
  }
}
