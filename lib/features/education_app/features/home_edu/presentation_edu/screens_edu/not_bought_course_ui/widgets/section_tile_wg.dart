import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/widgets/lesson_item_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_entity.dart';

class SectionTile extends StatelessWidget {
  final int index;
  final bool isLast;
  final CourseLessonTopicsEntity entity;

  const SectionTile({
    super.key,
    required this.index,
    required this.isLast,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            entity.text,
            style: AppTextStyles.source.regular(fontSize: 14),
          ),
          initiallyExpanded: index == 0,
          tilePadding: EdgeInsets.only(
            top: appH(5),
            bottom: appH(5),
            left: appW(10),
          ),
          children: [
            Divider(color: AppColors.greyScale.grey200, height: 1),
            LessonItem(courseId: entity.course, blockId: entity.id),
          ],
        ),
        if (!isLast) Divider(color: AppColors.greyScale.grey200, height: 1),
      ],
    );
  }
}
