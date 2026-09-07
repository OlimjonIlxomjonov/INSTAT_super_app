class PopularBooksEvent {}

/// Loads (or reloads) the first page, replacing whatever was there.
/// [categoryId] `null` bo'lsa barcha kategoriyalar.
class FetchPopularBooksEvent extends PopularBooksEvent {
  final int? categoryId;
  final String search;

  FetchPopularBooksEvent({this.categoryId, this.search = ''});
}

/// Appends the next page. Safe to fire repeatedly — the bloc ignores it
/// while a page is in flight or once the last page has been reached.
class LoadMorePopularBooksEvent extends PopularBooksEvent {}
