import 'package:my_template/core/common/params/edu_params/params.dart';

/// Base type for the search-students bloc's events.
///
/// [SearchStudentsEvent] and [LoadMoreSearchStudentsEvent] are deliberately
/// *siblings*: bloc's `on<E>` also matches subtypes, so making load-more
/// extend the search event would make every load-more re-run the search.
abstract class SearchStudentsBaseEvent {
  const SearchStudentsBaseEvent();
}

/// Runs a fresh search, replacing any previous results.
class SearchStudentsEvent extends SearchStudentsBaseEvent {
  final SearchStudentsParams params;

  SearchStudentsEvent({required this.params});
}

/// Appends the next page of the query that is already loaded.
class LoadMoreSearchStudentsEvent extends SearchStudentsBaseEvent {
  const LoadMoreSearchStudentsEvent();
}
