import 'package:equatable/equatable.dart';

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
class UserBooksEvent extends UserBooksBaseEvent {
  const UserBooksEvent();
}

/// Appends the next page. Safe to fire repeatedly — the bloc ignores it while
/// a page is in flight or once the last page has been reached.
class LoadMoreUserBooksEvent extends UserBooksBaseEvent {
  const LoadMoreUserBooksEvent();
}
