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
  final String? existingMainFileUrl;
  final int? existingMainFileSize;
  final String? existingAntiplagiatFileUrl;
  final int? existingAntiplagiatFileSize;

  /// Optimistic display while uploading / before detail refresh.
  final String? uploadedMainFileName;
  final int? uploadedMainFileSize;
  final String? uploadedAntiplagiatFileName;
  final int? uploadedAntiplagiatFileSize;

  final bool isEditMode;
  final bool isLoadingInitialData;
  final String? initialLoadError;

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
    this.existingMainFileUrl,
    this.existingMainFileSize,
    this.existingAntiplagiatFileUrl,
    this.existingAntiplagiatFileSize,
    this.uploadedMainFileName,
    this.uploadedMainFileSize,
    this.uploadedAntiplagiatFileName,
    this.uploadedAntiplagiatFileSize,
    this.isEditMode = false,
    this.isLoadingInitialData = false,
    this.initialLoadError,
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
    String? existingMainFileUrl,
    int? existingMainFileSize,
    String? existingAntiplagiatFileUrl,
    int? existingAntiplagiatFileSize,
    String? uploadedMainFileName,
    int? uploadedMainFileSize,
    String? uploadedAntiplagiatFileName,
    int? uploadedAntiplagiatFileSize,
    bool? isEditMode,
    bool? isLoadingInitialData,
    String? initialLoadError,
    List<ReviewAuthorParams>? localAuthors,
    List<ReviewAuthorEntity>? savedAuthors,
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
    bool clearInitialLoadError = false,
    bool clearExistingMainFile = false,
    bool clearExistingAntiplagiatFile = false,
    bool clearUploadedMainFile = false,
    bool clearUploadedAntiplagiatFile = false,
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
      existingMainFileUrl: clearExistingMainFile
          ? null
          : (existingMainFileUrl ?? this.existingMainFileUrl),
      existingMainFileSize: clearExistingMainFile
          ? null
          : (existingMainFileSize ?? this.existingMainFileSize),
      existingAntiplagiatFileUrl: clearExistingAntiplagiatFile
          ? null
          : (existingAntiplagiatFileUrl ?? this.existingAntiplagiatFileUrl),
      existingAntiplagiatFileSize: clearExistingAntiplagiatFile
          ? null
          : (existingAntiplagiatFileSize ?? this.existingAntiplagiatFileSize),
      uploadedMainFileName: clearUploadedMainFile
          ? null
          : (uploadedMainFileName ?? this.uploadedMainFileName),
      uploadedMainFileSize: clearUploadedMainFile
          ? null
          : (uploadedMainFileSize ?? this.uploadedMainFileSize),
      uploadedAntiplagiatFileName: clearUploadedAntiplagiatFile
          ? null
          : (uploadedAntiplagiatFileName ?? this.uploadedAntiplagiatFileName),
      uploadedAntiplagiatFileSize: clearUploadedAntiplagiatFile
          ? null
          : (uploadedAntiplagiatFileSize ?? this.uploadedAntiplagiatFileSize),
      isEditMode: isEditMode ?? this.isEditMode,
      isLoadingInitialData: isLoadingInitialData ?? this.isLoadingInitialData,
      initialLoadError: clearInitialLoadError
          ? null
          : (initialLoadError ?? this.initialLoadError),
      localAuthors: localAuthors ?? this.localAuthors,
      savedAuthors: savedAuthors ?? this.savedAuthors,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasMainFile =>
      (existingMainFileUrl != null && existingMainFileUrl!.isNotEmpty) ||
      (uploadedMainFileName != null && uploadedMainFileName!.isNotEmpty);

  bool get hasAntiplagiatFile =>
      (existingAntiplagiatFileUrl != null &&
          existingAntiplagiatFileUrl!.isNotEmpty) ||
      (uploadedAntiplagiatFileName != null &&
          uploadedAntiplagiatFileName!.isNotEmpty);

  String? get displayMainFileName {
    if (existingMainFileUrl != null && existingMainFileUrl!.isNotEmpty) {
      return Uri.parse(existingMainFileUrl!).pathSegments.last;
    }
    return uploadedMainFileName;
  }

  String? get displayAntiplagiatFileName {
    if (existingAntiplagiatFileUrl != null &&
        existingAntiplagiatFileUrl!.isNotEmpty) {
      return Uri.parse(existingAntiplagiatFileUrl!).pathSegments.last;
    }
    return uploadedAntiplagiatFileName;
  }

  int? get displayMainFileSize => existingMainFileSize ?? uploadedMainFileSize;

  int? get displayAntiplagiatFileSize =>
      existingAntiplagiatFileSize ?? uploadedAntiplagiatFileSize;

  /// Value for preview widgets that expect a URL-like string.
  String? get previewMainFile => hasMainFile
      ? (existingMainFileUrl ?? 'local://$uploadedMainFileName')
      : null;

  String? get previewAntiplagiatFile => hasAntiplagiatFile
      ? (existingAntiplagiatFileUrl ?? 'local://$uploadedAntiplagiatFileName')
      : null;

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
    existingMainFileUrl,
    existingMainFileSize,
    existingAntiplagiatFileUrl,
    existingAntiplagiatFileSize,
    uploadedMainFileName,
    uploadedMainFileSize,
    uploadedAntiplagiatFileName,
    uploadedAntiplagiatFileSize,
    isEditMode,
    isLoadingInitialData,
    initialLoadError,
    localAuthors,
    savedAuthors,
    isSaving,
    isSuccess,
    errorMessage,
  ];
}
