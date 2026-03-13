import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/detailed_course_info_header_image.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/watch_course_edu_video_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/course_video_brif_tile_wg.dart';

class DetailedUserBoughtCoursesEduPage extends StatelessWidget {
  const DetailedUserBoughtCoursesEduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const DetailedCourseInfoHeaderImage(),
          const DetailedCourseInfoHeaderWg(),
          SliverSafeArea(
            sliver: SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: CourseVideoBriefTileWg(
                  onTap: () {
                    FamilyModalSheet.of(context).pushPage(
                      MiniAppSheetShell(
                        showHandle: false,
                        child: const WatchCourseEduVideoPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
