import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/articles_stats/articles_stats_entity.dart';

class ArticleStatsState extends Equatable {
  const ArticleStatsState();

  @override
  List<Object?> get props => [];
}

class ArticleStatsInitial extends ArticleStatsState {}

class ArticleStatsLoading extends ArticleStatsState {}

class ArticleStatsLoaded extends ArticleStatsState {
  final ArticlesStatsEntity entity;

  const ArticleStatsLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class ArticleStatsError extends ArticleStatsState {}
