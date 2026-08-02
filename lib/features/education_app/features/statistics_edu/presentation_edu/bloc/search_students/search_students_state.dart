import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';

class SearchStudentsState {
  const SearchStudentsState();
}

class SearchStudentsInitial extends SearchStudentsState {}

class SearchStudentsLoading extends SearchStudentsState {}

class SearchStudentsLoaded extends SearchStudentsState {
  /// Accumulated across every page loaded for [query].
  final LeaderBoardResponse response;

  /// The query these results belong to, so a page that arrives after the
  /// user typed something else can be discarded instead of appended.
  final String query;

  /// True while an additional page is in flight; results stay visible.
  final bool isLoadingMore;

  SearchStudentsLoaded({
    required this.response,
    required this.query,
    this.isLoadingMore = false,
  });

  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  SearchStudentsLoaded copyWith({
    LeaderBoardResponse? response,
    String? query,
    bool? isLoadingMore,
  }) {
    return SearchStudentsLoaded(
      response: response ?? this.response,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchStudentsError extends SearchStudentsState {
  final bool isConnectionError;
  final String message;

  SearchStudentsError({
    required this.isConnectionError,
    required this.message,
  });
}
