import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_tile_videos_shimmer.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/course_topic_lessons_list_wg.dart';

class CourseVideoBriefTileWg extends StatelessWidget {
  const CourseVideoBriefTileWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;

    return BlocBuilder<CourseLessonTopicsBloc, CourseLessonTopicsState>(
      builder: (context, state) {
        if (state is CourseLessonTopicsLoaded) {
          final data = state.response.data;
          return SliverList.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayText(localeCode),
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  CourseTopicLessonsListWg(
                    key: ValueKey(item.id),
                    courseId: item.course,
                    blockId: item.id,
                    lessonCount: item.lessonsCount,
                  ),
                ],
              );
            },
          );
        }
        if (state is CourseLessonTopicsLoading ||
            state is CourseLessonTopicsInitial) {
          return const SliverToBoxAdapter(child: CourseTileVideosShimmer());
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
