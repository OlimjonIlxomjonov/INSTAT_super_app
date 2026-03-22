import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/magazine_sources.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/widgets/sliver_magazine_grid_wg.dart';

class MagazinesPage extends StatelessWidget {
  const MagazinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Jurnallar'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(),
          ),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Text('Jurnallar', style: CustomTextStyles.h2),
            ),
          ),

          /// MAGAZINE  CONTENT GRID
          SliverMagazineGridWg(items: dummyMagazineGrid),
        ],
      ),
    );
  }
}
