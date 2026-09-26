import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/search_courses_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_cubit.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_state.dart';
import 'package:my_template/features/main_app/global_search/presentation/widgets/search_group_wg.dart';
import 'package:my_template/features/main_app/global_search/presentation/widgets/search_module_chips_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/detailed_reports_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/reports_page.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/search_books_page.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/presentation/screens/magazine_detail_page.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/presentation/screens/magazine_search_page.dart';
import 'package:my_template/features/vacancy_app/features/presentation/screens/vacancy/vacancies_page.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_detailed_wg.dart';

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GlobalSearchCubit>(),
      child: const _GlobalSearchView(),
    );
  }
}

class _GlobalSearchView extends StatelessWidget {
  const _GlobalSearchView();

  void _openSheet(BuildContext context, Widget child) {
    final cubit = context.read<GlobalSearchCubit>();
    cubit.rememberQuery(cubit.state.query);
    openMiniAppSheetFamily(context, child: child, showHandler: false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cubit = context.read<GlobalSearchCubit>();
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: l.searchTitle),
            ),
          ),

          //! Qidiruv maydoni
          SliverAppBar(
            primary: false,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            titleSpacing: 20,
            title: AppSearchFieldWg(
              autofocus: true,
              hintText: l.globalSearchHint,
              onChanged: cubit.search,
            ),
          ),

          BlocBuilder<GlobalSearchCubit, GlobalSearchState>(
            builder: (context, state) {
              if (!state.hasQuery) {
                return _RecentSearches(recent: state.recent);
              }

              final isDone =
                  !state.courses.isLoading &&
                  !state.books.isLoading &&
                  !state.magazines.isLoading &&
                  !state.reports.isLoading &&
                  !state.vacancies.isLoading;

              if (isDone && state.isEverythingEmpty) {
                return SliverToBoxAdapter(
                  child: AppEmptyState(
                    title: l.globalSearchNothingFound(state.query),
                    subtitle: '',
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildListDelegate([
                  //! Modul filtri
                  SearchModuleChipsWg(state: state),

                  //! Kurslar
                  if (state.shows(SearchModule.courses))
                    SearchGroupWg(
                      title: l.searchGroupCourses,
                      icon: FlutterRemix.book_open_line,
                      section: state.courses,
                      isExpanded: state.selectedModule == SearchModule.courses,
                      titleBuilder: (item) => item.displayName(localeCode),
                      subtitleBuilder: (_) => '',
                      onItemTap: (item) => _openSheet(
                        context,
                        CourseCategoryBuilder(
                          categoryId: item.category,
                          loadingBuilder: (_) => const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          ),
                          builder: (_, categoryName) => DetailedCourseInfoPage(
                            data: item,
                            courseCategory: categoryName,
                            total: state.courses.total,
                          ),
                        ),
                      ),
                      onSeeAll: () => _openSheet(
                        context,
                        SearchCoursesPage(initialQuery: state.query),
                      ),
                      onRetry: () => cubit.search(state.query),
                    ),

                  //! Kitoblar
                  if (state.shows(SearchModule.books))
                    SearchGroupWg(
                      title: l.searchGroupBooks,
                      icon: FlutterRemix.book_mark_line,
                      section: state.books,
                      isExpanded: state.selectedModule == SearchModule.books,
                      titleBuilder: (item) => item.name,
                      subtitleBuilder: (item) => item.author.name,
                      onItemTap: (item) => _openSheet(
                        context,
                        DetailedOnlineBookComponent(data: item),
                      ),
                      onSeeAll: () => _openSheet(
                        context,
                        SearchBooksPage(initialQuery: state.query),
                      ),
                      onRetry: () => cubit.search(state.query),
                    ),

                  //! Jurnallar
                  if (state.shows(SearchModule.magazines))
                    SearchGroupWg(
                      title: l.searchGroupMagazines,
                      icon: FlutterRemix.newspaper_line,
                      section: state.magazines,
                      isExpanded:
                          state.selectedModule == SearchModule.magazines,
                      titleBuilder: (item) => item.title ?? '',
                      subtitleBuilder: (item) =>
                          [item.year, item.number].whereType<int>().join(' · '),
                      onItemTap: (item) => _openSheet(
                        context,
                        MagazineDetailPage(edition: item),
                      ),
                      onSeeAll: () => _openSheet(
                        context,
                        MagazineSearchPage(initialQuery: state.query),
                      ),
                      onRetry: () => cubit.search(state.query),
                    ),

                  //! Ma'lumot to'plamlari
                  if (state.shows(SearchModule.reports))
                    SearchGroupWg(
                      title: l.searchGroupReports,
                      icon: FlutterRemix.pie_chart_line,
                      section: state.reports,
                      isExpanded: state.selectedModule == SearchModule.reports,
                      titleBuilder: (item) => item.name,
                      subtitleBuilder: (item) => item.uniqueId,
                      onItemTap: (item) =>
                          _openSheet(context, DetailedReportsPage(item: item)),
                      onSeeAll: () => _openSheet(
                        context,
                        ReportsPage(initialQuery: state.query),
                      ),
                      onRetry: () => cubit.search(state.query),
                    ),

                  //! Vakansiyalar
                  if (state.shows(SearchModule.vacancies))
                    SearchGroupWg(
                      title: l.searchGroupVacancies,
                      icon: FlutterRemix.briefcase_line,
                      section: state.vacancies,
                      isExpanded:
                          state.selectedModule == SearchModule.vacancies,
                      titleBuilder: (item) => item.title,
                      subtitleBuilder: (item) => item.subtitle,
                      onItemTap: (item) =>
                          _openSheet(context, VacancyDetailedWg(item: item)),
                      onSeeAll: () => _openSheet(
                        context,
                        VacanciesPage(initialQuery: state.query),
                      ),
                      onRetry: () => cubit.search(state.query),
                    ),

                  const SizedBox(height: 40),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  final List<String> recent;

  const _RecentSearches({required this.recent});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cubit = context.read<GlobalSearchCubit>();

    if (recent.isEmpty) {
      return SliverToBoxAdapter(
        child: AppEmptyState(
          title: l.globalSearchIdleTitle,
          subtitle: l.globalSearchIdleSubtitle,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.recentSearches,
                  style: AppTextStyles.source.semiBold(fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: cubit.clearRecent,
                child: Text(
                  l.clearAllLabel,
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final query in recent)
          ListTile(
            leading: Icon(
              FlutterRemix.time_line,
              color: AppColors.greyScale.grey600,
            ),
            title: Text(
              query,
              style: AppTextStyles.source.regular(fontSize: 14),
            ),
            trailing: IconButton(
              onPressed: () => cubit.removeRecent(query),
              icon: Icon(Icons.close, color: AppColors.greyScale.grey400),
            ),
            onTap: () => cubit.search(query),
          ),
      ]),
    );
  }
}
