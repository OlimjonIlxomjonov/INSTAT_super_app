import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_achievements_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_info_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_sertificats_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/custom_profile_back.dart';

class TempDetailedUserEdu extends StatelessWidget {
  const TempDetailedUserEdu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Padding(
          padding: AppPadding.horizontal20x(),
          child: Column(
            children: [
              SizedBox(height: 20),
              ProfileHeader(
                background: AssetImage(AppImages.profileBackground),
                avatar: AssetImage(AppImages.profileBackground),
              ),
              SizedBox(height: appH(12)),
              Text(
                'Afzal Pulatov',
                style: AppTextStyles.source.semiBold(fontSize: 22),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Champion',
                    style: AppTextStyles.source.medium(
                      fontSize: 14,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                  const Text(" 🎖️"),
                ],
              ),
              SizedBox(height: appH(20)),

              CustomTabBarWg(
                firstTab: 'Ma’lumotlar',
                secondTab: "Medallar",
                thirdTab: "Sertifikatlar",
              ),

              SizedBox(height: appH(12)),

              Expanded(
                child: TabBarView(
                  children: [
                    UserInfoTab(),
                    UserAchievementsTab(),
                    SingleChildScrollView(child: UserSertificatsTab()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
