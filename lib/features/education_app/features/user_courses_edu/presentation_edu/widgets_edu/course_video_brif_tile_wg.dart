import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/course_topic_lessons_list_wg.dart';

class CourseVideoBriefTileWg extends StatelessWidget {
  const CourseVideoBriefTileWg({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseLessonTopicsBloc, CourseLessonTopicsState>(
      builder: (context, state) {
        if (state is CourseLessonTopicsLoaded) {
          final data = state.response.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(data.length, (index) {
              final item = data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '0${item.text}',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  CourseTopicLessonsListWg(
                    courseId: item.course,
                    blockId: item.id,
                    lessonCount: item.lessonsCount,
                  ),
                  if (index == data.length - 1)
                    Container(
                      padding: const .symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: .all(color: AppColors.greyScale.grey200),
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            'Umumiy test savollari',
                            style: CustomTextStyles.h3,
                          ),
                          Icon(
                            IconlyLight.arrow_right_2,
                            color: AppColors.greyScale.grey400,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          );
        }
        if (state is CourseLessonTopicsLoading ||
            state is CourseLessonTopicsInitial) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(3, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '01. Loading Topic Title...',
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                    SizedBox(height: appH(16)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: appH(12)),
                      margin: EdgeInsets.only(bottom: appH(12)),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyScale.grey200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Loading Lesson Title...',
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
                              ' 10 daqiqa',
                              style: AppTextStyles.source.medium(
                                fontSize: 13,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.greyScale.grey200,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
