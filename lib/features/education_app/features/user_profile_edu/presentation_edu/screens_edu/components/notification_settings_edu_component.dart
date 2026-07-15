import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';

class NotificationSettingsEduComponent extends StatefulWidget {
  const NotificationSettingsEduComponent({super.key});

  @override
  State<NotificationSettingsEduComponent> createState() =>
      _NotificationSettingsEduComponentState();
}

class _NotificationSettingsEduComponentState
    extends State<NotificationSettingsEduComponent> {
  late final List<bool> switches = List<bool>.filled(3, false);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final notificationSettings = [
      localization.notifications,
      localization.soundNotificationsLabel,
      localization.autoUpdateLabel,
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: localization.notifications),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: notificationSettings.length,
              (context, index) {
                return ProfileSettingsTileWg(
                  title: notificationSettings[index],
                  onTap: () {},
                  trailingIcon: DotSwitch(
                    value: switches[index],
                    onChanged: (bool switchState) {
                      setState(() {
                        switches[index] = switchState;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
