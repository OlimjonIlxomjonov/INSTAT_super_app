import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';

class ArticlesProfilePage extends StatelessWidget {
  const ArticlesProfilePage({super.key});

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
              title: 'Mening maqolalarim',
              onTap: () {},
              leadingIcon: IconlyLight.document,
            ),
          ),
        ],
      ),
    );
  }
}
