import 'package:equatable/equatable.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';

import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';

class AddArticleState extends Equatable {
  final int? reviewId;
  final String title;
  final int? articleType;
  final String language;
  final int? journalSection;
  final String? annotationUz;
  final String? annotationRu;
  final String? annotationEn;
  final String udkCode;
  final List<String> keywords;

  // Local authors that haven't been saved on the server yet (used when reviewId is null)
  final List<ReviewAuthorParams> localAuthors;

  // Authors fetched/saved from the server
  final List<ReviewAuthorEntity> savedAuthors;

  // Loading/Success/Error states for saving
  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;

  const AddArticleState({
    this.reviewId,
    this.title = '',
    this.articleType,
    this.language = 'uz',
    this.journalSection,
    this.annotationUz,
    this.annotationRu,
    this.annotationEn,
    this.udkCode = '',
    this.keywords = const [],
    this.localAuthors = const [],
    this.savedAuthors = const [],
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  AddArticleState copyWith({
    int? reviewId,
    String? title,
    int? articleType,
    String? language,
    int? journalSection,
    String? annotationUz,
    String? annotationRu,
    String? annotationEn,
    String? udkCode,
    List<String>? keywords,
    List<ReviewAuthorParams>? localAuthors,
    List<ReviewAuthorEntity>? savedAuthors,
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return AddArticleState(
      reviewId: reviewId ?? this.reviewId,
      title: title ?? this.title,
      articleType: articleType ?? this.articleType,
      language: language ?? this.language,
      journalSection: journalSection ?? this.journalSection,
      annotationUz: annotationUz ?? this.annotationUz,
      annotationRu: annotationRu ?? this.annotationRu,
      annotationEn: annotationEn ?? this.annotationEn,
      udkCode: udkCode ?? this.udkCode,
      keywords: keywords ?? this.keywords,
      localAuthors: localAuthors ?? this.localAuthors,
      savedAuthors: savedAuthors ?? this.savedAuthors,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        reviewId,
        title,
        articleType,
        language,
        journalSection,
        annotationUz,
        annotationRu,
        annotationEn,
        udkCode,
        keywords,
        localAuthors,
        savedAuthors,
        isSaving,
        isSuccess,
        errorMessage,
      ];
}
