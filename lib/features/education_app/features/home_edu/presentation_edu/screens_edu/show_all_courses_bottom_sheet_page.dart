import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShowAllCoursesBottomSheetPage extends StatelessWidget {
  const ShowAllCoursesBottomSheetPage({super.key});

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
                    TitleWithLayoutSelectorWg(),
                    Column(
                      children: List.generate(5, (index) {
                        return Skeletonizer(
                          enabled: false,
                          child: ExpandedCoursesCardWg(), // EXPANDED
                          // child: MinimalCoursesCardWg(), // MINIMAL
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
