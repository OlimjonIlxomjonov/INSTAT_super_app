import 'package:flutter/material.dart';
import 'package:my_template/core/common/placeholder/banner_placeholder.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/empty_state_static_text.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import '../../../../scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import '../../../../scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';

class MicroDataHomePage extends StatelessWidget {
  final VoidCallback onProfileTap, onSeeAllRequests;

  const MicroDataHomePage({
    super.key,
    required this.onProfileTap,
    required this.onSeeAllRequests,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
      body: CustomScrollView(
        slivers: [
          //! SEARCH BAR
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () {}),
          ),
          //! Placeholder TEMP Banner
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(child: BannerPlaceholder()),
          ),
          //! Brief card lists
          SliverBriefCardsWg(items: getMicroDataBrief(localization)),
          //! User requests
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: localization.myRequests,
                onTap: onSeeAllRequests,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: EmptyStateStaticText(
              message: localization.noRequestsAvailable,
            ),
          ),

          //! User last Actions
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: localization.recentActions,
                onTap: () {},
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: EmptyStateStaticText(
              message: localization.noRecentActionsAvailable,
            ),
          ),
        ],
      ),
    );
  }
}
