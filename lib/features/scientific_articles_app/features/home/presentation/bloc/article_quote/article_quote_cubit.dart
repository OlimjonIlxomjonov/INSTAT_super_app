import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_quote/article_quote_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_related/article_related_use_cases.dart';

class ArticleQuoteCubit extends Cubit<bool> {
  final ArticleQuoteUseCase useCase;

  ArticleQuoteCubit({required this.useCase}) : super(false);

  Future<void> create(
    int reviewId, {
    required void Function(ArticleQuoteEntity quote) onSuccess,
    required void Function(String? message) onError,
  }) async {
    if (state) return;
    emit(true);
    try {
      final quote = await useCase(reviewId);
      if (isClosed) return;
      emit(false);
      onSuccess(quote);
    } catch (e) {
      if (isClosed) return;
      emit(false);
      onError(apiErrorMessage(e));
    }
  }
}
