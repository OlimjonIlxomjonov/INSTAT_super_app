import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';

class ReviewProcessState extends Equatable {
  const ReviewProcessState();

  @override
  List<Object?> get props => [];
}

class ReviewProcessInitial extends ReviewProcessState {}

class ReviewProcessLoading extends ReviewProcessState {}

class ReviewProcessLoaded extends ReviewProcessState {
  final List<ArticleProcessEntity> listEntity;

  const ReviewProcessLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class ReviewProcessError extends ReviewProcessState {}
