import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_similar_courses/see_all_similar_courses.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_course_features_state.dart';

class AboutThisCourseTab extends StatelessWidget {
  final CourseEntity data;
  final String courseCategory;
  final int total;

  const AboutThisCourseTab({
    super.key,
    required this.data,
    required this.courseCategory,
    required this.total,
  });

  void _openSimilarCourses(BuildContext context) {
    FamilyNavigation.familyPush(context, const SeeAllSimilarCourses());
  }

  void _openCourseDetail(BuildContext context) {
    FamilyNavigation.familyPush(
      context,
      DetailedCourseInfoPage(
        data: data,
        courseCategory: courseCategory,
        total: total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: appH(16),
              left: appW(20),
              right: appW(20),
            ),
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
                      "Nimalarni o'rganasiz!",
                      style: AppTextStyles.source.medium(fontSize: 16),
                    ),
                    BlocBuilder<
                      AboutCourseFeaturesBloc,
                      AboutCourseFeaturesState
                    >(
                      builder: (context, state) {
                        if (state is AboutCourseFeaturesLoaded) {
                          final data = state.response.data;
                          return Column(
                            children: List.generate(data.length, (index) {
                              final item = data[index];
                              return _StudyItem(item.text);
                            }),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: appW(20)),
          sliver: SliverToBoxAdapter(
            child: ExtendSectionSeeAllWg(
              title: "O'xshash kurslar",
              onTap: () => _openSimilarCourses(context),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: appW(20)),
              itemCount: total,
              itemExtent: appW(312),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: appW(12)),
                  child: PopularCoursesCardWg(
                    onTap: () => _openCourseDetail(context),
                    data: data,
                    categoryName: courseCategory,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyItem extends StatelessWidget {
  final String text;

  const _StudyItem(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle, color: AppColors.primaryColor),
      title: Text(
        text,
        style: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey500,
        ),
      ),
    );
  }
}
