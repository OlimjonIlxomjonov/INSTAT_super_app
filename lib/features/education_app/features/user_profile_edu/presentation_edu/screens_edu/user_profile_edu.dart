import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/favourite_course_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/sertificats_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/user_groupes/user_groupers_component.dart';

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
    return Scaffold(
      appBar: CustomAppBarWg(
        myTitle: 'Akkaunt ma’lumotlari',
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
                  leadingIcon: IconlyLight.document,
                  title: 'Sertificatlar',
                  onTap: _openSertificatComponent,
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.heart,
                  title: 'Saqlanganlar',
                  onTap: _openFavouriteComponent,
                ),
                ProfileSettingsTileWg(
                  leadingIcon: IconlyLight.info_square,
                  title: 'Ko’p beriladigan savollar',
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
