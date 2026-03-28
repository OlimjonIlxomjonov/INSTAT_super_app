import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/widgets/section_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';

class CoursePlanTab extends StatefulWidget {
  const CoursePlanTab({super.key});

  @override
  State<CoursePlanTab> createState() => _CoursePlanTabState();
}

class _CoursePlanTabState extends State<CoursePlanTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            left: appW(20),
            right: appW(20),
            bottom: appH(20),
          ),
          sliver: SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyScale.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    BlocBuilder<
                      CourseLessonTopicsBloc,
                      CourseLessonTopicsState
                    >(
                      builder: (context, state) {
                        if (state is CourseLessonTopicsLoaded) {
                          final data = state.response.data;
                          return Column(
                            children: List.generate(data.length, (index) {
                              final item = data[index];
                              return SectionTile(
                                index: index,
                                isLast: index == data.length - 1,
                                entity: item,
                              );
                            }),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
