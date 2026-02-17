import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShowAllCoursesBottomSheetPage extends StatefulWidget {
  const ShowAllCoursesBottomSheetPage({super.key});

  @override
  State<ShowAllCoursesBottomSheetPage> createState() =>
      _ShowAllCoursesBottomSheetPageState();
}

class _ShowAllCoursesBottomSheetPageState
    extends State<ShowAllCoursesBottomSheetPage> {
  CoursesLayout layout = CoursesLayout.grid;

  void goToPage() {
    openMiniAppSheetFamily(context, child: DetailedCourseInfoPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// HEADER OF THE COURSES
          SliverDefaultAppBarWg(myTitle: AppStrings.coursesTitle),

          /// SEARCH BAR
          SliverAppBar(
            primary: false,
            pinned: true,
            automaticallyImplyLeading: false,
            title: AppSearchbarWg(),
            toolbarHeight: appH(80),
          ),

          /// CATEGORIES
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

          /// COURSES
          SliverSafeArea(
            sliver: SliverPadding(
              padding: .symmetric(horizontal: appW(20)),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    TitleWithLayoutSelectorWg(
                      onChanged: (v) => setState(() => layout = v),
                      layout: layout,
                    ),
                    Column(
                      children: List.generate(5, (index) {
                        return Skeletonizer(
                          enabled: false,
                          child: layout == CoursesLayout.grid
                              ? ExpandedCoursesCardWg(onTap: goToPage)
                              : MinimalCoursesCardWg(onTap: goToPage),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
