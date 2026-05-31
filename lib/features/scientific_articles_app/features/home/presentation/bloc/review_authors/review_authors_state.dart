import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';

class ReviewAuthorsState extends Equatable {
  const ReviewAuthorsState();

  @override
  List<Object?> get props => [];
}

class ReviewAuthorsInitial extends ReviewAuthorsState {}

class ReviewAuthorsLoading extends ReviewAuthorsState {}

class ReviewAuthorsLoaded extends ReviewAuthorsState {
  final List<ReviewAuthorEntity> response;

  const ReviewAuthorsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ReviewAuthorsError extends ReviewAuthorsState {}
