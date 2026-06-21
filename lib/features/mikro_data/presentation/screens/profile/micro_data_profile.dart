import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import '../../../../../core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';

class MicroDataProfile extends StatelessWidget {
  const MicroDataProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Akkaunt ma’lumotlari', showArrow: false),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: 'Saqlanganlar',
              onTap: () {},
              leadingIcon: IconlyLight.heart,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: 'Ko’p beriladigan savollar',
              onTap: () {},
              leadingIcon: IconlyLight.chat,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: 'Mening so\'rovlarim',
              onTap: () {},
              leadingIcon: IconlyLight.document,
            ),
          ),
        ],
      ),
    );
  }
}
