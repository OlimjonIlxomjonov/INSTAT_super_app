import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/regular_test/regular_test_course_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';

class WatchCourseEduVideoPage extends StatelessWidget {
  const WatchCourseEduVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                /// HERE WILL BE A VIDEO PLAYER
                Image.asset(
                  height: appH(320),
                  width: double.infinity,
                  'assets/home_page/temp_course_dummy.png',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: .only(left: appW(10), top: appH(10)),
                  child: IconButton(
                    onPressed: () {
                      AppRoute.close();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    ),
                    icon: Icon(IconlyLight.arrow_left_2, size: 20),
                  ),
                ),
              ],
            ),
          ),

          SliverSafeArea(
            sliver: SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Statistika (Tarmoqlar va sohalar bo’yicha)',
                      style: AppTextStyles.source.medium(fontSize: 20),
                    ),

                    SizedBox(height: appH(20)),
                    Text(
                      'Videolar',
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                    SizedBox(height: appH(16)),

                    /// available videos in the current course
                    ...List.generate(
                      2,
                      (index) => Container(
                        padding: .symmetric(horizontal: appH(12)),
                        margin: .only(bottom: appH(12)),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppColors.greyScale.grey200
                              : AppColors.transparent,
                          border: .all(color: AppColors.greyScale.grey200),
                          borderRadius: .circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: AppColors.transparent,
                            highlightColor: AppColors.transparent,
                          ),
                          child: ListTile(
                            onTap: () {},
                            contentPadding: .zero,
                            leading: Text(
                              '01.',
                              style: AppTextStyles.source.medium(
                                fontSize: 16,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                            title: Text(
                              'Tarmoqlar bo‘yicha statistika asoslari',
                              style: AppTextStyles.source.medium(fontSize: 15),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                            subtitle: Text(
                              '37 daqiqa 16 soniya',
                              style: AppTextStyles.source.regular(
                                fontSize: 13,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                            trailing: Container(
                              padding: .all(3),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: .all(
                                  color: AppColors.greyScale.grey200,
                                ),
                                shape: .circle,
                              ),
                              child: Icon(
                                index != 0 ? Icons.play_arrow : Icons.pause,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

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
                      tileLeading: Icon(IconlyLight.folder),
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
                      tileLeading: Icon(IconlyLight.folder),
                      onTap: () {
                        openMiniAppSheet(
                          context,
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
          ),
        ],
      ),
    );
  }
}
