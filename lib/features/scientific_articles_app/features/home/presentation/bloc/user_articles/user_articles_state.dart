import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';

class UserArticlesState extends Equatable {
  const UserArticlesState();

  @override
  List<Object?> get props => [];
}

class UserArticlesInitial extends UserArticlesState {}

class UserArticlesLoading extends UserArticlesState {}

class UserArticlesLoaded extends UserArticlesState {
  final UserArticlesResponse response;
  final String status;
  final String search;
  final bool isLoadingMore;
  final bool hasMore;

  const UserArticlesLoaded({
    required this.response,
    required this.status,
    required this.search,
    this.isLoadingMore = false,
    required this.hasMore,
  });

  bool get canLoadMore => hasMore && !isLoadingMore;

  UserArticlesLoaded copyWith({
    UserArticlesResponse? response,
    String? status,
    String? search,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return UserArticlesLoaded(
      response: response ?? this.response,
      status: status ?? this.status,
      search: search ?? this.search,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [response, status, search, isLoadingMore, hasMore];
}

class UserArticlesError extends UserArticlesState {}
