import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';

class PopularWithBlocWg extends StatelessWidget {
  const PopularWithBlocWg({super.key});

  double _measureLineHeight(BuildContext context, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: 'Ag', style: style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.height;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoaded) {
          final data = state.response.data;
          final cardWidth = appW(312);

          // Was a SizedBox(height: appH(270)) with card width appW(312) —
          // appW/appH scale width and height by separate ratios (against
          // screen width vs screen height), so on a device whose aspect
          // ratio differs a lot from the reference phone (e.g. an iPad,
          // much closer to square), the two stop matching up and the text
          // overflows. Deriving the height from the card's own real
          // content (like the book carousel elsewhere already does) works
          // on any device. This also keeps the list lazy (ListView.builder)
          // rather than building every card eagerly — building all of them
          // at once was mounting every card's CourseCategoryBuilder
          // (which share one global bloc) in the same frame, causing a
          // rebuild-storm assertion crash.
          final imageHeight = cardWidth / 2; // AspectRatio 12/6 in the card
          final categoryLineHeight = _measureLineHeight(
            context,
            AppTextStyles.source.medium(fontSize: 12),
          );
          final nameLineHeight = _measureLineHeight(
            context,
            AppTextStyles.source.medium(fontSize: 15),
          );
          final metaRowHeight = _measureLineHeight(
            context,
            AppTextStyles.source.regular(fontSize: 13),
          ).clamp(18.0, double.infinity); // row also has 18px icons

          final listHeight =
              imageHeight +
              appH(12) +
              categoryLineHeight +
              appH(4) +
              (nameLineHeight * 2) +
              appH(8) +
              metaRowHeight +
              4; // small rounding buffer

          return SizedBox(
            height: listHeight,
            child: ListView.builder(
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
