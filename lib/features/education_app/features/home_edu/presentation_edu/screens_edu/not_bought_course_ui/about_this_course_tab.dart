import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_similar_courses/see_all_similar_courses.dart';

class AboutThisCourseTab extends StatelessWidget {
  const AboutThisCourseTab({super.key});

  static const List<Widget> _studyItems = [
    _StudyItem(),
    _StudyItem(),
    _StudyItem(),
  ];

  void _openSimilarCourses(BuildContext context) {
    FamilyNavigation.familyPush(context, const SeeAllSimilarCourses());
  }

  void _openCourseDetail(BuildContext context) {
    FamilyNavigation.familyPush(context, const DetailedCourseInfoPage());
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
                    ..._studyItems,
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
              itemCount: 3,
              itemExtent: appW(312),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: appW(12)),
                  child: PopularCoursesCardWg(
                    onTap: () => _openCourseDetail(context),
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
  const _StudyItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle, color: AppColors.primaryColor),
      title: Text(
        "Iqtisodiyot tarmoqlari bo'yicha asosiy statistik ko'rsatkichlarni tahlil qilish",
        style: AppTextStyles.source.regular(
          fontSize: 14,
          color: AppColors.greyScale.grey500,
        ),
      ),
    );
  }
}
