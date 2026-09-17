import 'package:equatable/equatable.dart';

/// `type` query value for each tab of the user-books page.
enum UserBookType {
  all(null),
  online('online'),
  offline('offline');

  final String? query;

  const UserBookType(this.query);
}

/// Base type for the user-books bloc's events.
///
/// [UserBooksEvent] and [LoadMoreUserBooksEvent] are deliberately *siblings*:
/// bloc's `on<E>` also matches subtypes, so making load-more extend the fetch
/// event would make every load-more additionally reload page 1.
abstract class UserBooksBaseEvent extends Equatable {
  const UserBooksBaseEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) the first page, replacing whatever was there.
/// The filters are remembered by the bloc and reused by load-more.
class UserBooksEvent extends UserBooksBaseEvent {
  final UserBookType type;
  final String search;

  const UserBooksEvent({this.type = UserBookType.all, this.search = ''});

  @override
  List<Object?> get props => [type, search];
}

/// Reloads the first page with the filters the bloc already holds — for
/// callers outside the page (e.g. the reader closing) that must not reset
/// the user's tab / search.
class RefreshUserBooksEvent extends UserBooksBaseEvent {
  const RefreshUserBooksEvent();
}

/// Appends the next page. Safe to fire repeatedly — the bloc ignores it while
/// a page is in flight or once the last page has been reached.
class LoadMoreUserBooksEvent extends UserBooksBaseEvent {
  const LoadMoreUserBooksEvent();
}
