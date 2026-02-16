import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';

class FavouriteCourseSettingsComponent extends StatefulWidget {
  const FavouriteCourseSettingsComponent({super.key});

  @override
  State<FavouriteCourseSettingsComponent> createState() =>
      _FavouriteCourseSettingsComponentState();
}

class _FavouriteCourseSettingsComponentState
    extends State<FavouriteCourseSettingsComponent> {
  CoursesLayout layout = CoursesLayout.grid;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverDefaultAppBarWg(myTitle: 'Saqlanganlar'),
        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                TitleWithLayoutSelectorWg(
                  layout: layout,
                  onChanged: (newLayout) {
                    setState(() {
                      layout = newLayout;
                    });
                  },
                ),

                layout == CoursesLayout.grid
                    ? ExpandedCoursesCardWg(
                        onTap: () {
                          openMiniAppSheet(
                            context,
                            child: DetailedCourseInfoPage(),
                          );
                        },
                      )
                    : MinimalCoursesCardWg(
                        onTap: () {
                          openMiniAppSheet(
                            context,
                            child: DetailedCourseInfoPage(),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
