import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/watch_course_edu_video_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CourseTopicLessonsListWg extends StatefulWidget {
  final int courseId;
  final int blockId;
  final int lessonCount;

  const CourseTopicLessonsListWg({
    super.key,
    required this.courseId,
    required this.blockId,
    required this.lessonCount,
  });

  @override
  State<CourseTopicLessonsListWg> createState() =>
      _CourseTopicLessonsListWgState();
}

class _CourseTopicLessonsListWgState extends State<CourseTopicLessonsListWg> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CourseLessonItemsBloc>();
    if (!bloc.state.loadedBlocks.containsKey(widget.blockId) &&
        !bloc.state.loadingBlocks.contains(widget.blockId)) {
      bloc.add(
        CourseLessonItemsEvent(
          params: CourseLessonItemsParams(
            courseId: widget.courseId,
            blockId: widget.blockId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseLessonItemsBloc, CourseLessonItemsState>(
      builder: (context, state) {
        final isLoading = state.loadingBlocks.contains(widget.blockId);
        final hasError = state.errorBlocks.containsKey(widget.blockId);
        final loadedResponse = state.loadedBlocks[widget.blockId];

        if (isLoading) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(2, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: appH(12)),
                  margin: EdgeInsets.only(bottom: appH(12)),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyScale.grey200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Loading actual topic right now...',
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
                          ' 32 daqiqa',
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
                        border: Border.all(color: AppColors.greyScale.grey200),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }

        if (loadedResponse != null) {
          final lessons = loadedResponse.data;
          if (lessons.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(bottom: appH(12)),
              child: Text(
                'Hali darslar topilmadi.',
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey500,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(lessons.length, (lessonIndex) {
              final lesson = lessons[lessonIndex];
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
                    onTap: () => FamilyNavigation.familyPush(
                      showHandle: false,
                      context,
                      WatchCourseEduVideoPage(
                        imagePath: lesson.thumbnail,
                        title: lesson.title,
                        courseId: widget.courseId,
                        topicId: widget.blockId,
                        lessonId: lesson.id,
                        testCount: lesson.testsCount,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      lesson.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                          ' ${formatDuration(lesson.duration)}',
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
                        border: Border.all(color: AppColors.greyScale.grey200),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        lesson.status == 'ready' && lesson.isActive
                            ? Icons.play_arrow
                            : Icons.lock_outline,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }

        if (hasError) {
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
