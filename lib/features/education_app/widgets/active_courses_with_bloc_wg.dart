import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/user_order_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

class ActiveCoursesWithBlocWg extends StatelessWidget {
  final VoidCallback onSeeAll;

  const ActiveCoursesWithBlocWg({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const .only(left: 20, right: 20),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<UserCoursesBloc, UserCoursesState>(
          builder: (context, state) {
            if (state is UserCoursesLoaded) {
              final isNotEmpty = state.response.data.isNotEmpty;
              final data = state.response.data;

              if (data.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  if (isNotEmpty)
                    ExtendSectionSeeAllWg(
                      title: localization.studyingCourses,
                      onTap: () => onSeeAll(),
                    ),
                  Column(
                    children: List.generate(data.length.clamp(0, 2), (index) {
                      final item = data[index];
                      return CourseCategoryBuilder(
                        categoryId: item.category,
                        loadingBuilder: (context) => const SizedBox.shrink(),
                        builder: (context, categoryName) {
                          return ActiveCoursesWg(
                            onTap: () {
                              openMiniAppSheetFamily(
                                showHandler: false,
                                context,
                                child: DetailedUserBoughtCoursesEduPage(
                                  data: item,
                                  categoryName: categoryName,
                                ),
                              );
                            },
                            data: item,
                            categoryName: categoryName,
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            } else if (state is UserCoursesLoading) {
              //! Skeleton
              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: [
                    ExtendSectionSeeAllWg(
                      title: localization.studyingCourses,
                      onTap: () {},
                    ),
                    for (var i = 0; i < 2; i++)
                      ActiveCoursesWg(
                        onTap: () {},
                        data: _skeletonCourse,
                        categoryName: 'Programming',
                      ),
                  ],
                ),
              );
            } else if (state is UserCoursesError) {
              return Column(
                children: [
                  ExtendSectionSeeAllWg(
                    title: localization.studyingCourses,
                    onTap: () => onSeeAll(),
                  ),
                  SectionErrorWg(
                    title: state.message,
                    onRetry: () => context.read<UserCoursesBloc>().add(
                      UserCoursesEvent(
                        params: UserCoursesParams(state: 'in_progress'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

//! Skeleton uchun
final _skeletonCourse = CourseEntity(
  id: 0,
  name: 'Python bilan statistik tahlil',
  price: '0',
  isActive: true,
  thumbnail: '',
  isOnline: true,
  category: 0,
  lessonsCount: 24,
  totalDuration: 0,
  userOrder: UserOrder(
    id: 0,
    status: 'paid',
    currentLesson: 7,
    createdAt: '',
    progress: 0,
    scores: 0,
  ),
);
