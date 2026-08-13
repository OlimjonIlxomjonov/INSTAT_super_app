import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/favourite_course_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/sertificats_settings_component.dart';

class UserProfileEdu extends StatefulWidget {
  const UserProfileEdu({super.key});

  @override
  State<UserProfileEdu> createState() => _UserProfileEduState();
}

class _UserProfileEduState extends State<UserProfileEdu> {
  void _openSertificatComponent() {
    openMiniAppSheetFamily(
      context,
      showHandler: false,
      child: SertificatsSettingsComponent(),
    );
  }

  void _openFavouriteComponent() {
    openMiniAppSheetFamily(context, child: FavouriteCourseSettingsComponent());
  }

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
                  leadingIcon: FlutterRemix.file_3_line,
                  title: localization.certificates,
                  onTap: _openSertificatComponent,
                ),
                ProfileSettingsTileWg(
                  leadingIcon: FlutterRemix.heart_line,
                  title: localization.savedItems,
                  onTap: _openFavouriteComponent,
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
