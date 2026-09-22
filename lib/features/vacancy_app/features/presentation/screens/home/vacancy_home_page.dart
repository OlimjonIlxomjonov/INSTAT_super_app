import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancy_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancies_with_bloc_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_applications_with_bloc_wg.dart';
import '../../../../../../core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import '../../../../../../core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import '../../../../../../core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import '../../../../../scientific_articles_app/dummy_data_source/home_brief_info_card_source.dart';
import '../../../../../scientific_articles_app/features/home/presentation/widgets/sliver_brief_cards_wg.dart';

class VacancyHomePage extends StatefulWidget {
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
  State<VacancyHomePage> createState() => _VacancyHomePageState();
}

class _VacancyHomePageState extends State<VacancyHomePage> {
  @override
  void initState() {
    super.initState();
    if (context.read<VacanciesBloc>().state is VacanciesInitial) {
      context.read<VacanciesBloc>().add(const FetchVacanciesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) =>
          sl<VacancyApplicationsBloc>()
            ..add(const FetchVacancyApplicationsEvent()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //! Just a space
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            //! AppBar
            SliverAppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: DraggableAppBarWg(onProfileTap: widget.onProfileTap),
              ),
            ),

            /// global search bar
            SliverAppBar(
              toolbarHeight: 80,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: AppSearchbarWg(onTap: widget.onSeeAllVacancy),
            ),

            /// AD BANNERS
            const SliverToBoxAdapter(
              child: PromoBannersCarouselWg(
                localAssets: AppImages.vacancyBanners,
              ),
            ),

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
                  onTap: widget.onSeeAllVacancy,
                ),
              ),
            ),

            //! Vacancies
            VacanciesWithBlocWg(
              limit: 3,
              onRetry: () => context.read<VacanciesBloc>().add(
                const FetchVacanciesEvent(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            //! See all Requests
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: ExtendSectionSeeAllWg(
                  title: localization.myApplications,
                  onTap: widget.onSeeAllRequests,
                ),
              ),
            ),
            //! Requests
            const VacancyApplicationsWithBlocWg(limit: 3),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
