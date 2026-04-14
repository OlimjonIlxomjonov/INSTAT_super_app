import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/detailed_course_info_header_image.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/course_video_brif_tile_wg.dart';

class DetailedUserBoughtCoursesEduPage extends StatefulWidget {
  final CourseEntity data;
  final String categoryName;

  const DetailedUserBoughtCoursesEduPage({
    super.key,
    required this.data,
    required this.categoryName,
  });

  @override
  State<DetailedUserBoughtCoursesEduPage> createState() =>
      _DetailedUserBoughtCoursesEduPageState();
}

class _DetailedUserBoughtCoursesEduPageState
    extends State<DetailedUserBoughtCoursesEduPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CourseLessonTopicsBloc>();
    final state = bloc.state;
    bool shouldFetch = true;

    if (state is CourseLessonTopicsLoaded) {
      if (state.response.data.isNotEmpty) {
        if (state.response.data.first.course == widget.data.id) {
          shouldFetch = false;
        }
      }
    }

    if (shouldFetch) {
      bloc.add(
        CourseLessonTopicsEvent(
          params: CourseCategoryByIdParams(id: widget.data.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DetailedCourseInfoHeaderImage(imagePath: widget.data.thumbnail),
          DetailedCourseInfoHeaderWg(
            data: widget.data,
            categoryName: widget.categoryName,
          ),
          SliverSafeArea(
            sliver: SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: CourseVideoBriefTileWg(courseId: widget.data.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
