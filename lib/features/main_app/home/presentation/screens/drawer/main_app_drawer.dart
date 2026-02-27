import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/app_language_settings_model_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/notification_settings_edu_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';

class MainAppDrawer extends StatefulWidget {
  const MainAppDrawer({super.key});

  @override
  State<MainAppDrawer> createState() => _MainAppDrawerState();
}

class _MainAppDrawerState extends State<MainAppDrawer> {
  bool biometrickSwitchState = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: double.infinity,
      shape: RoundedRectangleBorder(),
      child: CustomScrollView(
        slivers: [
          /// HEADER
          // SliverDefaultAppBarWg(),

          /// USER AVATAR
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .center,
              children: [
                SizedBox(height: appH(15)),
                CircleAvatar(
                  radius: 75,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyScale.grey600,
                    size: 90,
                  ),
                ),
                SizedBox(height: appH(15)),
                Text(
                  'Afzal Pulatov',
                  style: AppTextStyles.source.medium(fontSize: 24),
                ),
                SizedBox(height: appH(8)),
                Container(
                  padding: .all(4),
                  decoration: BoxDecoration(
                    color: AppColors.orange50,
                    borderRadius: .circular(6),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(IconlyLight.danger, color: AppColors.orange500),
                      Text(
                        'Shaxsingizni tasdiqlang',
                        style: AppTextStyles.source.medium(
                          fontSize: 13,
                          color: AppColors.orange500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
                SizedBox(height: appH(5)),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.profile,
                  title: 'Shaxsiy ma’lumotlar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.notification,
                  title: 'Bildirishnomalar',
                  onTap: () {
                    openMiniAppSheet(
                      context,
                      child: NotificationSettingsEduComponent(),
                    );
                  },
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.language,
                  title: 'Ilova tili',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AppLanguageSettingsModelComponent(),
                    );
                  },
                ),

                /// BOSHQALAR
                // Padding(
                //   padding: .only(left: appW(20), top: appH(20)),
                //   child: Text(
                //     'Boshqalar',
                //     style: AppTextStyles.source.medium(fontSize: 18),
                //   ),
                // ),
                // ProfileSettingsTileWg(
                //   leadingIcon: IconlyLight.document,
                //   title: 'Sertificatlar',
                //   onTap: () {
                //     openMiniAppSheet(
                //       context,
                //       child: SertificatsSettingsComponent(),
                //     );
                //   },
                // ),
                // ProfileSettingsTileWg(
                //   leadingIcon: IconlyLight.heart,
                //   title: 'Saqlanganlar',
                //   onTap: () {
                //     openMiniAppSheet(
                //       context,
                //       child: FavouriteCourseSettingsComponent(),
                //     );
                //   },
                // ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.list_alt,
                  title: 'Tikketlar',
                  onTap: () {
                    openMiniAppSheet(
                      context,
                      child: EduTicketsSettingsComponent(),
                    );
                  },
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.message_outlined,
                  title: 'Ko’p beriladigan savollar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.fingerprint,
                  title: 'Biometrik autentifikatsiyalar',
                  trailingIcon: DotSwitch(
                    value: biometrickSwitchState,
                    onChanged: (bool newSwitchState) {
                      setState(() {
                        biometrickSwitchState = newSwitchState;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.logout,
                  title: 'Akkauntdan chiqish',
                  trailingIcon: SizedBox.shrink(),
                  onTap: () {},
                  isLogOut: true,
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
