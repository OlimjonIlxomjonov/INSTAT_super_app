class PopularBooksEvent {}

/// Loads (or reloads) the first page, replacing whatever was there.
class FetchPopularBooksEvent extends PopularBooksEvent {}

/// Appends the next page. Safe to fire repeatedly — the bloc ignores it
/// while a page is in flight or once the last page has been reached.
class LoadMorePopularBooksEvent extends PopularBooksEvent {}
