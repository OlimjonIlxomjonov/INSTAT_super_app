import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import '../../../../../core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';

class MicroDataProfile extends StatelessWidget {
  const MicroDataProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(
        myTitle: localization.accountInfo,
        showArrow: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: localization.savedItems,
              onTap: () {},
              leadingIcon: FlutterRemix.heart_line,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: localization.frQuestions,
              onTap: () {},
              leadingIcon: FlutterRemix.message_2_line,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: localization.myRequests,
              onTap: () {},
              leadingIcon: FlutterRemix.clipboard_line,
            ),
          ),
        ],
      ),
    );
  }
}
