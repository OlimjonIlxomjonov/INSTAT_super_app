import 'package:flutter/material.dart';
import 'package:my_template/core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/empty_state_static_text.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/user_requests_with_bloc/user_requests_with_bloc_wg.dart';
import '../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
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
      // appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
      body: CustomScrollView(
        slivers: [
          //!
          SliverAppBar(
            toolbarHeight: 75,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: SheetDragAreaWg(
              child: DraggableAppBarWg(onProfileTap: onProfileTap),
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
          const UserRequestsWithBlocWg(limit: 3),

          //! User last Actions

          // SliverPadding(
          //   padding: AppPadding.horizontal20x(),
          //   sliver: SliverToBoxAdapter(
          //     child: ExtendSectionSeeAllWg(
          //       title: localization.recentActions,
          //       onTap: () {},
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: EmptyStateStaticText(
          //     message: localization.noRecentActionsAvailable,
          //   ),
          // ),
        ],
      ),
    );
  }
}
