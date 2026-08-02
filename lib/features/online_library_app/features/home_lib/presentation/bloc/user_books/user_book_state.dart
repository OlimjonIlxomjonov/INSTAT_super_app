import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class UserBookState extends Equatable {
  const UserBookState();

  @override
  List<Object?> get props => [];
}

class UserBookInitial extends UserBookState {}

class UserBookLoading extends UserBookState {}

class UserBookLoaded extends UserBookState {
  /// Accumulated across every page loaded so far.
  final BookListResponse response;

  /// True while an additional page is in flight; loaded books stay visible.
  final bool isLoadingMore;

  const UserBookLoaded({required this.response, this.isLoadingMore = false});

  /// A null `meta` means the endpoint returned no pagination block, which is
  /// treated as "nothing more to load".
  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  UserBookLoaded copyWith({BookListResponse? response, bool? isLoadingMore}) {
    return UserBookLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore];
}

class UserBookError extends UserBookState {}
