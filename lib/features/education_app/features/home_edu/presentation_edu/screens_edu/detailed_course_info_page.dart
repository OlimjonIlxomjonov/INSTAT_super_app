import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/detailed_course_info_header_image.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/about_this_course_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_comments_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_plan_tab.dart';

class DetailedCourseInfoPage extends StatelessWidget {
  const DetailedCourseInfoPage({super.key});

  void _openPayment(BuildContext context) {
    onlineLibStyleCustomBottomSheetWg(
      context,
      headerTitle: "To'lov turi",
      child: const PaymentOpenBottomSheetWg(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // const DetailedCourseInfoHeaderImage(),
            // const DetailedCourseInfoHeaderWg(),
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(appH(90)),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: CustomTabBarWg(
                    firstTab: "Kurs haqida",
                    secondTab: "O'quv reja",
                    thirdTab: "Izohlar",
                  ),
                ),
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              AboutThisCourseTab(),
              CoursePlanTab(),
              CourseCommentsTab(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavContainerWg(
          onTap: () => _openPayment(context),
          buttonText: 'Sotib olish - 800 000 UZS',
        ),
      ),
    );
  }
}
