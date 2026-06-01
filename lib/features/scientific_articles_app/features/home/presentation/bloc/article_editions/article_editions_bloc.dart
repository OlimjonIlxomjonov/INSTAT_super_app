import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_editions/article_editions_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticleEditionsBloc
    extends Bloc<ArticlesHomeEvent, ArticleEditionsState> {
  final ArticleEditionsUseCase useCase;

  ArticleEditionsBloc({required this.useCase})
    : super(ArticleEditionsInitial()) {
    on<ArticlesEditionsEvent>((event, emit) async {
      emit(ArticleEditionsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(ArticleEditionsLoaded(response: response));
      } catch (e) {
        emit(ArticleEditionsError());
      }
    });
  }
}
