import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class EduCategoriesWg extends StatelessWidget {
  const EduCategoriesWg({super.key});

  @override
  Widget build(BuildContext context) {
    /// selected bg color = color: AppColors.eduCategorySelectedBg,
    /// border / icon / text = AppColors.primaryColor
    return Container(
      padding: .symmetric(vertical: appH(6), horizontal: appW(10)),
      margin: .only(left: appW(12), top: appH(24)),
      decoration: BoxDecoration(
        borderRadius: .circular(10),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Row(
        spacing: appW(8),
        mainAxisSize: .min,
        children: [Icon(Icons.grid_3x3), Text('Kotegoriya nomi')],
      ),
    );
  }
}
