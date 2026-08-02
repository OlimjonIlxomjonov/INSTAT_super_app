import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/user_articles_with_bloc/user_articles_with_bloc_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/last_actions_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

import '../../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';

class ArticlesHomePage extends StatelessWidget {
  final VoidCallback onProfileTap, toArticlesPage;

  const ArticlesHomePage({
    super.key,
    required this.onProfileTap,
    required this.toArticlesPage,
  });

  void _openUserArticlesPage(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      enableDrag: true,
      context,
      child: const UserArticlesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      /// HEADER USER PROFILE (on click leads to profile page)
      // appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<UserArticlesBloc>().add(
            UserArticlesEvent(status: 'all', search: ''),
          );
        },
        child: CustomScrollView(
          slivers: [
            //! AppBar
            SliverAppBar(
              toolbarHeight: 75,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: DraggableAppBarWg(onProfileTap: onProfileTap),
              ),
            ),

            /// global search bar
            SliverAppBar(
              toolbarHeight: 80,
              // floating: true,
              // snap: true,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: const AppSearchbarWg(),
            ),

            /// AD BANNERS
            const SliverToBoxAdapter(child: PromoBannersCarouselWg()),

            /// BRIEF CARD SECTIONS
            SliverBriefCardsWg(items: getBriefInfoCardList(localization)),

            /// SEE ALL ARTICLES
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: ExtendSectionSeeAllWg(
                  title: localization.articles,
                  onTap: () => _openUserArticlesPage(context),
                ),
              ),
            ),

            /// ARTICLES - Placed directly as a sliver widget
            UserArticlesWithBlocWg(limit: 2),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            /// SEE ALL LAST ACTIONS
            // SliverPadding(
            //   padding: AppPadding.horizontal20x(),
            //   sliver: SliverToBoxAdapter(
            //     child: ExtendSectionSeeAllWg(
            //       title: 'Ohirgi harakatlar',
            //       onTap: () {},
            //     ),
            //   ),
            // ),

            /// LAST ACTIONS
            // SliverLastActionsWg(items: lastActions),
          ],
        ),
      ),
    );
  }
}
