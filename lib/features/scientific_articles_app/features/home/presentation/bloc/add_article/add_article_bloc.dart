import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
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

  AddArticleBloc({
    required this.createReviewUseCase,
    required this.updateReviewUseCase,
    required this.createReviewAuthorUseCase,
    required this.updateReviewAuthorUseCase,
    required this.getReviewAuthorsUseCase,
    required this.reviewDetailUseCase,
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

    on<SaveArticleDraftEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));
      try {
        int finalReviewId = state.reviewId ?? 0;

        if (finalReviewId == 0) {
          final reviewParams = ReviewParams(
            title: state.title,
            articleType: state.articleType ?? 1,
            journalSection: state.journalSection ?? 1,
            annotationUz: state.annotationUz,
            annotationRu: state.annotationRu,
            annotationEn: state.annotationEn,
            udkCode: state.udkCode,
            status: event.status,
            language: state.language,
            keywords: state.keywords,
          );
          final response = await createReviewUseCase(reviewParams);
          finalReviewId = response.id;
        } else {
          final reviewParams = ReviewParams(
            id: finalReviewId,
            title: state.title,
            articleType: state.articleType ?? 1,
            journalSection: state.journalSection ?? 1,
            annotationUz: state.annotationUz,
            annotationRu: state.annotationRu,
            annotationEn: state.annotationEn,
            udkCode: state.udkCode,
            status: event.status,
            language: state.language,
            keywords: state.keywords,
          );
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
