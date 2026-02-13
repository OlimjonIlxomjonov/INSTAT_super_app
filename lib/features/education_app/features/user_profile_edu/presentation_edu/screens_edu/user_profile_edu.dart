import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';

class UserProfileEdu extends StatelessWidget {
  const UserProfileEdu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// HEADER
          SliverDefaultAppBarWg(),

          /// USER AVATAR
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .center,
              children: [
                CircleAvatar(radius: 75),
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
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.language,
                  title: 'Ilova tili',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.fingerprint,
                  title: 'Biometrik autentifikatsiyalar',
                  trailingIcon: Switch.adaptive(
                    padding: .zero,
                    value: false,
                    onChanged: (newValue) {},
                  ),
                  onTap: () {},
                ),

                /// BOSHQALAR
                Padding(
                  padding: .only(left: appW(20), top: appH(20)),
                  child: Text(
                    'Boshqalar',
                    style: AppTextStyles.source.medium(fontSize: 18),
                  ),
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.document,
                  title: 'Sertificatlar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.heart,
                  title: 'Saqlanganlar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.list_alt,
                  title: 'Tikketlar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: Icons.message_outlined,
                  title: 'Ko’p beriladigan savollar',
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.logout,
                  title: 'Akkauntdan chiqish',
                  trailingIcon: SizedBox.shrink(),
                  onTap: () {},
                  isLogOut: true,
                ),
                SizedBox(height: appH(30)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
