/// Base type for the saved-books bloc's events.
///
/// [SavedBooksEvent] and [LoadMoreSavedBooksEvent] are deliberately
/// *siblings* rather than parent/child: bloc's `on<E>` also matches
/// subtypes, so making load-more extend the fetch event would make every
/// load-more additionally re-run a full reload back to page 1.
abstract class SavedBooksBaseEvent {
  const SavedBooksBaseEvent();
}

/// Loads (or reloads) the first page, replacing whatever was there.
class SavedBooksEvent extends SavedBooksBaseEvent {
  const SavedBooksEvent();
}

/// Appends the next page. Safe to fire repeatedly — the bloc ignores it
/// while a page is in flight or once the last page has been reached.
class LoadMoreSavedBooksEvent extends SavedBooksBaseEvent {
  const LoadMoreSavedBooksEvent();
}
