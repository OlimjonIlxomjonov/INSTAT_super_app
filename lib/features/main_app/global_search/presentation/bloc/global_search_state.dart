import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';

enum SearchModule { courses, books, magazines, reports, vacancies }

class SearchSection<T> extends Equatable {
  final bool isLoading;
  final String? error;
  final List<T> items;
  final int total;

  const SearchSection({
    this.isLoading = false,
    this.error,
    this.items = const [],
    this.total = 0,
  });

  const SearchSection.loading() : this(isLoading: true);

  bool get isEmpty => !isLoading && error == null && items.isEmpty;

  @override
  List<Object?> get props => [isLoading, error, items, total];
}

class GlobalSearchState extends Equatable {
  final String query;
  final SearchSection<CourseEntity> courses;
  final SearchSection<BookEntity> books;
  final SearchSection<ArticleEditionsEntity> magazines;
  final SearchSection<ReportsEntity> reports;
  final SearchSection<VacancyEntity> vacancies;
  final List<String> recent;
  final SearchModule? selectedModule;

  const GlobalSearchState({
    this.query = '',
    this.courses = const SearchSection(),
    this.books = const SearchSection(),
    this.magazines = const SearchSection(),
    this.reports = const SearchSection(),
    this.vacancies = const SearchSection(),
    this.recent = const [],
    this.selectedModule,
  });

  bool get hasQuery => query.trim().isNotEmpty;

  bool get isEverythingEmpty =>
      courses.isEmpty &&
      books.isEmpty &&
      magazines.isEmpty &&
      reports.isEmpty &&
      vacancies.isEmpty;

  /// Natijasi bor modullar — chiplar shulardan tuziladi.
  List<SearchModule> get filledModules => [
    if (courses.items.isNotEmpty) SearchModule.courses,
    if (books.items.isNotEmpty) SearchModule.books,
    if (magazines.items.isNotEmpty) SearchModule.magazines,
    if (reports.items.isNotEmpty) SearchModule.reports,
    if (vacancies.items.isNotEmpty) SearchModule.vacancies,
  ];

  int totalFor(SearchModule module) => switch (module) {
    SearchModule.courses => courses.total,
    SearchModule.books => books.total,
    SearchModule.magazines => magazines.total,
    SearchModule.reports => reports.total,
    SearchModule.vacancies => vacancies.total,
  };

  bool shows(SearchModule module) =>
      selectedModule == null || selectedModule == module;

  GlobalSearchState copyWith({
    String? query,
    SearchSection<CourseEntity>? courses,
    SearchSection<BookEntity>? books,
    SearchSection<ArticleEditionsEntity>? magazines,
    SearchSection<ReportsEntity>? reports,
    SearchSection<VacancyEntity>? vacancies,
    List<String>? recent,
    SearchModule? selectedModule,
    bool clearModule = false,
  }) {
    return GlobalSearchState(
      query: query ?? this.query,
      courses: courses ?? this.courses,
      books: books ?? this.books,
      magazines: magazines ?? this.magazines,
      reports: reports ?? this.reports,
      vacancies: vacancies ?? this.vacancies,
      recent: recent ?? this.recent,
      selectedModule: clearModule
          ? null
          : (selectedModule ?? this.selectedModule),
    );
  }

  @override
  List<Object?> get props => [
    query,
    courses,
    books,
    magazines,
    reports,
    vacancies,
    recent,
    selectedModule,
  ];
}
