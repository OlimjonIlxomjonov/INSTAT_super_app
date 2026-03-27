import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/regular_test/regular_test_course_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/lesson_item_wg.dart';

class WatchCourseEduVideoPage extends StatelessWidget {
  final CourseLessonItemsEntity data;

  const WatchCourseEduVideoPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            collapsedHeight: 320,
            pinned: true,

            /// VIDEO
            flexibleSpace: FlexibleSpaceBar(
              background: RepaintBoundary(
                child: Image.network(data.thumbnail ?? '', fit: .cover),
              ),
            ),
            leading: Padding(
              padding: .only(left: 10, top: 10),
              child: IconButton(
                onPressed: () {
                  FamilyNavigation.familyClose(context); // main
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                ),
                icon: const Icon(IconlyLight.arrow_left_2, size: 20),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: .only(
                    topLeft: .circular(32),
                    topRight: .circular(32),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyles.source.medium(fontSize: 20),
                  ),
                  SizedBox(height: appH(20)),
                  Text(
                    'Videolar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                ],
              ),
            ),
          ),

          /// available videos in the current course
          SliverList.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return LessonItemWg();
            },
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  /// available files in the current course
                  SizedBox(height: appH(10)),
                  Text(
                    'Fayllar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  DefaultCustomTileWg(
                    tileMaxLines: 1,
                    tileOverflow: .ellipsis,
                    tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                    onTap: () {},
                    tileTitle: 'Tahlil, taqqoslash va prognozlash',
                    subTitle: '3.4 MB',
                  ),

                  /// available tests in the current course
                  SizedBox(height: appH(10)),
                  Text(
                    'Test topshiriqlar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  DefaultCustomTileWg(
                    tileMaxLines: 1,
                    tileOverflow: .ellipsis,
                    tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                    onTap: () {
                      openMiniAppSheetFamily(
                        context,
                        showHandler: false,
                        child: RegularTestCoursePage(),
                      );
                    },
                    tileTitle: 'Tahlil, taqqoslash va prognozlash',
                    subTitle: '3.4 MB',
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
