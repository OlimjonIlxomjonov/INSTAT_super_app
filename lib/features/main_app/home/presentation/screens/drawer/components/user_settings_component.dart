import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/app_language_settings_model_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/notification_settings_edu_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';
import "package:my_template/core/utils/app_utils.dart";
import "package:my_template/core/utils/widgets/app_widgets.dart";
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/active_devices_component.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/log_out_options_component.dart';

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
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: .only(left: 20),
          child: AutoSizeText(
            localization.accountInfo,
            style: AppTextStyles.source.medium(fontSize: isMobile ? 16 : 24),
          ),
        ),
        SizedBox(height: appH(5)),
        //! User Profile
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.user_line,
          title: localization.personalInfo,
          onTap: () {},
        ),
        //! Settings
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.notification_line,
          title: localization.notifications,
          onTap: () {
            openMiniAppSheetFamily(
              context,
              showHandler: false,
              child: NotificationSettingsEduComponent(),
            );
          },
        ),
        //! Language
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.earth_line,
          title: localization.appLanguage,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AppLanguageSettingsModelComponent(),
            );
          },
        ),
        //! Tickets
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.message_2_line,
          title: localization.tickets,
          onTap: () {
            openMiniAppSheetFamily(
              showHandler: false,
              context,
              child: EduTicketsSettingsComponent(),
            );
          },
        ),
        //! FAQ
        ProfileSettingsTileWg(
          leadingIcon: IconlyLight.info_square,
          title: localization.frQuestions,
          onTap: () {},
        ),

        //! Active devices
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.device_line,
          title: 'Aktiv qurilmalar',
          onTap: () {
            openMiniAppSheetFamily(
              context,
              child: ActiveDevicesComponent(),
              showHandler: false,
            );
          },
        ),
        //! Log out
        ProfileSettingsTileWg(
          leadingIcon: FlutterRemix.logout_box_r_line,
          title: localization.leaveAccount,
          trailingIcon: SizedBox.shrink(),
          onTap: () async {
            subBottomSheetOpener(
              context,
              child: LogOutOptionsComponent(),
              isExpanded: false,
            );
          },
          isLogOut: true,
        ),

        SizedBox(height: 30),
      ],
    );
  }
}
