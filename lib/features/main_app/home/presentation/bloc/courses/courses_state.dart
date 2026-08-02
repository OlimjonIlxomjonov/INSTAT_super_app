import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class CoursesState {
  CoursesState();
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  /// The accumulated result across every page loaded so far.
  ///
  /// [CourseListResponse.data] deliberately holds *all* items fetched to
  /// date, not just the newest page, so existing consumers that read
  /// `state.response.data` keep working unchanged and simply see more items
  /// appear as pages load. `meta` always comes from the most recent page, so
  /// `meta.total` stays the true total and `meta.currentPage` reflects how
  /// far we have paged.
  final CourseListResponse response;

  /// True while an additional page is in flight. Already-loaded items stay
  /// visible throughout, so the list never flashes empty.
  final bool isLoadingMore;

  CoursesLoaded({required this.response, this.isLoadingMore = false});

  /// Whether the backend reports at least one more page after the last one
  /// that was loaded.
  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  CoursesLoaded copyWith({
    CourseListResponse? response,
    bool? isLoadingMore,
  }) {
    return CoursesLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CoursesError extends CoursesState {
  final bool isConnectionError;
  final String message;

  CoursesError({required this.isConnectionError, required this.message});
}
