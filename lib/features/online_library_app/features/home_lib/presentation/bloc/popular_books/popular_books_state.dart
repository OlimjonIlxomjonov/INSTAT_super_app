import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class PopularBooksState {}

class PopularBooksInitial extends PopularBooksState {}

class PopularBooksLoading extends PopularBooksState {}

class PopularBooksLoaded extends PopularBooksState {
  /// Accumulated across every page loaded so far, so existing consumers
  /// that read `state.response.data` keep working unchanged.
  final BookListResponse response;

  /// True while an additional page is in flight; loaded books stay visible.
  final bool isLoadingMore;

  PopularBooksLoaded({required this.response, this.isLoadingMore = false});

  /// A null `meta` means the endpoint isn't paginated, which is treated as
  /// "nothing more to load" rather than paging blindly.
  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  PopularBooksLoaded copyWith({
    BookListResponse? response,
    bool? isLoadingMore,
  }) {
    return PopularBooksLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PopularBooksError extends PopularBooksState {
  final bool isConnectionError;
  final String message;

  PopularBooksError({required this.isConnectionError, required this.message});
}
