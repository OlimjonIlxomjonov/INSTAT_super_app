import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/create_article_order_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/create_review_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/update_review_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/create_review_author_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/review_authors_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/update_review_author_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_detail/review_detail_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';

class AddArticleBloc extends Bloc<ArticlesHomeEvent, AddArticleState> {
  final CreateReviewUseCase createReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final CreateReviewAuthorUseCase createReviewAuthorUseCase;
  final UpdateReviewAuthorUseCase updateReviewAuthorUseCase;
  final ReviewAuthorsUseCase getReviewAuthorsUseCase;
  final ReviewDetailUseCase reviewDetailUseCase;
  final CreateArticleOrderUseCase createArticleOrderUseCase;

  AddArticleBloc({
    required this.createReviewUseCase,
    required this.updateReviewUseCase,
    required this.createReviewAuthorUseCase,
    required this.updateReviewAuthorUseCase,
    required this.getReviewAuthorsUseCase,
    required this.reviewDetailUseCase,
    required this.createArticleOrderUseCase,
  }) : super(const AddArticleState()) {
    on<ResetAddArticleEvent>((event, emit) {
      emit(const AddArticleState());
    });

    on<LoadArticleForEditEvent>((event, emit) async {
      emit(
        state.copyWith(
          isLoadingInitialData: true,
          initialLoadError: null,
          clearInitialLoadError: true,
        ),
      );
      try {
        final detail = await reviewDetailUseCase(event.reviewId);

        if (detail.status != 'draft') {
          emit(
            state.copyWith(
              isLoadingInitialData: false,
              initialLoadError:
                  'Faqat qoralama (draft) holatidagi maqolalar tahrirlanadi',
            ),
          );
          return;
        }

        final authors = await getReviewAuthorsUseCase(event.reviewId);

        emit(
          AddArticleState(
            reviewId: detail.id,
            title: detail.title,
            articleType: detail.articleType,
            journalSection: detail.journalSection,
            annotationUz: detail.annotationUz,
            annotationRu: detail.annotationRu,
            annotationEn: detail.annotationEn,
            udkCode: detail.udkCode,
            language: detail.language,
            keywords: _parseKeywords(detail.keywords),
            existingMainFileUrl: detail.mainFile,
            existingMainFileSize: detail.mainFileSize,
            existingAntiplagiatFileUrl: detail.antiplagiatFile,
            existingAntiplagiatFileSize: detail.antiplagiatFileSize,
            savedAuthors: authors,
            isEditMode: true,
            isLoadingInitialData: false,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoadingInitialData: false,
            initialLoadError: 'Maqola ma\'lumotlarini yuklashda xatolik',
          ),
        );
      }
    });

    on<UpdateAddArticleFieldEvent>((event, emit) {
      emit(state.copyWith(
        title: event.title,
        articleType: event.articleType,
        language: event.language,
        journalSection: event.journalSection,
        annotationUz: event.annotationUz,
        annotationRu: event.annotationRu,
        annotationEn: event.annotationEn,
        udkCode: event.udkCode,
        keywords: event.keywords,
      ));
    });

    on<AddLocalAuthorEvent>((event, emit) {
      final updatedLocal = List<ReviewAuthorParams>.from(state.localAuthors)
        ..add(event.author);
      emit(state.copyWith(localAuthors: updatedLocal));
    });

    on<RemoveLocalAuthorEvent>((event, emit) {
      final updatedLocal = List<ReviewAuthorParams>.from(state.localAuthors)
        ..removeAt(event.index);
      emit(state.copyWith(localAuthors: updatedLocal));
    });

    on<CreateReviewAuthorEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));
      try {
        await createReviewAuthorUseCase(event.author);

        final saved = await getReviewAuthorsUseCase(event.author.review);

        emit(state.copyWith(
          savedAuthors: saved,
          isSaving: false,
          isSuccess: true,
        ));
        event.onSuccess?.call();
      } catch (e) {
        emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
        event.onError?.call(e.toString());
      }
    });

    on<UpdateReviewAuthorEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));
      try {
        await updateReviewAuthorUseCase(event.author);

        final saved = await getReviewAuthorsUseCase(event.author.review);

        emit(state.copyWith(
          savedAuthors: saved,
          isSaving: false,
          isSuccess: true,
        ));
        event.onSuccess?.call();
      } catch (e) {
        emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
        event.onError?.call(e.toString());
      }
    });

    on<UpdateArticleUploadedFileEvent>((event, emit) {
      emit(
        state.copyWith(
          uploadedMainFileName: event.mainFileName,
          uploadedMainFileSize: event.mainFileSize,
          uploadedAntiplagiatFileName: event.antiplagiatFileName,
          uploadedAntiplagiatFileSize: event.antiplagiatFileSize,
        ),
      );
    });

    on<RefreshArticleFilesEvent>((event, emit) async {
      final reviewId = state.reviewId;
      if (reviewId == null || reviewId == 0) return;

      try {
        final detail = await reviewDetailUseCase(reviewId);
        emit(
          state.copyWith(
            existingMainFileUrl: detail.mainFile,
            existingMainFileSize: detail.mainFileSize,
            existingAntiplagiatFileUrl: detail.antiplagiatFile,
            existingAntiplagiatFileSize: detail.antiplagiatFileSize,
            clearUploadedMainFile: detail.mainFile != null &&
                detail.mainFile!.isNotEmpty,
            clearUploadedAntiplagiatFile: detail.antiplagiatFile != null &&
                detail.antiplagiatFile!.isNotEmpty,
          ),
        );
      } catch (_) {}
    });

    on<SaveArticleDraftEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));
      try {
        final finalReviewId = await _saveReviewFields(state);
        final saved = await getReviewAuthorsUseCase(finalReviewId);

        emit(state.copyWith(
          reviewId: finalReviewId,
          localAuthors: const [],
          savedAuthors: saved,
          isSaving: false,
          isSuccess: true,
          isEditMode: state.isEditMode || finalReviewId > 0,
        ));
        event.onSuccess?.call();
      } catch (e) {
        emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
        event.onError?.call(e.toString());
      }
    });

    on<SubmitArticleForReviewEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));
      try {
        final finalReviewId = await _saveReviewFields(state);

        // This is the actual "submit for review" action — it's what
        // transitions status away from draft and creates the process log
        // entry server-side, matching exactly what the website does.
        // Sending `status: 'in_review'` directly on the plain update call
        // above would just silently set the field with no side effects.
        await createArticleOrderUseCase(
          CreateArticleOrderParams(
            reviewId: finalReviewId,
            paymentMethod: event.paymentMethod,
          ),
        );

        final saved = await getReviewAuthorsUseCase(finalReviewId);

        emit(state.copyWith(
          reviewId: finalReviewId,
          localAuthors: const [],
          savedAuthors: saved,
          isSaving: false,
          isSuccess: true,
          isEditMode: state.isEditMode || finalReviewId > 0,
        ));
        event.onSuccess?.call();
      } catch (e) {
        emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
        event.onError?.call(e.toString());
      }
    });
  }

  /// Creates the review (as draft) if it doesn't exist yet, or updates it
  /// otherwise, then saves any not-yet-persisted local authors. Status is
  /// always sent as 'draft' here — the client never sets any other status
  /// directly; submitting for review happens through create-order instead.
  Future<int> _saveReviewFields(AddArticleState state) async {
    int finalReviewId = state.reviewId ?? 0;

    final reviewParams = ReviewParams(
      id: finalReviewId == 0 ? null : finalReviewId,
      title: state.title,
      articleType: state.articleType ?? 1,
      journalSection: state.journalSection ?? 1,
      annotationUz: state.annotationUz,
      annotationRu: state.annotationRu,
      annotationEn: state.annotationEn,
      udkCode: state.udkCode,
      status: 'draft',
      language: state.language,
      keywords: state.keywords,
    );

    if (finalReviewId == 0) {
      final response = await createReviewUseCase(reviewParams);
      finalReviewId = response.id;
    } else {
      await updateReviewUseCase(reviewParams);
    }

    for (var author in state.localAuthors) {
      final authorParams = ReviewAuthorParams(
        firstName: author.firstName,
        lastName: author.lastName,
        review: finalReviewId,
        academicDegree: author.academicDegree,
        address: author.address,
        organization: author.organization,
        email: author.email,
        phoneNumber: author.phoneNumber,
        orcidCode: author.orcidCode,
      );
      await createReviewAuthorUseCase(authorParams);
    }

    return finalReviewId;
  }

  static List<String> _parseKeywords(String raw) {
    if (raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
