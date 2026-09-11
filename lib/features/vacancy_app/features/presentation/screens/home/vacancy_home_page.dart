import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/requests/requests_card_wg.dart';
import '../../../../../../core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import '../../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import '../../../../../../core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import '../../../../../scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import '../../../../../scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';
import '../../widgets/vacancies/vacancy_card_wg.dart';

class VacancyHomePage extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSeeAllVacancy;
  final VoidCallback onSeeAllRequests;

  const VacancyHomePage({
    super.key,
    required this.onProfileTap,
    required this.onSeeAllVacancy,
    required this.onSeeAllRequests,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! Just a space
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          //! AppBar
          SliverAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: SheetDragAreaWg(
              child: DraggableAppBarWg(onProfileTap: onProfileTap),
            ),
          ),

          /// global search bar
          SliverAppBar(
            toolbarHeight: 80,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () => {}),
          ),

          /// AD BANNERS
          const SliverToBoxAdapter(child: PromoBannersCarouselWg()),

          //! Vacancy total statistics
          SliverBriefCardsWg(
            items: getVacancyData(localization),
            entity: null,
            isLoading: false,
          ),

          //! See all vacancies
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: localization.vacanciesTitle,
                onTap: onSeeAllVacancy,
              ),
            ),
          ),

          //! Vacancies
          SliverToBoxAdapter(child: VacancyCardWg()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          //! See all Requests
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: localization.myApplications,
                onTap: onSeeAllRequests,
              ),
            ),
          ),
          //! Requests
          SliverToBoxAdapter(child: RequestsCardWg()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
