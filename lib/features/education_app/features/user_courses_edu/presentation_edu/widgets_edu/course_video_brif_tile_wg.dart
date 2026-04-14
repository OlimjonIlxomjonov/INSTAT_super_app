import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_tile_videos_shimmer.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/other/final_course_test_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/course_topic_lessons_list_wg.dart';

class CourseVideoBriefTileWg extends StatelessWidget {
  final int courseId;

  const CourseVideoBriefTileWg({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Course Tile Videos (course lessons)
        BlocBuilder<CourseLessonTopicsBloc, CourseLessonTopicsState>(
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

                      /// course lessons
                      CourseTopicLessonsListWg(
                        courseId: item.course,
                        blockId: item.id,
                        lessonCount: item.lessonsCount,
                      ),

                      /// final test page
                      // if (index == data.length - 1)
                      //   FinalCourseTestWg(courseId: item.course),
                    ],
                  );
                }),
              );
            }
            if (state is CourseLessonTopicsLoading ||
                state is CourseLessonTopicsInitial) {
              return CourseTileVideosShimmer();
            }

            return const SizedBox.shrink();
          },
        ),

        /// Course final test
        FinalCourseTestWg(courseId: courseId),
      ],
    );
  }
}
