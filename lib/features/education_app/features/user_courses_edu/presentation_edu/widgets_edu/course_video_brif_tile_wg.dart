import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class CourseVideoBriefTileWg extends StatelessWidget {
  final VoidCallback onTap;

  const CourseVideoBriefTileWg({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          '01. Tarmoqlar bo‘yicha statistika asoslari',
          style: AppTextStyles.source.semiBold(fontSize: 17),
        ),
        SizedBox(height: appH(16)),
        ...List.generate(4, (index) {
          return Container(
            padding: .symmetric(horizontal: appH(12)),
            margin: .only(bottom: appH(12)),
            decoration: BoxDecoration(
              border: .all(color: AppColors.greyScale.grey200),
              borderRadius: .circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: AppColors.transparent,
                highlightColor: AppColors.transparent,
              ),
              child: ListTile(
                onTap: onTap,
                contentPadding: .zero,
                title: Text(
                  maxLines: 1,
                  overflow: .ellipsis,
                  'Statistik ko‘rsatkichlar va ularning turlari',
                  style: AppTextStyles.source.medium(fontSize: 15),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      IconlyLight.time_circle,
                      size: 20,
                      color: AppColors.greyScale.grey600,
                    ),
                    Text(
                      ' 37 daqiqa',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: .all(3),
                  decoration: BoxDecoration(
                    border: .all(color: AppColors.greyScale.grey200),
                    shape: .circle,
                  ),
                  child: Icon(
                    index != 0 ? Icons.lock_outline : Icons.play_arrow,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
