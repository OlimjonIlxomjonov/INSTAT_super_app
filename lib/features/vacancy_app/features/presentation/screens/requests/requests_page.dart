import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_state.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_applications_with_bloc_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/choice_filter_sheet.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_filter_button_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<VacancyApplicationsBloc>()
            ..add(const FetchVacancyApplicationsEvent()),
      child: const _RequestsView(),
    );
  }
}

class _RequestsView extends StatefulWidget {
  const _RequestsView();

  @override
  State<_RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<_RequestsView> {
  String _search = '';
  String? _status;

  void _fetch() {
    context.read<VacancyApplicationsBloc>().add(
      FetchVacancyApplicationsEvent(
        params: VacancyApplicationListParams(search: _search, status: _status),
      ),
    );
  }

  Future<void> _openFilter() async {
    final l = AppLocalizations.of(context)!;
    final picked = await showChoiceFilterSheet(
      context,
      title: l.status,
      options: [
        for (final status in kApplicationStatuses)
          ChoiceOption(status, applicationStatusLabel(l, status)),
      ],
      selected: _status,
    );
    if (picked == _status) return;
    setState(() => _status = picked);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final hasFilter = _status != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomRefreshIndicator(
        onRefresh: () async => _fetch(),
        child: BlocBuilder<VacancyApplicationsBloc, VacancyApplicationsState>(
          buildWhen: (prev, curr) {
            final p = prev is VacancyApplicationsLoaded ? prev : null;
            final c = curr is VacancyApplicationsLoaded ? curr : null;
            return p?.hasMore != c?.hasMore ||
                p?.isLoadingMore != c?.isLoadingMore;
          },
          builder: (context, state) {
            final loaded = state is VacancyApplicationsLoaded ? state : null;

            return LoadMoreOnScroll(
              canLoadMore:
                  (loaded?.hasMore ?? false) &&
                  !(loaded?.isLoadingMore ?? false),
              onLoadMore: () => context.read<VacancyApplicationsBloc>().add(
                const LoadMoreVacancyApplicationsEvent(),
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
                        myTitle: localization.myApplications,
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
                      hintText: localization.searchApplicationsHint,
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
                            localization.applicationsTitle,
                            style: AppTextStyles.source.semiBold(fontSize: 18),
                          ),
                          VacancyFilterButtonWg(
                            activeLabel: hasFilter
                                ? applicationStatusLabel(localization, _status)
                                : null,
                            onTap: _openFilter,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //! Requests
                  VacancyApplicationsWithBlocWg(
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
