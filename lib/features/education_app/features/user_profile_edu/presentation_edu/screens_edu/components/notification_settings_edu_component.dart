import 'package:flutter/material.dart';
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
  final List<String> notificationSettings = [
    'Bildirishnomalar',
    'Ovozli bildirishnomalar',
    'Avtomatik yangilash',
  ];

  late final List<bool> switches;

  @override
  void initState() {
    super.initState();
    switches = List<bool>.filled(notificationSettings.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverDefaultAppBarWg(myTitle: 'Bildirishnomalar'),
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
    );
  }
}
