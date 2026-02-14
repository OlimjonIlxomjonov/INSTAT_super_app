import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';

class RegularTestCoursePage extends StatelessWidget {
  const RegularTestCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// TEST HEADER
          SliverPadding(
            padding: .only(top: appH(20), left: appW(20), right: appW(20)),
            sliver: SliverAppBar(
              floating: true,
              leading: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(8),
                    side: BorderSide(color: AppColors.greyScale.grey200),
                  ),
                ),
                onPressed: () {
                  AppRoute.close();
                },
                icon: Icon(IconlyLight.arrow_left_2, size: 20),
              ),
              centerTitle: true,
              title: LinearProgressIndicator(
                value: 0.3,
                minHeight: 16,
                borderRadius: .circular(35),
                color: AppColors.primaryColor,
              ),
              actions: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(8),
                      side: BorderSide(color: AppColors.greyScale.grey200),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.close();
                  },
                  icon: Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),

          /// QUESTION
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    '1-Savol',
                    style: AppTextStyles.source.medium(fontSize: 22),
                  ),
                  SizedBox(height: appH(16)),
                  Container(
                    padding: .all(24),
                    decoration: BoxDecoration(
                      borderRadius: .circular(16),
                      color: AppColors.greyScale.grey50,
                      border: .all(color: AppColors.greyScale.grey200),
                    ),
                    child: Text(
                      textAlign: .center,
                      'Iqtisodiyot tarmoqlari statistikasi asosan nimani o‘rganadi?',
                      style: AppTextStyles.source.medium(fontSize: 17),
                    ),
                  ),
                  SizedBox(height: appH(20)),
                  ...List.generate(
                    4,
                    (index) => DefaultCustomTileWg(
                      onTap: () {},
                      tileAction: Checkbox(value: false, onChanged: (temp) {}),
                      tileTitle:
                          'Tarmoqlar bo‘yicha ishlab chiqarish hajmi, o‘sish sur’atlari va samaradorlik ko‘rsatkichlarini',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(buttonText: 'Tasdiqlash'),
    );
  }
}
