import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_state.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancy_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/choice_filter_sheet.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancies_with_bloc_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_filter_button_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

import '../../../../../../core/utils/app_utils.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VacanciesBloc>()..add(const FetchVacanciesEvent()),
      child: const _VacanciesView(),
    );
  }
}

class _VacanciesView extends StatefulWidget {
  const _VacanciesView();

  @override
  State<_VacanciesView> createState() => _VacanciesViewState();
}

class _VacanciesViewState extends State<_VacanciesView> {
  String _search = '';
  String? _employmentType;

  void _fetch() {
    context.read<VacanciesBloc>().add(
      FetchVacanciesEvent(
        params: VacancyListParams(
          search: _search,
          employmentType: _employmentType,
        ),
      ),
    );
  }

  Future<void> _openFilter() async {
    final l = AppLocalizations.of(context)!;
    final picked = await showChoiceFilterSheet(
      context,
      title: l.employmentTypeLabel,
      options: [
        for (final type in kEmploymentTypes)
          ChoiceOption(type, employmentTypeLabel(l, type)),
      ],
      selected: _employmentType,
    );
    if (picked == _employmentType) return;
    setState(() => _employmentType = picked);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final hasFilter = _employmentType != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomRefreshIndicator(
        onRefresh: () async => _fetch(),
        child: BlocBuilder<VacanciesBloc, VacanciesState>(
          buildWhen: (prev, curr) {
            final p = prev is VacanciesLoaded ? prev : null;
            final c = curr is VacanciesLoaded ? curr : null;
            return p?.hasMore != c?.hasMore ||
                p?.isLoadingMore != c?.isLoadingMore;
          },
          builder: (context, state) {
            final loaded = state is VacanciesLoaded ? state : null;

            return LoadMoreOnScroll(
              canLoadMore:
                  (loaded?.hasMore ?? false) &&
                  !(loaded?.isLoadingMore ?? false),
              onLoadMore: () => context.read<VacanciesBloc>().add(
                const LoadMoreVacanciesEvent(),
              ),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  //! App Bar
                  SliverAppBar(
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    title: SheetDragAreaWg(
                      child: CustomAppBarWg(
                        myTitle: localization.vacanciesTitle,
                      ),
                    ),
                  ),

                  //! Search bar
                  SliverAppBar(
                    primary: false,
                    toolbarHeight: 80,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    titleSpacing: 20,
                    title: AppSearchFieldWg(
                      hintText: localization.searchVacanciesHint,
                      onChanged: (value) {
                        _search = value;
                        _fetch();
                      },
                    ),
                  ),

                  //! Filter
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.vacanciesTitle,
                            style: AppTextStyles.source.semiBold(fontSize: 18),
                          ),
                          VacancyFilterButtonWg(
                            activeLabel: hasFilter
                                ? employmentTypeLabel(
                                    localization,
                                    _employmentType,
                                  )
                                : null,
                            onTap: _openFilter,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //! Vacancies
                  VacanciesWithBlocWg(
                    isSearching: _search.isNotEmpty || hasFilter,
                    onRetry: _fetch,
                  ),

                  if (loaded?.isLoadingMore ?? false)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
