import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class EduCategoriesWg extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final String? categoryName;

  const EduCategoriesWg({
    super.key,
    this.isSelected = false,
    this.onTap,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    /// selected bg color = color: AppColors.eduCategorySelectedBg,
    /// border / icon / text = AppColors.primaryColor
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .symmetric(vertical: appH(6), horizontal: appW(10)),
        margin: .only(left: appW(12)),
        decoration: BoxDecoration(
          borderRadius: .circular(10),
          color: isSelected ? Colors.blue[50] : AppColors.transparent,
          border: .all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyScale.grey200,
          ),
        ),
        child: Row(
          spacing: appW(8),
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.grid_3x3,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.greyScale.grey600,
            ),
            Text(
              categoryName ?? 'Kategoriya nomi',
              style: AppTextStyles.source.medium(
                fontSize: 13,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.greyScale.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
