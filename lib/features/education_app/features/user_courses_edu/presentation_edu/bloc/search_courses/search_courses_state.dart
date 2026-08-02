import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class SearchCoursesState {
  const SearchCoursesState();
}

class SearchCoursesInitial extends SearchCoursesState {}

class SearchCoursesLoading extends SearchCoursesState {}

class SearchCoursesLoaded extends SearchCoursesState {
  /// Accumulated across every page loaded for [query].
  final CourseListResponse response;

  /// The query these results belong to.
  ///
  /// Typing is debounced, so a page-2 request can still be in flight when a
  /// new query starts. Recording the query lets a stale page be discarded
  /// rather than appended onto results for a different search.
  final String query;

  /// True while an additional page is in flight; results stay visible.
  final bool isLoadingMore;

  SearchCoursesLoaded({
    required this.response,
    required this.query,
    this.isLoadingMore = false,
  });

  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  SearchCoursesLoaded copyWith({
    CourseListResponse? response,
    String? query,
    bool? isLoadingMore,
  }) {
    return SearchCoursesLoaded(
      response: response ?? this.response,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchCoursesError extends SearchCoursesState {
  final bool isConnectionError;
  final String message;

  SearchCoursesError({required this.isConnectionError, required this.message});
}
