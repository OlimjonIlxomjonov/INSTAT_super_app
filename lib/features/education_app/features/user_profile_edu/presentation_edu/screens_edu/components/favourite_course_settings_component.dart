import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Saqlanganlar'),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  TitleWithLayoutSelectorWg(
                    prefsKey: 'another_screen',
                    onChanged: (newLayout) {
                      setState(() {
                        layout = newLayout;
                      });
                    },
                  ),
                  //
                  // layout == CoursesLayout.grid
                  //     ? ExpandedCoursesCardWg(
                  //         onTap: () {
                  //           openMiniAppSheetFamily(
                  //             context,
                  //             showHandler: false,
                  //             child: DetailedCourseInfoPage(),
                  //           );
                  //         },
                  //       )
                  //     : MinimalCoursesCardWg(
                  //         onTap: () {
                  //           openMiniAppSheetFamily(
                  //             context,
                  //             showHandler: false,
                  //             child: DetailedCourseInfoPage(),
                  //           );
                  //         },
                  //       ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
