import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

/// Runs a fresh search, replacing any previous results.
class SearchCoursesEvent extends CoursesEvent {
  final SearchCoursesParams params;

  SearchCoursesEvent({required this.params});
}

/// Appends the next page of the query that is already loaded.
///
/// A *sibling* of [SearchCoursesEvent] rather than a subclass — bloc's
/// `on<E>` also matches subtypes, so extending it would make every
/// load-more additionally re-run a full search.
class LoadMoreSearchCoursesEvent extends CoursesEvent {
  const LoadMoreSearchCoursesEvent();
}
