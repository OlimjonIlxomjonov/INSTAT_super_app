import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class PopularWithBlocWg extends StatelessWidget {
  const PopularWithBlocWg({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final isLandscape = orientation == Orientation.landscape;
    final cardWidth = isLandscape ? appW(180) : 312.0;
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoaded) {
          final data = state.response.data;

          return SizedBox(
            height: popularCoursesCardHeight(context),
            child: LoadMoreOnScroll(
              canLoadMore: state.hasMore && !state.isLoadingMore,
              onLoadMore: () =>
                  context.read<CoursesBloc>().add(LoadMoreCoursesEvent()),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppPadding.horizontal20x(),
                itemCount: data.length + (state.isLoadingMore ? 1 : 0),
                cacheExtent: appW(300),
                itemExtent: cardWidth,
                itemBuilder: (context, index) {
                  if (index >= data.length) {
                    return const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    );
                  }
                  final item = data[index];
                  return Padding(
                    padding: EdgeInsets.only(right: appW(12)),
                    child: CourseCategoryBuilder(
                      categoryId: item.category,
                      loadingBuilder: (context) => const SizedBox.shrink(),
                      builder: (context, categoryName) {
                        return PopularCoursesCardWg(
                          onTap: () {
                            /// open new a family
                            openMiniAppSheetFamily(
                              showHandler: false,
                              context,
                              child: DetailedCourseInfoPage(
                                total: state.response.meta.total,
                                data: item,
                                courseCategory: categoryName,
                              ),
                            );
                          },
                          data: item,
                          categoryName: categoryName,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is CoursesLoading) {
          return Padding(
            padding: AppPadding.horizontal20x(),
            child: SkeletonExpandedCourseCard(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
