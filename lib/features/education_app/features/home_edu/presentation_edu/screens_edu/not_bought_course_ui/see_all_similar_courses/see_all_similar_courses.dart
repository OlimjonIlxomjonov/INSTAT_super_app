import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';

class SeeAllSimilarCourses extends StatelessWidget {
  const SeeAllSimilarCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'O\'xshash kurslar', isFamily: true),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  AppSearchbarWg(),
                  TitleWithLayoutSelectorWg(
                    prefsKey: 'expanded',
                    onChanged: (v) {},
                  ),
                  // ExpandedCoursesCardWg(
                  //   onTap: () {
                  //     FamilyNavigation.familyPush(
                  //       context,
                  //       DetailedCourseInfoPage(),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
