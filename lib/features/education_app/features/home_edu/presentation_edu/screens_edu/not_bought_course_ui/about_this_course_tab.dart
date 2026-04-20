import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_similar_courses/see_all_similar_courses.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/widgets/course_features_list_state_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

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
    FamilyNavigation.familyPush(
      showHandle: false,
      context,
      const SeeAllSimilarCourses(),
    );
  }

  void _openCourseDetail(BuildContext context) {
    FamilyNavigation.familyPush(
      context,
      // showHandle: false,
      DetailedCourseInfoPage(
        data: widget.data,
        courseCategory: widget.courseCategory,
        total: widget.total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
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
                    "Nimalarni o'rganasiz!",
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
            title: "O'xshash kurslar",
            onTap: () => _openSimilarCourses(context),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: appW(20)),
            itemCount: widget.total,
            itemExtent: appW(312),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: appW(12)),
                child: PopularCoursesCardWg(
                  onTap: () => _openCourseDetail(context),
                  data: widget.data,
                  categoryName: widget.courseCategory,
                ),
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
