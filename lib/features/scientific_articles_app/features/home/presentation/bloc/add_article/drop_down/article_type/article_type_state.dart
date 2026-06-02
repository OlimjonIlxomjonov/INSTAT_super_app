import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class ArticleTypeState extends Equatable {
  const ArticleTypeState();

  @override
  List<Object?> get props => [];
}

class ArticleTypeInitial extends ArticleTypeState {}

class ArticleTypeLoading extends ArticleTypeState {}

class ArticleTypeLoaded extends ArticleTypeState {
  final List<DropDownEntity> entity;

  const ArticleTypeLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class ArticleTypeError extends ArticleTypeState {}
