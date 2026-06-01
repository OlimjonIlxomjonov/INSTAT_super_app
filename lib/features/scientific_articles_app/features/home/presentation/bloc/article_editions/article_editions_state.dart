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

  const ArticleEditionsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ArticleEditionsError extends ArticleEditionsState {}
