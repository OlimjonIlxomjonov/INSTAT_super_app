import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';

class VacancyProfile extends StatefulWidget {
  const VacancyProfile({super.key});

  @override
  State<VacancyProfile> createState() => _VacancyProfileState();
}

class _VacancyProfileState extends State<VacancyProfile> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(
        myTitle: localization.accountInfo,
        showArrow: false,
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          /// SETTINGS
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                ProfileSettingsTileWg(
                  leadingIcon: FlutterRemix.bookmark_line,
                  title: localization.savedItems,
                  onTap: () {},
                ),
                ProfileSettingsTileWg(
                  leadingIcon: FlutterRemix.message_2_line,
                  title: localization.frQuestions,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
