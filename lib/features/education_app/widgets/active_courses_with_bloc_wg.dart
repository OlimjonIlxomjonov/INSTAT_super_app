import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
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
      padding: AppPadding.horizontal20x(),
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
              return SkeletonMinimalCourseCard();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
