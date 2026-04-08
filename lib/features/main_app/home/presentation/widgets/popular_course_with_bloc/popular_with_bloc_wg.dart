import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';

class PopularWithBlocWg extends StatelessWidget {
  const PopularWithBlocWg({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appH(280),
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoaded) {
            final data = state.response.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: AppPadding.horizontal20x(),
              itemCount: data.length,
              cacheExtent: appW(300),
              itemExtent: appW(312),
              itemBuilder: (context, index) {
                final item = data[index];
                return Padding(
                  padding: EdgeInsets.only(right: appW(12)),
                  child: CourseCategoryBuilder(
                    categoryId: item.category,
                    loadingBuilder: (context) => const SizedBox.shrink(),
                    builder: (context, categoryName) {
                      return PopularCoursesCardWg(
                        onTap: () {
                          FamilyNavigation.familyPush(
                            context,
                            DetailedCourseInfoPage(
                              total: state.response.meta.total,
                              data: item,
                              courseCategory: categoryName,
                            ),
                            showHandle: false,
                          );
                        },
                        data: item,
                        categoryName: categoryName,
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is CoursesLoading) {
            return Padding(
              padding: AppPadding.horizontal20x(),
              child: SkeletonExpandedCourseCard(),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
