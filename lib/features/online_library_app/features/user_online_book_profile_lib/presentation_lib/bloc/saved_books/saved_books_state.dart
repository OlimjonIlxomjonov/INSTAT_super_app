import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class SavedBooksState extends Equatable {
  const SavedBooksState();

  @override
  List<Object?> get props => [];
}

class SavedBooksInitial extends SavedBooksState {}

class SavedBooksLoading extends SavedBooksState {}

class SavedBooksLoaded extends SavedBooksState {
  /// Accumulated across every page loaded so far.
  final BookListResponse response;

  /// True while an additional page is in flight; loaded books stay visible.
  final bool isLoadingMore;

  const SavedBooksLoaded({required this.response, this.isLoadingMore = false});

  /// A null `meta` means the endpoint returned no pagination block, which is
  /// treated as "nothing more to load".
  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  SavedBooksLoaded copyWith({BookListResponse? response, bool? isLoadingMore}) {
    return SavedBooksLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore];
}

class SavedBooksError extends SavedBooksState {}
