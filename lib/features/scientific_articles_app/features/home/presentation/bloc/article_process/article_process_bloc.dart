import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_process/article_process_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticleProcessBloc extends Bloc<ArticlesHomeEvent, ArticleProcessState> {
  final ArticleProcessUseCase useCase;

  ArticleProcessBloc({required this.useCase}) : super(ArticleProcessInitial()) {
    on<ArticleProcessEvent>((event, emit) async {
      emit(ArticleProcessLoading());
      try {
        final entity = await useCase.call(
          params: ArticleProcessParams(articleId: event.articleId),
        );
        emit(ArticleProcessLoaded(entity: entity));
      } catch (e) {
        emit(ArticleProcessError());
      }
    });
  }
}
