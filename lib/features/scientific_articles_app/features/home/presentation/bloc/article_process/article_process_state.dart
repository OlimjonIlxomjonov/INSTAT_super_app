import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';

class ArticleProcessState extends Equatable {
  const ArticleProcessState();

  @override
  List<Object?> get props => [];
}

class ArticleProcessInitial extends ArticleProcessState {}

class ArticleProcessLoading extends ArticleProcessState {}

class ArticleProcessLoaded extends ArticleProcessState {
  final List<ArticleProcessEntity> entity;

  const ArticleProcessLoaded({required this.entity});

  @override
  List<Object> get props => [entity];
}

class ArticleProcessError extends ArticleProcessState {}
