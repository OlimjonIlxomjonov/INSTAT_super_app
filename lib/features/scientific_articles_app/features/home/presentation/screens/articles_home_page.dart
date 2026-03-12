import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/articles_source.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/last_actions_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';

class ArticlesHomePage extends StatelessWidget {
  final VoidCallback onProfileTap;

  const ArticlesHomePage({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// HEADER USER PROFILE (on click leads to profile page)
          MiniAppHomeHeaderWg(onTapLeadToPage: onProfileTap),

          /// global search bar
          SliverAppBar(
            toolbarHeight: 56 + 24,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(),
          ),

          /// AD BANNERS
          SliverToBoxAdapter(
            child: Container(
              margin: AppPadding.hAndV20x20(),
              width: double.infinity,
              height: 200,
              color: AppColors.greyScale.grey400,
              child: Center(child: Text('BANNER')),
            ),
          ),

          /// BRIEF CARD SECTIONS
          SliverBriefCardsWg(items: briefInfoCardList),

          /// SEE ALL ARTICLES
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(title: 'Maqolalar', onTap: () {}),
            ),
          ),

          /// ARTICLES
          SliverArticlesListWg(items: dummyArticles),

          /// SEE ALL LAST ACTIONS
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: 'Ohirgi harakatlar',
                onTap: () {},
              ),
            ),
          ),

          /// LAST ACTIONS
          SliverLastActionsWg(items: lastActions),
        ],
      ),
    );
  }
}
