import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/app_language_settings_model_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/notification_settings_edu_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';
import "package:my_template/core/utils/app_utils.dart";
import "package:my_template/core/utils/widgets/app_widgets.dart";

class UserSettingsComponent extends StatefulWidget {
  const UserSettingsComponent({super.key});

  @override
  State<UserSettingsComponent> createState() => _UserSettingsComponentState();
}

class _UserSettingsComponentState extends State<UserSettingsComponent> {
  bool biometrickSwitchState = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: .start,

      children: [
        Padding(
          padding: .only(left: 20, top: 20),
          child: AutoSizeText(
            'Akkaunt ma’lumotlari',
            style: AppTextStyles.source.medium(fontSize: isMobile ? 16 : 24),
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
            openMiniAppSheetFamily(
              context,
              showHandler: false,
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
            openMiniAppSheetFamily(
              showHandler: false,
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
    );
  }
}
