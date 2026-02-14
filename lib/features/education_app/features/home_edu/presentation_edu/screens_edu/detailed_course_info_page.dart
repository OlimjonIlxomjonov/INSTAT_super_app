import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/about_this_course_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_comments_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_plan_tab.dart';

class DetailedCourseInfoPage extends StatelessWidget {
  const DetailedCourseInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const DetailedCourseInfoHeaderWg(),
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(appH(90)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: CustomTabBarWg(
                    firstTab: "Kurs haqida",
                    secondTab: "O’quv reja",
                    thirdTab: "Izohlar",
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: const [
              AboutThisCourseTab(),
              CoursePlanTab(),
              CourseCommentsTab(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavContainerWg(
          onTap: () {},
          buttonText: 'Sotib olish - 800 000 UZS',
        ),
      ),
    );
  }
}
