import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/services/search/recent_searches_service.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/search_courses/search_courses_use_case.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_state.dart';
import 'package:my_template/features/mikro_data/domain/usecase/reports/reports_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_search_books_usecase.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_editions/article_editions_use_case.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';

const int kGlobalSearchPreviewLimit = 3;

class GlobalSearchCubit extends Cubit<GlobalSearchState> {
  final SearchCoursesUseCase searchCoursesUseCase;
  final GetSearchBooksUseCase searchBooksUseCase;
  final ArticleEditionsUseCase articleEditionsUseCase;
  final ReportsUseCase reportsUseCase;
  final GetVacanciesUseCase vacanciesUseCase;

  /// Kechikkan javob yangisining ustiga yozib ketmasligi uchun.
  int _requestId = 0;

  GlobalSearchCubit({
    required this.searchCoursesUseCase,
    required this.searchBooksUseCase,
    required this.articleEditionsUseCase,
    required this.reportsUseCase,
    required this.vacanciesUseCase,
  }) : super(GlobalSearchState(recent: RecentSearchesService.load()));

  void search(String query) {
    final trimmed = query.trim();
    final id = ++_requestId;

    if (trimmed.isEmpty) {
      emit(GlobalSearchState(recent: state.recent));
      return;
    }

    emit(
      state.copyWith(
        query: trimmed,
        clearModule: true,
        courses: const SearchSection.loading(),
        books: const SearchSection.loading(),
        magazines: const SearchSection.loading(),
        reports: const SearchSection.loading(),
        vacancies: const SearchSection.loading(),
      ),
    );

    //! Kurslar
    _run(id, () async {
      final response = await searchCoursesUseCase(
        params: SearchCoursesParams(search: trimmed),
      );
      return (response.data, response.meta.total);
    }, (section) => emit(state.copyWith(courses: section)));

    //! Kitoblar
    _run(id, () async {
      final response = await searchBooksUseCase(
        SearchBooksParams(search: trimmed),
      );
      return (response.data, response.meta?.total ?? response.data.length);
    }, (section) => emit(state.copyWith(books: section)));

    //! Jurnallar
    _run(id, () async {
      final response = await articleEditionsUseCase(
        params: ArticleEditionsParams(status: 'published', search: trimmed),
      );
      return (response.data, response.meta.total);
    }, (section) => emit(state.copyWith(magazines: section)));

    //! Ma'lumot to'plamlari
    _run(id, () async {
      final response = await reportsUseCase(search: trimmed);
      return (response.data, response.meta.total);
    }, (section) => emit(state.copyWith(reports: section)));

    //! Vakansiyalar
    _run(id, () async {
      final response = await vacanciesUseCase(
        params: VacancyListParams(search: trimmed),
      );
      return (response.data, response.meta.total);
    }, (section) => emit(state.copyWith(vacancies: section)));
  }

  Future<void> _run<T>(
    int id,
    Future<(List<T>, int)> Function() fetch,
    void Function(SearchSection<T> section) onDone,
  ) async {
    try {
      final (items, total) = await fetch();
      if (isClosed || id != _requestId) return;
      onDone(SearchSection<T>(items: items, total: total));
    } catch (e) {
      if (isClosed || id != _requestId) return;
      onDone(SearchSection<T>(error: apiErrorMessage(e) ?? ''));
    }
  }

  void selectModule(SearchModule? module) {
    emit(state.copyWith(selectedModule: module, clearModule: module == null));
  }

  Future<void> rememberQuery(String query) async {
    final recent = await RecentSearchesService.add(query);
    if (!isClosed) emit(state.copyWith(recent: recent));
  }

  Future<void> removeRecent(String query) async {
    final recent = await RecentSearchesService.remove(query);
    if (!isClosed) emit(state.copyWith(recent: recent));
  }

  Future<void> clearRecent() async {
    await RecentSearchesService.clear();
    if (!isClosed) emit(state.copyWith(recent: const []));
  }
}
