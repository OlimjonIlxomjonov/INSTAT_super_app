import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';

import '../../../../../../core/utils/general_widgets/site_faqs/site_faqs.dart';

class ArticlesProfilePage extends StatelessWidget {
  const ArticlesProfilePage({super.key});

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
              onTap: () {
                openMiniAppSheetFamily(
                  showHandler: false,
                  context,
                  child: SiteFaqsWg(module: 'articles'),
                );
              },
              leadingIcon: FlutterRemix.message_2_line,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSettingsTileWg(
              title: localization.myArticles,
              onTap: () {},
              leadingIcon: FlutterRemix.file_edit_line,
            ),
          ),
        ],
      ),
    );
  }
}
