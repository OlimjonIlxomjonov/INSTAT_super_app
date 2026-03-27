import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/widgets_edu/home_achivements_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

class HomeEduPage extends StatelessWidget {
  final VoidCallback onTap, onProfileTap;

  const HomeEduPage({
    super.key,
    required this.onTap,
    required this.onProfileTap,
  });

  void _goToPageActiveCourses(BuildContext context) {
    // openMiniAppSheetFamily(
    //   context,
    //   child: const DetailedUserBoughtCoursesEduPage(),
    // );
  }

  void _goToAllCourses(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: const ShowAllCoursesBottomSheetPage(),
    );
  }

  void _goToDetailedCourse(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: const DetailedCourseInfoPage(),
    );
  }

  static const List<Widget> _categories = [
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
      body: CustomScrollView(
        slivers: [
          /// HOME HEADER
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                switch (index) {
                  case 0:
                    return Container(
                      width: double.infinity,
                      height: appH(184),
                      color: AppColors.greyScale.grey400,
                      child: Center(child: Text('plaseholder')),
                    );
                  case 1:
                    return HomeAchievementsWg();
                  case 2:
                    return ExtendSectionSeeAllWg(
                      title: AppStrings.studyingCourses,
                      onTap: onTap,
                    );
                  // case 3:
                  //   return ActiveCoursesWg(
                  //     onTap: () => _goToPageActiveCourses(context),
                  //   );
                  // case 4:
                  //   return ActiveCoursesWg(
                  //     onTap: () => _goToPageActiveCourses(context),
                  //   );
                  default:
                    return const SizedBox.shrink();
                }
              }, childCount: 5),
            ),
          ),

          /// SELECT CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories),
            ),
          ),

          /// All Courses
          // SliverSafeArea(
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate((context, index) {
          //       if (index == 0) {
          //         return Padding(
          //           padding: EdgeInsets.only(
          //             left: appW(20),
          //             right: appW(20),
          //             top: appH(10),
          //           ),
          //           child: ExtendSectionSeeAllWg(
          //             title: AppStrings.allCourses,
          //             onTap: () => _goToAllCourses(context),
          //           ),
          //         );
          //       }
          //       return SizedBox(
          //         height: 300,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           padding: EdgeInsets.symmetric(horizontal: appW(20)),
          //           itemCount: 10,
          //           itemExtent: appW(312),
          //           cacheExtent: appW(300),
          //           itemBuilder: (context, index) {
          //             return Padding(
          //               padding: EdgeInsets.only(right: appW(12)),
          //               child: PopularCoursesCardWg(
          //                 onTap: () => _goToDetailedCourse(context),
          //               ),
          //             );
          //           },
          //         ),
          //       );
          //     }, childCount: 2),
          //   ),
          // ),
        ],
      ),
    );
  }
}
