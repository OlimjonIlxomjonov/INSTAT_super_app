import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';

class ArticleEditionsState extends Equatable {
  const ArticleEditionsState();

  @override
  List<Object?> get props => [];
}

class ArticleEditionsInitial extends ArticleEditionsState {}

class ArticleEditionsLoading extends ArticleEditionsState {}

class ArticleEditionsLoaded extends ArticleEditionsState {
  final ArticleEditionsResponse response;
  final bool isRefreshing;

  const ArticleEditionsLoaded({
    required this.response,
    this.isRefreshing = false,
  });

  ArticleEditionsLoaded copyWith({
    ArticleEditionsResponse? response,
    bool? isRefreshing,
  }) {
    return ArticleEditionsLoaded(
      response: response ?? this.response,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [response, isRefreshing];
}

class ArticleEditionsError extends ArticleEditionsState {}
