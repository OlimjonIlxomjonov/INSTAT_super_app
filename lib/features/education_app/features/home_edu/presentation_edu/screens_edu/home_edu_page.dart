import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/widgets_edu/status_achievements_card_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

class HomeEduPage extends StatelessWidget {
  const HomeEduPage({super.key});

  @override
  Widget build(BuildContext context) {
    void goToPageActiveCourses() {
      openMiniAppSheetFamily(
        context,
        child: DetailedUserBoughtCoursesEduPage(),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .only(left: appW(20), right: appW(20), top: appH(20)),
            sliver: SliverAppBar(
              automaticallyImplyLeading: true,
              leading: CircleAvatar(
                backgroundColor: AppColors.greyScale.grey300,
              ),
              title: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Hayrli kun! ✌️',
                    style: AppTextStyles.source.regular(fontSize: 14),
                  ),
                  Text(
                    'Afzal Pulatov',
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                ],
              ),
              actions: [Icon(IconlyLight.notification)],
            ),
          ),
          SliverPadding(
            padding: .symmetric(horizontal: appW(20), vertical: appH(10)),
            sliver: SliverAppBar(
              toolbarHeight: appH(56) + appH(24),
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: AppSearchbarWg(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: .symmetric(horizontal: appW(20)),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: appH(184),
                    color: AppColors.greyScale.grey400,
                    child: Center(child: Text('plaseholder')),
                  ),

                  /// EDU USER STATUS / achievements
                  Row(
                    spacing: appW(8),
                    children: [
                      Expanded(
                        child: StatusAchievementsCardWg(descText: 'Darajangiz'),
                      ),
                      Expanded(
                        child: StatusAchievementsCardWg(descText: 'Medalingiz'),
                      ),
                      Expanded(
                        child: StatusAchievementsCardWg(
                          descText: "To’plagan ballingiz",
                        ),
                      ),
                    ],
                  ),

                  /// Active courses
                  ExtendSectionSeeAllWg(
                    title: AppStrings.studyingCourses,
                    onTap: () {},
                  ),
                  ActiveCoursesWg(onTap: goToPageActiveCourses),
                  ActiveCoursesWg(onTap: goToPageActiveCourses),
                ],
              ),
            ),
          ),

          /// SELECT CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return EduCategoriesWg();
                }),
              ),
            ),
          ),

          /// All Courses
          SliverSafeArea(
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: .only(
                      left: appW(20),
                      right: appW(20),
                      top: appH(10),
                    ),
                    child: ExtendSectionSeeAllWg(
                      title: AppStrings.allCourses,
                      onTap: () {
                        openMiniAppSheet(
                          context,
                          child: ShowAllCoursesBottomSheetPage(),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: appH(250),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: appW(20)),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: appW(12)),
                          child: SizedBox(
                            width: appW(300),
                            child: PopularCoursesCardWg(
                              onTap: () {
                                // openMiniAppSheet(
                                //   context,
                                //   child: DetailedCourseInfoPage(),
                                // );
                                // subBottomSheetOpener(
                                //   context,
                                //   child: DetailedCourseInfoPage(),
                                // );

                                openMiniAppSheetFamily(
                                  context,
                                  child: DetailedCourseInfoPage(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
