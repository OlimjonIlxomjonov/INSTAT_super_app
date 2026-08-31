import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/user_requests_with_bloc/user_requests_with_bloc_wg.dart';
import '../../../../../core/common/params/article_params/article_params.dart';
import '../../../../../core/common/ui_states/app_empty_state.dart';
import '../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import '../../../../scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import '../../../../scientific_articles_app/features/home/presentation/bloc/article_stats/article_stats_bloc.dart';
import '../../../../scientific_articles_app/features/home/presentation/bloc/article_stats/article_stats_state.dart';
import '../../../../scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import '../../../../scientific_articles_app/features/home/presentation/bloc/review_process/review_process_bloc.dart';
import '../../../../scientific_articles_app/features/home/presentation/bloc/review_process/review_process_state.dart';
import '../../../../scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';
import '../../../../scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';

class MicroDataHomePage extends StatefulWidget {
  final VoidCallback onProfileTap, onSeeAllRequests;

  const MicroDataHomePage({
    super.key,
    required this.onProfileTap,
    required this.onSeeAllRequests,
  });

  @override
  State<MicroDataHomePage> createState() => _MicroDataHomePageState();
}

class _MicroDataHomePageState extends State<MicroDataHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewProcessBloc>().add(
      ReviewProcessEvent(
        params: ReviewProcessParams(processType: 'data-requests'),
      ),
    );
    context.read<ArticleStatsBloc>().add(
      ArticleStatsEvent(countType: 'data-requests'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<ReviewProcessBloc>().add(
          ReviewProcessEvent(
            params: ReviewProcessParams(processType: 'data-requests'),
          ),
        );
        context.read<ArticleStatsBloc>().add(
          ArticleStatsEvent(countType: 'data-requests'),
        );
      },
      child: Scaffold(
        // appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
        body: CustomScrollView(
          slivers: [
            //!
            SliverAppBar(
              toolbarHeight: 75,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: DraggableAppBarWg(onProfileTap: widget.onProfileTap),
              ),
            ),

            //! SEARCH BAR
            SliverAppBar(
              toolbarHeight: 80,
              // floating: true,
              // snap: true,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: AppSearchbarWg(onTap: () {}),
            ),
            //! Placeholder TEMP Banner
            SliverToBoxAdapter(child: PromoBannersCarouselWg()),
            //! Brief card lists
            BlocBuilder<ArticleStatsBloc, ArticleStatsState>(
              builder: (context, state) {
                final isLoading = state is! ArticleStatsLoaded;
                return SliverBriefCardsWg(
                  items: getMicroDataBrief(localization),
                  entity: state is ArticleStatsLoaded ? state.entity : null,
                  isLoading: isLoading,
                );
              },
            ),
            //! User requests
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: ExtendSectionSeeAllWg(
                  title: localization.myRequests,
                  onTap: widget.onSeeAllRequests,
                ),
              ),
            ),
            const UserRequestsWithBlocWg(limit: 3),

            /// LAST ACTIONS
            BlocBuilder<ReviewProcessBloc, ReviewProcessState>(
              builder: (context, state) {
                if (state is ReviewProcessLoaded) {
                  //! Empty State
                  if (state.listEntity.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ExtendSectionSeeAllWg(
                              title: localization.recentActions,
                              onTap: () {},
                            ),
                          ),
                          AppEmptyState(
                            title: 'Navbat bo‘sh',
                            subtitle:
                                'Jarayonni boshlash uchun birinchi arizangizni yuboring.',
                          ),
                        ],
                      ),
                    );
                  }
                  //! Data
                  return SliverLastActionsWg(items: state.listEntity, limit: 3);
                }
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
