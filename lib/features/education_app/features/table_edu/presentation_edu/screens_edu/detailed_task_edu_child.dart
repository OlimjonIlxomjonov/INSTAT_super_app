import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class DetailedTaskEduChild extends StatelessWidget {
  const DetailedTaskEduChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: AppPadding.hAndV20x20(),
          padding: .all(12),
          decoration: BoxDecoration(
            borderRadius: .circular(12),
            border: .all(color: AppColors.greyScale.grey200),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Statistika (Tarmoqlar va sohalar bo’yicha)',
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
              SizedBox(height: appH(12)),
              Text(
                "Ushbu topshiriq kurs davomida o‘rganilgan statistik ma’lumotlarni real tarmoqlar va sohalar kesimida tahlil qilishga qaratilgan. Ushbu topshiriq kurs davomida o‘rganilgan statistik ma’lumotlarni real tarmoqlar va sohalar kesimida tahlil qilishga qaratilgan.",
                style: TextStyle(
                  fontWeight: .w400,
                  color: AppColors.greyScale.grey600,
                  fontSize: 13,
                  height: 2,
                ),
              ),
              SizedBox(height: appH(20)),
              Row(
                children: [
                  Icon(
                    IconlyLight.calendar,
                    color: AppColors.greyScale.grey400,
                  ),
                  Text(
                    ' 19.09.2025',
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey400,
                    ),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    IconlyLight.time_circle,
                    color: AppColors.greyScale.grey400,
                  ),
                  Text(
                    ' 18:00',
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
