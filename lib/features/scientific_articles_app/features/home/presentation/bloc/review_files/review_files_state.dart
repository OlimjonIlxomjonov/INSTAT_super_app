import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';

class ReviewFilesState extends Equatable {
  const ReviewFilesState();

  @override
  List<Object?> get props => [];
}

class ReviewFilesInitial extends ReviewFilesState {}

class ReviewFilesLoading extends ReviewFilesState {}

class ReviewFilesLoaded extends ReviewFilesState {
  final List<ReviewFilesEntity> entity;

  const ReviewFilesLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class ReviewFilesError extends ReviewFilesState {}
