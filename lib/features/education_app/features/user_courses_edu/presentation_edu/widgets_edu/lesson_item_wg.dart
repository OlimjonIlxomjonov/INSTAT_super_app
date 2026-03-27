import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_entity.dart';

class LessonItemWg extends StatelessWidget {
  final CourseLessonItemsEntity data;

  const LessonItemWg({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: appH(12)),
      margin: .only(bottom: appH(12), left: 20, right: 20),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        // if active AppColors.greyScale.grey200 else transparent
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
        ),
        child: ListTile(
          onTap: () {},
          contentPadding: .zero,
          leading: Text(
            '01.',
            style: AppTextStyles.source.medium(
              fontSize: 16,
              color: AppColors.greyScale.grey600,
            ),
          ),
          title: Text(
            'Tarmoqlar bo‘yicha statistika asoslari',
            style: AppTextStyles.source.medium(fontSize: 15),
            maxLines: 1,
            overflow: .ellipsis,
          ),
          subtitle: Text(
            '37 daqiqa 16 soniya',
            style: AppTextStyles.source.regular(
              fontSize: 13,
              color: AppColors.greyScale.grey600,
            ),
          ),
          trailing: Container(
            padding: .all(3),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: .all(color: AppColors.greyScale.grey200),
              shape: .circle,
            ),
            child: Icon(
              Icons.play_arrow,
              // if !active Icons.play_arrow else pause
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
