import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class TitleWithLayoutSelectorWg extends StatelessWidget {
  const TitleWithLayoutSelectorWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text('Kurslar', style: AppTextStyles.source.semiBold(fontSize: 18)),
        Container(
          margin: .symmetric(vertical: appH(20)),
          padding: .all(4),
          decoration: BoxDecoration(
            borderRadius: .circular(10),
            color: AppColors.greyScale.grey50,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: .circular(6)),
                ),
                icon: Icon(IconlyLight.category),
              ),
              IconButton(
                color: AppColors.greyScale.grey400,
                onPressed: () {},
                icon: Icon(Icons.list_alt),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
