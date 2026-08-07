import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';

class EditionArticlesState extends Equatable {
  const EditionArticlesState();

  @override
  List<Object?> get props => [];
}

class EditionArticlesInitial extends EditionArticlesState {}

class EditionArticlesLoading extends EditionArticlesState {}

class EditionArticlesLoaded extends EditionArticlesState {
  final List<EditionArticleEntity> items;

  const EditionArticlesLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class EditionArticlesError extends EditionArticlesState {}
