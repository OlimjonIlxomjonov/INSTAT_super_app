import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/user_articles_with_bloc/user_articles_with_bloc_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_stats/article_stats_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_stats/article_stats_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_process/review_process_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_process/review_process_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

import '../../../../../../core/common/ui_states/app_empty_state.dart';
import '../../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import '../widgets/last_actions/sliver_last_actions_wg.dart';

class ArticlesHomePage extends StatefulWidget {
  final VoidCallback onProfileTap, toArticlesPage;

  const ArticlesHomePage({
    super.key,
    required this.onProfileTap,
    required this.toArticlesPage,
  });

  @override
  State<ArticlesHomePage> createState() => _ArticlesHomePageState();
}

class _ArticlesHomePageState extends State<ArticlesHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewProcessBloc>().add(
      ReviewProcessEvent(params: ReviewProcessParams(processType: 'reviews')),
    );
    context.read<ArticleStatsBloc>().add(
      ArticleStatsEvent(countType: 'reviews'),
    );
  }

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
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<UserArticlesBloc>().add(
            UserArticlesEvent(status: 'all', search: ''),
          );
          context.read<ArticleStatsBloc>().add(
            ArticleStatsEvent(countType: 'reviews'),
          );
        },
        child: CustomScrollView(
          slivers: [
            //! AppBar
            SliverAppBar(
              // toolbarHeight: 75,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: DraggableAppBarWg(onProfileTap: widget.onProfileTap),
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
            BlocBuilder<ArticleStatsBloc, ArticleStatsState>(
              builder: (context, state) {
                final isLoading = state is! ArticleStatsLoaded;
                return SliverBriefCardsWg(
                  items: getBriefInfoCardList(localization),
                  entity: state is ArticleStatsLoaded ? state.entity : null,
                  isLoading: isLoading,
                );
              },
            ),

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

            /// ARTICLES
            UserArticlesWithBlocWg(limit: 2),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            /// LAST ACTIONS
            BlocBuilder<ReviewProcessBloc, ReviewProcessState>(
              builder: (context, state) {
                if (state is ReviewProcessLoaded) {
                  if (state.listEntity.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppEmptyState(
                        title: 'Navbat bo‘sh',
                        subtitle:
                            'Jarayonni boshlash uchun birinchi arizangizni yuboring.',
                      ),
                    );
                  }
                  return SliverLastActionsWg(items: state.listEntity, limit: 3);
                }
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            // SliverLastActionsWg(items: lastActions),
          ],
        ),
      ),
    );
  }
}
