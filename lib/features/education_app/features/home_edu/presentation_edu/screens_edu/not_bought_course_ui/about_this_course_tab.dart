import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/similar_courses/similar_courses_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/similar_courses/similar_courses_state.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_similar_courses/see_all_similar_courses.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/widgets/course_features_list_state_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AboutThisCourseTab extends StatefulWidget {
  final CourseEntity data;
  final String courseCategory;
  final int total;

  const AboutThisCourseTab({
    super.key,
    required this.data,
    required this.courseCategory,
    required this.total,
  });

  @override
  State<AboutThisCourseTab> createState() => _AboutThisCourseTabState();
}

class _AboutThisCourseTabState extends State<AboutThisCourseTab>
    with AutomaticKeepAliveClientMixin {
  void _openSimilarCourses(BuildContext context) {
    // FamilyNavigation.familyPush(
    //   showHandle: false,
    //   context,
    //   const SeeAllSimilarCourses(),
    // );

    openMiniAppSheetFamily(
      context,
      child: const SeeAllSimilarCourses(),
      showHandler: false,
    );
  }

  void _openCourseDetail(
    BuildContext context,
    CourseEntity course,
    String categoryName,
  ) {
    FamilyNavigation.familyPush(
      context,
      showHandle: false,
      DetailedCourseInfoPage(
        data: course,
        courseCategory: categoryName,
        total: widget.total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.whatYoullLearn,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                  CourseFeaturesList(courseId: widget.data.id),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appW(20)),
          child: ExtendSectionSeeAllWg(
            title: localization.similarCourses,
            onTap: () => _openSimilarCourses(context),
          ),
        ),
        SizedBox(
          height: popularCoursesCardHeight(context),
          child: BlocBuilder<SimilarCoursesBloc, SimilarCoursesState>(
            builder: (context, state) {
              if (state is SimilarCoursesLoaded) {
                final courses = state.listEntity;
                //! If empty
                if (courses.isEmpty) {
                  return Center(
                    child: AppEmptyState(
                      title: "O‘xshash kurslar topilmadi.",
                      subtitle:
                          "Hozircha ushbu mavzuga mos keladigan boshqa kurslar mavjud emas.",
                      illustrationSize: 100,
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: courses.length,
                  itemExtent: 312,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Padding(
                      padding: EdgeInsets.only(right: appW(12)),
                      child: CourseCategoryBuilder(
                        categoryId: course.category,
                        loadingBuilder: (context) => Skeletonizer(
                          enabled: true,
                          child: PopularCoursesCardWg(
                            onTap: () {},
                            data: course,
                            categoryName: '',
                          ),
                        ),
                        //! Data (Similar Courses)
                        builder: (context, categoryName) =>
                            PopularCoursesCardWg(
                              onTap: () => _openCourseDetail(
                                context,
                                course,
                                categoryName,
                              ),
                              data: course,
                              categoryName: categoryName,
                            ),
                      ),
                    );
                  },
                );
              }

              if (state is SimilarCoursesError) return const SizedBox.shrink();

              //! Loading
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: 3,
                itemExtent: 312,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: appW(12)),
                    child: Skeletonizer(
                      enabled: true,
                      child: PopularCoursesCardWg(
                        onTap: () {},
                        data: widget.data,
                        categoryName: widget.courseCategory,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
