import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LessonItem extends StatefulWidget {
  final int courseId;
  final int blockId;

  const LessonItem({super.key, required this.courseId, required this.blockId});

  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
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
            child: ListTile(
              leading: const Icon(Icons.video_collection),
              title: Text(
                AppLocalizations.of(context)!.loadingEllipsis,
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
              tileColor: AppColors.greyScale.grey100,
            ),
          );
        }

        if (loadedResponse != null) {
          final lessons = loadedResponse.data;
          if (lessons.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(bottom: appH(12)),
              child: Text(
                AppLocalizations.of(context)!.noLessonsFoundYet,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey500,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: .start,
            children: List.generate(lessons.length, (index) {
              return ListTile(
                leading: const Icon(Icons.video_collection),
                title: Text(
                  lessons[index].title,
                  style: AppTextStyles.source.regular(fontSize: 13),
                ),
                tileColor: AppColors.greyScale.grey100,
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
