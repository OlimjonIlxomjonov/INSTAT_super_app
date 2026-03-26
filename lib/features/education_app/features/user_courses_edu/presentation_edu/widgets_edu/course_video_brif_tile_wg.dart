import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';

class CourseVideoBriefTileWg extends StatelessWidget {
  final VoidCallback onTap;

  const CourseVideoBriefTileWg({super.key, required this.onTap});

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
                  ...List.generate(2, (lessonIndex) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: appH(12)),
                      margin: EdgeInsets.only(bottom: appH(12)),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyScale.grey200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: AppColors.transparent,
                          highlightColor: AppColors.transparent,
                        ),
                        child: ListTile(
                          onTap: onTap,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            'Statistik ko\'rsatkichlar va ularning turlari',
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
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyScale.grey200,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              lessonIndex != 0
                                  ? Icons.lock_outline
                                  : Icons.play_arrow,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
