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
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

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
  final Map<int, String> _categoryCache = {};

  @override
  bool get wantKeepAlive => true;

  void sheetOpener({required CourseEntity data}) {
    openMiniAppSheetFamily(
      context,
      child: DetailedUserBoughtCoursesEduPage(
        data: data,
        categoryName: _categoryCache[data.category] ?? '',
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

  void _fetchCategories(List<CourseEntity> courses) {
    final uniqueIds = courses.map((c) => c.category).toSet();
    for (final id in uniqueIds) {
      if (!_categoryCache.containsKey(id)) {
        context.read<UserCategoryByIdBloc>().add(
          UserCategoryByIdEvent(params: CourseCategoryByIdParams(id: id)),
        );
      }
    }
  }

  Widget _buildList(List<CourseEntity> data) {
    if (widget.layout == CoursesLayout.grid) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: appW(20)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final entity = data[index];
            return ExpandedCoursesCardWg(
              onTap: () => sheetOpener(data: entity),
              entity: entity,
              categoryName: _categoryCache[entity.category] ?? '',
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
          return MinimalCoursesCardWg(
            onTap: () => sheetOpener(data: entity),
            data: entity,
            categoryName: _categoryCache[entity.category] ?? '',
          );
        }, childCount: data.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<UserCoursesBloc, UserCoursesState>(
      listener: (context, state) {
        if (state is UserCoursesLoaded) {
          _fetchCategories(state.response.data);
        }
      },
      builder: (context, state) {
        if (state is UserCoursesLoaded) {
          final data = state.response.data;

          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyState(message: 'Hech qanday kurs hali tugatilmagan!'),
            );
          }

          return BlocListener<UserCategoryByIdBloc, UserCategoryByIdState>(
            listener: (context, catState) {
              if (catState is UserCategoryByIdLoaded) {
                setState(() {
                  _categoryCache[catState.entity.id] = catState.entity.name;
                });
              }
            },
            child: _buildList(data),
          );
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
