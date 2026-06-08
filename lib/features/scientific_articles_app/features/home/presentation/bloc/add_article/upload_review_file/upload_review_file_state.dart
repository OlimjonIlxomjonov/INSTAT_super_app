import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';

class UploadReviewFileState extends Equatable {
  const UploadReviewFileState();

  @override
  List<Object?> get props => [];
}

class UploadReviewFileInitial extends UploadReviewFileState {}

class UploadReviewFileLoading extends UploadReviewFileState {
  final String type;

  const UploadReviewFileLoading({required this.type});

  @override
  List<Object?> get props => [type];
}

class UploadReviewFileLoaded extends UploadReviewFileState {
  final ReviewFilesEntity entity;

  const UploadReviewFileLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class UploadReviewFileError extends UploadReviewFileState {
  final String type;

  const UploadReviewFileError({required this.type});

  @override
  List<Object?> get props => [type];
}
