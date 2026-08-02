import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class UserCoursesState {
  UserCoursesState();
}

class UserCoursesInitial extends UserCoursesState {}

class UserCoursesLoading extends UserCoursesState {}

class UserCoursesLoaded extends UserCoursesState {
  /// Accumulated across every page loaded so far.
  ///
  /// [CourseListResponse.data] holds *all* items fetched to date, so
  /// existing consumers that read `state.response.data` keep working
  /// unchanged (including the ones that deliberately clamp to the first 2).
  /// `meta` comes from the newest page, so `meta.total` stays the real total.
  final CourseListResponse response;

  /// Which filter ("in_progress" / "finished") this data belongs to.
  ///
  /// The same bloc type serves several filters, so paging has to request the
  /// *same* filter it is extending — otherwise page 2 of "finished" could be
  /// appended onto page 1 of "in_progress".
  final String filterState;

  /// True while an additional page is in flight; loaded items stay visible.
  final bool isLoadingMore;

  UserCoursesLoaded({
    required this.response,
    required this.filterState,
    this.isLoadingMore = false,
  });

  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  UserCoursesLoaded copyWith({
    CourseListResponse? response,
    String? filterState,
    bool? isLoadingMore,
  }) {
    return UserCoursesLoaded(
      response: response ?? this.response,
      filterState: filterState ?? this.filterState,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class UserCoursesError extends UserCoursesState {
  final bool isConnectionError;
  final String message;

  UserCoursesError({required this.isConnectionError, required this.message});
}
