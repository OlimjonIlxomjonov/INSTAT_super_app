import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/favourite_course_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/sertificats_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/user_groupes/user_groupers_component.dart';

class UserProfileEdu extends StatefulWidget {
  const UserProfileEdu({super.key});

  @override
  State<UserProfileEdu> createState() => _UserProfileEduState();
}

class _UserProfileEduState extends State<UserProfileEdu> {
  bool biometrickSwitchState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// SETTINGS
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: .only(left: appW(20), top: appH(20)),
                  child: Text(
                    'Akkaunt ma’lumotlari',
                    style: AppTextStyles.source.medium(fontSize: 18),
                  ),
                ),
                SizedBox(height: 5),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.document,
                  title: 'Sertificatlar',
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      child: SertificatsSettingsComponent(),
                    );
                  },
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.heart,
                  title: 'Saqlanganlar',
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      child: FavouriteCourseSettingsComponent(),
                    );
                  },
                ),

                ProfileSettingsTileWg(
                  leadingIcon: Icons.message_outlined,
                  title: 'Ko’p beriladigan savollar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.user,
                  title: 'Guruhlarim',
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      child: UserGroupersComponent(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
