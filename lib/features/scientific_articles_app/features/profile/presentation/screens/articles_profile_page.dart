import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';

class ArticlesProfilePage extends StatelessWidget {
  const ArticlesProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: AppPadding.hAndV20x20(),
            child: Text('Akkaunt ma’lumotlari', style: CustomTextStyles.h2),
          ),
          ProfileSettingsTileWg(
            title: 'Saqlanganlar',
            onTap: () {},
            leadingIcon: IconlyLight.heart,
          ),
          ProfileSettingsTileWg(
            title: 'Ko’p beriladigan savollar',
            onTap: () {},
            leadingIcon: Icons.message_outlined,
          ),
          ProfileSettingsTileWg(
            title: 'Mening maqolalarim',
            onTap: () {},
            leadingIcon: IconlyLight.document,
          ),
        ],
      ),
    );
  }
}
