import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';

class CoursesInProgressComponent extends StatefulWidget {
  final CoursesLayout layout;
  final String state;

  const CoursesInProgressComponent({
    super.key,
    required this.layout,
    required this.state,
  });

  @override
  State<CoursesInProgressComponent> createState() =>
      _CoursesInProgressComponentState();
}

class _CoursesInProgressComponentState extends State<CoursesInProgressComponent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void sheetOpener({required CourseEntity data, required String categoryName}) {
    openMiniAppSheetFamily(
      context,
      child: DetailedUserBoughtCoursesEduPage(
        data: data,
        categoryName: categoryName,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCoursesBloc>().add(
      UserCoursesEvent(params: UserCoursesParams(state: widget.state)),
    );
  }

  Widget _buildList(List<CourseEntity> data) {
    if (widget.layout == CoursesLayout.grid) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: appW(20)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final entity = data[index];
            return CourseCategoryBuilder(
              categoryId: entity.category,
              loadingBuilder: (context) => const SkeletonExpandedCourseCard(),
              builder: (context, categoryName) {
                return ExpandedCoursesCardWg(
                  onTap: () =>
                      sheetOpener(data: entity, categoryName: categoryName),
                  entity: entity,
                  categoryName: categoryName,
                );
              },
            );
          }, childCount: data.length),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: appW(20)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final entity = data[index];
          return CourseCategoryBuilder(
            categoryId: entity.category,
            loadingBuilder: (context) => const SkeletonMinimalCourseCard(),
            builder: (context, categoryName) {
              return MinimalCoursesCardWg(
                onTap: () =>
                    sheetOpener(data: entity, categoryName: categoryName),
                data: entity,
                categoryName: categoryName,
              );
            },
          );
        }, childCount: data.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UserCoursesBloc, UserCoursesState>(
      builder: (context, state) {
        if (state is UserCoursesLoaded) {
          final data = state.response.data;

          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyState(message: 'Hech qanday kurs hali tugatilmagan!'),
            );
          }

          return _buildList(data);
        }

        if (state is UserCoursesLoading) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appW(20)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.layout == CoursesLayout.grid
                    ? const SkeletonExpandedCourseCard()
                    : const SkeletonMinimalCourseCard(),
                childCount: 5,
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
