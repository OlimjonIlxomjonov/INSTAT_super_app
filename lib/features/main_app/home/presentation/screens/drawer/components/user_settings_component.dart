import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/app_language_settings_model_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/notification_settings_edu_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';
import "package:my_template/core/utils/app_utils.dart";
import "package:my_template/core/utils/widgets/app_widgets.dart";
import 'package:my_template/features/onboarding/screens/components/log_in_options_component.dart';

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
          padding: .only(left: 20, top: 20),
          child: AutoSizeText(
            localization.accountInfo,
            style: AppTextStyles.source.medium(fontSize: isMobile ? 16 : 24),
          ),
        ),
        SizedBox(height: appH(5)),
        ProfileSettingsTileWg(
          leadingIcon: IconlyLight.profile,
          title: localization.personalInfo,
          onTap: () {},
        ),
        ProfileSettingsTileWg(
          leadingIcon: IconlyLight.notification,
          title: localization.notifications,
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
          title: localization.appLanguage,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AppLanguageSettingsModelComponent(),
            );
          },
        ),
        ProfileSettingsTileWg(
          leadingIcon: Icons.list_alt,
          title: localization.tickets,
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
          title: localization.frQuestions,
          onTap: () {},
        ),
        ProfileSettingsTileWg(
          leadingIcon: Icons.fingerprint,
          title: localization.bioAuth,
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
          title: localization.leaveAccount,
          trailingIcon: SizedBox.shrink(),
          onTap: () async {
            await TokenStorageServiceImpl().deleteAccessToken();
            AppRoute.open(LogInOptionsPage());
          },
          isLogOut: true,
        ),

        SizedBox(height: 30),
      ],
    );
  }
}
