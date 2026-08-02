import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class SearchBooksState extends Equatable {
  const SearchBooksState();

  @override
  List<Object?> get props => [];
}

class SearchBooksInitial extends SearchBooksState {}

class SearchBooksLoading extends SearchBooksState {}

class SearchBooksLoaded extends SearchBooksState {
  /// Accumulated across every page loaded for [query].
  final BookListResponse response;

  /// The query these results belong to.
  ///
  /// Typing is debounced, so a page-2 request can still be in flight when a
  /// new query starts. Recording the query lets a stale page be discarded
  /// instead of being appended onto results for a different search.
  final String query;

  /// True while an additional page is in flight; loaded results stay visible.
  final bool isLoadingMore;

  const SearchBooksLoaded({
    required this.response,
    required this.query,
    this.isLoadingMore = false,
  });

  /// A null `meta` means the endpoint returned no pagination block, which is
  /// treated as "nothing more to load".
  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  SearchBooksLoaded copyWith({
    BookListResponse? response,
    String? query,
    bool? isLoadingMore,
  }) {
    return SearchBooksLoaded(
      response: response ?? this.response,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [response, query, isLoadingMore];
}

class SearchBooksError extends SearchBooksState {
  final String message;
  final bool isConnectionError;

  const SearchBooksError({
    required this.message,
    this.isConnectionError = false,
  });

  @override
  List<Object?> get props => [message, isConnectionError];
}
