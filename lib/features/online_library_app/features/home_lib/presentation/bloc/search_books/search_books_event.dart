import 'package:equatable/equatable.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';

/// Base type for the search bloc's events.
///
/// [SearchBooksEvent] and [LoadMoreSearchBooksEvent] are deliberately
/// *siblings* rather than parent/child: bloc's `on<E>` also matches
/// subtypes, so making load-more extend the search event would make every
/// load-more additionally re-run a full search.
abstract class SearchBooksBaseEvent extends Equatable {
  const SearchBooksBaseEvent();

  @override
  List<Object?> get props => [];
}

/// Runs a fresh search, replacing any previous results.
class SearchBooksEvent extends SearchBooksBaseEvent {
  final SearchBooksParams params;

  const SearchBooksEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Appends the next page of the query that is already loaded. Safe to fire
/// repeatedly — the bloc ignores it while a page is in flight or once the
/// last page has been reached.
class LoadMoreSearchBooksEvent extends SearchBooksBaseEvent {
  const LoadMoreSearchBooksEvent();
}
